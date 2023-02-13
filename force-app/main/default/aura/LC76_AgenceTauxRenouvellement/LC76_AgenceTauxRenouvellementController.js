({
	//méthode appelé lors de l'initialisation du composant
    doInit : function(component, event, helper) {
        component.set("v.spinner", true);
        //chercher le taux de renouvellement de l'agence du DAC courant
        var action = component.get('c.getTauxRenouvellementAgence');
        action.setCallback(this, function(response) {
            component.set("v.spinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.TauxRenouvellement", response.getReturnValue()); 
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
        
        //chercher dynamiquement l'url du rapport
        var action2 = component.get('c.getRapport');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.idRapport", response.getReturnValue()); 
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
        $A.enqueueAction(action2);
    }
})