/** 
* @author Jacques Akiki
* @date 13/07/2020 
* @test Class of LC71_AlerteEvolution_Controller
*/
@isTest
public class LC71_AlerteEvolution_Controller_test {
    static testMethod void testAlertEvol() 
    {
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp1.AccountId=myaccount.Id;
        myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp1.Type_pers__c =Label.Opp_type_Renewal;
        myOpp1.closeDate=Date.today();
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='Contrat');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        insert cont;
        
        List<Opportunity> listOpp = new List<Opportunity>();
        Opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp2.AccountId=myaccount.Id;
        myOpp2.closeDate=Date.today();
        myOpp2.Type_pers__c = label.Evolution;
        myOpp2.ContratOrigine__c = cont.id;
        myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        listOpp.add(myOpp2);
        Opportunity myOpp3 = testUtils.createOpportunity ('testOpp3', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp3.AccountId=myaccount.Id;
        myOpp3.closeDate=Date.today();
        myOpp3.Type_pers__c = Label.PV_Renouvellement;
        myOpp3.ContratOrigine__c = cont.id;
        myOpp3.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        listOpp.add(myOpp3);
        insert listOpp;
        test.startTest();
        LC71_AlerteEvolution_Controller.getOppEvol(myOpp2.id);
        LC71_AlerteEvolution_Controller.getOppEvol(myOpp3.id);
        myOpp2.ContratOrigine__c = null;
        update myOpp2;
        LC71_AlerteEvolution_Controller.getOppEvol(myOpp3.id);
        LC71_AlerteEvolution_Controller.getOppEvol(null);
        
        test.stopTest();
    }
}