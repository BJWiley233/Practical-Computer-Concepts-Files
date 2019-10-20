import java.nio.file.*;
import java.util.Scanner;
import static java.nio.file.AccessMode.*;
import java.io.IOException;

public class PathDemo2
{
   public static void main(String[] args)
   {
      String name;
      Scanner input = new Scanner(System.in);
      System.out.print("Enter file name >> ");
      name = input.nextLine();
      Path inputPath = Paths.get(name);
      Path fullPath = inputPath.toAbsolutePath();
      try
      {
         fullPath.getFileSystem().provider().checkAccess(fullPath, READ, WRITE);
         System.out.println("Full path is " + fullPath.toString());
      }
      catch(IOException e)
      {
         System.out.println("File cannot be used for this application");
      }
   }
}
