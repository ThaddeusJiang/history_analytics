WITH
  GitHubData AS (
    SELECT
      u.url,
      -- 提取 user
      CASE
        WHEN instr (u.url, 'github.com/') > 0 THEN substr (u.url, instr (u.url, 'github.com/') + 11, instr (substr (u.url, instr (u.url, 'github.com/') + 11), '/') - 1)
        ELSE NULL
      END AS user,
      u.visit_count,
      u.typed_count
    FROM
      urls u
    WHERE
      u.url LIKE '%github.com%' -- 筛选包含 github.com 的 URL
      AND USER NOT IN ('/', 'ThaddeusJiang', 'jiang-jifa', 'settings')
  ),
  TopUsers AS (
    SELECT
      user,
      SUM(visit_count) AS total_visits
    FROM
      GitHubData
    GROUP BY
      USER
    ORDER BY
      total_visits DESC
  )
SELECT
  *
FROM
  TopUsers
LIMIT
  10;
