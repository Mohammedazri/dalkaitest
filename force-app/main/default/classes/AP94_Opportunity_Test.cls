/**
* @author: Jimmy Khalil
* @date: 28/01/2021
* @description: Test Class for "AP94_Opportunity" 
*/
@isTest
public class AP94_Opportunity_Test {
    static testMethod void test()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        insert u2; 
        
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.OwnerID=u2.id;
        c1.Name='testtingg ';
        c1.DureeInitialeContrat__c = 1;
        insert c1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.ContratOrigine__c=c1.id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        insert myOpp;
        
        myOpp.OwnerId=u2.id;
        update myOpp;
        
    }
    
    static testMethod void test1()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        insert u2; 
        
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.OwnerID=u2.id;
        c1.Name='testtingg ';
        c1.DureeInitialeContrat__c = 1;
        insert c1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.ContratOrigine__c=c1.id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        insert myOpp;
        
        OpportunityTeamMember oppteamMember1 = new OpportunityTeamMember();
        oppteamMember1.OpportunityId=myOpp.id;
        oppteamMember1.userID=u2.id;
        oppteamMember1.TeamMemberRole='Account Manager';
        insert oppteamMember1;
        
        myOpp.OwnerId=u2.id;
        update myOpp;
        
    }
}