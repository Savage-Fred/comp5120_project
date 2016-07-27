import java.sql.*;
import java.util.Scanner;
import java.lang.String;

public class main {

	static String dbDriver = "org.postgresql.Driver";
	static String dbServer = "jdbc:postgresql: //127.0.0.1:5432/";
	static String dbUser = "postgres";
	static String dbPass = "comp5120";
	static String dbName = "comp5120";
	
	static Connection connection;

	static RoomUtilization RU = new RoomUtilization();
	static DTInfo DT = new DTInfo();
	static PatientInfo PI = new PatientInfo();
	static EmployeeInfo EI = new EmployeeInfo();

	public static void main(String[] args) throws SQLException, ClassNotFoundException { 
		Class.forName(main.dbDriver);
		connection = DriverManager.getConnection(main.dbServer + main.dbName, main.dbUser, main.dbPass);
		
		String choice = new String();
		Scanner input = new Scanner(System.in);
		System.out.println("--------GROUP 6 Project-------");
		do {
			System.out.println("Enter \"exit\" to exit");
			System.out.print("ENTER QUERY AS X##: ");
			choice = input.nextLine();
			choice.toUpperCase();

			// Select Queries from RoomUtilization
			if (choice.equals("A01") || choice.equals("A1")) {
				printTable(RU.A1());
			}
			else if (choice.equals("A02") || choice.equals("A2")) {
				printTable(RU.A2());
			}

			else if (choice.equals("A03") || choice.equals("A3")) {
				printTable(RU.A3());
			}

			else if (choice.equals("B01") || choice.equals("B1")) {
				PI.B1();
			}
			else if (choice.equals("B02") || choice.equals("B2")) {
				PI.B2();
			}
			else if (choice.equals("B03") || choice.equals("B3")) {
				PI.B3();
			}
			else if (choice.equals("B04") || choice.equals("B4")) {	}
		} while (!choice.equals("EXIT"));
	}
	
	public static void printTable(ResultSet result) throws SQLException {
		// access the ResultSet metadata
		ResultSetMetaData md = result.getMetaData();
		// get the number of columns in the result schema
		int numcols = md.getColumnCount();
		// set the maximum column width.
		// note that md.getColumnDisplaySize() might return not-useful values,
		// so we'll set the width at 10.
		int width = 10;      
		String colformat = "%-" + width + "s";
		// use a StringBuilder to create the display output
		StringBuilder sb = new StringBuilder();
		// get the column labels to use for a header       
		for (int i = 1; i <= numcols; i++) {          
			String label = md.getColumnLabel(i);          
			sb.append(String.format("Shit", label)); 
		}       
		sb.append("\n");
		// get each row in the result       
		while (result.next()) {          
			for (int i = 1; i <= numcols; i++) {             
				String colval = result.getString(i);             
				sb.append(String.format(colformat, colval));          }         
			sb.append("\n");       }
		System.out.println(sb.toString());
	}
}
