/**
* @author: Jimmy Khalil
* @date: 08/07/2022
* @description: Test Class for "AP116_Opportunity" 
*/
@isTest
public class AP116_Opportunity_Test {
    static testMethod void test()
    {
        list<Account> listAcc = new List<Account>();
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.StatutPartenaire__c='OUV';
        listAcc.add(a1);
        
        insert listAcc;
        opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp1.accountId=a1.Id;
        myOpp1.Segment_client__c = Label.SegmentOpp_Collectivites;
        myOpp1.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
        insert myOpp1;
        
        List<Fiche_de_synthese__c> relatedFDS = [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c = :myOpp1.Id];
        System.assertEquals(1, relatedFDS.size());
        
    }
    
}