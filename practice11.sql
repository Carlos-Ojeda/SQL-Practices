-- Mining text (getting data that could be used in AI)
  -- > strings
    -- Case formatting:
      SELECT upper('Neal7');
      SELECT lower('Randy');
      SELECT initcap('at the end of the day');
      -- Note initcap's imperfect for acronyms
      SELECT initcap('Practical SQL'); -- > Practical Sql
    -- Character data:
      SELECT char_length(' Pat ');
      SELECT length(' Pat ');
      SELECT position(', ' in 'Tan, Bella');
    -- Removing characters
      SELECT trim('s' from 'socks');
      SELECT trim(trailing 's' from 'socks');
      SELECT trim(' Pat ');
      SELECT ltrim('socks', 's');
      SELECT rtrim('socks', 's');
    -- Extract or replace characters:
      SELECT left('703-555-1212', 3);
      SELECT right('703-555-1212', 8);
      SELECT replace('bat', 'b', 'c');

  -- > regular expression (we can use https://regex101.com/ to practice regular expressions)
    -- Examples:
      -- One or digits followed by a.m. or p.m.:
        SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\d{1,2} (?:a.m.|p.m.)');
      -- Using it in WHERE clause:
        SELECT county_name
        FROM us_counties_pop_est_2019
        WHERE county_name ~* 'ash' AND county_name !~ 'Wash'
        ORDER BY county_name;
        
   -- > text search (with regular expressions)
    -- Creating and loading data for class excersice:
        CREATE TABLE crime_reports (
            crime_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
            case_number text,
            date_1 timestamptz,  -- note: this is the PostgreSQL shortcut for timestamp with time zone
            date_2 timestamptz,  -- note: this is the PostgreSQL shortcut for timestamp with time zone
            street text,
            city text,
            crime_type text,
            description text,
            original_text text NOT NULL
        );

        COPY crime_reports (original_text)
        FROM '/tmp/crime_reports.csv'
        WITH (FORMAT CSV, HEADER OFF, QUOTE '"');
        
    -- Challenge, create a regexp for Crime ID
        (C|SO)\d{9,10}
        (C0\d+)|(SO\d+)
