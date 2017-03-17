import java.util.*;


public class main {
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
	public static ArrayList<Container> variables = new ArrayList();
	public static int counter = 0;
	
	public static int pri(String c){
		if (c.equals("*") || c.equals("/"))
			return 1;
		else if (c.equals("+") || c.equals("-"))
			return 2;	
		else
			return 3;
	}
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

	public static Container findC(String s){
		for (int i = 0; i < variables.size(); i++) {
			if(variables.get(i).name.equals(s)){
				return variables.get(i);
			}
		}
		Container x = new Container("number", Integer.parseInt(s),  s, true);
		return x;
	}
	
	public static boolean isSign(String s){
		if(s.equals("+") || s.equals("-") || s.equals("/") || s.equals("*")){
			return true;
		}
		else{
			return false;
		}		
	}

	
	public static void evaluate(ArrayList<String> exp){
		Stack<Container> stk = new Stack<>();
		for (int i = 0; i < exp.size(); i++) {
			if(!isSign(exp.get(i))){
				stk.push(findC(exp.get(i)));
			}
			else{
				counter++;	
				String oper = exp.get(i);
				Container first = stk.pop();
				Container second = stk.pop();
				if(oper.equals("+")){
					String name = "" + counter;
					Container result = new Container(name, first.val + second.val, name, false);
					stk.push(result);
					String message = "%" + result.name + " = add i32 ";
					message = first.number ? message + first.reg : message + "%" + first.reg;
					message = message + ",";
					message = second.number ? message + second.reg : message + "%" + second.reg;
					System.out.println(message);
				 }
				else if(oper.equals("*")){
					String name = "" + counter;
					Container result = new Container(name, first.val * second.val, name, false);
					stk.push(result);
					String message = "%" + result.name + " = mul i32 ";
					message = first.number ? message + first.reg : message + "%" + first.reg;
					message = message + ",";
					message = second.number ? message + second.reg : message + "%" + second.reg;
					System.out.println(message);
				 }
				//Sub and div
			}
		}
	}
	
	public static void main(String[] args) {
		String str = "k=x1*(1+(2+5))";
		//if '=' exist
		int x = str.indexOf('=');
		if(x != -1){str = str.split("=")[1];}//Whether query contains = sign or not. Nice...
		String[] parts = str.split("(?<=[^\\.a-zA-Z\\d])|(?=[^\\.a-zA-Z\\d])");
		System.out.println(Arrays.toString(parts));
		ArrayList<String> s = infToPos(parts);
		variables.add(new Container("x1", 8, "x1", false));
		while(s.contains(" ")){s.remove(" ");}//This is for white spaces.
		System.out.println(s);
		evaluate(s);//Best fucking function in the universe xd
		
	}
}