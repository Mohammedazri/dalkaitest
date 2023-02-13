/**
* @author: Jacques Akiki -EI Technologies
* @date: 14/08/2019
* @description: Test Class for AP67_OpportunityTeamMember
*/
@isTest
public class AP67_OpportunityTeamMember_test {
    @isTest
    static void OwnerChange()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        List<User> listUsr = new List<User>();
        User u1 = testUtils.CreateUser('standt28', 'user1111@testorg2.com', 'Testing2', p.Id, 'user1rrr@testorg2.com');
        listUsr.add(u1);
        User u2 = testUtils.CreateUser('standt82', 'user222@testorg2.com', 'Testing22', p.Id, 'user1rrr22@testorg2.com');
        listUsr.add(u2);
        insert listUsr;
        
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = label.WS11_OUV;
        insert myaccount;
        
        Opportunity myOpp1 = testUtils.createOpportunity ('TESTOPP1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp1.Type_pers__c=Label.Renouvellement;
        insert myOpp1;
        
        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.UserId = u1.Id;
        otm.OpportunityId = myOpp1.id;
        otm.OpportunityAccessLevel = Label.Label_Edit;
        otm.TeamMemberRole = Label.PV_OTM_Comm;
        insert otm;
        
        Contrat__c cont = new Contrat__c(name='TESTOPP1');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.OwnerId = u1.id;
        insert cont;
        
        Opportunity myOpp2 = testUtils.createOpportunity ('TESTOPP2', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp2.AccountId=myaccount.Id;
        myOpp2.closeDate=Date.today();
        myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp2.Type_pers__c=Label.PV_Evolution;
        myOpp2.ContratOrigine__c = cont.id;
        insert myOpp2;
        
        cont.OwnerId=u2.id;
        update cont;
    }
}