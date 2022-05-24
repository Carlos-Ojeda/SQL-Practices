-- Clean up data
  -- Finding duplicates 
  -- indentify the columns
  -- use GROUP BY [..] HAVING to select that columns
  
  SELECT company,
      street,
      city,
      st,
      count(*) AS address_count
  FROM meat_poultry_egg_establishments
  GROUP BY company, street, city, st
  HAVING count(*) > 1
  ORDER BY company, street, city, st;
  -- or
  SELECT st, 
      count(*) AS st_count
  FROM meat_poultry_egg_establishments
  GROUP BY st
  ORDER BY st; -- here, you could add NULL FIRST

-- Missing data
  -- Records with NULL values 
  -- use GROUP BY [..] HAVING to select that columns
  
-- Constraints for specific columns
  SELECT length(zip),
         count(*) AS length_count
  -- You could include a WHERE constraint (for example "WHERE length(zip) < 5")
  FROM meat_poultry_egg_establishments
  GROUP BY length(zip)
  ORDER BY length(zip) ASC;

-- Backup data
  -- Tale:
    CREATE TABLE new_table_name AS  -- Here you modify the data
    SELECT * FROM old_table_name;
    
    UPDATE meat_poultry_egg_establishments original -- And then restore it
    SET st = backup.st
    FROM meat_poultry_egg_establishments_backup backup
    WHERE original.establishment_number = backup.establishment_number
    
  -- Column:
      ALTER TABLE new_table_name ADD COLUMN column_copy text; -- Here you modify the data
      
      UPDATE meat_poultry_egg_establishments  -- And then restore it
      SET st_copy = st;

-- Challenge:
  -- Add a new column (meat_processing) and set true to 
      ALTER TABLE meat_poultry_egg_establishments ADD COLUMN meat_processing boolean;

      UPDATE meat_poultry_egg_establishments 
      SET meat_processing = true
      WHERE activities LIKE '%Meat Processing%';
      
-- Transactions:
  -- Group database operations to **update data**, and then we can ROLLBACK or COMIMIT (to have a secure data enviroment)
      START TRANSACTION;

      UPDATE meat_poultry_egg_establishments
      SET company = 'AGRO Merchantss Oakland LLC'
      WHERE company = 'AGRO Merchants Oakland, LLC';

      -- view changes
      SELECT company FROM meat_poultry_egg_establishments WHERE company LIKE 'AGRO%' ORDER BY company;

      -- Revert changes
      ROLLBACK;

      -- See restored state
      SELECT company FROM meat_poultry_egg_establishments WHERE company LIKE 'AGRO%' ORDER BY company;

      -- ALTERNATELY, commit changes at the end:
      START TRANSACTION;
