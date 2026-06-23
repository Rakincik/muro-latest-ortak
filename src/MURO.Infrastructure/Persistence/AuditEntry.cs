using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using MURO.Domain.Entities;

namespace MURO.Infrastructure.Persistence;

public class AuditEntry
{
    public EntityEntry Entry { get; }
    public Guid? UserId { get; set; }
    public string? UserName { get; set; }
    public string? IpAddress { get; set; }
    public string TableName { get; set; } = string.Empty;
    public Dictionary<string, object?> KeyValues { get; } = new();
    public Dictionary<string, object?> OldValues { get; } = new();
    public Dictionary<string, object?> NewValues { get; } = new();

    public AuditEntry(EntityEntry entry)
    {
        Entry = entry;
    }

    public AuditLog ToAuditLog()
    {
        var audit = new AuditLog
        {
            UserId = UserId,
            UserName = UserName,
            IpAddress = IpAddress,
            EntityType = TableName,
            CreatedAt = DateTime.UtcNow
        };

        // Action type
        if (Entry.State == EntityState.Added)
        {
            audit.Action = "Create";
        }
        else if (Entry.State == EntityState.Deleted)
        {
            audit.Action = "Delete";
        }
        else
        {
            audit.Action = "Update";
        }

        // Retrieve primary keys
        var idList = new List<string>();
        foreach (var key in KeyValues)
        {
            idList.Add($"{key.Value}");
        }
        audit.EntityId = string.Join(",", idList);

        // Retrieve display name of the modified object
        audit.EntityName = GetEntityDisplayName();

        // Build formatted changes log
        var detailsBuilder = new StringBuilder();
        if (Entry.State == EntityState.Added)
        {
            detailsBuilder.AppendLine("Yeni Kayıt Oluşturuldu:");
            foreach (var kvp in NewValues)
            {
                if (kvp.Key == "PasswordHash")
                {
                    detailsBuilder.AppendLine($"- {kvp.Key}: [Şifrelenmiş Değer]");
                }
                else if (kvp.Value != null && !string.IsNullOrWhiteSpace(kvp.Value.ToString()))
                {
                    detailsBuilder.AppendLine($"- {kvp.Key}: '{kvp.Value}'");
                }
            }
        }
        else if (Entry.State == EntityState.Deleted)
        {
            detailsBuilder.AppendLine("Kayıt Silindi:");
            foreach (var kvp in OldValues)
            {
                if (kvp.Key == "PasswordHash") continue;
                if (kvp.Value != null && !string.IsNullOrWhiteSpace(kvp.Value.ToString()))
                {
                    detailsBuilder.AppendLine($"- {kvp.Key}: '{kvp.Value}'");
                }
            }
        }
        else // Modified
        {
            detailsBuilder.AppendLine("Değiştirilen Alanlar:");
            bool hasChanges = false;
            foreach (var kvp in NewValues)
            {
                var propName = kvp.Key;
                OldValues.TryGetValue(propName, out var oldValue);
                var newValue = kvp.Value;

                // Ignore unmodified properties
                if (Equals(oldValue, newValue)) continue;

                hasChanges = true;
                if (propName == "PasswordHash")
                {
                    detailsBuilder.AppendLine($"- {propName}: [Şifre Değiştirildi]");
                }
                else
                {
                    detailsBuilder.AppendLine($"- {propName}: '{oldValue}' ➔ '{newValue}'");
                }
            }

            if (!hasChanges)
            {
                detailsBuilder.AppendLine("(Detaylı alan değişikliği tespit edilmedi)");
            }
        }

        audit.Details = detailsBuilder.ToString().TrimEnd();

        return audit;
    }

    private string? GetEntityDisplayName()
    {
        var entity = Entry.Entity;

        if (entity is User user)
        {
            return $"{user.FirstName} {user.LastName}".Trim();
        }

        var properties = entity.GetType().GetProperties();
        string? nameValue = null;
        string? titleValue = null;
        string? emailValue = null;

        foreach (var prop in properties)
        {
            if (prop.Name.Equals("Name", StringComparison.OrdinalIgnoreCase) || prop.Name.Equals("Ad", StringComparison.OrdinalIgnoreCase))
                nameValue = prop.GetValue(entity)?.ToString();
            else if (prop.Name.Equals("Title", StringComparison.OrdinalIgnoreCase) || prop.Name.Equals("Baslik", StringComparison.OrdinalIgnoreCase))
                titleValue = prop.GetValue(entity)?.ToString();
            else if (prop.Name.Equals("Email", StringComparison.OrdinalIgnoreCase) || prop.Name.Equals("Eposta", StringComparison.OrdinalIgnoreCase))
                emailValue = prop.GetValue(entity)?.ToString();
        }

        return nameValue ?? titleValue ?? emailValue ?? TableName;
    }
}
