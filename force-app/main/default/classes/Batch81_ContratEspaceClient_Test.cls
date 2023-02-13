/**
* @author Dona Kfoury -EI Technologies
* @date 09/07/2020
* @description Test Class for Batch81_ContratEspaceClient
*/
@isTest
public class Batch81_ContratEspaceClient_Test {
     @isTest
    static void testEspaceClient() {
        
        Account myaccount=testUtils.createAccount('testAccount2', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
        myOpp1.AccountId=myaccount.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.statut__c =Label.Opp_StatutEnCours;
        insert myOpp1;
        
        Contrat__c cont = new Contrat__c(name='Contrat');
        cont.NomPartenaire__c = myaccount.Id; 
        cont.OpportuniteCommerciale__c = myOpp1.id;
        cont.EstContratcadre__c = true;
        insert cont;
        
        contact mycontact = testUtils.createContact('test 4', myaccount.Id, null);
        mycontact.IsContactEspaceClient__c = true;
        contact mycontact2 = testUtils.createContact('test 5', myaccount.Id, null);
        mycontact2.IsContactEspaceClient__c = true;
        List<Contact> listCons = new list<contact>{mycontact,mycontact2};
            insert listCons;
        ContratContact__c contactContrat = testUtils.createContactContrat(cont.Id, mycontact.Id);
        ContratContact__c contactContrat2 = testUtils.createContactContrat(cont.Id, mycontact2.Id);    
        List<ContratContact__c> listConConts = new list<ContratContact__c>{contactContrat,contactContrat2};
        insert listConConts;
        Test.startTest();            
        Id batchJobId = Database.executeBatch(new Batch81_ContratEspaceClient(), 2000);
        Test.stopTest();
    }

}