({
    //Appel lors de l'initialisation
    doInit : function(component, event, helper) {
        var action = component.get("c.getCurrentObject");
        action.setParams({ 
            contId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") 
            {
                component.set("v.Currentrecord", response.getReturnValue());
                if (component.get("v.Currentrecord").ErrorMessage != null)
                {
                    component.set("v.IfNoError",false);
                }
                else
                {
                    component.set("v.IfNoError",true);
                }
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
        
    }
    
})