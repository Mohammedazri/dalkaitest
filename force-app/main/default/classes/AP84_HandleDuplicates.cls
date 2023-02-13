/*
* @author Jacques Akiki
* @date 10/06/2020 
* @ Class to handle duplicate contacts on Opportunity and contract
* @test Class: AP84_HandleDuplicates_test
*/
public class AP84_HandleDuplicates {
    /*
* @author Jacques Akiki
* @date 10/06/2020 
* @ fill the field tech_Unique__c with id of opp anf id of contact to trigger duplicate rule
* @param listOppCont: list of OpportuniteContact__c
* @return void
*/
    public static void fillTechUniqueOpp(list<OpportuniteContact__c>listOppCont)
    {
        for(OpportuniteContact__c oppCont:listOppCont)
        {
            oppCont.tech_Unique__c = String.ValueOf(oppCont.Contact__c)+String.ValueOf(oppCont.Opportunite__c);
        }
    }
     /*
* @author Jacques Akiki 
* @date 10/06/2020 
* @fill the field tech_Unique__c with id of Contrat anf id of contact to trigger duplicate rule
* @param listCntCont: list of ContratContact__c
* @return void
*/
    public static void fillTechUniqueCont(list<ContratContact__c>listCntCont)
    {
        for(ContratContact__c cntCont:listCntCont)
        {
            cntCont.tech_Unique__c = String.ValueOf(cntCont.Contact__c)+String.ValueOf(cntCont.Contrat__c);
        }
    }

}