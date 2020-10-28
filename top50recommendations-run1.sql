/* Run 1: Recommendations based on Summary text - movie: Goal! (Keyword: Soccer)*/


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
test=> SELECT * FROM films1 where url='goal!-the-dream-begins';
test=> ALTER TABLE films1 ADD lexemesSummary tsvector;
ALTER TABLE
test=> UPDATE films1 SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229

/* Check films with soccer in the summary */
test=> SELECT url FROM films1 WHERE lexemesSummary @@ to_tsquery('soccer');
                                url                                
-------------------------------------------------------------------
 bella
 goal!-the-dream-begins
 next-goal-wins
 once-in-a-lifetime-the-extraordinary-story-of-the-new-york-cosmos
 playing-for-keeps
 timbuktu
 woman-is-the-future-of-man
 the-year-my-parents-went-on-vacation
(8 rows)

/* Create recommender system & export csv file */
test=> ALTER TABLE films1 ADD rank float4;
ALTER TABLE
test=> UPDATE films1 SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM films1 WHERE url='goal!-the-dream-begins')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField1 AS SELECT url, rank FROM films1 WHERE rank > 0.1 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField1) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 50
