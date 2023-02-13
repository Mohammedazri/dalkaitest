({
	doInit : function(component, event, helper) {
        var action = component.get('c.getOppCont');
        action.setParams({ 
            AccId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            component.set("v.ContOppWrapList", response.getReturnValue()); 
        });
        
        $A.enqueueAction(action);
    },
	
})