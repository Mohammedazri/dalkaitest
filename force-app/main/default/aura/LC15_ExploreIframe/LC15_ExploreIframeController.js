({
	doInit : function(component, event, helper) {
        var action = component.get('c.getAccountSIRET');
        action.setParams({ AccountId : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                console.log('test alain' + response.getReturnValue());
                var iframeURL = response.getReturnValue();
                component.set("v.iframeURL", response.getReturnValue());
                //alert(response.getReturnValue());
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
	}
})