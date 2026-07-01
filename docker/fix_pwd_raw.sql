UPDATE "Users" SET "PasswordHash" = '123456', "FailedLoginCount" = 0, "LockoutUntil" = NULL WHERE "Email" = 'admin@muro.com';
