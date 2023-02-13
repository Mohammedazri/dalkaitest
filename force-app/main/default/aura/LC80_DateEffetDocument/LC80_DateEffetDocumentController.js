({
    doInit : function(component, event, helper) {
        var action = component.get('c.getCurrentObject');
        
        action.setParams({ 
            OppId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'show')
                {
                    component.set("v.showPopUp", true);
                    window.setTimeout(
                        $A.getCallback(function() {
                            var action2 = component.get('c.updateOpp');
                            action2.setParams({ 
                                OppId : component.get("v.recordId")
                            });
                            action2.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    console.log("SUCCESS");
                                }
                                else if (state === "INCOMPLETE") {
                                    console.log("INCOMPLETE");
                                }
                                    else if (state === "ERROR") {
                                        console.log("ERROR");
                                    }
                            })
                            $A.enqueueAction(action2);
                        }), 5000
                    );
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " + errors[0].message);
                        }
                        else{
                            console.log("Unknown error");
                        }
                    }
                }
        });
        $A.enqueueAction(action);
    },
    Cancel : function(component, event, helper) {
        var action = component.get('c.updateOpp');
        action.setParams({ 
            OppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("SUCCESS");
            }
            else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }
                else if (state === "ERROR") {
                    console.log("ERROR");
                }
        })
        $A.enqueueAction(action);
        component.set("v.showPopUp", false);
        $A.get("e.force:closeQuickAction").fire();
    }
    
})