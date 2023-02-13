({
		doInit : function(component, event, helper) {
		var action = component.get('c.getAccountContacts');
        action.setParams({ AccountId : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                //alert("From server: " + response.getReturnValue());
				console.log(response.getReturnValue());
                component.set("v.listWrapper", response.getReturnValue());
                //alert(component.get("v.listWrapper"));
            }
            else if (component.isValid() && state === "INCOMPLETE") {
            }
            else if (component.isValid() && state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},

})