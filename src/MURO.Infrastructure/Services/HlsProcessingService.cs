using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;
using System.Diagnostics;

namespace MURO.Infrastructure.Services;

/// <summary>
/// FFmpeg kullanarak MP4 → 480p + 720p HLS dönüşümü yapar.
/// Hem BBB kayıtları hem dışarıdan yüklenen videolar bu servisi kullanır.
/// </summary>
public interface IHlsProcessingService
{
    Task<HlsProcessResult> ProcessAsync(Guid assetId, string sourceMp4Path, string outputBaseDir, CancellationToken ct = default);
}

public record HlsProcessResult(
    string MasterPlaylistPath,   // /hls/{assetId}/master.m3u8
    string ThumbnailPath,        // /hls/{assetId}/thumbnail.jpg
    bool Success,
    int? DurationSeconds = null,
    string? ErrorMessage = null
);

public class HlsProcessingService : IHlsProcessingService
{
    private readonly ILogger<HlsProcessingService> _logger;
    private readonly string _ffmpegPath;

    public HlsProcessingService(IConfiguration config, ILogger<HlsProcessingService> logger)
    {
        _logger = logger;
        _ffmpegPath = config["Ffmpeg:Path"] ?? "ffmpeg"; // PATH'te varsa sadece "ffmpeg"
    }

    public async Task<HlsProcessResult> ProcessAsync(
        Guid assetId, string sourceMp4Path, string outputBaseDir, CancellationToken ct = default)
    {
        var assetDir = Path.Combine(outputBaseDir, assetId.ToString());
        Directory.CreateDirectory(Path.Combine(assetDir, "480p"));
        Directory.CreateDirectory(Path.Combine(assetDir, "720p"));

        var masterPath    = Path.Combine(assetDir, "master.m3u8");
        var thumbPath     = Path.Combine(assetDir, "thumbnail.jpg");
        var playlist480   = Path.Combine(assetDir, "480p", "index.m3u8");
        var playlist720   = Path.Combine(assetDir, "720p", "index.m3u8");
        var segments480   = Path.Combine(assetDir, "480p", "seg%03d.ts");
        var segments720   = Path.Combine(assetDir, "720p", "seg%03d.ts");

        // ── 1. Thumbnail (30. saniyeden) ──────────────────────────────────────
        _logger.LogInformation("Thumbnail üretiliyor → {AssetId}", assetId);
        var thumbResult = await RunFfmpegAsync(
            $"-y -ss 30 -i \"{sourceMp4Path}\" -vframes 1 -q:v 2 \"{thumbPath}\"",
            ct);

        if (!thumbResult && !File.Exists(thumbPath))
        {
            // 30. saniye yok ise ilk kareden al
            await RunFfmpegAsync(
                $"-y -i \"{sourceMp4Path}\" -vframes 1 -q:v 2 \"{thumbPath}\"",
                ct);
        }

        // ── 1.5. Thumbnail Sprites (VTT) ──────────────────────────────────────
        var duration = await GetVideoDurationAsync(sourceMp4Path, ct);
        if (duration > 0)
        {
            _logger.LogInformation("Thumbnail VTT/Sprite üretiliyor → {AssetId}", assetId);
            var spritePattern = Path.Combine(assetDir, "sprite-%03d.jpg");
            var spriteVtt = Path.Combine(assetDir, "thumbnails.vtt");

            var spriteResult = await RunFfmpegAsync(
                $"-y -i \"{sourceMp4Path}\" -vf \"fps=1/10,scale=160:90,tile=10x10\" \"{spritePattern}\"",
                ct);

            if (spriteResult)
            {
                await GenerateThumbnailsVttAsync(spriteVtt, duration);
            }
        }

        // ── 2. 480p HLS ───────────────────────────────────────────────────────
        _logger.LogInformation("480p HLS işleniyor → {AssetId}", assetId);
        var ok480 = await RunFfmpegAsync(
            $"-y -i \"{sourceMp4Path}\" " +
            $"-vf scale=854:480 -c:v libx264 -preset fast -crf 28 -c:a aac -b:a 128k " +
            $"-hls_time 10 -hls_list_size 0 -hls_segment_filename \"{segments480}\" " +
            $"-f hls \"{playlist480}\"",
            ct);

        // ── 3. 720p HLS ───────────────────────────────────────────────────────
        _logger.LogInformation("720p HLS işleniyor → {AssetId}", assetId);
        var ok720 = await RunFfmpegAsync(
            $"-y -i \"{sourceMp4Path}\" " +
            $"-vf scale=1280:720 -c:v libx264 -preset fast -crf 26 -c:a aac -b:a 128k " +
            $"-hls_time 10 -hls_list_size 0 -hls_segment_filename \"{segments720}\" " +
            $"-f hls \"{playlist720}\"",
            ct);

        if (!ok480 && !ok720)
            return new HlsProcessResult("", "", false, null, "FFmpeg işlemi başarısız oldu.");

        // ── 4. Master Playlist (ABR) ──────────────────────────────────────────
        var master = new System.Text.StringBuilder();
        master.AppendLine("#EXTM3U");

        if (ok480)
        {
            master.AppendLine("#EXT-X-STREAM-INF:BANDWIDTH=1000000,RESOLUTION=854x480,NAME=\"480p\"");
            master.AppendLine("480p/index.m3u8");
        }
        if (ok720)
        {
            master.AppendLine("#EXT-X-STREAM-INF:BANDWIDTH=2500000,RESOLUTION=1280x720,NAME=\"720p\"");
            master.AppendLine("720p/index.m3u8");
        }
        await File.WriteAllTextAsync(masterPath, master.ToString(), ct);

        // Web-erişilebilir path'ler (wwwroot relative)
        var webMaster = $"/hls/{assetId}/master.m3u8";
        var webThumb  = File.Exists(thumbPath) ? $"/hls/{assetId}/thumbnail.jpg" : null;

        _logger.LogInformation("HLS dönüşümü tamamlandı ✓ AssetId: {AssetId}", assetId);

        return new HlsProcessResult(webMaster, webThumb ?? "", true, duration > 0 ? (int)duration : null);
    }

    private async Task<bool> RunFfmpegAsync(string arguments, CancellationToken ct)
    {
        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = _ffmpegPath,
                Arguments = arguments,
                RedirectStandardError = true,
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using var process = new Process { StartInfo = psi };
            process.Start();

            // FFmpeg progress loglarını arka planda oku (buffer dolmasın)
            var stderr = process.StandardError.ReadToEndAsync(ct);
            await process.WaitForExitAsync(ct);
            await stderr; // tamamlanmasını bekle

            return process.ExitCode == 0;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "FFmpeg çalıştırılırken hata: {Arguments}", arguments[..Math.Min(100, arguments.Length)]);
            return false;
        }
    }

    private async Task<double> GetVideoDurationAsync(string sourceMp4Path, CancellationToken ct)
    {
        try
        {
            // FFmpeg path üzerinden ffprobe path'ini güvenli şekilde bul
            var dir = Path.GetDirectoryName(_ffmpegPath);
            var ext = Path.GetExtension(_ffmpegPath);
            var ffprobeName = string.IsNullOrEmpty(ext) ? "ffprobe" : "ffprobe" + ext;
            var ffprobePath = string.IsNullOrEmpty(dir) ? ffprobeName : Path.Combine(dir, ffprobeName);

            var arguments = $"-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 \"{sourceMp4Path}\"";

            var psi = new ProcessStartInfo
            {
                FileName = ffprobePath,
                Arguments = arguments,
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using var process = new Process { StartInfo = psi };
            process.Start();

            var output = await process.StandardOutput.ReadToEndAsync(ct);
            await process.WaitForExitAsync(ct);

            if (double.TryParse(output.Trim(), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out double duration))
            {
                return duration;
            }
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "FFprobe ile süre alınamadı.");
        }
        return 0;
    }

    private async Task GenerateThumbnailsVttAsync(string vttFilePath, double durationSec)
    {
        var sb = new System.Text.StringBuilder();
        sb.AppendLine("WEBVTT");
        sb.AppendLine();

        int frameCount = (int)Math.Ceiling(durationSec / 10.0);
        int cols = 10;
        int rows = 10;
        int framesPerSprite = cols * rows;

        for (int i = 0; i < frameCount; i++)
        {
            double start = i * 10.0;
            double end = Math.Min((i + 1) * 10.0, durationSec);

            TimeSpan startTime = TimeSpan.FromSeconds(start);
            TimeSpan endTime = TimeSpan.FromSeconds(end);

            int spriteIndex = (i / framesPerSprite) + 1;
            int indexInSprite = i % framesPerSprite;
            int col = indexInSprite % cols;
            int row = indexInSprite / cols;

            int x = col * 160;
            int y = row * 90;

            sb.AppendLine($"{startTime:hh\\:mm\\:ss\\.fff} --> {endTime:hh\\:mm\\:ss\\.fff}");
            sb.AppendLine($"sprite-{spriteIndex:D3}.jpg#xywh={x},{y},160,90");
            sb.AppendLine();
        }

        await File.WriteAllTextAsync(vttFilePath, sb.ToString());
    }
}
