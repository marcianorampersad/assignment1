/* Run 2: Recommendations based on title text - movie: Cool runnings! (Keyword: runnings)*/


/* Open map RSL & open test database */
pi@raspberrypi:~/RSL $ psql test
psql (11.7 (Raspbian 11.7-0+deb10u1))
Type "help" for help.

/* Make the table and copy the data from the csv file */
test=> CREATE TABLE films2 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);
CREATE TABLE
test=> \copy films2  FROM '/home/pi/RSL//moviesFromMetacritic.csv' delimiter ';' csv header ;
COPY 5229

/* Select the film and add lexemes */
test=> SELECT * FROM films2 where url='cool-runnings';
test=> ALTER TABLE films2 ADD lexemesTitle tsvector;
ALTER TABLE
test=> UPDATE films2 SET lexemesTitle = to_tsvector(title);
UPDATE 5229

/* Check films with soccer in the summary */
test=> SELECT url FROM films2 WHERE lexemesTitle @@ to_tsquery('runnings');
                   url                    
------------------------------------------
 running-from-crazy
 hit-and-run
 the-running-man
 the-cannonball-run
 chicken-run
 cool-runnings
 running-scared
 midnight-run
 run-all-night
 run-lola-run
 see-spot-run
 running-free
 showrunners-the-art-of-running-a-tv-show
(13 rows)

/* Create recommender system & export csv file */
test=> ALTER TABLE films2 ADD rank float4;
ALTER TABLE
test=> UPDATE films2 SET rank = ts_rank(lexemesTitle,plainto_tsquery((SELECT title FROM films2 WHERE url='cool-runnings')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField2 AS SELECT url, rank FROM films2 WHERE rank > 0.1 ORDER BY rank DESC LIMIT 50;
SELECT 0
test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField2) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 0
