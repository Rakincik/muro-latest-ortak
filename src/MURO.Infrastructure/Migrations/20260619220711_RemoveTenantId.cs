using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RemoveTenantId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Assignments_Tenants_TenantId",
                table: "Assignments");

            migrationBuilder.DropForeignKey(
                name: "FK_CalendarEvents_Tenants_TenantId",
                table: "CalendarEvents");

            migrationBuilder.DropForeignKey(
                name: "FK_CourseMaterials_Tenants_TenantId",
                table: "CourseMaterials");

            migrationBuilder.DropForeignKey(
                name: "FK_Courses_Tenants_TenantId",
                table: "Courses");

            migrationBuilder.DropForeignKey(
                name: "FK_DeviceSessions_Tenants_TenantId",
                table: "DeviceSessions");

            migrationBuilder.DropForeignKey(
                name: "FK_Exams_Tenants_TenantId",
                table: "Exams");

            migrationBuilder.DropForeignKey(
                name: "FK_Faqs_Tenants_TenantId",
                table: "Faqs");

            migrationBuilder.DropForeignKey(
                name: "FK_Groups_Tenants_TenantId",
                table: "Groups");

            migrationBuilder.DropForeignKey(
                name: "FK_MediaAssets_Tenants_TenantId",
                table: "MediaAssets");

            migrationBuilder.DropForeignKey(
                name: "FK_MediaFolders_Tenants_TenantId",
                table: "MediaFolders");

            migrationBuilder.DropForeignKey(
                name: "FK_Notifications_Tenants_TenantId",
                table: "Notifications");

            migrationBuilder.DropForeignKey(
                name: "FK_Packages_Tenants_TenantId",
                table: "Packages");

            migrationBuilder.DropForeignKey(
                name: "FK_Plans_Tenants_TenantId",
                table: "Plans");

            migrationBuilder.DropForeignKey(
                name: "FK_Podcasts_Tenants_TenantId",
                table: "Podcasts");

            migrationBuilder.DropForeignKey(
                name: "FK_Questions_Tenants_TenantId",
                table: "Questions");

            migrationBuilder.DropForeignKey(
                name: "FK_SupportTickets_Tenants_TenantId",
                table: "SupportTickets");

            migrationBuilder.DropForeignKey(
                name: "FK_Transactions_Tenants_TenantId",
                table: "Transactions");

            migrationBuilder.DropTable(
                name: "TenantMemberships");

            migrationBuilder.DropTable(
                name: "Tenants");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Transactions_TenantId_TransactionDate\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_SupportTickets_TenantId_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_StudentExamDrafts_ExamId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_StudentExamDrafts_TenantId_ExamId_UserId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_SessionAttendances_TenantId_UserId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Questions_TenantId_InstructorId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Questions_TenantId_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Podcasts_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Plans_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Packages_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Notifications_TenantId_CreatedAt\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Notifications_UserId_TenantId_IsRead\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_MediaFolders_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_MediaAssets_TenantId_CourseId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_MediaAssets_TenantId_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Groups_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Faqs_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_ExamSubmissionQueues_TenantId_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Exams_TenantId_CreatedAt\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Exams_TenantId_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_DeviceSessions_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Courses_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_CourseMaterials_TenantId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_CalendarEvents_TenantId_GroupId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_CalendarEvents_TenantId_StartDate_EndDate\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_AuditLogs_TenantId_Action\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_AuditLogs_TenantId_CreatedAt\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Assignments_TenantId_CourseId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Assignments_TenantId_DueDate\";");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Transactions");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "SupportTickets");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "StudentExamDrafts");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "SessionAttendances");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Questions");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Podcasts");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Plans");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Packages");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Notifications");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "MediaFolders");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "MediaAssets");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Groups");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Faqs");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "ExamSubmissionQueues");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Exams");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "DeviceSessions");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "CourseMaterials");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "CalendarEvents");

            migrationBuilder.DropColumn(
                name: "TenantId",
                table: "Assignments");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_TransactionDate",
                table: "Transactions",
                column: "TransactionDate");

            migrationBuilder.CreateIndex(
                name: "IX_SupportTickets_Status",
                table: "SupportTickets",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_StudentExamDrafts_ExamId_UserId",
                table: "StudentExamDrafts",
                columns: new[] { "ExamId", "UserId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Questions_Status",
                table: "Questions",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_CreatedAt",
                table: "Notifications",
                column: "CreatedAt");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId_IsRead",
                table: "Notifications",
                columns: new[] { "UserId", "IsRead" });

            migrationBuilder.CreateIndex(
                name: "IX_MediaAssets_Status",
                table: "MediaAssets",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_ExamSubmissionQueues_Status",
                table: "ExamSubmissionQueues",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_Exams_CreatedAt",
                table: "Exams",
                column: "CreatedAt");

            migrationBuilder.CreateIndex(
                name: "IX_Exams_Status",
                table: "Exams",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_CalendarEvents_StartDate_EndDate",
                table: "CalendarEvents",
                columns: new[] { "StartDate", "EndDate" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditLogs_Action",
                table: "AuditLogs",
                column: "Action");

            migrationBuilder.CreateIndex(
                name: "IX_AuditLogs_CreatedAt",
                table: "AuditLogs",
                column: "CreatedAt");

            migrationBuilder.CreateIndex(
                name: "IX_Assignments_DueDate",
                table: "Assignments",
                column: "DueDate");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Transactions_TransactionDate\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_SupportTickets_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_StudentExamDrafts_ExamId_UserId\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Questions_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Notifications_CreatedAt\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Notifications_UserId_IsRead\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_MediaAssets_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_ExamSubmissionQueues_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Exams_CreatedAt\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Exams_Status\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_CalendarEvents_StartDate_EndDate\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_AuditLogs_Action\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_AuditLogs_CreatedAt\";");

            migrationBuilder.Sql("DROP INDEX IF EXISTS \"IX_Assignments_DueDate\";");

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Transactions",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "SupportTickets",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "StudentExamDrafts",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "SessionAttendances",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Questions",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Podcasts",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Plans",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Packages",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Notifications",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "MediaFolders",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "MediaAssets",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Groups",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Faqs",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "ExamSubmissionQueues",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Exams",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "DeviceSessions",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Courses",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "CourseMaterials",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "CalendarEvents",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "TenantId",
                table: "Assignments",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateTable(
                name: "Tenants",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AccentColor = table.Column<string>(type: "text", nullable: true),
                    BbbSecret = table.Column<string>(type: "text", nullable: true),
                    BbbServerUrl = table.Column<string>(type: "text", nullable: true),
                    Code = table.Column<string>(type: "text", nullable: false),
                    ConnectionString = table.Column<string>(type: "text", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    Domain = table.Column<string>(type: "text", nullable: true),
                    FaviconUrl = table.Column<string>(type: "text", nullable: true),
                    Features = table.Column<string>(type: "text", nullable: true),
                    FooterText = table.Column<string>(type: "text", nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    JitsiServerUrl = table.Column<string>(type: "text", nullable: true),
                    LogoUrl = table.Column<string>(type: "text", nullable: true),
                    MaxBbbParticipants = table.Column<int>(type: "integer", nullable: true),
                    MaxCourses = table.Column<int>(type: "integer", nullable: true),
                    MaxDemoStudents = table.Column<int>(type: "integer", nullable: true),
                    MaxSessionsPerDay = table.Column<int>(type: "integer", nullable: true),
                    MaxStudents = table.Column<int>(type: "integer", nullable: true),
                    MeetingProviderType = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    PrimaryColor = table.Column<string>(type: "text", nullable: true),
                    ServerGroup = table.Column<string>(type: "text", nullable: true),
                    StorageLimitGb = table.Column<decimal>(type: "numeric", nullable: true),
                    Subdomain = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tenants", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "TenantMemberships",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TenantId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Role = table.Column<string>(type: "text", nullable: false),
                    Status = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TenantMemberships", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TenantMemberships_Tenants_TenantId",
                        column: x => x.TenantId,
                        principalTable: "Tenants",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TenantMemberships_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_TenantId_TransactionDate",
                table: "Transactions",
                columns: new[] { "TenantId", "TransactionDate" });

            migrationBuilder.CreateIndex(
                name: "IX_SupportTickets_TenantId_Status",
                table: "SupportTickets",
                columns: new[] { "TenantId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_StudentExamDrafts_ExamId",
                table: "StudentExamDrafts",
                column: "ExamId");

            migrationBuilder.CreateIndex(
                name: "IX_StudentExamDrafts_TenantId_ExamId_UserId",
                table: "StudentExamDrafts",
                columns: new[] { "TenantId", "ExamId", "UserId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_SessionAttendances_TenantId_UserId",
                table: "SessionAttendances",
                columns: new[] { "TenantId", "UserId" });

            migrationBuilder.CreateIndex(
                name: "IX_Questions_TenantId_InstructorId",
                table: "Questions",
                columns: new[] { "TenantId", "InstructorId" });

            migrationBuilder.CreateIndex(
                name: "IX_Questions_TenantId_Status",
                table: "Questions",
                columns: new[] { "TenantId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_Podcasts_TenantId",
                table: "Podcasts",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_Plans_TenantId",
                table: "Plans",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_Packages_TenantId",
                table: "Packages",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_TenantId_CreatedAt",
                table: "Notifications",
                columns: new[] { "TenantId", "CreatedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId_TenantId_IsRead",
                table: "Notifications",
                columns: new[] { "UserId", "TenantId", "IsRead" });

            migrationBuilder.CreateIndex(
                name: "IX_MediaFolders_TenantId",
                table: "MediaFolders",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_MediaAssets_TenantId_CourseId",
                table: "MediaAssets",
                columns: new[] { "TenantId", "CourseId" });

            migrationBuilder.CreateIndex(
                name: "IX_MediaAssets_TenantId_Status",
                table: "MediaAssets",
                columns: new[] { "TenantId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_Groups_TenantId",
                table: "Groups",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_Faqs_TenantId",
                table: "Faqs",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_ExamSubmissionQueues_TenantId_Status",
                table: "ExamSubmissionQueues",
                columns: new[] { "TenantId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_Exams_TenantId_CreatedAt",
                table: "Exams",
                columns: new[] { "TenantId", "CreatedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_Exams_TenantId_Status",
                table: "Exams",
                columns: new[] { "TenantId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_DeviceSessions_TenantId",
                table: "DeviceSessions",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_Courses_TenantId",
                table: "Courses",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_CourseMaterials_TenantId",
                table: "CourseMaterials",
                column: "TenantId");

            migrationBuilder.CreateIndex(
                name: "IX_CalendarEvents_TenantId_GroupId",
                table: "CalendarEvents",
                columns: new[] { "TenantId", "GroupId" });

            migrationBuilder.CreateIndex(
                name: "IX_CalendarEvents_TenantId_StartDate_EndDate",
                table: "CalendarEvents",
                columns: new[] { "TenantId", "StartDate", "EndDate" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditLogs_TenantId_Action",
                table: "AuditLogs",
                columns: new[] { "TenantId", "Action" });

            migrationBuilder.CreateIndex(
                name: "IX_AuditLogs_TenantId_CreatedAt",
                table: "AuditLogs",
                columns: new[] { "TenantId", "CreatedAt" });

            migrationBuilder.CreateIndex(
                name: "IX_Assignments_TenantId_CourseId",
                table: "Assignments",
                columns: new[] { "TenantId", "CourseId" });

            migrationBuilder.CreateIndex(
                name: "IX_Assignments_TenantId_DueDate",
                table: "Assignments",
                columns: new[] { "TenantId", "DueDate" });

            migrationBuilder.CreateIndex(
                name: "IX_TenantMemberships_TenantId_Status",
                table: "TenantMemberships",
                columns: new[] { "TenantId", "Status" });

            migrationBuilder.CreateIndex(
                name: "IX_TenantMemberships_UserId_TenantId",
                table: "TenantMemberships",
                columns: new[] { "UserId", "TenantId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Tenants_Code",
                table: "Tenants",
                column: "Code",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Assignments_Tenants_TenantId",
                table: "Assignments",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CalendarEvents_Tenants_TenantId",
                table: "CalendarEvents",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CourseMaterials_Tenants_TenantId",
                table: "CourseMaterials",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Courses_Tenants_TenantId",
                table: "Courses",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DeviceSessions_Tenants_TenantId",
                table: "DeviceSessions",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Exams_Tenants_TenantId",
                table: "Exams",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Faqs_Tenants_TenantId",
                table: "Faqs",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Groups_Tenants_TenantId",
                table: "Groups",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_MediaAssets_Tenants_TenantId",
                table: "MediaAssets",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_MediaFolders_Tenants_TenantId",
                table: "MediaFolders",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Notifications_Tenants_TenantId",
                table: "Notifications",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Packages_Tenants_TenantId",
                table: "Packages",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Plans_Tenants_TenantId",
                table: "Plans",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Podcasts_Tenants_TenantId",
                table: "Podcasts",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Questions_Tenants_TenantId",
                table: "Questions",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_SupportTickets_Tenants_TenantId",
                table: "SupportTickets",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Transactions_Tenants_TenantId",
                table: "Transactions",
                column: "TenantId",
                principalTable: "Tenants",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
