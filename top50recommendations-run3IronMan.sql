/* Run 3: Recommendations based on Starring text - movie: Wolf of wall street (Keyword: DiCaprio)*/


/* Open map RSL & open test database */
pi@raspberrypi:~/RSL $ psql test
psql (11.7 (Raspbian 11.7-0+deb10u1))
Type "help" for help.

/* Make the table and copy the data from the csv file */
test=> CREATE TABLE films3 (url text, title text, ReleaseDate text, Distributor text, Starring text, Summary text, Director text, Genre text, Rating text, Runtime text, Userscore text, Metascore text, scoreCounts text);
CREATE TABLE
test=> \copy films3  FROM '/home/pi/RSL//moviesFromMetacritic.csv' delimiter ';' csv header ;
COPY 5229

/* Select the film and add lexemes */
test=> SELECT * FROM films3 where url='iron-man';
test=> ALTER TABLE films3 ADD lexemesStarring tsvector;
ALTER TABLE
test=> UPDATE films3 SET lexemesStarring  = to_tsvector(Starring);
UPDATE 5229

/* Check films with Downey in the starring */
test=> SELECT url FROM films3 WHERE lexemesStarring  @@ to_tsquery('Downey');
           url            
--------------------------
 tair-america
 avengers-age-of-ultron
 chaplin
 chef
 due-date
 vocateur-the-morton-downey-jr-movie
 gothika
 home-for-the-holidays
 iron-man
 iron-man-2
 iron-man-3
 kiss-kiss-bang-bang
 captain-america-civil-war
 a-scanner-darkly
 sherlock-holmes
 sherlock-holmes-a-game-of-shadows
 the-singing-detective
 the-soloist
 spider-man-homecoming
 tropic-thunder
 us-marshals


/* Create recommender system & export csv file */
test=> ALTER TABLE films3 ADD rank float4;
ALTER TABLE
test=> UPDATE films3 SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM films3 WHERE url='iron-man')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnSummaryField311 AS SELECT url, rank FROM films3 WHERE rank > 0.0001 ORDER BY rank DESC LIMIT 50;
SELECT 40
test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField311) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 40
