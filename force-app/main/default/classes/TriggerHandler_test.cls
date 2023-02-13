/**
*@author Jacques Akiki
*@date 16/11/2022
*@description Test Class pour TriggerHandler
*/
@isTest
public class TriggerHandler_test {
    static testMethod void TriggerHandler_test(){   
        
        TriggerHandler th = new TriggerHandler();
        th.setMaxLoopCount(5);
        th.clearMaxLoopCount();
        th.beforeInsert();
        th.beforeUpdate();
        th.beforeDelete();
        th.afterInsert();
        th.afterUpdate();
        th.afterDelete();
        th.afterUndelete();
        TriggerHandler.LoopCount TriggerHandlerlc = new TriggerHandler.LoopCount();
        TriggerHandlerlc.exceeded();
        TriggerHandlerlc.getCount();
        TriggerHandlerlc.getMax();
        TriggerHandlerlc.increment();
        TriggerHandlerlc.setMax(5);
        TriggerHandler.clearAllBypasses();
    }
}