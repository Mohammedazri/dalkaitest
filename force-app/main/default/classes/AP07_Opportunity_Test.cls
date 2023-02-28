/*** The aim of this class is to test the functionality of the class AP07_Opportunity ***/
@isTest
public class AP07_Opportunity_Test {
    
    @isTest
    static void tesAP05_Opportunity()
    {
        siege__c siege1= new siege__c();
        siege1.Name='SIEGE GROUPE DALKIA';
        siege1.Code_Siege__c='DKSG';
        insert siege1;
        
        region__c region1= new region__c();
        region1.Name='DALKIA FRANCE REGION CENTRE EST';
        region1.code_region__c='OCES';
        region1.siege__c=siege1.Id;
        insert region1;
        
        List<Agence__c> AgenveList= new List<Agence__c>();
        agence__c agence1= new agence__c();
        agence1.Name='AGENCE COMMERCIALE MARCHE SANTE ET GRAND PROJETS';
        agence1.code_agence__c='OCESCOM2';
        agence1.region__c=region1.Id;
        agence1.DkCode__c = 'A-1234';
        AgenveList.add(agence1);
        
        agence__c agence2= new agence__c();
        agence2.Name='AGENCE COMMERCIALE MARCHE INDUSTRIE';
        agence2.code_agence__c='OCESCOM1';
        agence2.DkCode__c = 'A-1235';
        agence2.region__c=region1.Id;
        AgenveList.add(agence2);
        
        insert AgenveList;
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        Profile p1 = [SELECT Id FROM Profile WHERE name='Commercial'];
        
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.Code_d_Appartenance__c='OCESCOM2';
        u1.Organisation__c = 'A-1234';
        insert u1;
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        u2.Organisation__c = 'A-1235';
        insert u2;
        
        User u3 = testUtils.CreateUser('standt23', 'user2133@testorg2.com', 'Testing3', p1.Id, 'user3rrr@testorg3.com');
        u3.Code_d_Appartenance__c='OCESCOM2';
        u3.BypassValidationRules__c =true;
        u3.ManagerId=u1.id;
        insert u3;
        
        System.runAs(u2) 
        {
            
            Test.startTest();
            
            List<Objectif__c> ListObj2= new List<Objectif__c>();
            Objectif__c obj1=testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.valueof(System.Today().year()));
            obj1.Commercial__c=u1.Id;
            obj1.AgenceDeObjectif__c=agence1.id;
            ListObj2.add(obj1);
            insert obj1;
            updateobj(obj1);
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Annee_de_signature__c=String.valueof(System.Today().year());
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
            myOpp.Amount=5;
            myOpp.Type_pers__c='Renouvellement';
            myOpp.OwnerId=u1.Id;
            insert myOpp; 
            myOpp.Libelle_Agence__c = agence1.id;
            System.assertEquals('C' + myOpp.CloseDate.year() + '_' + string.valueof(myOpp.OwnerId).left(15) +'_'+string.valueof(myOpp.Libelle_Agence__c).left(15), 'C'+ obj1.Annee__c + '_' + string.valueof(obj1.Commercial__c).left(15)+ '_' +string.valueof(obj1.AgenceDeObjectif__c).left(15));
            
            obj1.Annee__c=String.valueof(System.Today().year()+1);
            obj1.Commercial__c=u2.Id;
            update obj1;
            updateobj(obj1);
            
            myOpp.OwnerId=u2.Id;
            myOpp.Amount=2;
            myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c='Evolution';
            update myOpp;
            
            System.assertNotEquals('C' + myOpp.Annee_de_signature__c + '_' + string.valueof(myOpp.OwnerId).left(15), 'C'+ obj1.Annee__c + '_' + string.valueof(obj1.Commercial__c).left(15));
        }
        
        Test.stopTest();
    }
    
    
    Static void updateobj(Objectif__c obj)
    { 
        obj.TECH_Unique__c= 'C'+ obj.Annee__c + '_' + string.valueof(obj.Commercial__c).left(15); 
        update obj;
    }
}