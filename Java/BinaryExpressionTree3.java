import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.StringTokenizer;

import com.chuckkann.datastructures.Stack;
import com.chuckkann.datastructures.utility.stack.ArrayListStack;


/**
 * @author Charles Kann
 *
 * October 1, 2002
 *
 * This project creates a Binary Expression Tree from an infix equation
 */

public class BinaryExpressionTree3 {

    public static void main(String args[]) {
        try {

            // Set up the Buffered reader to read a line.
            System.out.println("Enter Expression To Calculate");
            BufferedReader br =
                new BufferedReader(new InputStreamReader(System.in));

            // call evaluateExpression to evaluate this expression and print the answer.
			Node root = evaluateExpression(br.readLine());
/*
			System.out.println("Pre-Order is: " + root.preOrder());
			System.out.println("In-Order is: " + root.inOrder());
			System.out.println("Post-Order is: " + root.postOrder());
*/
			BinaryTreePrinter.printNode((OperatorNode) root);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    

    public static Node evaluateExpression(String expression)
            throws InvalidOperatorException {
        Stack<Node> operands = new ArrayListStack<Node>();
		Stack<Operator> operators = new ArrayListStack<Operator>();

        StringTokenizer st = new StringTokenizer(expression, "+-/*() \t", true);

        while(st.hasMoreTokens()) {
    		String token = st.nextToken();
			
			if (token.equals(" ") || token.equals("\t"));   //remove blank space and tabs from string
			
			// push operands onto stack, does not check if operand is a number however "f+5" 
			// will result in error.  this is where the GUI comes in since JTextfield is not editable
			// also need to pop off the 0.0 if a number is entered like real calculate, for example 
			// user enter "5"
			else if (!Operator.isOperator(token)) {
				operands.push(new OperatorNode(token, null, null));
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
					Node d2 = operands.pop();
					Node d1 = operands.pop();
					OperatorNode newOpNode = new OperatorNode(op, d1, d2);
	                operands.push(newOpNode);
				}
				// Again only peek and pop if there is a start brace
				// in case user forgets to add start brace
				if(!operators.isEmpty() && operators.peek().isStartBrace())
					operators.pop(); // pop the matching start brace
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
					Node d2 = operands.pop();
					Node d1 = operands.pop();
					OperatorNode newOpNode = new OperatorNode(op, d1, d2);
	                operands.push(newOpNode);  
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
				Node d2 = operands.pop();
				Node d1 = operands.pop();
				OperatorNode newOpNode = new OperatorNode(op, d1, d2);
                operands.push(newOpNode); 
			}
			else {
				operators.pop();
			}
	    }
		
		// This will work now even if user makes no entry because we push 0.0
		// at the beginning or if user only enters 1 number such as "666.5"
		return operands.peek();
    }

	private static interface Node extends Comparable<Node> {
		public String preOrder();
		public String inOrder();
		public String postOrder();
	    public String generate0MachineCode();
	}
	
	private static class OperandNode implements Node {
		
		Node left = null;
		Node right = null;
	    private String operand;
	     
	    public OperandNode(String operand, Node left, Node right) {
	        this.operand = operand;
	        this.left = left;
	        this.right = right;
	    }

	    public String generate0MachineCode() {
	        // You need to fill this method in.
	    	return null;
	    }

		public String preOrder() {
		    return operand;
		}
		
		public String inOrder() {
		    return operand;
		}
		
		public String postOrder() {
		    return operand;
		}
		
	    public String toString() {
	      return operand;
	    }

		public int compareTo(Node n) {
			return (n.toString().compareTo(this.toString()));
		}
	}

	private static class OperatorNode implements Node {
	    Node left, right;
	    Operator operator;
	    String operand;
	
	   public OperatorNode(Operator operator, Node left, Node right)
	            throws InvalidOperatorException {
	        this.operator = operator;
	        this.left = left;
	        this.right = right;
	    }
	   
	   public OperatorNode(String operand, Node left, Node right)
	            throws InvalidOperatorException {
	        this.operand = operand;
	        this.left = left;
	        this.right = right;
	    }
	
	    public String generate0MachineCode() {
	      // You must fill in this method
	    	return null;
	    }
	    
	    
		
		public String preOrder() {
		    return operand.toString();
			/*
			return(" " + operand.toString() + " " +
		           left.preOrder() + " " +  
		    	   right.preOrder() + " " + operand.toString());
		    	   */ 		    
		}
		
		public String inOrder() {
		    return("(" + left.inOrder() + " " +
		    	   operator.toString() + " " +  
		    	   right.inOrder() + ")" ); 
		}
		
		public String postOrder() {
		    return(" " + left.postOrder() + " " +
		          right.postOrder() + " " + 
		    	  operator.toString() + " ");
		}
	
		@Override
		public int compareTo(Node n) {
			// TODO Auto-generated method stub
			return (this.toString().compareTo(n.toString()));
		}
	}
	
	private static class BinaryTreePrinter {
		public static void printNode(Node root) {
			int maxLevel = BinaryTreePrinter.maxLevel(root);
			System.out.println("Max Level should be three: " + maxLevel);
			printNodeInternal(Collections.singletonList(root), 1, maxLevel);
		}
		
		private static void printNodeInternal(List<Node> nodes, int level, int maxLevel) {
			if (nodes.isEmpty() || BinaryTreePrinter.isAllElementsNull(nodes))
				return;
			
			int floor = maxLevel - level;  // maxLevel here is the call to the maxLevel function of the 
										   // root operator.  It calls recursively to each left and right node.
										   // If there is only an operator for instance "+", then it calls 
										   // one time because maxLevel((OperatorNode) node.left) is null and
										   // and returns 0 as well as maxLevel((OperatorNode) node.left).
										   // So it will return Max(0, 0) + 1 which is just 1.  For every level
										   // the recursive call just adds 1.  Most important part of printing tree!

			
			int edgeLines = (int) Math.pow(2, (Math.max(floor - 1, 0)));  // pow(2, 3-1) = 4
			int firstSpaces = (int) Math.pow(2, floor) - 1;  //
			int betweenSpaces = (int) Math.pow(2, (floor + 1)) - 1;

			BinaryTreePrinter.printWhitespaces(firstSpaces);
			
			List<Node> newNodes = new ArrayList<Node>();
			for (Node node: nodes) {
				if (node != null) {
					if(node instanceof OperandNode) {
						System.out.print(((OperandNode)node).operand);
						newNodes.add(((OperandNode)node).left);
						newNodes.add(((OperandNode)node).right);
					}
					else {
						System.out.print(((OperatorNode)node).operand);
						newNodes.add(((OperatorNode)node).left);
						newNodes.add(((OperatorNode)node).right);
					}
				}
				else {
					newNodes.add(null);
					newNodes.add(null);
					System.out.print(" ");
				}
				
				BinaryTreePrinter.printWhitespaces(betweenSpaces);
			}
			
			System.out.println();

			for (int i = 1; i <= edgeLines; ++i) {
				for (int j = 0; j < nodes.size(); ++j) {
					BinaryTreePrinter.printWhitespaces(firstSpaces - i);
					if (nodes.get(j) == null) {
						BinaryTreePrinter.printWhitespaces(edgeLines + edgeLines + i + 1);
	                    continue;
					}
					
					if(nodes.get(j) instanceof OperandNode) {
						if (((OperandNode)nodes.get(j)).left != null)
							System.out.print("/");
						else 
							BinaryTreePrinter.printWhitespaces(1);
					}
					else {
						if (((OperatorNode)nodes.get(j)).left != null)
							System.out.print("/");
						else 
							BinaryTreePrinter.printWhitespaces(1);
					}
					BinaryTreePrinter.printWhitespaces(i + i - 1);
					
					if(nodes.get(j) instanceof OperandNode) {
						if (((OperandNode)nodes.get(j)).right != null)
							System.out.print("\\");
						else 
							BinaryTreePrinter.printWhitespaces(1);
					}
					else {
						if (((OperatorNode)nodes.get(j)).right != null)
							System.out.print("\\");
						else 
							BinaryTreePrinter.printWhitespaces(1);
					}
					
					BinaryTreePrinter.printWhitespaces(edgeLines + edgeLines - i);
				}
				
				System.out.println();
			}
			
			printNodeInternal(newNodes, level + 1, maxLevel);
		}
		
		
		private static void printWhitespaces(int count) {
	        for (int i = 0; i < count; i++)
	            System.out.print(" ");
	    }
		
		private static int maxLevel(Node node) {
			if (node == null)
				return 0;

			if (node instanceof OperandNode) {
				return Math.max(BinaryTreePrinter.maxLevel(((OperandNode)node).left), BinaryTreePrinter.maxLevel(((OperandNode)node).right)) + 1;
			}
			else {
				return Math.max(BinaryTreePrinter.maxLevel(((OperatorNode)node).left), BinaryTreePrinter.maxLevel(((OperatorNode)node).right)) + 1;
			}
		}
		
		private static boolean isAllElementsNull (List<Node> list) {
			for (Object object : list) {
				if (object != null)
					return false;
			}
			
			return true;
		}
	}
}



    

