import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.StringTokenizer;

import com.chuckkann.datastructures.Stack;
import com.chuckkann.datastructures.utility.stack.ArrayListStack;


/**
 * @author Charles Kann
 *
 * October 1, 2002
 *
 * This project implements a simple postfix calculator.
 */
public class PostFixCalculator {

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

    public static double evaluateExpression(String expression)
            throws InvalidOperatorException {

        Stack<Double> operands = new ArrayListStack<Double>();

 		StringTokenizer st = new StringTokenizer(expression,"+-()*/ \t",true);

		while(st.hasMoreTokens()){ //if tokenizer has token continue through loop until none when while becomes false and exits loop
			String token = st.nextToken();
			
			if (token.equals(" ") || token.equals("\t"));   //remove blank space and tabs from string
            
			else if (!Operator.isOperator(token)){ //If token is an operand put it on the stack
                operands.push(Double.parseDouble(token));
            }
            else {  // It if an operator, so process it.
                Operator op = Operator.getOperator(token);
                double d2 = operands.pop();
                double d1 = operands.pop();
                operands.push(op.doCalc(d1,d2));
            }
         }

        // return the result, the only thing left on the stack.
        return operands.pop();
    }
}
