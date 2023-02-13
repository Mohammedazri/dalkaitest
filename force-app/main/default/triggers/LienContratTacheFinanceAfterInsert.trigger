/** 
* @author Jacques Akiki
* @date 03/09/2020 
* @description trigger LienContratTacheFinance After Insert
* @Test Class AP91_Contrat_test
*/
trigger LienContratTacheFinanceAfterInsert on LienContratTacheFinance__c (after insert) {
if(PAD.CanTrigger('AP91_Contrat')){
        AP91_Contrat.filterLCT(Trigger.new,null);
    }
}