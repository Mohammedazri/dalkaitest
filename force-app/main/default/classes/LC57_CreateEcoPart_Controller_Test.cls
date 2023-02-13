@isTest
public class LC57_CreateEcoPart_Controller_Test {
 @isTest
    static void  testController()
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
            insert myaccount;
            // create an account
            account myaccount1= new Account(Name= 'testAccount2', BillingCountry ='France', Type= 'Privé', Code_NACE__c='222', NaturePartenaire__c='PART',SIRET__c='3920443',Segment_client__c='SCL04',Categorie_partenaire__c='EDF',/*Statut__c='Actif',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test2', BillingPostalCode='213', BillingState='vvv', BillingStreet='bbb', RecordtypeId=Label.PartenaireSociete);
            myaccount1.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount1;
            // create an Opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),'En cours', 'Piste');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Amount=3;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(); 
            myOpp.Type_pers__c=Label.LC28_TypeNouveau;
            insert myOpp;
            // create a Contrat__c
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=myaccount1.Id;
            c1.OwnerID=u2.id;
            insert c1; 
            
            // create contacts 
           	contact mycontact = testUtils.createContact('test 2', myaccount.Id, null);
        	insert mycontact;
            
            contact mycontact1 = testUtils.createContact('test 1', myaccount1.Id, null);
        	insert mycontact1;
            
            // create an EcosystemePartenaire__c
            EcosystemePartenaire__c eco = new EcosystemePartenaire__c ( PartenaireLie__c=myaccount.Id , TypeRelation__c = 'Représenté par', tech_OpportuniteSansFiltre__c= myOpp.ID); 
            // create an EcosystemePartenaire__c
            EcosystemePartenaire__c eco1= new EcosystemePartenaire__c ( PartenaireLie__c=myaccount.Id , tech_ContratSansFiltre__c= c1.ID); 
            // create an EcosystemePartenaire__c 
            EcosystemePartenaire__c eco2 = new EcosystemePartenaire__c (PartenaireLie__c=myaccount1.Id , Opportunite__c= myOpp.ID, ContactDuPartenaireLie__c = mycontact.id); 
            // create an EcosystemePartenaire__c
            EcosystemePartenaire__c eco3 = new EcosystemePartenaire__c (  PartenaireLie__c=myaccount1.Id , Opportunite__c= myOpp.ID, ContactDuPartenaireLie__c = mycontact.id); 
            
            Test.startTest();
            // call the functions of the Apex Controller LC57_CreateNewEcoSysPart_Controller
            List<String> str1 = LC57_CreateNewEcoSysPart_Controller.createEcoSystem(myOpp.ID, eco, true);
            List<String> str2 = LC57_CreateNewEcoSysPart_Controller.createEcoSystem(myOpp.ID, eco1,true);
            List<String> str3 = LC57_CreateNewEcoSysPart_Controller.createEcoSystem(myOpp.ID, eco2,true); 
            List<String> str4 = LC57_CreateNewEcoSysPart_Controller.createEcoSystem(myOpp.ID, eco3,true); 
            sObject Acc = LC57_CreateNewEcoSysPart_Controller.showCurrentOppOrContract('Account',myaccount.Id);
            sObject Contact = LC57_CreateNewEcoSysPart_Controller.showCurrentOppOrContract('Contact',mycontact.Id);
            Test.stopTest();
            
        }
    }
}