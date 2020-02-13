import java.util.Random;

import DuplicateSearchWithObjects.Compare;

public class RunTimeMultipleArraySizes {
	public static void main(String[] args) {
		Random randomNumber = new Random();
		Integer[] hundredThousandElements = new Integer[100000];
        Integer[] MillionElements = new Integer[1000000];
        Integer[] tenMillionElements = new Integer[10000000];
        
        long startTime = System.currentTimeMillis();
        for (int j = 0; j < hundredThousandElements.length; ++j) {
        	hundredThousandElements[j] = randomNumber.nextInt(10000000) + 1;
        	
        }
        System.out.println(duplicateSearch(hundredThousandElements, new Compare<Integer>());
        long endTime = System.currentTimeMillis();
        System.out.println("For " + 
        		hundredThousandElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
        
        
        
        startTime = System.currentTimeMillis();
        
        for (int j = 0; j < MillionElements.length; ++j) {
        	MillionElements[j] = randomNumber.nextInt(10000000) + 1;
        }
        
        endTime = System.currentTimeMillis();
        System.out.println("For " + 
        		MillionElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
        
        
        
        startTime = System.currentTimeMillis();
        
        for (int j = 0; j < tenMillionElements.length; ++j) {
        	tenMillionElements[j] = randomNumber.nextInt(10000000) + 1;
        }
        
        endTime = System.currentTimeMillis();
        System.out.println("For " + 
        		tenMillionElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
	}
}
