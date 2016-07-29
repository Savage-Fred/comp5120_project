import java.util.Scanner;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Date;
import java.sql.Timestamp;

public class DTInfo {
	ResultSet C1() throws SQLException {
		String query = "SELECT did, dname, COUNT(did) AS occurrences " +
				"FROM diagnosesGiven LEFT JOIN diagnoses USING (did) NATURAL JOIN patients JOIN admissions USING (pid) " +
				"WHERE dateDischarged IS NULL " +
				"GROUP BY did, dname " +
				"ORDER BY occurrences desc;";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C2() throws SQLException {
		String query = "SELECT did, dname, COUNT(did) as occurrences " +
						"FROM diagnoses NATURAL JOIN diagnosesGiven JOIN patients using (pid) " +
						"WHERE inpatient is false " +
						"GROUP BY did " +
						"ORDER BY occurrences desc;"; 

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C3() throws SQLException {
		String query = "SELECT did, dname, COUNT(did) as occurrences " +
				"FROM diagnosesGiven NATURAL JOIN diagnoses " +
				"GROUP BY did, dname " +
				"ORDER BY occurrences desc;";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C4() throws SQLException {
		String query = "SELECT trid, tname, COUNT(trid) as occurrences " +
				"FROM treatmentsGiven NATURAL JOIN treatments " +
				"GROUP BY trid, tname " +
				"ORDER BY occurrences desc;";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C5() throws SQLException {
		String query = "SELECT trid, tname, COUNT(trid) as occurrences " +
				"FROM treatmentsGiven NATURAL JOIN treatments NATURAL JOIN admissions NATURAL JOIN patients " +
				"WHERE inpatient IS TRUE " +
				"GROUP BY trid, tname " +
				"ORDER BY occurrences desc;";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C6() throws SQLException {
		String query = "SELECT treatments.trid, treatments.tname, COUNT(tTime) as occurrences " +
				"FROM treatments NATURAL JOIN treatmentsGiven JOIN patients using (pid) " +
				"WHERE patients.inpatient IS FALSE " +
				"GROUP BY treatments.trid " +
				"ORDER BY occurrences desc;";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C7() throws SQLException {
		String query = "SELECT dname,patients.pname,COUNT(admissions.pid) AS TotalAdmissions " +
						"FROM patients NATURAL JOIN admissions LEFT JOIN diagnosesGiven ON admissions.pid=diagnosesGiven.pid NATURAL JOIN diagnoses " +
						"WHERE patients.pname = (SELECT pname " +
                		"FROM (SELECT pname, COUNT(admissions.pid) AS aCount " +
                      				"FROM patients NATURAL JOIN admissions " +
                      				"GROUP BY pname) AS admitCount " +
                		    "WHERE aCount = (SELECT MAX(aCount) " +
                                			"FROM (SELECT COUNT(pid) AS aCount " +
                                            "FROM admissions " +
                                            "GROUP BY pid) AS maxCount)) " +
						"GROUP BY patients.pname, diagnoses.dname " +
						"ORDER BY COUNT(admissions.pid) ASC ";

		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}

	ResultSet C8() throws SQLException {
		Scanner input = new Scanner(System.in);
		Timestamp time;
		String pid;

		String query = "SELECT tname, tTime, treatmentsGiven.eid, pname, ename as doctor " +
				"FROM treatmentsGiven NATURAL JOIN treatments NATURAL JOIN patients JOIN employees ON (doctor = employees.eid)" +
				"WHERE pid = ? AND tTime = ?;";

		// try statement prevents exception related crash
		while(true) {
			try {
				System.out.print("Enter timestamp as YYYY-MM-DD HH:MM:SS: ");
				time = Timestamp.valueOf(input.nextLine());
				System.out.print("Enter patient id: ");
				pid = input.nextLine();

				PreparedStatement pstmt = main.connection.prepareStatement(query);
				pstmt.setString(1, pid);
				pstmt.setTimestamp(2, time);

				return pstmt.executeQuery();
			}
			catch (IllegalArgumentException e) {
				System.out.println("Illegal Argument make sure date format is YYYY-MM-DD HH:MM:SS.\n");
			}
		}
	}
}