using System;
using System.Collections.Generic;

namespace MURO.Application.DTOs.Integrations;

public class IntegrationItemDto
{
    public Guid Id { get; set; }
    public string ProviderKey { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsEnabled { get; set; }
    public string? ConfigJson { get; set; }
    public DateTime? LastTestedAt { get; set; }
    public string? TestStatus { get; set; }
    public string? TestMessage { get; set; }
    public DateTime UpdatedAt { get; set; }
    public string? UpdatedBy { get; set; }
    public bool IsConfigured { get; set; }
}

public class UpdateIntegrationRequest
{
    public bool IsEnabled { get; set; }
    public string? ConfigJson { get; set; }
}

public class TestIntegrationRequest
{
    public string? ConfigJson { get; set; }
    public string? TestPhone { get; set; }
}

public class VatanSmsConfigDto
{
    public string ApiId { get; set; } = string.Empty;
    public string ApiKey { get; set; } = string.Empty;
    public string Sender { get; set; } = string.Empty;
    public string MessageType { get; set; } = "normal"; // "normal" | "turkce"
    public string MessageContentType { get; set; } = "bilgi"; // "bilgi" | "ticari"
}

public class SendSingleSmsRequest
{
    public string Phone { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string? Sender { get; set; }
    public bool IsOtp { get; set; } = false;
}

public class SendBulkSmsRequest
{
    public List<string> Phones { get; set; } = new();
    public string Message { get; set; } = string.Empty;
    public string? Sender { get; set; }
    public string? SendTime { get; set; } // Y-m-d H:i:s
}

public class SmsSendResult
{
    public bool Success { get; set; }
    public string? ReportId { get; set; }
    public string? Status { get; set; }
    public string? Message { get; set; }
    public string? RawResponse { get; set; }
}

public class SmsAccountInfoResult
{
    public bool Success { get; set; }
    public string? CustomerName { get; set; }
    public string? Balance { get; set; }
    public List<string> Senders { get; set; } = new();
    public string? Message { get; set; }
}
