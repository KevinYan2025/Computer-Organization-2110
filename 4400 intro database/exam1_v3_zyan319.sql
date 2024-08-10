-- CS4400: Introduction to Database Systems
-- SQL Autograding Environment (v3): Global Company Database (EXAM 1)

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'global_company';

-- -------------------------------------------------
-- ENTER YOUR QUERY SOLUTIONS STARTING AT LINE 178
-- -------------------------------------------------

drop database if exists global_company;
create database if not exists global_company;
use global_company;

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

create table fund_source (
  fsid integer not null,
  remaining integer default null,
  usage_rate integer default null,
  pnumber decimal(2, 0) default null,
  primary key (fsid)
) engine = innodb;

create table customer (
  cid varchar(100) not null,
  company varchar(200) default null,
  location char(20) default null,
  assets integer default null,
  fsid integer not null,
  primary key (cid)
) engine = innodb;

create table budget (
  dnumber decimal(1, 0) not null,
  bcode integer not null,
  balance integer default null,
  fsid integer default null,
  primary key (dnumber, bcode)
) engine = innodb;

create table remote_access (
  ssn decimal(9, 0) not null,
  ip_address varchar(39) default null,
  user_account varchar(200) default null,
  primary key (ssn),
  unique key (ip_address)
) engine = innodb;

create table time_frames (
  ssn decimal(9, 0) not null,
  start_hour integer not null,
  duration integer not null,
  primary key (ssn, start_hour, duration)
) engine = innodb;

create table in_office (
  ssn decimal(9, 0) not null,
  building varchar(200) default null,
  room varchar(200) default null,
  primary key (ssn)
) engine = innodb;

create table analysis (
  pnumber decimal(2, 0) not null,
  title text default null,
  frequency integer default null,
  quantity integer default null,
  primary key (pnumber)
) engine = innodb;

create table operations (
  pnumber decimal(2, 0) not null,
  title text default null,
  team_size integer default null,
  primary key (pnumber)
) engine = innodb;

create table operation_skills (
  pnumber decimal(2, 0) not null,
  skill_name varchar(200) not null,
  primary key (pnumber, skill_name)
) engine = innodb;

create table maintenance (
  pnumber decimal(2, 0) not null,
  primary key (pnumber)
) engine = innodb;

create table maintenance_types (
  pnumber decimal(2, 0) not null,
  remote_access enum('none', 'intranet', 'vpn', 'open') not null,
  frequency integer not null,
  cost integer not null,
  primary key (pnumber, remote_access, frequency, cost)
) engine = innodb;

create table interns_in (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  dnumber decimal(1, 0) not null,
  rating integer default null,
  primary key (essn, dependent_name, dnumber)
) engine = innodb;

-- Enter your queries in the area below using this format:
-- create or replace view practiceQuery<#> as
-- <your proposed query solution>;

-- Be sure to end all queries with a semi-colon (';') and make sure that
-- the <#> value matches the query value from the practice sheet

-- -------------------------------------------------
-- view structures (student created solutions)
-- PUT ALL PROPOSED QUERY SOLUTIONS BELOW THIS LINE
-- -------------------------------------------------

/* practiceQuery1: Display the social security number of each unique employee
that works on a project for at least 10 hours a week, and at most 30 hours a week.*/
create or replace view practiceQuery1 as
select distinct essn from works_on where hours between 10 and 30;

/* practiceQuery2: Display the first name, last name, address, and birthday of every employee born in the month of January.*/
create or replace view practiceQuery2 as
select fname,lname,address,bdate from employee where bdate like '____-01-__';
/* practiceQuery3: Display the social security number and the number of dependents of every sponsor that has more than one dependent.*/
create or replace view practiceQuery3 as
select essn,count(*) from dependent group by essn having count(*)>1;

/* practiceQuery4: Display the project number, the total remaining funds, and the average usage rate for each project with an average use rate of at least 1500 per month.*/
create or replace view practiceQuery4 as
select pnumber, sum(remaining), avg(usage_rate) from fund_source group by pnumber having avg(usage_rate) >= 1500;
/* practiceQuery5: Display the project number, the number of employees working at least 10 hours, and the total hours worked by those employees for each project. Only consider projects that have at least two employees working at least 10 hours on them.*/
create or replace view practiceQuery5 as
select pno, count(*) as 'num_employees', sum(hours) from works_on where hours>=10 group by pno having count(*)>=2;

-- -------------------------------------------------
-- PUT ALL PROPOSED QUERY SOLUTIONS ABOVE THIS LINE
-- -------------------------------------------------

-- The sole purpose of the following instruction is to minimize the impact of student-entered code
-- on the remainder of the autograding processes below
set @unused_variable_dont_care_about_value = 0;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

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

insert into fund_source values
(2, 10000, 1000, 1),
(3, 27000, 1000, 2),
(5, 31000, 2000, 2),
(7, 16000, 1000, 3),
(11, 6000, 1000, 10),
(13, 9000, 2000, 10),
(17, 61000, 5000, 10),
(23, 24000, 3000, 20),
(29, 21000, 1000, 30);

insert into customer values
('bank1', 'Second National Bank', 'Dallas', 350000, 2),
('bank2', 'Tempest Bank', 'Atlanta', 200000, 3),
('mgmt1', 'Power, Water & Copper', 'Dallas', null, 7),
('tech2', 'Cumulus Cloud Computing', null, 380000, 11),
('tech3', null, 'Houston', 850000, 13),
('bank3', 'Credit Union Universal', 'New York', 417000, 23),
('bank4', 'Anytime Anywhere Crypto', 'Houston', 619000, 29);

insert into budget values
(1, 10, 170000, 5),
(4, 6, 64000, null),
(5, 0, 516000, 17);

insert into remote_access values
(666884444, '403e:8f59:336e:d11b:0425:ed18:2f34:48a3', 'rnarayan3'),
(888665555, '26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4', 'jborg1'),
(987654321, '3208:78e4:578b:034b:c7ff:1b55:6e41:8ece', 'jwallace3');

insert into time_frames values
(666884444, 13, 9),
(987654321, 11, 4),
(987654321, 23, 5),
(888665555, 15, 4);

insert into in_office values
(123456789, 'Main', '33-C'),
(333445555, 'Main', '100'),
(453453453, 'Main', '33-C'),
(987987987, 'Computing', 'Bridge'),
(999887777, 'Research', null);

insert into analysis values
(2, 'stock market prediction', 60, 2),
(30, 'cryptocurrency correlation', 30, 1);

insert into operations values
(2, 'stock ticker collection', 2),
(10, 'drone traffic control', 4),
(20, 'cloud conversion', 5),
(30, 'crypto monitoring', 2);

insert into operation_skills values
(2, 'financial analysis'),
(2, 'data storage management'),
(2, 'data visualization'),
(10, 'drone piloting'),
(10, 'real-time operating systems'),
(10, 'wireless networking'),
(20, 'cloud computing'),
(30, 'financial analysis'),
(30, 'data storage management'),
(30, 'pattern mining'),
(30, 'data visualization');

insert into maintenance values
(1),
(2),
(10);

insert into maintenance_types values
(1, 'intranet', 4, 500),
(1, 'open', 12, 100),
(2, 'none', 1, 2000),
(2, 'intranet', 10, 200),
(2, 'vpn', 30, 100),
(10, 'vpn', 4, 400),
(10, 'open', 20, 100);

insert into interns_in values
(123456789, 'Alice', 1, 7),
(123456789, 'Alice', 4, 8),
(123456789, 'Michael', 4, 6),
(123456789, 'Michael', 5, 8),
(333445555, 'Alice', 5, 10);

-- -[2]---------------------------------------------
-- database state management
-- -------------------------------------------------

create table magic44_database_state (
  state_id integer not null,
  state_description varchar(2000) default null,
  primary key (state_id)
) engine = innodb;

insert into magic44_database_state values
(0,'initial/original state'),
(1,'deleted department 4'),
(2,'deleted department 5'),
(3,'add new department 9'),
(4,'random value perturbations');

create table magic44_state_holds_rows (
  state_id integer not null,
  row_id varchar(100) not null,
  primary key (state_id, row_id)
) engine = innodb;

insert into magic44_state_holds_rows values
(0,'analysis_1'),
(0,'analysis_2'),
(0,'budget_1'),
(0,'budget_2'),
(0,'budget_3'),
(0,'customer_1'),
(0,'customer_2'),
(0,'customer_3'),
(0,'customer_4'),
(0,'customer_5'),
(0,'customer_6'),
(0,'customer_7'),
(0,'department_1'),
(0,'department_2'),
(0,'department_3'),
(0,'dependent_1'),
(0,'dependent_2'),
(0,'dependent_3'),
(0,'dependent_4'),
(0,'dependent_5'),
(0,'dependent_6'),
(0,'dependent_7'),
(0,'dept_locations_1'),
(0,'dept_locations_2'),
(0,'dept_locations_3'),
(0,'dept_locations_4'),
(0,'dept_locations_5'),
(0,'employee_1'),
(0,'employee_2'),
(0,'employee_3'),
(0,'employee_4'),
(0,'employee_5'),
(0,'employee_6'),
(0,'employee_7'),
(0,'employee_8'),
(0,'fund_source_1'),
(0,'fund_source_2'),
(0,'fund_source_3'),
(0,'fund_source_4'),
(0,'fund_source_5'),
(0,'fund_source_6'),
(0,'fund_source_7'),
(0,'fund_source_8'),
(0,'fund_source_9'),
(0,'in_office_1'),
(0,'in_office_2'),
(0,'in_office_3'),
(0,'in_office_4'),
(0,'in_office_5'),
(0,'interns_in_1'),
(0,'interns_in_2'),
(0,'interns_in_3'),
(0,'interns_in_4'),
(0,'interns_in_5'),
(0,'maintenance_1'),
(0,'maintenance_2'),
(0,'maintenance_3'),
(0,'maintenance_types_1'),
(0,'maintenance_types_2'),
(0,'maintenance_types_3'),
(0,'maintenance_types_4'),
(0,'maintenance_types_5'),
(0,'maintenance_types_6'),
(0,'maintenance_types_7'),
(0,'operation_skills_1'),
(0,'operation_skills_10'),
(0,'operation_skills_11'),
(0,'operation_skills_2'),
(0,'operation_skills_3'),
(0,'operation_skills_4'),
(0,'operation_skills_5'),
(0,'operation_skills_6'),
(0,'operation_skills_7'),
(0,'operation_skills_8'),
(0,'operation_skills_9'),
(0,'operations_1'),
(0,'operations_2'),
(0,'operations_3'),
(0,'operations_4'),
(0,'project_1'),
(0,'project_2'),
(0,'project_3'),
(0,'project_4'),
(0,'project_5'),
(0,'project_6'),
(0,'remote_access_1'),
(0,'remote_access_2'),
(0,'remote_access_3'),
(0,'time_frames_1'),
(0,'time_frames_2'),
(0,'time_frames_3'),
(0,'time_frames_4'),
(0,'works_on_1'),
(0,'works_on_10'),
(0,'works_on_11'),
(0,'works_on_12'),
(0,'works_on_13'),
(0,'works_on_14'),
(0,'works_on_15'),
(0,'works_on_16'),
(0,'works_on_2'),
(0,'works_on_3'),
(0,'works_on_4'),
(0,'works_on_5'),
(0,'works_on_6'),
(0,'works_on_7'),
(0,'works_on_8'),
(0,'works_on_9'),
(1,'analysis_1'),
(1,'budget_1'),
(1,'customer_1'),
(1,'customer_2'),
(1,'customer_3'),
(1,'customer_5'),
(1,'department_1'),
(1,'department_3'),
(1,'dependent_1'),
(1,'dependent_2'),
(1,'dependent_3'),
(1,'dependent_4'),
(1,'dependent_5'),
(1,'dependent_6'),
(1,'dept_locations_1'),
(1,'dept_locations_3'),
(1,'dept_locations_4'),
(1,'dept_locations_5'),
(1,'employee_1'),
(1,'employee_2'),
(1,'employee_3'),
(1,'employee_4'),
(1,'employee_5'),
(1,'fund_source_1'),
(1,'fund_source_2'),
(1,'fund_source_3'),
(1,'fund_source_4'),
(1,'fund_source_8'),
(1,'in_office_1'),
(1,'in_office_2'),
(1,'in_office_3'),
(1,'interns_in_1'),
(1,'interns_in_4'),
(1,'interns_in_5'),
(1,'maintenance_1'),
(1,'maintenance_2'),
(1,'maintenance_types_1'),
(1,'maintenance_types_2'),
(1,'maintenance_types_3'),
(1,'maintenance_types_4'),
(1,'maintenance_types_5'),
(1,'operation_skills_1'),
(1,'operation_skills_2'),
(1,'operation_skills_3'),
(1,'operation_skills_7'),
(1,'operations_1'),
(1,'operations_3'),
(1,'project_1'),
(1,'project_2'),
(1,'project_3'),
(1,'project_5'),
(1,'remote_access_1'),
(1,'remote_access_2'),
(1,'time_frames_1'),
(1,'time_frames_2'),
(1,'works_on_1'),
(1,'works_on_10'),
(1,'works_on_2'),
(1,'works_on_3'),
(1,'works_on_4'),
(1,'works_on_6'),
(1,'works_on_7'),
(1,'works_on_8'),
(1,'works_on_9'),
(2,'analysis_2'),
(2,'budget_2'),
(2,'customer_3'),
(2,'customer_4'),
(2,'customer_6'),
(2,'customer_7'),
(2,'department_1'),
(2,'department_2'),
(2,'dependent_7'),
(2,'dept_locations_1'),
(2,'dept_locations_2'),
(2,'employee_5'),
(2,'employee_6'),
(2,'employee_7'),
(2,'employee_8'),
(2,'fund_source_5'),
(2,'fund_source_6'),
(2,'fund_source_7'),
(2,'fund_source_8'),
(2,'fund_source_9'),
(2,'in_office_4'),
(2,'in_office_5'),
(2,'maintenance_3'),
(2,'maintenance_types_6'),
(2,'maintenance_types_7'),
(2,'operation_skills_10'),
(2,'operation_skills_11'),
(2,'operation_skills_4'),
(2,'operation_skills_5'),
(2,'operation_skills_6'),
(2,'operation_skills_7'),
(2,'operation_skills_8'),
(2,'operation_skills_9'),
(2,'operations_2'),
(2,'operations_3'),
(2,'operations_4'),
(2,'project_4'),
(2,'project_5'),
(2,'project_6'),
(2,'remote_access_2'),
(2,'remote_access_3'),
(2,'time_frames_2'),
(2,'time_frames_3'),
(2,'time_frames_4'),
(2,'works_on_10'),
(2,'works_on_11'),
(2,'works_on_12'),
(2,'works_on_13'),
(2,'works_on_14'),
(2,'works_on_15'),
(2,'works_on_16'),
(3,'analysis_1'),
(3,'analysis_2'),
(3,'budget_1'),
(3,'budget_2'),
(3,'budget_3'),
(3,'budget_5'),
(3,'customer_1'),
(3,'customer_10'),
(3,'customer_2'),
(3,'customer_3'),
(3,'customer_4'),
(3,'customer_5'),
(3,'customer_6'),
(3,'customer_7'),
(3,'department_1'),
(3,'department_2'),
(3,'department_3'),
(3,'department_4'),
(3,'dependent_1'),
(3,'dependent_10'),
(3,'dependent_2'),
(3,'dependent_3'),
(3,'dependent_4'),
(3,'dependent_5'),
(3,'dependent_6'),
(3,'dependent_7'),
(3,'dependent_9'),
(3,'dept_location_6'),
(3,'dept_location_7'),
(3,'dept_locations_1'),
(3,'dept_locations_2'),
(3,'dept_locations_3'),
(3,'dept_locations_4'),
(3,'dept_locations_5'),
(3,'employee_1'),
(3,'employee_10'),
(3,'employee_11'),
(3,'employee_12'),
(3,'employee_13'),
(3,'employee_2'),
(3,'employee_3'),
(3,'employee_4'),
(3,'employee_5'),
(3,'employee_6'),
(3,'employee_7'),
(3,'employee_8'),
(3,'employee_9'),
(3,'fund_source_1'),
(3,'fund_source_2'),
(3,'fund_source_20'),
(3,'fund_source_21'),
(3,'fund_source_3'),
(3,'fund_source_4'),
(3,'fund_source_5'),
(3,'fund_source_6'),
(3,'fund_source_7'),
(3,'fund_source_8'),
(3,'fund_source_9'),
(3,'in_office_1'),
(3,'in_office_2'),
(3,'in_office_3'),
(3,'in_office_4'),
(3,'in_office_5'),
(3,'in_office_6'),
(3,'interns_in_1'),
(3,'interns_in_10'),
(3,'interns_in_2'),
(3,'interns_in_3'),
(3,'interns_in_4'),
(3,'interns_in_5'),
(3,'interns_in_9'),
(3,'maintenance_1'),
(3,'maintenance_2'),
(3,'maintenance_3'),
(3,'maintenance_5'),
(3,'maintenance_types_1'),
(3,'maintenance_types_10'),
(3,'maintenance_types_2'),
(3,'maintenance_types_3'),
(3,'maintenance_types_4'),
(3,'maintenance_types_5'),
(3,'maintenance_types_6'),
(3,'maintenance_types_7'),
(3,'maintenance_types_9'),
(3,'operation_skills_1'),
(3,'operation_skills_10'),
(3,'operation_skills_11'),
(3,'operation_skills_2'),
(3,'operation_skills_22'),
(3,'operation_skills_3'),
(3,'operation_skills_4'),
(3,'operation_skills_5'),
(3,'operation_skills_6'),
(3,'operation_skills_7'),
(3,'operation_skills_8'),
(3,'operation_skills_9'),
(3,'operations_1'),
(3,'operations_2'),
(3,'operations_3'),
(3,'operations_4'),
(3,'operations_9'),
(3,'project_1'),
(3,'project_12'),
(3,'project_2'),
(3,'project_3'),
(3,'project_4'),
(3,'project_5'),
(3,'project_6'),
(3,'remote_access_1'),
(3,'remote_access_2'),
(3,'remote_access_3'),
(3,'remote_access_5'),
(3,'remote_access_6'),
(3,'time_frames_1'),
(3,'time_frames_10'),
(3,'time_frames_11'),
(3,'time_frames_2'),
(3,'time_frames_3'),
(3,'time_frames_4'),
(3,'time_frames_9'),
(3,'works_on_1'),
(3,'works_on_10'),
(3,'works_on_11'),
(3,'works_on_12'),
(3,'works_on_13'),
(3,'works_on_14'),
(3,'works_on_15'),
(3,'works_on_16'),
(3,'works_on_2'),
(3,'works_on_3'),
(3,'works_on_36'),
(3,'works_on_37'),
(3,'works_on_38'),
(3,'works_on_4'),
(3,'works_on_5'),
(3,'works_on_6'),
(3,'works_on_7'),
(3,'works_on_8'),
(3,'works_on_9'),
(4,'analysis_1'),
(4,'analysis_2'),
(4,'budget_6'),
(4,'budget_7'),
(4,'budget_8'),
(4,'customer_11'),
(4,'customer_12'),
(4,'customer_13'),
(4,'customer_14'),
(4,'customer_15'),
(4,'customer_3'),
(4,'customer_5'),
(4,'department_1'),
(4,'department_2'),
(4,'department_3'),
(4,'dependent_1'),
(4,'dependent_2'),
(4,'dependent_3'),
(4,'dependent_4'),
(4,'dependent_5'),
(4,'dependent_6'),
(4,'dependent_7'),
(4,'dept_locations_1'),
(4,'dept_locations_2'),
(4,'dept_locations_3'),
(4,'dept_locations_4'),
(4,'dept_locations_5'),
(4,'employee_16'),
(4,'employee_17'),
(4,'employee_18'),
(4,'employee_19'),
(4,'employee_20'),
(4,'employee_3'),
(4,'employee_4'),
(4,'employee_5'),
(4,'fund_source_23'),
(4,'fund_source_24'),
(4,'fund_source_25'),
(4,'fund_source_26'),
(4,'fund_source_27'),
(4,'fund_source_28'),
(4,'fund_source_29'),
(4,'fund_source_30'),
(4,'fund_source_31'),
(4,'in_office_1'),
(4,'in_office_2'),
(4,'in_office_3'),
(4,'in_office_4'),
(4,'in_office_5'),
(4,'interns_in_12'),
(4,'interns_in_13'),
(4,'interns_in_14'),
(4,'interns_in_2'),
(4,'interns_in_4'),
(4,'maintenance_1'),
(4,'maintenance_2'),
(4,'maintenance_3'),
(4,'maintenance_types_12'),
(4,'maintenance_types_13'),
(4,'maintenance_types_14'),
(4,'maintenance_types_15'),
(4,'maintenance_types_16'),
(4,'maintenance_types_3'),
(4,'maintenance_types_6'),
(4,'operation_skills_1'),
(4,'operation_skills_10'),
(4,'operation_skills_11'),
(4,'operation_skills_2'),
(4,'operation_skills_3'),
(4,'operation_skills_4'),
(4,'operation_skills_5'),
(4,'operation_skills_6'),
(4,'operation_skills_7'),
(4,'operation_skills_8'),
(4,'operation_skills_9'),
(4,'operations_1'),
(4,'operations_2'),
(4,'operations_3'),
(4,'operations_4'),
(4,'project_1'),
(4,'project_2'),
(4,'project_3'),
(4,'project_4'),
(4,'project_5'),
(4,'project_6'),
(4,'remote_access_1'),
(4,'remote_access_2'),
(4,'remote_access_3'),
(4,'time_frames_1'),
(4,'time_frames_2'),
(4,'time_frames_3'),
(4,'time_frames_4'),
(4,'works_on_10'),
(4,'works_on_14'),
(4,'works_on_15'),
(4,'works_on_39'),
(4,'works_on_40'),
(4,'works_on_41'),
(4,'works_on_42'),
(4,'works_on_43'),
(4,'works_on_44'),
(4,'works_on_45'),
(4,'works_on_46'),
(4,'works_on_47'),
(4,'works_on_48'),
(4,'works_on_49'),
(4,'works_on_50'),
(4,'works_on_6');

create table magic44_employee_datastore (
  fname char(10) not null,
  lname char(20) not null,
  ssn decimal(9, 0) not null,
  bdate date not null,
  address char(30) not null,
  sex char(1) not null,
  salary decimal(5, 0) not null,
  superssn decimal(9, 0) default null,
  dno decimal(1, 0) not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_employee_datastore values
('John','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5,'employee_1',1),
('Franklin','Wong',333445555,'1955-12-08','638 Voss, Houston TX','M',40000,888665555,5,'employee_2',2),
('Joyce','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5,'employee_3',3),
('Ramesh','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5,'employee_4',4),
('James','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1,'employee_5',5),
('Jennifer','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4,'employee_6',6),
('Ahmad','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4,'employee_7',7),
('Alicia','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4,'employee_8',8),
('Camila','Jackson',163479608,'1975-04-20','3830 Stellar Fruit, Tulsa OK','F',37000,235711131,9,'employee_9',9),
('Hector','Cuevas',235711131,'1970-11-06','107 Five Finger Way, Dallas TX','M',31000,888665555,9,'employee_10',10),
('Heike','Weiss',378990405,'1966-11-13','219 Zoo Palast, Norman OK','F',41000,235711131,9,'employee_11',11),
('Hiroto','Watanabe',510176317,'1961-11-17','606 Spring Tail, Houston TX','M',38000,235711131,9,'employee_12',12),
('Alicia','Smith',701294005,'1967-03-19','2 Teleport, Dallas TX','F',51000,235711131,9,'employee_13',13),
('John','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',36000,333445555,5,'employee_16',16),
('Franklin','Wong',333445555,'1955-12-08','638 Voss, Houston TX','M',37000,888665555,5,'employee_17',17),
('Jennifer','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',46000,888665555,4,'employee_18',18),
('Ahmad','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',34000,987654321,4,'employee_19',19),
('Alicia','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',31000,987654321,4,'employee_20',20);

create table magic44_dependent_datastore (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  sex char(1) not null,
  bdate date not null,
  relationship char(30) not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_dependent_datastore values
(123456789,'Alice','F','1988-12-30','Daughter','dependent_1',1),
(123456789,'Elizabeth','F','1967-05-05','Spouse','dependent_2',2),
(123456789,'Michael','M','1988-01-04','Son','dependent_3',3),
(333445555,'Alice','F','1986-04-04','Daughter','dependent_4',4),
(333445555,'Joy','F','1958-05-03','Spouse','dependent_5',5),
(333445555,'Theodore','M','1983-10-25','Son','dependent_6',6),
(987654321,'Abner','M','1942-02-28','Spouse','dependent_7',7),
(999887777,'Aurora','F','2010-01-01','Daughter','dependent_8',8),
(378990405,'Ariel','M','1989-05-25','Son','dependent_9',9),
(378990405,'Florence','F','1966-01-25','Spouse','dependent_10',10);

create table magic44_department_datastore (
  dname char(20) not null,
  dnumber decimal(1, 0) not null,
  mgrssn decimal(9, 0) not null,
  mgrstartdate date not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_department_datastore values
('Headquarters',1,888665555,'1981-06-19','department_1',1),
('Administration',4,987654321,'1995-01-01','department_2',2),
('Research',5,333445555,'1988-05-22','department_3',3),
('Reverse Engineering',9,235711131,'2002-06-22','department_4',4);

create table magic44_dept_locations_datastore (
  dnumber decimal(1, 0) not null,
  dlocation char(15) not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_dept_locations_datastore values
(1,'Houston','dept_locations_1',1),
(4,'Stafford','dept_locations_2',2),
(5,'Bellaire','dept_locations_3',3),
(5,'Houston','dept_locations_4',4),
(5,'Sugarland','dept_locations_5',5),
(9,'Dallas','dept_location_6',6),
(9,'Sugarland','dept_location_7',7);

create table magic44_project_datastore (
  pname char(20) not null,
  pnumber decimal(2, 0) not null,
  plocation char(20) not null,
  dnum decimal(1, 0) not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_project_datastore values
('ProductX',1,'Bellaire',5,'project_1',1),
('ProductY',2,'Sugarland',5,'project_2',2),
('ProductZ',3,'Houston',5,'project_3',3),
('Computerization',10,'Stafford',4,'project_4',4),
('Reorganization',20,'Houston',1,'project_5',5),
('Newbenefits',30,'Stafford',4,'project_6',6),
('Special',41,'Stafford',4,'project_8',8),
('Community',43,'Amarillo',5,'project_9',9),
('WrongPlace',55,'Bellaire',4,'project_10',10),
('WrongDept',66,'Amarillo',1,'project_11',11),
('Hindsight',55,'Dallas',9,'project_12',12);

create table magic44_works_on_datastore (
  essn decimal(9, 0) not null,
  pno decimal(2, 0) not null,
  hours decimal(5, 1) default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_works_on_datastore values
(123456789,1,32.5,'works_on_1',1),
(123456789,2,7.5,'works_on_2',2),
(333445555,2,10.0,'works_on_3',3),
(333445555,3,10.0,'works_on_4',4),
(333445555,10,10.0,'works_on_5',5),
(333445555,20,10.0,'works_on_6',6),
(453453453,1,20.0,'works_on_7',7),
(453453453,2,20.0,'works_on_8',8),
(666884444,3,40.0,'works_on_9',9),
(888665555,20,null,'works_on_10',10),
(987654321,20,15.0,'works_on_11',11),
(987654321,30,20.0,'works_on_12',12),
(987987987,10,35.0,'works_on_13',13),
(987987987,30,5.0,'works_on_14',14),
(999887777,10,10.0,'works_on_15',15),
(999887777,30,30.0,'works_on_16',16),
(123456789,41,99.0,'works_on_32',32),
(333445555,41,99.0,'works_on_33',33),
(333445555,43,99.0,'works_on_34',34),
(987654321,41,99.0,'works_on_35',35),
(163479608,55,35.0,'works_on_36',36),
(235711131,55,10.0,'works_on_37',37),
(701294005,55,20.0,'works_on_38',38),
(123456789,1,44.5,'works_on_39',39),
(123456789,2,9.0,'works_on_40',40),
(333445555,2,11.5,'works_on_41',41),
(333445555,3,14.5,'works_on_42',42),
(333445555,10,13.0,'works_on_43',43),
(453453453,1,30.5,'works_on_44',44),
(453453453,2,27.5,'works_on_45',45),
(666884444,3,49.0,'works_on_46',46),
(987654321,20,27.0,'works_on_47',47),
(987654321,30,24.5,'works_on_48',48),
(987987987,10,41.0,'works_on_49',49),
(999887777,30,31.5,'works_on_50',50);

create table magic44_fund_source_datastore (
  fsid integer not null,
  remaining integer default null,
  usage_rate integer default null,
  pnumber decimal(2, 0) default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_fund_source_datastore values
(2,10000,1000,1,'fund_source_1',1),
(3,27000,1000,2,'fund_source_2',2),
(5,31000,2000,2,'fund_source_3',3),
(7,16000,1000,3,'fund_source_4',4),
(11,6000,1000,10,'fund_source_5',5),
(13,9000,2000,10,'fund_source_6',6),
(17,61000,5000,10,'fund_source_7',7),
(23,24000,3000,20,'fund_source_8',8),
(29,21000,1000,30,'fund_source_9',9),
(31,6999,500,1,'fund_source_16',16),
(37,7000,500,1,'fund_source_17',17),
(41,7000,500,1,'fund_source_18',18),
(43,23400,1500,3,'fund_source_19',19),
(31,66000,3000,55,'fund_source_20',20),
(37,29000,1000,55,'fund_source_21',21),
(2,6000,1000,1,'fund_source_23',23),
(3,19000,1000,2,'fund_source_24',24),
(5,29000,2000,2,'fund_source_25',25),
(7,12000,1000,3,'fund_source_26',26),
(11,0,1000,10,'fund_source_27',27),
(13,3000,2000,10,'fund_source_28',28),
(17,59000,5000,10,'fund_source_29',29),
(23,25000,3000,20,'fund_source_30',30),
(29,20000,1000,30,'fund_source_31',31);

create table magic44_customer_datastore (
  cid varchar(100) not null,
  company varchar(200) default null,
  location char(20) default null,
  assets integer default null,
  fsid integer not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_customer_datastore values
('bank1','Second National Bank','Dallas',350000,2,'customer_1',1),
('bank2','Tempest Bank','Atlanta',200000,3,'customer_2',2),
('bank3','Credit Union Universal','New York',417000,23,'customer_3',3),
('bank4','Anytime Anywhere Crypto','Houston',619000,29,'customer_4',4),
('mgmt1','Power, Water & Copper','Dallas',null,7,'customer_5',5),
('tech2','Cumulus Cloud Computing',null,380000,11,'customer_6',6),
('tech3',null,'Houston',850000,13,'customer_7',7),
('ebank1','Fourth National Bank','Miami',600000,2,'customer_8',8),
('ebank2','Third National Bank','Dallas',500000,2,'customer_9',9),
('mgmt2','Shell Oil & Gas','Lubbock',415000,37,'customer_10',10),
('bank1','Second National Bank','Dallas',360000,2,'customer_11',11),
('bank2','Tempest Bank','Atlanta',220000,3,'customer_12',12),
('bank4','Anytime Anywhere Crypto','Houston',649000,29,'customer_13',13),
('tech2','Cumulus Cloud Computing',null,370000,11,'customer_14',14),
('tech3',null,'Houston',840000,13,'customer_15',15);

create table magic44_budget_datastore (
  dnumber decimal(1, 0) not null,
  bcode integer not null,
  balance integer default null,
  fsid integer default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_budget_datastore values
(1,10,170000,5,'budget_1',1),
(4,6,64000,null,'budget_2',2),
(5,0,516000,17,'budget_3',3),
(4,99,164000,43,'budget_4',4),
(9,5,100000,31,'budget_5',5),
(1,10,160000,5,'budget_6',6),
(4,6,74000,null,'budget_7',7),
(5,0,506000,17,'budget_8',8);

create table magic44_remote_access_datastore (
  ssn decimal(9, 0) not null,
  ip_address varchar(39) default null,
  user_account varchar(200) default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_remote_access_datastore values
(666884444,'403e:8f59:336e:d11b:0425:ed18:2f34:48a3','rnarayan3','remote_access_1',1),
(888665555,'26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4','jborg1','remote_access_2',2),
(987654321,'3208:78e4:578b:034b:c7ff:1b55:6e41:8ece','jwallace3','remote_access_3',3),
(987654321,'3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf','jwallace3','remote_access_4',4),
(378990405,'27ad:3301:bc3f:0002:0004:0015:41fe:3e3a','hweiss10','remote_access_5',5),
(701294005,'403e:4186:578b:0002:0425:4b03:6e41:3e3a','asmith26','remote_access_6',6);

create table magic44_time_frames_datastore (
  ssn decimal(9, 0) not null,
  start_hour integer not null,
  duration integer not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_time_frames_datastore values
(666884444,13,9,'time_frames_1',1),
(888665555,15,4,'time_frames_2',2),
(987654321,11,4,'time_frames_3',3),
(987654321,23,5,'time_frames_4',4),
(987654321,6,3,'time_frames_8',8),
(378990405,20,8,'time_frames_9',9),
(701294005,5,10,'time_frames_10',10),
(701294005,23,2,'time_frames_11',11);

create table magic44_in_office_datastore (
  ssn decimal(9, 0) not null,
  building varchar(200) default null,
  room varchar(200) default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_in_office_datastore values
(123456789,'Main','33-C','in_office_1',1),
(333445555,'Main','100','in_office_2',2),
(453453453,'Main','33-C','in_office_3',3),
(987987987,'Computing','Bridge','in_office_4',4),
(999887777,'Research',null,'in_office_5',5),
(235711131,'Main','100','in_office_6',6);

create table magic44_analysis_datastore (
  pnumber decimal(2, 0) not null,
  title text default null,
  frequency integer default null,
  quantity integer default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_analysis_datastore values
(2,'stock market prediction',60,2,'analysis_1',1),
(30,'cryptocurrency correlation',30,1,'analysis_2',2);

create table magic44_operations_datastore (
  pnumber decimal(2, 0) not null,
  title text default null,
  team_size integer default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_operations_datastore values
(2,'stock ticker collection',2,'operations_1',1),
(10,'drone traffic control',4,'operations_2',2),
(20,'cloud conversion',5,'operations_3',3),
(30,'crypto monitoring',2,'operations_4',4),
(1,'foreign language translation',31,'operations_8',8),
(55,'dataflow graph analysis',6,'operations_9',9);

create table magic44_operation_skills_datastore (
  pnumber decimal(2, 0) not null,
  skill_name varchar(200) not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_operation_skills_datastore values
(2,'data storage management','operation_skills_1',1),
(2,'data visualization','operation_skills_2',2),
(2,'financial analysis','operation_skills_3',3),
(10,'drone piloting','operation_skills_4',4),
(10,'real-time operating systems','operation_skills_5',5),
(10,'wireless networking','operation_skills_6',6),
(20,'cloud computing','operation_skills_7',7),
(30,'data storage management','operation_skills_8',8),
(30,'data visualization','operation_skills_9',9),
(30,'financial analysis','operation_skills_10',10),
(30,'pattern mining','operation_skills_11',11),
(2,'cloud computing','operation_skills_16',16),
(2,'deep-space astronomical data','operation_skills_17',17),
(2,'no-code automated data correlation','operation_skills_18',18),
(2,'non-relational database','operation_skills_19',19),
(20,'scalable quantum computing','operation_skills_20',20),
(20,'scalable virtual reality','operation_skills_21',21),
(55,'dataflow graph analysis','operation_skills_22',22);

create table magic44_maintenance_datastore (
  pnumber decimal(2, 0) not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_maintenance_datastore values
(1,'maintenance_1',1),
(2,'maintenance_2',2),
(10,'maintenance_3',3),
(30,'maintenance_4',4),
(55,'maintenance_5',5);

create table magic44_maintenance_types_datastore (
  pnumber decimal(2, 0) not null,
  remote_access enum('none', 'intranet', 'vpn', 'open') not null,
  frequency integer not null,
  cost integer not null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_maintenance_types_datastore values
(1,'intranet',4,500,'maintenance_types_1',1),
(1,'open',12,100,'maintenance_types_2',2),
(2,'none',1,2000,'maintenance_types_3',3),
(2,'intranet',10,200,'maintenance_types_4',4),
(2,'vpn',30,100,'maintenance_types_5',5),
(10,'vpn',4,400,'maintenance_types_6',6),
(10,'open',20,100,'maintenance_types_7',7),
(10,'intranet',4,50,'maintenance_types_8',8),
(55,'intranet',15,600,'maintenance_types_9',9),
(55,'vpn',2,2000,'maintenance_types_10',10),
(1,'intranet',4,700,'maintenance_types_12',12),
(1,'open',12,200,'maintenance_types_13',13),
(2,'intranet',10,300,'maintenance_types_14',14),
(2,'vpn',30,200,'maintenance_types_15',15),
(10,'open',20,300,'maintenance_types_16',16);

create table magic44_interns_in_datastore (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  dnumber decimal(1, 0) not null,
  rating integer default null,
  row_id varchar(100) default null,
  auto_id integer not null auto_increment,
  primary key (auto_id)
) engine = innodb;

insert into magic44_interns_in_datastore values
(123456789,'Alice',1,7,'interns_in_1',1),
(123456789,'Alice',4,8,'interns_in_2',2),
(123456789,'Michael',4,6,'interns_in_3',3),
(123456789,'Michael',5,8,'interns_in_4',4),
(333445555,'Alice',5,10,'interns_in_5',5),
(999887777,'Aurora',4,9,'interns_in_8',8),
(378990405,'Ariel',5,8,'interns_in_9',9),
(378990405,'Ariel',9,8,'interns_in_10',10),
(123456789,'Alice',1,6,'interns_in_12',12),
(123456789,'Michael',4,5,'interns_in_13',13),
(333445555,'Alice',5,8,'interns_in_14',14);

-- -------------------------------------------------
-- allow controlled changes to the database state
-- -------------------------------------------------

drop procedure if exists magic44_set_database_state;
delimiter //
create procedure magic44_set_database_state (in requestedState integer)
begin
	-- Purge and then reload all of the database rows back into the tables.
    -- Ensure that the data is deleted in reverse order with respect to the
    -- foreign key dependencies (i.e., from children up to parents).
	delete from interns_in;
	delete from maintenance_types;
	delete from maintenance;
	delete from operation_skills;
	delete from operations;
	delete from analysis;
	delete from in_office;
	delete from time_frames;
	delete from remote_access;
	delete from customer;
	delete from budget;
	delete from fund_source;
	delete from dept_locations;
	delete from works_on;
	delete from dependent;
	delete from project;
	delete from department;
	delete from employee;
    
    -- Check the validity of the requested state
    if exists(select * from magic44_state_holds_rows where state_id = requestedState) then
		set @trueState = requestedState;
	else
		set @trueState = 0;
	end if;

    -- Ensure that the data is inserted in order with respect to the foreign
    -- key dependencies (i.e., from parents down to children)
    insert into employee (select fname, lname, ssn, bdate, address, sex, salary,
		superssn, dno from magic44_employee_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into dependent (select essn, dependent_name, sex, bdate, relationship
		from magic44_dependent_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into department (select dname, dnumber, mgrssn, mgrstartdate
		from magic44_department_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into dept_locations (select dnumber, dlocation
		from magic44_dept_locations_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into project (select pname, pnumber, plocation, dnum
		from magic44_project_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into works_on (select essn, pno, hours
		from magic44_works_on_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into fund_source (select fsid, remaining, usage_rate, pnumber
		from magic44_fund_source_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into customer (select cid, company, location, assets, fsid
		from magic44_customer_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));        
	insert into budget (select dnumber, bcode, balance, fsid
		from magic44_budget_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into remote_access (select ssn, ip_address, user_account
		from magic44_remote_access_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into time_frames (select ssn, start_hour, duration
		from magic44_time_frames_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));        
	insert into in_office (select ssn, building, room
		from magic44_in_office_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into analysis (select pnumber, title, frequency, quantity
		from magic44_analysis_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));        
	insert into operations (select pnumber, title, team_size
		from magic44_operations_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));        
	insert into operation_skills (select pnumber, skill_name
		from magic44_operation_skills_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into maintenance (select pnumber
		from magic44_maintenance_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into maintenance_types (select pnumber, remote_access, frequency, cost
		from magic44_maintenance_types_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
	insert into interns_in (select essn, dependent_name, dnumber, rating
		from magic44_interns_in_datastore where row_id in
        (select row_id from magic44_state_holds_rows where state_id = @trueState));
end //
delimiter ;

-- -------------------------------------------------
-- expected answers for autograding comparisons
-- -------------------------------------------------

-- These tables are used to store the answers and test results.  The answers are generated by executing
-- the test script against our reference solution.  The test results are collected by running the test
-- script against your submission in order to compare the results.

-- the results from magic44_data_capture the are transferred into the magic44_test_results table
drop table if exists magic44_test_results;
create table magic44_test_results (
	state_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

-- the answers generated from the reference solution are loaded below
drop table if exists magic44_expected_results;
create table magic44_expected_results (
	state_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

INSERT INTO magic44_expected_results VALUES (0,1,'result#set#exists############'),(0,2,'result#set#exists############'),(0,3,'result#set#exists############'),(0,4,'result#set#exists############'),(0,5,'result#set#exists############'),(1,1,'result#set#exists############'),(1,2,'result#set#exists############'),(1,3,'result#set#exists############'),(1,4,'result#set#exists############'),(1,5,'result#set#exists############'),(2,1,'result#set#exists############'),(2,2,'result#set#exists############'),(2,3,'result#set#exists############'),(2,4,'result#set#exists############'),(2,5,'result#set#exists############'),(3,1,'result#set#exists############'),(3,2,'result#set#exists############'),(3,3,'result#set#exists############'),(3,4,'result#set#exists############'),(3,5,'result#set#exists############'),(4,1,'result#set#exists############'),(4,2,'result#set#exists############'),(4,3,'result#set#exists############'),(4,4,'result#set#exists############'),(4,5,'result#set#exists############'),(0,1,'333445555##############'),(0,1,'453453453##############'),(0,1,'987654321##############'),(0,1,'999887777##############'),(0,2,'john#smith#731fondren,houstontx#1965-01-09###########'),(0,2,'alicia#zelaya#3321castle,springtx#1968-01-19###########'),(0,3,'123456789#3#############'),(0,3,'333445555#3#############'),(0,4,'2#58000#1500.0000############'),(0,4,'10#76000#2666.6667############'),(0,4,'20#24000#3000.0000############'),(0,5,'1#2#52.5############'),(0,5,'2#2#30.0############'),(0,5,'3#2#50.0############'),(0,5,'10#3#55.0############'),(0,5,'20#2#25.0############'),(0,5,'30#2#50.0############'),(1,1,'333445555##############'),(1,1,'453453453##############'),(1,2,'john#smith#731fondren,houstontx#1965-01-09###########'),(1,3,'123456789#3#############'),(1,3,'333445555#3#############'),(1,4,'2#58000#1500.0000############'),(1,4,'20#24000#3000.0000############'),(1,5,'1#2#52.5############'),(1,5,'2#2#30.0############'),(1,5,'3#2#50.0############'),(2,1,'987654321##############'),(2,1,'999887777##############'),(2,2,'alicia#zelaya#3321castle,springtx#1968-01-19###########'),(2,4,'10#76000#2666.6667############'),(2,4,'20#24000#3000.0000############'),(2,5,'30#2#50.0############'),(2,5,'10#2#45.0############'),(3,1,'235711131##############'),(3,1,'333445555##############'),(3,1,'453453453##############'),(3,1,'701294005##############'),(3,1,'987654321##############'),(3,1,'999887777##############'),(3,2,'john#smith#731fondren,houstontx#1965-01-09###########'),(3,2,'alicia#zelaya#3321castle,springtx#1968-01-19###########'),(3,3,'123456789#3#############'),(3,3,'333445555#3#############'),(3,3,'378990405#2#############'),(3,4,'2#58000#1500.0000############'),(3,4,'10#76000#2666.6667############'),(3,4,'20#24000#3000.0000############'),(3,4,'55#95000#2000.0000############'),(3,5,'1#2#52.5############'),(3,5,'55#3#65.0############'),(3,5,'2#2#30.0############'),(3,5,'3#2#50.0############'),(3,5,'10#3#55.0############'),(3,5,'20#2#25.0############'),(3,5,'30#2#50.0############'),(4,1,'333445555##############'),(4,1,'453453453##############'),(4,1,'987654321##############'),(4,1,'999887777##############'),(4,2,'john#smith#731fondren,houstontx#1965-01-09###########'),(4,2,'alicia#zelaya#3321castle,springtx#1968-01-19###########'),(4,3,'123456789#3#############'),(4,3,'333445555#3#############'),(4,4,'2#48000#1500.0000############'),(4,4,'10#62000#2666.6667############'),(4,4,'20#25000#3000.0000############'),(4,5,'1#2#75.0############'),(4,5,'2#2#39.0############'),(4,5,'3#2#63.5############'),(4,5,'10#3#64.0############'),(4,5,'20#2#37.0############'),(4,5,'30#2#56.0############');

-- --[%v%0%1%]--------------------------------------
-- autograding system
-- -------------------------------------------------
-- The magic44_data_capture table is used to store the data created by the student's queries
-- The table is populated by the magic44_evaluate_queries stored procedure
-- The data in the table is used to populate the magic44_test_results table for analysis

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stateID integer, queryID integer,
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
-- The magic44_log_query_errors table capture these errors for later review

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	state_id integer,
    query_id integer,
    error_code char(5),
    error_message text	
);

drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer, thisState integer)
	returns varchar(1000) reads sql data
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('practiceQuery', thisQuery));

	set @buildQuery = 'insert into magic44_data_capture (stateID, queryID, ';
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ') select ');
    set @buildQuery = concat(@buildQuery, thisState, ', ');
    set @buildQuery = concat(@buildQuery, thisQuery, ', practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, '.* from practiceQuery');
    set @buildQuery = concat(@buildQuery, thisQuery, ';');
    
return @buildQuery;
end //
delimiter ;

-- This null result set marker is used to avoid some edge cases (e.g., empty
-- test cases) when capturing the results.  This value is also used when
-- analyzing the submitted queries.
set @null_result_set_marker = 'result#set#exists############';
drop procedure if exists magic44_evaluate_query;
delimiter //
create procedure magic44_evaluate_query(in thisQuery integer, in thisState integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;
    
	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		-- data capture tombstone added to alleviate empty result set anomalies
		insert into magic44_test_results values (thisState, thisQuery, @null_result_set_marker);
        
		-- prepare and evaluate query contents
		set @sql_text = magic44_query_capture(thisQuery, thisState);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000' then
			insert into magic44_log_query_errors values (thisState, thisQuery, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

drop procedure if exists magic44_evaluate_solutions;
delimiter //
create procedure magic44_evaluate_solutions()
sp_main: begin
	-- ensure that the state and query target tables exist
	if not exists (select * from magic44_state_holds_rows) then leave sp_main; end if;
	if not exists (select * from magic44_expected_results) then leave sp_main; end if;
    
	set @startingState = (select min(state_id) from magic44_state_holds_rows); 
	set @endingState = (select max(state_id) from magic44_state_holds_rows); 
	-- set @startingQuery = (select min(query_id) from magic44_expected_results); 
	-- set @endingQuery = (select max(query_id) from magic44_expected_results); 
	set @startingQuery = 0; 
	set @endingQuery = 1000; 

    -- check all queries for each database state
    set @stateCounter = @startingState;
    check_next_state: while (@stateCounter <= @endingState) do
		if @stateCounter not in (select state_id from magic44_state_holds_rows) then
			set @stateCounter = @stateCounter + 1;
			iterate check_next_state;
		end if;
        call magic44_set_database_state(@stateCounter);
        
		set @queryCounter = @startingQuery;
        check_next_query: while (@queryCounter <= @endingQuery) do
			if not magic44_query_exists(@queryCounter) then
				set @queryCounter = @queryCounter + 1;
				iterate check_next_query;
			end if;
        
			call magic44_evaluate_query(@queryCounter, @stateCounter);
			set @queryCounter = @queryCounter + 1;
		end while;
        
		set @stateCounter = @stateCounter + 1;
	end while;
end //
delimiter ;

-- -------------------------------------------------
-- evaluate all queries against the different states
-- -------------------------------------------------

call magic44_evaluate_solutions();
-- Added [Mon, 12 Sep 2022] to return the database to its original state after testing
call magic44_set_database_state(0);

insert into magic44_test_results
select stateID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

-- Delete the unneeded rows from the answers table to simplify later analysis
delete from magic44_expected_results where not magic44_query_exists(query_id);

-- Modify the row hash results for the results table to eliminate spaces and convert all characters to lowercase
update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

/*
The magic44_content_differences view displays the differences between the answers and test results in terms of the
row attributes and values.  The error_category column contains missing for rows that are not included in the test
results but should be, while extra represents the rows that should not be included in the test results.  The row_hash
column contains the values of the row in a single string with the attribute values separated by a selected delimeter
(i.e., the pound sign/#).
*/

create or replace view magic44_scoring_content_differences as
select query_id, state_id, 'missing' as category, row_hash
from magic44_expected_results where row(state_id, query_id, row_hash) not in
	(select state_id, query_id, row_hash from magic44_test_results)
union
select query_id, state_id, 'extra' as category, row_hash
from magic44_test_results where row(state_id, query_id, row_hash) not in
	(select state_id, query_id, row_hash from magic44_expected_results)
order by query_id, state_id, row_hash;

drop table if exists magic44_autograding_content_errors;
create table magic44_autograding_content_errors (
	query_id integer,
    state_id integer,
    extra_or_missing char(20),
    row_hash varchar(15000)
);

insert into magic44_autograding_content_errors
select * from magic44_scoring_content_differences order by query_id, state_id, row_hash;

create or replace view magic44_tally_row_count as
select * from (select state_id, query_id, count(*) - 1 as actual_row_count from magic44_test_results
	group by state_id, query_id) as actual_dump
natural join
(select state_id, query_id, count(*) - 1 as expected_row_count from magic44_expected_results
	group by state_id, query_id) as expected_dump;

drop function if exists magic44_valid_row;
delimiter //
create function magic44_valid_row(ip_row_hash varchar(15000))
	returns boolean reads sql data
begin
	return (ip_row_hash <> @null_result_set_marker);
end //
delimiter ;

create or replace view magic44_tally_correct as
select state_id, query_id, count(*) as match_total
from magic44_test_results where row(state_id, query_id, row_hash)
	in (select state_id, query_id, row_hash from magic44_expected_results)
    and magic44_valid_row(row_hash) group by state_id, query_id;

create or replace view magic44_tally_missing as
select state_id, query_id, count(*) as missing_total
from magic44_expected_results where row(state_id, query_id, row_hash)
    not in (select state_id, query_id, row_hash from magic44_test_results)
    and magic44_valid_row(row_hash) group by state_id, query_id;

create or replace view magic44_tally_excess as
select state_id, query_id, count(*) as excess_total
from magic44_test_results where row(state_id, query_id, row_hash)
    not in (select state_id, query_id, row_hash from magic44_expected_results)
    and magic44_valid_row(row_hash) group by state_id, query_id;

drop function if exists magic44_category_logic;
delimiter //
create function magic44_category_logic(actual integer, expected integer, matching integer,
	missing integer, excess integer) returns varchar(50) deterministic
begin
	if (actual = expected and expected = matching) then return 'all_correct';
    elseif (actual <> expected and excess = 0) then return 'likely_duplicate_rows';
	elseif (actual = expected) then return 'columns_values_incorrect';
	elseif (missing > 0 and excess > 0) then return 'missing_and_excess_rows';
	elseif (missing > 0) then return 'missing_rows';
	elseif (excess > 0) then return 'excess_rows';
	else return 'undefined_status';
    end if;
end //
delimiter ;

drop function if exists magic44_scoring_logic;
delimiter //
create function magic44_scoring_logic(actual integer, expected integer, matching integer,
	missing integer, excess integer) returns decimal(5, 2) deterministic
begin
	set @line_score = 0.00;
	if (actual = expected and expected = matching and missing = 0 and excess = 0) then
		set @line_score = @line_score + 1.00; end if;
    return @line_score + least(1.00, round((matching + 1.00) / (expected + 1.00), 2));
end //
delimiter ;

create or replace view magic44_scoring_details as
select query_id, state_id, actual_row_count, expected_row_count, ifnull(match_total, 0) as match_count,
	ifnull(missing_total, 0) as missing_count, ifnull(excess_total, 0) as excess_count,
    magic44_category_logic(actual_row_count, expected_row_count, ifnull(match_total, 0),
		ifnull(missing_total, 0), ifnull(excess_total, 0)) as category,
    magic44_scoring_logic(actual_row_count, expected_row_count, ifnull(match_total, 0),
		ifnull(missing_total, 0), ifnull(excess_total, 0)) as score
from ((magic44_tally_row_count natural left outer join magic44_tally_correct)
    natural left outer join magic44_tally_missing) natural left outer join magic44_tally_excess
order by query_id, state_id, category;

drop table if exists magic44_autograding_scoring_details;
create table magic44_autograding_scoring_details (
	query_id integer,
    state_id integer,
    actual_row_count integer,
    expected_row_count integer,
    match_total integer,
	missing_total integer,
    excess_total integer,
    category varchar(50),
    score decimal(5, 2)
);

insert into magic44_autograding_scoring_details
select * from magic44_scoring_details order by query_id, state_id, category;

create or replace view magic44_scoring_summary as
(select query_id, category, group_concat(state_id) as states_affected,
	sum(score) as score_subtotals from magic44_scoring_details
	group by query_id, category
union
select null, '{overall_score}', null, sum(score) from magic44_scoring_details);

drop table if exists magic44_autograding_scoring_summary;
create table magic44_autograding_scoring_summary (
	query_id integer,
    category varchar(50),
    state_listing varchar(50),
    score decimal(10, 2)
);

insert into magic44_autograding_scoring_summary
select * from magic44_scoring_summary;

-- Remove all unneeded tables, views, stored procedures and functions.
-- Keep only those structures needed to provide student feedback.
drop view if exists magic44_scoring_content_differences;
drop view if exists magic44_scoring_details;
drop view if exists magic44_scoring_summary;
drop view if exists magic44_tally_correct;
drop view if exists magic44_tally_excess;
drop view if exists magic44_tally_missing;
drop view if exists magic44_tally_row_count;
drop procedure if exists magic44_evaluate_query;
drop procedure if exists magic44_evaluate_solutions;
drop function if exists magic44_category_logic;
drop function if exists magic44_gen_simple_template;
drop function if exists magic44_query_capture;
drop function if exists magic44_query_exists;
drop function if exists magic44_scoring_logic;
drop function if exists magic44_valid_row;
drop table if exists magic44_column_listing;
drop table if exists magic44_data_capture;
