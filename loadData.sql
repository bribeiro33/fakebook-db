-- Users --
INSERT INTO Users (user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender)
SELECT DISTINCT user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender 
FROM project1.Public_User_Information;

-- Friends --
INSERT INTO Friends (user1_id, user2_id)
SELECT DISTINCT LEAST(user1_id, user2_id), GREATEST(user1_id, user2_id)
FROM project1.Public_Are_Friends;

-- Cities --
INSERT INTO Cities (city_name, state_name, country_name)
SELECT DISTINCT current_city, current_state, current_country
FROM project1.Public_User_Information
UNION
SELECT DISTINCT hometown_city, hometown_state, hometown_country
FROM project1.Public_User_Information
UNION
SELECT DISTINCT event_city, event_state, event_country
FROM project1.Public_Event_Information;

-- User Cities --
/* inner join acts as a filter - only cities that exist in both 
the public_ui and Cities tables are inserted into the "User_curr_city" table 
The Selecting occurs after the inner join has occured*/
INSERT INTO User_Current_Cities (user_id, current_city_id)
SELECT DISTINCT user_id, city_id
FROM project1.Public_User_Information P
INNER JOIN Cities C
    ON P.current_city = C.city_name
    AND P.current_state = C.state_name
    AND P.current_country = C.country_name;
-- Might need to also check that userid exists

-- User Hometown --
INSERT INTO User_Hometown_Cities (user_id, hometown_city_id)
SELECT DISTINCT user_id, city_id
FROM project1.Public_User_Information P
INNER JOIN Cities C
    ON P.hometown_city = C.city_name
    AND P.hometown_state = C.state_name
    AND P.hometown_country = C.country_name;

-- Messages Not in Public DB --

-- Programs --
INSERT INTO Programs (institution, concentration, degree)
SELECT DISTINCT institution_name, program_concentration, program_degree
FROM project1.Public_User_Information
WHERE institution_name IS NOT NULL
    AND program_concentration IS NOT NULL
    AND program_degree IS NOT NULL;

-- Education --
INSERT INTO Education (user_id, program_id, program_year)
SELECT DISTINCT user_id, program_id, program_year
FROM project1.Public_User_Information P
INNER JOIN Programs G
    ON P.institution_name = G.institution
    AND P.program_concentration = G.concentration
    AND P.program_degree = G.degree;

-- User Events --
INSERT INTO User_Events (event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, event_city_id, event_start_time, event_end_time)
SELECT DISTINCT event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, city_id, event_start_time, event_end_time
FROM project1.Public_Event_Information P 
INNER JOIN Cities C
    ON P.event_city = C.city_name
    AND P.event_state = C.state_name
    AND P.event_country = C.country_name
-- FIX --
-- Participants Not in Public DB--

-- Because of Albums/Photos circular dependency, they have to be inserted in the same transaction
 SET AUTOCOMMIT OFF;

-- Albums -- 
INSERT INTO Albums (album_id, album_owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id)
SELECT DISTINCT album_id, owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id
FROM project1.Public_Photo_Information

-- Photos --
INSERT INTO Photos (photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link)
SELECT DISTINCT photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link
FROM project1.Public_Photo_Information

COMMIT;
SET AUTOCOMMIT ON;

-- Tags --
INSERT INTO Tags (tag_photo_id, tag_subject_id, tag_create_time, tag_x, tag_y)
SELECT DISTINCT photo_id, tag_subject_id, tag_created_time, tag_x_coordinate, tag_y_coordinate
FROM project1.Public_Tag_Information
 


