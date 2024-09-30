with _google_data as (
    SELECT
        SUBSTRING(u.url FROM 'https?://([^/]+)') AS domain,
		SUM(u.visit_count) as total_visit_count
    FROM urls u
    WHERE url LIKE '%.google.com%'
    GROUP BY DOMAIN
)
SELECT COUNT(domain)
FROM _google_data
