/**
*@author Jimmy Khalil
*@date 09/07/2021
*@description Test Class pour AP101_Case
*/
@isTest
public class AP101_Case_Test {
    static testMethod void testNotif(){
        
        User testUser = [Select id from User where ID=:Label.AP101_MCConnectId];
        
        system.runAs(testUser){
            
            
            
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            contact mycontact = testUtils.createContact('test 2', myaccount.Id, null);
            mycontact.Phone ='45245';
            insert mycontact;
            
            list<Case> listcase = new List<Case>();
            Case ca = new Case(Subject='Test',Status = 'Nouveau',Origin ='Mail',Reason='Information',Type_de_demande__c=Label.AP101_TypeDemandeInsatisfaction,AccountId=myaccount.Id,ContactId=mycontact.Id,DateDeReceptionDeLaDemande__c = Date.today());
            listcase.add(ca);
            insert listcase;
        }
    }
    static testMethod void testNotifBulk(){
        User testUser = [Select id from User where ID=:Label.AP101_MCConnectId];
        
        system.runAs(testUser){
            Test.startTest();
            
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            contact mycontact = testUtils.createContact('test 2', myaccount.Id, null);
            mycontact.Phone ='45245';
            insert mycontact;
            
            Test.stopTest();
            
            list<Case> listcase = new List<Case>();
            for(integer i=0;i<10;i++){
                listcase.add(new Case(Subject=('Test'+i),Status = 'Nouveau',Origin ='Mail',Reason='Information',Type_de_demande__c=Label.AP101_TypeDemandeInsatisfaction,AccountId=myaccount.Id,ContactId=mycontact.Id,DateDeReceptionDeLaDemande__c = Date.today()));
            }
            insert listcase;
        }
    }
}