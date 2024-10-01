WITH _google_domains AS (
	SELECT
		SUBSTRING(url FROM 'https?://([^/]+)') as DOMAIN,
		SUM(visit_count) AS total_visit_count
	FROM urls
	WHERE url LIKE '%.google.com%'
	GROUP BY DOMAIN
	ORDER BY total_visit_count DESC
)

SELECT DOMAIN, total_visit_count
FROM _google_domains
WHERE DOMAIN LIKE '%google.com%'
order by total_visit_count
