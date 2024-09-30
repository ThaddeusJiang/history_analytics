SELECT
    SUBSTRING(u.url FROM 'https?://([^/]+)') AS domain,
    SUM(u.visit_count) AS total_visits
FROM urls u
WHERE url NOT SIMILAR TO 'http://(localhost|127.0.0.1)%'
GROUP BY domain
ORDER BY total_visits DESC
LIMIT 10;
