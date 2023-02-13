/*
* @Description: test Class used to cover LC33_RelatedListEchoOnOpp_Controller
* @Author: Johny Kassis
* @Date: 11/06/2018
* @Class: LC33_RelatedListEchoOnOpp_Controller
*/
@isTest
public class LC33_RltListEchoOnOpp_Controller_Test 
{
    
    @isTest
    static void  testController()
    {
        /*Create account and SDV*/
        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345','a1234567');
        Account a2 = testUtilsC360.createAccount('testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233','b1234567');
        Account a3 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '9999999','c1234567');
        List<Account> listAcc = new list<Account>{a1,a2,a3};   
        insert listAcc;
        /*Create Active Contact*/
        Contact c1 = testUtilsC360.createContact('Test', a1.Id, null, true);
        Insert c1;
        /*Create Opportunity*/
        Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
        Opportunity opp2 = testUtilsC360.createOpportunityIndepNouveau('testOpp2', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId());
        Insert new List<Opportunity> {opp1,opp2};
            
        /*Complete Opportunity FDS*/
        testUtilsC360.completeeFDS(new set<Id> {opp1.Id});
		/*Set Contcat for Opportnity*/
        OpportuniteContact__c oppCont1 = testUtilsC360.createOpportunityContrat(opp1.Id, c1.Id);
        Insert new List<OpportuniteContact__c> {oppCont1};
        opp1 = testUtilsC360.realiseOpportunity(opp1);
        Update new List<Opportunity> {opp1};
        
        Test.startTest();
        
        // create an EcosystemePartenaire__c
        EcosystemePartenaire__c eco= new EcosystemePartenaire__c ( PartenaireLie__c=a3.Id , Opportunite__c= opp2.id, TypeRelation__c = Label.LC33_type); 
        insert eco;
        
        // create an EcosystemePartenaire__c
        Opportunity oppTotal = [SELECT Contrat_Genere_lookup__c FROM Opportunity where id =:opp1.id];
        EcosystemePartenaire__c eco1= new EcosystemePartenaire__c (PartenaireLie__c=a3.Id , Contrat__c= oppTotal.Contrat_Genere_lookup__c, TypeRelation__c = Label.LC33_type); 
        //insert eco1;
        
        
        
        // call the functions of the Apex Controller LC33_RelatedListEchoOnOpp_Controller
        List<EcosystemePartenaire__c> ecoSys= LC33_RelatedListEchoOnOpp_Controller.getEcoSystems( opp1.id);
        String accID=LC33_RelatedListEchoOnOpp_Controller.getAccountID(opp1.id);
        List<String> str= LC33_RelatedListEchoOnOpp_Controller.deleteEco(eco.ID);
        
        List<EcosystemePartenaire__c> ecoSys2= LC33_RelatedListEchoOnOpp_Controller.getEcoSystems( oppTotal.Contrat_Genere_lookup__c);
        String accID2 = LC33_RelatedListEchoOnOpp_Controller.getAccountID(oppTotal.Contrat_Genere_lookup__c);
        
        Boolean b1 = LC33_RelatedListEchoOnOpp_Controller.getStatut(opp1.id);
        Boolean b2 = LC33_RelatedListEchoOnOpp_Controller.getStatut(oppTotal.Contrat_Genere_lookup__c);
        
        Test.stopTest();
    }
    
    
}