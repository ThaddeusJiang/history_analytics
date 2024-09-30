-- Drop tables if they exist
DROP TABLE IF EXISTS clusters_and_visits CASCADE;

DROP TABLE IF EXISTS cluster_visit_duplicates CASCADE;

DROP TABLE IF EXISTS cluster_keywords CASCADE;

DROP TABLE IF EXISTS segments CASCADE;

DROP TABLE IF EXISTS segment_usage CASCADE;

DROP TABLE IF EXISTS content_annotations CASCADE;

DROP TABLE IF EXISTS context_annotations CASCADE;

DROP TABLE IF EXISTS downloads_slices CASCADE;

DROP TABLE IF EXISTS downloads_url_chains CASCADE;

DROP TABLE IF EXISTS downloads CASCADE;

DROP TABLE IF EXISTS visit_source CASCADE;

DROP TABLE IF EXISTS keyword_search_terms CASCADE;

DROP TABLE IF EXISTS visits CASCADE;

DROP TABLE IF EXISTS urls CASCADE;

DROP TABLE IF EXISTS meta CASCADE;

DROP TABLE IF EXISTS clusters CASCADE;

DROP TABLE IF EXISTS history_sync_metadata CASCADE;

DROP TABLE IF EXISTS visited_links CASCADE;

-- Create tables
CREATE TABLE
  meta (key TEXT NOT NULL UNIQUE PRIMARY KEY, value TEXT);

CREATE TABLE
  urls (
    id SERIAL PRIMARY KEY,
    url TEXT NOT NULL,
    title TEXT,
    visit_count BIGINT DEFAULT 0 NOT NULL,
    typed_count BIGINT DEFAULT 0 NOT NULL,
    last_visit_time BIGINT NOT NULL,
    hidden BIGINT DEFAULT 0 NOT NULL
  );

CREATE TABLE
  visits (
    id SERIAL PRIMARY KEY,
    url BIGINT NOT NULL REFERENCES urls (id),
    visit_time BIGINT NOT NULL,
    from_visit BIGINT,
    transition BIGINT DEFAULT 0 NOT NULL,
    segment_id BIGINT,
    visit_duration BIGINT DEFAULT 0 NOT NULL,
    incremented_omnibox_typed_score BOOLEAN DEFAULT FALSE NOT NULL,
    opener_visit BIGINT,
    originator_cache_guid TEXT,
    originator_visit_id BIGINT,
    originator_from_visit BIGINT,
    originator_opener_visit BIGINT,
    is_known_to_sync BOOLEAN DEFAULT FALSE NOT NULL,
    consider_for_ntp_most_visited BOOLEAN DEFAULT FALSE NOT NULL,
    external_referrer_url TEXT,
    visited_link_id BIGINT,
    app_id TEXT
  );

CREATE TABLE
  visit_source (id SERIAL, source BIGINT NOT NULL);

CREATE INDEX visits_url_index ON visits (url);

CREATE INDEX visits_from_index ON visits (from_visit);

CREATE INDEX visits_time_index ON visits (visit_time);

CREATE INDEX visits_originator_id_index ON visits (originator_visit_id);

CREATE TABLE
  keyword_search_terms (keyword_id BIGINT NOT NULL, url_id BIGINT NOT NULL, term TEXT NOT NULL, normalized_term TEXT NOT NULL);

CREATE INDEX keyword_search_terms_index1 ON keyword_search_terms (keyword_id, normalized_term);

CREATE INDEX keyword_search_terms_index2 ON keyword_search_terms (url_id);

CREATE INDEX keyword_search_terms_index3 ON keyword_search_terms (term);

CREATE TABLE
  downloads (
    id SERIAL,
    guid VARCHAR NOT NULL,
    current_path TEXT NOT NULL,
    target_path TEXT NOT NULL,
    start_time BIGINT NOT NULL,
    received_bytes BIGINT NOT NULL,
    total_bytes BIGINT NOT NULL,
    state BIGINT NOT NULL,
    danger_type BIGINT NOT NULL,
    interrupt_reason BIGINT NOT NULL,
    hash BYTEA NOT NULL,
    end_time BIGINT NOT NULL,
    opened BIGINT NOT NULL,
    last_access_time BIGINT NOT NULL,
    transient BIGINT NOT NULL,
    referrer VARCHAR NOT NULL,
    site_url VARCHAR NOT NULL,
    embedder_download_data VARCHAR NOT NULL,
    tab_url VARCHAR NOT NULL,
    tab_referrer_url VARCHAR NOT NULL,
    http_method VARCHAR NOT NULL,
    by_ext_id VARCHAR NOT NULL,
    by_ext_name VARCHAR NOT NULL,
    etag VARCHAR NOT NULL,
    last_modified VARCHAR NOT NULL,
    mime_type VARCHAR(255) NOT NULL,
    original_mime_type VARCHAR(255) NOT NULL,
    by_web_app_id VARCHAR NOT NULL DEFAULT ''
  );

CREATE TABLE
  downloads_url_chains (id BIGINT NOT NULL, chain_index BIGINT NOT NULL, url TEXT NOT NULL, PRIMARY KEY (id, chain_index));

CREATE TABLE
  downloads_slices (
    download_id BIGINT NOT NULL,
    "offset" BIGINT NOT NULL, -- Use quotes to treat "offset" as a column name
    received_bytes BIGINT NOT NULL,
    finished BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (download_id, "offset")
  );

CREATE TABLE
  segments (id SERIAL, name VARCHAR, url_id BIGINT NOT NULL);

CREATE INDEX segments_name ON segments (name);

CREATE INDEX segments_url_id ON segments (url_id);

CREATE TABLE
  segment_usage (id SERIAL, segment_id BIGINT NOT NULL, time_slot BIGINT NOT NULL, visit_count BIGINT DEFAULT 0 NOT NULL);

CREATE INDEX segment_usage_time_slot_segment_id ON segment_usage (time_slot, segment_id);

CREATE INDEX segments_usage_seg_id ON segment_usage (segment_id);

CREATE TABLE
  content_annotations (
    visit_id SERIAL,
    visibility_score NUMERIC,
    floc_protected_score NUMERIC,
    categories VARCHAR,
    page_topics_model_version BIGINT,
    annotation_flags BIGINT NOT NULL,
    entities VARCHAR,
    related_searches VARCHAR,
    search_normalized_url VARCHAR,
    search_terms TEXT,
    alternative_title VARCHAR,
    page_language VARCHAR,
    password_state BIGINT DEFAULT 0 NOT NULL,
    has_url_keyed_image BOOLEAN DEFAULT false NOT NULL
  );

CREATE TABLE
  context_annotations (
    visit_id SERIAL,
    context_annotation_flags BIGINT NOT NULL,
    duration_since_last_visit BIGINT,
    page_end_reason BIGINT,
    total_foreground_duration BIGINT,
    browser_type BIGINT DEFAULT 0 NOT NULL,
    window_id BIGINT DEFAULT -1 NOT NULL,
    tab_id BIGINT DEFAULT -1 NOT NULL,
    task_id BIGINT DEFAULT -1 NOT NULL,
    root_task_id BIGINT DEFAULT -1 NOT NULL,
    parent_task_id BIGINT DEFAULT -1 NOT NULL,
    response_code BIGINT DEFAULT 0 NOT NULL
  );

CREATE TABLE
  clusters_and_visits (
    cluster_id BIGINT NOT NULL,
    visit_id BIGINT NOT NULL,
    score NUMERIC NOT NULL,
    engagement_score NUMERIC NOT NULL,
    url_for_deduping TEXT NOT NULL,
    normalized_url TEXT NOT NULL,
    url_for_display TEXT NOT NULL,
    interaction_state BIGINT DEFAULT 0 NOT NULL,
    PRIMARY KEY (cluster_id, visit_id)
  );

CREATE INDEX clusters_for_visit ON clusters_and_visits (visit_id);

CREATE TABLE
  cluster_keywords (
    cluster_id BIGINT NOT NULL,
    keyword VARCHAR NOT NULL,
    type BIGINT NOT NULL,
    score NUMERIC NOT NULL,
    collections VARCHAR NOT NULL
  );

CREATE INDEX cluster_keywords_cluster_id_index ON cluster_keywords (cluster_id);

CREATE TABLE
  cluster_visit_duplicates (visit_id BIGINT NOT NULL, duplicate_visit_id BIGINT NOT NULL, PRIMARY KEY (visit_id, duplicate_visit_id));

-- CREATE INDEX urls_url_index ON urls (url);
CREATE INDEX urls_url_hash_index ON urls (md5 (url));

CREATE TABLE
  clusters (
    cluster_id SERIAL PRIMARY KEY,
    should_show_on_prominent_ui_surfaces BOOLEAN NOT NULL,
    label VARCHAR NOT NULL,
    raw_label VARCHAR NOT NULL,
    triggerability_calculated BOOLEAN NOT NULL,
    originator_cache_guid TEXT DEFAULT '' NOT NULL,
    originator_cluster_id BIGINT DEFAULT 0 NOT NULL
  );

CREATE TABLE
  history_sync_metadata (storage_key SERIAL NOT NULL, value BYTEA);

CREATE TABLE
  visited_links (
    id SERIAL PRIMARY KEY,
    link_url_id BIGINT NOT NULL,
    top_level_url TEXT NOT NULL,
    frame_url TEXT NOT NULL,
    visit_count BIGINT DEFAULT 0 NOT NULL
  );

CREATE INDEX visited_links_index ON visited_links (link_url_id, top_level_url, frame_url);
