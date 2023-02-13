/*
@Author : Jacques Akiki
@CreatedDate : 15/11/2022
@Description : Task Trigger Handler.
*/
public class TaskTriggerHandler extends TriggerHandler implements ITriggerHandler{
    private Map<Id, Task> newMap;
    private Map<Id, Task> oldMap;
    private List<Task> TriggerNew;
    private List<Task> TriggerOld;
    
    public TaskTriggerHandler(){
        this.newMap = (Map<Id, Task>) Trigger.newMap;
        this.oldMap = (Map<Id, Task>) Trigger.oldMap;
        this.TriggerNew= (List<Task>) Trigger.New;
        this.TriggerOld= (List<Task>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        
    }
    public override void afterInsert() {
        if(PAD.canTrigger('AP119_Task')){
            AP119_Task.notifyUser(TriggerNew);
        }
        
    }
    public  override void beforeUpdate() {

    }
    public override void afterUpdate() {
        
    }
    public override void beforeDelete() {
        
    }
    public override void afterDelete() {
        
    }
    
    public override void afterUnDelete() {
        
    }
}