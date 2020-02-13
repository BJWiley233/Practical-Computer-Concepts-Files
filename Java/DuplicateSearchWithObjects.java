import java.util.Comparator;
import java.util.Random;

/**
 * This project was implemented using Objects. 
 * Code give answers to problems 1 & 2 for Assignment 3.
 * Includes private comparator class used in SequentialSearchWithObjects
 * from class.  Includes duplicateSearch method which modifies
 * sequentialSearch to return duplicate index for which i != j (meaning 
 * don't count the actual index for that being search for duplicate). 
 * Also includes a method to create random String array and method to
 * output Birthday Paradox percentages.
 * 
 * @author Brian Wiley
 * @since 6/18/2019
 *
 */

public class DuplicateSearchWithObjects {

	/*
	 * main class searching for String objects
	 */
    public static void main(String[] args) {
    	// Question 1 
    	final int TIMES_TO_RUN = 100;
    	Random randomNumber = new Random();
    	int timesFoundDuplicate = 0;
        Integer[] tenElements = new Integer[10];
        Integer[] twentyFiveElements = new Integer[25];
        Integer[] fiftyElements = new Integer[50];
        Integer[] seventyFiveElements = new Integer[75];
        Integer[] twentyThreeElements = new Integer[23];  // seeing if close to 50% for 365 numbers
        int i;
        int j;
        
        // ten element array
        for (i = 0; i < TIMES_TO_RUN; ++i) {
        	for (j = 0; j < tenElements.length; ++j) {
            	tenElements[j] = randomNumber.nextInt(1000) + 1;
            }
        	if (duplicateSearch(tenElements, new Compare<Integer>())[0] >= 0) {
        		timesFoundDuplicate += 1;
        	}
        }
        System.out.println("For 10 element array percentage is " +
        		(double)(timesFoundDuplicate)/TIMES_TO_RUN);
        
        // 25 element array
        timesFoundDuplicate = 0;
        for (i = 0; i < TIMES_TO_RUN; ++i) {
        	for (j = 0; j < twentyFiveElements.length; ++j) {
        		twentyFiveElements[j] = randomNumber.nextInt(1000) + 1;
            }
        	if (duplicateSearch(twentyFiveElements, new Compare<Integer>())[0] >= 0) {
        		timesFoundDuplicate += 1;
        	}
        }
        System.out.println("For 25 element array percentage is " + 
        		(double)(timesFoundDuplicate)/TIMES_TO_RUN);
        
        // 50 element array
        timesFoundDuplicate = 0;
        for (i = 0; i < TIMES_TO_RUN; ++i) {
        	for (j = 0; j < fiftyElements.length; ++j) {
        		fiftyElements[j] = randomNumber.nextInt(1000) + 1;
            }
        	if (duplicateSearch(fiftyElements, new Compare<Integer>())[0] >= 0) {
        		timesFoundDuplicate += 1;
        	}
        }
        System.out.println("For 50 element array percentage is " +
        		(double)(timesFoundDuplicate)/TIMES_TO_RUN);
        
        // 75 element array
        timesFoundDuplicate = 0;
        for (i = 0; i < TIMES_TO_RUN; ++i) {
        	for (j = 0; j < seventyFiveElements.length; ++j) {
        		seventyFiveElements[j] = randomNumber.nextInt(1000) + 1;
            }
        	if (duplicateSearch(seventyFiveElements, new Compare<Integer>())[0] >= 0) {
        		timesFoundDuplicate += 1;
        	}
        }
        System.out.println("For 75 element array percentage is " +
        		(double)(timesFoundDuplicate)/TIMES_TO_RUN);
        
        // 50 String element array to test allowing other types of objects
        timesFoundDuplicate = 0;
        for (i = 0; i < TIMES_TO_RUN; ++i) {
        	String[] fiftyStringElements = getStringArray("ABCDEFGHIJ", 3, 50);
        	if (duplicateSearch(fiftyStringElements, new Compare<String>())[0] >= 0) {
        		timesFoundDuplicate += 1;
        	}
        }
        System.out.println("For 50 String element array percentage is " +
        		(double)(timesFoundDuplicate)/TIMES_TO_RUN);
        
        // 23 element array of 365 numbers to mimic birthday percentage
        timesFoundDuplicate = 0;
        System.out.println("");
        for (i = 0; i < TIMES_TO_RUN; ++i) {
        	for (j = 0; j < twentyThreeElements.length; ++j) {
        		twentyThreeElements[j] = randomNumber.nextInt(365) + 1;
            }
        	if (duplicateSearch(twentyThreeElements, new Compare<Integer>())[0] >= 0) {
        		timesFoundDuplicate += 1;
        	}
        }
        System.out.println("For 23 element array of 365 birthdays, percentage is " +
        		(double)(timesFoundDuplicate)/TIMES_TO_RUN);
        // run Birthday paradox
        System.out.println("Probability of group of 1 people is " + birthdayParadox(1));
        System.out.println("Probability of group of 5 people is " + birthdayParadox(5));
        System.out.println("Probability of group of 10 people is " + birthdayParadox(10));
        System.out.println("Probability of group of 20 people is " + birthdayParadox(20));
        System.out.println("Probability of group of 23 people is " + birthdayParadox(23));
        
        System.out.println("\n");
        
        
        // Question 2
        Integer[] hundredThousandElements = new Integer[100000];
        Integer[] MillionElements = new Integer[1000000];
        Integer[] tenMillionElements = new Integer[10000000];
        int[] duplicateIndexes = new int[2]; 
        
        // 100,000 elements. Will also print out the duplicate indexes
        long startTime = System.currentTimeMillis();
        for (j = 0; j < hundredThousandElements.length; ++j) {
        	hundredThousandElements[j] = randomNumber.nextInt(10000000) + 1;
        	
        }
        duplicateIndexes = duplicateSearch(hundredThousandElements, new Compare<Integer>());
        System.out.println("Duplicates for " + hundredThousandElements.length + 
        		" found at indices " + duplicateIndexes[0] + " & " + duplicateIndexes[1]);
        long endTime = System.currentTimeMillis();
        System.out.println("For " + 
        		hundredThousandElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds\n");
        
        // 1,000,000 elements. Will also print out the duplicate indexes
        startTime = System.currentTimeMillis();
        for (j = 0; j < MillionElements.length; ++j) {
        	MillionElements[j] = randomNumber.nextInt(10000000) + 1;
        }
        duplicateIndexes = duplicateSearch(MillionElements, new Compare<Integer>());
        System.out.println("Duplicates for " + MillionElements.length + 
        		" found at indices " + duplicateIndexes[0] + " & " + duplicateIndexes[1]);
        endTime = System.currentTimeMillis();
        System.out.println("For " + 
        		MillionElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds\n");
        
        // 10,000,000 elements. Will also print out the duplicate indexes
        startTime = System.currentTimeMillis();
        for (j = 0; j < tenMillionElements.length; ++j) {
        	tenMillionElements[j] = randomNumber.nextInt(10000000) + 1;
        }
        duplicateIndexes = duplicateSearch(tenMillionElements, new Compare<Integer>());
        System.out.println("Duplicates for " + tenMillionElements.length + 
        		" found at indices " + duplicateIndexes[0] + " & " + duplicateIndexes[1]);
        endTime = System.currentTimeMillis();
        System.out.println("For " + 
        		tenMillionElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds\n");
    }
	
    /**
     * Explicit comparator using the natural sort order. 
     * Extends Comparable for compareTo method and also
     * implements Comparator interface to use its compare
     * method template. The compare method implemented sorts
     * in ascending order.
     */
	private static class Compare<T extends Comparable<T>> 
	implements Comparator<T> {
		public int compare(T o1, T o2) {
		    return o1.compareTo(o2);
		}
	}
	
	/**
	 * method that handles a missing Comparator, uses the
	 * null as Comparator.
	 * 
	 * @param elements array of objects to search
	 * @return positions of value in array which are first duplicates
	 */
	public static <T extends Comparable<T>> int[] duplicateSearch(T[] elements) {
		return(duplicateSearch(elements, null));
	}
	
	/**
	 * Duplicate search for object using Comparable or Comparator. 
	 * Extends Comparable with Generic type to allow for any type 
	 * of object array.
	 * 
	 * @param elements array of objects to search 
	 * @param c comparator to use, null to use natural sort order
	 * @return positions of value in array which are first duplicates
	 */
	public static <T extends Comparable<T>> int[] duplicateSearch(T[] elements, 
            Comparator<T> c) {
		int[] answer = new int[2];
		// search through array
		for (int i = 0; i < elements.length; i++) {
			for (int j = 0; j < elements.length; ++j) {
			// if c is null,  no Comparator, use natural sort order
				if (c == null) {
			        if (elements[i].compareTo(elements[j]) == 0 && i != j) {
			    	    answer[0] = i;
			    	    answer[1] = j;
			        	return answer;
			        }
				}
			// Comparator is used
			    else {
			       	if (c.compare(elements[i], elements[j]) == 0 && i != j) {
			       		answer[0] = i;
			    	    answer[1] = j;
			        	return answer;
			       	}
			    }
			}
	    }
		// item is not found, return {-1, -1}
		answer[0] = -1;
	    answer[1] = -1;
    	return answer;
	}
	
	/**
	 * Create array of random strings
	 * 
	 * @param stringEntry String of characters to choose from 
	 * @param stringLength length of each String in array
	 * @param arraySize number of Strings in array
	 * @return String[] array
	 */
	public static String[] getStringArray(String stringEntry, 
			int stringLength, int arraySize) {
		StringBuilder stringBuild = new StringBuilder(stringLength);
		for (int i = 0; i < stringLength; ++i)
			stringBuild.append('-');
		String[] stringArray = new String[arraySize];
		for (int i = 0; i < stringArray.length; ++i) {
			for (int j = 0; j < stringLength; ++j) {
				int index = (int) (Math.random() * stringEntry.length());
				stringBuild.setCharAt(j, stringEntry.charAt(index));
			}
			stringArray[i] = stringBuild.toString();
		}
		return stringArray;
	}
	
	/**
	 * Function returns probability of duplicate birthdays given
	 * a number of people entry.  Probably better to use the factorial
	 * representation in method: 365! / 365<sup>n</sup>(365 - n)!
	 * 
	 * @param numPeople number of people
	 * @return probability of duplicate birthdays given number of people
	 * @see <a href="https://en.wikipedia.org/wiki/Birthday_problem">
	 * Wikipedia Birthday Paradox</a>
	 */
	public static double birthdayParadox(int numPeople) {
		int daysInYear = 365;
		int firstPeople = 364;
		double noTwoBirthdays = 1.0;
		double duplicateBirthdays;
		
		if (numPeople <= 1) {
			return 0.0;	
		}
		else {
			for (int i = 0; i < (numPeople - 1); ++i) {
				noTwoBirthdays = noTwoBirthdays * (double)(firstPeople)/daysInYear;
				--firstPeople;
			}
		}
		duplicateBirthdays = 1.0 - noTwoBirthdays;
		return Math.round(duplicateBirthdays * 1000) / 1000.0;
	}
}
