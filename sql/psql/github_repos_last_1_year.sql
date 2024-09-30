WITH _helper AS (
	SELECT
		EXTRACT(EPOCH FROM AGE(DATE '1970-01-01',
				DATE '1601-01-01')) AS seconds_diff
),
_github AS (
	SELECT
		SUBSTRING(u.url FROM '^(https://github.com/([^/]+)/([^/]+))') AS link,
		SUBSTRING(u.url FROM 'https://github.com/([^/]+)/[^/]+') AS github_user,
		-- can not use "user"
		SUBSTRING(u.url FROM 'https://github.com/[^/]+/([^/]+)') AS repo,
		COUNT(v.url) AS visits_url_count,
		SUM(u.visit_count) AS urls_visit_count_sum,
		TO_TIMESTAMP((v.visit_time / 1000000) - h.seconds_diff) AS _visit_time
	FROM
		_helper h,
		urls u
		JOIN visits v ON u.id = v.url
	WHERE
		u.url LIKE 'https://github.com/%/%'
		AND u.url NOT SIMILAR TO 'https://github.com/(settings|users|login)/%'
	GROUP BY
		u.url,
		v.visit_time,
		h.seconds_diff
)
-- query
SELECT
	concat(github_user, '/', repo) AS repo,
	SUM(d.urls_visit_count_sum) AS visited_count
FROM
	_github d
WHERE
	d._visit_time > CURRENT_DATE - INTERVAL '1 year'
	AND d.github_user NOT IN('ThaddeusJiang', 'jiang-jifa', 'moji-inc', 'plugoinc', 'TeamSamurai')
GROUP BY
	repo,
	github_user
ORDER BY
	visited_count DESC
LIMIT 10
