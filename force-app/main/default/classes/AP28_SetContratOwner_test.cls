/**
* This class contains unit tests for validating the behavior of Apex classes AP28_SetContratOwner
*/
@isTest
public class AP28_SetContratOwner_test 
{
    @isTest
    static void tesAP28_SetContratOwner()
    {
        //Query the profile
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        
        //Create a first user
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        insert u1;
        
        //Create a second User
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            test.startTest();
            //Create and insert an Opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.Renouvellement;
            insert myOpp;
            
            //Update the Opportunity to won 
            myOpp.StageName=Label.LC28_Realise;
            myOpp.Statut__c =Label.OppBeforeUp_gagne; 
            update myOpp;
            
            //Query the Created Contract
            list <Contrat__c> contList=[SELECT ID, Statut__c,OpportuniteCommerciale__c
                                        FROM Contrat__c 
                                        WHERE OpportuniteCommerciale__c= :myOpp.id ];     
            //Update the contract
            Contrat__c cont= contList[0];
            cont.PiloteDuContrat__c =u1.id;
            update cont;
            
            test.stopTest();
        }
    }
    
}