import java.nio.file.*;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import static java.nio.file.StandardOpenOption.*;
import java.util.Scanner;

public class CreateEmployeesRandomFile
{
   public static void main(String[] args) throws Exception
   {
      Path file = Paths.get("RandomEmployees.txt");
      String s = "000,       ,00.00" + System.getProperty("line.separator");
                      ///////
      byte[] data = s.getBytes();
      ByteBuffer buffer = ByteBuffer.wrap(data); // need wrap method
      final int REC_SIZE = s.length();
      FileChannel fc = null;
      String idString;
      int id;
      String name;
      String payRate;
      final String QUIT = "999";
      Scanner input = new Scanner(System.in);
      String delimeter = ",";
      try
      {
         fc = (FileChannel)Files.newByteChannel(file, READ, WRITE);
         System.out.print("Enter employee ID number >> ");
         idString = input.nextLine();
         while (!idString.equals(QUIT))
         {
            id = Integer.parseInt(idString);
            System.out.print("Enter name (7 letters only) >> ");
            
            while ((name = input.nextLine()).length() != 7)
            {
               System.out.print("Enter 7 letters only for name >> ");
            }
            System.out.println(name);
            System.out.print("Enter pay rate for employee #" + id + " >> ");
            payRate = input.nextLine();
            s = idString + delimeter + name + delimeter + payRate + System.getProperty("line.separator");
            data = s.getBytes();
            buffer = ByteBuffer.wrap(data);
            fc.position(id * REC_SIZE);
            fc.write(buffer);
            System.out.print("Enter next ID number or " + QUIT + " to quit >> ");
            idString = input.nextLine();
         }
         fc.close();
      }
      catch (Exception e)
      {
         System.out.println(e);
      }
   }
}