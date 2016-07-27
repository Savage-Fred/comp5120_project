import java.sql.*;

public class RoomUtilization {	
	ResultSet A1() throws SQLException, ClassNotFoundException {
		String query = "SELECT roomNum, pname, dateAdmitted" +
						"FROM rooms NATURAL JOIN patients NATURAL JOIN admissions;";
		
		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}
	
	ResultSet A2() throws SQLException, ClassNotFoundException {
		String query = "SELECT roomNum" + 
					   "FROM rooms" +
					   "WHERE pid IS NULL;";
		Statement stmt = main.connection.createStatement();
		return stmt.executeQuery(query);
	}
	
	
}
