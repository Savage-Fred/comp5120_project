import java.sql.*;
import java.util.Scanner;

public class EmployeeInfo {
	ResultSet D1() throws SQLException {
		String query = "SELECT eid, name, category, hireDate " +
				"FROM employees " +
				"ORDER BY name;";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet D2() throws SQLException {
		String query = "SELECT vid, name " +
				"FROM volunteers NATURAL JOIN services " +
				"WHERE location=’information desk’ AND sday =  ‘[Tuesday]’;";
		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet D3() throws SQLException {
		String query = "";
		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet D4() throws SQLException {
		Scanner input = new Scanner(System.in);
		String doctorInfo = new String();

		String query = "SELECT dname, COUNT(doctor) as occurrences " +
				"FROM diagnosesGiven JOIN diagnoses using (did) JOIN employees ON (doctor = eid) " +
				"WHERE doctor = ‘?’ OR ename = ‘?’ " +
				"GROUP BY dname " +
				"ORDER BY occurrences desc;" ;


		//Probably want this to check the format but LMAO
		System.out.print("Enter either Doctor's Employee ID or Name: ");
		doctorInfo = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query
		pstmt.setString(1, doctorInfo);

		return pstmt.executeQuery();
	}

	ResultSet D5() throws SQLException {
		Scanner input = new Scanner(System.in);
		String doctorInfo = new String();

		String query = "SELECT tname, COUNT(doctor) as occurrences " +
				"FROM treatments JOIN treatmentsGiven USING (trid) JOIN employees ON (doctor = employees.eid) " +
				"WHERE doctor = ‘?’ OR ename = '?'" +
				"GROUP BY tname " +
				"ORDER BY occurrences desc;";

		//Probably want this to check the format but LMAO
		System.out.print("Enter either Doctor's Employee ID or Name: ");
		doctorInfo = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query
		pstmt.setString(1, doctorInfo);

		return pstmt.executeQuery();
	}

	ResultSet D6() throws SQLException {
		Scanner input = new Scanner(System.in);
		String doctorInfo = new String();

		String query = "SELECT tname, COUNT(treatmentsGiven.eid) as occurrences " +
					"FROM treatments join treatmentsGiven using (trid) JOIN employees ON (treatmentsGiven.eid  =  employees.eid) " +
					"WHERE eid = ‘?’ OR ename = ‘?’ " +
					"GROUP BY tname " +
					"ORDER BY occurrences desc;";

		//Probably want this to check the format but LMAO
		System.out.print("Enter either Doctor's Employee ID or Name: ");
		doctorInfo = input.nextLine();

		PreparedStatement pstmt = main.connection.prepareStatement(query);
		// replaces ? marks in query
		pstmt.setString(1, doctorInfo);

		return pstmt.executeQuery();	
	}

	ResultSet D7() throws SQLException {
		String query = "";
		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}
}