({
    doInit : function(component, event, helper) {
        var synchronizeAction = component.get("c.synchronizeAccount");
        synchronizeAction.setParams({ 
            AccountId : component.get("v.recordId")
        });
        synchronizeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                 $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire(); 
            }
        });
        $A.enqueueAction(synchronizeAction);
    },})