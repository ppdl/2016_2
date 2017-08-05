/*
 * Name: Cho young jae
 * Student ID:2013147513
 * Don't forget to remove the package line (if it exists)
 */

import java.util.Scanner;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.PriorityQueue;

/*
 * Do not import anything else
 */

public class HuffmanEncoder
{
    char[] alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,!?'-\" \n)(".toCharArray();
    /*
     * alphabet holds all of the characters that may appear in our tests
     * You should not edit alphabet in any way
     * 
     * Note that some of the characters (quotes, newline) are represented as two
     * characters in text. These are still read as one character when
     * scanned or written so be sure to account for these special characters. 
     *
     * You may add any other instance variable that you wish
     *
     */
    private HashMap<Character, Integer> frequencyTable;
    PriorityQueue<HuffmanNode> huffmanTable;
    HuffmanNode root;
    HashMap<Character, String> encodedCharacter;    

    public HuffmanEncoder(HashMap<Character, Integer> frequencyTable)
    {
        /*
         * Constructor for our Huffman Encoder if we are given a predefined
         * frequency table from which to construct our encoding tree
         *
         * frequencyTable - HashMap<Character, Integer> - A hashmap containing
         *     each character and its frequency. If a character does not appear
         *     in the table, you can assume it will not appear in any test
         */
    	this.frequencyTable = frequencyTable;
    	this.huffmanTable = new PriorityQueue<HuffmanNode>();  	
    	this.encodedCharacter = new HashMap<Character, String>();
    	makeTrie();
    }

    public HuffmanEncoder(String filePath)
    {

        /*
         * Constructor for our Huffman Encoder if we are given a file path from
         * which to infer a frequency table
         *
         * We have provided some skeleton code that you can use (or not) in
         * order to scan the file.
         *
         * filePath - String - the path to a text file that should be scanned
         *     and used to construct our encoding tree. If a character does not
         *     appear in the file, you can assume it will not appear in any test
         */
    	this.huffmanTable = new PriorityQueue<HuffmanNode>();
    	
    	
        Scanner scan = null;
        
        try 
        {
            scan = new Scanner(new BufferedReader(new FileReader(filePath)));
            char[] characters;
            while (scan.hasNextLine())
            {
                String s = scan.nextLine(); 
                characters = s.toCharArray();
                for(char c : characters)
                {
                    /*
                     *
                     * Write your code here for parsing each of the characters
                     * from the input file
                     *
                     * The char[] array, characters, holds all of the characters
                     * in the current line of the file
                     *
                     * You are free to delete all of this and implement it in
                     * whatever way you want, but we don't recommend it.
                     * 
                     */
                	if(!frequencyTable.containsKey(c)) frequencyTable.put(c, 0);
                	if(frequencyTable.containsKey(c)) frequencyTable.put(c, frequencyTable.get(c)+1);
                }
            }
        	this.huffmanTable = new PriorityQueue<HuffmanNode>();  	
        	this.encodedCharacter = new HashMap<Character, String>();
        	makeTrie();
        }        

        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }

        finally 
        {
            if (scan != null) 
            {
                scan.close();
            }
        }
    }

    public double compressionRatio(String s)
    {
        /*
         * Return the fraction of the length of the encoded string compared to
         * the (length of s)*16 (since we care about the number of bits)
         */
    	return (double)((double)encodeString(s).length()/(double)(s.length()*16));
    }

    public String encodeString(String s)
    {
        /*
         * Return the string containing the encoding of the provided string
         */
    	characterEncode(root, "");
    	String result = "";
    	for(char c: s.toCharArray()){
    		result += encodedCharacter.get(c);
    	}    	
    	return result;
    }

    public String decodeString(String s)
    {
        /*
         * Given an encoded string, return the original, decoded string
         */
    	String result = "";
    	HuffmanNode n = root;
    	int i=0;
    	while(i<s.length()-1){
	    	while(n.getCharacter() == null){
	    		if(s.charAt(i) == '0') n = n.getLeft();
	    		else n = n.getRight();
	    		i++;
	    	}
	    	result += n.getCharacter();
	    	n = root;
    	}
    	return result;
    }

    public void encodeFile(String inputFilePath, String outputFilePath)
    {
        /*
         * Read the file at inputFilePath and write the encoding of text to a
         * file stored at outputFilePath 
         */
    	 String str="";
    	 Scanner scan = null;
         
         try 
         {
             scan = new Scanner(new BufferedReader(new FileReader(inputFilePath)));
             char[] characters;
             while (scan.hasNextLine())
             {
                 String s = scan.nextLine(); 
                 characters = s.toCharArray();
                 for(char c : characters)
                 {
                 	str += c;
                 }
             }
         }        

         catch(Exception e)
         {
             System.out.println(e.getMessage());
         }

         finally 
         {
             if (scan != null) 
             {
                 scan.close();
             }
         }
         
         str = encodeString(str);
         
         try{
        	 FileWriter writer = new FileWriter(outputFilePath);
        	 writer.write(str);
        	 
        	 writer.close();
         }catch(Exception e){
        	 System.out.println(e.getMessage());
         }
    }        

    

    public void decodeFile(String inputFilePath, String outputFilePath)
    {
        /*
         * Read the file at inputFilePath (containing encoded text) and write
         * the decoded text to a file at outputFilePath
         */
    	String str="";
   	 	Scanner scan = null;
        
        try 
        {
            scan = new Scanner(new BufferedReader(new FileReader(inputFilePath)));
            char[] characters;
            while (scan.hasNextLine())
            {
                String s = scan.nextLine(); 
                characters = s.toCharArray();
                for(char c : characters)
                {
                	str += c;
                }
            }
        }        

        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }

        finally 
        {
            if (scan != null) 
            {
                scan.close();
            }
        }
        
        str = decodeString(str);
        
        try{
       	 FileWriter writer = new FileWriter(outputFilePath);
       	 writer.write(str);
       	 
       	 writer.close();
        }catch(Exception e){
       	 System.out.println(e.getMessage());
        }
    }

    public HashMap<Character, String> getMapping()
    {
        /*
         * Return a hashmap containing each character in the encoder and its
         * encoding string
         * 
         */
    	characterEncode(root,"");    	
    	return encodedCharacter;
    }
    
    public void makeTrie()
    {
    	for(char c : alphabet){
    		huffmanTable.add(new HuffmanNode(frequencyTable.get(c), c));
    	}
    	
    	while(true){
    		HuffmanNode leftChild = huffmanTable.poll();
    		HuffmanNode rightChild = huffmanTable.poll();
    		HuffmanNode newNode = new HuffmanNode(leftChild.getFrequency() + rightChild.getFrequency());
    		newNode.setLeft(leftChild);
    		newNode.setRight(rightChild);
    		if(huffmanTable.isEmpty()){
    			root = newNode;
    			break;
    		}
    		huffmanTable.offer(newNode);
    	}
    }
    
    public void characterEncode(HuffmanNode n, String str)
    {
    	if(n.getCharacter() != null){
    		encodedCharacter.put(n.getCharacter(), str);
    		return;
    	}
    	else{
    		characterEncode(n.getLeft(), str + '0');
    		characterEncode(n.getRight(), str + '1');
    	}
    }
}

/*
 *  ================================
 *  Do not modify below this comment
 *  ================================
 */

class HuffmanNode implements Comparable<HuffmanNode>
{
    private int frequency;
    private Character ch;
    private HuffmanNode left, right;

    public HuffmanNode(int frequency)
    {
        this.frequency = frequency;
    }

    public HuffmanNode(int frequency, Character ch)
    {
        this.frequency = frequency;
        this.ch = ch;
    }

    public int getFrequency()
    {
        return frequency;
    }

    public Character getCharacter()
    {
        return ch;
    }

    public HuffmanNode getLeft()
    {
        return left;
    }

    public HuffmanNode getRight()
    {
        return right;
    }

    public void setFrequency(int frequency)
    {
        this.frequency = frequency;
    }

    public void setCharacter(Character ch)
    {
        this.ch = ch;
    }

    public void setLeft(HuffmanNode n)
    {
        this.left = n;
    }

    public void setRight(HuffmanNode n)
    {
        this.right = n;
    }

    public String toString()
    {
        if(this.ch != null)
            return Character.toString(this.ch) + String.format(":%d",frequency);
        else
            return String.format("null:%d", frequency);
    }

    public int compareTo(HuffmanNode n)
    {
        if(this.getFrequency() == n.getFrequency())
        {
            if(this.getCharacter() != null && n.getCharacter() != null)
            {
                return this.getCharacter().compareTo(n.getCharacter());
            }

            else if(this.getCharacter() == null && n.getCharacter() != null)
            {
                return 1;
            }

            else if(this.getCharacter() != null && n.getCharacter() == null)
            {
                return -1;
            }

            else
            {
                return 0;
            }
        }
        return this.getFrequency()-n.getFrequency();
    }
}