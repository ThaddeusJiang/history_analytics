WITH _github AS (
	SELECT
		LOWER(SUBSTRING(u.url FROM 'https://github.com/([^/]+/[^/]+)')) AS user_repo,
		SUM(u.visit_count) AS repo_visit_count
	FROM
		urls u
	WHERE
		u.url LIKE 'https://github.com/%/%'
		AND u.url NOT SIMILAR TO 'https://github.com/(settings|users|login)/%'
	GROUP BY
		user_repo
)
-- query
SELECT
	user_repo,
	repo_visit_count
FROM
	_github d
ORDER BY
	repo_visit_count DESC
LIMIT 50
