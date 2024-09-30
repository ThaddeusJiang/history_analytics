
SELECT
    SUBSTRING(u.url FROM 'https?://([^/]+)') AS domain,
    SUM(u.visit_count) AS total_visits
FROM urls u
GROUP BY domain
ORDER BY total_visits DESC
LIMIT 10;
