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
   PRIMARY KEY (pid)
   FOREIGN KEY (pid) REFERENCES patients (pid)
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
   PRIMARY KEY (roomNum)
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
   PRIMARY KEY (pid)
   FOREIGN KEY (pid)       REFERENCES inpatientInfo (pid)
   FOREIGN KEY (doctor)    REFERENCES employees (eid)
   FOREIGN KEY (roomNum)   REFERENCES rooms (roomNum)
   FOREIGN KEY (administrator) REFERENCES employees (eid)
);

/*
   - assignedDoctors(pid, doctor)*/
CREATE TABLE assignedDoctors (

);

/*
   - treatments(tid, name)*/
CREATE TABLE treatments (

);

/*
   - diagnoses(did, name)*/

CREATE TABLE diagnoses (

);

/*
   - treatmentsGiven(pid, doctor, tid, eid, timestamp)*/
CREATE TABLE treatmentsGiven (

);

/*
   - diagnosesGiven(pid, doctor, did, timestamp)*/
CREATE TABLE diagnosesGiven (

);

/*
   - services(vid, day, location) */
CREATE TABLE services (

);


insert into employees values
	(000000001, 'CONNIE ARDATH', '1982-2-6', TRUE, 'doctor'),
	(000000002, 'KENNITH KATHRYNE', '1985-1-1', TRUE, 'doctor'),
	(000000003, 'WARD ROWENA', '1983-5-28', TRUE, 'doctor'),
	(000000004, 'CLAUDIO HILDA', '1987-3-26', TRUE, 'doctor'),
	(000000005, 'ELLIS ARLETTE', '1981-2-12', FALSE, 'nurse'),
	(000000006, 'CHRISTOPHER YVONE', '1982-1-26', FALSE, 'nurse'),
	(000000007, 'SOLOMON SHERLEY', '1983-10-27', FALSE, 'nurse'),
	(000000008, 'MODESTO MICHAELE', '1985-8-2', FALSE, 'nurse'),
	(000000009, 'JEFFRY MI', '1984-3-1', FALSE, 'nurse'),
	(000000010, 'MOSES ROMONA', '1984-5-3', FALSE, 'technicians'),
	(000000011, 'MOHAMED ELAYNE', '1987-9-24', FALSE, 'technicians'),
	(000000012, 'THEODORE NOBLE', '1985-8-10', FALSE, 'technicians'),
	(000000013, 'LAMAR PHILOMENA', '1989-10-12', FALSE, 'technicians'),
	(000000014, 'BRANT VERONA', '1984-5-7', FALSE, 'technicians'),
	(000000015, 'PORTER CARLOS', '1986-9-16', FALSE, 'staff'),
	(000000016, 'BLAIR BERENICE', '1989-3-1', FALSE, 'staff'),
	(000000017, 'OTIS JADE', '1986-8-26', FALSE, 'staff'),
	(000000018, 'LAVERNE BEVERLY', '1984-6-24', FALSE, 'staff'),
	(000000019, 'MERLIN QUEEN', '1987-7-14', FALSE, 'staff'),
	(000000020, 'CHAUNCEY INGA', '1983-10-19', FALSE, 'administrator'),
	(000000021, 'SIMON WALTER', '1989-11-18', FALSE, 'administrator'),
	(000000022, 'QUINCY KIMBRA', '1980-9-12', FALSE, 'administrator'),
	(000000023, 'MASON EARNESTINE', '1989-5-8', FALSE, 'administrator'),
	(000000024, 'RICKIE PHILLIP', '1981-2-25', FALSE, 'administrator'),
	(000000025, 'ELOY ANDREE', '1988-4-13', FALSE, 'volunteer'),
	(000000026, 'JARROD BUFORD', '1984-7-2', FALSE, 'volunteer'),
	(000000027, 'TONEY HUGO', '1989-9-4', FALSE, 'volunteer'),
	(000000028, 'GILBERTO VIVIAN', '1985-6-5', FALSE, 'volunteer'),
	(000000029, 'QUENTIN IESHA', '1981-12-7', FALSE, 'volunteer'),
	(000000030, 'TEDDY NEREIDA', '1989-10-27', FALSE, 'volunteer');

