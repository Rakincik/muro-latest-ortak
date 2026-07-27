SELECT c."Title", COUNT(s."Id") as sessions_count
FROM "Courses" c
LEFT JOIN "Sessions" s ON c."Id" = s."CourseId" AND s."IsDeleted" = false
WHERE c."IsDeleted" = false
GROUP BY c."Title"
ORDER BY sessions_count ASC;
