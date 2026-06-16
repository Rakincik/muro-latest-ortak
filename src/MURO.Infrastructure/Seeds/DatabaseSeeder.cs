using Microsoft.EntityFrameworkCore;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Seeds;

public static class DatabaseSeeder
{
    public static async Task SeedAsync(MuroDbContext db)
    {
        // ── Tenant ────────────────────────────────────────────────────────────
        var tenantId = Guid.Parse("11111111-1111-1111-1111-111111111111");
        var tenant = await db.Tenants.IgnoreQueryFilters().FirstOrDefaultAsync(t => t.Id == tenantId);
        if (tenant == null)
        {
            tenant = new Tenant
            {
                Id           = tenantId,
                Name         = "Render",
                Code         = "render",
                PrimaryColor = "#6366f1",
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Tenants.Add(tenant);
            await db.SaveChangesAsync();
        }

        // ── Admin user ────────────────────────────────────────────────────────
        var adminId = Guid.Parse("22222222-2222-2222-2222-222222222222");
        var admin = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Id == adminId);
        if (admin == null)
        {
            admin = new User
            {
                Id           = adminId,
                FirstName    = "Render",
                LastName     = "Admin",
                Email        = "render@muro.com",
                PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456"),
                Role         = UserRole.Admin,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(admin);

            db.TenantMemberships.Add(new TenantMembership
            {
                Id        = Guid.NewGuid(),
                UserId    = admin.Id,
                TenantId  = tenant.Id,
                Role      = UserRole.Admin,
                Status    = "active",
                JoinedAt  = DateTime.UtcNow,
            });
        }
        else
        {
            // Force-reset admin password on every dev startup
            admin.PasswordHash = BCrypt.Net.BCrypt.HashPassword("123456");
            admin.IsActive     = true;
            db.Users.Update(admin);
        }

        // ── Student user ──────────────────────────────────────────────────────
        var studentId = Guid.Parse("33333333-3333-3333-3333-333333333333");
        var student = await db.Users.IgnoreQueryFilters().FirstOrDefaultAsync(u => u.Id == studentId);
        if (student == null)
        {
            student = new User
            {
                Id           = studentId,
                FirstName    = "Demo",
                LastName     = "Öğrenci",
                Email        = "ogrenci@demo.com",
                PasswordHash = "123456",
                Role         = UserRole.Student,
                StudentType  = StudentType.Active,
                IsActive     = true,
                CreatedAt    = DateTime.UtcNow,
            };
            db.Users.Add(student);

            db.TenantMemberships.Add(new TenantMembership
            {
                Id        = Guid.NewGuid(),
                UserId    = student.Id,
                TenantId  = tenant.Id,
                Role      = UserRole.Student,
                Status    = "active",
                JoinedAt  = DateTime.UtcNow,
            });
        }
        else
        {
            // Force-reset student password on every dev startup
            student.PasswordHash = "123456";
            student.IsActive     = true;
            db.Users.Update(student);
        }

        await db.SaveChangesAsync();
    }
}
