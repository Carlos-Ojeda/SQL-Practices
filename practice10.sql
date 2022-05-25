-- PSQL extensions (adding capability SQL)
  -- You can see them with: SELECT * FROM pg_available_extensions;
  
  -- To Install the <X> function:
    CREATE EXTENSION <extension name>;
    
  -- CHALLENGE: instead of using the office as pivote, use the flavor:
    SELECT *
    FROM crosstab('SELECT flavor,
                          office,
                          count(*)
                   FROM ice_cream_survey
                   GROUP BY flavor, office
                   ORDER BY flavor',

                  'SELECT office
                   FROM ice_cream_survey
                   GROUP BY office
                   ORDER BY office')

    AS (office text,
        Downtown bigint,
        Midtown bigint,
        Uptown bigint);
    
  -- Another example:
    CREATE TABLE temperature_readings (
        station_name text,
        observation_date date,
        max_temp integer,
        min_temp integer,
        CONSTRAINT temp_key PRIMARY KEY (station_name, observation_date)
    );

    COPY temperature_readings
    FROM '/tmp/temperature_readings.csv'
    WITH (FORMAT CSV, HEADER);

    -- Generating the temperature readings CROSSTAB
    SELECT *
    FROM crosstab('SELECT
                      station_name,
                      date_part(''month'', observation_date),
                      percentile_cont(.5)
                          WITHIN GROUP (ORDER BY max_temp)
                   FROM temperature_readings
                   GROUP BY station_name,
                            date_part(''month'', observation_date)
                   ORDER BY station_name',

                  'SELECT month
                   FROM generate_series(1,12) month')
    AS (station text,
        jan numeric(3,0),
        feb numeric(3,0),
        mar numeric(3,0),
        apr numeric(3,0),
        may numeric(3,0),
        jun numeric(3,0),
        jul numeric(3,0),
        aug numeric(3,0),
        sep numeric(3,0),
        oct numeric(3,0),
        nov numeric(3,0),
        dec numeric(3,0)
    );

    -- Reclassifying temperature data with CASE (We can use thins on Peripheral Loans -IBM Project-)
    SELECT max_temp,
           CASE WHEN max_temp >= 90 THEN 'Hot'
                WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
                WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
                WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
                WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
                WHEN max_temp < 20 THEN 'Inhumane'
                ELSE 'No reading'
            END AS temperature_group
    FROM temperature_readings
    ORDER BY station_name, observation_date;
