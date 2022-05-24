-- Date and time
  -- Date: Monday 2nd 2022
  -- Time intervals: 
  -- Timestamp: date + time + time zon

  -- Extract components of a TIMESTAMP:
    -- date_part()
      SELECT date_part('year', '2022-12-01 18:37:12 EST'::timestamptz) AS year
    -- extract()
      SELECT extract(year from '2022-12-01 18:37:12 EST'::timestamptz) AS year

  -- Display a new date/time:
    -- SELECT make_date(YYYY, MM, DD);
    -- SELECT make_time(HH, MM, SS);
    -- SELECT make_timestamptz(YYYY, MM, DD, HH, MM, SS, 'America/Mexico_City');
    
  -- Display the current date and time:
      SELECT
        current_timestamp,
        localtimestamp,
        current_date,
        current_time,
        localtime,
        now();
        
  -- Setting time zone:
      SET TIME ZONE 'America/Mexico_City';
      -- (You can find your time zone with:
      --  SELECT * FROM pg_timezone_abbrevs ORDER BY abbrev;
      --  SELECT * FROM pg_timezone_names ORDER BY name;)
        
  -- Getting with time zone:
      SELECT test_date AT TIME ZONE 'Asia/Seoul'
      FROM time_zone_test;
      
  -- Math with dates:
      SELECT '1929-09-30'::timestamp + '5 years'::interval + '2 hours'::interval;
      
  -- Challenge: 
      -- Calculate the lenght of each ride. Sort the lenght from longest to shortest.
      
