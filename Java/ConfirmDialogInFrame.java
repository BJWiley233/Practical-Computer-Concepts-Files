import java.awt.Color;
import java.awt.Dimension;
import java.awt.Image;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.ImageIcon;

/**
 * A JOptionPane showMessageDialog example that shows
 * how to display a component (JComponent) in a 
 * JOptionPane dialog.
 */
public class ConfirmDialogInFrame extends JFrame
{

   public ConfirmDialogInFrame()
   {
   getContentPane().setBackground(Color.BLUE);
   setTitle("JOptionPane showConfirmDialog component example");
   setSize(600, 600);
   setVisible(true);
   setResizable(false);
   getContentPane().setLayout(null);
   setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
   }
   
   public static void main(String[] args)
   {
    // create a simple jpanel
    
   ImageIcon icon = new ImageIcon("turtle.jpg");
    
   JPanel panel = new JPanel();
   panel.setBackground(Color.BLUE);
   panel.setMinimumSize(new Dimension(400,300));
    
   // display the jpanel in a joptionpane dialog, using showMessageDialog
   
   ConfirmDialogInFrame f = new ConfirmDialogInFrame(); 
   int result = JOptionPane.showConfirmDialog(f, 
                                              "I appear as part of frame", "Brian", 
                                              JOptionPane.YES_NO_CANCEL_OPTION, 
                                               icon); //JOptionPane.PLAIN_MESSAGE,
 /*JOptionPane.showMessageDialog(null, "I like turtles.", 
                "Customized Dialog", JOptionPane.INFORMATION_MESSAGE, icon);*/
   System.out.println(result);
   f.dispose();
   
   }
}