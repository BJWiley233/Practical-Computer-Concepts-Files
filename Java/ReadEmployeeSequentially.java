import java.nio.file.*;
import java.io.*;
import java.nio.file.AccessMode.*;

public class ReadEmployeeSequentially
{
   public static void main(String[] args) //throws Exception
   {
      Path file = Paths.get("RandomEmployees.txt");
      String[] array = new String[3];
      String s = "";
      String delimiter = ",";
      int id;
      String stringID;
      String name;
      double payRate;
      double gross;
      final double HRS_IN_WEEK = 40.0;
      double total = 0;
      
      try
      {
         InputStream input = new 
            BufferedInputStream(Files.newInputStream(file));
         BufferedReader reader = new 
            BufferedReader(new InputStreamReader(input));
         System.out.println();
         s = reader.readLine();
         while (s != null)
         {
            array = s.split(delimiter);
            stringID = array[0];
            id = Integer.parseInt(stringID);
            if (id == 3)
            {
               name = array[1];
               payRate = Double.parseDouble(array[2]);
               gross = payRate * HRS_IN_WEEK;
               total += gross;
               System.out.println("ID#" + stringID + " " + name +
                  " $" + payRate + " $" + gross);
            }
            s = reader.readLine();
         }
         reader.close();
      }
      catch (Exception e)
      {
         System.out.println("Message " + e);
      }
      System.out.println("Total gross payroll is $" + total);
   }
}