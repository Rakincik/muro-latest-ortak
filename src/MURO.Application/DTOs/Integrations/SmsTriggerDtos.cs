using System;
using System.Collections.Generic;

namespace MURO.Application.DTOs.Integrations;

public class SmsTriggerSettingsDto
{
    // 1. Canlı Ders Hatırlatması (15 dk önce)
    public bool LiveLessonReminderEnabled { get; set; } = false;
    public string LiveLessonReminderTemplate { get; set; } = "Sayın {ad}, {kurs} canlı dersiniz 15 dk sonra başlıyor! Giriş linki: {giris_linki}";

    // 2. Canlı Ders Başladı (Hoca dersi başlattığı an)
    public bool LiveLessonStartedEnabled { get; set; } = false;
    public string LiveLessonStartedTemplate { get; set; } = "Sayın {ad}, {kurs} canlı dersi başladı! Canlı yayına katılmak için: {giris_linki}";

    // 3. Yeni Öğrenci Hoş Geldin & Giriş Bilgileri
    public bool WelcomeStudentEnabled { get; set; } = false;
    public string WelcomeStudentTemplate { get; set; } = "Merhaba {ad} {soyad}, {kurum_adi} kaydınız tamamlandı. Kullanıcı Adınız: {kullanici_adi}, Giriş Adresi: {giris_linki}";

    // 4. Ders Kaydı Hazır Bildirimi
    public bool RecordingReadyEnabled { get; set; } = false;
    public string RecordingReadyTemplate { get; set; } = "Sayın {ad}, {kurs} dersinin tekrar video kaydı sisteme yüklendi. Panelinizden izleyebilirsiniz.";

    // 5. Yeni Sınav / Deneme Bildirimi
    public bool NewExamEnabled { get; set; } = false;
    public string NewExamTemplate { get; set; } = "Sayın {ad}, yeni bir online deneme sınavı açıldı: {kurs}. Panelinizden katılabilirsiniz.";
}

public class BulkSmsCampaignRequest
{
    public string TargetType { get; set; } = "all"; // "course" | "group" | "package" | "all" | "custom"
    public List<Guid> TargetIds { get; set; } = new();
    public List<string>? CustomPhones { get; set; }
    public string MessageTemplate { get; set; } = string.Empty;
    public string? Sender { get; set; }
    public string? SendTime { get; set; } // Format: YYYY-MM-DD HH:mm:ss
}

public class SmsRecipientPreviewDto
{
    public Guid UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string TargetName { get; set; } = string.Empty;
    public string RenderedMessage { get; set; } = string.Empty;
    public bool IsValidPhone { get; set; }
}

public class BulkSmsPreviewResult
{
    public int TotalRecipients { get; set; }
    public int ValidPhonesCount { get; set; }
    public int InvalidPhonesCount { get; set; }
    public int EstimatedSmsUnits { get; set; }
    public List<SmsRecipientPreviewDto> Recipients { get; set; } = new();
}

public class BulkSmsExecutionResult
{
    public bool Success { get; set; }
    public int SentCount { get; set; }
    public int FailedCount { get; set; }
    public string? ReportId { get; set; }
    public string? Message { get; set; }
}
