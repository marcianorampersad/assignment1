/* Run 2: Recommendations based on title text - movie: Iron Man (Keyword: iron man)*/


/* Open map RSL & open test database */
psql test

/* Make the table and copy the data from the csv file */
CREATE TABLE films2 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);
\copy films2  FROM '/home/pi/RSL//moviesFromMetacritic.csv' delimiter ';' csv header ;

/* Select the film and add lexemes */
SELECT * FROM films2 where url='iron-man';
ALTER TABLE films2 ADD lexemesTitle tsvector;
UPDATE films2 SET lexemesTitle = to_tsvector(title);

/* Check films with iron man in the title */
SELECT url FROM films2 WHERE lexemesTitle @@ to_tsquery('iron+man');

/* Create recommender system & export csv file */
ALTER TABLE films2 ADD rank float4;
UPDATE films2 SET rank = ts_rank(lexemesTitle,plainto_tsquery((SELECT title FROM films2 WHERE url='iron-man')));
CREATE TABLE recommendationsBasedOnSummaryField2 AS SELECT url, rank FROM films2 WHERE rank > 0.0001 ORDER BY rank DESC LIMIT 50;
\copy (SELECT * FROM recommendationsBasedOnSummaryField2) to '/home/pi/RSL/top50recommendations.csv' WITH csv;

