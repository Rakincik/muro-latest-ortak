using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCodesToPackageAndGroup : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsPodcastEnabled",
                table: "SystemSettings");

            migrationBuilder.DropColumn(
                name: "IsQuestionsEnabled",
                table: "SystemSettings");

            migrationBuilder.DropColumn(
                name: "IsSupportEnabled",
                table: "SystemSettings");

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "Packages",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "Groups",
                type: "text",
                nullable: false,
                defaultValue: "");

            // Custom SQL to seed existing packages with zero-padded sequences
            migrationBuilder.Sql(@"
WITH RankedPackages AS (
    SELECT ""Id"", ROW_NUMBER() OVER (ORDER BY ""CreatedAt"") as rn
    FROM ""Packages""
)
UPDATE ""Packages"" p
SET ""Code"" = LPAD(rp.rn::text, 3, '0')
FROM RankedPackages rp
WHERE p.""Id"" = rp.""Id"";
");

            // Custom SQL to seed existing groups with zero-padded sequences
            migrationBuilder.Sql(@"
WITH RankedGroups AS (
    SELECT ""Id"", ROW_NUMBER() OVER (ORDER BY ""CreatedAt"") as rn
    FROM ""Groups""
)
UPDATE ""Groups"" g
SET ""Code"" = LPAD(rg.rn::text, 3, '0')
FROM RankedGroups rg
WHERE g.""Id"" = rg.""Id"";
");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Code",
                table: "Packages");

            migrationBuilder.DropColumn(
                name: "Code",
                table: "Groups");

            migrationBuilder.AddColumn<bool>(
                name: "IsPodcastEnabled",
                table: "SystemSettings",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsQuestionsEnabled",
                table: "SystemSettings",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsSupportEnabled",
                table: "SystemSettings",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }
    }
}
