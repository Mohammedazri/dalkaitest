/** 
* @author Jacques Akiki
* @date 03/09/2020 
* @description trigger LienContratTacheFinance After delete
* @Test Class AP91_Contrat_test
*/
trigger LienContratTacheFinanceAfterDelete on LienContratTacheFinance__c (after delete) {
if(PAD.CanTrigger('AP91_Contrat')){
        AP91_Contrat.filterLCT(null,Trigger.oldMap);
    }
}