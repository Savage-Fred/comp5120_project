import java.sql.*;
import java.util.Scanner;

public class main {

	static String dbDriver = "org.postgresql.Driver";
	static String dbServer = "jdbc:postgresql: //127.0.0.1:5432/";
	static String dbUser = "postgres";
	static String dbPass = "comp5120";
	static String dbName = "comp5120";

	static RoomUtilization RU = new RoomUtilization();
	static DTInfo DT = new DTInfo();
	static PatientInfo PI = new PatientInfo();
	static EmployeeInfo EI = new EmployeeInfo();

	public static void main(String[] args) throws SQLException, ClassNotFoundException { 
		Class.forName(dbDriver);
		Connection connection = DriverManager.getConnection(dbServer + dbName, dbUser, dbPass);


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
				RU.A1();
			}
			else if (choice.equals("A02") || choice.equals("A2")) {
				RU.A2();
			}

			else if (choice.equals("A03") || choice.equals("A3")) {
				RU.A3();
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
}
