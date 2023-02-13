@istest
public class Batch68_StatutFerme_test {
    static testMethod void RTChange()
    {
        profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create user and	 add bypass
        User u2 = testUtils.CreateUser('TestRT', 'TestRTCont@dalkia.fr', 'TestRT', p.Id, 'TestRTCont@dalkia.fr');
        u2.BypassValidationRules__c =true;
        u2.Bypass_Workflow__c =true;
        insert u2;
        System.runAs(u2)
        {
            Contrat__c contrat = new Contrat__c();
            contrat.Name = 'TESTCONTRAT';
            PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
            contrat.TypeContrat__c = 'IND';
            contrat.Statut__c =  Label.ContratFerme;
            insert contrat;  
            Test.startTest();
            Id BatchId = Database.executeBatch(new Batch68_StatutFerme());
            Test.stopTest();
        }
    }
}