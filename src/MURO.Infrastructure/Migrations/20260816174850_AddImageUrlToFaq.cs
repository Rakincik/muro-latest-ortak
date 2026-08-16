using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddImageUrlToFaq : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "BbbSecret",
                table: "SystemSettings",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "BbbUrl",
                table: "SystemSettings",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ImageUrl",
                table: "Faqs",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BbbSecret",
                table: "SystemSettings");

            migrationBuilder.DropColumn(
                name: "BbbUrl",
                table: "SystemSettings");

            migrationBuilder.DropColumn(
                name: "ImageUrl",
                table: "Faqs");
        }
    }
}
