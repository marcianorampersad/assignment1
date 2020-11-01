/* Run 1: Recommendations based on Summary text - movie: Iron Man (Keyword: iron-man)*/


/* Open map RSL & open test database */
cd RSL
psql test

/* Make the table and copy the data from the csv file */
CREATE TABLE films1 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);
CREATE TABLE
\copy films1  FROM '/home/pi/RSL//moviesFromMetacritic.csv' delimiter ';' csv header ;


/* Select the film and add lexemes */
SELECT * FROM films1 where url='iron-man';
ALTER TABLE films1 ADD lexemesSummary tsvector;
UPDATE films1 SET lexemesSummary = to_tsvector(Summary);


/* Check films with iron man in the summary */
SELECT url FROM films1 WHERE lexemesSummary @@ to_tsquery('iron+man');
                                                             
/* Create recommender system & export csv file */
ALTER TABLE films1 ADD rank float4;

UPDATE films1 SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM films1 WHERE url='iron-man')));
CREATE TABLE recommendationsBasedOnSummaryField1 AS SELECT url, rank FROM films1 WHERE rank > 0.1 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM recommendationsBasedOnSummaryField1) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
