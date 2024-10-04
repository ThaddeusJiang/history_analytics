WITH _hexdocs AS (
	SELECT
		LOWER(SUBSTRING(u.url FROM 'hexdocs.pm/([^/]+)')) AS package,
		SUM(visit_count) AS sum_total_count
	FROM
		urls u
	WHERE
		url LIKE '%hexdocs.pm%'
	GROUP BY
		package
	ORDER BY
		sum_total_count DESC
)
-- query
SELECT
	COUNT(package)
FROM
	_hexdocs;
