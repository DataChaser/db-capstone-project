SHOW DATABASES;
USE littlelemondb;
SELECT * FROM Orders;
SELECT * FROM Customers;
SELECT * FROM Menu;
SELECT * FROM Bookings;

-- In the first task, Little Lemon need you to create a virtual table called OrdersView that focuses on OrderID, Quantity and Cost columns within the Orders table for all orders with a quantity greater than 2. 
DROP VIEW IF EXISTS OrdersViews;
CREATE VIEW OrdersViews AS
SELECT OrderID, Quantity, TotalCost FROM Orders WHERE Quantity > 2;
SELECT * FROM OrdersViews;

-- For your second task, Little Lemon need information from four tables on all customers with orders that cost more than $150. Extract the required information from each of the following tables by using the relevant JOIN clause: 
SELECT c.CustomerID, c.FullName, o.OrderID, o.TotalCost, m.ItemName, m.Category 
FROM Customers c JOIN Bookings b ON c.CustomerID = b.CustomerID 
JOIN Orders o ON b.BookingID = o.BookingID JOIN Menu m ON o.MenuID = m.MenuID 
WHERE o.TotalCost > 150 ORDER BY o.TotalCost ASC;

-- For the third and final task, Little Lemon need you to find all menu items for which more than 2 orders have been placed. You can carry out this task by creating a subquery that lists the menu names from the menus table for any order quantity with more than 2.
SELECT ItemName FROM Menu WHERE MenuID = ANY (SELECT MenuID From Orders WHERE Quantity > 2);

-- In this first task, Little Lemon need you to create a procedure that displays the maximum ordered quantity in the Orders table. 
DROP PROCEDURE IF EXISTS GetMaxQuantity()
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN 
	SELECT MAX(Quantity) AS MaxQuantity FROM Orders;
END //
DELIMITER ;

CALL GetMaxQuantity();

-- In the second task, Little Lemon need you to help them to create a prepared statement called GetOrderDetail. This prepared statement will help to reduce the parsing time of queries. It will also help to secure the database from SQL injections.
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE BookingID = ANY(SELECT BookingID FROM Bookings WHERE CustomerID = ?)';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Your third and final task is to create a stored procedure called CancelOrder. Little Lemon want to use this stored procedure to delete an order record based on the user input of the order id.
DELIMITER //
CREATE PROCEDURE CancelOrder (IN order_id INT)
BEGIN
	IF EXISTS (SELECT OrderID FROM Orders WHERE OrderID = order_id) THEN
		DELETE FROM Orders WHERE OrderID = order_id;
        SELECT CONCAT('Order ', order_id, ' has been cancelled.') AS Message;
	ELSE 
		SELECT CONCAT('Order ', order_id, ' not found.') AS Message;
	END IF;
END //
DELIMITER ;
 
CALL CancelOrder(5);

-- Little Lemon wants to populate the Bookings table of their database with some records of data. Your first task is to replicate the list of records in the following table by adding them to the Little Lemon booking table. 
INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID) 
VALUES 
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);
SELECT BookingID, Date, TableNumber, CustomerID FROM Bookings; 
-- WHERE BookingID < 5;

-- For your second task, Little Lemon need you to create a stored procedure called CheckBooking to check whether a table in the restaurant is already booked.
DROP PROCEDURE IF EXISTS CheckBooking; 
DELIMITER //
CREATE PROCEDURE CheckBooking(IN booking_date DATE, IN table_number INT)
BEGIN
	IF EXISTS (SELECT Date, TableNumber FROM Bookings WHERE Date = booking_date AND TableNumber = table_number)
		THEN 
        SELECT CONCAT('Table ', table_number, ' is already booked.') AS Booking_status;
	ELSE 
		SELECT CONCAT('Table ', table_number, ' is available.') AS Booking_status;
	END IF;
END //
DELIMITER ;

CALL CheckBooking('2022-10-11', 2);
	
-- For your third and final task, Little Lemon need to verify a booking, and decline any reservations for tables that are already booked under another name. 

DROP PROCEDURE IF EXISTS AddValidBooking;
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN booking_date DATE, IN table_number INT)
BEGIN
	START TRANSACTION;
	IF EXISTS (SELECT Date, TableNumber FROM Bookings WHERE Date = booking_date AND TableNumber = table_number)
		THEN
		SELECT CONCAT('Table ', table_number, ' has already been booked. Booking cancelled.') AS Booking_Message;
	ROLLBACK;
	ELSE 
		INSERT INTO Bookings(Date, TableNumber) VALUES (booking_date, table_number);
	COMMIT;
			SELECT CONCAT('Table ', table_number, ' is available. Booking confirmed') AS Booking_Message;
		END IF;
END //
DELIMITER ;

CALL AddValidBooking('2022-10-10', 5);

-- In this first task you need to create a new procedure called AddBooking to add a new table booking record.
DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(IN booking_id INT, IN customer_id INT, IN booking_date DATE, IN table_number INT) -- , IN staff_id INT)
BEGIN
    INSERT INTO Bookings (BookingID, CustomerID, Date, TableNumber) -- , StaffID) 
    VALUES (booking_id, customer_id, booking_date, table_number); -- , staff_id);
    SELECT CONCAT('New Booking Confirmed') AS Confirmation;
END //
DELIMITER ;
CALL AddBooking(11, 10, '2025-10-10', 11); -- , 10);

-- For your second task, Little Lemon need you to create a new procedure called UpdateBooking that they can use to update existing bookings in the booking table.
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN new_booking_date DATE)
BEGIN
    UPDATE Bookings
    SET Date = new_booking_date
    WHERE BookingID = booking_id;
    SELECT CONCAT('Booking ID ', booking_id, ' has been updated to ', new_booking_date) AS Confirmation;
END //
DELIMITER ;
CALL UpdateBooking(11, '2025-12-01');

-- For the third and final task, Little Lemon need you to create a new procedure called CancelBooking that they can use to cancel or remove a booking.
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
    DELETE FROM Bookings
    WHERE BookingID = booking_id;
    SELECT CONCAT('Booking ID ', booking_id, ' has been canceled.') AS Confirmation;
END //
DELIMITER ;

CALL CancelBooking(9);







        
        
        
        
	








