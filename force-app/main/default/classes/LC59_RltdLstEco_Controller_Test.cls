@isTest
public class LC59_RltdLstEco_Controller_Test {
  @isTest
    public static void  testController()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            // create an account
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            
            // create an account
            account myaccount1= new Account(Name= 'testAccount2', BillingCountry ='France', Type= 'Privé', Code_NACE__c='222', NaturePartenaire__c='PART',SIRET__c='3920443',Segment_client__c='SCL04',Categorie_partenaire__c='EDF',/*Statut__c='Actif',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test2', BillingPostalCode='213', BillingState='vvv', BillingStreet='bbb', RecordtypeId=Label.PartenaireSociete);
            insert myaccount1;
            
            // create an Opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(); 
            myOpp.Type_pers__c=Label.LC28_TypeNouveau;
            insert myOpp;
            
            Test.startTest();
            // create an EcosystemePartenaire__c
            EcosystemePartenaire__c eco = new EcosystemePartenaire__c ( PartenaireLie__c=myaccount1.Id , Opportunite__c= myOpp.ID,TypeRelation__c = 'Représenté par'); 
            insert eco;
            
            List<EcosystemePartenaire__c> ecoSys= LC59_RelatedListEco_Controller.getEcoSystems( myaccount.id);
            List<String> str= LC59_RelatedListEco_Controller.deleteEco(eco.ID);
            
            Test.stopTest();
        }
    }
}