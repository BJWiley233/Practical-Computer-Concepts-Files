import java.io.BufferedReader;
import java.io.InputStreamReader;
import com.chuckkann.datastructures.Stack;
import com.chuckkann.datastructures.utility.stack.ArrayListStack;

import java.util.StringTokenizer;

/**
 * @author Charles Kann, Brian Wiley
 *
 * October 1, 2002
 *
 * This project implements a simple stack calculator.  Uses both
 * an operator stack and operand stack with the  ArrayListStack
 * class that implements the Stack interface
 */

public class InfixCalculator {

    public static void main(String args[]) {
        try {

            // Set up the Buffered reader to read a line.
            System.out.println("Enter Expression To Calculate");
            BufferedReader br =
                new BufferedReader(new InputStreamReader(System.in));

            // call evaluateExpression to evaluate this expression and print the answer.
            System.out.println("ans = " + evaluateExpression(br.readLine()));
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @author bjwil
     * 
     * @param expression String to tokenize for stack
     * @return {@code double} will be the last operand on the stack; {@code 0.0}
     * 		   if nothing is entered
     */
    public static double evaluateExpression(String expression)
            throws InvalidOperatorException {

        //Declare an operators and operand stack.
    	Stack<Double> operands = new ArrayListStack<Double>();
    	Stack<Operator> operators = new ArrayListStack<Operator>();
    	
    	// push 0.0 onto Stack in case no numbers/operands are given by user
    	operands.push(0.0);
    	
        // Process each token
    	StringTokenizer st = new StringTokenizer(expression,"+-()*/ \t", true);
    	
    	while(st.hasMoreTokens()) {
    		String token = st.nextToken();
			
			if (token.equals(" ") || token.equals("\t"));   //remove blank space and tabs from string
			
			// push operands onto stack, does not check if operand is a number however "f+5" 
			// will result in error.  this is where the GUI comes in since JTextfield is not editable
			// also need to pop off the 0.0 if a number is entered like real calculate, for example 
			// user enter "5"
			else if (!Operator.isOperator(token)) {
				operands.push(Double.parseDouble(token));
			}
			
			else if (Operator.getOperator(token).isStartBrace()) { //push start brace to operator stack
					operators.push(Operator.getOperator(token));
			}
			
			// handle end brace to matching start brace
			else if (Operator.getOperator(token).isEndBrace()) {
				// I added a check if operators are empty before peek if
				// for instance user enters "66/3)" or "65+43) * (2-3)"
				// and forgets the start brace
				while (!operators.isEmpty() &&
					   !operators.peek().isStartBrace()) {  // and top is not matching parens pop stack
					Operator op = operators.pop();
	                double d2 = operands.pop();
	                double d1 = operands.pop();
	                operands.push(op.doCalc(d1,d2));
				}
				// Again only peek and pop if there is a start brace
				// in case user forgets to add start brace
				if(!operators.isEmpty() && operators.peek().isStartBrace())
					operators.pop(); // pop the start brace
			}
	
			else { 
				// Any other operator, check precedence
				// If there is operator existing on the stack check the precedence level
				// and if the top operator on stack has higher precedence perform pop
				// on that operator, pop the previous two operands and push the doCalc 
				// to top of operands stack.  
				// Operand stack size must also be at least 2 in order to pop two operands
				// for example user enters "++++5" stop at calculation of last 2 operands
				while (!operators.isEmpty() && 
                        operators.peek().getPrecedenceLevel() >= Operator.getOperator(token).getPrecedenceLevel() &&
                        operands.size() >= 2) {
						Operator op = operators.pop();
		                double d2 = operands.pop();
		                double d1 = operands.pop();
		                operands.push(op.doCalc(d1,d2));  
				}
				// If there is no operator yet where !operators.isEmpty() is false
				// for instance user enters "+55-3" takes care of first operator push.
				// Also if precedence of top operator is not greater than we push
				// the greater precedence on top so it gets the doCalc first when
				// popping from top of stack
				operators.push(Operator.getOperator(token));
			}
    	}
        

    	// After tokens finished clean up and finish last operators on stack
    	// operand stack size must also be at least 2 in order to pop two operands.
		// I added check if Operator has an evaluator because for example user 
    	// enters "((((5" or "((((5+2) where they forget to complete correct closing
    	// brace we do not want to do a doCalc with the brace(s) as it will fail.
    	// This works if user also enter "77((*2" or "5+5+(((5" because we pop off
    	// extra start braces that do not have matching end braces.
    	// ** Please note I added new method to Operator class: operatorHasEvaluator(Operator op)
		while(!operators.isEmpty() && operands.size() >= 2) {
			if(Operator.operatorHasEvaluator(operators.peek())) {
				Operator op = operators.pop();
	            double d2 = operands.pop();
	            double d1 = operands.pop();
	            operands.push(op.doCalc(d1,d2));
			}
			else {
				operators.pop();
			}
	    }
		
		// This will work now even if user makes no entry because we push 0.0
		// at the beginning or if user only enters 1 number such as "666.5"
		return operands.peek();
    }
}
    
