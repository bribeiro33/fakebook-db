-- View_User_Information --
    -- User
    -- User_Current_City
        -- Cities
    -- User_Hometown_City
        -- Cities
    -- Education
        -- Programs

CREATE VIEW View_User_Information AS 
    WITH CurrentCities AS (
        SELECT UCC.user_id, C.city_name AS current_city, 
            C.state_name AS current_state, 
            C.country_name AS current_country
        FROM User_Current_Cities UCC
        INNER JOIN Cities C ON UCC.current_city_id = C.city_id
    ),
    HometownCities AS (
        SELECT UHC.user_id, C.city_name AS hometown_city, 
            C.state_name AS hometown_state, 
            C.country_name AS hometown_country
        FROM User_Hometown_Cities UHC
        INNER JOIN Cities C ON UHC.hometown_city_id = C.city_id
    ),
    UserEducations AS (
        SELECT E.user_id, P.institution AS institution_name,
            E.program_year,
            P.concentration AS program_concentration,
            P.degree AS program_degree
        FROM Education E
        INNER JOIN Programs P ON E.program_id = P.program_id
    )
SELECT U.user_id, U.first_name, U.last_name, U.year_of_birth, U.month_of_birth, U.gender,
    CC.current_city, CC.current_state, CC.current_country,
    HC.hometown_city, HC.hometown_state, HC.hometown_country,
    UE.institution_name, UE.program_year, UE.program_concentration, UE.program_degree
FROM Users U
LEFT JOIN CurrentCities CC ON U.user_id = CC.user_id
LEFT JOIN HometownCities HC ON U.user_id = HC.user_id
LEFT JOIN UserEducations UE ON U.user_id = UE.user_id;

-- View_Are_Friends --
    -- Friends

CREATE VIEW View_Are_Friends AS
SELECT F.user1_id, F.user2_id 
FROM Friends F;

-- View_Photo_Information --
    -- Album
    -- Photo

CREATE VIEW View_Photo_Information AS
SELECT A.album_id, A.album_owner_id AS owner_id, A.cover_photo_id, 
    A.album_name, A.album_created_time, A.album_modified_time, A.album_link,
    A.album_visibility, P.photo_id, P.photo_caption, P.photo_created_time, 
    P.photo_modified_time, P.photo_link
FROM Albums A
INNER JOIN Photos P ON A.album_id = P.album_id;

-- View_Event_Information --
    -- User_Events
        -- Cities

CREATE VIEW View_Event_Information AS
SELECT UE.event_id, UE.event_creator_id, UE.event_name, UE.event_tagline, 
    UE.event_description, UE.event_host, UE.event_type, UE.event_subtype, 
    UE.event_address, C.city_name AS event_city, C.state_name AS event_state, 
    C.country_name AS event_country, UE.event_start_time, UE.event_end_time
FROM User_Events UE
LEFT JOIN Cities C ON UE.event_city_id = C.city_id;

-- View_Tag_Information --
    -- Tags

CREATE VIEW View_Tag_Information AS
SELECT T.tag_photo_id AS photo_id, T.tag_subject_id, T.tag_created_time, 
    T.tag_x AS tag_x_coordinate, T.tag_y AS tag_y_coordinate
FROM Tags T;