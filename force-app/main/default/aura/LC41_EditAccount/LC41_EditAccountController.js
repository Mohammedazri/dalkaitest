({
    doInit : function(component, event, helper) {
        var synchronizeAction = component.get("c.synchronizeAccount");
        synchronizeAction.setParams({ 
            AccountId : component.get("v.recordId")
        });
        synchronizeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                helper.goToRecord(component, helper);
            }
        });
        $A.enqueueAction(synchronizeAction);
    },})