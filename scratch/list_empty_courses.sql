SELECT c."Id", c."Title" 
FROM "Courses" c 
LEFT JOIN "Sessions" s ON c."Id" = s."CourseId" AND s."IsDeleted" = false 
WHERE c."IsDeleted" = false 
GROUP BY c."Id", c."Title" 
HAVING COUNT(s."Id") = 0 
ORDER BY c."Title" ASC;
