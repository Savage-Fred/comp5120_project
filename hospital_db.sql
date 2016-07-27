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
   FOREIGN KEY (pid) REFERENCES patients (pid) -- originally inpatientInfo (pid) - Will Mc
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
   PRIMARY KEY (pid),
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
   sday      text NOT NULL
         CHECK (sday IN ('Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun')),
   slocation text NOT NULL
         CHECK (slocation IN ('gift shop', 'information desk', 'snack cart', 'reading cart')),
   FOREIGN KEY (vid) REFERENCES volunteers (vid),
   PRIMARY KEY (vid, sday)
);
