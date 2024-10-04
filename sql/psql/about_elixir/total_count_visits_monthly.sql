WITH _helper AS (
	SELECT
		EXTRACT(EPOCH FROM AGE(DATE '1970-01-01',
				DATE '1601-01-01')) AS seconds_diff
),
_hexdocs AS (
	SELECT
	    v.id,
		TO_TIMESTAMP((v.visit_time / 1000000) - h.seconds_diff) AS _visit_time
	FROM
		_helper h,
		urls u
		JOIN visits v ON u.id = v.url
	WHERE
		u.url LIKE '%hexdocs.pm%'
)
-- query
SELECT
	DATE_TRUNC('month', _visit_time) AS visit_month,
	count(id) as total_visits
FROM
	_hexdocs
GROUP BY
	visit_month
ORDER BY
	visit_month;
