//package algorithms;

public class ColourConsoleDemo {

   public static void main(String[] args) {
      // TODO Auto-generated method stub
      final String ANSI_RED = "\u001B[31m";
      final String ANSI_RESET = "\u001B[0m";
      
      System.out.println("\033[0m BLACK");
      System.out.printf(ANSI_RED + "RED" + ANSI_RESET);
      System.out.println("\033[32m GREEN");
      System.out.println("\033[33m YELLOW");
      System.out.println("\033[34m BLUE");
      System.out.println("\033[35m MAGENTA");
      System.out.println("\033[36m CYAN");
      System.out.println("\033[37m WHITE");
   }

}