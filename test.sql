test=> ALTER TABLE films ADD lexemesSummary tsvector;
ALTER TABLE
test=> UPDATE films SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229
test=> SELECT url FROM films WHERE lexemesSummary @@ to_tsquery('pirate');
