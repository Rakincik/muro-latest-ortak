SELECT "UserId", SUM("WatchedSeconds") as t FROM "VideoProgresses" GROUP BY "UserId" ORDER BY t DESC LIMIT 10;
