/**
 * @description       : Class de test du contrôleur du Lightning Web Component qui permet de faire le suivi des appels techniciens STI "LWC06_GestionSTI_CTRL"
 * @author            : Othmane Choulli
 * @group             : 
 * @last modified on  : 26-09-2022
 * @last modified by  : Othmane Choulli
**/

@isTest
public class LWC06_GestionSTI_CTRL_TEST {
   
    @testSetup
    static void makeData(){

        Id RT_DemandeSTI = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_STI').getRecordTypeId();
        Emplacement__c emplacement1 = testUtils.insertEmplacement('Emplacement 1', false, 'DKCode 1');
        Contact contact = testUtils.insertContact('FirstName', 'LastName', '06123456789', 'test@test.com');
        
        
        Case demande_duree_global = testUtils.insertDemandeDureeGlobal('Subject 1', RT_DemandeSTI, contact, emplacement1, 'A traiter');
        Case demande = testUtils.insertDemande('Subject 2', RT_DemandeSTI, contact, emplacement1, 'A traiter');
    }
    
    @isTest
    static void getData_Test() {
        
        List<Case> listeDemandes = testUtils.getAllDemande();
        
        Test.startTest();
            LWC06_GestionSTI_CTRL.STIWrapperResponse response = LWC06_GestionSTI_CTRL.getData(listeDemandes[0].Id);
        Test.stopTest();

    }

    @isTest
    static void setKO_Test() {
        
        List<Case> listeDemandes = testUtils.getAllDemande();
        
        Test.startTest();
            LWC06_GestionSTI_CTRL.setKO(listeDemandes[0].Id);
        Test.stopTest();

    }

    @isTest
    static void setOK_Test() {
        
       	List<Case> listeDemandes = testUtils.getAllDemande();
        
        Test.startTest();
            LWC06_GestionSTI_CTRL.setOK(listeDemandes[0].Id);
        	LWC06_GestionSTI_CTRL.setOK(listeDemandes[1].Id);
        	listeDemandes[1].EtapeSTI__c = 'Durée intervention';
        	LWC06_GestionSTI_CTRL.setOK(listeDemandes[1].Id);
        Test.stopTest();
    }

    @isTest
    static void prolongation_Test() {
        
        List<Case> listeDemandes = testUtils.getAllDemande();
        
        Test.startTest();
            LWC06_GestionSTI_CTRL.setProlongation(listeDemandes[0].Id, '20');
        Test.stopTest();
    }
}