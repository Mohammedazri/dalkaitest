({
    //méthode appelé lors de l'initialisation du composant
    doInit : function(component, event, helper) {
        component.set("v.spinner", true);
        //chercher le taux d'adoption à l'Espace Client de l'utilisateur actuel
        var action = component.get('c.getTauxVA');
        action.setCallback(this, function(response) {
            component.set("v.spinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.TauxVentes", response.getReturnValue()); 
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
    }
})