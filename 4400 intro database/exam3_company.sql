-- CS4400: Introduction to Database Systems: Tuesday, Apr 9, 2024
-- Practices on View, Function, Procedure

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set session SQL_MODE = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'company';

-- -------------------------------------------------
-- ENTER YOUR QUERY SOLUTIONS STARTING AT LINE 90
-- -------------------------------------------------

drop database if exists company;
create database if not exists company;
use company;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table employee (
  fname char(10) not null,
  lname char(20) not null,
  ssn decimal(9, 0) not null,
  bdate date not null,
  address char(30) not null,
  sex char(1) not null,
  salary decimal(5, 0) not null,
  superssn decimal(9, 0) default null,
  dno decimal(1, 0) not null,
  primary key (ssn)
) engine = innodb;

create table dependent (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  sex char(1) not null,
  bdate date not null,
  relationship char(30) not null,
  primary key (essn, dependent_name)
) engine = innodb;

create table department (
  dname char(20) not null,
  dnumber decimal(1, 0) not null,
  mgrssn decimal(9, 0) not null,
  mgrstartdate date not null,
  primary key (dnumber),
  unique key (dname)
) engine = innodb;

create table dept_locations (
  dnumber decimal(1, 0) not null,
  dlocation char(15) not null,
  primary key (dnumber, dlocation)
) engine = innodb;

create table project (
  pname char(20) not null,
  pnumber decimal(2, 0) not null,
  plocation char(20) not null,
  dnum decimal(1, 0) not null,
  primary key (pnumber),
  unique key (pname)
) engine = innodb;

create table works_on (
  essn decimal(9, 0) not null,
  pno decimal(2, 0) not null,
  hours decimal(5, 1) default null,
  primary key (essn, pno)
) engine = innodb;

-- -------------------------------------------------
-- view structures (student created solutions)
-- PUT ALL PROPOSED SOLUTIONS BELOW THIS LINE
-- -------------------------------------------------

/* Display the department number, the department name, and its location that has more than 1 ongoing projects. Show every department location for each department. */
drop view if exists active_department_locations;
create or replace view active_department_locations as
select 'WRITE YOUR ANSWER HERE';

/* Display all employee's first name, total hours worked, salary, department name and the supervisor's name. */
drop view if exists employee_dashboard;
create or replace view employee_dashboard as
select 'WRITE YOUR ANSWER HERE';

/* Create a function that returns the total hours worked across all employees that is older than the given birth date. */
drop function if exists sum_of_hours_based_on_birthdate;
delimiter //
create function sum_of_hours_based_on_birthdate(ip_bdate date)
	returns int deterministic
    begin
		-- WRITE YOUR ANSWER HERE
		return 0;
    end //
delimiter ;

/* Create a procedure to insert a new employee given the first name, last name, ssn, birth date, address, sex, salary, manager's ssn, and department number. */ 
drop procedure if exists add_employee;
delimiter //
create procedure add_employee(ip_fname varchar(10), ip_lname varchar(20), ip_ssn decimal(9.0), 
ip_bdate date, ip_address varchar(30), ip_sex char(1), ip_salary decimal(5.0), ip_superssn decimal(9.0), ip_dno decimal(1.0))
sp_main: begin
	-- WRITE YOUR ANSWER HERE
end //
delimiter ;

/* Create a procedure to add a new location to a department and move all the department's projects to the location specified. Location cannot be empty. */
drop procedure if exists relocate_department;
delimiter //
create procedure relocate_department(in ip_dnum decimal(1.0), in ip_location varchar(20))
sp_main: begin
	-- WRITE YOUR ANSWER HERE
end //
delimiter ;


-- -------------------------------------------------
-- PUT ALL PROPOSED SOLUTIONS ABOVE THIS LINE
-- -------------------------------------------------

-- The sole purpose of the following instruction is to minimize the impact of student-entered code
-- on the remainder of the autograding processes below
set @unused_variable_dont_care_about_value = 0;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

drop procedure if exists magic44_reset_database_state;
delimiter //
create procedure magic44_reset_database_state ()
begin
	-- Purge and then reload all of the database rows back into the tables.
    -- Ensure that the data is deleted in reverse order with respect to the
    -- foreign key dependencies (i.e., from children up to parents).
	
	delete from employee;
	delete from department;
	delete from dependent;
	delete from dept_locations;
	delete from project;
	delete from works_on;

    -- Ensure that the data is inserted in order with respect to the
    -- foreign key dependencies (i.e., from parents down to children).
	insert into employee values
	('John', 'Smith', 123456789, '1965-01-09', '731 Fondren, Houston TX', 'M', 30000, 333445555, 5),
	('Franklin', 'Wong', 333445555, '1955-12-08', '638 Voss, Houston TX', 'M', 40000, 888665555, 5),
	('Joyce', 'English', 453453453, '1972-07-31', '5631 Rice, Houston TX', 'F', 25000, 333445555, 5),
	('Ramesh', 'Narayan', 666884444, '1962-09-15', '975 Fire Oak, Humble TX', 'M', 38000, 333445555, 5),
	('James', 'Borg', 888665555, '1937-11-10', '450 Stone, Houston TX', 'M', 55000, null, 1),
	('Jennifer', 'Wallace', 987654321, '1941-06-20', '291 Berry, Bellaire TX', 'F', 43000, 888665555, 4),
	('Ahmad', 'Jabbar', 987987987, '1969-03-29', '980 Dallas, Houston TX', 'M', 25000, 987654321, 4),
	('Alicia', 'Zelaya', 999887777, '1968-01-19', '3321 Castle, Spring TX', 'F', 25000, 987654321, 4);

	insert into dependent values
	(123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
	(123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
	(123456789, 'Michael', 'M', '1988-01-04', 'Son'),
	(333445555, 'Alice', 'F', '1986-04-04', 'Daughter'),
	(333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
	(333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
	(987654321, 'Abner', 'M', '1942-02-28', 'Spouse');

	insert into department values
	('Headquarters', 1, 888665555, '1981-06-19'),
	('Administration', 4, 987654321, '1995-01-01'),
	('Research', 5, 333445555, '1988-05-22');

	insert into dept_locations values
	(1, 'Houston'),
	(4, 'Stafford'),
	(5, 'Bellaire'),
	(5, 'Houston'),
	(5, 'Sugarland');

	insert into project values
	('ProductX', 1, 'Bellaire', 5),
	('ProductY', 2, 'Sugarland', 5),
	('ProductZ', 3, 'Houston', 5),
	('Computerization', 10, 'Stafford', 4),
	('Reorganization', 20, 'Houston', 1),
	('Newbenefits', 30, 'Stafford', 4);

	insert into works_on values
	(123456789, 1, 32.5),
	(123456789, 2, 7.5),
	(333445555, 2, 10.0),
	(333445555, 3, 10.0),
	(333445555, 10, 10.0),
	(333445555, 20, 10.0),
	(453453453, 1, 20.0),
	(453453453, 2, 20.0),
	(666884444, 3, 40.0),
	(888665555, 20, null),
	(987654321, 20, 15.0),
	(987654321, 30, 20.0),
	(987987987, 10, 35.0),
	(987987987, 30, 5.0),
	(999887777, 10, 10.0),
	(999887777, 30, 30.0);

	
end //
delimiter ;


-- -[2]--------------------------------------------------
-- Create views to evaluate the queries & transactions
-- ------------------------------------------------------

create or replace view practiceQuery10 as select * from employee;
create or replace view practiceQuery11 as select * from department;
create or replace view practiceQuery12 as select * from dependent;
create or replace view practiceQuery13 as select * from dept_locations;
create or replace view practiceQuery14 as select * from project;
create or replace view practiceQuery15 as select * from works_on;

-- views here
create or replace view practiceQuery16 as select * from active_department_locations;
create or replace view practiceQuery17 as select * from employee_dashboard;

-- functions here
create or replace view practiceQuery18 as select sum_of_hours_based_on_birthdate('1970-01-01');
create or replace view practiceQuery19 as select sum_of_hours_based_on_birthdate('1966-01-01');



-- [3]-------------------------------------------------
-- Prepare to capture the query results for later analysis
-- -----------------------------------------------------

-- The magic44_data_capture table is used to store the data created by the student's queries
-- The table is populated by the magic44_evaluate_queries stored procedure
-- The data in the table is used to populate the magic44_test_results table for analysis

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stepID integer, queryID integer,
    columnDump0 varchar(1000), columnDump1 varchar(1000), columnDump2 varchar(1000), columnDump3 varchar(1000), columnDump4 varchar(1000),
    columnDump5 varchar(1000), columnDump6 varchar(1000), columnDump7 varchar(1000), columnDump8 varchar(1000), columnDump9 varchar(1000),
	columnDump10 varchar(1000), columnDump11 varchar(1000), columnDump12 varchar(1000), columnDump13 varchar(1000), columnDump14 varchar(1000)
);

-- The magic44_column_listing table is used to help prepare the insert statements for the magic44_data_capture
-- table for the student's queries which may have variable numbers of columns (the table is prepopulated)

drop table if exists magic44_column_listing;
create table magic44_column_listing (
	columnPosition integer,
    simpleColumnName varchar(50),
    nullColumnName varchar(50)
);

insert into magic44_column_listing (columnPosition, simpleColumnName) values
(0, 'columnDump0'), (1, 'columnDump1'), (2, 'columnDump2'), (3, 'columnDump3'), (4, 'columnDump4'),
(5, 'columnDump5'), (6, 'columnDump6'), (7, 'columnDump7'), (8, 'columnDump8'), (9, 'columnDump9'),
(10, 'columnDump10'), (11, 'columnDump11'), (12, 'columnDump12'), (13, 'columnDump13'), (14, 'columnDump14');

drop function if exists magic44_gen_simple_template;
delimiter //
create function magic44_gen_simple_template(numberOfColumns integer)
	returns varchar(1000) deterministic
begin
return (select group_concat(simpleColumnName separator ', ') from magic44_column_listing
	where columnPosition < numberOfColumns);
end //
delimiter ;

-- Create a variable to effectively act as a program counter for the testing process/steps
set @stepCounter = 0;

-- The magic44_query_capture function is used to construct the instruction
-- that can be used to execute and store the results of a query

drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer)
	returns varchar(1000) deterministic
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('practiceQuery', thisQuery));

	set @buildQuery = 'insert into magic44_data_capture (stepID, queryID, ';
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ') select ');
    set @buildQuery = concat(@buildQuery, @stepCounter, ', ');
    set @buildQuery = concat(@buildQuery, thisQuery, ', practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, '.* from practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, ';');

return @buildQuery;
end //
delimiter ;

drop function if exists magic44_query_exists;
delimiter //
create function magic44_query_exists(thisQuery integer)
	returns integer deterministic
begin
	return (select exists (select * from information_schema.views
		where table_schema = @thisDatabase
        and table_name like concat('practiceQuery', thisQuery)));
end //
delimiter ;

-- Exception checking has been implemented to prevent (as much as reasonably possible) errors
-- in the queries being evaluated from interrupting the testing process
-- The magic44_log_query_errors table captures these errors for later review

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	step_id integer,
    query_id integer,
    error_code char(5),
    error_message text
);

drop procedure if exists magic44_query_check_and_run;
delimiter //
create procedure magic44_query_check_and_run(in thisQuery integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;

	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

    declare continue handler for SQLWARNING
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		set @sql_text = magic44_query_capture(thisQuery);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000' then
			insert into magic44_log_query_errors values (@stepCounter, thisQuery, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [4] Organize the testing results by step and query identifiers
-- ----------------------------------------------------------------------------------

drop table if exists magic44_test_case_directory;
create table if not exists magic44_test_case_directory (
	base_step_id integer,
	number_of_steps integer,
    query_label char(20),
    query_name varchar(100),
    scoring_weight integer
);

insert into magic44_test_case_directory values
(0, 1, '[V_0]', 'initial_state_check', 0),
(5, 2, '[V_1]', 'active_department_locations', 10),
(10, 3, '[V_2]', 'employee_dashbaord', 10),
(15, 2, '[F_1]', 'sum_of_hours_based_on_birthdate', 10),
(20, 9, '[P_1]', 'add_employee', 10),
(30, 4, '[P_2]', 'relocate_department', 10);

drop table if exists magic44_scores_guide;
create table if not exists magic44_scores_guide (
    score_tag char(1),
    score_category varchar(100),
    display_order integer
);

insert into magic44_scores_guide values
('V', 'Views', 1), ('F', 'Functions', 2),
('P', 'Procedures', 3);

-- ----------------------------------------------------------------------------------
-- [5] Test the queries & transactions and store the results
-- ----------------------------------------------------------------------------------

-- utility stored procedures to help design test cases
delimiter //
create procedure deleteEmployee(in i_ssn varchar(40))
begin
	DELETE from employee where ssn = i_ssn;
end //
delimiter ;


delimiter //
create procedure addWorksOn(in i_ssn varchar(40), in i_pno INT, in i_hours FLOAT)
begin
	insert into works_on(essn,pno,hours) values(i_ssn,i_pno,i_hours);
end //
delimiter ;


delimiter //
create procedure addProject(in ip_pname varchar(40), in ip_pnumber INT, in ip_plocation varchar(40), in ip_dnum INT)
begin
	insert into project(pname, pnumber,plocation,dnum) values(ip_pname,ip_pnumber,ip_plocation, ip_dnum);
end //
delimiter ;


delimiter //
create procedure addDepLocation(in ip_dnumber INT, in ip_dlocation varchar(40))
begin
	insert into dept_locations(dnumber, dlocation) values(ip_dnumber, ip_dlocation);
end //
delimiter ;

-- Check that the initial state of their database matches the required configuration
-- The magic44_reset_database_state() call is missing in order to monitor the submitted database
set @stepCounter = 0;
call magic44_query_check_and_run(10);
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(12);
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(14);
call magic44_query_check_and_run(15);

-- Successful test: view active department locations
call magic44_reset_database_state();
set @stepCounter = 5;
call magic44_query_check_and_run(16);

-- Successful test: add a project and a location, then view active department locations
call magic44_reset_database_state();
call addDepLocation(1, 'Stafford');
call addProject('ProductA', 4, 'Stafford', 1);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(16);

-- Successful test: view employee dashboard
call magic44_reset_database_state();
set @stepCounter = 10;
call magic44_query_check_and_run(17);

-- Successful test: Delete an entry from the table and then check the employee dashboard
call magic44_reset_database_state();
call deleteEmployee('123456789');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(17);

-- Successful test: Add an entry in works_on table and then check the employee dashboard
call magic44_reset_database_state();
call addWorksOn('888665555', 1, 40);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(17);

-- Successful test: test sum_of_hours_based_on_birthdate function with input '1970-01-01'
call magic44_reset_database_state();
set @stepCounter = 15;
call magic44_query_check_and_run(18);

-- Successful test: test sum_of_hours_based_on_birthdate function with input '1966-01-01'
call magic44_reset_database_state();
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(19);

-- Successful test: add a new employee
call magic44_reset_database_state();
call add_employee('George', 'Burdell', '123456788', '1927-04-01', '801 Atlantic Avenue', 'M', 50000, '987654321', 5);
set @stepCounter = 20;
call magic44_query_check_and_run(10);

call magic44_reset_database_state();
call add_employee('Tom', 'George', '283948288', '1944-04-01', '801 Atlantic Avenue', 'M', 60000, '987654321', 4);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

call magic44_reset_database_state();
call add_employee('Jim', 'Price', '482737193', '1966-04-01', '801 Atlantic Avenue', 'M', 48032, '987654321', 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

call magic44_reset_database_state();
call add_employee('Mia', 'Stone', '628137473', '1967-04-01', '810 Atlantic Avenue', 'F', 51000, '987654321', 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

call magic44_reset_database_state();
call add_employee('Tina', 'Williams', '123456788', '1988-07-01', '770 Atlantic Avenue', 'F', 46500, '987654321', 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

-- Failed test: add an employee with duplicate ssn
call magic44_reset_database_state();
call add_employee('George', 'Burdell', '123456789', '1927-04-01', '801 Atlantic Avenue', 'M', 50000, '987654321', 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

-- Failed test: add an employee with invalid superssn
call magic44_reset_database_state();
call add_employee('George', 'Burdell', '123456788', '1927-04-01', '801 Atlantic Avenue', 'M', 50000, '111111111', 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

-- Failed test: add an employee with invalid department num
call magic44_reset_database_state();
call add_employee('George', 'Burdell', '123456788', '1927-04-01', '801 Atlantic Avenue', 'M', 50000, '987654321', 8);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

-- Failed test: add an employee with null input
call magic44_reset_database_state();
call add_employee('George', 'Burdell', NULL, '1927-04-01', '801 Atlantic Avenue', 'M', 50000, '987654321', 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(10);

-- Successful test: relocate department 4 to Atlanta
call magic44_reset_database_state();
call relocate_department(4, 'Atlanta');
set @stepCounter = 30;
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(14);

-- Successful test: relocate department 5 to Boston
call magic44_reset_database_state();
call relocate_department(5, 'Boston');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(14);

-- Failed test: relocate a department with empty location string
call magic44_reset_database_state();
call relocate_department(4, '');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(14);

-- Failed test: relocate a department with NULL location
call magic44_reset_database_state();
call relocate_department(4, NULL);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(14);

call magic44_reset_database_state();


-- ----------------------------------------------------------------------------------
-- [6] Collect and analyze the testing results for the student's submission
-- ----------------------------------------------------------------------------------

-- These tables are used to store the answers and test results.  The answers are generated by executing
-- the test script against our reference solution.  The test results are collected by running the test
-- script against your submission in order to compare the results.

-- The results from magic44_data_capture are transferred into the magic44_test_results table
drop table if exists magic44_test_results;
create table magic44_test_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

insert into magic44_test_results
select stepID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

-- the answers generated from the reference solution are loaded below
drop table if exists magic44_expected_results;
create table magic44_expected_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null,
    index (step_id),
    index (query_id)
);

insert into magic44_expected_results values
(5,16,'4#administration#stafford############'),
(5,16,'5#research#bellaire############'),
(5,16,'5#research#houston############'),
(5,16,'5#research#sugarland############'),
(6,16,'4#administration#stafford############'),
(6,16,'1#headquarters#houston############'),
(6,16,'1#headquarters#stafford############'),
(6,16,'5#research#bellaire############'),
(6,16,'5#research#houston############'),
(6,16,'5#research#sugarland############'),
(10,17,'john#40.0#30000#research#franklin##########'),
(10,17,'franklin#40.0#40000#research#james##########'),
(10,17,'joyce#40.0#25000#research#franklin##########'),
(10,17,'ramesh#40.0#38000#research#franklin##########'),
(10,17,'james##55000#headquarters###########'),
(10,17,'jennifer#35.0#43000#administration#james##########'),
(10,17,'ahmad#40.0#25000#administration#jennifer##########'),
(10,17,'alicia#40.0#25000#administration#jennifer##########'),
(11,17,'franklin#40.0#40000#research#james##########'),
(11,17,'joyce#40.0#25000#research#franklin##########'),
(11,17,'ramesh#40.0#38000#research#franklin##########'),
(11,17,'james##55000#headquarters###########'),
(11,17,'jennifer#35.0#43000#administration#james##########'),
(11,17,'ahmad#40.0#25000#administration#jennifer##########'),
(11,17,'alicia#40.0#25000#administration#jennifer##########'),
(12,17,'john#40.0#30000#research#franklin##########'),
(12,17,'franklin#40.0#40000#research#james##########'),
(12,17,'joyce#40.0#25000#research#franklin##########'),
(12,17,'ramesh#40.0#38000#research#franklin##########'),
(12,17,'james#40.0#55000#headquarters###########'),
(12,17,'jennifer#35.0#43000#administration#james##########'),
(12,17,'ahmad#40.0#25000#administration#jennifer##########'),
(12,17,'alicia#40.0#25000#administration#jennifer##########'),
(15,18,'235##############'),
(16,19,'155##############'),
(20,10,'george#burdell#123456788#1927-04-01#801atlanticavenue#m#50000#987654321#5######'),
(20,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(20,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(20,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(20,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(20,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(20,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(20,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(20,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(21,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(21,10,'tom#george#283948288#1944-04-01#801atlanticavenue#m#60000#987654321#4######'),
(21,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(21,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(21,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(21,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(21,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(21,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(21,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(22,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(22,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(22,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(22,10,'jim#price#482737193#1966-04-01#801atlanticavenue#m#48032#987654321#5######'),
(22,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(22,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(22,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(22,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(22,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(23,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(23,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(23,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(23,10,'mia#stone#628137473#1967-04-01#810atlanticavenue#f#51000#987654321#5######'),
(23,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(23,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(23,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(23,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(23,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(24,10,'tina#williams#123456788#1988-07-01#770atlanticavenue#f#46500#987654321#5######'),
(24,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(24,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(24,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(24,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(24,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(24,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(24,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(24,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(25,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(25,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(25,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(25,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(25,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(25,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(25,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(25,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(26,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(26,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(26,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(26,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(26,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(26,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(26,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(26,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(27,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(27,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(27,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(27,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(27,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(27,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(27,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(27,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(28,10,'john#smith#123456789#1965-01-09#731fondren,houstontx#m#30000#333445555#5######'),
(28,10,'franklin#wong#333445555#1955-12-08#638voss,houstontx#m#40000#888665555#5######'),
(28,10,'joyce#english#453453453#1972-07-31#5631rice,houstontx#f#25000#333445555#5######'),
(28,10,'ramesh#narayan#666884444#1962-09-15#975fireoak,humbletx#m#38000#333445555#5######'),
(28,10,'james#borg#888665555#1937-11-10#450stone,houstontx#m#55000##1######'),
(28,10,'jennifer#wallace#987654321#1941-06-20#291berry,bellairetx#f#43000#888665555#4######'),
(28,10,'ahmad#jabbar#987987987#1969-03-29#980dallas,houstontx#m#25000#987654321#4######'),
(28,10,'alicia#zelaya#999887777#1968-01-19#3321castle,springtx#f#25000#987654321#4######'),
(30,13,'1#houston#############'),
(30,13,'4#atlanta#############'),
(30,13,'4#stafford#############'),
(30,13,'5#bellaire#############'),
(30,13,'5#houston#############'),
(30,13,'5#sugarland#############'),
(30,14,'productx#1#bellaire#5###########'),
(30,14,'producty#2#sugarland#5###########'),
(30,14,'productz#3#houston#5###########'),
(30,14,'computerization#10#atlanta#4###########'),
(30,14,'reorganization#20#houston#1###########'),
(30,14,'newbenefits#30#atlanta#4###########'),
(31,13,'1#houston#############'),
(31,13,'4#stafford#############'),
(31,13,'5#bellaire#############'),
(31,13,'5#boston#############'),
(31,13,'5#houston#############'),
(31,13,'5#sugarland#############'),
(31,14,'productx#1#boston#5###########'),
(31,14,'producty#2#boston#5###########'),
(31,14,'productz#3#boston#5###########'),
(31,14,'computerization#10#stafford#4###########'),
(31,14,'reorganization#20#houston#1###########'),
(31,14,'newbenefits#30#stafford#4###########'),
(32,13,'1#houston#############'),
(32,13,'4#stafford#############'),
(32,13,'5#bellaire#############'),
(32,13,'5#houston#############'),
(32,13,'5#sugarland#############'),
(32,14,'productx#1#bellaire#5###########'),
(32,14,'producty#2#sugarland#5###########'),
(32,14,'productz#3#houston#5###########'),
(32,14,'computerization#10#stafford#4###########'),
(32,14,'reorganization#20#houston#1###########'),
(32,14,'newbenefits#30#stafford#4###########'),
(33,13,'1#houston#############'),
(33,13,'4#stafford#############'),
(33,13,'5#bellaire#############'),
(33,13,'5#houston#############'),
(33,13,'5#sugarland#############'),
(33,14,'productx#1#bellaire#5###########'),
(33,14,'producty#2#sugarland#5###########'),
(33,14,'productz#3#houston#5###########'),
(33,14,'computerization#10#stafford#4###########'),
(33,14,'reorganization#20#houston#1###########'),
(33,14,'newbenefits#30#stafford#4###########');



-- ----------------------------------------------------------------------------------
-- [7] Compare & evaluate the testing results
-- ----------------------------------------------------------------------------------

-- Delete the unneeded rows from the answers table to simplify later analysis
delete from magic44_expected_results where not magic44_query_exists(query_id);

-- Modify the row hash results for the results table to eliminate spaces and convert all characters to lowercase
update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

-- The magic44_count_differences view displays the differences between the number of rows contained in the answers
-- and the test results.  The value null in the answer_total and result_total columns represents zero (0) rows for
-- that query result.

drop view if exists magic44_count_answers;
create view magic44_count_answers as
select step_id, query_id, count(*) as answer_total
from magic44_expected_results group by step_id, query_id;

drop view if exists magic44_count_test_results;
create view magic44_count_test_results as
select step_id, query_id, count(*) as result_total
from magic44_test_results group by step_id, query_id;

drop view if exists magic44_count_differences;
create view magic44_count_differences as
select magic44_count_answers.query_id, magic44_count_answers.step_id, answer_total, result_total
from magic44_count_answers left outer join magic44_count_test_results
	on magic44_count_answers.step_id = magic44_count_test_results.step_id
	and magic44_count_answers.query_id = magic44_count_test_results.query_id
where answer_total <> result_total or result_total is null
union
select magic44_count_test_results.query_id, magic44_count_test_results.step_id, answer_total, result_total
from magic44_count_test_results left outer join magic44_count_answers
	on magic44_count_test_results.step_id = magic44_count_answers.step_id
	and magic44_count_test_results.query_id = magic44_count_answers.query_id
where result_total <> answer_total or answer_total is null
order by query_id, step_id;

-- The magic44_content_differences view displays the differences between the answers and test results
-- in terms of the row attributes and values.  the error_category column contains missing for rows that
-- are not included in the test results but should be, while extra represents the rows that should not
-- be included in the test results.  the row_hash column contains the values of the row in a single
-- string with the attribute values separated by a selected delimiter (i.e., the pound sign/#).

drop view if exists magic44_content_differences;
create view magic44_content_differences as
select query_id, step_id, 'missing' as category, row_hash
from magic44_expected_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_test_results)
union
select query_id, step_id, 'extra' as category, row_hash
from magic44_test_results where row(step_id, query_id, row_hash) not in
	(select step_id, query_id, row_hash from magic44_expected_results)
order by query_id, step_id, row_hash;

drop view if exists magic44_result_set_size_errors;
create view magic44_result_set_size_errors as
select step_id, query_id, 'result_set_size' as err_category from magic44_count_differences
group by step_id, query_id;

drop view if exists magic44_attribute_value_errors;
create view magic44_attribute_value_errors as
select step_id, query_id, 'attribute_values' as err_category from magic44_content_differences
where row(step_id, query_id) not in (select step_id, query_id from magic44_count_differences)
group by step_id, query_id;

drop view if exists magic44_errors_assembled;
create view magic44_errors_assembled as
select * from magic44_result_set_size_errors
union
select * from magic44_attribute_value_errors;

drop table if exists magic44_row_count_errors;
create table magic44_row_count_errors
select * from magic44_count_differences
order by query_id, step_id;

drop table if exists magic44_column_errors;
create table magic44_column_errors
select * from magic44_content_differences
order by query_id, step_id, row_hash;

drop view if exists magic44_fast_expected_results;
create view magic44_fast_expected_results as
select step_id, query_id, query_label, query_name
from magic44_expected_results, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_row_based_errors;
create view magic44_fast_row_based_errors as
select step_id, query_id, query_label, query_name
from magic44_row_count_errors, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_column_based_errors;
create view magic44_fast_column_based_errors as
select step_id, query_id, query_label, query_name
from magic44_column_errors, magic44_test_case_directory
where base_step_id <= step_id and step_id <= (base_step_id + number_of_steps - 1)
group by step_id, query_id, query_label, query_name;

drop view if exists magic44_fast_total_test_cases;
create view magic44_fast_total_test_cases as
select query_label, query_name, count(*) as total_cases
from magic44_fast_expected_results group by query_label, query_name;

drop view if exists magic44_fast_correct_test_cases;
create view magic44_fast_correct_test_cases as
select query_label, query_name, count(*) as correct_cases
from magic44_fast_expected_results where row(step_id, query_id) not in
(select step_id, query_id from magic44_fast_row_based_errors
union select step_id, query_id from magic44_fast_column_based_errors)
group by query_label, query_name;

drop table if exists magic44_autograding_low_level;
create table magic44_autograding_low_level
select magic44_fast_total_test_cases.*, ifnull(correct_cases, 0) as passed_cases
from magic44_fast_total_test_cases left outer join magic44_fast_correct_test_cases
on magic44_fast_total_test_cases.query_label = magic44_fast_correct_test_cases.query_label
and magic44_fast_total_test_cases.query_name = magic44_fast_correct_test_cases.query_name;

drop table if exists magic44_autograding_score_summary;
create table magic44_autograding_score_summary
select query_label, query_name,
	round(scoring_weight * passed_cases / total_cases, 2) as final_score, scoring_weight
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases < total_cases
union
select null, 'REMAINING CORRECT CASES', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory
where passed_cases = total_cases
union
select null, 'TOTAL SCORE', sum(round(scoring_weight * passed_cases / total_cases, 2)), null
from magic44_autograding_low_level natural join magic44_test_case_directory;

drop table if exists magic44_autograding_high_level;
create table magic44_autograding_high_level
select score_tag, score_category, sum(total_cases) as total_possible,
	sum(passed_cases) as total_passed
from magic44_scores_guide natural join
(select *, mid(query_label, 2, 1) as score_tag from magic44_autograding_low_level) as temp
group by score_tag order by display_order;

-- Evaluate potential query errors against the original state and the modified state
drop view if exists magic44_result_errs_original;
create view magic44_result_errs_original as
select distinct 'row_count_errors_initial_state' as title, query_id
from magic44_row_count_errors where step_id = 0;

drop view if exists magic44_result_errs_modified;
create view magic44_result_errs_modified as
select distinct 'row_count_errors_test_cases' as title, query_id
from magic44_row_count_errors
where query_id not in (select query_id from magic44_result_errs_original)
union
select * from magic44_result_errs_original;

drop view if exists magic44_attribute_errs_original;
create view magic44_attribute_errs_original as
select distinct 'column_errors_initial_state' as title, query_id
from magic44_column_errors where step_id = 0
and query_id not in (select query_id from magic44_result_errs_modified)
union
select * from magic44_result_errs_modified;

drop view if exists magic44_attribute_errs_modified;
create view magic44_attribute_errs_modified as
select distinct 'column_errors_test_cases' as title, query_id
from magic44_column_errors
where query_id not in (select query_id from magic44_attribute_errs_original)
union
select * from magic44_attribute_errs_original;

drop view if exists magic44_correct_remainders;
create view magic44_correct_remainders as
select distinct 'fully_correct' as title, query_id
from magic44_test_results
where query_id not in (select query_id from magic44_attribute_errs_modified)
union
select * from magic44_attribute_errs_modified;

drop view if exists magic44_grading_rollups;
create view magic44_grading_rollups as
select title, count(*) as number_affected, group_concat(query_id order by query_id asc) as queries_affected
from magic44_correct_remainders
group by title;

drop table if exists magic44_autograding_directory;
create table magic44_autograding_directory (query_status_category varchar(1000));
insert into magic44_autograding_directory values ('fully_correct'),
('column_errors_initial_state'), ('row_count_errors_initial_state'),
('column_errors_test_cases'), ('row_count_errors_test_cases');

drop table if exists magic44_autograding_query_level;
create table magic44_autograding_query_level
select query_status_category, number_affected, queries_affected
from magic44_autograding_directory left outer join magic44_grading_rollups
on query_status_category = title;

-- ----------------------------------------------------------------------------------
-- Validate/verify that the test case results are correct
-- The test case results are compared to the initial database state contents
-- ----------------------------------------------------------------------------------

drop procedure if exists magic44_check_test_case;
delimiter //
create procedure magic44_check_test_case(in ip_test_case_number integer)
begin
	select * from (select query_id, 'added' as category, row_hash
	from magic44_test_results where step_id = ip_test_case_number and row(query_id, row_hash) not in
		(select query_id, row_hash from magic44_expected_results where step_id = 0)
	union
	select temp.query_id, 'removed' as category, temp.row_hash
	from (select query_id, row_hash from magic44_expected_results where step_id = 0) as temp
	where row(temp.query_id, temp.row_hash) not in
		(select query_id, row_hash from magic44_test_results where step_id = ip_test_case_number)
	and temp.query_id in
		(select query_id from magic44_test_results where step_id = ip_test_case_number)) as unified
	order by query_id, row_hash;
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [8] Remove unneeded tables, views, stored procedures and functions
-- ----------------------------------------------------------------------------------

-- Keep only those structures needed to provide student feedback
drop table if exists magic44_autograding_directory;

drop view if exists magic44_grading_rollups;
drop view if exists magic44_correct_remainders;
drop view if exists magic44_attribute_errs_modified;
drop view if exists magic44_attribute_errs_original;
drop view if exists magic44_result_errs_modified;
drop view if exists magic44_result_errs_original;
drop view if exists magic44_errors_assembled;
drop view if exists magic44_attribute_value_errors;
drop view if exists magic44_result_set_size_errors;
drop view if exists magic44_content_differences;
drop view if exists magic44_count_differences;
drop view if exists magic44_count_test_results;
drop view if exists magic44_count_answers;

drop procedure if exists magic44_query_check_and_run;

drop function if exists magic44_query_exists;
drop function if exists magic44_query_capture;
drop function if exists magic44_gen_simple_template;

drop table if exists magic44_column_listing;

-- The magic44_reset_database_state() and magic44_check_test_case procedures can be
-- dropped if desired, but they might be helpful for troubleshooting
-- drop procedure if exists magic44_reset_database_state;
-- drop procedure if exists magic44_check_test_case;

drop view if exists practiceQuery10;
drop view if exists practiceQuery11;
drop view if exists practiceQuery12;
drop view if exists practiceQuery13;
drop view if exists practiceQuery14;
drop view if exists practiceQuery15;
drop view if exists practiceQuery16;
drop view if exists practiceQuery17;
drop view if exists practiceQuery18;
drop view if exists practiceQuery19;

drop procedure if exists addDepLocation;
drop procedure if exists addProject;
drop procedure if exists deleteEmployee;
drop procedure if exists addWorksOn;

drop view if exists magic44_fast_correct_test_cases;
drop view if exists magic44_fast_total_test_cases;
drop view if exists magic44_fast_column_based_errors;
drop view if exists magic44_fast_row_based_errors;
drop view if exists magic44_fast_expected_results;

drop table if exists magic44_scores_guide;