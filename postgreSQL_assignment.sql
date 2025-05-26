-- Active: 1747562696861@@localhost@5432@conservation_db

CREATE DATABASE conservation_db;


CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150),
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) CHECK (conservation_status IN ('Least Concern', 'Vulnerable', 'Endangered', 'Critically Endangered', 'Historic'))
);


CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    species_id INT REFERENCES species(species_id) ON DELETE CASCADE,
    sighting_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(150),
    notes TEXT
);


INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range'),
('David Lee', 'Eastern Forest'),
('Eva Johnson', 'Southern Wetlands'),
('Frank Miller', 'Northern Hills'),
('Grace Kim', 'River Delta'),
('Nazrul Islam', 'Mountain Range');




INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES
('Shadow Leopard', 'Panthera nebulosa', '1999-05-22', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered'),
('Great Hornbill', 'Buceros bicornis', '1824-08-15', 'Vulnerable'),
('Clouded Leopard', 'Neofelis nebulosa', '1821-03-04', 'Endangered'),
('Indian Pangolin', 'Manis crassicaudata', '1800-01-01', 'Least Concern'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered');




INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL),
(5, 4, 4, 'Riverbend', '2024-06-01 08:15:00', 'Seen crossing the river'),
(6, 5, 5, 'Hilltop', '2024-06-03 14:50:00', 'Solo individual spotted'),
(7, 6, 6, 'Forest Edge', '2024-06-05 11:30:00', 'Pair observed near nest'),
(8, 7, 7, 'Marshland', '2024-06-07 17:45:00', 'Tracks found in mud');


--Problem 1
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');


--Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

--Problem 3

SELECT * 
FROM sightings
WHERE location ILIKE '%Pass%';


--Problem 4

SELECT rangers.name, COUNT(sightings.sighting_id) AS total_sightings
FROM rangers
LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.name



--Problem 5

SELECT common_name
FROM species
WHERE species_id NOT IN (
    SELECT DISTINCT species_id
    FROM sightings
);



--Problem 6

SELECT species.common_name, sightings.sighting_time, rangers.name
FROM sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;


--Problem 7

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';



--Problem 8

SELECT
  sighting_id,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;



--Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);













