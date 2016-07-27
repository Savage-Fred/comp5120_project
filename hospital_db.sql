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