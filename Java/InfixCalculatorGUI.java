import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import com.chuckkann.datastructures.Stack;
import com.chuckkann.datastructures.utility.stack.ArrayListStack;
import java.util.StringTokenizer;

import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;

/**
 * @author bjwil
 *
 * @since 7/19/2019
 *
 * This project implements a simple stack calculator as a GUI.
 */
public class InfixCalculatorGUI<T extends Comparable<T>> extends JFrame {
	
	private static final long serialVersionUID = 1L;
	
	private static final String[][] BUTTON_TEXTS = {
			  {"(", ")", "C"},
		      {"7", "8", "9"},
		      {"4", "5", "6"},
		      {"1", "2", "3"},
		      {".", "0", "<="}
	};
	
	private static final String[][] OP_BUTTON_TEXTS = {
			  {"+"},
		      {"-"},
		      {"*"},
		      {"/"},
		      {"="}
	};
	private static final Font BTN_FONT = new Font(Font.SANS_SERIF, Font.BOLD, 12);
	private static Color bg = new Color(0, 204, 0);
	private static boolean equalEntered = false;
	
	public InfixCalculatorGUI() {
		
		super("Infix Calculator");
	}
	
		
	@SuppressWarnings("unchecked")
	public static <T extends Comparable<T>> void displayGUI() {	

		JPanel calcGui = new JPanel();
		calcGui.setLayout(new BoxLayout(calcGui, BoxLayout.Y_AXIS));
		
		JPanel postFixPanel = new JPanel();
		postFixPanel.setLayout(new BoxLayout(postFixPanel, BoxLayout.X_AXIS));
		
		JPanel postFixLabelPanel = new JPanel();
		JLabel postFixLabel = new JLabel("PostFix:", JLabel.LEFT);
		postFixLabelPanel.add(postFixLabel);
		postFixLabelPanel.setBackground(bg);
		
		JPanel postFixFieldPanel = new JPanel();
		JTextField postFixField = new JTextField(20);
		postFixField.setHorizontalAlignment(SwingConstants.RIGHT);
		postFixField.setEditable(false);
		postFixFieldPanel.add(postFixField);
		postFixFieldPanel.setBackground(bg);
		
		postFixPanel.add(postFixLabelPanel);
		postFixPanel.add(postFixFieldPanel);

		
		JPanel infixPanel = new JPanel();
		infixPanel.setLayout(new FlowLayout(FlowLayout.RIGHT, 0, 0));
		
		JPanel infixFieldPanel = new JPanel();
		JTextField inFixField = new JTextField(20);
		inFixField.setBackground(Color.WHITE);
		inFixField.setHorizontalAlignment(SwingConstants.RIGHT);
		inFixField.setEditable(false);
		infixFieldPanel.add(inFixField);
		infixFieldPanel.setBackground(bg);
		
		infixPanel.add(infixFieldPanel);
		infixPanel.setBackground(bg);
		
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new BoxLayout(buttonPanel, BoxLayout.X_AXIS));
		
		JPanel buttonPanelNumbers = new JPanel();
		buttonPanelNumbers.setLayout(new GridLayout(BUTTON_TEXTS.length, BUTTON_TEXTS[0].length, 1, 1));
		buttonPanelNumbers.setBackground(bg);
		for (int i = 0; i < BUTTON_TEXTS.length; ++i) {
			for (int j = 0; j < BUTTON_TEXTS[0].length; ++j) {
				JButton btn = new JButton(BUTTON_TEXTS[i][j]);
				btn.setPreferredSize(new Dimension(34, 30));
				btn.setMargin(new Insets(0, 0, 0, 0));
				btn.setFont(BTN_FONT);
				btn.setBackground(bg);
				buttonPanelNumbers.add(btn);
				if (BUTTON_TEXTS[i][j].compareTo("C") == 0) {
					btn.addActionListener(new ActionListener() {
						
						@Override
						public void actionPerformed(ActionEvent ae) {
							inFixField.setText("");
						}
					});
				}
				// Wanted to test casting for using Comparable
				// For Strings is easier to just use String.compareTo
				else if (((T) BUTTON_TEXTS[i][j]).compareTo((T) "<=") == 0) {
						btn.addActionListener(new ActionListener() {
						
						@Override
						public void actionPerformed(ActionEvent ae) {
							String str = inFixField.getText();
							if ((str != null) && (str.length() > 0))
								inFixField.setText(str.substring(0, str.length() - 1));
						}
					});
				}
				else {
					btn.addActionListener(new ActionListener() {
						
						@Override
						public void actionPerformed(ActionEvent ae) {
							JButton but = (JButton) ae.getSource();
							if (equalEntered) {
								inFixField.setText(but.getActionCommand());
								equalEntered = false;
							}
							else {
								inFixField.setText(inFixField.getText() + but.getActionCommand());
							}
						}
					});
				}
			}
		}
		
		JPanel buttonPanelOperators = new JPanel();
		buttonPanelOperators.setLayout(new GridLayout(OP_BUTTON_TEXTS.length, OP_BUTTON_TEXTS[0].length, 1, 1));
		buttonPanelOperators.setBackground(bg);
		for (int i = 0; i < OP_BUTTON_TEXTS.length; ++i) {
			for (int j = 0; j < OP_BUTTON_TEXTS[0].length; ++j) {
				JButton opBtn = new JButton(OP_BUTTON_TEXTS[i][j]);
				opBtn.setPreferredSize(new Dimension(10, 30));
				opBtn.setMargin(new Insets(0, 0, 0, 0));
				opBtn.setFont(BTN_FONT);
				opBtn.setBackground(bg);
				buttonPanelOperators.add(opBtn);
				if (OP_BUTTON_TEXTS[i][j].compareTo("=") != 0) {
					opBtn.addActionListener(new ActionListener() {
						
						@Override
						public void actionPerformed(ActionEvent ae) {
							JButton but = (JButton) ae.getSource();
							if (equalEntered) {
								inFixField.setText(inFixField.getText() + but.getActionCommand());
								equalEntered = false;
							}
							else {
								inFixField.setText(inFixField.getText() + but.getActionCommand());
							}
						}
					});
				}
				else {
					opBtn.addActionListener(new ActionListener() {
						@Override
						public void actionPerformed(ActionEvent ae) {
							try {
								postFixField.setText(translate(inFixField.getText()));
								inFixField.setText(String.valueOf(evaluateExpression(inFixField.getText())));
								equalEntered = true;
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					});
				}
			}
		}
		
		buttonPanel.add(Box.createRigidArea(new Dimension(60, 0)));
		buttonPanel.add(buttonPanelNumbers);
		buttonPanel.add(Box.createRigidArea(new Dimension(30, 0)));
		buttonPanel.add(buttonPanelOperators);
		buttonPanel.add(Box.createRigidArea(new Dimension(5, 0)));
		buttonPanel.setBackground(bg);
		
		calcGui.add(postFixPanel);
		calcGui.add(infixPanel);
		calcGui.add(Box.createRigidArea(new Dimension(0, 10)));
		calcGui.add(buttonPanel);
		calcGui.add(Box.createRigidArea(new Dimension(0, 10)));
		calcGui.setBackground(bg);
		
		JFrame calcFrame = new JFrame("Infix Calculator");
		calcFrame.setSize(300, 400);
		calcFrame.getContentPane().add(calcGui, BorderLayout.WEST);
		calcFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		calcFrame.setResizable(false);
		//calcFrame.setBackground(Color.GREEN);
		
		calcFrame.pack();
		calcFrame.setLocationByPlatform(true);
		calcFrame.setVisible(true);
	}

    public static void main(String args[]) {
    	
    	javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
            	displayGUI();
            }
        });
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
    
    /**
     * 
     */
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
					while (!operators.isEmpty() &&
						   !operators.peek().isStartBrace()) // and top is not matching parens pop stack
					{
						postfix+= operators.pop(); 
						postfix+=" ";
					}
					if(!operators.isEmpty() && operators.peek().isStartBrace())
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

		while(!operators.isEmpty() && 
			  Operator.operatorHasEvaluator(operators.peek())){ //Finished with tokens and still some left on stack, pop remaining operators
			postfix += operators.pop();

	    }

		return postfix;
  }
    
}
    
