-- ====================================================================
-- MURO LMS - AKM Tenant Recording Domain Replacement Script
-- This script replaces the old 's104.okinar.com' domain with the new
-- 'canli.akm.muro.click' domain for BBB recording URLs.
-- Targets ONLY the specific meeting/record ID prefixes provided.
-- ====================================================================

-- 1. Begin transaction to ensure safety
BEGIN;

-- 2. Update MediaAssets table (FilePath)
UPDATE "MediaAssets"
SET "FilePath" = REPLACE("FilePath", 's104.okinar.com', 'canli.akm.muro.click')
WHERE "FilePath" LIKE '%e8cb3229d3e02fd9a3771e480ef0bdbc3baea2f9%'
   OR "FilePath" LIKE '%7bcb39dff9158bae8e9e11518d0ece663b5c5bfc%'
   OR "FilePath" LIKE '%b25f532e0e7a3853d232ec187ed3fd4ef1be27a0%'
   OR "FilePath" LIKE '%17f3e8fe0cd61c01acad8ceccf132c5fb15538e9%';

-- 3. Update Sessions table (VideoUrl)
UPDATE "Sessions"
SET "VideoUrl" = REPLACE("VideoUrl", 's104.okinar.com', 'canli.akm.muro.click')
WHERE "VideoUrl" LIKE '%e8cb3229d3e02fd9a3771e480ef0bdbc3baea2f9%'
   OR "VideoUrl" LIKE '%7bcb39dff9158bae8e9e11518d0ece663b5c5bfc%'
   OR "VideoUrl" LIKE '%b25f532e0e7a3853d232ec187ed3fd4ef1be27a0%'
   OR "VideoUrl" LIKE '%17f3e8fe0cd61c01acad8ceccf132c5fb15538e9%';

-- 4. Commit changes
COMMIT;
