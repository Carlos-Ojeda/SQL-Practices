-- View (used on really complex queries and restrict access to some columns/data)
  --> Regular View (basically used to restrict access)
    -- Create:
        CREATE OR REPLACE VIEW view_name AS
        SELECT column_name0,
               column_name1,
               column_name2
        FROM table_name;
    -- Access:
        SELECT * FROM view_name;
    -- Delete:
        DROP VIEW view_name;
        
  --> Materialized View (basically used to power its performance, kinda storage the result in a new table)
    -- Create:
        CREATE MATERIALIZED VIEW view_name AS
        SELECT column_name0,
               column_name1,
               column_name2
        FROM table_name;
    -- Refresh data:
        REFRESH MATERIALIZED VIEW view_name;


-- Function (can return value(s))
  -- Create:
      CREATE OR REPLACE FUNCTION function_name(param0 text, param1 text, param2 numeric, param3 integer DEFAULT 1)
      RETURNS text AS
      $$
      BEGIN
        RETURN LOWER(param0);
      END;
      $$ LANGUAGE plpsql;
  -- Calling:
      SELECT function_name(...);  -- We can create TRIGGERS (so themselves are called when something happens, but the function must be different)

-- Triggers (can return value(s))
  -- Create function for trigger:
      CREATE OR REPLACE FUNCTION function_name()
      RETURNS trigger AS
      $$
      BEGIN
          NEW.column_name := lower(NEW.column_name);
          RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
  -- Create trigger:
      CREATE TRIGGER trigger_name
      BEFORE INSERT
      ON table_name
      FOR EACH ROW
      EXECUTE PROCEDURE function/procedure_name();

-- Procedure (doesn't return any value)
  -- Create:
      CREATE OR REPLACE PROCEDURE procedure_name()
      AS $$
      BEGIN
          UPDATE table_name
          SET column_name...;
      END;
      $$
      LANGUAGE plpgsql;
