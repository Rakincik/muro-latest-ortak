using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Optimization_Phase1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_StudentExamDrafts_ExamId_UserId",
                table: "StudentExamDrafts");

            migrationBuilder.CreateIndex(
                name: "IX_StudentExamDrafts_ExamId",
                table: "StudentExamDrafts",
                column: "ExamId");

            migrationBuilder.CreateIndex(
                name: "IX_StudentExamDrafts_TenantId_ExamId_UserId",
                table: "StudentExamDrafts",
                columns: new[] { "TenantId", "ExamId", "UserId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_StudentExamDrafts_ExamId",
                table: "StudentExamDrafts");

            migrationBuilder.DropIndex(
                name: "IX_StudentExamDrafts_TenantId_ExamId_UserId",
                table: "StudentExamDrafts");

            migrationBuilder.CreateIndex(
                name: "IX_StudentExamDrafts_ExamId_UserId",
                table: "StudentExamDrafts",
                columns: new[] { "ExamId", "UserId" },
                unique: true);
        }
    }
}
