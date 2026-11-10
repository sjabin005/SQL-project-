CREATE DATABASE library_management
-- Student Number(s):10705593	
-- Student Name(s):	Sara Jabin

/*	Database Creation & Population Script (6 marks)
	Produce a script to create the database you designed in Task 1 (incorporating any changes you have made since then).
	Be sure to give your columns the same data types, properties and constraints specified in your data dictionary, and be sure to name tables and columns consistently.
	Include any suitable default values and any necessary/appropriate CHECK or UNIQUE constraints.

	Make sure this script can be run multiple times without resulting in any errors (hint: drop the database if it exists before trying to create it).
	You can use/adapt the code at the start of the creation scripts of the sample databases available in the unit materials to implement this.

	See the assignment brief for further information. 
*/


-- Write your creation script here  
CREATE TABLE room_type
(
  type_id INT IDENTITY PRIMARY KEY NOT NULL,
  type_name VARCHAR(50) NOT NULL,
  max_booking_duration INT NOT NULL CHECK(max_booking_duration>0)
);

CREATE TABLE booking_status
(
  status_id INT IDENTITY PRIMARY KEY NOT NULL,
  status_name VARCHAR(50) NOT NULL
);

CREATE TABLE permission_level
(
  level_id INT IDENTITY PRIMARY KEY NOT NULL,
  level_name VARCHAR(20) NOT NULL,
  description VARCHAR(255) NOT NULL
);

CREATE TABLE staff
(
 staff_id INT IDENTITY PRIMARY KEY NOT NULL,
 first_name VARCHAR(20) NOT NULL,
 last_name VARCHAR(20)NOT NULL,
 email VARCHAR(100)NOT NULL UNIQUE,
 password VARCHAR(255) NOT NULL,
 postal_address VARCHAR(100) NOT NULL,
 phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE user_details
(
  user_id INT IDENTITY PRIMARY KEY NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  postal_address VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  preferred_room_type INT NULL FOREIGN KEY REFERENCES room_type(type_id)
);

CREATE TABLE room
(
 room_id INT IDENTITY PRIMARY KEY NOT NULL,
 room_name VARCHAR(50) NOT NULL,
 building_name VARCHAR(50) NOT NULL,
 max_seating_capacity INT NOT NULL CHECK(max_seating_capacity>0),
 type_id INT NOT NULL FOREIGN KEY REFERENCES room_type(type_id),
 UNIQUE(building_name, room_name)
);

CREATE TABLE booking
(
 booking_id INT IDENTITY PRIMARY KEY NOT NULL,
 start_datetime DATETIME NOT NULL,
 booking_duration SMALLINT NOT NULL CHECK(booking_duration>0),
 purpose VARCHAR(50) NOT NULL,
 approved_datetime DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
 room_id INT NOT NULL FOREIGN KEY REFERENCES room(room_id),
 user_id INT NOT NULL FOREIGN KEY REFERENCES user_details(user_id),
 status_id INT NOT NULL FOREIGN KEY REFERENCES booking_status(status_id),
 created_by_staff_id INT NOT NULL FOREIGN KEY REFERENCES staff(staff_id),
 approved_by_staff_id INT NULL FOREIGN KEY REFERENCES staff(staff_id)
);

CREATE TABLE booking_note
(
 note_id INT IDENTITY PRIMARY KEY NOT NULL,
 booking_id INT NOT NULL FOREIGN KEY REFERENCES booking(booking_id),
 date_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 added_by_staff_id INT NOT NULL FOREIGN KEY REFERENCES staff(staff_id),
 content VARCHAR(255) NOT NULL
);

CREATE TABLE staff_permission
(
 staff_id INT NOT NULL FOREIGN KEY REFERENCES staff(staff_id),
 level_id INT NOT NULL FOREIGN KEY REFERENCES permission_level(level_id),
 PRIMARY KEY(staff_id, level_id)
);
/*	Database Population Statements
	Following the SQL statements to create your database and its tables, you must include statements to populate the database with sufficient test data.
	You are only required to populate the database with enough data to make sure that all views and queries return meaningful results.
	
	You can start working on your views and queries and write INSERT statements as needed for testing as you go.
	The final create.sql should be able to create your database and populate it with enough data to make sure that all views and queries return meaningful results.

	Since writing sample data is time-consuming and quite tedious, I have provided data for some of the tables below.
	Adapt the INSERT statements as needed, and write your own INSERT statements for the remaining tables at the end of the file.
*/



/*	The following statement inserts the details of 3 room types into a table named "room_type".
    It specifies values for columns named "type_name" and "max_booking_duration" (in hours).
	Room type ID numbers are not specified since it is assumed that an auto-incrementing integer is being used.
	If required, change the table and column names to match those in your database.
*/

INSERT INTO room_type (type_name, max_booking_duration)
VALUES	('Study Room', 2),			-- room type 1
		('Meeting Room', 4),		-- room type 2
		('Presentation Room', 8);	-- room type 3



/*	The following statement inserts the details of 5 bookable rooms into a table named "room".
    If required, change the table and column names to match those in your database.
*/

INSERT INTO room (room_name, building_name, max_seating_capacity, type_id)
VALUES	('2.14', 'Reid Library', 6, 1),						-- room type 1 (Study Room)
		('1.03', 'Reid Library', 12, 2),					-- room type 2 (Meeting Room)
		('6.07', 'Robertson Library', 30, 3),				-- room type 3 (Presentation Room)
		('3.22', 'Reid Library',6, 1),						-- room type 1 (Study Room)
		('4.10', 'Robertson Library', 8, 2);				-- room type 2 (Meeting Room)


/*	The following statement inserts the details of 4 booking statuses into a table named "booking_status".
   	If required, change the table and column names to match those in your database.

	The following is an explanation of the meaning of each status:
	 * Pending - The booking has been created but not processed for approval.
	 * Approved - The booking has been approved.
	 * Cancelled - The booking has been cancelled by either the library staff or on request of the user who booked it.
	 * Completed - The use of the room in the booking has been completed.
*/
INSERT INTO booking_status (status_name)
VALUES	('Pending'),				-- status 1
		('Approved'),				-- status 2
		('Cancelled'),				-- status 3
		('Completed');				-- status 4



-- Write your INSERT statements for the remaining tables here

INSERT INTO permission_level ( level_name, description)
VALUES ('Staff', 'Create and manage booking'),
       ('Manager', 'Approve or reject bookings'),
	   ('Admin', 'Full control of all bookings');

INSERT INTO staff (first_name, last_name, email, password, postal_address, phone_number)
VALUES ('Sara', 'Jabin', 'sjabin12@gmail.com', 'sv1Q', 'Perth WA', 06111111),
       ('Zara', 'Mehjabin', 'zmehjabin12@gmail.com', 'ba125', 'Geraldton WA', 0688888),
	   ('Lara', 'Zabin', 'lzabin12@gmail.com', 'MgA1', 'Adelaide SA', 0655555);

INSERT INTO user_details (first_name, last_name, email, postal_address, phone_number, preferred_room_type)
VALUES ('Nimi', 'Myer', 'akhan12@gmail.com', 'Perth WA', 0622222, 1),
       ('Yuson', 'Fila', 'yfila2@gmail.com', 'Sydney NSW', 063333, 2),
	   ('Lishana', 'Ahmed', 'lahmed8@gmail.com', 'Darwin NT', 064444, 3);



INSERT INTO booking (start_datetime, booking_duration, purpose, approved_datetime, room_id, user_id, status_id, created_by_staff_id, approved_by_staff_id)
VALUES ('2026-05-02 10:15:23', '60', 'Group study session','2026- 05-08 9:03:12', 2, 3, 1, 3, 1),
       ('2026-05-09 20:22:01', '30', 'Individual study session','2026-05-10 05:03:12', 6, 1, 1, 3, 2),
	   ('2026-07-04 3:12:09', '40', 'Group exam revision', '2026-04-07 08:10:05', 4, 2, 2, 2, 1),
	   ('2026-08-02 10:00:00', '60', 'Practice Session', '2026-03-03 06:11:12', 5, 3, 2, 3, NULL),
	   ('2026-09-01 11:15:01', '45', 'Meeting', NULL, 6,3, 2, 1, 2)
UPDATE booking
SET status_id = 2
WHERE booking_id = 8;
INSERT INTO booking_note (booking_id, date_time, added_by_staff_id, content)
VALUES  (6, '2026-02-10 12:15:02', 2, 'Room needs to be cleaned before booking'),
        (7, '2026-01-09 01:23:22', 1, 'Additional seat required for the booking'),
		(8, '2026-09-20 11:23:23', 1, 'Room must have projector and meeting will last 5 hours'),
		(9, '2026-07-11 13:10:05', 2, 'Room capacity should be at least 70 and booking date can be change'),
		(6, '2026-07-02 13:21:21', 1, 'Additional microphone setup required');
INSERT INTO staff_permission (staff_id, level_id)
VALUES (3, 1),
       (2, 2);

