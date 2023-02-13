({
 doInit : function (component, event, helper) {
        var action = component.get("c.getProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS" && response.getReturnValue()!=null) 
            {
                component.set("v.hasAccessToFullView", response.getReturnValue());
            }
            else if(response.getReturnValue()==null)
            {
                component.set("v.error", $A.get("$Label.c.LC81_ErrorMsg1"));
            }
            else if (state === "INCOMPLETE") {
                console.log("State is incomplete");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action); 
     
    },
})