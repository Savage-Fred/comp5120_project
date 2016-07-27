import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RoomUtilization {	
	ResultSet A1() throws SQLException {
		String query = "SELECT roomNum, pname, dateAdmitted " +
						"FROM rooms NATURAL JOIN patients NATURAL JOIN admissions;";
		
		Statement stmt = main.connection.createStatement();
		
		return stmt.executeQuery(query);
	}
	
	ResultSet A2() throws SQLException {
		String query = "SELECT roomNum " + 
					   "FROM rooms " +
					   "WHERE pid IS NULL; ";
		
		Statement stmt = main.connection.createStatement();
		
		return stmt.executeQuery(query);
	}
	
	ResultSet A3() throws SQLException {
		String query = "SELECT tempb3.roomNum, pid, dateAdmitted " +
					   "FROM (SELECT roomNum, patients.pid " +
					   		  "FROM rooms LEFT JOIN patients ON (rooms.pid = patients.pid)) AS tempb3 " +
					      "JOIN admissions USING (pid);";
		
		Statement stmt = main.connection.createStatement();
		
		return stmt.executeQuery(query);
	}	
}
