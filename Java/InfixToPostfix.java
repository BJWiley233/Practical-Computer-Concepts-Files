
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.StringTokenizer;

import com.chuckkann.datastructures.Stack;
import com.chuckkann.datastructures.utility.stack.ArrayListStack;


public class InfixToPostfix {

	public static void main(String args[]) {
		try {

			// Set up the Buffered reader to read a line.
			System.out.println("Enter Infix notation to convert to Postfix notation");
			BufferedReader br =
					new BufferedReader(new InputStreamReader(System.in));

			// Return postfix notation
			System.out.println("Postfix notation is "+ translate(br.readLine()));
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static String translate(String infix)  
			throws InvalidOperatorException{ 

		String postfix = "";
		Stack<Operator> operators = new ArrayListStack<Operator>();
		StringTokenizer st = new StringTokenizer(infix,"+-()*/ \t",true);

		while(st.hasMoreTokens()) { //if tokenizer has token continue through loop until none when while becomes false and exits loop
			String token = st.nextToken();
			
			if (token.equals(" ") || token.equals("\t")); //remove blank space and tabs from string

			else if (!Operator.isOperator(token)){ //If token is an operand put it on string
				postfix+=token;
				postfix+=" ";
			}
			
   	        else if(Operator.getOperator(token).isStartBrace()){
					operators.push(Operator.getOperator(token));
			}
 			else if (Operator.getOperator(token).isEndBrace()){		
					while (!operators.peek().isStartBrace()) // and top is not matching parens pop stack
					{
						postfix+= operators.pop(); 
						postfix+=" ";
					}
					operators.pop(); //otherwise it is a matching parens and pop stack but do not add to string
			}
			else { // Any other operator, check precedence
				while (!operators.isEmpty() && 
                        operators.peek().getPrecedenceLevel() >= Operator.getOperator(token).getPrecedenceLevel()){
						postfix+= operators.pop(); //pop operator with greater precedence and push operator on to stack.  Popped operator added to string.
						postfix+=" ";
				}	 
				operators.push(Operator.getOperator(token)); //if precedence of Operators is greater than stack push to the stack
				
			}
			
		}	

		while(!operators.isEmpty()){ //Finished with tokens and still some left on stack, pop remaining operators
			postfix += operators.pop();

	    }

		return postfix;
  }
}
