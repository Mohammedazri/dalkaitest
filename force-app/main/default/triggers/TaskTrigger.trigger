/*
@Author : Jacques Akiki
@CreatedDate : 15/11/2022
@Description : Trigger on Task Object
*/
trigger TaskTrigger on Task (before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    new TaskTriggerHandler().run();

}