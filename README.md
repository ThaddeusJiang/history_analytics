# History Analytics

- [x] History of Arc Browser
- [ ] History of Safari
- [ ] History of Chromium like Browsers
- [ ] macOS terminal

## Prepare Arc History Data

1. copy History to workspace

```sh
mkdir _data
cp ~/Library/Application\ Support/Arc/User\ Data/Default/History ./_data/arc/history.db
```

2. SQLite to PostgreSQL

```sh
createdb arc_history_copy

psql arc_history_copy < sql/psql_schema.sql
```

3. load database

```sh
brew install pgloader

pgloader db.load
```
