@isTest
public class LC38_OpportuniteFille_Controller_Test {
    static testMethod void testController() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;
        u2.BypassFilters__c = true;
        insert u2;
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        
        System.runAs(u2) {
            
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp.EstOpportuniteMere__c = true;
            myOpp.Type_pers__c = Label.Renouvellement;
            insert(myOpp);
            
           	opportunity myOppFille = testUtils.createOpportunity ('testOppFille', date.today(),null, 'Piste');
            myOppFille.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOppFille.Type_pers__c = Label.Renouvellement;
            myOppFille.OpportuniteMere__c = myOpp.Id;
            insert(myOppFille);
  
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id,OwnerID=u2.id);
            insert(mycontrat);
            Test.startTest();
            List<LC38_OpportuniteFille_Controller.WrapperClass> lstWrapper = new List<LC38_OpportuniteFille_Controller.WrapperClass>();
            LC38_OpportuniteFille_Controller.getStages();
            lstWrapper = LC38_OpportuniteFille_Controller.getOpportunitiesFilles(mycontrat.Id);
            for(LC38_OpportuniteFille_Controller.WrapperClass  wrap : lstWrapper){
                wrap.isSelected = true;
            }
            
            String wrapperSerialized1= (String) Json.serialize(lstWrapper);
            LC38_OpportuniteFille_Controller.saveOppFille(wrapperSerialized1);
            
            
            Test.stopTest();
        }
    }
    
}