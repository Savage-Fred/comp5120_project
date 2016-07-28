import java.util.Scanner;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

public class PatientInfo {	
	ResultSet B1() throws SQLException {
		String query = "SELECT patients.pid �pid�, name, primaryDoctor, emergencyContact, insurance " +
				"FROM patients LEFT JOIN inpatientInfo ON patients.pid = inpatientInfo.pid; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B2() throws SQLException {
		String query = "SELECT pid, pname " +
				"FROM patients" +
				"WHERE inpatient IS TRUE; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B3() throws SQLException {
		Scanner input = new Scanner(System.in);
		String date1, date2;

		String query = "SELECT pid, name " +
				"FROM patients join admissions using (pid) " +
				"WHERE dateAdmitted BETWEEN ? and ?; ";

		//Probably want this to check the format but LMAO
		System.out.print("Enter beginning date as YYYY-MM-DD: ");
		date1 = input.nextLine();
		System.out.print("Enter ending date as YYYY-MM-DD: ");
		date2 = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query
		pstmt.setString(1, date1);
		pstmt.setString(2, date2);

		return pstmt.executeQuery();
	}

	ResultSet B4() throws SQLException {
		Scanner input = new Scanner(System.in);
		String date1, date2;

		String query = "SELECT pid, name " +
				"FROM patients join admissions using (pid) " +
				"WHERE dateDischarged BETWEEN ? and ? ; ";


		//Probably want this to check the format but LMAO
		System.out.print("Enter beginning date as YYYY-MM-DD: ");
		date1 = input.nextLine();
		System.out.print("Enter ending date as YYYY-MM-DD: ");
		date2 = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query
		pstmt.setString(1, date1);
		pstmt.setString(2, date2);

		return pstmt.executeQuery();
	}

	ResultSet B5() throws SQLException {
		String query = "SELECT pid, name " +
				"FROM patients " +
				"WHERE inpatient IS FALSE; ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet B6() throws SQLException {
		Scanner input = new Scanner(System.in);
		String date1, date2;

		String query = "SELECT pid, name " +
				"FROM patients  JOIN treatmentsGiven JOIN diagnosesGiven USING (pid) " +
				"WHERE inpatient IS FALSE " +
				"AND timestamp BETWEEN ? and ?; ";



		//Probably want this to check the format but LMAO
		System.out.print("Enter beginning date as YYYY-MM-DD: ");
		date1 = input.nextLine() + " 00:00:00";
		System.out.print("Enter ending date as YYYY-MM-DD: ");
		date2 = input.nextLine() + " 23:59:59";

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query
		pstmt.setString(1, date1);
		pstmt.setString(2, date2);

		return pstmt.executeQuery();
	}

	ResultSet B7() throws SQLException {
		Scanner input = new Scanner(System.in);
		String patientInfo;

		String query = "SELECT pid, pname, dname " +
				"FROM patients NATURAL JOIN admissions NATURAL JOIN diagnosesGiven " +
				"NATURAL JOIN diagnoses " +
				"WHERE pid = ? OR pname = ?; " ;

		//get patientInfo
		System.out.print("Enter either patient name or ID: ");
		patientInfo = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query.
		// In this case we're assuming it's one or the other so set both to patientInfo 
		pstmt.setString(1, patientInfo);
		pstmt.setString(2, patientInfo);

		return pstmt.executeQuery();
	}

	ResultSet B8() throws SQLException {
		Scanner input = new Scanner(System.in);
		String patientInfo = new String();
		
		String query = "SELECT treatments.name, treatmentsGiven.tTime, admissions.dateAdmitted " +
				"FROM patients NATURAL JOIN admissions NATURAL JOIN treatmentsGiven + NATURAL JOIN treatments " +
				"WHERE pid = ? or WHERE name = ? " +
				"GROUP BY admissions.dateAdmitted DESC " +
				"ORDER BY treatmentsGiven.tTime ASC; ";

		//get patientInfo
		System.out.print("Enter either patient name or ID: ");
		patientInfo = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query.
		// In this case we're assuming it's one or the other so set both to patientInfo 
		pstmt.setString(1, patientInfo);
		pstmt.setString(2, patientInfo);

		return pstmt.executeQuery();
	}

	ResultSet B9() throws SQLException {
		String query = "SELECT patients.pid, patients.name, diagnosis.name, employees.name " +
					"FROM patients, admissions, employees, diagnosis " +
					"WHERE diagnosis.pid = admissions.pid AND admissions.pid = patients.pid AND patients.pid = " +
						"(SELECT DISTINCT pid " +
						"FROM admissions " +
						"GROUP BY pid " +
						"WHERE dateAdmitted > dateDischarged AND dateAdmitted - dateDischarged <= 30);";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}
	
	ResultSet B10() throws SQLException {
		String query = "";
		
		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}
}


