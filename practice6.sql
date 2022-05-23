-- Index:
  -- Indexes represent the data with another data structure (trees or hashes) to efficiently perform a given query.
    CREATE TABLE new_york_addresses (
        longitude numeric(9,6),
        latitude numeric(9,6),
        street_number text,
        street text,
        unit text,
        postcode text,
        id integer CONSTRAINT new_york_key PRIMARY KEY
    );

    COPY new_york_addresses
    FROM '/temp/city_of_new_york.csv'
    WITH (FORMAT CSV, HEADER);


    SELECT * FROM new_york_addresses -- compare the time required (1 secs 336 msec).
    WHERE street = 'BROADWAY';

    -- Creating a B-tree index on the street column from new_york_addresses table:

    CREATE INDEX street_idx ON new_york_addresses (street);

    SELECT * FROM new_york_addresses -- compare the time required (630 msec).
    WHERE street = 'BROADWAY';
