SELECT
  LOWER(
    CASE
      WHEN instr (u.url, 'twitter.com/') > 0 THEN substr (
        u.url,
        instr (u.url, 'twitter.com/') + length ('twitter.com/'),
        instr (substr (u.url, instr (u.url, 'twitter.com/') + length ('twitter.com/')), '/') - 1
      )
      ELSE substr (u.url, instr (u.url, 'twitter.com/') + length ('twitter.com/'))
    END
  ) AS USER,
  SUM(u.visit_count) AS total_visit,
  SUM(u.typed_count) AS total_typed
FROM
  urls u
  JOIN visits v ON u.id = v.url
WHERE
  u.url LIKE '%https://twitter.com/%'
  AND u.url NOT LIKE '%?q=%'
  AND USER NOT IN ('home', 'explore', 'notifications', 'messages', 'login', 'i', 'compose', 'settings', 'search', 'hashtag', 'account')
  AND USER NOT IN ('', '/', 'twitter', 'thaddeusjiang', 'amami_hara', 'aierdotapp')
GROUP BY
  USER
ORDER BY
  total_visit DESC,
  total_typed DESC
LIMIT
  10;
