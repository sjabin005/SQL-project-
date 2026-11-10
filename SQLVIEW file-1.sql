-- Student Number(s):10705593	
-- Student Name(s):	Sara Jabin 	

USE library_management;
GO


/*	Count of Booking Notes View (2 marks)
	Create a view that contains the Primary Key for each booking (e.g. booking_id) 
	and the total number of notes that have been created for that booking.
		* Make sure every booking is included, even if they do not have any notes.
		* Use column aliases as appropriate
*/

-- Write your View for your Count of Booking Notes here

CREATE VIEW count_booking_notes_view AS

SELECT b.booking_id,
       COUNT(bn.note_id) AS note_count
FROM booking AS b
LEFT OUTER JOIN booking_note AS bn
ON b.booking_id=bn.booking_id
GROUP BY b.booking_id;
GO 

SELECT *
FROM count_booking_notes_view


/*	Booking Details View (3 marks)
	Create a view that selects the following details of all bookings (use column aliases as appropriate):
		* ALL of the columns from the booking table (hint, you don’t need to specify each column by name)
		* The status name for the booking’s current status
		* The building name and room name/number for the room being booked
		* The library user’s first and last name concatenated into a full name 
			(e.g. “Daniel Nguyen”) for the user who requested the booking
		* The staff member’s first and last name concatenated into a full name 
			for the staff member who created the booking
		* The staff member’s first and last name concatenated into a full name 
			for the staff member who approved the booking
*/

-- Write your View for your Booking Details here
CREATE VIEW booking_details_view AS
SELECT b.*,
       bs.status_name,
	   r.building_name,
	   r.room_name,
	   CONCAT(u.first_name, ' ', u.last_name) AS user_full_name,
	   CONCAT(sc.first_name, ' ', sc.last_name) AS created_by_staff,
	   CONCAT(sa.first_name, ' ', sa.last_name) AS approved_by_staff
FROM booking AS b
INNER JOIN booking_status AS bs
ON b.status_id=bs.status_id
INNER JOIN room AS r
ON b.room_id=r.room_id
INNER JOIN user_details AS u
ON b.user_id=u.user_id
INNER JOIN staff AS sc
ON b.created_by_staff_id=sc.staff_id
LEFT OUTER JOIN staff AS sa
ON b.approved_by_staff_id=sa.staff_id;

SELECT * FROM booking_details_view

GO

/*	If you wish to create additional views to use in the queries which follow, include them in this file. */
