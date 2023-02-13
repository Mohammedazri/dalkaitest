/**
* @author: Charbel Khoury Hanna
* @date: 22/06/2022
* @description: Test Class for "AP113_ContratContact" 
*/
@istest
public class AP113_ContratContact_Test {

    @testSetup static void setup() {
        account myaccount= testUtils.createAccount('TEST1', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        opportunity myOpp = testUtils.createOpportunity ('testContrat', date.today(),Label.OpportunityStatusEnCours, 'Piste');
        myOpp.accountId=myaccount.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c=Label.PV_Evolution;
        myOpp.Annee_de_signature__c='2017';
        insert myOpp;
        Contrat__c contrat = new Contrat__c();
        contrat.Name = 'TESTCONTRAT';
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat.TypeContrat__c = 'IND';
        contrat.OpportuniteCommerciale__c = myOpp.id;
        contrat.NomPartenaire__c = myaccount.id;
        insert contrat;
    }
    
    static testMethod void deleteContactContrat()
    {
        Account myaccount = [SELECT id FROM Account limit 1];
        Contrat__c contrat = [SELECT id FROM Contrat__c limit 1];
        contact mycontact = testUtils.createContact('test 4', myaccount.Id, null);
        insert mycontact;
        ContratContact__c cc = new ContratContact__c(contact__c =mycontact.id,contrat__c =contrat.id);
        insert cc;
        TEST.startTest();
        try{
            delete cc;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP113_ErrorMsg));
        }
        TEST.stopTest();
    }
}