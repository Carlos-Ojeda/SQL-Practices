-- Subquery
  -- Subquery in WHERE (example: WHERE column_example <= {SUBQUERY});
  -- Subquery as a derived table in a FROM clause, example:
      SELECT round(calcs.average, 0) as average,
             calcs.median,
             round(calcs.average - calcs.median, 0) AS median_average_diff
      FROM (
           SELECT avg(pop_est_2019) AS average,
                  percentile_cont(.5)
                      WITHIN GROUP (ORDER BY pop_est_2019)::numeric AS median
           FROM us_counties_pop_est_2019
           )
      AS calcs;
  -- Subquery in JOIN (as derived table)
  -- Subquery as a column, example:
      SELECT county_name,
           state_name AS st,
           pop_est_2019,
           (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019)
            FROM us_counties_pop_est_2019) AS us_median
      FROM us_counties_pop_est_2019;
  -- Subquery in calculation, example:
      SELECT county_name,
           state_name AS st,
           pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019)
                           FROM us_counties_pop_est_2019) AS diff_from_median
  -- Subquery to get values from other table:
      SELECT column1_table1, column2_table1
      FROM table1
      WHERE column3_table1 IN ( -- If it returns NULL values, IN wont work
          SELECT column1_table2
          FROM table2)
      ORDER BY column3_table1;
    -- or
      SELECT column1_table1, column2_table1
      FROM table1
      WHERE EXISTS (
          SELECT column1_table2
          FROM table2
          WHERE id = table1.column3_table1);
          
  -- Lateral Subqueries, example:
      SELECT county_name,
             state_name,
             pop_est_2018,
             pop_est_2019,
             raw_chg,
             round(pct_chg * 100, 2) AS pct_chg
      FROM us_counties_pop_est_2019,
           LATERAL (SELECT pop_est_2019 - pop_est_2018 AS raw_chg) rc,
           LATERAL (SELECT raw_chg / pop_est_2018::numeric AS pct_chg) pc
      ORDER BY pct_chg DESC;
      
  -- CTE (Common Table Expressions), we create a temporary table to minimize code, example:
      WITH 
      temporary_table_name (c1, c2, c3)
      AS (
          SELECT c1, c2, c3
          FROM stable_table_name
          WHERE c1 >= 100000
         )
      SELECT c1, count(*)
      FROM temporary_table_name
      GROUP BY c1
      ORDER BY count(*) DESC;
     -- or, we can create multiple temporary tables:
     WITH
          counties (st, pop_est_2018) AS
          (SELECT state_name, sum(pop_est_2018)
           FROM us_counties_pop_est_2019
           GROUP BY state_name),

          establishments (st, establishment_count) AS
          (SELECT st, sum(establishments) AS establishment_count
           FROM cbp_naics_72_establishments
           GROUP BY st)

      SELECT counties.st,
             pop_est_2018,
             establishment_count,
             round((establishments.establishment_count / 
                    counties.pop_est_2018::numeric(10,1)) * 1000, 1)
                 AS estabs_per_thousand
      FROM counties JOIN establishments
      ON counties.st = establishments.st
      ORDER BY estabs_per_thousand DESC;
