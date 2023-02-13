/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki 
Company: EI-Technologies
Description: Test Class for AP30_UpdateCAEcartMBrute
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP30_UpdateCAEcartMBrute_test{
    @isTest
    static void TestClass()
    {    
        account myaccount = testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.StatutPartenaire__c =label.WS11_OUV;
        insert myaccount;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.AccountId = myaccount.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c = Label.Evolution;
        myOpp.Tech_CdtRefSelectionnee__c = Label.LC12_Budget;
        insert myOpp;
        
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        /*Fiche_de_synthese__c ficheDeSythese = new Fiche_de_synthese__c();
ficheDeSythese.Opportunit_commerciale__c = myOpp.id;
ficheDeSythese.P1CaOf__c = 20;
ficheDeSythese.P1MbOf__c = 20;
ficheDeSythese.OffreA1P1VentesServices__c= 1;
ficheDeSythese.ConditionsDeReference__c=Label.LC12_Budget;
insert ficheDeSythese;*/
        
        Fiche_de_synthese__c ficheDeSythese= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        ficheDeSythese.P1CaOf__c = 20;
        ficheDeSythese.P1MbOf__c = 20;
        ficheDeSythese.OffreA1P1VentesServices__c= 1;
        ficheDeSythese.ConditionsDeReference__c=Label.LC12_Budget;
        update ficheDeSythese;
        
        test.startTest();
        myOpp.Tech_CdtRefSelectionnee__c = Label.LC12_Saisie;
        update myOpp;
        myOpp.Tech_CdtRefSelectionnee__c = Label.LC12_Budget;
        update myOpp;
        ficheDeSythese.OffreA1P1VentesServices__c= 5;
        ficheDeSythese.ConditionsDeReference__c=Label.LC12_Saisie;
        update ficheDeSythese;
        test.stopTest();
        
    }
}