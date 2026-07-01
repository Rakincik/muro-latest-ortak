using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MURO.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddTelegramMessageMapping : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_SessionAttendances_Sessions_SessionId1",
                table: "SessionAttendances");

            migrationBuilder.DropIndex(
                name: "IX_SessionAttendances_SessionId1",
                table: "SessionAttendances");

            migrationBuilder.DropColumn(
                name: "SessionId1",
                table: "SessionAttendances");

            migrationBuilder.CreateTable(
                name: "TelegramMessageMappings",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    TelegramMessageId = table.Column<long>(type: "bigint", nullable: false),
                    TelegramChatId = table.Column<long>(type: "bigint", nullable: false),
                    SupportTicketId = table.Column<Guid>(type: "uuid", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TelegramMessageMappings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TelegramMessageMappings_SupportTickets_SupportTicketId",
                        column: x => x.SupportTicketId,
                        principalTable: "SupportTickets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_TelegramMessageMappings_SupportTicketId",
                table: "TelegramMessageMappings",
                column: "SupportTicketId");

            migrationBuilder.CreateIndex(
                name: "IX_TelegramMessageMappings_TelegramMessageId",
                table: "TelegramMessageMappings",
                column: "TelegramMessageId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TelegramMessageMappings");

            migrationBuilder.AddColumn<Guid>(
                name: "SessionId1",
                table: "SessionAttendances",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_SessionAttendances_SessionId1",
                table: "SessionAttendances",
                column: "SessionId1");

            migrationBuilder.AddForeignKey(
                name: "FK_SessionAttendances_Sessions_SessionId1",
                table: "SessionAttendances",
                column: "SessionId1",
                principalTable: "Sessions",
                principalColumn: "Id");
        }
    }
}
