({
    doInit : function(component, event, helper) {
        var action = component.get('c.getComment');
        action.setParams({ 
            recordId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.Currentrecord",response.getReturnValue());
      });
          $A.enqueueAction(action);
        },
})