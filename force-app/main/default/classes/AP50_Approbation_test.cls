/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: Test Class for LC50_CommentairesApprobation_Controller
*/
@isTest
public class AP50_Approbation_test {
    @isTest
    static void testApprob()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user1111@testorg2.com', 'Testing2', p.Id, 'user1rrr@testorg2.com');
        insert u1;
        
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        insert a1;
        
        //create and insert opportunity
        opportunity myOpp = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c=Label.PV_Evolution;
        myOpp.Annee_de_signature__c='2022';
        insert myOpp;

        Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        Fiche1.Approbateur1__c = u1.id;
        update Fiche1;
        test.startTest();
        Approbation__c App = new Approbation__c();
        App.Name = 'Test';
        App.Statut__c='Soumis';
        App.tech_Attribue__c = u1.id;
        App.tech_FicheDeSynthese__c = Fiche1.Id;
        insert App;
        system.assert([SELECT id FROM OpportunityTeamMember WHERE OpportunityId =:myOpp.Id].size()==2);
        App.Statut__c= 'Approuvée';
        update App;
        test.stopTest();
    }
}