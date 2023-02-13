({
	 doInit : function(component, event, helper) {
    	var action = component.get('c.getCurrentObject');
        
        action.setParams({ 
            ContratId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                //alert("From server: " + response.getReturnValue());
                console.log(response.getReturnValue());
                component.set("v.Currentrecord", response.getReturnValue());
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
    
    ExpandBelow : function(component, event, helper) {
        
        if(component.get("v.IfExpand"))
        {
            component.set("v.IfExpand", false);
        }
        else 
        {
            component.set("v.IfExpand", true);
        }
    }
})