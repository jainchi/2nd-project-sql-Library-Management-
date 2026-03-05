--Library_Management_System (2nd project)

CREATE TABLE 
books
	(isbn VARCHAR(29),
	 book_title VARCHAR(80),
	 category VARCHAR(15),	
	 rental_price FLOAT ,
	 status VARCHAR(25), 
	 author VARCHAR(35),
	 publisher VARCHAR(35));


CREATE TABLE branch
(branch_id CHAR(4),
 manager_id	CHAR(4),
 branch_address	VARCHAR(15),
 contact_no smallint 
)
ALTER TABLE branch
ALTER COLUMN contact_no type BIGINT;


INSERT INTO branch (branch_id,manager_id,branch_address, contact_no)
VALUES
('B001', 'E109', '123 Main St', 919100000000),
('B002', 'E109', '456 Elm St', 919100000000),
('B003', 'E109', '789 Oak St', 919100000000),
('B004', 'E110', '567 Pine St', 919100000000),
('B005', 'E110', '890 Maple St', 919100000000);
CREATE TABLE members 
(member_id CHAR(4) PRIMARY KEY,
 member_name VARCHAR(25),
 member_address VARCHAR(55),
 reg_date DATE
)

CREATE TABLE employees
(emp_id VARCHAR(15),
 emp_name VARCHAR(55),
 position VARCHAR(55),
 salary INT,
 branch_id VARCHAR(50) 
)

INSERT INTO employees (emp_id, emp_name, position, salary, branch_id
)
VALUES
('E101', 'John Doe', 'Clerk', 60000, 'B001'),
('E102', 'Jane Smith', 'Clerk', 45000, 'B002'),
('E103', 'Mike Johnson', 'Librarian', 55000, 'B001'),
('E104', 'Emily Davis', 'Assistant', 40000, 'B001'),
('E105', 'Sarah Brown', 'Assistant', 42000, 'B001'),
('E106', 'Michelle Ramirez', 'Assistant', 43000, 'B001'),
('E107', 'Michael Thompson', 'Clerk', 62000, 'B005'),
('E108', 'Jessica Taylor', 'Clerk', 46000, 'B004'),
('E109', 'Daniel Anderson', 'Manager', 57000, 'B003'),
('E110', 'Laura Martinez', 'Manager', 41000, 'B005'),
('E111', 'Christopher Lee', 'Assistant', 65000, 'B005');

DROP TABLE members
CREATE TABLE issued_status
(issued_id VARCHAR(10),
 issued_member_id VARCHAR(25),
 issued_book_name VARCHAR(100),
 issued_date DATE,
 isbn VARCHAR(50),
 emp_id VARCHAR(10)
);

CREATE TABLE return_status
	(return_id VARCHAR(6) NOT NULL,
	 issued_id VARCHAR(8),
	 return_book_name VARCHAR(35),
	 return_date DATE,
	 return_book_isbn VARCHAR(50));

SELECT * FROM books
SELECT * FROM branch
SELECT * FROM members
SELECT * FROM employees
SELECT * FROM issued_status
SELECT * FROM return_status


ALTER TABLE books
ADD CONSTRAINT pk_books
PRIMARY KEY (isbn);

ALTER TABLE branch
ADD CONSTRAINT pk_branch
PRIMARY KEY (branch_id);

ALTER TABLE employees
ADD CONSTRAINT pk_employees
PRIMARY KEY (emp_id);

ALTER TABLE issued_status
ADD CONSTRAINT pk_issued_status
PRIMARY KEY (issued_id);

ALTER TABLE return_status
ADD CONSTRAINT pk_return_status
PRIMARY KEY (return_id);


--HAVE CREATED ALL NECESSARY TABLES TILL NOW

--Now Coming to the Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = 'BHIWADI'
WHERE member_id = 'C105';


-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status 
WHERE issued_id = 'IS121'
SELECT * FROM issued_status

- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE emp_id = 'E101';

 
-- Task 5: List Members Who Have Issued More Than One Book 

SELECT imi.issued_member_id,m.member_name, count(issued_member_id)
FROM issued_status AS imi
JOIN members AS m
ON imi.issued_member_id = m.member_id
GROUP BY imi.issued_member_id,2
HAVING COUNT(issued_member_id)>1



SELECT * FROM issued_status

-- CTAS

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

	
	

-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:

	SELECT * FROM books
	where category ='Classic'

-- Task 8: Find Total Rental Income by Category:

	SELECT category, SUM(rental_price)AS Rental_Income
	from books
	GROUP BY category;

-- Task 9. **List Members Who Registered in the Last 1200 Days**:

	SELECT * FROM members
	WHERE reg_date >= CURRENT_DATE - INTERVAL '1200 days';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:

	SELECT em.emp_name,em.position,br.branch_id, br.manager_id
	FROM branch AS br
	INNER JOIN employees AS em
	ON br.branch_id= em.branch_id


	CREATE TABLE expensive_books AS
	SELECT * FROM books
	WHERE rental_price > 7.00;

-- Task 12: Retrieve the List of Books Not Yet Returned

	SELECT * FROM issued_status AS i
	LEFT JOIN return_status AS r
	ON i.issued_id=r.issued_id
	WHERE return_id IS NULL

	--Task 13: Identify Members with Overdue Books
	--Write a query to identify members who have overdue books (assume a 30-day return period).
	--Display the member's_id, member's name, book title, issue date, and days overdue.

	 
SELECT m1.member_id,m1.member_name,ist.issued_book_name AS book_title,ist.issued_date, CURRENT_DATE - ist.issued_date as over_dues_days 
FROM members AS m1
JOIN  issued_status as ist
ON m1.member_id=ist.issued_member_id
LEFT JOIN return_status AS rs1
ON rs1.issued_id = ist.issued_id
WHERE 
	rs1.return_date IS NULL OR
 (CURRENT_DATE - ist.issued_date) > 30

---
SELECT * FROM books
SELECT * FROM branch
SELECT * FROM members
SELECT * FROM employees
SELECT * FROM issued_status ORDER BY issued_id ASC
SELECT * FROM return_status

/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).*/

SELECT * FROM books AS bks
JOIN return_status AS rs2
ON rs2.return_book_isbn = bks.isbn



/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

	SELECT b.branch_id, COUNT(isd.issued_id), COUNT(rs2.return_id), SUM(rental_price)
	from employees es
	JOIN issued_status isd
	ON isd.emp_id = es.emp_id
	JOIN return_status AS rs2
	ON rs2.issued_id = isd.issued_id
	FULL JOIN branch AS b
	ON b.branch_id =es.branch_id
	FULL JOIN books AS bs
	ON bs.isbn = isd.isbn
		GROUP BY b.branch_id
		ORDER BY b.branch_id ASC	
-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

	CREATE TABLE active_members
	AS
	SELECT * FROM members
	WHERE member_id IN (SELECT 
	                        DISTINCT issued_member_id   
	                    FROM issued_status
	                    WHERE 
	                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
	                    )
	;
	
	SELECT * FROM active_members;

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.*/
	
		SELECT 
	    e.emp_name,
	    b.*,
	    COUNT(ist.issued_id) as no_book_issued
	FROM issued_status as ist
	JOIN
	employees as e
	ON e.emp_id = ist.emp_id
	JOIN
	branch as b
	ON e.branch_id = b.branch_id
	GROUP BY 1, 2


/*Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name and the number of times they've issued damaged books.*/


	SELECT issued_status.emp_id, emp_name, count(issued_status.emp_id) -'2' AS Damged_count 
	FROM issued_status
	JOIN  employees AS es
	ON issued_status.emp_id = es.emp_id
	GROUP BY issued_status.emp_id, emp_name
	HAVING COUNT(issued_status.emp_id)>2


-- Thank You
	