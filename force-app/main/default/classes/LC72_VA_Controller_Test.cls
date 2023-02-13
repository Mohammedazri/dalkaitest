/**
* @author Dona Kfoury -EI Technologies
* @date 17/07/2020
* @description Test Class for LC72_VentesAdditionnelles_Controller
*/
@isTest
public class LC72_VA_Controller_Test {
    @testSetup static void CreateObjects() {

        List<Agence__c> listAgc = new List<Agence__c>();
        List<ObjectifAgence__c> listObjAgc = new List<ObjectifAgence__c>();
        
        Agence__c agc1 =  new Agence__c();
        agc1.Name = 'Agence1';
        agc1.Code_Agence__c = 'DCIST';
        agc1.dkcode__c='1234';
        listAgc.add(agc1);
        
        Agence__c agc2 =  new Agence__c();
        agc2.Name = 'Agence2';
        agc2.Code_Agence__c = 'DCN';
        agc2.DkCode__c='1235';
        listAgc.add(agc2);
        insert listAgc;
        CodeAgence_Region__c cr = new CodeAgence_Region__c();
        cr.Name = 'test';
        cr.Code__c = 'DCN';
        cr.DkCode__c = '1234';
        insert cr;
        
        Region__c reg = new Region__c();
        reg.name = 'testReg';
        reg.DkCode__c = '1234';
        insert reg;
        
        ObjectifAgence__c objAgc1 = new ObjectifAgence__c();
        objAgc1.AgenceId__c = agc1.id;
        objAgc1.Annee__c = '2019';
        objAgc1.name = '2019';
        objAgc1.tech_AgenceAnnee__c = agc1.id+'2019';
        listObjAgc.add(objAgc1);
        
        ObjectifAgence__c objAgc2 = new ObjectifAgence__c();
        objAgc2.AgenceId__c = agc2.id;
        objAgc2.Annee__c = '2018';
        objAgc2.name = '2018';
        objAgc2.tech_AgenceAnnee__c = agc2.id+'2018';
        listObjAgc.add(objAgc2);
        
        insert listObjAgc;
       
        
    }
    @isTest
    public static void LC72_TEST(){
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User usr = testUtils.CreateUser('tusr1', 'user1@testorgdalkia2.com', 'user1T', p.Id, 'user1@testorgdalkia2.com');
        usr.BypassValidationRules__c = true;
        usr.Bypass_Workflow__c = true;
        usr.Code_d_Appartenance__c = 'DCIST';
        usr.Nom_agence__c = 'Agence1';
        usr.Organisation__c='1234';
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
        LC72_VentesAdditionnelles_Controller.getTauxVA();
         }
        test.stopTest();
    }
    
}