/**
*@author Charbel Khoury Hanna
*@date 10/17/2022
*@description Test Class pour AP117_Case
*/
@isTest
public class AP117_Case_Test {
    
    static testMethod void testMethode()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.Flux_AC_Id];
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        insert u1;
        
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        contact mycontact = testUtils.createContact('test 2', myaccount.Id, null);
        mycontact.Phone ='45245';
        insert mycontact;
        
        list<Case> listcase = new List<Case>();
        Case ca = new Case(Subject='Test',Status = 'Nouveau',Origin ='Mail',Reason='Information',Type_de_demande__c=Label.AP101_TypeDemandeInsatisfaction,AccountId=myaccount.Id,ContactId=mycontact.Id,DateDeReceptionDeLaDemande__c = Date.today());
        listcase.add(ca);
        insert listcase;
        
        System.runAs(u1) 
        {
            ca.Subject = 'Test 123';
            update ca;
            
            delete ca;   
        }
    }

}