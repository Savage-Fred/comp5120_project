/*
 hospital_db.sql 

 SQL commands for creating the hospital database 
 */

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
   FOREIGN KEY (primaryDoctor) REFERENCES admissions (doctor)
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
   FOREIGN KEY (pid) REFERENCES inpatientInfo (pid)
);

/*
   - admissions(doctor, pid, room, dateAdmitted, dateDischarged, admin)
   - a doctor with admitting priveleges admits a patient 
   - the admitting doctor is the patient's primary doctor */
CREATE TABLE admissions (
   pid            varchar(10),
   doctor         varchar(10),
   administrator  varchar(10),
   roomNum        smallint,
   dateAdmitted   date,
   dateDischarged date,
   PRIMARY KEY (pid),
   FOREIGN KEY (pid)       REFERENCES inpatientInfo (pid),
   FOREIGN KEY (doctor)    REFERENCES employees (eid),
   FOREIGN KEY (roomNum)   REFERENCES rooms (roomNum),
   FOREIGN KEY (administrator) REFERENCES employees (eid)
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
   PRIMARY KEY (pid, tTime)
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
   sday      varchar(5) NOT NULL
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
	(10, 'MOSES ROMONA', '1984-5-3', FALSE, 'technicians'),
	(11, 'MOHAMED ELAYNE', '1987-9-24', FALSE, 'technicians'),
	(12, 'THEODORE NOBLE', '1985-8-10', FALSE, 'technicians'),
	(13, 'LAMAR PHILOMENA', '1989-10-12', FALSE, 'technicians'),
	(14, 'BRANT VERONA', '1984-5-7', FALSE, 'technicians'),
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
	(100010, 'ED MARICA', FALSE),
	(100011, 'QUINCY JAY', FALSE),
	(100012, 'CLEMENTE CORRINA', FALSE),
	(100013, 'JOHNATHAN ANTONIO', FALSE),
	(100014, 'FREEMAN THOMAS', FALSE),
	(100015, 'GARRETT CATHY', FALSE),
	(100016, 'ROOSEVELT DORI', FALSE),
	(100017, 'WILLIE TORRIE', FALSE),
	(100018, 'MITCHEL CALLIE', FALSE),
	(100019, 'SAUL MADALINE', FALSE),
	(100020, 'LESLEY ISABELLE', FALSE),
	(20001, 'BOOKER OTTO', TRUE),
	(20002, 'JUDE FLORENCIO', TRUE),
	(20003, 'COLLIN SHERRY', TRUE),
	(20004, 'HANK WAYNE', TRUE),
	(20005, 'BRENDAN STASIA', TRUE),
	(20006, 'RENATO THERESIA', TRUE),
	(20007, 'DENNY FRANKIE', TRUE),
	(20008, 'GAYLE ANGIE', TRUE),
	(20009, 'AURELIO BEULAH', TRUE),
	(200010, 'CASEY ROBERTO', TRUE),
	(200011, 'GROVER GERI', TRUE),
	(200012, 'LAMONT MINDA', TRUE),
	(200013, 'ANTONIA KERRY', TRUE),
	(200014, 'DEANGELO EDGARDO', TRUE),
	(200015, 'CAMERON GRETTA', TRUE),
	(200016, 'DEL SARAN', TRUE),
	(200017, 'RAYMOND CHRISTAL', TRUE),
	(200018, 'REED ROSELEE', TRUE),
	(200019, 'SETH LAWRENCE', TRUE),
	(200020, 'JACK LATASHA', TRUE);

insert into rooms values
	(1, '1'),
	(2, '2'),
	(3, '3'),
	(4, '4'),
	(5, '5'),
	(6, '6'),
	(7, '7'),
	(8, '8'),
	(9, '9'),
	(10, '10'),
	(11, '11'),
	(12, '12'),
	(13, '13'),
	(14, '14'),
	(15, '15'),
	(16, '16'),
	(17, '17'),
	(18, '18'),
	(19, '19'),
	(20, '20'),
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
	(40, NULL),
	(41, NULL),
	(42, NULL),
	(43, NULL),
	(44, NULL),
	(45, NULL),
	(46, NULL),
	(47, NULL),
	(48, NULL),
	(49, NULL),
	(50, NULL);

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
	('100010', '1'),
	('100011', '1'),
	('100012', '1'),
	('100013', '3'),
	('100014', '2'),
	('100015', '4'),
	('100016', '4'),
	('100017', '2'),
	('100018', '2'),
	('100019', '1'),
	('100020', '2'),
	('20001', '2'),
	('20002', '1'),
	('20003', '2'),
	('20004', '2'),
	('20005', '4'),
	('20006', '3'),
	('20007', '3'),
	('20008', '2'),
	('20009', '4'),
	('200010', '1'),
	('200011', '2'),
	('200012', '3'),
	('200013', '4'),
	('200014', '4'),
	('200015', '1'),
	('200016', '4'),
	('200017', '2'),
	('200018', '3'),
	('200019', '1'),
	('200020', '3');

