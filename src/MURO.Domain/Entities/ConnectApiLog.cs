using System;

namespace MURO.Domain.Entities;

public class ConnectApiLog
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid TenantId { get; set; }
    public Guid? ApiKeyId { get; set; }
    public string Endpoint { get; set; } = string.Empty;
    public string HttpMethod { get; set; } = "POST";
    public string? IpAddress { get; set; }
    public int StatusCode { get; set; } = 200;
    public string? RequestBody { get; set; }
    public string? ResponseBody { get; set; }
    public long DurationMs { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
