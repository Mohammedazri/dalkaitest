/**
* @author Dona Kfoury -EI Technologies
* @date 03/09/2020
* @description Test Class for LC75_AgenceVA_Controller
*/
@isTest
public class LC75_AgenceVA_Controller_Test {
    @testSetup static void CreateObjects() {
        
         Agence__c agc1 =  testUtils.createAgence('CO - AGENCE ONE','DCIST','J00001203S');
         Agence__c agc2=  testUtils.createAgence('GE - AGENCE ONE','DCN','J00003660J');
         List<Agence__c> listAgc = new List<Agence__c>{agc1,agc2};   
         insert listAgc;
        
        
    }
    @isTest
    public static void LC75_TEST(){
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('tusr1', 'user1@testorgdalkia2.com', 'user1T', p.Id, 'user1@testorgdalkia2.com');
        usr.Code_d_Appartenance__c = 'DCIST';
        usr.Nom_agence__c = 'Agence1';
        usr.Organisation__c = 'J00001203S';
        insert usr;
        
        Datetime dateToday = System.today();
        Objectif__c obj1 = testUtils.CreateObjectif('testObj1', label.Objectif_RT_Commercial, String.ValueOf(dateToday.year()));
        obj1.Commercial__c = usr.Id;
        insert obj1;
        //create and insert Account
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.StatutPartenaire__c = 'OUV';
        insert a1;
        
        //create opp
        Opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, 'Piste');
        myOpp1.AccountId=a1.Id;
        myOpp1.closeDate=Date.today();
        myOpp1.ownerid = usr.Id;
        myOpp1.statut__c =Label.Opp_StatutEnCours;
        insert myOpp1;
        test.startTest();
        System.runAs(usr) {
            LC75_AgenceVA_Controller.getTauxVAAgence();
        }
        test.stopTest();
    }
}