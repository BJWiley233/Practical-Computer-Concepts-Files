import java.util.HashMap;
import java.io.IOException;

public class HashMap4  {

public static void main(String[] args) throws IOException {


HashMap<String, Integer> statePopulation = new HashMap<String, Integer>();

// 2013 population data from census.gov
statePopulation.put("CA", 38332521);
statePopulation.put("AZ", 6626624);
statePopulation.put("MA", 6692824);
      
//System.out.print("Population of Arizona in 2013 is ");
System.out.print(statePopulation.get("AZ"));

return;
}
}

