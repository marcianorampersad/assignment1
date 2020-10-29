/* Run 1: Recommendations based on Summary text - movie: Iron Man (Keyword: iron-man)*/


/* Open map RSL & open test database */
pi@raspberrypi:~ $ cd RSL
pi@raspberrypi:~/RSL $ psql test
psql (11.7 (Raspbian 11.7-0+deb10u1))
Type "help" for help.

/* Make the table and copy the data from the csv file */
test=> CREATE TABLE films1 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);
CREATE TABLE
test=> \copy films1  FROM '/home/pi/RSL//moviesFromMetacritic.csv' delimiter ';' csv header ;
COPY 5229

/* Select the film and add lexemes */
test=> SELECT * FROM films1 where url='iron-man';
test=> ALTER TABLE films1 ADD lexemesSummary tsvector;
ALTER TABLE
test=> UPDATE films1 SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229

/* Check films with iron man in the summary */
test=> SELECT url FROM films1 WHERE lexemesSummary @@ to_tsquery('iron+man');
                                url                                
-------------------------------------------------------------------
 avengers-age-of-ultron
 iron-man
 iron-man-2
 iron-man-3
 natural-born-killers
 lore
 the-perfect-holiday
(7 rows)


/* Create recommender system & export csv file */
test=> ALTER TABLE films1 ADD rank float4;
ALTER TABLE
test=> UPDATE films1 SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM films1 WHERE url='iron-man')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField1 AS SELECT url, rank FROM films1 WHERE rank > 0.1 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField1) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 50
