using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSessionIdToCourseMedia : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "SessionId",
                table: "CourseMedias",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_CourseMedias_SessionId",
                table: "CourseMedias",
                column: "SessionId");

            migrationBuilder.AddForeignKey(
                name: "FK_CourseMedias_Sessions_SessionId",
                table: "CourseMedias",
                column: "SessionId",
                principalTable: "Sessions",
                principalColumn: "Id");

            migrationBuilder.Sql(@"
                INSERT INTO ""CourseMedias"" (""Id"", ""CourseId"", ""SessionId"", ""OrderIndex"", ""CreatedAt"")
                SELECT gen_random_uuid(), ""CourseId"", ""Id"", ""Order"", ""CreatedAt""
                FROM ""Sessions"";
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CourseMedias_Sessions_SessionId",
                table: "CourseMedias");

            migrationBuilder.DropIndex(
                name: "IX_CourseMedias_SessionId",
                table: "CourseMedias");

            migrationBuilder.DropColumn(
                name: "SessionId",
                table: "CourseMedias");
        }
    }
}
