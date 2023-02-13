/** test class for the class chartjsController **/
@isTest
public class test_chartjsController {
    
    @isTest
    public static void test_lineChart(){
        string chartjsData = chartjsController.getChartjsData('chartjsSampleLineChartDataProvider', '');
        system.assertEquals('{"labels":["Jan","Feb","Mar","Apr","May","Jun","Jul"],"datasets":[{"strokeColor":"rgba(220,220,220,1)","pointStrokeColor":"#fff","pointHighlightStroke":"rgba(220,220,220,1)","pointHighlightFill":"#fff","pointColor":"rgba(220,220,220,1)","label":"My First dataset","fillColor":"rgba(220,220,220,0.2)","data":[65,59,80,81,56,55,40]},{"strokeColor":"rgba(151,187,205,1)","pointStrokeColor":"#fff","pointHighlightStroke":"rgba(151,187,205,1)","pointHighlightFill":"#fff","pointColor":"rgba(151,187,205,1)","label":"My Second dataset","fillColor":"rgba(151,187,205,0.2)","data":[28,48,40,19,86,27,90]}]}', chartjsData);
    }
    
    @isTest
    public static void test_pieChart(){
        
        string chartjsData = chartjsController.getChartjsData('chartjsSamplePieChartDataProvider','');
        system.assertEquals('[{"value":300,"label":"Red","highlight":"#FF5A5E","color":"#F7464A"},{"value":50,"label":"Green","highlight":"#5AD3D1","color":"#46BFBD"},{"value":100,"label":"Yellow","highlight":"#FFC870","color":"#FDB45C"}]', chartjsData);
    }
    
    @isTest
    public static void test_GonogoChart(){
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
        myOpp.accountId=myaccount.Id;
        myOpp.CreerNouvelleFicheGONOGO__c = true;
        myOpp.Statut__c='En cours';
        myOpp.Type_pers__c ='Renouvellement';
        myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        insert myOpp;
        
        FicheGoNoGo__c ficheGonogo = new FicheGoNoGo__c(
        interet_strategique_et_financier__c = 10, 
        score_client__c = 9,
        score_commerce__c = 12,
        Projet_Commercial__c=myOpp.Id,
        score_exploitation__c=23);
        insert ficheGonogo;
        
        string chartjsData = chartjsController.getChartjsData('chartjsGonogoChart',ficheGonogo.Id);
       //system.assertEquals('[{"value":300,"label":"Red","highlight":"#FF5A5E","color":"#F7464A"},{"value":50,"label":"Green","highlight":"#5AD3D1","color":"#46BFBD"},{"value":100,"label":"Yellow","highlight":"#FFC870","color":"#FDB45C"}]', chartjsData);
    
    }
}