import java.util.Hashtable;

/**
 * @author Charles Kann
 *
 * October 1, 2002
 * 
 * This class provides all the methods and data needed to 
 * process an operator.
 */
public class Operator implements Comparable<Operator> {

    // Static section of the class.  We initialize
    // the hash map of operators in a static constructor.  Note
    // that to add new operators (as long as they aren't 
    // braces) all that needs to be done is change this table.
    // All other methods work off of data defined here.
    private static Hashtable<String, Operator> validOperators;

    static {
        validOperators = new Hashtable<String, Operator>();
        validOperators.put("+", new Operator("+", 1, new AddEvaluator()));
        validOperators.put("-", new Operator("-", 1, new SubEvaluator()));
        validOperators.put("*", new Operator("*", 2, new MulEvaluator()));
        validOperators.put("/", new Operator("/", 2, new DivEvaluator()));
        validOperators.put("(", new Operator("(", 0, null));
        validOperators.put(")", new Operator(")", 0, null));

    }
    
    Evaluator evaluator;

    /**
     *  Static method to check if the string is a valid operator.
     */
    public static boolean isOperator(String s) {
        return validOperators.containsKey(s);
    }
    
    /**
     *  Static method to check if the Operator has a valid Evaluator.
     *  This is needed so that we only do doCalc() on something that is
     *  an operator with an Evaluator.  We cannot do doCalc() on braces.
     */
    public static boolean operatorHasEvaluator(Operator op) {
        return (op.evaluator != null);
    }

    // Data for every operator
    private String operator;
    private int precedenceLevel;
    // that can evaluate the operator.
    // Evaluators are defined below.

    /**
     * Private constuctor, used in the static constructor to 
     * create the valid operators.  Note that a user of the
     * class should never use this constructor, but use the
     * public one.	
     */
    private Operator(String s, int precedenceLevel, Evaluator evaluator) {
        this.operator = s;
        this.precedenceLevel = precedenceLevel;
        this.evaluator = evaluator;
    }

    /**
     *  Factory pattern
     */
    public static Operator getOperator(String s)
             throws InvalidOperatorException {
        Operator op = (Operator) validOperators.get(s);
        if (op == null) {
            throw new InvalidOperatorException(s + " Is not a valid operator");
        }
        return op;
    }

    /**
     *  Get the precedence level from operator
     */
    public int getPrecedenceLevel() {
        return precedenceLevel;
    }

    /**
     *  Do the calculation for the operator
     */
    public double doCalc(double x, double y) {
        return evaluator.doCalc(x, y);	
    }

    /**
     * Check if a start brace
     */
    public boolean isStartBrace() {
    	if (this.operator == "(")
    		return true;
    	else
    		return false;
    }

    /**
     * Check if a end brace
     */
    public boolean isEndBrace() {
    	if (this.operator == ")")
    		return true;
    	else
    		return false;
    }

    
    /**
     * 
     */
    public int compareTo(Operator o) {
    	return 0;
    }

    public String toString() {
       return operator;
    }
    
    private interface Evaluator {
    	public double doCalc(double x, double y);
    }
    
    private static class AddEvaluator implements Evaluator {
        public double doCalc(double d1, double d2) {
            return d1 + d2;
        }
    }

    private static class MulEvaluator implements Evaluator {
        public double doCalc(double d1, double d2) {
            return d1 * d2;
        }
    }

    private static class SubEvaluator implements Evaluator {
        public double doCalc(double d1, double d2) {
            return d1 - d2;
        }
    }

    private static class DivEvaluator implements Evaluator {
        public double doCalc(double d1, double d2) {
            return d1 / d2;
        }
    }
}


