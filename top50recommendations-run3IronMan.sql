/* Run 3: Recommendations based on Starring text - movie: Iron Man (Keyword: Downey)*/


/* Open map RSL & open test database */
cd RSL
psql test

/* Make the table and copy the data from the csv file */
CREATE TABLE films3 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);
\copy films3  FROM '/home/pi/RSL//moviesFromMetacritic.csv' delimiter ';' csv header ;

/* Select the film and add lexemes */
SELECT * FROM films3 where url='iron-man';
ALTER TABLE films3 ADD lexemesStarring tsvector;
UPDATE films3 SET lexemesStarring  = to_tsvector(Starring);

/* Check films with Downey in the starring */
SELECT url FROM films3 WHERE lexemesStarring  @@ to_tsquery('Downey');

/* Create recommender system & export csv file */
ALTER TABLE films3 ADD rank float4;
UPDATE films3 SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM films3 WHERE url='iron-man')));
CREATE TABLE recommendationsBasedOnSummaryField311 AS SELECT url, rank FROM films3 WHERE rank > 0.0001 ORDER BY rank DESC LIMIT 50;
\copy (SELECT * FROM recommendationsBasedOnSummaryField311) to '/home/pi/RSL/top50recommendations.csv' WITH csv;

