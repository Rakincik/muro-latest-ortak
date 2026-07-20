using Microsoft.EntityFrameworkCore;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Seeds;

public static class DatabaseSeeder
{
    public static async Task SeedAsync(MuroDbContext db)
    {


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
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(rustem);
        }
        else
        {
            rustem.PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456");
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
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("osman6363"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(osman);
        }
        else
        {
            osman.PasswordHash = BCrypt.Net.BCrypt.HashPassword("osman6363");
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
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("vc0606"),
                Role         = UserRole.SuperAdmin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(volkan);
        }
        else
        {
            volkan.PasswordHash = BCrypt.Net.BCrypt.HashPassword("vc0606");
            db.Users.Update(volkan);
        }

        await db.SaveChangesAsync();
    }
}
