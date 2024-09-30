WITH _twitter AS (
	SELECT
		LOWER(SUBSTRING(u.url FROM 'twitter.com/([^/]+)')) AS twitter_username,
		SUM(u.visit_count) AS total_visit_count
	FROM
		urls u
	WHERE
		u.url LIKE '%twitter.com/%'
		AND u.url NOT SIMILAR TO '%twitter.com/(home|notifications|compose|i|messages|explore|settings|account|search|hashtag)%'
	GROUP BY
		twitter_username
)
-- query
SELECT
	twitter_username,
	total_visit_count
FROM
	_twitter t
WHERE
	twitter_username IS NOT NULL
	AND twitter_username NOT IN('thaddeusjiang', 'amami_hara', 'aierdotapp', 'twitter')
ORDER BY
	total_visit_count DESC
	LIMIT 10
