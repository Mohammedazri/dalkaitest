/** 
* @author Jacques AKiki
* @date 21/06/2021 
* @description class responsible of running AP74 Once
* @Test Class AP74_Account_test 
*/
global class Validation_Account 
{
    public static boolean blnDoneOnce = false; 
    public static boolean hasDoneOnce()
    { 
        return blnDoneOnce; 
    }
    
    public static void setDoneOnce() 
    {
        blnDoneOnce = true;
    } 
}