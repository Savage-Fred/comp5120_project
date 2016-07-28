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
		String query = "SELECT rooms.roomNum, patients.pname, dateAdmitted " +
						"FROM rooms LEFT JOIN patients USING (pid) LEFT JOIN admissions USING (pid);";
		
		Statement stmt = main.connection.createStatement();
		
		return stmt.executeQuery(query);
	}	
}
