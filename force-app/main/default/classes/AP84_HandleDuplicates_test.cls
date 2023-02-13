@isTest
public class AP84_HandleDuplicates_test {
    @isTest
    static void testDuplicates() {
        Account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
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
        insert mycontact;
        
        test.starttest();
        OpportuniteContact__c oc = new OpportuniteContact__c(contact__c =mycontact.id,opportunite__c =myOpp1.id);
        insert oc;
        ContratContact__c cc = new ContratContact__c(contact__c =mycontact.id,contrat__c =cont.id);
        insert cc;
        update oc;
        update cc;
        test.stopTest();
    }
}