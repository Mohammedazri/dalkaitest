/**
* @author: Jacques Akiki -EI Technologies
* @date: 24/04/2019
* @description: Test Class for Batch44_UpdateOwner
*/
@isTest
public class Batch44_UpdateOwner_test {
@isTest
    static void testUpdateOwner(){
        
        List<User> listUser = new List<User>(); // new list of users
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('test', 'test@testorg.com.tst', 'test', p.Id, 'test@testorg.com.tst'); // new  user
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        usr.BypassProcessBuilder__c = true;
        usr.Bypass_Triggers__c = 'AP45_OwnerChange;AP28_SetContratOwner';
        listUser.add(usr);
        
        User usr1 = testUtils.CreateUser('test1', 'test1@testorg.com.tst', 'test1', p.Id, 'test1@testorg.comtst'); // new user
        listUser.add(usr1);
        
        insert listUser;
        system.runAs(usr)
        {
            Account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount; // insert new Account
            
            Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.statut__c =Label.LC29_newStat; 
            myOpp.Type_pers__c = Label.LC35_Renouv; 
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.OwnerId = usr1.Id;
            insert myOpp; // insert new Opportunity
            
            Contrat__c mycontrat= new Contrat__c(Name='testContrat');
            mycontrat.NomPartenaire__c=myaccount.Id;
            mycontrat.PiloteDuContrat__c = usr1.Id;
            mycontrat.OpportuniteCommerciale__c = myOpp.Id; 
            insert mycontrat; // insert new contract 
            String contId = mycontrat.Id;
            test.startTest();
            Id batchJobId  = Database.executeBatch(new Batch44_UpdateOwner('WHERE id=\''+contId+'\''));
            test.stopTest();
        }
    }
}