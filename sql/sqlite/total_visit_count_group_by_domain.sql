SELECT
  CASE
    WHEN instr (url, '://') > 0 THEN substr (url, instr (url, '://') + 3, instr (substr (url, instr (url, '://') + 3), '/') - 1)
    ELSE substr (url, 1, instr (url, '/') - 1)
  END AS domain,
  SUM(visit_count) as total_visit_count
FROM
  urls
WHERE
  instr (DOMAIN, ':') = 0
GROUP BY
  DOMAIN
ORDER BY
  total_visit_count DESC
LIMIT
  100
