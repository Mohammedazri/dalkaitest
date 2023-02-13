/**
* @author: Jacques Akiki
* @date: 21/01/2021
* @description: Test Class for "Batch108_UpdateOppEcartP2" 
*/
@isTest
public class Batch108_UpdateOppEcartP2_test {
    static testMethod void test()
    {
        
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        
        Opportunity myOpp = TestUtils.createOpportunity('test',date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.Type_pers__c = Label.Evolution;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.ZZZ_Tech_Heures_P2_Ecart__c = 10;
        insert myOpp;
        
        /*Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
        fds.Opportunit_commerciale__c = myOpp.id;
        fds.ConditionsDeReference__c = 'Budget Corrigé';
        insert fds;*/
         //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
        
        for(Fiche_de_synthese__c fds:listFDS){
            fds.SaisieRefP1VentesServices__c=12;
            fds.OffreA1P1VentesServices__c=13;
            fds.ConditionsDeReference__c = 'Budget Corrigé';
        }
        Update listFDS;
        
        Test.startTest();
        Id batchId = Database.executeBatch(new Batch108_UpdateOppEcartP2());
        Test.stopTest();
    }
}