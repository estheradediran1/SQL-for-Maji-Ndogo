-- to view the tables in the database and explore the database
SHOW TABLES; 

-- this queries the location table which has information on a specific location, with an address, the province and town the location is in, and if it'sin a city (Urban) or not. 
SELECT *
FROM md_water_services.location
LIMIT 10;

-- this queries the visit table and gives a list of location_id, source_id, record_id, and a date and time,
SELECT *
FROM md_water_services.visits
LIMIT 5;

-- step 1: Discover the type of water source I will be dealing with
SELECT DISTINCT type_of_water_source
FROM md_water_services.water_source;

-- Step 2: Query the visit table to know where people queue for the longest (in minutes i.e 500 mins)
SELECT *
FROM md_water_services.visits
WHERE time_in_queue > 500;

-- Step 3: Query to assess the quality of the water sources
SELECT *
FROM md_water_services.water_quality
WHERE subjective_quality_score = 10
AND visit_count = 2;

-- Step 4: Query to investigate pollution issues
SELECT *
FROM md_water_services.well_pollution
LIMIT 5;

-- Step 5: Query to know whether test results for well pollution is clean but biological contamination is >0.01 (0= clean >0.01= contaminated)
SELECT *
FROM md_water_services.well_pollution
WHERE results = 'CLEAN'
AND biological > 0.01;

-- It seems like, in some cases, if the description field begins with the word “Clean”, the results have been classified as “Clean” in the results column, even though the biological column is > 0.01.
SELECT *
FROM md_water_services.well_pollution
WHERE description LIKE 'clean_%';

	 -- Case 1a: Update descriptions that mistakenly mention `Clean Bacteria: E. coli` to `Bacteria: E. coli`
SET sql_safe_updates = 0;

UPDATE md_water_services.well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria:E. coli';

	-- Case 1b: Update descriptions that mistakenly mention `Clean Bacteria: Giardia Lamblia` to `Bacteria: Giardia Lamblia`
UPDATE md_water_services.well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

	-- Case 1c: Update the `result` to `Contaminated: Biological` where `biological` is greater than 0.01 plus current results is `Clean`
UPDATE md_water_services.well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = 'Clean';

-- To confirm my table has been successfully updated
SELECT *
FROM md_water_services.well_pollution
WHERE biological > 0.01 AND results = 'Clean'

-- SEE YOU IN PART 2 :)