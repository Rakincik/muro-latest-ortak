using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUseWhiteLogoBackground : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "UseWhiteLogoBackground",
                table: "SystemSettings",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UseWhiteLogoBackground",
                table: "SystemSettings");
        }
    }
}
