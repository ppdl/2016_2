import org.junit.Test;
import static org.junit.Assert.assertEquals;
import org.junit.Before;
import org.junit.AfterClass;

public class AVLTreeTest
{
    AVLTree t;

    @Before
    public void setup()
    {
        t = new AVLTree();
    }

    @Test(timeout=100)
    public void testOne()
    {
        t.insert(3);
        assertEquals("3", t.toString());
    }

    @Test(timeout=100)
    public void testTwo()
    {
        t.insert(3);
        t.insert(5);
        assertEquals("3,5", t.toString());
        t.insert(1);
        assertEquals("3,1,5", t.toString());

    }

    @Test(timeout=100)
    public void testThree()
    {
        t.insert(3);
        t.insert(5);
        assertEquals("3,5", t.toString());
        t.insert(1);
        assertEquals("3,1,5", t.toString());
        t.delete(3);
        assertEquals("1,5", t.toString());
    }
    
    @Test(timeout=1000)
    public void testFour()
    {
        t.insert(1);
        assertEquals("1", t.toString());
        t.insert(2);
        assertEquals("1,2", t.toString());
        t.insert(3);
        assertEquals("2,1,3", t.toString());
        t.insert(4);
        assertEquals("2,1,3,4", t.toString());
        t.insert(5);
        assertEquals("2,1,4,3,5", t.toString());
        t.insert(6);
        assertEquals("4,2,1,3,5,6", t.toString());
        t.delete(4);
        assertEquals("3,2,1,5,6", t.toString());
        t.delete(3);
        assertEquals("2,1,5,6", t.toString());
        t.delete(2);
        assertEquals("5,1,6", t.toString());
        t.delete(5);
        assertEquals("1,6", t.toString());
    }

    @Test(timeout=1000)
    public void testFive()
    {
        t.insert(6);
        assertEquals("6", t.toString());
        t.insert(5);
        assertEquals("6,5", t.toString());
        t.insert(4);
        assertEquals("5,4,6", t.toString());
        t.insert(3);
        assertEquals("5,4,3,6", t.toString());
        t.insert(2);
        assertEquals("5,3,2,4,6", t.toString());
        t.insert(1);
        assertEquals("3,2,1,5,4,6", t.toString());
        t.delete(6);
        assertEquals("3,2,1,5,4", t.toString());
        t.delete(5);
        assertEquals("3,2,1,4", t.toString());
        t.delete(4);
        assertEquals("2,1,3", t.toString());
        t.delete(2);
        assertEquals("1,3", t.toString());
    }
}