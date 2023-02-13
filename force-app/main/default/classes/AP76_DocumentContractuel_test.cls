@isTest
public class AP76_DocumentContractuel_test {
    static testMethod void testUpdatePartenaire()
    {
        
        Contrat__c contrat = new Contrat__c();
        contrat.Name = 'testContrat2';
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat.TypeContrat__c = 'IND';
        insert contrat;
        
        Document_Contractuel__c DC1 = new Document_Contractuel__c();
        DC1.TitreDocument__c = 'test1';
        DC1.NumeroPiece__c='123';
        DC1.NatureDocument__c = 'DOC02';
        DC1.StatutDocument__c = 'ACT';
        DC1.Contrat__c = contrat.Id;
        DC1.DateSignature__c = Date.today();
        DC1.DatePriseEffet__c = Date.Today();
        insert DC1;
        Test.startTest();
        try
        {
            delete DC1;
        }
        catch(exception e){
            string errorMsg = e.getMessage();
            system.assertEquals(true, errorMsg.contains(Label.AP76_PreventDelete));
        }
        Test.stopTest();
    }
}