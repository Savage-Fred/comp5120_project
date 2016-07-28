import java.sql.*;
import java.util.Scanner;
import java.lang.String;

public class main {

	static String dbDriver = "org.postgresql.Driver";
	static String dbServer = "jdbc:postgresql://127.0.0.1:5432/";
	static String dbUser = "postgres";
	static String dbPass = "comp5120";
	static String dbName = "comp5120";

	static Connection connection;

	static RoomUtilization RU = new RoomUtilization();
	static PatientInfo PI = new PatientInfo();
	static DTInfo DT = new DTInfo();
	static EmployeeInfo EI = new EmployeeInfo();

	public static void main(String[] args) throws SQLException, ClassNotFoundException { 
		Class.forName(main.dbDriver);
		connection = DriverManager.getConnection(main.dbServer + main.dbName, main.dbUser, main.dbPass);

		String choice = new String();
		Scanner input = new Scanner(System.in);
		System.out.println("--------GROUP 6 Project-------");
		do {
			System.out.println("\n\nEnter \"exit\" to exit");
			System.out.print("ENTER QUERY AS X##: ");
			choice = input.nextLine();
			choice = choice.toUpperCase();

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

			// Select Queries from PatientInfo
			else if (choice.equals("B01") || choice.equals("B1")) {
				printTable(PI.B1());
			}
			else if (choice.equals("B02") || choice.equals("B2")) {
				printTable(PI.B2());
			}
			else if (choice.equals("B03") || choice.equals("B3")) {
				printTable(PI.B3());
			}
			else if (choice.equals("B04") || choice.equals("B4")) {
				printTable(PI.B4());
			}
			else if (choice.equals("B05") || choice.equals("B5")) {
				printTable(PI.B5());
			}
			else if (choice.equals("B06") || choice.equals("B6")) {
				printTable(PI.B6());
			}
			else if (choice.equals("B07") || choice.equals("B7")) {
				printTable(PI.B7());
			}
			else if (choice.equals("B08") || choice.equals("B8")) {
				printTable(PI.B8());
			}			
			else if (choice.equals("B09") || choice.equals("B9")) {
				printTable(PI.B9());
			}
			else if (choice.equals("B10")) {
				printTable(PI.B10());
			}

			// Select Queries from DTInfo
			else if (choice.equals("C01") || choice.equals("C1")) {
				printTable(DT.C1());
			}
			else if (choice.equals("C02") || choice.equals("C2")) {
				printTable(DT.C2());
			}
			else if (choice.equals("C03") || choice.equals("C3")) {
				printTable(DT.C3());
			}
			else if (choice.equals("C04") || choice.equals("C4")) {
				printTable(DT.C4());
			}
			else if (choice.equals("C05") || choice.equals("C5")) {
				printTable(DT.C5());
			}
			else if (choice.equals("C06") || choice.equals("C6")) {
				printTable(DT.C6());
			}
			else if (choice.equals("C07") || choice.equals("C7")) {
				printTable(DT.C7());
			}
			else if (choice.equals("C08") || choice.equals("C8")) {
				printTable(DT.C8());
			}

			// Select Queries from EmployeeInfo
			else if (choice.equals("D01") || choice.equals("D1")) {
				printTable(EI.D1());
			}
			else if (choice.equals("D02") || choice.equals("D2")) {
				printTable(EI.D2());
			}
			else if (choice.equals("D03") || choice.equals("D3")) {
				printTable(EI.D3());
			}
			else if (choice.equals("D04") || choice.equals("D4")) {
				printTable(EI.D4());
			}
			else if (choice.equals("D05") || choice.equals("D5")) {
				printTable(EI.D5());
			}
			else if (choice.equals("D06") || choice.equals("D6")) {
				printTable(EI.D6());
			}
			else if (choice.equals("D07") || choice.equals("D7")) {
				printTable(EI.D7());
			}

		} while (!choice.equals("EXIT"));
	}


	/* 
	 * Taken from the notes
	 */
	private static void printTable(ResultSet result) throws SQLException {
		// access the ResultSet metadata
		ResultSetMetaData md = result.getMetaData();
		// get the number of columns in the result schema
		int numcols = md.getColumnCount();
		// set the maximum column width.
		// note that md.getColumnDisplaySize() might return not-useful values,
		// so we'll set the width at 10.
		int width = 20;      
		String colformat = "%-" + width + "s";
		// use a StringBuilder to create the display output
		StringBuilder sb = new StringBuilder();
		// get the column labels to use for a header       
		for (int i = 1; i <= numcols; i++) {          
			String label = md.getColumnLabel(i);          
			sb.append(String.format(colformat, label)); 
		}       
		sb.append("\n");
		// get each row in the result       
		while (result.next()) {          
			for (int i = 1; i <= numcols; i++) {             
				String colval = result.getString(i);             
				sb.append(String.format(colformat, colval));
			}         
			sb.append("\n");
		}
		System.out.println(sb.toString());
	}
}