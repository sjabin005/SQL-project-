-- Student Number(s): 10705593
-- Student Name(s):	Sara Jabin 

USE your_database_name;
GO  


/*	Query 1 – Short Upcoming Bookings (2 marks)
	Write a query that selects the booking ID, start date/time, booking duration (minutes), building 
	name, room name/number, and booking status name of 
	all upcoming bookings (i.e. bookings with a start date/time in the future) that:
		* have a booking duration of 90 minutes or less
	
	Order the results by start date/time.
*/

-- Write Query 1 here
SELECT b.booking_id,
       b.start_datetime,
	   b.booking_duration,
	   r.building_name, 
	   r.room_name,
	   bs.status_name

FROM booking AS b 
INNER JOIN room AS r
ON b.room_id=r.room_id 
INNER JOIN booking_status AS bs
ON b.status_id=bs.status_id
WHERE b.start_datetime>CURRENT_TIMESTAMP
AND b.booking_duration<=90
ORDER BY b.start_datetime;




/*	Query 2 – Most Active Users (2 marks)
	Write a query that selects the library user ID, the total number of bookings they have requested, 
	and the average booking duration for the top three library users (those who have requested the highest number of bookings).

	Order the results by the number of bookings in descending order.
*/

-- Write Query 2 here

SELECT TOP 3 b.user_id,
       COUNT(booking_id) AS total_bookings,
	   AVG(booking_duration) AS average_booking_duration
FROM booking AS b
GROUP BY b.user_id
ORDER BY total_bookings DESC;





/*	Query 3 – Formatted Booking Details (2 marks)
	Write a query that selects three columns of concatenated information about bookings, as pictured below. 
	
	Order the results by the booking duration in descending order.
	
	Your query must return the following three columns (use column aliases as appropriate):
		1. Booking Summary – formatted as:
		Booking <booking_id>: <status_name> (<duration_minutes> mins)
		2. When & Where – formatted as:
		<start_datetime> - <building_name> Room <room_name>
		3. Requested By – formatted as:
		<user_full_name> )
*/

-- Write Query 3 here
SELECT 
CONCAT(
   'Booking', 
   ':', 
   status_name, 
   '(', booking_duration, 'mins)')
   AS booking_summary,
CONCAT(
    start_datetime,
	'-', 
	building_name,
	'Room', 
	room_name
	) AS [when & where],
user_full_name AS requested_by
FROM booking_details_view
ORDER BY booking_duration DESC;


/*	Query 4 – Invalid Approval Records (3 marks)
	Write a query that selects the booking ID, start date/time, status name, approved date/time, and the
	full name (first name + last name) of the approving staff member for any bookings where the approval
	details are inconsistent with the booking’s status.

	Include any booking where either of the following is true:
		* The booking status is "Approved" but approval details are missing 
			(approved date/time is NULL and/or approving staff is NULL), or
		* The booking status is not "Approved" or "Completed" but approval details exist 
			(approved date/time is NOT NULL and/or approving staff is NOT NULL)
	
	Order the results by status name.
*/

-- Write Query 4 here

SELECT booking_id,
       start_datetime,
	   status_name, 
	   approved_datetime,
	   approved_by_staff
FROM booking_details_view
WHERE(
      status_name='Approved'
	  AND
	  (
	  approved_datetime IS NULL
	  OR approved_by_staff IS NULL
	 )
	)
	 OR
	 (
	  status_name NOT IN ('Approved', 'Completed')
	  AND
	  ( 
	   approved_datetime IS NOT NULL
	   OR approved_by_staff IS NOT NULL
	   )
	  )
ORDER BY status_name
	  


/*	Query 5 – Room Type Booking Summary (3 marks)
	Write a query that selects the following details for each room type defined in the system:
		* The room type name.
		* The total number of rooms of that room type.
		* The total number of bookings made for rooms of that type.
		* The total minutes booked for that room type (sum of booking durations).
		* The average booking duration.
		* The start date/time of the latest booking for that room type.

	Include room types even if they have no rooms or no bookings.

	Order the results by total minutes booked in descending order and be sure to give each column a
	suitable alias.
*/

-- Write Query 5 here
SELECT rt.type_name, 
COUNT(DISTINCT r.room_id) AS room_count,
COUNT(DISTINCT b.booking_id) AS booking_count,
SUM(b.booking_duration) AS total_miniutes_booking,
AVG(b.booking_duration) AS avg_duration_miniutes,
MAX(b.start_datetime) AS latest_booking
FROM room_type AS rt
LEFT OUTER JOIN room AS r
ON rt.type_id=r.type_id
LEFT OUTER JOIN booking AS b
ON r.room_id=b.room_id
GROUP BY rt.type_name
ORDER BY total_miniutes_booking



/*	Query 6 – Longer than Average Notes (3 marks)
	Write a query that selects:
		* the note ID, note date/time, note content, the note length (number of characters in the note content), and 
		* the full name (first name + last name) of the staff member who wrote the note, 
		* for any booking notes that are longer than the average length of all booking notes.

	Order the results by note length in descending order.
*/

-- Write Query 6 here
SELECT bn.note_id,
       bn.date_time,
	   bn.content,
	   len(bn.content) AS note_length,
	   CONCAT(s.first_name, ' ', last_name) AS staff_full_name
FROM booking_note AS bn
INNER JOIN staff AS s
ON bn.added_by_staff_id=s.staff_id
WHERE LEN(bn.content)>
( 
  SELECT AVG(LEN(content))
FROM booking_note
)
ORDER BY note_length DESC;




/*	Query 7 – Room Utilisation Statistics (4 marks)
	Write a query that selects the following information about each room:
		* Building name and room name/number, concatenated as pictured below
			(e.g., Reid Library - Room 2.14)
		* The room type name
		* The number of bookings for the room
		* The total minutes booked for the room (sum of booking durations)
			Sometimes this can result in a NULL value. Instead of displaying  'NULL' , display the number '0' (zero) instead.
		* The start date/time of the latest booking for the room

	Include all rooms, even if they have no bookings.
	
	Order the results by total minutes booked in descending order.
*/

-- Write Query 7 here

SELECT 
    CONCAT(r.building_name, 
       '-Room',
	      r.room_name) AS room,
    rt.type_name AS room_type_name,
	COUNT(b.booking_id) AS booking_count,
	ISNULL(SUM(b.booking_duration),0)
	AS total_miniutes_booked,
	MAX(b.start_datetime) AS latest_booking
FROM room AS r
LEFT OUTER JOIN room_type AS rt
ON r.type_id=rt.type_id
LEFT OUTER JOIN booking AS b
ON r.room_id=b.room_id
GROUP BY 
   r.building_name,
   r.room_name,
   rt.type_name
ORDER BY total_miniutes_booked;


/*	Query 8 – High-Intervention Bookings (4 marks)
	Write a query that selects the following details of bookings:
		* The booking ID, purpose, start date/time, and booking duration (minutes)
		* The booking status name
		* The full name of the staff member who created the booking
		* The full name of the staff member who approved the booking (if applicable; otherwise show it as empty)
		* The number of notes written about the booking.

	The results should only include bookings where:
		* there are at least 2 notes written about the booking, and 
		* the booking status is Pending or Approved.

	Order the results by the note count in descending order, then booking start date/time in descending order.

	(HINT: This query is much easier if you use both the views you created).
*/

-- Write Query 8 here
SELECT bdv.booking_id,
       bdv.purpose, 
	   bdv.start_datetime, 
	   bdv.booking_duration,
	   bdv.status_name, 
	   bdv.created_by_staff,
	   bdv.approved_by_staff,
	   cbnv.note_count
FROM booking_details_view AS bdv
INNER JOIN count_booking_notes_view AS cbnv 
ON bdv.booking_id=cbnv.booking_id
WHERE cbnv.note_count>0
AND bdv.status_name IN ('Pending', 'Approved')
ORDER BY cbnv.note_count DESC,
         bdv.start_datetime DESC;



/*	Query 9 – Staff Statistics (4 marks)
	Write a query that selects the staff ID, full name (first name and last name concatenated with a space), as well as:
		* the number of bookings they have created
		* the number of bookings they have approved
		* the number of booking notes they have written

	Ensure that all staff members are included in the results,
	even if they have not created or approved any bookings and have not written any notes.

	Order by the staff member’s last name in ascending order.
*/

-- Write Query 9 here


SELECT s.staff_id, 
       CONCAT(s.first_name, ' ', s.last_name) AS staff_full_name,
	   COUNT(DISTINCT bc.booking_id) AS bookings_created,
	   COUNT(DISTINCT ba.booking_id) AS bookings_approved,
	   COUNT(DISTINCT bn.note_id) AS note_written
FROM staff AS s
LEFT OUTER JOIN booking AS bc
ON s.staff_id=bc.created_by_staff_id
LEFT OUTER JOIN booking AS ba
ON s.staff_id=ba.approved_by_staff_id
LEFT OUTER JOIN booking_note AS bn
ON s.staff_id=bn.added_by_staff_id
GROUP BY 
      s.staff_id,
      s.first_name,
	  s.last_name

ORDER BY s.last_name ASC;