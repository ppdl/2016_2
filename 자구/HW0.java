/* 
Name:Á¶¿µÀç
Student ID:2013147513
*/

import java.util.Arrays;

public class HW0
{
	static int iterator = 0;
	
	public static void permutation(String prefix, String str, String resultStr[]) {
		
	    int n = str.length();
	    if (n == 0) {
	    	for(int i=0; i< iterator; i++){
	    		if(resultStr[i].equals(prefix)) return;
	    	}
	    	
	    	resultStr[iterator] = prefix;
	    	iterator++;
	    }
	    else {
	        for (int i = 0; i < n; i++)
	            permutation(prefix + str.charAt(i), str.substring(0, i) + str.substring(i+1, n),resultStr);
	    }
	}
	
	//Factorial
	public static int fact(int n)
	{
		if(n<=1) return n;
		else return fact(n-1)*n;
	}
	
	//input : s is sorted string
	//output : combination of s.length()
	public static int combination(String s)
	{
		int count = 1;
		int result = fact(s.length());
		
		for(int i=0; i<s.length()-1; i++)
		{			
			if(s.charAt(i) != s.charAt(i+1)){
				result /= fact(count);
				count = 1;
			}
			else count++;
		}
		return result /= fact(count);
	}
	
    public static String[] printPermutations(String s)
    {
    	//sorting input string
    	char[] stringChr = s.toCharArray();    	
    	Arrays.sort(stringChr);
    	
    	//Initializing size of resultString by using combination
    	String[] resultStr = new String[combination(s)];
      	
    	String inputString = new String(stringChr, 0, stringChr.length);
    	
    	permutation("",inputString,resultStr);
        /*
        You should return a list of strings populated by the unique permutations
        of the input, s, in alphabetical order.
        */
    	return resultStr;
    }

    /*
    Do not edit anything below this comment.
    */

    public static void main(String[] args)
    {
        String[] permutations = printPermutations(args[0]);
        for(String p : permutations)
        {
            System.out.println(p);
        }
    }
}