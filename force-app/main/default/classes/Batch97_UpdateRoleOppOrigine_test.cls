/** 
* @author Jacques Akiki 
* @date 01/10/2020 
* @Test Class for Batch97_UpdateRoleOppOrigine
*/
@isTest
public class Batch97_UpdateRoleOppOrigine_test {
    @isTest
    static void ownerOTM()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user1111@testorg2.com', 'Testing2', p.Id, 'user1rrr@testorg2.com');
        insert u1;
        
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = label.WS11_OUV;
        insert myaccount;
        
        Opportunity myOpp1 = testUtils.createOpportunity ('TESTOPP1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='TESTOPP1');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.OwnerId = u1.id;
        insert cont;
        
        myOpp1.Contrat_Genere_lookup__c = cont.id;
        update myOpp1;
        
        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.UserId = u1.Id;
        otm.OpportunityId = myOpp1.id;
        otm.OpportunityAccessLevel = Label.Label_Edit;
        insert otm;
        id BatchId = Database.executeBatch(new Batch97_UpdateRoleOppOrigine());
        
    }
}