import java.util.Scanner;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Date;
import java.sql.Timestamp;

public class PatientInfo {	
	ResultSet B1() throws SQLException {
		String query = "SELECT patients.pid \"pid\", pname, primaryDoctor, emergencyContact, insurance " +
				"FROM patients LEFT JOIN inpatientInfo ON patients.pid = inpatientInfo.pid; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B2() throws SQLException {
		String query = "SELECT pid, pname " +
				"FROM patients NATURAL JOIN admissions " +
				"WHERE dateDischarged IS NULL; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B3() throws SQLException {
		Scanner input = new Scanner(System.in);
		Date date1, date2;

		String query = "SELECT pid, pname " +
				"FROM patients JOIN admissions USING (pid) " +
				"WHERE dateAdmitted BETWEEN ? and ?; ";

		// try block keeps program from crashing if wrong data is entered
		while(true) {
			try {
				System.out.print("Enter beginning date as YYYY-MM-DD: ");
				date1 = Date.valueOf(input.nextLine());
				System.out.print("Enter ending date as YYYY-MM-DD: ");
				date2 = Date.valueOf(input.nextLine());

				PreparedStatement pstmt = main.connection.prepareStatement(query);
				// replaces ? marks in query
				pstmt.setDate(1, date1);
				pstmt.setDate(2, date2);
				return pstmt.executeQuery();
			}
			catch(IllegalArgumentException e) {
				System.out.println("Illegal Argument make sure date format is YYYY-MM-DD.\n");
			}
		}
	}

	ResultSet B4() throws SQLException {
		Scanner input = new Scanner(System.in);
		Date date1, date2;

		String query = "SELECT pid, pname " +
				"FROM patients join admissions using (pid) " +
				"WHERE dateDischarged BETWEEN ? and ? ; ";

		// try block keeps program from crashing if wrong data is entered
		while(true) {
			try {
				System.out.print("Enter beginning date as YYYY-MM-DD: ");
				date1 =  Date.valueOf(input.nextLine());
				System.out.print("Enter ending date as YYYY-MM-DD: ");
				date2 =  Date.valueOf(input.nextLine());

				PreparedStatement pstmt = main.connection.prepareStatement(query);
				// replaces ? marks in query
				pstmt.setDate(1, date1);
				pstmt.setDate(2, date2);

				return pstmt.executeQuery();
			}
			catch(IllegalArgumentException e) {
				System.out.println("Illegal Argument make sure date format is YYYY-MM-DD.\n");
			}
		}
	}

	ResultSet B5() throws SQLException {
		String query = "SELECT pid, pname " +
				"FROM patients " +
				"WHERE inpatient IS FALSE; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B6() throws SQLException {
		Scanner input = new Scanner(System.in);
		Timestamp time1, time2;

		String query = "SELECT pid, pname " +
				"FROM patients NATURAL JOIN treatmentsGiven NATURAL JOIN diagnosesGiven " +
				"WHERE inpatient IS FALSE " +
				"AND tTime BETWEEN ? and ?; ";

		// try block keeps program from crashing if wrong data is entered
		while(true) {
			try {
				System.out.print("Enter beginning date as YYYY-MM-DD: ");
				time1 = Timestamp.valueOf(input.nextLine() + " 00:00:00");
				System.out.print("Enter ending date as YYYY-MM-DD: ");
				time2 = Timestamp.valueOf(input.nextLine() + " 23:59:59");

				PreparedStatement pstmt = main.connection.prepareStatement(query);
				// replaces ? marks in query
				pstmt.setTimestamp(1, time1);
				pstmt.setTimestamp(2, time2);

				return pstmt.executeQuery();
			}
			catch (IllegalArgumentException e) {
				System.out.println("Illegal Argument make sure date format is YYYY-MM-DD.\n");
			}
		}
	}

	ResultSet B7() throws SQLException {
		Scanner input = new Scanner(System.in);
		String patientInfo;

		String query = "SELECT pid, pname, dname " +
				"FROM patients NATURAL JOIN admissions JOIN diagnosesGiven USING (pid)" +
				"NATURAL JOIN diagnoses " +
				"WHERE pid = ? OR pname = ?; " ;
		while(true) {
			try {
				//get patientInfo
				System.out.print("Enter either patient name or ID: ");
				patientInfo = input.nextLine().toUpperCase();

				PreparedStatement pstmt = main.connection.prepareStatement(query);
				// replaces ? marks in query.
				// In this case we're assuming it's one or the other so set both to patientInfo 
				pstmt.setString(1, patientInfo);
				pstmt.setString(2, patientInfo);

				return pstmt.executeQuery();
			}
			catch (IllegalArgumentException e) {
				System.out.println("Illegal Argument make sure date format is YYYY-MM-DD.\n");
			}
		}
	}

	ResultSet B8() throws SQLException {
		Scanner input = new Scanner(System.in);
		String patientInfo = new String();

		String query = "SELECT treatments.tname, treatmentsGiven.tTime, admissions.dateAdmitted " +
				"FROM patients NATURAL JOIN admissions JOIN treatmentsGiven USING (pid) NATURAL JOIN treatments " +
				"WHERE pid = ? OR pname = ? " +
				"GROUP BY treatments.tname, treatmentsGiven.tTime, admissions.dateAdmitted " +
				"ORDER BY admissions.dateAdmitted DESC, treatmentsGiven.tTime ASC; ";

		//get patientInfo
		System.out.print("Enter either patient name or ID: ");
		patientInfo = input.nextLine();
		patientInfo = patientInfo.toUpperCase();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query.
		// In this case we're assuming it's one or the other so set both to patientInfo 
		pstmt.setString(1, patientInfo);
		pstmt.setString(2, patientInfo);

		return pstmt.executeQuery();
	}

	ResultSet B9() throws SQLException {
		String query = "SELECT patients.pid, patients.pname, diagnoses.dname, employees.ename " +
				"FROM patients NATURAL JOIN admissions JOIN  employees ON (admissions.doctor = employees.eid) JOIN " +
				"diagnosesGiven ON (patients.pid = diagnosesGiven.did) " +
				"JOIN diagnoses ON(diagnosesGiven.did = diagnoses.did) " +
				"WHERE patients.pid = (SELECT DISTINCT pid FROM admissions WHERE dateAdmitted > dateDischarged " +
				"AND dateAdmitted - dateDischarged <= 30 GROUP BY pid);";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B10() throws SQLException {
		String query = "SELECT pname, pid, COUNT(pid) AS \"Times Admitted\", " +
				"ROUND(AVG(dateDischarged - dateAdmitted), 2) AS \"Average Admission Span\", " +
				"MAX(dateDischarged - dateAdmitted) AS \"Max Admission Span\", " +
				"MIN(dateDischarged - dateAdmitted) AS \"Min Admission Span\" " +
				"FROM admissions NATURAL JOIN patients " +
				"GROUP BY pname, pid; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}
}


