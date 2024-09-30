WITH _github AS (
	SELECT
		LOWER(SUBSTRING(u.url FROM 'https://github.com/([^/]+/[^/]+)')) AS user_repo
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
	count(user_repo)
FROM
	_github d
