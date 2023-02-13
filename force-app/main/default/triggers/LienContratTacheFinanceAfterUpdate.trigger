/** 
* @author Jacques Akiki
* @date 03/09/2020 
* @description trigger LienContratTacheFinance After update
* @Test Class AP91_Contrat_test
*/
trigger LienContratTacheFinanceAfterUpdate on LienContratTacheFinance__c (after update) {
if(PAD.CanTrigger('AP91_Contrat')){
        AP91_Contrat.filterLCT(Trigger.new,Trigger.oldMap);
    }
}