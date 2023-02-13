/*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: Test Class for Batch119_ObjectifRegional
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch119_ObjectifRegional_Test {
    @isTest
    static void shareObjectifTest() {
        Profile p = [SELECT Id FROM Profile WHERE id=: Label.AdminProfileId ];
        
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        insert myaccount;
        
        Siege__c siege = new Siege__c();
        siege.Name = 'Dalkia';
        siege.Code_Siege__c = 'SIE12';
        
        insert siege;
        
        Region__c reg = new Region__c();
        reg.Name = 'Paris';
        reg.Siege__c = siege.Id;
        reg.Code_Region__c = 'REG12';
        
        insert reg;
        
        Agence__c agc1 =  new Agence__c();
        agc1.Name = 'agence1';
        agc1.Code_Agence__c = 'DCIST';
        agc1.Region__c = reg.Id;
        agc1.DkCode__c ='12345';
        insert agc1;
        
        String objRegionalRTId = Schema.getGlobalDescribe().get('Objectif__c').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.Objectif_regional).getRecordTypeId();
        
        
        List<User>listUsers= new List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.Grands_Comptes__c = false;
        u1.Contrats_Nationaux__c = false;
        listUsers.add(u1);
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassFilters__c = true;
        listUsers.add(u2);
        
        Insert listUsers;
        System.runAs(u2) {
            
            Test.startTest();
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Annee_de_signature__c=String.valueof(System.Today().year());
            myOpp.RecordTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Amount=5;
            myOpp.Type_pers__c= Label.Renouvellement;
            myOpp.OwnerId=u1.Id;
            myOpp.Annee_de_signature__c = String.valueOf(System.Today().year());
            myOpp.Libelle_Agence__c = agc1.Id;
            insert myOpp; 
            
            // List<Opportunity> lstOpp = [SELECT id,Libelle_Region__c,Annee_de_signature__c FROM Opportunity];
            
            
            List<objectif__c>ListObjectifs=new List<objectif__c>();
            objectif__c obj1=testUtils.CreateObjectif('testObj1', objRegionalRTId, String.valueof(System.Today().year()));
            obj1.Commercial__c=u1.Id;
            obj1.RegionRegion__c = reg.Id;
            insert obj1;
            /*obj1.Commercial__c=u2.Id;
update obj1;*/
            Test.stopTest();
            
            Map<String,String> mapRegionAnneIdObj = new Map<String,String>();
            Set<String> setRegion = new Set<String>();
            Set<String> setAnnee = new Set<String>();
            
            setRegion.add('Paris');
            
            
            setAnnee.add(String.valueof(System.Today().year()));
            
            
            mapRegionAnneIdObj.put('Paris' + '_' + String.valueof(System.Today().year()),obj1.Id);
            
            Batch119_ObjectifRegional myBatch= new Batch119_ObjectifRegional();
            myBatch.mapRegionAnneIdObj = mapRegionAnneIdObj;
            myBatch.setRegion = setRegion;
            myBatch.setAnnee = setAnnee;
            ID batchprocessid = Database.executeBatch(myBatch,200);
        }
    }
}