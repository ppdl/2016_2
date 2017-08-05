/* 
 * Name: Cho young jae
 * Student ID: 2013147513
 * Don't forget to remove the package line.
 */

public class AVLTree
{
    private AVLTreeNode root;
    private int size;

    /* 
     * Our instance variables.
     *
     * root - AVLTreeNode, root of our AVLTree
     * size - int, the number of elements in our AVLTree
     */

    public AVLTree()
    {
        /*
         * Our constructor. 
         * Initialize the instance variables to their default values
         */
    	root = null;
    	size = 0;    	
    }

    public AVLTreeNode insert(int data)
    {
        /*
         * Constructs a new AVLTreeNode and inserts it into our AVLTree
         *
         * return the inserted AVLTreeNode or null if a node with the same data
         * already exists
         */
    	if(contains(data)) return null;
    	   	
    	if(size == 0){
    		root = new AVLTreeNode(data);
    		root.setParent(null);
    		size++;
    		return root;
    	}
    	size++;

    	AVLTreeNode position = root;//start from root to find proper position where to insert a new node.
    	AVLTreeNode p = null;			//variable for saving position's parent node
    	//find a position
		while(position != null){
			p = position;
			
			if(data < position.getData()) position = position.getLeft();
			else if(data > position.getData()) position = position.getRight();
			
		}
		//insert a new node
		if(data < p.getData()){
			p.setLeft(new AVLTreeNode(data));
			position = p.getLeft();
			position.setParent(p);
		}
		else{
			p.setRight(new AVLTreeNode(data));
			position = p.getRight();
			position.setParent(p);
		}
		
		position.setBalanceFactorHeight();

		AVLTreeNode balanceStart = position;
		while(balanceStart != root){
			if(!balanceStart.isBalnce()) break;
			else balanceStart = balanceStart.getParent();
		}
		if(!balanceStart.isBalnce()) balance(balanceStart);
		return position;
    }

    public AVLTreeNode retrieve(int data)
    {
        /*
         * returns the node in the tree containing the desired data
         *
         * return null if it is not in the tree
         */
    	
    	AVLTreeNode[] container = preorder();
    	for(int i=0; i<container.length; i++)
    		if(container[i].getData() == data) return container[i];    	
    	return null;
    	
    }

    public boolean contains(int data)
    {
        /*
         * return whether or not the tree contains a node with the desired data
         */
    	AVLTreeNode[] container = preorder();
    	for(int i=0; i<container.length; i++)
    		if(container[i].getData() == data) return true;
    	return false;
    }

    public AVLTreeNode delete(int data)
    {
        /*
         * remove and return the AVLTreeNode with the desired data
         *
         * return null if the data is not in the AVLTree
         */
    	if(!contains(data)) return null;
    	
    	AVLTreeNode[] container = inorder();
    	
    	AVLTreeNode delNode = null;
    	AVLTreeNode delNextNode = null;    	
    	
    	size--;
    	if(size == 0){
    		clear();
    		return root;
    	}
    	for(int i=0; i<container.length; i++)
    		if(container[i].getData() == data){
    			if(i == container.length -1){
    				if(container[i].getLeft() != null){
    					container[i].getParent().setRight(container[i].getLeft());
    					container[i].getParent().getRight().setParent(container[i].getParent());
    				}
    				else container[i].getParent().setRight(null);
    				container[i].getParent().setBalanceFactorHeight();
    				if(!container[i].getParent().isBalnce()) balance(container[i].getParent());
    				return container[i];
    			}
    			delNode = container[i];
				delNextNode = container[i+1];
				break;
    	}
    	AVLTreeNode temp = new AVLTreeNode(delNode.getData());    	
    	delNode.setData(delNextNode.getData());
    	
    	if(delNode.getRight() == delNextNode){
    		delNode.setRight(delNextNode.getRight());
    		if(delNode.getRight() != null) delNode.getRight().setParent(delNode);
    		delNode.setBalanceFactorHeight();
    		if(!delNode.isBalnce()) balance(delNode);
    	}
    	else if(delNextNode == delNode.getParent()){
    		delNextNode.setLeft(delNode.getRight());
    		if(delNode.getRight() != null) delNode.getRight().setParent(delNextNode);
    		delNextNode.setBalanceFactorHeight();
    		if(!delNextNode.isBalnce()) balance(delNextNode);
    	}
    	else{
    		delNextNode.getParent().setLeft(delNextNode.getRight());
    		if(delNextNode.getRight() != null) delNextNode.getRight().setParent(delNextNode.getParent());
    		delNextNode.getParent().setBalanceFactorHeight();
    		if(!delNextNode.getParent().isBalnce()) balance(delNextNode.getParent());
    	}    	
    	return temp;
    }

    public AVLTreeNode leftRotate(AVLTreeNode node)
    {
        /*
         * Perform a left rotate on the subtree rooted at node
         *
         * return the new root of the subtree
         */
    	AVLTreeNode a = node;
    	AVLTreeNode b = node.getRight();
    	
    	if(a.getParent() == null){
    		b.setParent(null);
    		b.setLeft(a);
    		a.setParent(b);
    	}
    	else{
    		b.setParent(a.getParent());
    		if(b.getData() < b.getParent().getData()) b.getParent().setLeft(b);
    		else b.getParent().setRight(b);
        	a.setRight(b.getLeft());
        	if(a.getRight() != null) a.getRight().setParent(a);
        	a.setParent(b);
        	b.setLeft(a);
        }
    	a.setBalanceFactorHeight();
    	
    	return b;
    }

    public AVLTreeNode rightRotate(AVLTreeNode node)
    {
        /*
         * Perform a right rotate on the subtree rooted at node
         *
         * return the new root of the subtree
         */
    	AVLTreeNode c = node;
    	AVLTreeNode b = node.getLeft();
    	
    	if(c.getParent() == null){
    		b.setParent(null);
    		b.setRight(c);
    		c.setParent(b);
    	}
    	else{
    		b.setParent(c.getParent());
    		if(b.getData() < b.getParent().getData()) b.getParent().setLeft(b);
    		else b.getParent().setRight(b);
        	c.setLeft(b.getRight());
        	if(c.getLeft() != null) c.getLeft().setParent(c);
        	c.setParent(b);
        	b.setRight(c);
    	}
    	c.setBalanceFactorHeight();
    	
    	return b;
    }
    
    private int OrderIdx;
    public AVLTreeNode[] preorder()
    {
        /*
         * return an array of AVLTreeNodes in preorder
         */
    	OrderIdx=0;
    	AVLTreeNode[] result = new AVLTreeNode[getSize()];
    	preOrder(root, result);
 
    	return result;
    }

    public AVLTreeNode[] postorder()
    {
        /*
         * return an array of AVLTreeNodes in postorder
         */
    	OrderIdx=0;
    	AVLTreeNode[] result = new AVLTreeNode[size];
    	postOrder(root, result);
    	return result;
    }

    public AVLTreeNode[] inorder()
    {
        /*
         * return an array of AVLTreeNodes in inorder
         */
    	OrderIdx=0;
    	AVLTreeNode[] result = new AVLTreeNode[size];
    	inOrder(root, result);
    	return result;
    }
    public void preOrder(AVLTreeNode v, AVLTreeNode[] t) //root, result
    {
    	if(v != null){
    		t[OrderIdx] = v;
    		OrderIdx++;
    		preOrder(v.getLeft(),t);
    		preOrder(v.getRight(),t);
    	}
    }
    
    public void postOrder(AVLTreeNode v, AVLTreeNode[] t)
    {
    	if(v != null){
    		postOrder(v.getLeft(),t);
    		postOrder(v.getRight(),t);
    		t[OrderIdx] = v;
    		OrderIdx++;
    	}
    }
    
    public void inOrder(AVLTreeNode v, AVLTreeNode[] t)
    {

    	if(v.getLeft() != null)
    		inOrder(v.getLeft(), t);
    	t[OrderIdx] = v;
    	OrderIdx++;
    	if(v.getRight() != null)
    		inOrder(v.getRight(), t);
    }

    public void balance(AVLTreeNode node){
    	AVLTreeNode a,b,c;
    	AVLTreeNode x,y,z;
    	AVLTreeNode T0, T1, T2, T3;
    	
    	if(node.getBalanceFactor() == -2 && node.getLeft().getBalanceFactor() == -1){
    		a = node.getLeft().getLeft();
    		b = node.getLeft();
    		c = node;
    		T0 = a.getLeft();
    		T1 = a.getRight();
    		T2 = b.getRight();
    		T3 = c.getRight();
    		x = c;
    		y = b;
    		z = a;
    	}
    	else if(node.getBalanceFactor() == -2 && node.getLeft().getBalanceFactor() == 1){
    		a = node.getLeft();
    		b = node.getLeft().getRight();
    		c = node;
    		T0 = a.getLeft();
    		T1 = b.getLeft();
    		T2 = b.getRight();
    		T3 = c.getRight();
    		x = c;
    		y = a;
    		z = b;
    	}
    	else if(node.getBalanceFactor() == 2 && node.getRight().getBalanceFactor() == -1){
    		a = node;
    		b = node.getRight().getLeft();
    		c = node.getRight();
    		T0 = a.getLeft();
    		T1 = b.getLeft();
    		T2 = b.getRight();
    		T3 = c.getRight();
    		x = a;
    		y = c;
    		z = b;
    	}
    	else{
    		a = node;
    		b = node.getRight();
    		c = node.getRight().getRight();
    		T0 = a.getLeft();
    		T1 = b.getLeft();
    		T2 = c.getLeft();
    		T3 = c.getRight();
    		x = a;
    		y = b;
    		z = c;
    	}
    	
    	if(x.getParent() == null){
    		root = b;
    		b.setParent(null);
    	}
    	else{
    		AVLTreeNode p = x.getParent();
    		if(x.getData() < p.getData()){
    			b.setParent(p);
    			p.setLeft(b);
    		}
    		else{
    			b.setParent(p);
    			p.setRight(b);
    		}
    	}
    	
    	b.setLeft(a);
    	a.setParent(b);
    	b.setRight(c);
    	c.setParent(b);
    	
    	a.setLeft(T0);
    	if(T0 != null) T0.setParent(a);
    	a.setRight(T1);
    	if(T1 != null) T1.setParent(a);
    	
    	c.setLeft(T2);
    	if(T2 != null) T2.setParent(c);
    	c.setRight(T3);
    	if(T3 != null) T3.setParent(c);
    	
       //set height and balanceFactor after balancing
    	a.setHeight();
    	a.setBalanceFactor();
    	c.setHeight();    	
    	c.setBalanceFactor();
       while(b.getParent() != null){
    	   b.setHeight();
    	   b.setBalanceFactor();
    	   b = b.getParent();    	   
       }
       b.setHeight();
       b.setBalanceFactor();
    }
    public void clear()
    {
        /*
         * clear the AVLTree
         */
    	this.root = null;
    	this.size = 0;
    }

    public boolean isEmpty()
    {
        /*
         * return whether or not the AVLTree is empty
         */
    	return (size == 0);
    }

    public AVLTreeNode getRoot()
    {
        /*
         * return the root of the AVLTree
         */
    	return root;
    }
    public String toString()
    {
        /*
         * return a string representation of the AVLTree.
         *
         * The format is the elements of the tree in preorder, each separated
         * by a comma. There should be no spaces and no trailing commas.
         */
    	AVLTreeNode[] container = preorder();
    	String result = container[0].toString();
    	for(int i=1; i<container.length; i++)
    		result = result + "," + container[i].toString();    		
    	return result;
    }
    public int getSize()
    {
    	return this.size;
    }
}

class AVLTreeNode
{
    private int data, height, balanceFactor;
    private AVLTreeNode left, right, parent;

    /* 
     * Our instance variables.
     *
     * data - int, the data the AVLTreeNode will hold
     * height - int, the height of the AVLTreeNode
     * balanceFactor - int, the balance factor of the node
     * left - AVLTreeNode, the left child of the node
     * right - AVLTreeNode, the right child of the node
     */

    public AVLTreeNode(int data)
    {
        /*
         * Our constructor. 
         * Initialize the instance variables to their default values or the
         * values passed as paramters
         */
    	setData(data);
    	setHeight(0);
    	setBalanceFactor(0);	
    	setLeft(null);
    	setRight(null);
    }

    public void setData(int data)
    {
        /*
         * Set the value stored in data
         */
    	this.data = data;
    }

    public void setHeight(int height)
    {
        /*
         * Set the value stored in height
         */
    	this.height = height;
    }
    public void setHeight()
    {
    	if(left == null && right == null) height = 0;
    	else if(left == null && right != null) height = right.getHeight()+1;
    	else if(left != null && right == null) height = left.getHeight()+1;
    	else{
    		if(left.getHeight() > right.getHeight()) height = left.getHeight()+1;
    		else height = right.getHeight()+1;
    	}
    }
    public void setBalanceFactor(int balanceFactor)
    {
        /*
         * Set the value stored in balanceFactor
         */
    	this.balanceFactor = balanceFactor;
    }
    
    public void setBalanceFactor()
    {
    	/*
    	 * Set the balanceFactor of node
    	 */
    	int bf;
    	if(this.right == null && this.left == null) bf = 0;
    	else if(this.right == null && this.left != null) bf = -1 - this.left.getHeight();
    	else if(this.right != null && this.left == null) bf = this.right.getHeight() + 1;
    	else bf = this.right.getHeight() - this.left.getHeight();
    	
    	this.balanceFactor = bf;
    }

    public void setBalanceFactorHeight()
    {
    	AVLTreeNode pos = this;
    	
    	while(pos.getParent() != null){
    		pos.setHeight();
    		pos = pos.getParent();
    	}
    	pos.setHeight();
		//set nodes' balanceFactor above of the inserted node     	
		AVLTreeNode balanceFactorStart = this;
		while(balanceFactorStart.getParent() != null){			
			balanceFactorStart.setBalanceFactor();
			balanceFactorStart = balanceFactorStart.getParent();
		}
		//set balanceFactor of the root node
		balanceFactorStart.setBalanceFactor(); 
    }
    
    public void setLeft(AVLTreeNode left)
    {
        /*
         * Set the left child
         */
    	this.left = left;
    }

    public void setRight(AVLTreeNode right)
    {
        /*
         * Set the right child
         */
    	this.right = right;
    }
    
    public void setParent(AVLTreeNode parent){
    /*
     * Set the parent
     */
    this.parent = parent;
    }

    public void clearLeft()
    {
        /*
         * clear the left child
         */
    	this.left = null;
    	if(getHeight() == (left.getHeight()+1)) this.setHeight(right.getHeight() + 1);
    	else this.setHeight(this.getHeight()-1);
    }

    public void clearRight()
    {
        /*
         * clear the right child
         */
    	this.right = null;
    	if(getHeight() == (right.getHeight()+1)) setHeight(left.getHeight() + 1);
    	else this.setHeight(this.getHeight()-1);
    }

    public int getData()
    {
        /*
         * get the data stored in the AVLTreeNode
         */
    	return data;
    }

    public int getHeight()
    {
        /*
         * get the height of the AVLTreeNode
         */
    	return height;
    }
    

    public int getBalanceFactor()
    {
        /*
         * get the balanceFactor of the AVLTreeNode
         */
    	return balanceFactor;
    }

    public AVLTreeNode getLeft()
    {
        /*
         * get the left child
         */
    	return left;
    }

    public AVLTreeNode getRight()
    {
        /*
         * get the right child
         */
    	return right;
    }
    
    public AVLTreeNode getParent()
    {
    	/*
    	 * get the parent
    	 */
    	return parent;
    }
    
    public boolean isBalnce()    
    {
    	return (this.getBalanceFactor() == -1 || this.getBalanceFactor() == 0 || this.getBalanceFactor() == 1);
    }

    public String toString()
    {
        /*
         * return the string value of the data stored in the node
         */
    	return Integer.toString(data);
    }
}