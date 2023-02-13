/**
* This class contains unit tests for validating the behavior of Apex classes LC06_PlanAction_Controller
*/
@isTest
public class LC06_PlanAction_Controller_Test {
    
    @isTest
    static void PlanDActionTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            Test.startTest(); 
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            insert myaccount;
            system.debug('myaccount'+myaccount);
            contact mycontact = testUtils.createContact('test 1', myaccount.Id, null);
            insert mycontact;
            contact mycontact2 = testUtils.createContact('test 2', myaccount.Id, mycontact.Id);
            mycontact2 .ReportsToId=mycontact.Id;
            insert mycontact2 ;
            
            
            List<task> MyTaskList = new List<task>();
            Task myTask3= testUtils.createTask(myaccount.Id,null, Date.today()-1, 'Relationnel client', 'Moyenne', 'Terminé' );
            myTask3.Action_strategie_compte__c=true;
            MyTaskList.add(myTask3);
            Task myTask= testUtils.createTask(myaccount.Id,null, Date.today()-1, 'Enjeux contractuels', 'Moyenne', 'Terminé' );
            MyTaskList.add(myTask);
            Task myTask2= testUtils.createTask(myaccount.Id,null, Date.today()-1,null, 'Elevée', 'Terminé' );
            myTask2.WhatId=myaccount.id;
            MyTaskList.add(myTask2);
            insert MyTaskList;
            
            Event myEvent= testUtils.createEvent(myaccount.Id,null, Date.today()-1,'Satisfaction client', 3); 
            myEvent.Action_strategie_compte__c=true;
            insert myEvent;
            
            //added by yorgo
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.CreerNouvelleFicheGONOGO__c =true;
            //myOpp.Record_type__c=Label.OppType_EvRen;
            insert myOpp;
            ProjetCommercial__c MyProjetCommercial= new ProjetCommercial__c(name='projet commercial',OpportunitCommerciale__c=myOpp.id);
            insert MyProjetCommercial;
            FicheGoNoGo__c MyGNGFiche= new FicheGoNoGo__c(name='Fiche',Projet_commercial__c=myOpp.id,ProjetCommercial__c=MyProjetCommercial.id);
            insert MyGNGFiche;
            myOpp.ProjetCommercial__c=MyProjetCommercial.id;
            myOpp.AccountId=myaccount.Id;
            update myOpp;
            
            StrategieCompte__c MyStrategie= new StrategieCompte__c(Compte__c=myaccount.id);
            insert MyStrategie;
            
            //End Yorgo
            
            system.debug('mycontact '+mycontact );
            LC06_PlanAction_Controller.getAccountPlans(myaccount.Id, true, true, true);
            LC06_PlanAction_Controller.getAccountPlans(myaccount.Id, false, true, true);
            LC06_PlanAction_Controller.getAccountPlans(myaccount.Id, false, false, true);
            LC06_PlanAction_Controller.getAccountPlans(myaccount.Id, false, false, false);
            LC06_PlanAction_Controller.getAccountPlans(myaccount.Id, true, false, false);
            LC06_PlanAction_Controller.getAccountPlans(myaccount.Id, false, true, false);
            Test.stopTest();
        }
    }
}