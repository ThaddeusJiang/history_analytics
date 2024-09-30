SELECT
    SUBSTRING(u.url FROM 'https?://([^/]+)') AS domain,
    SUM(u.visit_count) AS total_visits
FROM urls u
WHERE url LIKE '%.google.com%'
GROUP BY domain
ORDER BY total_visits DESC
