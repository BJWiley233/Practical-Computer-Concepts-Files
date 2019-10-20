import java.nio.file.*;
import java.io.*;

public class ReadEmployeeFile2
{
   public static void main(String[] args) throws Exception
   {
      //Path file = Paths.get("Employees.txt");
      Path file = Paths.get("Employees.txt");
      double gross;
      String delimeter = ",";
      String s = "";
      double total = 0;
      try
      {
         InputStream input = new BufferedInputStream(Files.newInputStream(file));
         BufferedReader reader = new BufferedReader(new InputStreamReader(input)); 
         String[] nextRecord;
         s = reader.readLine();
         while (s != null)
         {
            nextRecord = s.split(delimeter);
            int id = Integer.parseInt(nextRecord[0]);
            gross = Double.parseDouble(nextRecord[2]) * 40;
            System.out.println("ID#" + id + " " + nextRecord[1] + " $" + nextRecord[2] + " $" + gross);
            total += gross;
            s = reader.readLine();  // this is needed!!
         }
         reader.close();
      }
      catch(Exception e)
      {
         System.out.println(e);
      }
      System.out.println(" Total gross payroll is $" + total);
   }
}