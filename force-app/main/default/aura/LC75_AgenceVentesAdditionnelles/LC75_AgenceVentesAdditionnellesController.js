({
    //méthode appelé lors de l'initialisation du composant
    doInit : function(component, event, helper) {
        component.set("v.spinner", true);
        //chercher le taux de vente additionnelles de l'agence du DAC courant
        var action = component.get('c.getTauxVAAgence');
        action.setCallback(this, function(response) {
            component.set("v.spinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.TauxVentesAgence", response.getReturnValue()); 
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