/** 
* @author Jacques Akiki
* @date 03/09/2020 
* @description trigger Projet Finance after update
* @Test Class AP91_Contrat_test
*/
trigger ProjetFinanceAfterUpdate on ProjetFinance__c (after update) {
if(PAD.CanTrigger('AP91_Contrat')){
        AP91_Contrat.filterPF(Trigger.new,Trigger.oldMap);
    }
}