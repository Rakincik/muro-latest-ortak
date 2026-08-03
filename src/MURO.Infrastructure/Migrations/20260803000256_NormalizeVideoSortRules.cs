using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class NormalizeVideoSortRules : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Geriye dönük olarak boş veya null olan kuralları normalize et kanka!
            migrationBuilder.Sql("UPDATE \"SystemSettings\" SET \"VideoSortRule\" = 'custom' WHERE \"VideoSortRule\" IS NULL OR \"VideoSortRule\" = '';");
            migrationBuilder.Sql("UPDATE \"Courses\" SET \"VideoSortRule\" = 'default' WHERE \"VideoSortRule\" IS NULL OR \"VideoSortRule\" = '';");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
        }
    }
}
