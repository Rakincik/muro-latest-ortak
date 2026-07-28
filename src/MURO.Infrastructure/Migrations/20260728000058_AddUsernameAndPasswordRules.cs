using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUsernameAndPasswordRules : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PasswordRule",
                table: "SystemSettings",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "UsernameRule",
                table: "SystemSettings",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PasswordRule",
                table: "SystemSettings");

            migrationBuilder.DropColumn(
                name: "UsernameRule",
                table: "SystemSettings");
        }
    }
}
