using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSoftDeleteAndPartitioning : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Users",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Users",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Tenants",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Tenants",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Sessions",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Sessions",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Groups",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Groups",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Exams",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Exams",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Courses",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Courses",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Assignments",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "Assignments",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.Sql(@"
-- PostgreSQL Partitioning for AuditLogs
ALTER TABLE ""AuditLogs"" RENAME TO ""AuditLogs_Old"";
ALTER TABLE ""AuditLogs_Old"" RENAME CONSTRAINT ""PK_AuditLogs"" TO ""PK_AuditLogs_Old"";
ALTER INDEX IF EXISTS ""IX_AuditLogs_TenantId"" RENAME TO ""IX_AuditLogs_TenantId_Old"";
ALTER INDEX IF EXISTS ""IX_AuditLogs_UserId"" RENAME TO ""IX_AuditLogs_UserId_Old"";

CREATE TABLE ""AuditLogs"" (
    ""Id"" uuid NOT NULL,
    ""UserId"" uuid,
    ""UserName"" text,
    ""TenantId"" uuid,
    ""Action"" text NOT NULL,
    ""EntityType"" text NOT NULL,
    ""EntityId"" text,
    ""EntityName"" text,
    ""Details"" text,
    ""IpAddress"" text,
    ""CreatedAt"" timestamp with time zone NOT NULL,
    CONSTRAINT ""PK_AuditLogs"" PRIMARY KEY (""Id"", ""CreatedAt"")
) PARTITION BY RANGE (""CreatedAt"");

CREATE TABLE ""AuditLogs_Default"" PARTITION OF ""AuditLogs"" DEFAULT;

INSERT INTO ""AuditLogs"" (""Id"", ""UserId"", ""UserName"", ""TenantId"", ""Action"", ""EntityType"", ""EntityId"", ""EntityName"", ""Details"", ""IpAddress"", ""CreatedAt"")
SELECT ""Id"", ""UserId"", ""UserName"", ""TenantId"", ""Action"", ""EntityType"", ""EntityId"", ""EntityName"", ""Details"", ""IpAddress"", ""CreatedAt""
FROM ""AuditLogs_Old"";

DROP TABLE ""AuditLogs_Old"";
CREATE INDEX ""IX_AuditLogs_TenantId"" ON ""AuditLogs"" (""TenantId"");
CREATE INDEX ""IX_AuditLogs_UserId"" ON ""AuditLogs"" (""UserId"");
");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Tenants");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Tenants");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Sessions");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Groups");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Groups");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Exams");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Exams");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Courses");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Assignments");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "Assignments");
        }
    }
}
