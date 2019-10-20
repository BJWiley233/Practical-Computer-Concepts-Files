import java.nio.file.*;
import java.io.IOException;
import java.nio.file.attribute.*;

public class PathDemo4
{
   public static void main(String[] args)
   {
      Path filePath = Paths.get("turtle.jpg");
      
      try
      {
         BasicFileAttributes attr = Files.readAttributes(filePath, BasicFileAttributes.class);
         System.out.println("File created on " + attr.creationTime());
         System.out.println("Was last modified on " + attr.lastModifiedTime());
         System.out.println("Size is " + attr.size());
      }
      catch (IOException e)
      {
         System.out.println("IO Exception");
      }
   }         
}