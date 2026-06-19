using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class PreDropTenantCleanup : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            var sql = @"
            -- FK kısıtlamalarını geçici olarak devre dışı bırak (sadece bu session için)
            SET session_replication_role = 'replica';

            -- TenantId barındıran tüm tablolardan Monopol harici verileri sil
            DO $$ 
            DECLARE
                monopol_ids uuid[];
            BEGIN
                -- Monopol tenant id'lerini al
                SELECT array_agg(""Id"") INTO monopol_ids FROM ""Tenants"" WHERE ""Code"" ILIKE '%monopol%';

                IF monopol_ids IS NOT NULL THEN
                    DELETE FROM ""TenantMemberships"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Users"" WHERE ""Id"" NOT IN (SELECT ""UserId"" FROM ""TenantMemberships"");
                    
                    DELETE FROM ""Announcements"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Assignments"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""AssignmentSubmissions"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""AuditLogs"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""CalendarEvents"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Courses"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""CourseGroups"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""CourseMaterials"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""CourseMedias"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""CourseStudents"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""DeviceSessions"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Exams"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""ExamAssignments"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""ExamResults"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""ExamSubmissionQueues"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Faqs"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Groups"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""GroupMembers"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""MediaAssets"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""MediaFolders"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Notifications"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Packages"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""PackageGroups"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Plans"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Podcasts"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Questions"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""SecurityEvents"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Sessions"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""SessionAttendances"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""SessionRecordings"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""StudentExamDrafts"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""SupportMessages"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""SupportTickets"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""Transactions"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""UserPackages"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""VideoNotes"" WHERE ""TenantId"" != ALL(monopol_ids);
                    DELETE FROM ""VideoProgresses"" WHERE ""TenantId"" != ALL(monopol_ids);

                    -- Diğer tenantları sil
                    DELETE FROM ""Tenants"" WHERE ""Code"" NOT ILIKE '%monopol%';
                END IF;
            EXCEPTION WHEN undefined_table THEN
                -- Tablo yoksa atla
            WHEN undefined_column THEN
                -- Kolon yoksa atla
            END $$;

            -- FK kısıtlamalarını geri aç
            SET session_replication_role = 'origin';
            ";

            migrationBuilder.Sql(sql);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
