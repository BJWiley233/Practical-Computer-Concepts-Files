public class TestDogs2
{
   public static void main(String[] args)
   {
      DogTriPart2 dog1 = new DogTriPart2("Bowser", 2, 85, 89, 0);
      dog1.display();
      DogTriPart2 dog2 = new DogTriPart2("Rush", 2, 78, 72, 80);
      dog2.display();
      DogTriPart2 dog3 = new DogTriPart2("Ginger", 3, 90, 86, 72);
      dog3.display();
      System.out.println("");
      DogTriPart2 dog4 = new DogTriPart2("Brian", 1, 25, 86, 0);
      dog4.display();
   }
}