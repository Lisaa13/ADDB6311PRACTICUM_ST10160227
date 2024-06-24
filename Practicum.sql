CREATE TABLE Instructor (
  ins_id INT NOT NULL,
  ins_fname VARCHAR(100) NOT NULL,
  ins_sname VARCHAR(100) NOT NULL,
  ins_contact VARCHAR(30) NOT NULL,
  ins_level INT NOT NULL,
   CONSTRAINT PK_Instructor PRIMARY KEY(ins_id)
);

CREATE TABLE Customer (
  cust_id VARCHAR(10) NOT NULL,
  cust_fname VARCHAR(100) NOT NULL,
  cust_sname VARCHAR(100) NOT NULL,
  cust_address VARCHAR(150) NOT NULL,
  cust_contact VARCHAR(150) NOT NULL,
   CONSTRAINT PK_Customer PRIMARY KEY(cust_id)
);

CREATE TABLE Dive (
  dive_id INT NOT NULL,
  dive_name VARCHAR(100) NOT NULL,
  dive_duration VARCHAR(100) NOT NULL,
  dive_location VARCHAR(100) NOT NULL,
  dive_exp_level INT NOT NULL,
  dive_cost INT NOT NULL,
   CONSTRAINT PK_Dive PRIMARY KEY(dive_id)
);

CREATE TABLE Dive_Event (
  dive_event_id VARCHAR(10) NOT NULL,
  dive_date DATE NOT NULL,
  dive_participants INT NOT NULL,
  ins_id INT NOT NULL,
  cust_id VARCHAR(10) NOT NULL,
  dive_id INT NOT NULL,
  CONSTRAINT PK_Dive_Event PRIMARY KEY(dive_event_id),
  CONSTRAINT FK_Instructor_Dive_Event FOREIGN KEY (ins_id) REFERENCES Instructor(ins_id),
  CONSTRAINT FK_Customer_Dive_Event FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
  CONSTRAINT FK_Dive_Dive_Event FOREIGN KEY (dive_id) REFERENCES Dive(dive_id)
);

--inserting data--
 INSERT ALL 
 INTO Instructor VALUES (101,'James','Willis','0843569851',7)
  INTO Instructor VALUES (102,'Sam','Walt','0763698521', 2)
  INTO Instructor VALUES (103,'Sally','Gumede','0786598521', 8)
  INTO Instructor VALUES (104,'Bob','Du Preez','0796369857', 3)
  INTO Instructor VALUES (105,'Simon','Jones','0826598741', 9)
  
 INTO Customer VALUES ('C115', 'Heinrich', 'Willis', '3 Main Road', '0821253659')
 INTO Customer VALUES ('C116', 'David', 'Watson', '13 Cape Road', '0769658547')
 INTO Customer VALUES ('C117', 'Waldo', 'Smith', '3 Mountain Road', '0863256574')
 INTO Customer VALUES ('C118','Alex','Hadson','8 Circle Road','0762356587')
 INTO Customer VALUES('C119','Kuhle','Bitterhout','15 Main Road','0821235258')
 INTO Customer VALUES ('C120','Thando','Zolani','88 Summer Road','0847541254')
 INTO Customer VALUES('C121','Philip','Jackson','3 Long Road','0745556658')
 INTO Customer VALUES ('C122','Sarah','Jones','7 Sea Road','0814745745')
 INTO Customer VALUES ('C123','Catherine','Howard','31 Lake Side Road','0822232521')
 
 INTO Dive VALUES (550,'Shark Dive','3 hours','Shark Point',8, 500)
 INTO Dive VALUES (551,'Coral Dive','1 hour','Break Point',7, 300)
 INTO Dive VALUES (552,'Wave Crescent','2 hours','Ship wreck ally',3, 800)	 				
 INTO Dive VALUES (553,'Underwater Exploration','1 hour','Coral ally',2, 250)	 				
 INTO Dive VALUES (554,'Underwater Adventure','3 hours','Sandy Beach',3, 750)				
 INTO Dive VALUES (555,'Deep Blue Ocean','30 minutes','Lazy Waves',2, 120)				
 INTO Dive VALUES (556,'Rough Seas','1 hour','Pipe',9, 700)
 INTO Dive VALUES (557,'White Water','2 hours','Drifts',5, 200)
 INTO Dive VALUES (558,'Current Adventure','2 hours','Rock Lands',3, 150)
 
INTO Dive_Event VALUES ('de_101','15-Jul-17',5,103,'C115',558)
INTO Dive_Event VALUES ('de_102','16-Jul-17',7,102,'C117',555)
INTO Dive_Event VALUES ('de_103','18-Jul-17',8,104,'C118',552)
INTO Dive_Event VALUES ('de_104','19-Jul-17',3,101,'C119',551)
INTO Dive_Event VALUES ('de_105','21-Jul-17',5,104,'C121',558)
INTO Dive_Event VALUES ('de_106','22-Jul-17',8,105,'C120',556)
INTO Dive_Event VALUES ('de_107','25-Jul-17',10,105,'C115',554)
INTO Dive_Event VALUES ('de_108','27-Jul-17',5,101,'C122',552)
INTO Dive_Event VALUES ('de_109','28-Jul-17',3,102,'C123',553)

SELECT * FROM DUAL;




SELECT * FROM Instructor;
SELECT * FROM Customer;
SELECT * FROM Dive;
SELECT * FROM Dive_Event;

	 				
--question 2--

--create roles--
CREATE ROLE adminOnly;
CREATE ROLE general_users;
 --grant privilleges to admin--
GRANT CREATE, ALTER, DROP, GRANT, REVOKE, SELECT, INSERT, UPDATE, DELETE TO admin;
--grant privilleges to general user--

GRANT SELECT ON Customer,Dive,Dive_Event TO general_user
GRANT INSERT ON Customer, Dive, TO general_user
GRANT UPDATE ON Customer(cust_contact),Dive(dive_name) TO general_users



--Q3--
SELECT i.ins_fname || ' ' || i.ins_sname AS instructor,
       c.cust_fname || ' ' || c.cust_sname AS customer,
       d.dive_location,
       de.dive_participants
FROM Dive_Event de
INNER JOIN Instructor i ON de.ins_id = i.ins_id
INNER JOIN Customer c ON de.cust_id = c.cust_id
INNER JOIN Dive d ON de.dive_id = d.dive_id
WHERE de.dive_participants BETWEEN 8 AND 10;



SELECT d.dive_name, de.dive_date,de.dive_participants
FROM Dive_Event de
INNER JOIN Dive d ON de.dive_id = d.dive_id
WHERE de.dive_participants >= 10;

SET SERVEROUTPUT ON;
DECLARE
  CURSOR dive_cursor IS
    SELECT d.dive_name, de.dive_date, de.dive_participants
    FROM Dive_Event de
    INNER JOIN Dive d ON de.dive_id = d.dive_id
    WHERE de.dive_participants >= 10;
  
  dive_record dive_cursor%ROWTYPE;
BEGIN
  -- Open the cursor
  OPEN dive_cursor;
  
  -- Loop through each record in the cursor
  LOOP
    FETCH dive_cursor INTO dive_record;
    EXIT WHEN dive_cursor%NOTFOUND; -- Exit when no more records

    -- Display the retrieved data with formatting
    DBMS_OUTPUT.PUT_LINE('DIVE NAME: ' || dive_record.dive_name);
    DBMS_OUTPUT.PUT_LINE('DIVE DATE: ' || TO_CHAR(dive_record.dive_date));
    DBMS_OUTPUT.PUT_LINE('PARTICIPANTS: ' || dive_record.dive_participants);
    DBMS_OUTPUT.PUT_LINE(' '); -- Add an empty line for better readability
  END LOOP;
  
  -- Close the cursor
  CLOSE dive_cursor;
END;
/SELECT * FROM Instructor;
SELECT * FROM Customer;
SELECT * FROM Dive;
SELECT * FROM Dive_Event;



--Q6--
CREATE OR REPLACE FUNCTION calculate_dive_event_cost (
  dive_event_id IN VARCHAR2(10)
)
RETURN NUMBER
IS
  dive_id NUMBER;
  ins_level NUMBER;
  discount NUMBER := 0;  -- Initialize discount to 0
  total_cost NUMBER;
BEGIN
  -- Retrieve dive ID and instructor level from Dive_Event table
  SELECT de.dive_id, i.ins_level
  INTO dive_id, ins_level
  FROM Dive_Event de
  INNER JOIN Instructor i ON de.ins_id = i.ins_id
  WHERE de.dive_event_id = dive_event_id;

  -- Check if dive event ID exists
  IF dive_id IS NULL THEN
    RAISE VALUE_ERROR('Invalid dive event ID.');
  END IF;

  -- Calculate discount based on instructor experience level
  CASE ins_level
  WHEN 7 THEN
    discount := 0.05;  -- 5% discount for level 7
  WHEN   -- Corrected indentation
  8 THEN
    discount := 0.1;  -- 10% discount for level 8
  WHEN 9 THEN
    discount := 0.15; -- 15% discount for level 9
  END CASE;

  -- Retrieve dive cost from Dive table
  SELECT dive_cost
  INTO total_cost
  FROM Dive
  WHERE dive_id = dive_id;

  -- Calculate final cost with discount
  total_cost := total_cost * (1 - discount);

  -- **Removed unnecessary IF statement**

  -- Return the total cost
  RETURN total_cost;
END;
/

CREATE OR REPLACE TRIGGER New_Dive_Event
BEFORE INSERT ON Dive_Event
FOR EACH ROW
BEGIN
  IF :NEW.dive_participants <= 0 THEN
    RAISE APPLICATION_ERROR(-20001, 'Error: Number of participants cannot be zero or less.');
  ELSIF :NEW.dive_participants > 20 THEN
    RAISE APPLICATION_ERROR(-20002, 'Error: Number of participants cannot exceed 20.');
  END IF;
END;
/

DECLARE
  CURSOR dive_cursor IS
    SELECT c.cust_fname || ', ' || c.cust_sname AS customer_name,
           d.dive_name,
           de.dive_participants,
           CASE
             WHEN de.dive_participants <= 4 THEN 1
             WHEN de.dive_participants <= 7 THEN 2
             ELSE 3
           END AS instructors_required
    FROM Customer c
    INNER JOIN Dive_Event de ON c.cust_id = de.cust_id
    INNER JOIN Dive d ON de.dive_id = d.dive_id
    WHERE d.dive_cost > 500;  -- Filter for dives costing over R500

  dive_record dive_cursor%ROWTYPE;
BEGIN
  -- Open the cursor
  OPEN dive_cursor;

  -- Loop through the cursor results
  LOOP
    FETCH dive_cursor INTO dive_record;
    EXIT WHEN dive_cursor%NOTFOUND;

    -- Display results for each dive event
    DBMS_OUTPUT.PUT_LINE('CUSTOMER: ' || dive_record.customer_name);
    DBMS_OUTPUT.PUT_LINE('DIVE NAME: ' || dive_record.dive_name);
    DBMS_OUTPUT.PUT_LINE('PARTICIPANTS: ' || dive_record.dive_participants);
    DBMS_OUTPUT.PUT_LINE('STATUS:');
    DBMS_OUTPUT.PUT_LINE(dive_record.instructors_required || ' instructors required.');
    DBMS_OUTPUT.PUT_LINE('---');
  END LOOP;

  -- Close the cursor
  CLOSE dive_cursor;
END;
/

