WITH _hexdocs AS (
	SELECT
		LOWER(SUBSTRING(u.url FROM 'hexdocs.pm/([^/]+)')) AS package,
		v.id
	FROM
		urls u
		JOIN visits v ON v.url = u.id
	WHERE
		u.url LIKE '%hexdocs.pm%'
)
SELECT package, COUNT(id) as total_count_visits
FROM _hexdocs
GROUP BY package
ORDER BY total_count_visits DESC
