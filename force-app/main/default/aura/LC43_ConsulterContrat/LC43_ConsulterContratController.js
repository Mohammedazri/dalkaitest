({
    doInit : function(component, event, helper) {
        var synchronizeAction = component.get("c.consulterContrat");
        synchronizeAction.setParams({ 
            contractId : component.get("v.recordId")
        });
        synchronizeAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                helper.goToRecord(component, helper);
            }
        });
        $A.enqueueAction(synchronizeAction);
    }
})