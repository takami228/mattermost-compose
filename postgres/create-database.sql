-- Mattermost
-- https://github.com/mattermost/mattermost-docker
CREATE USER mattermost PASSWORD 'mattermost';
CREATE DATABASE mattermost;
GRANT ALL PRIVILEGES ON DATABASE mattermost TO mattermost;
