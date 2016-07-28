/*
 hospital_db.sql
 SQL commands for creating the hospital database
 */

 DROP TABLE if exists inpatientInfo;
 DROP TABLE if exists admissions;
 DROP TABLE if exists rooms;
 DROP TABLE if exists assignedDoctors;
 DROP TABLE if exists treatmentsGiven;
 DROP TABLE if exists diagnosesGiven;
 DROP TABLE if exists treatments;
 DROP TABLE if exists diagnoses;
 DROP TABLE if exists patients;
 DROP TABLE if exists services;
 DROP TABLE if exists volunteers;
 DROP TABLE if exists employees;

/*
   - employees(eid*, name, hireDate, category, admit)
   - category is the type of employee
      - subtypes are staff, technician, nurse, administrator, doctor
   - admit (can_admit here) is a boolean flag. True if employee has admitting priveleges */
CREATE TABLE employees (
   eid         varchar(10) NOT NULL,
   ename       text,
   hireDate    date,
   can_admit   bool DEFAULT FALSE,
   category    varchar(20) NOT NULL
      CHECK (category IN ('staff', 'technician', 'nurse', 'administrator', 'doctor')),
   PRIMARY KEY (eid)
);


/*
   - volunteers(vid*, name) */
CREATE TABLE volunteers (
   vid         varchar(10) NOT NULL,
   vname       text,
   PRIMARY KEY (vid)
);


/*
   - patients(pid*, name, inpatient)
   - superclass for all patients
   - inpatient is boolean flag. True if patient is an inpatient */
CREATE TABLE patients (
   pid         varchar(10) NOT NULL,
   pname       text,
   inpatient   bool DEFAULT FALSE,
   PRIMARY KEY (pid)
);


/*
   - rooms(num*, currentPid)
   - num is the room number
   - a room is assigned to at most one patient
   - */
CREATE TABLE rooms (
   roomNum  smallint,
   pid      varchar(10) UNIQUE,
   PRIMARY KEY (roomNum),
   FOREIGN KEY (pid) REFERENCES patients (pid)
);


/*
   - admissions(doctor, pid, room, dateAdmitted, dateDischarged, admin)
   - a doctor with admitting priveleges admits a patient
   - the admitting doctor is the patient's primary doctor */
CREATE TABLE admissions (
   pid            varchar(10),
   doctor         varchar(10) NOT NULL,
   administrator  varchar(10),
   roomNum        smallint,
   dateAdmitted   date,
   dateDischarged date,
   PRIMARY KEY (pid,dateAdmitted),
   FOREIGN KEY (pid)       REFERENCES patients (pid),
   FOREIGN KEY (doctor)    REFERENCES employees (eid),
   FOREIGN KEY (roomNum)   REFERENCES rooms (roomNum),
   FOREIGN KEY (administrator) REFERENCES employees (eid)
);


/*
   - inpatientInfo(pid*, primaryDoctor, emergencyContact, insurance)
   - inpatients are assigned a primary doctor
   - all admitted patients must provide emergency contact phone number and insurance information
   -
 */
CREATE TABLE inpatientInfo (
   pid               varchar(10) NOT NULL,
   primaryDoctor     varchar(10),
   emergencyContact  text NOT NULL,
   insurance         text NOT NULL,
   PRIMARY KEY (pid),
   FOREIGN KEY (pid) REFERENCES patients (pid),
   FOREIGN KEY (primaryDoctor) REFERENCES employees (eid)
 );


/*
   - assignedDoctors(pid*, doctor*)
   - Doctors are assigned to patients.
   - Multiple doctors can be assigned to a single patient*/
CREATE TABLE assignedDoctors (
   pid         varchar(10),
   doctor      varchar(10),
   PRIMARY KEY (pid, doctor),
   FOREIGN KEY (pid)    REFERENCES patients  (pid),
   FOREIGN KEY (doctor) REFERENCES employees (eid)
);

/*
   - treatments(trid*, name)*/
CREATE TABLE treatments (
   trid        varchar(10),
   tname       text,
   PRIMARY KEY (trid)
);

/*
   - diagnoses(did*, name)*/
CREATE TABLE diagnoses (
   did         varchar(10),
   dname       text,
   PRIMARY Key (did)
);

/*
   - treatmentsGiven(pid*, doctor, tid, eid, timestamp*)
   - treatments are ordered by a doctor and administered by an appropriate employee */
CREATE TABLE treatmentsGiven (
   pid         varchar(10),
   doctor      varchar(10),
   trid        varchar(10),
   eid         varchar(10),
   tTime       timestamp,
   FOREIGN KEY (pid)    REFERENCES patients   (pid),
   FOREIGN KEY (doctor) REFERENCES employees  (eid),
   FOREIGN KEY (trid)   REFERENCES treatments (trid),
   FOREIGN KEY (eid)    REFERENCES employees  (eid),
   PRIMARY KEY (pid, eid, tTime)
);

/*
   - diagnosesGiven(pid*, doctor, did, timestamp*)*/
CREATE TABLE diagnosesGiven (
   pid         varchar(10),
   doctor      varchar(10),
   did         varchar(10),
   dTime       timestamp,
   FOREIGN KEY (pid)    REFERENCES patients  (pid),
   FOREIGN KEY (doctor) REFERENCES employees (eid),
   FOREIGN KEY (did)    REFERENCES diagnoses (did),
   PRIMARY KEY (pid, dTime)
);

/*
   - services(vid*, day*, location)
   - volunteers provide services for a few days each week
   - they work in different locations*/
CREATE TABLE services (
   vid       varchar(10),
   sday      text NOT NULL
         CHECK (sday IN ('Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun')),
   slocation text NOT NULL
         CHECK (slocation IN ('gift shop', 'information desk', 'snack cart', 'reading cart')),
   FOREIGN KEY (vid) REFERENCES volunteers (vid),
   PRIMARY KEY (vid, sday)
);

insert into employees values
	(1, 'CONNIE ARDATH', '1982-2-6', TRUE, 'doctor'),
	(2, 'KENNITH KATHRYNE', '1985-1-1', TRUE, 'doctor'),
	(3, 'WARD ROWENA', '1983-5-28', TRUE, 'doctor'),
	(4, 'CLAUDIO HILDA', '1987-3-26', TRUE, 'doctor'),
	(5, 'ELLIS ARLETTE', '1981-2-12', FALSE, 'nurse'),
	(6, 'CHRISTOPHER YVONE', '1982-1-26', FALSE, 'nurse'),
	(7, 'SOLOMON SHERLEY', '1983-10-27', FALSE, 'nurse'),
	(8, 'MODESTO MICHAELE', '1985-8-2', FALSE, 'nurse'),
	(9, 'JEFFRY MI', '1984-3-1', FALSE, 'nurse'),
	(10, 'MOSES ROMONA', '1984-5-3', FALSE, 'technician'),
	(11, 'MOHAMED ELAYNE', '1987-9-24', FALSE, 'technician'),
	(12, 'THEODORE NOBLE', '1985-8-10', FALSE, 'technician'),
	(13, 'LAMAR PHILOMENA', '1989-10-12', FALSE, 'technician'),
	(14, 'BRANT VERONA', '1984-5-7', FALSE, 'technician'),
	(15, 'PORTER CARLOS', '1986-9-16', FALSE, 'staff'),
	(16, 'BLAIR BERENICE', '1989-3-1', FALSE, 'staff'),
	(17, 'OTIS JADE', '1986-8-26', FALSE, 'staff'),
	(18, 'LAVERNE BEVERLY', '1984-6-24', FALSE, 'staff'),
	(19, 'MERLIN QUEEN', '1987-7-14', FALSE, 'staff'),
	(20, 'CHAUNCEY INGA', '1983-10-19', FALSE, 'administrator'),
	(21, 'SIMON WALTER', '1989-11-18', FALSE, 'administrator'),
	(22, 'QUINCY KIMBRA', '1980-9-12', FALSE, 'administrator'),
	(23, 'MASON EARNESTINE', '1989-5-8', FALSE, 'administrator'),
	(24, 'RICKIE PHILLIP', '1981-2-25', FALSE, 'administrator');

insert into volunteers values
	(1, 'TOMMIE ARDELIA'),
	(2, 'REGGIE NEAL'),
	(3, 'NICOLAS JACKSON'),
	(4, 'LINDSAY KAROLINE'),
	(5, 'ADOLPH DAWN'),
	(6, 'TRINIDAD MILDRED'),
	(7, 'COURTNEY BECKI'),
	(8, 'LACY HAYWOOD'),
	(9, 'QUINCY HUEY'),
	(10, 'ANTONY TYRA');

insert into patients values
	(10001, 'MIQUEL IVELISSE', FALSE),
	(10002, 'BRICE ALETHA', FALSE),
	(10003, 'JASON MICHELINA', FALSE),
	(10004, 'HARLAND INES', FALSE),
	(10005, 'IRVING JUDE', FALSE),
	(10006, 'COLUMBUS BIRDIE', FALSE),
	(10007, 'ANDRES DIANNE', FALSE),
	(10008, 'RALPH LIBBIE', FALSE),
	(10009, 'WADE JERRELL', FALSE),
	(10010, 'ED MARICA', FALSE),
	(10011, 'QUINCY JAY', FALSE),
	(10012, 'CLEMENTE CORRINA', FALSE),
	(10013, 'JOHNATHAN ANTONIO', FALSE),
	(10014, 'FREEMAN THOMAS', FALSE),
	(10015, 'GARRETT CATHY', FALSE),
	(10016, 'ROOSEVELT DORI', FALSE),
	(10017, 'WILLIE TORRIE', FALSE),
	(10018, 'MITCHEL CALLIE', FALSE),
	(10019, 'SAUL MADALINE', FALSE),
	(10020, 'LESLEY ISABELLE', FALSE),
	(20001, 'BOOKER OTTO', TRUE),
	(20002, 'JUDE FLORENCIO', TRUE),
	(20003, 'COLLIN SHERRY', TRUE),
	(20004, 'HANK WAYNE', TRUE),
	(20005, 'BRENDAN STASIA', TRUE),
	(20006, 'RENATO THERESIA', TRUE),
	(20007, 'DENNY FRANKIE', TRUE),
	(20008, 'GAYLE ANGIE', TRUE),
	(20009, 'AURELIO BEULAH', TRUE),
	(20010, 'CASEY ROBERTO', TRUE),
	(20011, 'GROVER GERI', TRUE),
	(20012, 'LAMONT MINDA', TRUE),
	(20013, 'ANTONIA KERRY', TRUE),
	(20014, 'DEANGELO EDGARDO', TRUE),
	(20015, 'CAMERON GRETTA', TRUE),
	(20016, 'DEL SARAN', TRUE),
	(20017, 'RAYMOND CHRISTAL', TRUE),
	(20018, 'REED ROSELEE', TRUE),
	(20019, 'SETH LAWRENCE', TRUE),
	(20020, 'JACK LATASHA', TRUE);

insert into inpatientInfo values
	(20001, 1, '281-391-1435', 'Humana'),
	(20002, 1, '617-869-5487', 'BlueCrossBlueShield'),
	(20003, 1, '648-228-7063', 'BlueCrossBlueShield'),
	(20004, 3, '965-686-8966', 'Aetna'),
	(20005, 2, '906-198-9954', 'BlueCrossBlueShield'),
	(20006, 3, '729-120-8627', 'BlueCrossBlueShield'),
	(20007, 1, '672-119-6296', 'Aetna'),
	(20008, 4, '316-684-7670', 'BlueCrossBlueShield'),
	(20009, 2, '102-265-3258', 'Aetna'),
	(20010, 4, '162-561-2382', 'BlueCrossBlueShield'),
	(20011, 1, '746-298-3087', 'BlueCrossBlueShield'),
	(20012, 1, '654-411-4595', 'BlueCrossBlueShield'),
	(20013, 3, '893-214-1596', 'Aetna'),
	(20014, 1, '356-981-9247', 'BlueCrossBlueShield'),
	(20015, 2, '700-480-3728', 'Aetna'),
	(20016, 2, '749-372-8133', 'Aetna'),
	(20017, 1, '372-944-1136', 'BlueCrossBlueShield'),
	(20018, 1, '327-258-1152', 'BlueCrossBlueShield'),
	(20019, 1, '680-614-6293', 'Aetna'),
	(20020, 3, '153-285-3447', 'Aetna');

insert into rooms values
	(1, '20001'),
	(2, '20002'),
	(3, '20003'),
	(4, '20004'),
	(5, '20005'),
	(6, '20006'),
	(7, '20007'),
	(8, '20008'),
	(9, '20009'),
	(10, '20010'),
	(11, '20011'),
	(12, '20012'),
	(13, '20013'),
	(14, '20014'),
	(15, '20015'),
	(16, '20016'),
	(17, '20017'),
	(18, '20018'),
	(19, '20019'),
	(20, '20020'),
	(21, NULL),
	(22, NULL),
	(23, NULL),
	(24, NULL),
	(25, NULL),
	(26, NULL),
	(27, NULL),
	(28, NULL),
	(29, NULL),
	(30, NULL),
	(31, NULL),
	(32, NULL),
	(33, NULL),
	(34, NULL),
	(35, NULL),
	(36, NULL),
	(37, NULL),
	(38, NULL),
	(39, NULL),
	(40, NULL);

insert into assignedDoctors values
	('10001', '3'),
	('10002', '4'),
	('10003', '1'),
	('10004', '2'),
	('10005', '3'),
	('10006', '2'),
	('10007', '3'),
	('10008', '4'),
	('10009', '1'),
	('10010', '1'),
	('10011', '1'),
	('10012', '1'),
	('10013', '3'),
	('10014', '2'),
	('10015', '4'),
	('10016', '4'),
	('10017', '2'),
	('10018', '2'),
	('10019', '1'),
	('10020', '2'),
	('20001', '2'),
	('20002', '1'),
	('20003', '2'),
	('20004', '2'),
	('20005', '4'),
	('20006', '3'),
	('20007', '3'),
	('20008', '2'),
	('20009', '4'),
	('20010', '1'),
	('20011', '2'),
	('20012', '3'),
	('20013', '4'),
	('20014', '4'),
	('20015', '1'),
	('20016', '4'),
	('20017', '2'),
	('20018', '3'),
	('20019', '1'),
	('20020', '3');


insert into treatments values
	('1', 'chemotherapy'),
	('2', 'stereroids'),
	('3', 'blood transfusion'),
	('4', 'appendecitis'),
	('5', 'mechanical ventilation');

insert into diagnoses values
	('1', 'cancer'),
	('2', 'virus'),
	('3', 'blood infection'),
	('4', 'appendectomy'),
	('5', 'asthma');

insert into treatmentsGiven values
	('10001', '3', '1', '1', '2001-4-21 22:56:24'),
	('10002', '4', '2', '2', '2002-3-25 8:23:44'),
	('10003', '1', '3', '3', '2001-5-6 23:44:55'),
	('10004', '2', '4', '4', '2003-1-8 22:22:22'),
	('10005', '3', '5', '5', '2004-2-14 12:21:56'),
	('10006', '2', '1', '6', '2002-3-15 13:45:32'),
	('10007', '3', '2', '7', '2001-4-16 9:32:12'),
	('10008', '4', '3', '8', '2005-5-17 20:45:22'),
	('10009', '1', '4', '9', '2006-3-18 8:59:21'),
	('10010', '1', '5', '10', '2007-11-28 23:55:34'),
	('10011', '1', '1', '11', '2003-12-22 21:43:58'),
	('10012', '1', '2', '12', '2004-4-21 19:29:28'),
	('10013', '3', '3', '13', '2005-2-22 23:50:20'),
	('10014', '2', '4', '14', '2006-2-23 23:50:59'),
	('10015', '4', '5', '1', '2007-7-24 22:59:55'),
	('10016', '4', '1', '2', '2008-8-25 23:23:10'),
	('10017', '2', '2', '3', '2001-10-26 23:45:20'),
	('10018', '2', '3', '4', '2002-11-27 19:57:30'),
	('10019', '1', '4', '5', '2003-12-28 23:23:40'),
	('10020', '2', '5', '6', '2004-6-29 13:43:50'),
	('20001', '2', '1', '7', '2006-8-11 12:55:10'),
	('20002', '1', '2', '8', '2005-9-21 11:53:20'),
	('20003', '2', '3', '9', '2004-11-13 4:11:30'),
	('20004', '2', '4', '10', '2003-1-27 5:12:40'),
	('20005', '4', '5', '11', '2002-2-21 2:1:50'),
	('20006', '3', '1', '12', '2001-4-18 1:40:10'),
	('20007', '3', '2', '13', '2002-3-17 16:20:20'),
	('20008', '2', '3', '14', '2003-6-7 18:30:30'),
	('20009', '4', '4', '1', '2004-7-1 9:10:40'),
	('20010', '1', '5', '2', '2005-8-19 10:30:50'),
	('20011', '2', '1', '3', '2006-9-13 23:20:10'),
	('20012', '3', '2', '4', '2007-5-15 22:40:20'),
	('20013', '4', '3', '5', '2002-6-16 11:50:30'),
	('20014', '4', '4', '6', '2009-4-22 9:10:40'),
	('20015', '1', '5', '7', '2001-9-21 7:20:50'),
	('20016', '4', '1', '8', '2002-2-23 6:30:10'),
	('20017', '2', '2', '9', '2003-12-24 3:40:20'),
	('20018', '3', '3', '10', '2004-1-27 6:50:30'),
	('20019', '1', '4', '11', '2005-2-28 19:23:10'),
	('20020', '3', '5', '12', '2006-3-29 23:21:20'),
	('20002', '1', '2', '7', '2005-9-21 11:53:20'),
	('20003', '2', '3', '7', '2004-11-13 4:11:30'),
	('20004', '2', '4', '7', '2003-1-27 5:12:40'),
	('20005', '4', '5', '7', '2002-2-21 2:1:50'),
	('20006', '3', '1', '7', '2001-4-18 1:40:10'),
	('20007', '3', '2', '7', '2002-3-17 16:20:20'),
	('20008', '2', '3', '7', '2003-6-7 18:30:30'),
	('20009', '4', '4', '7', '2004-7-1 9:10:40'),
	('20010', '1', '5', '7', '2005-8-19 10:30:50'),
	('20011', '2', '1', '7', '2006-9-13 23:20:10'),
	('20012', '3', '2', '7', '2007-5-15 22:40:20'),
	('20013', '4', '3', '7', '2002-6-16 11:50:30'),
	('20014', '4', '4', '7', '2009-4-22 9:10:40'),
	('20016', '4', '1', '7', '2002-2-23 6:30:10'),
	('20017', '2', '2', '7', '2003-12-24 3:40:20'),
	('20018', '3', '3', '7', '2004-1-27 6:50:30'),
	('20019', '1', '4', '7', '2005-2-28 19:23:10'),
	('20020', '3', '5', '7', '2006-3-29 23:21:20'),
	('10001', '3', '1', '2', '2001-4-14 22:56:24'),
	('10001', '3', '1', '3', '2001-4-28 22:56:24');

insert into diagnosesGiven values
	('10001', '3', '1', '2001-4-20 22:56:18'),
	('10002', '4', '2', '2002-3-18 8:23:44'),
	('10003', '1', '3', '2001-5-5 23:44:55'),
	('10004', '2', '4', '2003-1-7 22:22:22'),
	('10005', '3', '5', '2004-2-13 12:21:56'),
	('10006', '2', '1', '2002-3-14 13:45:32'),
	('10007', '3', '2', '2001-4-15 9:32:12'),
	('10008', '4', '3', '2005-5-16 20:45:22'),
	('10009', '1', '4', '2006-3-17 8:59:21'),
	('10010', '1', '5', '2007-11-27 23:55:34'),
	('10011', '1', '1', '2003-12-23 21:43:58'),
	('10012', '1', '2', '2004-4-20 19:29:28'),
	('10013', '3', '3', '2005-2-21 23:50:37'),
	('10014', '2', '4', '2006-2-22 18:50:59'),
	('10015', '4', '5', '2007-7-23 22:59:55'),
	('10016', '4', '1', '2008-8-18 18:23:10'),
	('10017', '2', '2', '2001-10-25 18:45:20'),
	('10018', '2', '3', '2002-11-26 19:57:30'),
	('10019', '1', '4', '2003-12-27 18:23:40'),
	('10020', '2', '5', '2004-6-28 13:43:50'),
	('20001', '2', '1', '2006-8-10 12:55:10'),
	('20002', '1', '2', '2005-9-20 11:53:20'),
	('20003', '2', '3', '2004-11-12 4:11:30'),
	('20004', '2', '4', '2003-1-26 5:12:40'),
	('20005', '4', '5', '2002-2-22 2:1:50'),
	('20006', '3', '1', '2001-4-17 1:40:10'),
	('20007', '3', '2', '2002-3-16 16:20:20'),
	('20008', '2', '3', '2003-6-6 18:30:30'),
	('20009', '4', '4', '2004-7-1 4:10:40'),
	('20010', '1', '5', '2005-8-18 10:30:50'),
	('20011', '2', '1', '2006-9-12 23:20:10'),
	('20012', '3', '2', '2007-5-14 22:40:20'),
	('20013', '4', '3', '2002-6-15 11:50:30'),
	('20014', '4', '4', '2009-4-21 9:10:40'),
	('20015', '1', '5', '2001-9-20 7:20:50'),
	('20016', '4', '1', '2002-2-22 6:30:10'),
	('20017', '2', '2', '2003-12-23 3:40:20'),
	('20018', '3', '3', '2004-1-26 6:50:30'),
	('20019', '1', '4', '2005-2-27 19:23:10'),
	('20020', '3', '5', '2006-3-28 23:21:20');

insert into services values
	(1, 'Wed', 'snack cart'),
	(2, 'Sat', 'gift shop'),
	(3, 'Thurs', 'snack cart'),
	(4, 'Mon', 'gift shop'),
	(5, 'Fri', 'reading cart'),
	(6, 'Tues', 'reading cart'),
	(7, 'Tues', 'gift shop'),
	(8, 'Wed', 'information desk'),
	(9, 'Sun', 'reading cart'),
	(10, 'Mon', 'snack cart'),
	(1, 'Sun', 'snack cart'),
	(2, 'Thurs', 'information desk'),
	(3, 'Tues', 'snack cart'),
	(4, 'Sun', 'reading cart'),
	(5, 'Sat', 'reading cart'),
	(6, 'Fri', 'information desk'),
	(7, 'Wed', 'snack cart'),
	(8, 'Sun', 'gift shop'),
	(9, 'Thurs', 'snack cart'),
	(10, 'Thurs', 'gift shop');

insert into admissions values
	('20001', '2', '21', '1', '2006-8-9', '2006-8-12'),
	('20002', '1', '22', 2, '2005-9-19', '2005-9-21'),
	('20003', '2', '23', 3, '2004-11-11', '2004-11-13'),
	('20004', '2', '24', '4', '2003-1-25', '2003-1-27'),
	('20005', '4', '23', '5', '2002-2-23', '2002-2-25'),
	('20006', '3', '21', '6', '2001-4-18', '2001-4-20'),
	('20007', '3', '22', '7', '2002-3-15', '2002-3-17'),
	('20008', '2', '23', '8', '2003-6-5', '2003-6-8'),
	('20009', '4', '24', '9', '2004-7-1', '2004-7-4'),
	('20010', '1', '21', '10', '2005-8-17', '2005-8-19'),
	('20011', '2', '21', '11', '2006-9-11', '2006-9-13'),
	('20012', '3', '22', '12', '2007-5-13', '2007-5-15'),
	('20013', '4', '23', '13', '2002-6-14', '2002-6-18'),
	('20014', '4', '24', '14', '2009-4-20', '2009-4-24'),
	('20015', '1', '22', '15', '2001-9-19', '2001-9-23'),
	('20016', '4', '21', '16', '2002-2-21', '2002-2-25'),
	('20017', '2', '22', '17', '2003-12-22', '2003-12-26'),
	('20018', '3', '23', '18', '2004-1-25', '2004-1-28'),
	('20019', '1', '24', '19', '2005-2-26', '2005-2-28'),
	('20020', '3', '21', '20', '2006-3-27', '2006-3-29'),
	('20001', '1', '22', '1', '2004-08-09', '2005-08-15'),
	('20001', '1', '22', '1', '2003-08-09', '2003-09-15');

