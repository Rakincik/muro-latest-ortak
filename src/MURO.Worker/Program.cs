using Microsoft.EntityFrameworkCore;
using Serilog;
using MURO.Application.Interfaces;
using MURO.Infrastructure.Persistence;
using MURO.Infrastructure.Services;
using MURO.Worker.Jobs;
using StackExchange.Redis;

var builder = Host.CreateApplicationBuilder(args);

// --- Serilog ---
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .CreateLogger();
builder.Logging.ClearProviders();
builder.Logging.AddSerilog();

// --- Database ---
builder.Services.AddDbContext<MuroDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// --- HTTP Client (BBB indirme için) ---
builder.Services.AddHttpClient("bbb-download", client =>
{
    client.Timeout = TimeSpan.FromMinutes(60); // Büyük dosyalar için uzun timeout
});
builder.Services.AddHttpClient<BbbService>();

// --- Services ---
var redisConnection = builder.Configuration.GetConnectionString("Redis") ?? "127.0.0.1:6379,abortConnect=false";
builder.Services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = redisConnection;
    options.InstanceName = "muro:";
});
builder.Services.AddSingleton<IConnectionMultiplexer>(ConnectionMultiplexer.Connect(redisConnection));
builder.Services.AddSingleton<ICacheService, RedisCacheService>();

builder.Services.AddScoped<IBbbService, BbbService>();
builder.Services.AddScoped<IHlsProcessingService, HlsProcessingService>();
builder.Services.AddSingleton<IJobQueue, RedisJobQueue>();
builder.Services.AddScoped<IEmailSender, SmtpEmailSender>();
builder.Services.AddScoped<ISmsSender, SmsPlaceholderSender>();

// --- Background Jobs ---
builder.Services.AddHostedService<UploadProcessingJob>();
builder.Services.AddHostedService<ExamScoringJob>();
builder.Services.AddHostedService<NotificationProcessingJob>();
builder.Services.AddHostedService<GroupExpirationJob>();
builder.Services.AddHostedService<AuditLogCleanupJob>();

var host = builder.Build();

Log.Information("MURO Worker başlatıldı.");
host.Run();
