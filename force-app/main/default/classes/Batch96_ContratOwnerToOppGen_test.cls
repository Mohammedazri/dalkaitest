/** 
* @author Jacques Akiki 
* @date 01/10/2020 
* @Test Class for Batch96_ContratOwnerToOppGen
*/
@isTest
public class Batch96_ContratOwnerToOppGen_test {
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
        myOpp1.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='TESTOPP1');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.OwnerId = u1.id;
        insert cont;
        
        List<Opportunity> listOpp = new List <Opportunity>();
        Opportunity myOpp2 = testUtils.createOpportunity ('TESTOPP2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp2.AccountId=myaccount.Id;
        myOpp2.closeDate=Date.today();
        myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp2.Type_pers__c =Label.Evolution;
        myOpp2.ContratOrigine__c = cont.id;
        listOpp.add(myOpp2);
        
        Opportunity myOpp3 = testUtils.createOpportunity ('TESTOPP2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp3.AccountId=myaccount.Id;
        myOpp3.closeDate=Date.today();
        myOpp3.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp3.Type_pers__c =Label.Evolution;
        myOpp3.ContratOrigine__c = cont.id;
        listOpp.add(myOpp3);
        insert listOpp; 
        
        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.UserId = u1.Id;
        otm.OpportunityId = myOpp2.id;
        otm.OpportunityAccessLevel = 'Read';
        otm.TeamMemberRole = Label.PV_OTM_Comm;
        insert otm;
        id BatchId = Database.executeBatch(new Batch96_ContratOwnerToOppGen());
        
    }
}