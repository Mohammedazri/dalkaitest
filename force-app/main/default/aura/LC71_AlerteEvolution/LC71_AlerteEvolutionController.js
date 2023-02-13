({
    //Appel lors de l'initialisation
	doInit : function(component, event, helper) {
		var action = component.get("c.getOppEvol");
        action.setParams({ 
            OppId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                component.set("v.shouldAppear", response.getReturnValue());
            }
       });
        $A.enqueueAction(action); 
    }

})