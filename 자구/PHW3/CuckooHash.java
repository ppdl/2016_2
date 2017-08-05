/* 
 * Name: Cho young jae
 * Student ID: 2013147513
 * Don't forget to remove the package line.
 */

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

/* 
 * java.util.ArrayList is for the ArrayList
 * java.util.Random is so you can generate your own hash functions
 * You should not import anything else
 */

public class CuckooHash
{
    private int a1, b1, a2, b2, n, numElements, chainLength;
    private double threshold;
    private int[] array1, array2;
    private boolean resized;
    private ArrayList<Integer> elements;

    /* 
     * Our instance variables.
     *
     * a1 - int, a in the first hash function
     * b1 - int, b in the first hash function
     * a2 - int, a in the second hash function
     * b2 - int, b in the second hash function
     * n - int, the initial size of each array
     * numElements - int, the number of elements that have been inserted
     * chainLength - int, the length of the allowed chain before we resize
     * threshold - double, the point at which our arrays are too full and we resize
     * array1 - int[], the first hash table
     * array2 - int[], the second hash table
     * resized - boolean, set to true if the previous insertion caused a resize
     *           and false otherwise
     */

    public CuckooHash(int a1, int b1, int a2, int b2, int n, int chainLength, double threshold)
    {
        /*
         * Our constructor. Initialize the instance variables to their default
         * value or the value passed as a parameter.
         *
         * array1, array2 should initially be filled with 0's
         */
    	this.a1 = a1;
    	this.b1 = b1;
    	this.a2 = a2;
    	this.b2 = b2;
    	this.n = n;
    	numElements = 0;
    	
    	this.chainLength = chainLength;
    	this.threshold = threshold;
    	
    	array1 = new int[n];
    	Arrays.fill(array1, 0);
    	array2 = new int[n];
    	Arrays.fill(array2, 0);
    	
    	elements = new ArrayList<Integer>();

    }
    public int insert(int data, int a1, int b1, int a2, int b2)
    {
        /*
         * insert data into our CuckooHash if it is not already contained
         * be sure to update resized if necessary
         *
         * This version allows you to specify the new constants for the hash
         * function that will exist after resizing. If the insert does not cause
         * a resize, it should NOT change the hash functions.
         * 
         * return the value that is inserted or -1 if it already exists
         */
    	if(contains(data)) return -1;
    	
    	int bump = 0;  
    	
    	elements.add(data);
    	
    	while(true)
    	{
    		resized = ((bump >= chainLength) || (double)((double)elements.size()/(double)(2*n)) >= threshold);
			if(resized){ 
				resize(a1, b1, a2, b2);
				break;
			}
			
	    	if(array1[hash1(data)] == 0)
	    	{
	    		array1[hash1(data)] = data;
	    		break;
	    	}
	    	else if(array1[hash1(data)] != 0)
	    	{
	    		bump++;	    		
	    		if(array2[hash2(array1[hash1(data)])] == 0)
	    		{		    			
	    			array2[hash2(array1[hash1(data)])] = array1[hash1(data)];
	    			array1[hash1(data)] = data;
	    			resized = ((bump >= chainLength) || (double)((double)elements.size()/(double)(2*n)) >= threshold);
	    			if(resized) resize(a1, b1, a2, b2);
	    			break;
	    		}
	    	
	    		resized = ((bump >= chainLength) || (double)((double)elements.size()/(double)(2*n)) >= threshold);	    		
    			if(resized) {
    				resize(a1, b1, a2, b2);
    				break;
    			}
    			
	    		if(array2[hash2(array1[hash1(data)])] != 0)
	    		{
	    			bump++;	    			
	    			int temp = array2[hash2(array1[hash1(data)])];
	    			array2[hash2(array1[hash1(data)])] = array1[hash1(data)];
	    			array1[hash1(data)] = data;
	    				    
	    			resized = ((bump >= chainLength) || (double)((double)elements.size()/(double)(2*n)) >= threshold);	    			
	    			if(resized) {
	    				resize(a1, b1, a2, b2);
	    				break;
	    			}
	    			data = temp;
	    		}
	    	}
    	}
    	return data;
    }

    public int delete(int data)
    {
        /*
         * delete data from our CuckooHash
         *
         *
         * return the deleted value or -1 if it is not in the CuckooHash
         */
    	if(contains(data)){
    		for(int j=0; j<elements.size(); j++)
    			if(elements.get(j) == data) elements.remove(j);

	    	for(int i=0; i<getN(); i++)
	    	{	    		
	    		if(getElementArray1(i) == data)
	    			{	    				    				
	    				array1[i] = 0;	    			   
	    				return data; 
	    			}
	    		if(getElementArray2(i) == data)
	    		{	    		    				
	    			array2[i] = 0;	    		
	    			return data;
	    		}
	    	}	    		
    	}
    	return -1;
    }

    public boolean contains(int data)
    {
        /*
         * checks containment
         *
         * return true if data is in the CuckooHash
         */
    	return elements.contains(data);
    }

    public int hash1(int x)
    {
        /*
         * Our first hash function
         * Remember, hashes are defined as (a,b,N) = ax+b (mod N)
         *
         * return the value computed by the first hash function
         */
    	return (getA1()*x+getB1())%getN();
    }

    public int hash2(int x)
    {
        /*
         * Our second hash function
         * Remember, hashes are defined as (a,b,N) = ax+b (mod N)
         *
         * return the value computed by the second hash function
         */
    	return (getA2()*x+getB2())%getN();
    }

    public void resize(int a1, int b1, int a2, int b2)
    {
        /*
         * resize our CuckooHash and make new hash functions
         */
    	setA1(a1);
    	setB1(b1);
    	setA2(a2);
    	setB2(b2);
    	
    	n *= 2;
    	
    	array1 = new int[n];
    	Arrays.fill(array1, 0);
    	array2 = new int[n];
    	Arrays.fill(array2, 0);
    	
    	int size = elements.size();
    	
    	int[] temp = new int[size];
    	for(int j=0; j<size; j++)
    		temp[j] = elements.get(j);
    	
    	elements.clear();
    
    	for(int i=0; i<size; i++)insert(temp[i],a1,b1,a2,b2);
    }

    public void setA1(int a1)
    {
        /*
         * set the value a1
         */
    	this.a1 = a1;
    }

    public void setB1(int b1)
    {
        /*
         * set the value b1
         */
    	this.b1 = b1;
    }

    public void setA2(int a2)
    {
        /*
         * set the value a2
         */
    	this.a2 = a2;
    }

    public void setB2(int b2)
    {
        /*
         * set the value b2
         */
    	this.b2 = b2;
    }

    public void setThreshold(double t)
    {
        /*
         * set the threshold
         */
    	this.threshold = t;
    }

    public void setChainLength(int c)
    {
        /*
         * set the chainLength
         */
    	this.chainLength = c;
    }

    public int getElementArray1(int index)
    {
        /*
         * return element at index from array1
         */
    	return array1[index];
    }

    public int getElementArray2(int index)
    {
        /*
         * return element at index from array2
         */
    	return array2[index];
    }

    public int getA1()
    {
        /*
         * return a1
         */
    	return a1;
    }

    public int getB1()
    {
        /*
         * return b1
         */return b1;
    }

    public int getA2()
    {
        /*
         * return a2
         */   
    	return a2;
    }

    public int getB2()
    {
        /*
         * return b2
         */      
    	return b2;
    }

    public int getN()
    {
        /*
         * return n
         */
    	return n;
    }

    public double getThreshold()
    {
        /*
         * return threshold
         */
    	return getNumElements()/(2*getN());
    }

    public int getChainLength()
    {
        /*
         * return chainLength
         */
    	return chainLength;
    }

    public int[] getArray1()
    {
        /*
         * return array1
         */
    	return array1;
    }

    public int[] getArray2()
    {
        /*
         * return array2
         */return array2;
    }

    public int getNumElements()
    {
        /*
         * return the number of elements in the CuckooHash
         */
    	return elements.size();
    }

    public ArrayList<Integer> getElements()
    {
        /*
         * return all of the elements that are in the CuckooHash in their
         * inserted order
         */
    	return elements;
    }

    public boolean getResized()
    {
        /*
         * return the resized variable
         */
    	return resized;
    }

    public String toString()
    {
        /*
         * return the string version of the CuckooHash
         *
         * the required format is: 
         * all values in array1 (including 0's) separated by commas followed by
         * a bar | followed by all values of array2 (including 0's) separated by
         * commas
         *
         * there should be no spaces or trailing commas
         */
    	String str = new String();
    	str = str + getElementArray1(0);
    	for(int i=1; i<getN(); i++)
    		str = str + "," + getElementArray1(i);
    	
    	str += "|" + getElementArray2(0);
    	
    	
    	for(int j=1; j<getN(); j++)
    		str = str + "," + getElementArray2(j); 
    	
    	return str;
    }
}