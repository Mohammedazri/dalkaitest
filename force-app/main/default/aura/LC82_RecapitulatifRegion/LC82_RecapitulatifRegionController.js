({
 doInit : function (component, event, helper) {
     var action = component.get("c.getContratByRegion");
     action.setParams({
         AccId:component.get("v.recordId")
     });
     action.setCallback(this, function(response) {
         var state = response.getState();
         if (component.isValid() && state === "SUCCESS" ) 
         {
             component.set("v.ListRegion",response.getReturnValue());
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