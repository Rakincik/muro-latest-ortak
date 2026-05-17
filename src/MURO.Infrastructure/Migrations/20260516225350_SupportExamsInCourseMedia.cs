using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SupportExamsInCourseMedia : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<Guid>(
                name: "MediaAssetId",
                table: "CourseMedias",
                type: "uuid",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uuid");

            migrationBuilder.AddColumn<Guid>(
                name: "ExamId",
                table: "CourseMedias",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_CourseMedias_ExamId",
                table: "CourseMedias",
                column: "ExamId");

            migrationBuilder.AddForeignKey(
                name: "FK_CourseMedias_Exams_ExamId",
                table: "CourseMedias",
                column: "ExamId",
                principalTable: "Exams",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CourseMedias_Exams_ExamId",
                table: "CourseMedias");

            migrationBuilder.DropIndex(
                name: "IX_CourseMedias_ExamId",
                table: "CourseMedias");

            migrationBuilder.DropColumn(
                name: "ExamId",
                table: "CourseMedias");

            migrationBuilder.AlterColumn<Guid>(
                name: "MediaAssetId",
                table: "CourseMedias",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);
        }
    }
}
