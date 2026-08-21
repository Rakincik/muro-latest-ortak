using Microsoft.EntityFrameworkCore;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Seeds;

public static class DatabaseSeeder
{
    public static async Task SeedAsync(MuroDbContext db, Microsoft.Extensions.Configuration.IConfiguration config)
    {
        // ── Auto Schema Update: Ensure FeaturesJson column exists ──────────────
        await db.Database.ExecuteSqlRawAsync("ALTER TABLE \"SystemSettings\" ADD COLUMN IF NOT EXISTS \"FeaturesJson\" text;");
        await db.Database.ExecuteSqlRawAsync("ALTER TABLE \"SystemSettings\" ADD COLUMN IF NOT EXISTS \"BbbUrl\" text;");
        await db.Database.ExecuteSqlRawAsync("ALTER TABLE \"SystemSettings\" ADD COLUMN IF NOT EXISTS \"BbbSecret\" text;");

        // ── Auto Schema Update: IntegrationSettings table ──────────────────────
        await db.Database.ExecuteSqlRawAsync(@"
            CREATE TABLE IF NOT EXISTS ""IntegrationSettings"" (
                ""Id"" uuid PRIMARY KEY,
                ""ProviderKey"" text NOT NULL,
                ""Category"" text NOT NULL,
                ""Title"" text NOT NULL,
                ""Description"" text,
                ""IsEnabled"" boolean NOT NULL DEFAULT false,
                ""ConfigJson"" text,
                ""LastTestedAt"" timestamp with time zone,
                ""TestStatus"" text,
                ""TestMessage"" text,
                ""UpdatedAt"" timestamp with time zone NOT NULL,
                ""UpdatedBy"" text
            );
        ");
        await db.Database.ExecuteSqlRawAsync("ALTER TABLE \"IntegrationSettings\" ADD COLUMN IF NOT EXISTS \"TriggerSettingsJson\" text;");

        // ── Seed Default Integration Cards if empty ───────────────────────────
        try
        {
            var hasTopluSms = await db.IntegrationSettings.AnyAsync(i => i.ProviderKey == "toplusms");
            if (!hasTopluSms)
            {
                db.IntegrationSettings.Add(new IntegrationSetting
                {
                    Id = Guid.NewGuid(),
                    ProviderKey = "toplusms",
                    Category = "SMS",
                    Title = "Toplu SMS (api.toplusms.app)",
                    Description = "VatanSMS yeni nesil REST API altyapısı (api.toplusms.app) ile OTP ve toplu SMS gönderim servisi.",
                    IsEnabled = false,
                    ConfigJson = "{\"api_key\":\"\",\"sender\":\"\",\"message_type\":\"normal\",\"message_content_type\":\"bilgi\",\"add_cancel_link\":false}",
                    UpdatedAt = DateTime.UtcNow
                });
                await db.SaveChangesAsync();
            }

            var hasVatanSms = await db.IntegrationSettings.AnyAsync(i => i.ProviderKey == "vatansms");
            if (!hasVatanSms)
            {
                db.IntegrationSettings.Add(new IntegrationSetting
                {
                    Id = Guid.NewGuid(),
                    ProviderKey = "vatansms",
                    Category = "SMS",
                    Title = "Vatan SMS (Eski API)",
                    Description = "Türkiye geneli güvenli OTP, bilgilendirme ve toplu SMS gönderim servisi (api.vatansms.net).",
                    IsEnabled = false,
                    ConfigJson = "{\"api_id\":\"\",\"api_key\":\"\",\"sender\":\"\",\"message_type\":\"normal\",\"message_content_type\":\"bilgi\"}",
                    UpdatedAt = DateTime.UtcNow
                });
                await db.SaveChangesAsync();
            }
        }
        catch { /* ignore */ }

        // ── Auto Sync BBB settings from environment to database ──────────────
        var bbbUrl = config["Bbb:Url"];
        var bbbSecret = config["Bbb:Secret"];
        if (!string.IsNullOrEmpty(bbbUrl) && !string.IsNullOrEmpty(bbbSecret))
        {
            var settings = await db.SystemSettings.FirstOrDefaultAsync();
            if (settings != null)
            {
                if (settings.BbbUrl != bbbUrl || settings.BbbSecret != bbbSecret)
                {
                    settings.BbbUrl = bbbUrl;
                    settings.BbbSecret = bbbSecret;
                    settings.UpdatedAt = DateTime.UtcNow;
                    db.SystemSettings.Update(settings);
                }
            }
            else
            {
                db.SystemSettings.Add(new SystemSetting
                {
                    Id = Guid.NewGuid(),
                    BbbUrl = bbbUrl,
                    BbbSecret = bbbSecret,
                    UpdatedAt = DateTime.UtcNow
                });
            }
        }

        // ── Demo student user ──────────────────────────────────────────────────
        var studentEmail = "ogrenci@demo.com";
        var student = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == studentEmail);
        if (student == null)
        {
            student = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Demo",
                LastName     = "Öğrenci",
                Email        = studentEmail,
                Username     = studentEmail,
                PasswordHash = "123456",
                Role         = UserRole.Student,
                StudentType  = StudentType.Active,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(student);
        }
        else
        {
            student.IsActive     = true;
            db.Users.Update(student);
        }

        // ── Rüstem SuperAdmin ────────────────────────────────────────────────
        var rustemEmail = "rustemakincik@on7yazilim.com";
        var rustem = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == rustemEmail);
        if (rustem == null)
        {
            rustem = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Rüstem",
                LastName     = "Akıncık",
                Email        = rustemEmail,
                Username     = rustemEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("R.Akincik.07.On7*"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(rustem);
        }
        else
        {
            rustem.IsActive     = true;
            rustem.Role         = UserRole.SuperAdmin;
            db.Users.Update(rustem);
        }

        // ── Osman SuperAdmin ────────────────────────────────────────────────
        var osmanEmail = "osmanbadilli@on7yazilim.com";
        var osman = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == osmanEmail || u.Email == "osmanbadilli");
        if (osman == null)
        {
            osman = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Osman",
                LastName     = "Badıllı",
                Email        = osmanEmail,
                Username     = osmanEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Badıllı.63.06"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(osman);
        }
        else
        {
            osman.IsActive     = true;
            osman.Role         = UserRole.SuperAdmin;
            db.Users.Update(osman);
        }

        // ── Volkan SuperAdmin ────────────────────────────────────────────────
        var volkanEmail = "volkancetin@on7yazilim.com";
        var volkan = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Email == volkanEmail || u.Email == "volkancetin");
        if (volkan == null)
        {
            volkan = new User
            {
                Id           = Guid.NewGuid(),
                FirstName    = "Volkan",
                LastName     = "Çetin",
                Email        = volkanEmail,
                Username     = volkanEmail,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("Volkan.,1906.,On7"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(volkan);
        }
        else
        {
            volkan.IsActive     = true;
            volkan.Role         = UserRole.SuperAdmin;
            db.Users.Update(volkan);
        }

        await db.SaveChangesAsync();
    }
}
