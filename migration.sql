CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

CREATE TABLE "Tenants" (
    "Id" uuid NOT NULL,
    "Name" text NOT NULL,
    "Code" text NOT NULL,
    "LogoUrl" text,
    "Domain" text,
    "PrimaryColor" text,
    "IsActive" boolean NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Tenants" PRIMARY KEY ("Id")
);

CREATE TABLE "Users" (
    "Id" uuid NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Email" text NOT NULL,
    "Phone" text,
    "PasswordHash" text NOT NULL,
    "Role" text NOT NULL,
    "StudentType" text,
    "DemoExpiresAt" timestamp with time zone,
    "IsActive" boolean NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    "LastLoginAt" timestamp with time zone,
    CONSTRAINT "PK_Users" PRIMARY KEY ("Id")
);

CREATE TABLE "Exams" (
    "Id" uuid NOT NULL,
    "Title" text NOT NULL,
    "Description" text,
    "ExamType" text NOT NULL,
    "QuestionCount" integer NOT NULL,
    "OptionCount" integer NOT NULL,
    "DurationMinutes" integer,
    "WrongPenaltyWeight" double precision NOT NULL,
    "PdfUrl" text,
    "SolutionPdfUrl" text,
    "AnswerKeyJson" text,
    "Status" text NOT NULL,
    "ShowResults" boolean NOT NULL,
    "StartDate" timestamp with time zone,
    "EndDate" timestamp with time zone,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Exams" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Exams_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Faqs" (
    "Id" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "QuestionText" text NOT NULL,
    "AnswerText" text NOT NULL,
    "Category" text,
    "SortOrder" integer NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Faqs" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Faqs_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Groups" (
    "Id" uuid NOT NULL,
    "Name" text NOT NULL,
    "Description" text,
    "TenantId" uuid NOT NULL,
    "ParentId" uuid,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Groups" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Groups_Groups_ParentId" FOREIGN KEY ("ParentId") REFERENCES "Groups" ("Id") ON DELETE RESTRICT,
    CONSTRAINT "FK_Groups_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Courses" (
    "Id" uuid NOT NULL,
    "Title" text NOT NULL,
    "Description" text,
    "ThumbnailUrl" text,
    "CourseType" text NOT NULL,
    "Mode" text NOT NULL,
    "InstructorId" uuid,
    "TenantId" uuid NOT NULL,
    "IsPublished" boolean NOT NULL,
    "Order" integer NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Courses" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Courses_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_Courses_Users_InstructorId" FOREIGN KEY ("InstructorId") REFERENCES "Users" ("Id") ON DELETE SET NULL
);

CREATE TABLE "DeviceSessions" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "DeviceInfo" text NOT NULL,
    "IpAddress" text,
    "UserAgent" text,
    "LoginAt" timestamp with time zone NOT NULL,
    "LogoutAt" timestamp with time zone,
    "IsActive" boolean NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_DeviceSessions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_DeviceSessions_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_DeviceSessions_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Notifications" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "Title" text NOT NULL,
    "Body" text NOT NULL,
    "Type" text,
    "IsRead" boolean NOT NULL,
    "Channel" text NOT NULL,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Notifications" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Notifications_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_Notifications_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "SupportTickets" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "Subject" text NOT NULL,
    "Body" text NOT NULL,
    "Status" integer NOT NULL,
    "Priority" text NOT NULL,
    "Category" text NOT NULL,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_SupportTickets" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_SupportTickets_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_SupportTickets_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "TenantMemberships" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "Role" text NOT NULL,
    "Status" text NOT NULL,
    "JoinedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_TenantMemberships" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_TenantMemberships_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_TenantMemberships_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Transactions" (
    "Id" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "UserId" uuid,
    "Amount" numeric(18,2) NOT NULL,
    "Type" text NOT NULL,
    "Description" text,
    "TransactionDate" timestamp with time zone NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Transactions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Transactions_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_Transactions_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id")
);

CREATE TABLE "ExamAssignments" (
    "Id" uuid NOT NULL,
    "ExamId" uuid NOT NULL,
    "TargetType" text NOT NULL,
    "TargetId" uuid NOT NULL,
    "StartsAt" timestamp with time zone,
    "EndsAt" timestamp with time zone,
    "AssignedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_ExamAssignments" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_ExamAssignments_Exams_ExamId" FOREIGN KEY ("ExamId") REFERENCES "Exams" ("Id") ON DELETE CASCADE
);

CREATE TABLE "ExamResults" (
    "Id" uuid NOT NULL,
    "ExamId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "Answers" text NOT NULL,
    "CorrectCount" integer NOT NULL,
    "WrongCount" integer NOT NULL,
    "EmptyCount" integer NOT NULL,
    "Score" double precision NOT NULL,
    "StartedAt" timestamp with time zone,
    "SubmittedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_ExamResults" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_ExamResults_Exams_ExamId" FOREIGN KEY ("ExamId") REFERENCES "Exams" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_ExamResults_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Announcements" (
    "Id" uuid NOT NULL,
    "GroupId" uuid NOT NULL,
    "Title" text NOT NULL,
    "Content" text NOT NULL,
    "ImageUrl" text,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Announcements" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Announcements_Groups_GroupId" FOREIGN KEY ("GroupId") REFERENCES "Groups" ("Id") ON DELETE CASCADE
);

CREATE TABLE "GroupMembers" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "GroupId" uuid NOT NULL,
    "Role" integer NOT NULL,
    "Status" text NOT NULL,
    "AddedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_GroupMembers" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_GroupMembers_Groups_GroupId" FOREIGN KEY ("GroupId") REFERENCES "Groups" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_GroupMembers_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Assignments" (
    "Id" uuid NOT NULL,
    "CourseId" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "Title" text NOT NULL,
    "Description" text,
    "DueDate" timestamp with time zone NOT NULL,
    "FileUrl" text,
    "MaxScore" integer NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Assignments" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Assignments_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_Assignments_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "CalendarEvents" (
    "Id" uuid NOT NULL,
    "Title" text NOT NULL,
    "Description" text,
    "EventType" text NOT NULL,
    "StartDate" timestamp with time zone NOT NULL,
    "EndDate" timestamp with time zone NOT NULL,
    "Color" text,
    "GroupId" uuid,
    "CourseId" uuid,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_CalendarEvents" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_CalendarEvents_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id"),
    CONSTRAINT "FK_CalendarEvents_Groups_GroupId" FOREIGN KEY ("GroupId") REFERENCES "Groups" ("Id"),
    CONSTRAINT "FK_CalendarEvents_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "CourseGroups" (
    "Id" uuid NOT NULL,
    "CourseId" uuid NOT NULL,
    "GroupId" uuid NOT NULL,
    "Mode" text NOT NULL,
    "AssignedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_CourseGroups" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_CourseGroups_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_CourseGroups_Groups_GroupId" FOREIGN KEY ("GroupId") REFERENCES "Groups" ("Id") ON DELETE CASCADE
);

CREATE TABLE "MediaAssets" (
    "Id" uuid NOT NULL,
    "Title" text NOT NULL,
    "FilePath" text,
    "HlsPath" text,
    "ThumbnailPath" text,
    "DurationSeconds" integer,
    "Status" text NOT NULL,
    "CourseId" uuid,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_MediaAssets" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_MediaAssets_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id"),
    CONSTRAINT "FK_MediaAssets_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Podcasts" (
    "Id" uuid NOT NULL,
    "CourseId" uuid,
    "Title" text NOT NULL,
    "TextContent" text,
    "AudioFilePath" text,
    "DurationSeconds" integer,
    "Status" text NOT NULL,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Podcasts" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Podcasts_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id"),
    CONSTRAINT "FK_Podcasts_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "Questions" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "InstructorId" uuid NOT NULL,
    "Subject" text NOT NULL,
    "Body" text NOT NULL,
    "ImageUrl" text,
    "Answer" text,
    "AnsweredAt" timestamp with time zone,
    "Status" text NOT NULL,
    "CourseId" uuid,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Questions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Questions_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id"),
    CONSTRAINT "FK_Questions_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_Questions_Users_InstructorId" FOREIGN KEY ("InstructorId") REFERENCES "Users" ("Id") ON DELETE RESTRICT,
    CONSTRAINT "FK_Questions_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE RESTRICT
);

CREATE TABLE "Sessions" (
    "Id" uuid NOT NULL,
    "CourseId" uuid NOT NULL,
    "Title" text NOT NULL,
    "Description" text,
    "Order" integer NOT NULL,
    "VideoUrl" text,
    "DurationMinutes" integer,
    "IsFree" boolean NOT NULL,
    "ScheduledStart" timestamp with time zone,
    "ScheduledEnd" timestamp with time zone,
    "BbbMeetingId" text,
    "Status" text NOT NULL,
    "RecordingEnabled" boolean NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Sessions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Sessions_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE
);

CREATE TABLE "SupportMessages" (
    "Id" uuid NOT NULL,
    "TicketId" uuid NOT NULL,
    "SenderId" uuid NOT NULL,
    "Body" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_SupportMessages" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_SupportMessages_SupportTickets_TicketId" FOREIGN KEY ("TicketId") REFERENCES "SupportTickets" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_SupportMessages_Users_SenderId" FOREIGN KEY ("SenderId") REFERENCES "Users" ("Id") ON DELETE RESTRICT
);

CREATE TABLE "AssignmentSubmissions" (
    "Id" uuid NOT NULL,
    "AssignmentId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "FileUrl" text,
    "Comment" text,
    "SubmittedAt" timestamp with time zone NOT NULL,
    "Score" integer,
    "Feedback" text,
    CONSTRAINT "PK_AssignmentSubmissions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_AssignmentSubmissions_Assignments_AssignmentId" FOREIGN KEY ("AssignmentId") REFERENCES "Assignments" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_AssignmentSubmissions_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "VideoNotes" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "MediaAssetId" uuid NOT NULL,
    "TimestampSeconds" integer NOT NULL,
    "Text" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    "UpdatedAt" timestamp with time zone,
    CONSTRAINT "PK_VideoNotes" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_VideoNotes_MediaAssets_MediaAssetId" FOREIGN KEY ("MediaAssetId") REFERENCES "MediaAssets" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_VideoNotes_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE RESTRICT
);

CREATE TABLE "VideoProgresses" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "MediaAssetId" uuid NOT NULL,
    "WatchedSeconds" integer NOT NULL,
    "TotalSeconds" integer NOT NULL,
    "LastPosition" integer NOT NULL,
    "SkipCount" integer NOT NULL,
    "ReplayCount" integer NOT NULL,
    "CompletedAt" timestamp with time zone,
    "UpdatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_VideoProgresses" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_VideoProgresses_MediaAssets_MediaAssetId" FOREIGN KEY ("MediaAssetId") REFERENCES "MediaAssets" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_VideoProgresses_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "SessionAttendances" (
    "Id" uuid NOT NULL,
    "SessionId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "JoinedAt" timestamp with time zone NOT NULL,
    "LeftAt" timestamp with time zone,
    "DurationMinutes" integer,
    "SessionId1" uuid,
    CONSTRAINT "PK_SessionAttendances" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_SessionAttendances_Sessions_SessionId" FOREIGN KEY ("SessionId") REFERENCES "Sessions" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_SessionAttendances_Sessions_SessionId1" FOREIGN KEY ("SessionId1") REFERENCES "Sessions" ("Id"),
    CONSTRAINT "FK_SessionAttendances_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE RESTRICT
);

CREATE TABLE "SessionRecordings" (
    "Id" uuid NOT NULL,
    "SessionId" uuid NOT NULL,
    "MediaAssetId" uuid,
    "Status" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_SessionRecordings" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_SessionRecordings_MediaAssets_MediaAssetId" FOREIGN KEY ("MediaAssetId") REFERENCES "MediaAssets" ("Id"),
    CONSTRAINT "FK_SessionRecordings_Sessions_SessionId" FOREIGN KEY ("SessionId") REFERENCES "Sessions" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_Announcements_GroupId" ON "Announcements" ("GroupId");

CREATE INDEX "IX_Assignments_CourseId" ON "Assignments" ("CourseId");

CREATE INDEX "IX_Assignments_TenantId" ON "Assignments" ("TenantId");

CREATE INDEX "IX_AssignmentSubmissions_AssignmentId" ON "AssignmentSubmissions" ("AssignmentId");

CREATE INDEX "IX_AssignmentSubmissions_UserId" ON "AssignmentSubmissions" ("UserId");

CREATE INDEX "IX_CalendarEvents_CourseId" ON "CalendarEvents" ("CourseId");

CREATE INDEX "IX_CalendarEvents_GroupId" ON "CalendarEvents" ("GroupId");

CREATE INDEX "IX_CalendarEvents_TenantId" ON "CalendarEvents" ("TenantId");

CREATE UNIQUE INDEX "IX_CourseGroups_CourseId_GroupId" ON "CourseGroups" ("CourseId", "GroupId");

CREATE INDEX "IX_CourseGroups_GroupId" ON "CourseGroups" ("GroupId");

CREATE INDEX "IX_Courses_InstructorId" ON "Courses" ("InstructorId");

CREATE INDEX "IX_Courses_TenantId" ON "Courses" ("TenantId");

CREATE INDEX "IX_DeviceSessions_TenantId" ON "DeviceSessions" ("TenantId");

CREATE INDEX "IX_DeviceSessions_UserId" ON "DeviceSessions" ("UserId");

CREATE INDEX "IX_ExamAssignments_ExamId" ON "ExamAssignments" ("ExamId");

CREATE INDEX "IX_ExamResults_ExamId" ON "ExamResults" ("ExamId");

CREATE INDEX "IX_ExamResults_UserId" ON "ExamResults" ("UserId");

CREATE INDEX "IX_Exams_TenantId" ON "Exams" ("TenantId");

CREATE INDEX "IX_Faqs_TenantId" ON "Faqs" ("TenantId");

CREATE INDEX "IX_GroupMembers_GroupId" ON "GroupMembers" ("GroupId");

CREATE UNIQUE INDEX "IX_GroupMembers_UserId_GroupId" ON "GroupMembers" ("UserId", "GroupId");

CREATE INDEX "IX_Groups_ParentId" ON "Groups" ("ParentId");

CREATE INDEX "IX_Groups_TenantId" ON "Groups" ("TenantId");

CREATE INDEX "IX_MediaAssets_CourseId" ON "MediaAssets" ("CourseId");

CREATE INDEX "IX_MediaAssets_TenantId" ON "MediaAssets" ("TenantId");

CREATE INDEX "IX_Notifications_TenantId" ON "Notifications" ("TenantId");

CREATE INDEX "IX_Notifications_UserId" ON "Notifications" ("UserId");

CREATE INDEX "IX_Podcasts_CourseId" ON "Podcasts" ("CourseId");

CREATE INDEX "IX_Podcasts_TenantId" ON "Podcasts" ("TenantId");

CREATE INDEX "IX_Questions_CourseId" ON "Questions" ("CourseId");

CREATE INDEX "IX_Questions_InstructorId" ON "Questions" ("InstructorId");

CREATE INDEX "IX_Questions_TenantId" ON "Questions" ("TenantId");

CREATE INDEX "IX_Questions_UserId" ON "Questions" ("UserId");

CREATE UNIQUE INDEX "IX_SessionAttendances_SessionId_UserId" ON "SessionAttendances" ("SessionId", "UserId");

CREATE INDEX "IX_SessionAttendances_SessionId1" ON "SessionAttendances" ("SessionId1");

CREATE INDEX "IX_SessionAttendances_UserId" ON "SessionAttendances" ("UserId");

CREATE INDEX "IX_SessionRecordings_MediaAssetId" ON "SessionRecordings" ("MediaAssetId");

CREATE UNIQUE INDEX "IX_SessionRecordings_SessionId" ON "SessionRecordings" ("SessionId");

CREATE INDEX "IX_Sessions_CourseId" ON "Sessions" ("CourseId");

CREATE INDEX "IX_SupportMessages_SenderId" ON "SupportMessages" ("SenderId");

CREATE INDEX "IX_SupportMessages_TicketId" ON "SupportMessages" ("TicketId");

CREATE INDEX "IX_SupportTickets_TenantId" ON "SupportTickets" ("TenantId");

CREATE INDEX "IX_SupportTickets_UserId" ON "SupportTickets" ("UserId");

CREATE INDEX "IX_TenantMemberships_TenantId" ON "TenantMemberships" ("TenantId");

CREATE UNIQUE INDEX "IX_TenantMemberships_UserId_TenantId" ON "TenantMemberships" ("UserId", "TenantId");

CREATE UNIQUE INDEX "IX_Tenants_Code" ON "Tenants" ("Code");

CREATE INDEX "IX_Transactions_TenantId" ON "Transactions" ("TenantId");

CREATE INDEX "IX_Transactions_UserId" ON "Transactions" ("UserId");

CREATE UNIQUE INDEX "IX_Users_Email" ON "Users" ("Email");

CREATE INDEX "IX_VideoNotes_MediaAssetId" ON "VideoNotes" ("MediaAssetId");

CREATE INDEX "IX_VideoNotes_UserId" ON "VideoNotes" ("UserId");

CREATE INDEX "IX_VideoProgresses_MediaAssetId" ON "VideoProgresses" ("MediaAssetId");

CREATE UNIQUE INDEX "IX_VideoProgresses_UserId_MediaAssetId" ON "VideoProgresses" ("UserId", "MediaAssetId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260221221601_LiveAndVideoFeatures', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Transactions" ADD "InvoiceNo" text;

ALTER TABLE "Transactions" ADD "PaymentMethod" text;

ALTER TABLE "Transactions" ADD "PlanId" uuid;

ALTER TABLE "Transactions" ADD "Status" text NOT NULL DEFAULT '';

ALTER TABLE "Podcasts" ADD "GeneratedScript" text;

CREATE TABLE "Plans" (
    "Id" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "Name" text NOT NULL,
    "Description" text,
    "Price" numeric NOT NULL,
    "Currency" text NOT NULL,
    "BillingCycle" text NOT NULL,
    "MaxStudents" integer,
    "IsActive" boolean NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Plans" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Plans_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_Transactions_PlanId" ON "Transactions" ("PlanId");

CREATE INDEX "IX_Plans_TenantId" ON "Plans" ("TenantId");

ALTER TABLE "Transactions" ADD CONSTRAINT "FK_Transactions_Plans_PlanId" FOREIGN KEY ("PlanId") REFERENCES "Plans" ("Id");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260224205805_AddPodcastGeneratedScript', '8.0.0');

COMMIT;

START TRANSACTION;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260225102124_AddQuestionAudioAndNote', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Questions" ADD "AudioUrl" text;

ALTER TABLE "Questions" ADD "Note" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260226172501_AddBbbSessionFields', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Users" ADD "FailedLoginCount" integer NOT NULL DEFAULT 0;

ALTER TABLE "Users" ADD "LockoutUntil" timestamp with time zone;

CREATE TABLE "SecurityEvents" (
    "Id" uuid NOT NULL,
    "UserId" uuid,
    "TenantId" uuid,
    "EventType" text NOT NULL,
    "IpAddress" text,
    "UserAgent" text,
    "Details" text,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_SecurityEvents" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_SecurityEvents_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE SET NULL
);

CREATE INDEX "IX_SecurityEvents_EventType_CreatedAt" ON "SecurityEvents" ("EventType", "CreatedAt");

CREATE INDEX "IX_SecurityEvents_UserId" ON "SecurityEvents" ("UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260226221806_AddSecurityAuditLog', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Groups" ADD "Color" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260227143848_GroupColor', '8.0.0');

COMMIT;

START TRANSACTION;

CREATE TABLE "Packages" (
    "Id" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "Name" text NOT NULL,
    "Description" text,
    "Price" numeric(18,2) NOT NULL,
    "DurationDays" integer NOT NULL,
    "IsActive" boolean NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_Packages" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Packages_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE TABLE "PackageGroups" (
    "Id" uuid NOT NULL,
    "PackageId" uuid NOT NULL,
    "GroupId" uuid NOT NULL,
    "ContentMode" text NOT NULL,
    CONSTRAINT "PK_PackageGroups" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_PackageGroups_Groups_GroupId" FOREIGN KEY ("GroupId") REFERENCES "Groups" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_PackageGroups_Packages_PackageId" FOREIGN KEY ("PackageId") REFERENCES "Packages" ("Id") ON DELETE CASCADE
);

CREATE TABLE "UserPackages" (
    "Id" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "PackageId" uuid NOT NULL,
    "OrderId" text,
    "ActivatedAt" timestamp with time zone NOT NULL,
    "ExpiresAt" timestamp with time zone,
    "Status" text NOT NULL,
    "Source" text NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_UserPackages" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_UserPackages_Packages_PackageId" FOREIGN KEY ("PackageId") REFERENCES "Packages" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_UserPackages_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_PackageGroups_GroupId" ON "PackageGroups" ("GroupId");

CREATE UNIQUE INDEX "IX_PackageGroups_PackageId_GroupId" ON "PackageGroups" ("PackageId", "GroupId");

CREATE INDEX "IX_Packages_TenantId" ON "Packages" ("TenantId");

CREATE INDEX "IX_UserPackages_ExpiresAt" ON "UserPackages" ("ExpiresAt");

CREATE INDEX "IX_UserPackages_OrderId" ON "UserPackages" ("OrderId");

CREATE INDEX "IX_UserPackages_PackageId" ON "UserPackages" ("PackageId");

CREATE INDEX "IX_UserPackages_UserId_PackageId" ON "UserPackages" ("UserId", "PackageId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260227162733_AddPackageSystem', '8.0.0');

COMMIT;

START TRANSACTION;

CREATE TABLE "AuditLogs" (
    "Id" uuid NOT NULL,
    "UserId" uuid,
    "UserName" text,
    "TenantId" uuid,
    "Action" text NOT NULL,
    "EntityType" text NOT NULL,
    "EntityId" text,
    "EntityName" text,
    "Details" text,
    "IpAddress" text,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_AuditLogs" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_AuditLogs_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE SET NULL
);

CREATE TABLE "CourseMaterials" (
    "Id" uuid NOT NULL,
    "CourseId" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "Title" text NOT NULL,
    "FileName" text NOT NULL,
    "FilePath" text NOT NULL,
    "ContentType" text NOT NULL,
    "FileSize" bigint NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_CourseMaterials" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_CourseMaterials_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_CourseMaterials_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_AuditLogs_EntityType" ON "AuditLogs" ("EntityType");

CREATE INDEX "IX_AuditLogs_TenantId_CreatedAt" ON "AuditLogs" ("TenantId", "CreatedAt");

CREATE INDEX "IX_AuditLogs_UserId" ON "AuditLogs" ("UserId");

CREATE INDEX "IX_CourseMaterials_CourseId" ON "CourseMaterials" ("CourseId");

CREATE INDEX "IX_CourseMaterials_TenantId" ON "CourseMaterials" ("TenantId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260228161324_AddAuditLog', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Tenants" ADD "AccentColor" text;

ALTER TABLE "Tenants" ADD "BbbSecret" text;

ALTER TABLE "Tenants" ADD "BbbServerUrl" text;

ALTER TABLE "Tenants" ADD "ConnectionString" text;

ALTER TABLE "Tenants" ADD "FaviconUrl" text;

ALTER TABLE "Tenants" ADD "Features" text;

ALTER TABLE "Tenants" ADD "FooterText" text;

ALTER TABLE "Tenants" ADD "ServerGroup" text;

ALTER TABLE "Tenants" ADD "Subdomain" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260228164801_MultiTenantInfrastructure', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Groups" ADD "EducationType" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260302232154_SyncSchemaFixes', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Courses" ADD "StartDate" timestamp with time zone;

UPDATE "Courses" SET "CourseType" = 'Online' WHERE "CourseType" = 'OnDemand'

UPDATE "Courses" SET "CourseType" = 'Offline' WHERE "CourseType" = 'Live'

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260303144357_RenomeCourseTypeAndAddStartDate', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Exams" ADD "QuestionWeightsJson" text;

ALTER TABLE "Exams" ADD "ResultMode" text NOT NULL DEFAULT '';

ALTER TABLE "Exams" ADD "ResultPublishDate" timestamp with time zone;

ALTER TABLE "Exams" ADD "SectionsJson" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260303165824_AddExamWeightsAndScheduledResults', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Tenants" ADD "MaxBbbParticipants" integer;

ALTER TABLE "Tenants" ADD "MaxCourses" integer;

ALTER TABLE "Tenants" ADD "MaxSessionsPerDay" integer;

ALTER TABLE "Tenants" ADD "MaxStudents" integer;

ALTER TABLE "Tenants" ADD "StorageLimitGb" numeric;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260309164623_AddTenantQuotas', '8.0.0');

COMMIT;

START TRANSACTION;

DROP INDEX "IX_VideoNotes_UserId";

DROP INDEX "IX_Transactions_TenantId";

DROP INDEX "IX_TenantMemberships_TenantId";

DROP INDEX "IX_SupportTickets_TenantId";

DROP INDEX "IX_Sessions_CourseId";

DROP INDEX "IX_Questions_TenantId";

DROP INDEX "IX_Notifications_TenantId";

DROP INDEX "IX_Notifications_UserId";

DROP INDEX "IX_MediaAssets_TenantId";

DROP INDEX "IX_GroupMembers_GroupId";

DROP INDEX "IX_Exams_TenantId";

DROP INDEX "IX_ExamResults_ExamId";

DROP INDEX "IX_CalendarEvents_TenantId";

DROP INDEX "IX_AssignmentSubmissions_AssignmentId";

DROP INDEX "IX_Assignments_TenantId";

DROP INDEX "IX_Announcements_GroupId";

CREATE INDEX "IX_VideoNotes_UserId_MediaAssetId" ON "VideoNotes" ("UserId", "MediaAssetId");

CREATE INDEX "IX_Transactions_TenantId_TransactionDate" ON "Transactions" ("TenantId", "TransactionDate");

CREATE INDEX "IX_TenantMemberships_TenantId_Status" ON "TenantMemberships" ("TenantId", "Status");

CREATE INDEX "IX_SupportTickets_TenantId_Status" ON "SupportTickets" ("TenantId", "Status");

CREATE INDEX "IX_Sessions_CourseId_ScheduledStart" ON "Sessions" ("CourseId", "ScheduledStart");

CREATE INDEX "IX_SessionAttendances_TenantId_UserId" ON "SessionAttendances" ("TenantId", "UserId");

CREATE INDEX "IX_SecurityEvents_IpAddress_EventType_CreatedAt" ON "SecurityEvents" ("IpAddress", "EventType", "CreatedAt");

CREATE INDEX "IX_Questions_TenantId_InstructorId" ON "Questions" ("TenantId", "InstructorId");

CREATE INDEX "IX_Questions_TenantId_Status" ON "Questions" ("TenantId", "Status");

CREATE INDEX "IX_Notifications_TenantId_CreatedAt" ON "Notifications" ("TenantId", "CreatedAt");

CREATE INDEX "IX_Notifications_UserId_TenantId_IsRead" ON "Notifications" ("UserId", "TenantId", "IsRead");

CREATE INDEX "IX_MediaAssets_TenantId_CourseId" ON "MediaAssets" ("TenantId", "CourseId");

CREATE INDEX "IX_MediaAssets_TenantId_Status" ON "MediaAssets" ("TenantId", "Status");

CREATE INDEX "IX_GroupMembers_GroupId_Status" ON "GroupMembers" ("GroupId", "Status");

CREATE INDEX "IX_GroupMembers_UserId" ON "GroupMembers" ("UserId");

CREATE INDEX "IX_Exams_TenantId_CreatedAt" ON "Exams" ("TenantId", "CreatedAt");

CREATE INDEX "IX_Exams_TenantId_Status" ON "Exams" ("TenantId", "Status");

CREATE INDEX "IX_ExamResults_ExamId_UserId" ON "ExamResults" ("ExamId", "UserId");

CREATE INDEX "IX_CalendarEvents_TenantId_GroupId" ON "CalendarEvents" ("TenantId", "GroupId");

CREATE INDEX "IX_CalendarEvents_TenantId_StartDate_EndDate" ON "CalendarEvents" ("TenantId", "StartDate", "EndDate");

CREATE INDEX "IX_AuditLogs_TenantId_Action" ON "AuditLogs" ("TenantId", "Action");

CREATE INDEX "IX_AssignmentSubmissions_AssignmentId_UserId" ON "AssignmentSubmissions" ("AssignmentId", "UserId");

CREATE INDEX "IX_Assignments_TenantId_CourseId" ON "Assignments" ("TenantId", "CourseId");

CREATE INDEX "IX_Assignments_TenantId_DueDate" ON "Assignments" ("TenantId", "DueDate");

CREATE INDEX "IX_Announcements_GroupId_CreatedAt" ON "Announcements" ("GroupId", "CreatedAt");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260309200419_Phase2PerformanceIndexes', '8.0.0');

COMMIT;

START TRANSACTION;

CREATE INDEX "IX_UserPackages_UserId" ON "UserPackages" ("UserId");

CREATE INDEX "IX_PackageGroups_PackageId" ON "PackageGroups" ("PackageId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260309201402_FinalPerformanceIndexes', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Tenants" ADD "JitsiServerUrl" text;

ALTER TABLE "Tenants" ADD "MeetingProviderType" text NOT NULL DEFAULT '';

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260309213504_AddMeetingProviderToTenant', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "DeviceSessions" DROP CONSTRAINT "FK_DeviceSessions_Tenants_TenantId";

ALTER TABLE "Exams" ADD "MaxScore" double precision NOT NULL DEFAULT 0.0;

ALTER TABLE "Exams" ADD "VirtualParticipantCount" integer NOT NULL DEFAULT 0;

ALTER TABLE "DeviceSessions" ALTER COLUMN "TenantId" DROP NOT NULL;

ALTER TABLE "DeviceSessions" ADD CONSTRAINT "FK_DeviceSessions_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260425212610_AddExamMaxScoreAndVirtualCount', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "DeviceSessions" ADD "PushToken" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260508220133_AddPushTokenToDeviceSession', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "MediaAssets" ADD "FolderId" uuid;

CREATE TABLE "CourseMedias" (
    "Id" uuid NOT NULL,
    "CourseId" uuid NOT NULL,
    "MediaAssetId" uuid NOT NULL,
    "OrderIndex" integer NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_CourseMedias" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_CourseMedias_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_CourseMedias_MediaAssets_MediaAssetId" FOREIGN KEY ("MediaAssetId") REFERENCES "MediaAssets" ("Id") ON DELETE CASCADE
);

CREATE TABLE "MediaFolders" (
    "Id" uuid NOT NULL,
    "Name" text NOT NULL,
    "ParentFolderId" uuid,
    "TenantId" uuid NOT NULL,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_MediaFolders" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_MediaFolders_MediaFolders_ParentFolderId" FOREIGN KEY ("ParentFolderId") REFERENCES "MediaFolders" ("Id") ON DELETE RESTRICT,
    CONSTRAINT "FK_MediaFolders_Tenants_TenantId" FOREIGN KEY ("TenantId") REFERENCES "Tenants" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_MediaAssets_FolderId" ON "MediaAssets" ("FolderId");

CREATE UNIQUE INDEX "IX_CourseMedias_CourseId_MediaAssetId" ON "CourseMedias" ("CourseId", "MediaAssetId");

CREATE INDEX "IX_CourseMedias_MediaAssetId" ON "CourseMedias" ("MediaAssetId");

CREATE INDEX "IX_CourseMedias_OrderIndex" ON "CourseMedias" ("OrderIndex");

CREATE INDEX "IX_MediaFolders_ParentFolderId" ON "MediaFolders" ("ParentFolderId");

CREATE INDEX "IX_MediaFolders_TenantId" ON "MediaFolders" ("TenantId");

ALTER TABLE "MediaAssets" ADD CONSTRAINT "FK_MediaAssets_MediaFolders_FolderId" FOREIGN KEY ("FolderId") REFERENCES "MediaFolders" ("Id") ON DELETE SET NULL;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260513015516_AddMediaLibraryArchitecture', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Tenants" ADD "MaxDemoStudents" integer;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260515082131_AddMaxDemoStudentsToTenant', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "CourseMedias" ALTER COLUMN "MediaAssetId" DROP NOT NULL;

ALTER TABLE "CourseMedias" ADD "ExamId" uuid;

CREATE INDEX "IX_CourseMedias_ExamId" ON "CourseMedias" ("ExamId");

ALTER TABLE "CourseMedias" ADD CONSTRAINT "FK_CourseMedias_Exams_ExamId" FOREIGN KEY ("ExamId") REFERENCES "Exams" ("Id");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260516225350_SupportExamsInCourseMedia', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Exams" ADD "DigitalQuestionsJson" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260516230759_AddDigitalQuestionsToExam', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "CourseMedias" ADD "SessionId" uuid;

CREATE INDEX "IX_CourseMedias_SessionId" ON "CourseMedias" ("SessionId");

ALTER TABLE "CourseMedias" ADD CONSTRAINT "FK_CourseMedias_Sessions_SessionId" FOREIGN KEY ("SessionId") REFERENCES "Sessions" ("Id");


                INSERT INTO "CourseMedias" ("Id", "CourseId", "SessionId", "OrderIndex", "CreatedAt")
                SELECT gen_random_uuid(), "CourseId", "Id", "Order", "CreatedAt"
                FROM "Sessions";
            

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260517154951_AddSessionIdToCourseMedia', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Exams" ADD "BaseScore" double precision NOT NULL DEFAULT 0.0;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260517205201_AddBaseScoreToExams', '8.0.0');

COMMIT;

START TRANSACTION;

CREATE TABLE "ExamSubmissionQueues" (
    "Id" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "ExamId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "AnswersJson" jsonb NOT NULL,
    "SubmittedAt" timestamp with time zone NOT NULL,
    "Status" text NOT NULL,
    "ErrorMessage" text,
    CONSTRAINT "PK_ExamSubmissionQueues" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_ExamSubmissionQueues_Exams_ExamId" FOREIGN KEY ("ExamId") REFERENCES "Exams" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_ExamSubmissionQueues_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE TABLE "StudentExamDrafts" (
    "Id" uuid NOT NULL,
    "TenantId" uuid NOT NULL,
    "ExamId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "AnswersJson" jsonb NOT NULL,
    "LastUpdatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_StudentExamDrafts" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_StudentExamDrafts_Exams_ExamId" FOREIGN KEY ("ExamId") REFERENCES "Exams" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_StudentExamDrafts_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_ExamSubmissionQueues_ExamId" ON "ExamSubmissionQueues" ("ExamId");

CREATE INDEX "IX_ExamSubmissionQueues_TenantId_Status" ON "ExamSubmissionQueues" ("TenantId", "Status");

CREATE INDEX "IX_ExamSubmissionQueues_UserId" ON "ExamSubmissionQueues" ("UserId");

CREATE UNIQUE INDEX "IX_StudentExamDrafts_ExamId_UserId" ON "StudentExamDrafts" ("ExamId", "UserId");

CREATE INDEX "IX_StudentExamDrafts_UserId" ON "StudentExamDrafts" ("UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260517211235_AddExamSubmissionQueueAndDrafts', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Users" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Users" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Tenants" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Tenants" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Sessions" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Sessions" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Groups" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Groups" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Exams" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Exams" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Courses" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Courses" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;

ALTER TABLE "Assignments" ADD "DeletedAt" timestamp with time zone;

ALTER TABLE "Assignments" ADD "IsDeleted" boolean NOT NULL DEFAULT FALSE;


-- PostgreSQL Partitioning for AuditLogs
ALTER TABLE "AuditLogs" RENAME TO "AuditLogs_Old";
ALTER TABLE "AuditLogs_Old" RENAME CONSTRAINT "PK_AuditLogs" TO "PK_AuditLogs_Old";
ALTER INDEX IF EXISTS "IX_AuditLogs_TenantId" RENAME TO "IX_AuditLogs_TenantId_Old";
ALTER INDEX IF EXISTS "IX_AuditLogs_UserId" RENAME TO "IX_AuditLogs_UserId_Old";

CREATE TABLE "AuditLogs" (
    "Id" uuid NOT NULL,
    "UserId" uuid,
    "UserName" text,
    "TenantId" uuid,
    "Action" text NOT NULL,
    "EntityType" text NOT NULL,
    "EntityId" text,
    "EntityName" text,
    "Details" text,
    "IpAddress" text,
    "CreatedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_AuditLogs" PRIMARY KEY ("Id", "CreatedAt")
) PARTITION BY RANGE ("CreatedAt");

CREATE TABLE "AuditLogs_Default" PARTITION OF "AuditLogs" DEFAULT;

INSERT INTO "AuditLogs" ("Id", "UserId", "UserName", "TenantId", "Action", "EntityType", "EntityId", "EntityName", "Details", "IpAddress", "CreatedAt")
SELECT "Id", "UserId", "UserName", "TenantId", "Action", "EntityType", "EntityId", "EntityName", "Details", "IpAddress", "CreatedAt"
FROM "AuditLogs_Old";

DROP TABLE "AuditLogs_Old";
CREATE INDEX "IX_AuditLogs_TenantId" ON "AuditLogs" ("TenantId");
CREATE INDEX "IX_AuditLogs_UserId" ON "AuditLogs" ("UserId");


INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260517212903_AddSoftDeleteAndPartitioning', '8.0.0');

COMMIT;

START TRANSACTION;

DROP INDEX "IX_StudentExamDrafts_ExamId_UserId";

CREATE INDEX "IX_StudentExamDrafts_ExamId" ON "StudentExamDrafts" ("ExamId");

CREATE UNIQUE INDEX "IX_StudentExamDrafts_TenantId_ExamId_UserId" ON "StudentExamDrafts" ("TenantId", "ExamId", "UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260519001140_Optimization_Phase1', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "MediaAssets" ADD "Tags" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260520152833_AddMediaAssetTags', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Groups" ADD "ExpirationDate" timestamp with time zone;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260520235848_AddGroupExpirationDate', '8.0.0');

COMMIT;

START TRANSACTION;

CREATE TABLE "CourseStudents" (
    "Id" uuid NOT NULL,
    "CourseId" uuid NOT NULL,
    "UserId" uuid NOT NULL,
    "AssignedAt" timestamp with time zone NOT NULL,
    CONSTRAINT "PK_CourseStudents" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_CourseStudents_Courses_CourseId" FOREIGN KEY ("CourseId") REFERENCES "Courses" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_CourseStudents_Users_UserId" FOREIGN KEY ("UserId") REFERENCES "Users" ("Id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX "IX_CourseStudents_CourseId_UserId" ON "CourseStudents" ("CourseId", "UserId");

CREATE INDEX "IX_CourseStudents_UserId" ON "CourseStudents" ("UserId");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260615154618_AddCourseStudentEntity', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "CourseStudents" ADD "ExpiresAt" timestamp with time zone;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260615173132_AddExpiresAtToCourseStudent', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Users" ADD "TcNo" text;

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260617165439_AddTcNoToUser', '8.0.0');

COMMIT;

START TRANSACTION;


            -- FK kısıtlamalarını geçici olarak devre dışı bırak (sadece bu session için)
            SET session_replication_role = 'replica';

            -- TenantId barındıran tüm tablolardan Monopol harici verileri sil
            DO $$ 
            DECLARE
                monopol_ids uuid[];
            BEGIN
                -- Monopol tenant id'lerini al
                SELECT array_agg("Id") INTO monopol_ids FROM "Tenants" WHERE "Code" ILIKE '%monopol%';

                IF monopol_ids IS NOT NULL THEN
                    DELETE FROM "TenantMemberships" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Users" WHERE "Id" NOT IN (SELECT "UserId" FROM "TenantMemberships");
                    
                    DELETE FROM "Announcements" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Assignments" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "AssignmentSubmissions" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "AuditLogs" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "CalendarEvents" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Courses" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "CourseGroups" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "CourseMaterials" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "CourseMedias" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "CourseStudents" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "DeviceSessions" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Exams" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "ExamAssignments" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "ExamResults" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "ExamSubmissionQueues" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Faqs" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Groups" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "GroupMembers" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "MediaAssets" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "MediaFolders" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Notifications" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Packages" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "PackageGroups" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Plans" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Podcasts" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Questions" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "SecurityEvents" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Sessions" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "SessionAttendances" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "SessionRecordings" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "StudentExamDrafts" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "SupportMessages" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "SupportTickets" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "Transactions" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "UserPackages" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "VideoNotes" WHERE "TenantId" != ALL(monopol_ids);
                    DELETE FROM "VideoProgresses" WHERE "TenantId" != ALL(monopol_ids);

                    -- Diğer tenantları sil
                    DELETE FROM "Tenants" WHERE "Code" NOT ILIKE '%monopol%';
                END IF;
            EXCEPTION WHEN undefined_table THEN
                -- Tablo yoksa atla
            WHEN undefined_column THEN
                -- Kolon yoksa atla
            END $$;

            -- FK kısıtlamalarını geri aç
            SET session_replication_role = 'origin';
            

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260619201940_PreDropTenantCleanup', '8.0.0');

COMMIT;

START TRANSACTION;

ALTER TABLE "Assignments" DROP CONSTRAINT "FK_Assignments_Tenants_TenantId";

ALTER TABLE "CalendarEvents" DROP CONSTRAINT "FK_CalendarEvents_Tenants_TenantId";

ALTER TABLE "CourseMaterials" DROP CONSTRAINT "FK_CourseMaterials_Tenants_TenantId";

ALTER TABLE "Courses" DROP CONSTRAINT "FK_Courses_Tenants_TenantId";

ALTER TABLE "DeviceSessions" DROP CONSTRAINT "FK_DeviceSessions_Tenants_TenantId";

ALTER TABLE "Exams" DROP CONSTRAINT "FK_Exams_Tenants_TenantId";

ALTER TABLE "Faqs" DROP CONSTRAINT "FK_Faqs_Tenants_TenantId";

ALTER TABLE "Groups" DROP CONSTRAINT "FK_Groups_Tenants_TenantId";

ALTER TABLE "MediaAssets" DROP CONSTRAINT "FK_MediaAssets_Tenants_TenantId";

ALTER TABLE "MediaFolders" DROP CONSTRAINT "FK_MediaFolders_Tenants_TenantId";

ALTER TABLE "Notifications" DROP CONSTRAINT "FK_Notifications_Tenants_TenantId";

ALTER TABLE "Packages" DROP CONSTRAINT "FK_Packages_Tenants_TenantId";

ALTER TABLE "Plans" DROP CONSTRAINT "FK_Plans_Tenants_TenantId";

ALTER TABLE "Podcasts" DROP CONSTRAINT "FK_Podcasts_Tenants_TenantId";

ALTER TABLE "Questions" DROP CONSTRAINT "FK_Questions_Tenants_TenantId";

ALTER TABLE "SupportTickets" DROP CONSTRAINT "FK_SupportTickets_Tenants_TenantId";

ALTER TABLE "Transactions" DROP CONSTRAINT "FK_Transactions_Tenants_TenantId";

DROP TABLE "TenantMemberships";

DROP TABLE "Tenants";

DROP INDEX IF EXISTS "IX_Transactions_TenantId_TransactionDate";

DROP INDEX IF EXISTS "IX_SupportTickets_TenantId_Status";

DROP INDEX IF EXISTS "IX_StudentExamDrafts_ExamId";

DROP INDEX IF EXISTS "IX_StudentExamDrafts_TenantId_ExamId_UserId";

DROP INDEX IF EXISTS "IX_SessionAttendances_TenantId_UserId";

DROP INDEX IF EXISTS "IX_Questions_TenantId_InstructorId";

DROP INDEX IF EXISTS "IX_Questions_TenantId_Status";

DROP INDEX IF EXISTS "IX_Podcasts_TenantId";

DROP INDEX IF EXISTS "IX_Plans_TenantId";

DROP INDEX IF EXISTS "IX_Packages_TenantId";

DROP INDEX IF EXISTS "IX_Notifications_TenantId_CreatedAt";

DROP INDEX IF EXISTS "IX_Notifications_UserId_TenantId_IsRead";

DROP INDEX IF EXISTS "IX_MediaFolders_TenantId";

DROP INDEX IF EXISTS "IX_MediaAssets_TenantId_CourseId";

DROP INDEX IF EXISTS "IX_MediaAssets_TenantId_Status";

DROP INDEX IF EXISTS "IX_Groups_TenantId";

DROP INDEX IF EXISTS "IX_Faqs_TenantId";

DROP INDEX IF EXISTS "IX_ExamSubmissionQueues_TenantId_Status";

DROP INDEX IF EXISTS "IX_Exams_TenantId_CreatedAt";

DROP INDEX IF EXISTS "IX_Exams_TenantId_Status";

DROP INDEX IF EXISTS "IX_DeviceSessions_TenantId";

DROP INDEX IF EXISTS "IX_Courses_TenantId";

DROP INDEX IF EXISTS "IX_CourseMaterials_TenantId";

DROP INDEX IF EXISTS "IX_CalendarEvents_TenantId_GroupId";

DROP INDEX IF EXISTS "IX_CalendarEvents_TenantId_StartDate_EndDate";

DROP INDEX IF EXISTS "IX_AuditLogs_TenantId_Action";

DROP INDEX IF EXISTS "IX_AuditLogs_TenantId_CreatedAt";

DROP INDEX IF EXISTS "IX_Assignments_TenantId_CourseId";

DROP INDEX IF EXISTS "IX_Assignments_TenantId_DueDate";

ALTER TABLE "Transactions" DROP COLUMN "TenantId";

ALTER TABLE "SupportTickets" DROP COLUMN "TenantId";

ALTER TABLE "StudentExamDrafts" DROP COLUMN "TenantId";

ALTER TABLE "SessionAttendances" DROP COLUMN "TenantId";

ALTER TABLE "Questions" DROP COLUMN "TenantId";

ALTER TABLE "Podcasts" DROP COLUMN "TenantId";

ALTER TABLE "Plans" DROP COLUMN "TenantId";

ALTER TABLE "Packages" DROP COLUMN "TenantId";

ALTER TABLE "Notifications" DROP COLUMN "TenantId";

ALTER TABLE "MediaFolders" DROP COLUMN "TenantId";

ALTER TABLE "MediaAssets" DROP COLUMN "TenantId";

ALTER TABLE "Groups" DROP COLUMN "TenantId";

ALTER TABLE "Faqs" DROP COLUMN "TenantId";

ALTER TABLE "ExamSubmissionQueues" DROP COLUMN "TenantId";

ALTER TABLE "Exams" DROP COLUMN "TenantId";

ALTER TABLE "DeviceSessions" DROP COLUMN "TenantId";

ALTER TABLE "Courses" DROP COLUMN "TenantId";

ALTER TABLE "CourseMaterials" DROP COLUMN "TenantId";

ALTER TABLE "CalendarEvents" DROP COLUMN "TenantId";

ALTER TABLE "Assignments" DROP COLUMN "TenantId";

CREATE INDEX "IX_Transactions_TransactionDate" ON "Transactions" ("TransactionDate");

CREATE INDEX "IX_SupportTickets_Status" ON "SupportTickets" ("Status");

CREATE UNIQUE INDEX "IX_StudentExamDrafts_ExamId_UserId" ON "StudentExamDrafts" ("ExamId", "UserId");

CREATE INDEX "IX_Questions_Status" ON "Questions" ("Status");

CREATE INDEX "IX_Notifications_CreatedAt" ON "Notifications" ("CreatedAt");

CREATE INDEX "IX_Notifications_UserId_IsRead" ON "Notifications" ("UserId", "IsRead");

CREATE INDEX "IX_MediaAssets_Status" ON "MediaAssets" ("Status");

CREATE INDEX "IX_ExamSubmissionQueues_Status" ON "ExamSubmissionQueues" ("Status");

CREATE INDEX "IX_Exams_CreatedAt" ON "Exams" ("CreatedAt");

CREATE INDEX "IX_Exams_Status" ON "Exams" ("Status");

CREATE INDEX "IX_CalendarEvents_StartDate_EndDate" ON "CalendarEvents" ("StartDate", "EndDate");

CREATE INDEX "IX_AuditLogs_Action" ON "AuditLogs" ("Action");

CREATE INDEX "IX_AuditLogs_CreatedAt" ON "AuditLogs" ("CreatedAt");

CREATE INDEX "IX_Assignments_DueDate" ON "Assignments" ("DueDate");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260619220711_RemoveTenantId', '8.0.0');

COMMIT;

START TRANSACTION;

DROP INDEX "IX_Users_Email";

ALTER TABLE "Users" ADD "Username" text NOT NULL DEFAULT '';

UPDATE "Users" SET "Username" = "Email";

CREATE INDEX "IX_Users_Email" ON "Users" ("Email");

CREATE UNIQUE INDEX "IX_Users_Username" ON "Users" ("Username");

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260620162013_AddUsernameToUser', '8.0.0');

COMMIT;

