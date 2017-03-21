import java.io.*;
import java.util.*;
/**
 *Program for generating llvm code from mathematical expressions.
 * @author Recep Deniz Aksoy
 *
 */
public class stm2ir {
	public static BufferedWriter w;
	/**
	 * Class for containers that contains values, numbers or registers.
	 *
	 */
	public static class Container{
		public String name = "";
		public int val = 0;
		public  String reg = "";
		public  boolean number = false;
		public Container(String name_, int val_, String reg_,boolean number_){
			name = name_;
			val = val_;
			reg = reg_;
			number = number_;
		}
		public Container(){}
	}
	
	public static ArrayList<Container> variables = new ArrayList<Container>();
	public static int counter = 0;
	public static int linee = 0;
	/**Determines the priority of the operation.
	 * @param c Is the character.
	 * @return Priority of the character.
	 */
	public static int pri(String c){
		if (c.equals("*") || c.equals("/"))
			return 1;
		else if (c.equals("+") || c.equals("-"))
			return 2;	
		else
			return 3;
	}
	/**Takes infix string array and returns postfix string arraylist.
	 * @param str String that is going evaluated to postfix notation
	 * @return Postfix notation
	 */
	public static ArrayList<String> infToPos(String[] str){
		ArrayList<String> res = new ArrayList<>();
		Stack<String> stk = new Stack<>();
		for (int i = 0; i < str.length; i++) {
			if (str[i].equals("+") || str[i].equals("-") || str[i].equals("*") || str[i].equals("/")) {
				while(!stk.isEmpty() && pri(stk.peek()) <= pri(str[i])){
					res.add(stk.pop());
				}
				stk.push(str[i]);
			}
			else if(str[i].equals("(")){
				stk.push(str[i]);
			}
			else if(str[i].equals(")")){
				while(!stk.peek().equals("(")){
					res.add(stk.pop());
				}
				stk.pop();
			}
			else{
				res.add(str[i]);
			}
		}
		while(!stk.isEmpty()){
			res.add(stk.pop());
		}
		return res;
	}
	/**Finds container object that matches the string
	 * @param s Name of the (or number) variable.
	 * @return variable as Container object.
	 * @throws IOException if variable is undefined.
	 */
	public static Container findC(String s) throws IOException{
		try {
		if(!isNumber(s)){
				for (int i = 0; i < variables.size(); i++) {
					String ss = variables.get(i).name;
					if(s.equals(ss)){
						return variables.get(i);
					}
				}
		}
		Container x = new Container("number", Integer.parseInt(s),  s, true);
		return x;
		} catch (Exception e) {
			File fout = new File("file.ll");
			FileOutputStream fos = new FileOutputStream(fout);
			w = new BufferedWriter(new OutputStreamWriter(fos));			
			System.out.println("Error: Line "+linee+": undefined variable " + s+ "\n");
			w.flush();
			w.close();
			System.exit(1);
			return null;
		}
	}
	/**
	 * Determines whether given string is a sign or not.
	 * @param s string object
	 * @return true if it's a sign.
	 */
	public static boolean isSign(String s){
		if(s.equals("+") || s.equals("-") || s.equals("/") || s.equals("*")){
			return true;
		}
		else{
			return false;
		}		
	}

	public static boolean isNumber(String s){
		for (int i = 0; i < s.length(); i++) {
			if(s.matches("^-?\\d+$")){
				return true;
			}
		}
		return false;
	}
	/**
	 * Evaluates the expression, writes the llvm line.
	 * @param exp Expression arraylist line.
	 * @return returns evaluated register.
	 * @throws IOException if file does not exist.
	 */
	public static Container evaluate(ArrayList<String> exp) throws IOException{
		if(exp.size() == 1){
			Container x = findC(exp.get(0));
			counter++;
			if(x.number){
				w.write("%" + counter + " = load i32* " + x.val+ "\n");
			}else{w.write("%" + counter + " = load i32* %" + x.name+ "\n");}
		}
		ArrayList<String> names = new ArrayList<String>();
		Stack<Container> stk = new Stack<>();
		for (int i = 0; i < exp.size(); i++) {
			if(!isSign(exp.get(i))){
				stk.push(findC(exp.get(i)));
			}
			else{
				String oper = exp.get(i);
				Container first = stk.pop();
				if(!first.number && !names.contains(first.name)){
					counter++;
					w.write("%" + counter + " = load i32* %" + first.name+ "\n");
					first.reg = "" + counter;
					names.add(first.name);
				}
				Container second = stk.pop();
				if(!second.number && !names.contains(second.name)){
					counter++;
					w.write("%" + counter + " = load i32* %" + second.name+ "\n");
					second.reg = "" + counter;
					names.add(second.name);
				}
				counter++;	
				if(oper.equals("+")){
					String name = "" + counter;
					Container result = new Container("register", 888, name, true);
					stk.push(result);
					String message = "%" + result.reg + " = add i32 ";
					message = first.number  && !first.name.equals("register")? message + first.reg : message + "%" + first.reg;
					message = message + ",";
					message = second.number  && !second.name.equals("register") ? message + second.reg : message + "%" + second.reg;
					w.write(message+ "\n");
				 }
				else if(oper.equals("*")){
					String name = "" + counter;
					Container result = new Container("register", 888, name, true);
					stk.push(result);
					String message = "%" + result.reg + " = mul i32 ";
					message = first.number && !first.name.equals("register")? message + first.reg : message + "%" + first.reg;
					message = message + ",";
					message = second.number  && !second.name.equals("register") ? message + second.reg : message + "%" + second.reg;
					w.write(message+ "\n");
				 }
				else if(oper.equals("/")){
					String name = "" + counter;
					Container result = new Container("register",888, name, true);
					stk.push(result);
					String message = "%" + result.reg + " = sdiv i32 ";
					message = second.number  && !second.name.equals("register") ? message + second.reg : message + "%" + second.reg;
					message = message + ",";
					message = first.number  && !first.name.equals("register")? message + first.reg : message + "%" + first.reg;
					w.write(message+ "\n");
				 }
				else if(oper.equals("-")){
					String name = "" + counter;
					Container result = new Container("register", 888, name, true);
					stk.push(result);
					String message = "%" + result.reg + " = sub i32 ";
					message = second.number  && !second.name.equals("register")? message + second.reg : message + "%" + second.reg;
					message = message + ",";
					message = first.number && !first.name.equals("register") ? message + first.reg : message + "%" + first.reg;
					w.write(message+ "\n");
				 }
			}
		}
		return stk.pop();
	}
	/**
	 * Determines whether variables arraylist contains given variable.
	 * @param x Variable name.
	 * @return true if variable is in the variables arraylist.
	 */
	public static boolean ContainsVar(String x){
		for (int i = 0; i < variables.size(); i++) {
			if(variables.get(i).name.equals(x)){
				return true;
			}
		}
		return false;
	}
	/**
	 * 
	 * @param args input and output file.
	 * @throws IOException if output file is corrupted.
	 */
	public static void main(String[] args) throws IOException {
		File fout = new File("file.ll");
		FileOutputStream fos = new FileOutputStream(fout);
		w = new BufferedWriter(new OutputStreamWriter(fos));
		//System.setOut(new PrintStream(new BufferedOutputStream(new FileOutputStream("file.ll"))));
		w.write(";ModuleID = \'stm2ir\'\ndeclare i32 @printf(i8*, ...)\n@print.str = constant [4 x i8] c\"%d\\0A\\00\"\n\ndefine i32 @main() {"+ "\n");
		@SuppressWarnings("resource")
		Scanner input = new Scanner(new File(args[0]));
		while(input.hasNextLine()){
			linee++;
			try {
			String str = input.nextLine();
			str = str.replaceAll("\\s+","");
			int x = str.indexOf('=');//Whether query contains = sign or not. Nice...
			String str_;String var = "";
			Container contt = new Container("", 0, "", false);
			boolean assign = false;
			if(x != -1){
				str_ = str.split("=")[1];
				var = str.split("=")[0];
				assign = true;
				if(!ContainsVar(var)){
					var = var.replaceAll("\\s","");
					contt = new Container(var, 0, var, false);
					variables.add(contt);
					w.write("%" + var + " = alloca i32"+ "\n");
				}				
			}
			else{str_ = str;}
			//w.write(str_);
			String[] parts = str_.split("(?<=[^\\.a-zA-Z\\d])|(?=[^\\.a-zA-Z\\d])");
			ArrayList<String> sForOne = infToPos(parts);
			while(sForOne.contains(" ")){sForOne.remove(" ");}//This is for white spaces.
			if(sForOne.size() == 1 && assign){
				w.write("store i32 "+ sForOne.get(0) + ", i32* %" + var+ "\n");
				contt.val = Integer.parseInt(sForOne.get(0));
				continue;
			}
			else if (!assign){
				ArrayList<String> s = infToPos(parts);
				while(s.contains(" ")){s.remove(" ");}//This is for white spaces.
				Container regg =evaluate(s);
				w.write("call i32 (i8*, ...)* @printf(i8* getelementptr ([4 x i8]* @print.str, i32 0, i32 0), i32 %" + counter + ")\n");
				counter++;
				continue;
			}
			ArrayList<String> s = infToPos(parts);
			while(s.contains(" ")){s.remove(" ");}
                try{
                    Container regg =evaluate(s);
                }
                catch (Exception e) {
                    fout = new File("file.ll");
                    fos = new FileOutputStream(fout);
                    w = new BufferedWriter(new OutputStreamWriter(fos));
                    System.out.println("Error: Line "+linee+": Syntax error\n");
                    w.flush();
                    w.close();
                    System.exit(1);
                    break;
                }
			w.write("store i32 %"+ counter + ", i32* %" + var + "\n");
			//Find and replace
			} 
			catch (Exception e) {
				fout = new File("file.ll");
				fos = new FileOutputStream(fout);
				w = new BufferedWriter(new OutputStreamWriter(fos));
				System.out.println("Error: Line "+linee+": Syntax error\n");
				w.flush();
				w.close();
				System.exit(1);
				break;
			}
		}
		w.write("ret i32 0\n}"+ "\n");
		w.flush();
		w.close();
	}
}
