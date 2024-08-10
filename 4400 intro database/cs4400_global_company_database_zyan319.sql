-- CS4400: Introduction to Database Systems [Wednesday, March 23, 2022]
-- Global Company Database (Clean WITH Primary and foreign keys)

/* This database is constructed as an extension to the Company Database as defined
in the Elmasri & Navathe textbook used in class. The initial relations (and the initial
dataset for the physical schema) have been designed so that they are unchanged from the
textbook. The added relations will give more opportunities to produce a wider variety
of queries for testing purposes. */

-- This version of the database is intended to work with legacy versions of MySQL
-- It does include the tables and data, which are needed to practice writing queries
-- It does not include the views, stored procedures and functions from other versions

drop database if exists global_company;
create database if not exists global_company;
use global_company;

-- The initial database tables & data (per the Elmasri/Navathe textbook)
drop table if exists employee;
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

insert into employee values
('John', 'Smith', 123456789, '1965-01-09', '731 Fondren, Houston TX', 'M', 30000, 333445555, 5),
('Franklin', 'Wong', 333445555, '1955-12-08', '638 Voss, Houston TX', 'M', 40000, 888665555, 5),
('Joyce', 'English', 453453453, '1972-07-31', '5631 Rice, Houston TX', 'F', 25000, 333445555, 5),
('Ramesh', 'Narayan', 666884444, '1962-09-15', '975 Fire Oak, Humble TX', 'M', 38000, 333445555, 5),
('James', 'Borg', 888665555, '1937-11-10', '450 Stone, Houston TX', 'M', 55000, null, 1),
('Jennifer', 'Wallace', 987654321, '1941-06-20', '291 Berry, Bellaire TX', 'F', 43000, 888665555, 4),
('Ahmad', 'Jabbar', 987987987, '1969-03-29', '980 Dallas, Houston TX', 'M', 25000, 987654321, 4),
('Alicia', 'Zelaya', 999887777, '1968-01-19', '3321 Castle, Spring TX', 'F', 25000, 987654321, 4);

drop table if exists dependent;
create table dependent (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  sex char(1) not null,
  bdate date not null,
  relationship char(30) not null,
  primary key (essn, dependent_name),
  constraint fk1 foreign key (essn) references employee (ssn)
) engine = innodb;

insert into dependent values
(123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
(123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
(123456789, 'Michael', 'M', '1988-01-04', 'Son'),
(333445555, 'Alice', 'F', '1986-04-04', 'Daughter'),
(333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
(333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
(987654321, 'Abner', 'M', '1942-02-28', 'Spouse');

drop table if exists department;
create table department (
  dname char(20) not null,
  dnumber decimal(1, 0) not null,
  mgrssn decimal(9, 0) not null,
  mgrstartdate date not null,
  primary key (dnumber),
  unique key (dname)
) engine = innodb;

insert into department values
('Headquarters', 1, 888665555, '1981-06-19'),
('Administration', 4, 987654321, '1995-01-01'),
('Research', 5, 333445555, '1988-05-22');

drop table if exists dept_locations;
create table dept_locations (
  dnumber decimal(1, 0) not null,
  dlocation char(15) not null,
  primary key (dnumber, dlocation),
  constraint fk8 foreign key (dnumber) references department (dnumber)
) engine = innodb;

insert into dept_locations values
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Houston'),
(5, 'Sugarland');

drop table if exists project;
create table project (
  pname char(20) not null,
  pnumber decimal(2, 0) not null,
  plocation char(20) not null,
  dnum decimal(1, 0) not null,
  primary key (pnumber),
  unique key (pname),
  constraint fk3 foreign key (dnum) references department (dnumber)
) engine = innodb;

insert into project values
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

drop table if exists works_on;
create table works_on (
  essn decimal(9, 0) not null,
  pno decimal(2, 0) not null,
  hours decimal(5, 1) default null,
  primary key (essn, pno),
  constraint fk5 foreign key (essn) references employee (ssn),
  constraint fk6 foreign key (pno) references project (pnumber)
) engine = innodb;

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

alter table employee add constraint fk2 foreign key (dno) references department (dnumber);
alter table employee add constraint fk7 foreign key (superssn) references employee (ssn);
alter table department add constraint fk4 foreign key (mgrssn) references employee (ssn);

-- The newly added database tables & data (to increase the query testing variety)
drop table if exists fund_source;
create table fund_source (
  fsid integer not null,
  remaining integer default null,
  usage_rate integer default null,
  pnumber decimal(2, 0) default null,
  primary key (fsid),
  constraint fk22 foreign key (pnumber) references project (pnumber)
) engine = innodb;

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

drop table if exists customer;
create table customer (
  cid varchar(100) not null,
  company varchar(200) default null,
  location char(20) default null,
  assets integer default null,
  fsid integer not null,
  primary key (cid),
  constraint fk10 foreign key (fsid) references fund_source (fsid)
) engine = innodb;

insert into customer values
('bank1', 'Second National Bank', 'Dallas', 350000, 2),
('bank2', 'Tempest Bank', 'Atlanta', 200000, 3),
('mgmt1', 'Power, Water & Copper', 'Dallas', null, 7),
('tech2', 'Cumulus Cloud Computing', null, 380000, 11),
('tech3', null, 'Houston', 850000, 13),
('bank3', 'Credit Union Universal', 'New York', 417000, 23),
('bank4', 'Anytime Anywhere Crypto', 'Houston', 619000, 29);

drop table if exists budget;
create table budget (
  dnumber decimal(1, 0) not null,
  bcode integer not null,
  balance integer default null,
  fsid integer default null,
  primary key (dnumber, bcode),
  constraint fk9 foreign key (dnumber) references department (dnumber),
  constraint fk11 foreign key (fsid) references fund_source (fsid)
) engine = innodb;

insert into budget values
(1, 10, 170000, 5),
(4, 6, 64000, null),
(5, 0, 516000, 17);

drop table if exists remote_access;
create table remote_access (
  ssn decimal(9, 0) not null,
  ip_address varchar(39) default null,
  user_account varchar(200) default null,
  primary key (ssn),
  unique key (ip_address),
  constraint fk12 foreign key (ssn) references employee (ssn)
) engine = innodb;

insert into remote_access values
(666884444, '403e:8f59:336e:d11b:0425:ed18:2f34:48a3', 'rnarayan3'),
(888665555, '26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4', 'jborg1'),
(987654321, '3208:78e4:578b:034b:c7ff:1b55:6e41:8ece', 'jwallace3');

drop table if exists time_frames;
create table time_frames (
  ssn decimal(9, 0) not null,
  start_hour integer not null,
  duration integer not null,
  primary key (ssn, start_hour, duration),
  constraint fk13 foreign key (ssn) references remote_access (ssn)
) engine = innodb;

insert into time_frames values
(666884444, 13, 9),
(987654321, 11, 4),
(987654321, 23, 5),
(888665555, 15, 4);

drop table if exists in_office;
create table in_office (
  ssn decimal(9, 0) not null,
  building varchar(200) default null,
  room varchar(200) default null,
  primary key (ssn),
  constraint fk14 foreign key (ssn) references employee (ssn)
) engine = innodb;

insert into in_office values
(123456789, 'Main', '33-C'),
(333445555, 'Main', '100'),
(453453453, 'Main', '33-C'),
(987987987, 'Computing', 'Bridge'),
(999887777, 'Research', null);

drop table if exists analysis;
create table analysis (
  pnumber decimal(2, 0) not null,
  title text default null,
  frequency integer default null,
  quantity integer default null,
  primary key (pnumber),
  constraint fk15 foreign key (pnumber) references project (pnumber)
) engine = innodb;

insert into analysis values
(2, 'stock market prediction', 60, 2),
(30, 'cryptocurrency correlation', 30, 1);

drop table if exists operations;
create table operations (
  pnumber decimal(2, 0) not null,
  title text default null,
  team_size integer default null,
  primary key (pnumber),
  constraint fk16 foreign key (pnumber) references project (pnumber)
) engine = innodb;

insert into operations values
(2, 'stock ticker collection', 2),
(10, 'drone traffic control', 4),
(20, 'cloud conversion', 5),
(30, 'crypto monitoring', 2);

drop table if exists operation_skills;
create table operation_skills (
  pnumber decimal(2, 0) not null,
  skill_name varchar(200) not null,
  primary key (pnumber, skill_name),
  constraint fk17 foreign key (pnumber) references operations (pnumber)
) engine = innodb;

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

drop table if exists maintenance;
create table maintenance (
  pnumber decimal(2, 0) not null,
  primary key (pnumber),
  constraint fk18 foreign key (pnumber) references project (pnumber)
) engine = innodb;

insert into maintenance values
(1),
(2),
(10);

drop table if exists maintenance_types;
create table maintenance_types (
  pnumber decimal(2, 0) not null,
  remote_access enum('none', 'intranet', 'vpn', 'open') not null,
  frequency integer not null,
  cost integer not null,
  primary key (pnumber, remote_access, frequency, cost),
  constraint fk19 foreign key (pnumber) references maintenance (pnumber)
) engine = innodb;

insert into maintenance_types values
(1, 'intranet', 4, 500),
(1, 'open', 12, 100),
(2, 'none', 1, 2000),
(2, 'intranet', 10, 200),
(2, 'vpn', 30, 100),
(10, 'vpn', 4, 400),
(10, 'open', 20, 100);

drop table if exists interns_in;
create table interns_in (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  dnumber decimal(1, 0) not null,
  rating integer default null,
  primary key (essn, dependent_name, dnumber),
  constraint fk20 foreign key (essn, dependent_name) references dependent (essn, dependent_name),
  constraint fk21 foreign key (dnumber) references department (dnumber)  
) engine = innodb;

insert into interns_in values
(123456789, 'Alice', 1, 7),
(123456789, 'Alice', 4, 8),
(123456789, 'Michael', 4, 6),
(123456789, 'Michael', 5, 8),
(333445555, 'Alice', 5, 10);