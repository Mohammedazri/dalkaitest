/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis 
Company: EI-Technologies
Description: Test Class for AP18_Contrat
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP18_Contrat_test {
    @isTest
    static void testContrat()
    {
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c=Label.WS11_OUV;
        insert a1;
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.alert6mois__c = true;
        insert c1;
        
        c1.DateProchaineEcheance__c= date.Today().addDays(175);
        c1.AvenantDateProchaineEcheance__c= date.Today().addDays(175);
        update c1;
        
        c1.DateProchaineEcheance__c= date.Today().addDays(172);
        c1.AvenantDateProchaineEcheance__c= date.Today().addDays(172);
        update c1;
        
        c1.DateProchaineEcheance__c= date.Today().addDays(185);
        c1.AvenantDateProchaineEcheance__c= date.Today().addDays(185);
        update c1;
        
        Contrat__c c2= new Contrat__c();
        c2.NomPartenaire__c=a1.Id;
        c2.DateProchaineEcheance__c= date.Today().addDays(172);
        insert c2;
        
    }
}