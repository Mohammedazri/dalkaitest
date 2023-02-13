/**
* This class contains unit tests for validating the behavior of Apex classes AP09_Opportunity
*/
@isTest
private class AP09_Opportunity_test {
    @isTest
    static void checkExistanceRenewalOpp_Test() {        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        System.runAs(u2) {            
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            contrat__c contrat = new contrat__c();
            contrat.name = 'testContrat';
            contrat.NomPartenaire__c = myaccount.Id;
            insert contrat;
            
            contrat__c contrat2 = new contrat__c();
            contrat2.name = 'testContrat2';
            contrat2.NomPartenaire__c = myaccount.Id;
            insert contrat2;
            
            Test.startTest();
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Type_pers__c=Label.Renouvellement;
            myOpp.ContratOrigine__c = contrat.Id;
            myOpp.Statut__c = 'En cours';
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp2.AccountId=myaccount.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp2.Type_pers__c=Label.PV_Opp_Type_Nouveau;
            myOpp2.ContratOrigine__c = contrat2.Id;            
            insert new list<opportunity>{myOpp, myOpp2};
            myOpp2.Type_pers__c = Label.Renouvellement;            
            update myOpp2;
        }                       
        Test.stopTest();
        
    }
}