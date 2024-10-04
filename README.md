# History Analytics

- [x] History of Arc Browser
- [ ] History of Safari
- [ ] History of Chromium like Browsers
- [ ] macOS terminal

## Made with

- [SQLite](https://www.sqlite.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [pgloader](https://github.com/dimitri/pgloader)
- [Metabase](https://www.metabase.com/)

# Preview

https://github.com/user-attachments/assets/bcc22c29-f48b-418a-a951-a5b9b82b3c30

## Prepare Data

1. copy Browser History

```sh
mkdir _data
cp ~/Library/Application\ Support/Arc/User\ Data/Default/History ./_data/arc/history.db
```

2. create db

```sh
createdb arc_history_copy

psql arc_history_copy < sql/psql_schema.sql
```

3. load data

```sh
brew install pgloader

pgloader db.load
```

## Start

```sh
docker compose up
```
