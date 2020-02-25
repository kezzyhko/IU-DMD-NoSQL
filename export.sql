--
-- NOTE:
--
-- File paths need to be edited. Search for C:/Users/kezzyhko/Desktop/DMD/CSV and
-- replace it with the path to the directory desired to contain .CSV files
--



DO $$
DECLARE
	row RECORD;
	path VARCHAR;
BEGIN 
	FOR row IN
		SELECT tablename FROM pg_tables WHERE schemaname='public'
	LOOP
        path := concat('C:/Users/kezzyhko/Desktop/DMD/CSV/', row.tablename, '.csv');
        EXECUTE format('COPY %I TO %L WITH (FORMAT CSV, HEADER, FORCE_QUOTE *);', row.tablename, path);
	END LOOP;
END;
$$;