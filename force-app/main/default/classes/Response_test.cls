/**
*@author Jacques Akiki
*@date 03/07/2019
*@description Test class for Response
*/
@istest
public class Response_test {
@istest
    public static void testController() 
    {
        Response rsp = new Response();
        Response rsp1 = new Response('a','b');
        Response rsp2 = new Response('a','b',true);
    }
}