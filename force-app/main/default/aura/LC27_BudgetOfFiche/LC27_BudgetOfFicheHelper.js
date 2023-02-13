({
	helperMethod : function(component) {
		var action = component.get("c.getID");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                //alert (response.getReturnValue());
                component.set("v.BudgetIDFromCont", response.getReturnValue());
            }
       });
        $A.enqueueAction(action);
	}
})