import java.nio.file.*;
import java.io.IOException;

public class PathDemo3
{
   public static void main(String[] args)
   {
      Path filePath = Paths.get("Data.txt");
      try
      {
         Files.delete(filePath);
         System.out.println("File deleted");
      }
      catch (NoSuchFileException e)
      {
         System.out.println("No such file or directory");
      }
      catch (DirectoryNotEmptyException e)
      {
         System.out.println("Directory not empty");
      }
      catch (SecurityException e)
      {
         System.out.println("No permission");
      }
      catch (IOException e)
      {
         System.out.println("IO Exception");
      }

   }
}
