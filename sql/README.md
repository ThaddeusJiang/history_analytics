# SQLite schema -> Postgres schema

```sql
sqlite3 ./_data/arc/History.db .schema > ./sql/psql_schema.sql
```

Modify something

- [x] replace `INTEGER PRIMARY KEY` to `SERIAL PRIMARY KEY`
- [x] replace `INTEGER` to `BIGINT`
- [x] remove `AUTOINCREMENT`
- [x] replace `longvarchar` to `TEXT`
- [x] replace `offset` to `"offset"`
