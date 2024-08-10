-- CS4400: Introduction to Database Systems (Spring 2024)
-- Course Project: Phase 3 Autograder BASIC/LIMITED [v1] Wednesday, March 27, 2024 @ 5:20pm EST
-- This version uses a significantly simplified testing system

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
use drone_dispatch;

-- ----------------------------------------------------------------------------------
-- [1] Implement a capability to reset the database state easily
-- ----------------------------------------------------------------------------------

drop procedure if exists magic44_reset_database_state;
delimiter //
create procedure magic44_reset_database_state ()
begin
	-- Purge and then reload all of the database rows back into the tables.
    -- Ensure that the data is deleted in reverse order with respect to the
    -- foreign key dependencies (i.e., from children up to parents).
	delete from order_lines;
	delete from orders;
	delete from products;
	delete from drones;
	delete from employed_workers;
	delete from stores;
	delete from store_workers;
	delete from drone_pilots;
	delete from employees;
	delete from customers;
	delete from users;

    -- Ensure that the data is inserted in order with respect to the
    -- foreign key dependencies (i.e., from parents down to children).
	insert into users values
    ('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
    ('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
    ('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
    ('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
    ('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
    ('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
    ('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
    ('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
    ('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
    ('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
    ('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
    ('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
    ('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

	insert into customers values
    ('jstone5', 4, 40), ('sprince6', 5, 30), ('awilson5', 2, 100),
    ('lrodriguez5', 4, 60), ('bsummers4', 3, 110), ('cjordan5', 3, 50);
    
	insert into employees values
    ('awilson5', '111-11-1111', 9, 46000),
    ('lrodriguez5', '222-22-2222', 20, 58000),
    ('tmccall5', '333-33-3333', 29, 33000),
    ('eross10', '444-44-4444', 10, 61000),
    ('hstark16', '555-55-5555', 20, 59000),
    ('echarles19', '777-77-7777', 3, 27000),
    ('csoares8', '888-88-8888', 26, 57000),
    ('agarcia7', '999-99-9999', 24, 41000),
    ('bsummers4', '000-00-0000', 17, 35000),
    ('fprefontaine6', '121-21-2121', 5, 20000);

	insert into drone_pilots values
    ('awilson5', '314159', 41), ('lrodriguez5', '287182', 67),
    ('tmccall5', '181633', 10), ('agarcia7', '610623', 38),
    ('bsummers4', '411911', 35), ('fprefontaine6', '657483', 2);

	insert into store_workers values
    ('eross10'), ('hstark16'), ('echarles19');
    
	insert into stores values
    ('pub', 'Publix', 200, 'hstark16'), ('krg', 'Kroger', 300, 'echarles19');

	insert into employed_workers values
    ('pub', 'eross10'), ('pub', 'hstark16'), ('krg', 'eross10'),
    ('krg', 'echarles19');

	insert into drones values
    ('pub', 1, 10, 3, 'awilson5'), ('pub', 2, 20, 2, 'lrodriguez5'),
    ('krg', 1, 15, 4, 'tmccall5'), ('pub', 9, 45, 1, 'fprefontaine6');
    
	insert into products values
    ('pr_3C6A9R', 'pot roast', 6), ('ss_2D4E6L', 'shrimp salad', 3),
    ('hs_5E7L23M', 'hoagie sandwich', 3),
    ('clc_4T9U25X', 'chocolate lava cake', 5),
    ('ap_9T25E36L', 'antipasto platter', 4);

	insert into orders values
    ('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
    ('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
    ('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
    ('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

    insert into order_lines values
    ('pub_303', 'pr_3C6A9R', 20, 1), ('pub_303', 'ap_9T25E36L', 4, 1),
    ('pub_305', 'clc_4T9U25X', 3, 2), ('pub_306', 'hs_5E7L23M', 3, 2),
    ('pub_306', 'ap_9T25E36L', 10, 1), ('krg_217', 'pr_3C6A9R', 15, 2);
end //
delimiter ;

-- ----------------------------------------------------------------------------------
-- [2] Create views to evaluate the queries & transactions
-- ----------------------------------------------------------------------------------

-- Create one view per original base table and student-created view to be used
-- to evaluate the transaction results.

create or replace view practiceQuery10 as select * from users;
create or replace view practiceQuery11 as select * from customers;
create or replace view practiceQuery12 as select * from employees;
create or replace view practiceQuery13 as select * from drone_pilots;
create or replace view practiceQuery14 as select * from store_workers;
create or replace view practiceQuery15 as select * from stores;
create or replace view practiceQuery16 as select * from employed_workers;
create or replace view practiceQuery17 as select * from drones;
create or replace view practiceQuery18 as select * from products;
create or replace view practiceQuery19 as select * from orders;
create or replace view practiceQuery20 as select * from order_lines;

create or replace view practiceQuery30 as select * from role_distribution;
create or replace view practiceQuery31 as select * from customer_credit_check;
create or replace view practiceQuery32 as select * from drone_traffic_control;
create or replace view practiceQuery33 as select * from most_popular_products;
create or replace view practiceQuery34 as select * from drone_pilot_roster;
create or replace view practiceQuery35 as select * from store_sales_overview;
create or replace view practiceQuery36 as select * from orders_in_progress;

-- ----------------------------------------------------------------------------------
-- [3] Prepare to capture the query results for later analysis
-- ----------------------------------------------------------------------------------

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
    query_name varchar(100)
);

insert into magic44_test_case_directory values
(0, 1, '[V_0]', 'initial_state_check'),
(1, 1, '[C_1]', 'add_customer'),
(5, 1, '[C_2]', 'add_drone_pilot'),
(15, 1, '[C_3]', 'add_product'),
(20, 1, '[C_4]', 'add_drone'),
(25, 1, '[U_1]', 'increase_customer_credits'),
(30, 1, '[U_2]', 'swap_drone_control'),
(35, 1, '[U_3]', 'repair_refuel_drone'),
(40, 1, '[U_4]', 'begin_order'),
(50, 1, '[U_5]', 'add_order_line'),
(60, 1, '[U_6]', 'deliver_order'),
(70, 1, '[U_7]', 'cancel_order'),
(80, 1, '[R_1]', 'remove_customer'),
(85, 1, '[R_2]', 'remove_drone_pilot'),
(90, 1, '[R_3]', 'remove_product'),
(95, 1, '[R_4]', 'remove_drone'),
(100, 1, '[V_1]', 'role_distribution'),
(105, 1, '[V_2]', 'customer_credit_check'),
(110, 1, '[V_3]', 'drone_traffic_control'),
(115, 1, '[V_4]', 'most_popular_products'),
(120, 1, '[V_5]', 'drone_pilot_roster'),
(125, 1, '[V_6]', 'store_sales_overview'),
(130, 1, '[V_7]', 'orders_in_progress'),
(140, 8, '[E_1]', 'basic delivery scenario');

drop table if exists magic44_scores_guide;
create table if not exists magic44_scores_guide (
    score_tag char(1),
    score_category varchar(100),
    display_order integer
);

insert into magic44_scores_guide values
('C', 'Create Transactions', 1), ('U', 'Use Case Transactions', 2),
('R', 'Remove Transactions', 3), ('V', 'Global Views/Queries', 4),
('E', 'Event Scenarios/Sequences', 5);

-- ----------------------------------------------------------------------------------
-- [5] Test the queries & transactions and store the results
-- ----------------------------------------------------------------------------------

-- Check that the initial state of their database matches the required configuration
-- The magic44_reset_database_state() call is missing in order to monitor the submitted database
set @stepCounter = 0;
call magic44_query_check_and_run(10);
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(12);
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(14);
call magic44_query_check_and_run(15);
call magic44_query_check_and_run(16);
call magic44_query_check_and_run(17);
call magic44_query_check_and_run(18);
call magic44_query_check_and_run(19);
call magic44_query_check_and_run(20);

-- Successful test: add a new customer
call magic44_reset_database_state();
call add_customer('gpburdell3', 'George', 'Burdell', '801 Atlantic Avenue', '1927-04-01', 5, 100);
set @stepCounter = 1;
call magic44_query_check_and_run(10);
call magic44_query_check_and_run(11);

-- Successful test: add a new drone pilot
call magic44_reset_database_state();
call add_drone_pilot('gpburdell3', 'George', 'Burdell', '801 Atlantic Avenue', '1927-04-01', '123-45-6789', 1, 10000, '258741', 33);
set @stepCounter = 5;
call magic44_query_check_and_run(10);
call magic44_query_check_and_run(12);
call magic44_query_check_and_run(13);

-- Successful test: add a new product
call magic44_reset_database_state();
call add_product('sc_2A3R5T', 'spaghetti carbonara', 3);
set @stepCounter = 15;
call magic44_query_check_and_run(18);

-- Successful test: add a new drone
call magic44_reset_database_state();
call add_drone('krg', 2, 15, 2, 'agarcia7');
set @stepCounter = 20;
call magic44_query_check_and_run(17);

-- Successful test: increase a customer's credits
call magic44_reset_database_state();
call increase_customer_credits('awilson5', 100);
set @stepCounter = 25;
call magic44_query_check_and_run(11);

-- Successful test: transfer control of a drone to another pilot
call magic44_reset_database_state();
call swap_drone_control('agarcia7', 'tmccall5');
set @stepCounter = 30;
call magic44_query_check_and_run(17);

-- Successful test: permit the drone to support more deliveries
call magic44_reset_database_state();
call repair_refuel_drone('pub', 1, 10);
set @stepCounter = 35;
call magic44_query_check_and_run(17);

-- Successful test: begin a new order
call magic44_reset_database_state();
call begin_order('krg_219', '2024-05-25', 'awilson5', 'krg', 1, 'ss_2D4E6L', 2, 1);
set @stepCounter = 40;
call magic44_query_check_and_run(19);
call magic44_query_check_and_run(20);

-- Successful test: add a new line to an order
call magic44_reset_database_state();
call add_order_line('krg_217', 'hs_5E7L23M', 10, 1);
set @stepCounter = 50;
call magic44_query_check_and_run(20);

-- Successful test: deliver an order
call magic44_reset_database_state();
call deliver_order('krg_217');
set @stepCounter = 60;
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(15);
call magic44_query_check_and_run(17);
call magic44_query_check_and_run(19);
call magic44_query_check_and_run(20);

-- Successful test: cancel an order
call magic44_reset_database_state();
call cancel_order('krg_217');
set @stepCounter = 70;
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(19);
call magic44_query_check_and_run(20);

-- Successful test: remove a customer
call magic44_reset_database_state();
call remove_customer('cjordan5');
set @stepCounter = 80;
call magic44_query_check_and_run(10);
call magic44_query_check_and_run(11);

-- Successful test: remove a pilot
call magic44_reset_database_state();
call remove_drone_pilot('agarcia7');
set @stepCounter = 85;
call magic44_query_check_and_run(10);
call magic44_query_check_and_run(12);
call magic44_query_check_and_run(13);

-- Successful test: remove an product
call magic44_reset_database_state();
call remove_product('ss_2D4E6L');
set @stepCounter = 90;
call magic44_query_check_and_run(18);

-- Successful test: remove a drone
call magic44_reset_database_state();
call remove_drone('pub', 9);
set @stepCounter = 95;
call magic44_query_check_and_run(17);

-- Successful test: view the distribution of roles
call magic44_reset_database_state();
set @stepCounter = 100;
call magic44_query_check_and_run(30);

-- Successful test: view the customer credit levels
call magic44_reset_database_state();
set @stepCounter = 105;
call magic44_query_check_and_run(31);

-- Successful test: view the drone activity
call magic44_reset_database_state();
set @stepCounter = 110;
call magic44_query_check_and_run(32);

-- Successful test: view the product activity
call magic44_reset_database_state();
set @stepCounter = 115;
call magic44_query_check_and_run(33);

-- Successful test: view the drone pilot activity
call magic44_reset_database_state();
set @stepCounter = 120;
call magic44_query_check_and_run(34);

-- Successful test: view the store activity
call magic44_reset_database_state();
set @stepCounter = 125;
call magic44_query_check_and_run(35);

-- Successful test: view the order activity
call magic44_reset_database_state();
set @stepCounter = 130;
call magic44_query_check_and_run(36);

-- Successful test: simulate a basic delivery sequence of events
-- Place a new order for three helpings of pot roast ($8 each) from Publix
call magic44_reset_database_state();
call begin_order('pub_710', '2024-06-19', 'cjordan5', 'pub', 9, 'pr_3C6A9R', 8, 3);
set @stepCounter = 140;
call magic44_query_check_and_run(19);
call magic44_query_check_and_run(20);

-- Add a line for two helpings of shrimp salad ($5 each) to the order
call add_order_line('pub_710', 'ss_2D4E6L', 5, 2);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(20);

-- Add a line for five helpings of chocolate lava cake ($2 each) to the order
-- Unfortunately, the drone doesn't have enough capacity to carry these products
call add_order_line('pub_710', 'clc_4T9U25X', 2, 5);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(20);

-- Reduce the line to two helpings of chocolate lava cake ($4 each)
call add_order_line('pub_710', 'clc_4T9U25X', 4, 2);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(20);

-- Add a line for one helping of the antipasto platter ($10 each) to the order
-- Unfortunately, the customer doesn't have enough credits to buy this product
call add_order_line('pub_710', 'ap_9T25E36L', 10, 1);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(20);

-- Give the customer more credits to complete the order
call increase_customer_credits('cjordan5', 20);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(11);

-- Add a line for one helping of the fancier antipasto platter ($15 each)
call add_order_line('pub_710', 'ap_9T25E36L', 15, 1);
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(20);

-- The order is complete so deliver it to the customer and close the bill
call deliver_order('pub_710');
set @stepCounter = @stepCounter + 1;
call magic44_query_check_and_run(11);
call magic44_query_check_and_run(13);
call magic44_query_check_and_run(15);
call magic44_query_check_and_run(17);
call magic44_query_check_and_run(19);
call magic44_query_check_and_run(20);

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
(0,10,'agarcia7#alejandro#garcia#710livingwaterdrive#1966-10-29##########'),
(0,10,'awilson5#aaron#wilson#220peachtreestreet#1963-11-11##########'),
(0,10,'bsummers4#brie#summers#5105dragonstarcircle#1976-02-09##########'),
(0,10,'cjordan5#clark#jordan#77infinitestarsroad#1966-06-05##########'),
(0,10,'csoares8#claire#soares#706livingstoneway#1965-09-03##########'),
(0,10,'echarles19#ella#charles#22peachtreestreet#1974-05-06##########'),
(0,10,'eross10#erica#ross#22peachtreestreet#1975-04-02##########'),
(0,10,'fprefontaine6#ford#prefontaine#10hitchhikerslane#1961-01-28##########'),
(0,10,'hstark16#harmon#stark#53tankertoplane#1971-10-27##########'),
(0,10,'jstone5#jared#stone#101fivefingerway#1961-01-06##########'),
(0,10,'lrodriguez5#lina#rodriguez#360corkscrewcircle#1975-04-02##########'),
(0,10,'sprince6#sarah#prince#22peachtreestreet#1968-06-15##########'),
(0,10,'tmccall5#trey#mccall#360corkscrewcircle#1973-03-19##########'),
(0,11,'awilson5#2#100############'),
(0,11,'bsummers4#3#110############'),
(0,11,'cjordan5#3#50############'),
(0,11,'jstone5#4#40############'),
(0,11,'lrodriguez5#4#60############'),
(0,11,'sprince6#5#30############'),
(0,12,'agarcia7#999-99-9999#24#41000###########'),
(0,12,'awilson5#111-11-1111#9#46000###########'),
(0,12,'bsummers4#000-00-0000#17#35000###########'),
(0,12,'csoares8#888-88-8888#26#57000###########'),
(0,12,'echarles19#777-77-7777#3#27000###########'),
(0,12,'eross10#444-44-4444#10#61000###########'),
(0,12,'fprefontaine6#121-21-2121#5#20000###########'),
(0,12,'hstark16#555-55-5555#20#59000###########'),
(0,12,'lrodriguez5#222-22-2222#20#58000###########'),
(0,12,'tmccall5#333-33-3333#29#33000###########'),
(0,13,'agarcia7#610623#38############'),
(0,13,'awilson5#314159#41############'),
(0,13,'bsummers4#411911#35############'),
(0,13,'fprefontaine6#657483#2############'),
(0,13,'lrodriguez5#287182#67############'),
(0,13,'tmccall5#181633#10############'),
(0,14,'echarles19##############'),
(0,14,'eross10##############'),
(0,14,'hstark16##############'),
(0,15,'krg#kroger#300#echarles19###########'),
(0,15,'pub#publix#200#hstark16###########'),
(0,16,'krg#echarles19#############'),
(0,16,'krg#eross10#############'),
(0,16,'pub#eross10#############'),
(0,16,'pub#hstark16#############'),
(0,17,'krg#1#15#4#tmccall5##########'),
(0,17,'pub#1#10#3#awilson5##########'),
(0,17,'pub#2#20#2#lrodriguez5##########'),
(0,17,'pub#9#45#1#fprefontaine6##########'),
(0,18,'ap_9t25e36l#antipastoplatter#4############'),
(0,18,'clc_4t9u25x#chocolatelavacake#5############'),
(0,18,'hs_5e7l23m#hoagiesandwich#3############'),
(0,18,'pr_3c6a9r#potroast#6############'),
(0,18,'ss_2d4e6l#shrimpsalad#3############'),
(0,19,'krg_217#2024-05-23#jstone5#krg#1##########'),
(0,19,'pub_303#2024-05-23#sprince6#pub#1##########'),
(0,19,'pub_305#2024-05-22#sprince6#pub#2##########'),
(0,19,'pub_306#2024-05-22#awilson5#pub#2##########'),
(0,20,'krg_217#pr_3c6a9r#15#2###########'),
(0,20,'pub_303#ap_9t25e36l#4#1###########'),
(0,20,'pub_303#pr_3c6a9r#20#1###########'),
(0,20,'pub_305#clc_4t9u25x#3#2###########'),
(0,20,'pub_306#ap_9t25e36l#10#1###########'),
(0,20,'pub_306#hs_5e7l23m#3#2###########'),
(1,10,'agarcia7#alejandro#garcia#710livingwaterdrive#1966-10-29##########'),
(1,10,'awilson5#aaron#wilson#220peachtreestreet#1963-11-11##########'),
(1,10,'bsummers4#brie#summers#5105dragonstarcircle#1976-02-09##########'),
(1,10,'cjordan5#clark#jordan#77infinitestarsroad#1966-06-05##########'),
(1,10,'csoares8#claire#soares#706livingstoneway#1965-09-03##########'),
(1,10,'echarles19#ella#charles#22peachtreestreet#1974-05-06##########'),
(1,10,'eross10#erica#ross#22peachtreestreet#1975-04-02##########'),
(1,10,'fprefontaine6#ford#prefontaine#10hitchhikerslane#1961-01-28##########'),
(1,10,'gpburdell3#george#burdell#801atlanticavenue#1927-04-01##########'),
(1,10,'hstark16#harmon#stark#53tankertoplane#1971-10-27##########'),
(1,10,'jstone5#jared#stone#101fivefingerway#1961-01-06##########'),
(1,10,'lrodriguez5#lina#rodriguez#360corkscrewcircle#1975-04-02##########'),
(1,10,'sprince6#sarah#prince#22peachtreestreet#1968-06-15##########'),
(1,10,'tmccall5#trey#mccall#360corkscrewcircle#1973-03-19##########'),
(1,11,'awilson5#2#100############'),
(1,11,'bsummers4#3#110############'),
(1,11,'cjordan5#3#50############'),
(1,11,'gpburdell3#5#100############'),
(1,11,'jstone5#4#40############'),
(1,11,'lrodriguez5#4#60############'),
(1,11,'sprince6#5#30############'),
(5,10,'agarcia7#alejandro#garcia#710livingwaterdrive#1966-10-29##########'),
(5,10,'awilson5#aaron#wilson#220peachtreestreet#1963-11-11##########'),
(5,10,'bsummers4#brie#summers#5105dragonstarcircle#1976-02-09##########'),
(5,10,'cjordan5#clark#jordan#77infinitestarsroad#1966-06-05##########'),
(5,10,'csoares8#claire#soares#706livingstoneway#1965-09-03##########'),
(5,10,'echarles19#ella#charles#22peachtreestreet#1974-05-06##########'),
(5,10,'eross10#erica#ross#22peachtreestreet#1975-04-02##########'),
(5,10,'fprefontaine6#ford#prefontaine#10hitchhikerslane#1961-01-28##########'),
(5,10,'gpburdell3#george#burdell#801atlanticavenue#1927-04-01##########'),
(5,10,'hstark16#harmon#stark#53tankertoplane#1971-10-27##########'),
(5,10,'jstone5#jared#stone#101fivefingerway#1961-01-06##########'),
(5,10,'lrodriguez5#lina#rodriguez#360corkscrewcircle#1975-04-02##########'),
(5,10,'sprince6#sarah#prince#22peachtreestreet#1968-06-15##########'),
(5,10,'tmccall5#trey#mccall#360corkscrewcircle#1973-03-19##########'),
(5,12,'agarcia7#999-99-9999#24#41000###########'),
(5,12,'awilson5#111-11-1111#9#46000###########'),
(5,12,'bsummers4#000-00-0000#17#35000###########'),
(5,12,'csoares8#888-88-8888#26#57000###########'),
(5,12,'echarles19#777-77-7777#3#27000###########'),
(5,12,'eross10#444-44-4444#10#61000###########'),
(5,12,'fprefontaine6#121-21-2121#5#20000###########'),
(5,12,'gpburdell3#123-45-6789#1#10000###########'),
(5,12,'hstark16#555-55-5555#20#59000###########'),
(5,12,'lrodriguez5#222-22-2222#20#58000###########'),
(5,12,'tmccall5#333-33-3333#29#33000###########'),
(5,13,'agarcia7#610623#38############'),
(5,13,'awilson5#314159#41############'),
(5,13,'bsummers4#411911#35############'),
(5,13,'fprefontaine6#657483#2############'),
(5,13,'gpburdell3#258741#33############'),
(5,13,'lrodriguez5#287182#67############'),
(5,13,'tmccall5#181633#10############'),
(15,18,'ap_9t25e36l#antipastoplatter#4############'),
(15,18,'clc_4t9u25x#chocolatelavacake#5############'),
(15,18,'hs_5e7l23m#hoagiesandwich#3############'),
(15,18,'pr_3c6a9r#potroast#6############'),
(15,18,'sc_2a3r5t#spaghetticarbonara#3############'),
(15,18,'ss_2d4e6l#shrimpsalad#3############'),
(20,17,'krg#1#15#4#tmccall5##########'),
(20,17,'krg#2#15#2#agarcia7##########'),
(20,17,'pub#1#10#3#awilson5##########'),
(20,17,'pub#2#20#2#lrodriguez5##########'),
(20,17,'pub#9#45#1#fprefontaine6##########'),
(25,11,'awilson5#2#200############'),
(25,11,'bsummers4#3#110############'),
(25,11,'cjordan5#3#50############'),
(25,11,'jstone5#4#40############'),
(25,11,'lrodriguez5#4#60############'),
(25,11,'sprince6#5#30############'),
(30,17,'krg#1#15#4#agarcia7##########'),
(30,17,'pub#1#10#3#awilson5##########'),
(30,17,'pub#2#20#2#lrodriguez5##########'),
(30,17,'pub#9#45#1#fprefontaine6##########'),
(35,17,'krg#1#15#4#tmccall5##########'),
(35,17,'pub#1#10#13#awilson5##########'),
(35,17,'pub#2#20#2#lrodriguez5##########'),
(35,17,'pub#9#45#1#fprefontaine6##########'),
(40,19,'krg_217#2024-05-23#jstone5#krg#1##########'),
(40,19,'krg_219#2024-05-25#awilson5#krg#1##########'),
(40,19,'pub_303#2024-05-23#sprince6#pub#1##########'),
(40,19,'pub_305#2024-05-22#sprince6#pub#2##########'),
(40,19,'pub_306#2024-05-22#awilson5#pub#2##########'),
(40,20,'krg_217#pr_3c6a9r#15#2###########'),
(40,20,'krg_219#ss_2d4e6l#2#1###########'),
(40,20,'pub_303#ap_9t25e36l#4#1###########'),
(40,20,'pub_303#pr_3c6a9r#20#1###########'),
(40,20,'pub_305#clc_4t9u25x#3#2###########'),
(40,20,'pub_306#ap_9t25e36l#10#1###########'),
(40,20,'pub_306#hs_5e7l23m#3#2###########'),
(50,20,'krg_217#hs_5e7l23m#10#1###########'),
(50,20,'krg_217#pr_3c6a9r#15#2###########'),
(50,20,'pub_303#ap_9t25e36l#4#1###########'),
(50,20,'pub_303#pr_3c6a9r#20#1###########'),
(50,20,'pub_305#clc_4t9u25x#3#2###########'),
(50,20,'pub_306#ap_9t25e36l#10#1###########'),
(50,20,'pub_306#hs_5e7l23m#3#2###########'),
(60,11,'awilson5#2#100############'),
(60,11,'bsummers4#3#110############'),
(60,11,'cjordan5#3#50############'),
(60,11,'jstone5#5#10############'),
(60,11,'lrodriguez5#4#60############'),
(60,11,'sprince6#5#30############'),
(60,13,'agarcia7#610623#38############'),
(60,13,'awilson5#314159#41############'),
(60,13,'bsummers4#411911#35############'),
(60,13,'fprefontaine6#657483#2############'),
(60,13,'lrodriguez5#287182#67############'),
(60,13,'tmccall5#181633#11############'),
(60,15,'krg#kroger#330#echarles19###########'),
(60,15,'pub#publix#200#hstark16###########'),
(60,17,'krg#1#15#3#tmccall5##########'),
(60,17,'pub#1#10#3#awilson5##########'),
(60,17,'pub#2#20#2#lrodriguez5##########'),
(60,17,'pub#9#45#1#fprefontaine6##########'),
(60,19,'pub_303#2024-05-23#sprince6#pub#1##########'),
(60,19,'pub_305#2024-05-22#sprince6#pub#2##########'),
(60,19,'pub_306#2024-05-22#awilson5#pub#2##########'),
(60,20,'pub_303#ap_9t25e36l#4#1###########'),
(60,20,'pub_303#pr_3c6a9r#20#1###########'),
(60,20,'pub_305#clc_4t9u25x#3#2###########'),
(60,20,'pub_306#ap_9t25e36l#10#1###########'),
(60,20,'pub_306#hs_5e7l23m#3#2###########'),
(70,11,'awilson5#2#100############'),
(70,11,'bsummers4#3#110############'),
(70,11,'cjordan5#3#50############'),
(70,11,'jstone5#3#40############'),
(70,11,'lrodriguez5#4#60############'),
(70,11,'sprince6#5#30############'),
(70,19,'pub_303#2024-05-23#sprince6#pub#1##########'),
(70,19,'pub_305#2024-05-22#sprince6#pub#2##########'),
(70,19,'pub_306#2024-05-22#awilson5#pub#2##########'),
(70,20,'pub_303#ap_9t25e36l#4#1###########'),
(70,20,'pub_303#pr_3c6a9r#20#1###########'),
(70,20,'pub_305#clc_4t9u25x#3#2###########'),
(70,20,'pub_306#ap_9t25e36l#10#1###########'),
(70,20,'pub_306#hs_5e7l23m#3#2###########'),
(80,10,'agarcia7#alejandro#garcia#710livingwaterdrive#1966-10-29##########'),
(80,10,'awilson5#aaron#wilson#220peachtreestreet#1963-11-11##########'),
(80,10,'bsummers4#brie#summers#5105dragonstarcircle#1976-02-09##########'),
(80,10,'csoares8#claire#soares#706livingstoneway#1965-09-03##########'),
(80,10,'echarles19#ella#charles#22peachtreestreet#1974-05-06##########'),
(80,10,'eross10#erica#ross#22peachtreestreet#1975-04-02##########'),
(80,10,'fprefontaine6#ford#prefontaine#10hitchhikerslane#1961-01-28##########'),
(80,10,'hstark16#harmon#stark#53tankertoplane#1971-10-27##########'),
(80,10,'jstone5#jared#stone#101fivefingerway#1961-01-06##########'),
(80,10,'lrodriguez5#lina#rodriguez#360corkscrewcircle#1975-04-02##########'),
(80,10,'sprince6#sarah#prince#22peachtreestreet#1968-06-15##########'),
(80,10,'tmccall5#trey#mccall#360corkscrewcircle#1973-03-19##########'),
(80,11,'awilson5#2#100############'),
(80,11,'bsummers4#3#110############'),
(80,11,'jstone5#4#40############'),
(80,11,'lrodriguez5#4#60############'),
(80,11,'sprince6#5#30############'),
(85,10,'awilson5#aaron#wilson#220peachtreestreet#1963-11-11##########'),
(85,10,'bsummers4#brie#summers#5105dragonstarcircle#1976-02-09##########'),
(85,10,'cjordan5#clark#jordan#77infinitestarsroad#1966-06-05##########'),
(85,10,'csoares8#claire#soares#706livingstoneway#1965-09-03##########'),
(85,10,'echarles19#ella#charles#22peachtreestreet#1974-05-06##########'),
(85,10,'eross10#erica#ross#22peachtreestreet#1975-04-02##########'),
(85,10,'fprefontaine6#ford#prefontaine#10hitchhikerslane#1961-01-28##########'),
(85,10,'hstark16#harmon#stark#53tankertoplane#1971-10-27##########'),
(85,10,'jstone5#jared#stone#101fivefingerway#1961-01-06##########'),
(85,10,'lrodriguez5#lina#rodriguez#360corkscrewcircle#1975-04-02##########'),
(85,10,'sprince6#sarah#prince#22peachtreestreet#1968-06-15##########'),
(85,10,'tmccall5#trey#mccall#360corkscrewcircle#1973-03-19##########'),
(85,12,'awilson5#111-11-1111#9#46000###########'),
(85,12,'bsummers4#000-00-0000#17#35000###########'),
(85,12,'csoares8#888-88-8888#26#57000###########'),
(85,12,'echarles19#777-77-7777#3#27000###########'),
(85,12,'eross10#444-44-4444#10#61000###########'),
(85,12,'fprefontaine6#121-21-2121#5#20000###########'),
(85,12,'hstark16#555-55-5555#20#59000###########'),
(85,12,'lrodriguez5#222-22-2222#20#58000###########'),
(85,12,'tmccall5#333-33-3333#29#33000###########'),
(85,13,'awilson5#314159#41############'),
(85,13,'bsummers4#411911#35############'),
(85,13,'fprefontaine6#657483#2############'),
(85,13,'lrodriguez5#287182#67############'),
(85,13,'tmccall5#181633#10############'),
(90,18,'ap_9t25e36l#antipastoplatter#4############'),
(90,18,'clc_4t9u25x#chocolatelavacake#5############'),
(90,18,'hs_5e7l23m#hoagiesandwich#3############'),
(90,18,'pr_3c6a9r#potroast#6############'),
(95,17,'krg#1#15#4#tmccall5##########'),
(95,17,'pub#1#10#3#awilson5##########'),
(95,17,'pub#2#20#2#lrodriguez5##########'),
(100,30,'users#13#############'),
(100,30,'customers#6#############'),
(100,30,'employees#10#############'),
(100,30,'customer_employer_overlap#3#############'),
(100,30,'drone_pilots#6#############'),
(100,30,'store_workers#3#############'),
(100,30,'other_employee_roles#1#############'),
(105,31,'awilson5#2#100#16###########'),
(105,31,'bsummers4#3#110#0###########'),
(105,31,'cjordan5#3#50#0###########'),
(105,31,'jstone5#4#40#30###########'),
(105,31,'lrodriguez5#4#60#0###########'),
(105,31,'sprince6#5#30#30###########'),
(110,32,'krg#1#tmccall5#15#12#4#1########'),
(110,32,'pub#1#awilson5#10#10#3#1########'),
(110,32,'pub#2#lrodriguez5#20#20#2#2########'),
(110,32,'pub#9#fprefontaine6#45#0#1#0########'),
(115,33,'ap_9t25e36l#antipastoplatter#4#4#10#1#1#2#######'),
(115,33,'clc_4t9u25x#chocolatelavacake#5#3#3#2#2#2#######'),
(115,33,'hs_5e7l23m#hoagiesandwich#3#3#3#2#2#2#######'),
(115,33,'pr_3c6a9r#potroast#6#15#20#1#2#3#######'),
(115,33,'ss_2d4e6l#shrimpsalad#3###0#0#0#######'),
(120,34,'agarcia7#610623###38#0#########'),
(120,34,'awilson5#314159#pub#1#41#1#########'),
(120,34,'bsummers4#411911###35#0#########'),
(120,34,'fprefontaine6#657483#pub#9#2#0#########'),
(120,34,'lrodriguez5#287182#pub#2#67#2#########'),
(120,34,'tmccall5#181633#krg#1#10#1#########'),
(125,35,'krg#kroger#echarles19#300#30#1#########'),
(125,35,'pub#publix#hstark16#200#46#3#########'),
(130,36,'krg_217#30#1#12#potroast##########'),
(130,36,'pub_303#24#2#10#antipastoplatter,potroast##########'),
(130,36,'pub_305#6#1#10#chocolatelavacake##########'),
(130,36,'pub_306#16#2#10#antipastoplatter,hoagiesandwich##########'),
(140,19,'krg_217#2024-05-23#jstone5#krg#1##########'),
(140,19,'pub_303#2024-05-23#sprince6#pub#1##########'),
(140,19,'pub_305#2024-05-22#sprince6#pub#2##########'),
(140,19,'pub_306#2024-05-22#awilson5#pub#2##########'),
(140,19,'pub_710#2024-06-19#cjordan5#pub#9##########'),
(140,20,'krg_217#pr_3c6a9r#15#2###########'),
(140,20,'pub_303#ap_9t25e36l#4#1###########'),
(140,20,'pub_303#pr_3c6a9r#20#1###########'),
(140,20,'pub_305#clc_4t9u25x#3#2###########'),
(140,20,'pub_306#ap_9t25e36l#10#1###########'),
(140,20,'pub_306#hs_5e7l23m#3#2###########'),
(140,20,'pub_710#pr_3c6a9r#8#3###########'),
(141,20,'krg_217#pr_3c6a9r#15#2###########'),
(141,20,'pub_303#ap_9t25e36l#4#1###########'),
(141,20,'pub_303#pr_3c6a9r#20#1###########'),
(141,20,'pub_305#clc_4t9u25x#3#2###########'),
(141,20,'pub_306#ap_9t25e36l#10#1###########'),
(141,20,'pub_306#hs_5e7l23m#3#2###########'),
(141,20,'pub_710#pr_3c6a9r#8#3###########'),
(141,20,'pub_710#ss_2d4e6l#5#2###########'),
(142,20,'krg_217#pr_3c6a9r#15#2###########'),
(142,20,'pub_303#ap_9t25e36l#4#1###########'),
(142,20,'pub_303#pr_3c6a9r#20#1###########'),
(142,20,'pub_305#clc_4t9u25x#3#2###########'),
(142,20,'pub_306#ap_9t25e36l#10#1###########'),
(142,20,'pub_306#hs_5e7l23m#3#2###########'),
(142,20,'pub_710#pr_3c6a9r#8#3###########'),
(142,20,'pub_710#ss_2d4e6l#5#2###########'),
(143,20,'krg_217#pr_3c6a9r#15#2###########'),
(143,20,'pub_303#ap_9t25e36l#4#1###########'),
(143,20,'pub_303#pr_3c6a9r#20#1###########'),
(143,20,'pub_305#clc_4t9u25x#3#2###########'),
(143,20,'pub_306#ap_9t25e36l#10#1###########'),
(143,20,'pub_306#hs_5e7l23m#3#2###########'),
(143,20,'pub_710#clc_4t9u25x#4#2###########'),
(143,20,'pub_710#pr_3c6a9r#8#3###########'),
(143,20,'pub_710#ss_2d4e6l#5#2###########'),
(144,20,'krg_217#pr_3c6a9r#15#2###########'),
(144,20,'pub_303#ap_9t25e36l#4#1###########'),
(144,20,'pub_303#pr_3c6a9r#20#1###########'),
(144,20,'pub_305#clc_4t9u25x#3#2###########'),
(144,20,'pub_306#ap_9t25e36l#10#1###########'),
(144,20,'pub_306#hs_5e7l23m#3#2###########'),
(144,20,'pub_710#clc_4t9u25x#4#2###########'),
(144,20,'pub_710#pr_3c6a9r#8#3###########'),
(144,20,'pub_710#ss_2d4e6l#5#2###########'),
(145,11,'awilson5#2#100############'),
(145,11,'bsummers4#3#110############'),
(145,11,'cjordan5#3#70############'),
(145,11,'jstone5#4#40############'),
(145,11,'lrodriguez5#4#60############'),
(145,11,'sprince6#5#30############'),
(146,20,'krg_217#pr_3c6a9r#15#2###########'),
(146,20,'pub_303#ap_9t25e36l#4#1###########'),
(146,20,'pub_303#pr_3c6a9r#20#1###########'),
(146,20,'pub_305#clc_4t9u25x#3#2###########'),
(146,20,'pub_306#ap_9t25e36l#10#1###########'),
(146,20,'pub_306#hs_5e7l23m#3#2###########'),
(146,20,'pub_710#ap_9t25e36l#15#1###########'),
(146,20,'pub_710#clc_4t9u25x#4#2###########'),
(146,20,'pub_710#pr_3c6a9r#8#3###########'),
(146,20,'pub_710#ss_2d4e6l#5#2###########'),
(147,11,'awilson5#2#100############'),
(147,11,'bsummers4#3#110############'),
(147,11,'cjordan5#4#13############'),
(147,11,'jstone5#4#40############'),
(147,11,'lrodriguez5#4#60############'),
(147,11,'sprince6#5#30############'),
(147,13,'agarcia7#610623#38############'),
(147,13,'awilson5#314159#41############'),
(147,13,'bsummers4#411911#35############'),
(147,13,'fprefontaine6#657483#3############'),
(147,13,'lrodriguez5#287182#67############'),
(147,13,'tmccall5#181633#10############'),
(147,15,'krg#kroger#300#echarles19###########'),
(147,15,'pub#publix#257#hstark16###########'),
(147,17,'krg#1#15#4#tmccall5##########'),
(147,17,'pub#1#10#3#awilson5##########'),
(147,17,'pub#2#20#2#lrodriguez5##########'),
(147,17,'pub#9#45#0#fprefontaine6##########'),
(147,19,'krg_217#2024-05-23#jstone5#krg#1##########'),
(147,19,'pub_303#2024-05-23#sprince6#pub#1##########'),
(147,19,'pub_305#2024-05-22#sprince6#pub#2##########'),
(147,19,'pub_306#2024-05-22#awilson5#pub#2##########'),
(147,20,'krg_217#pr_3c6a9r#15#2###########'),
(147,20,'pub_303#ap_9t25e36l#4#1###########'),
(147,20,'pub_303#pr_3c6a9r#20#1###########'),
(147,20,'pub_305#clc_4t9u25x#3#2###########'),
(147,20,'pub_306#ap_9t25e36l#10#1###########'),
(147,20,'pub_306#hs_5e7l23m#3#2###########');

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

drop table if exists magic44_autograding_high_level;
create table magic44_autograding_high_level
select score_tag, score_category, sum(total_cases) as total_possible,
	sum(passed_cases) as total_passed
from magic44_scores_guide natural join
(select *, mid(query_label, 2, 1) as score_tag from magic44_autograding_low_level) as temp
group by score_tag, score_category;

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
drop view if exists practiceQuery20;
drop view if exists practiceQuery30;
drop view if exists practiceQuery31;
drop view if exists practiceQuery32;
drop view if exists practiceQuery33;
drop view if exists practiceQuery34;
drop view if exists practiceQuery35;
drop view if exists practiceQuery36;

drop view if exists magic44_fast_correct_test_cases;
drop view if exists magic44_fast_total_test_cases;
drop view if exists magic44_fast_column_based_errors;
drop view if exists magic44_fast_row_based_errors;
drop view if exists magic44_fast_expected_results;

drop table if exists magic44_scores_guide;
