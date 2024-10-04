SELECT
	COUNT(v.url) AS visit_count
FROM
	urls u
	JOIN visits v ON v.url = u.id
WHERE
	u.url LIKE '%hexdocs.pm%';

-- sum(urls.visit_count) is less than the count(visits.url)

	-- SELECT
	-- 	SUM(visit_count) AS total_visit_count
	-- FROM
	-- 	urls u
	-- WHERE
	-- 	url LIKE '%hexdocs.pm%'
