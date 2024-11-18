/*
init
*/
DROP DATABASE IF EXISTS sample_vector_db;
CREATE DATABASE sample_vector_db;
-- connect the created vectore db
\c sample_vector_db;
-- create extension
DROP EXTENSION IF EXISTS vector;
CREATE EXTENSION vector;
-- create table
-- ref: https://github.com/pgvector/pgvector
DROP TABLE IF EXISTS items;
CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));
-- insert vectors
INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');
