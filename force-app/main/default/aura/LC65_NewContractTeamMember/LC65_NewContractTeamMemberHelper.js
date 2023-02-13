({
    //get contract name from apex
    getContract : function(component, event, helper){
        component.set('v.loaded',true);
        var action = component.get("c.getContractName");
        action.setParams({
            contractId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var myContractName = response.getReturnValue();
                component.set("v.ContractName", myContractName);
                component.set('v.loaded',false);
            }
            else if (state === "INCOMPLETE") {
                component.set("v.error", $A.get("$Label.c.LC66_Erreur_Survenue"));
                component.set("v.ifErrorExists",true);
                component.set('v.loaded',false);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            component.set("v.error", errors[0].message);
                            component.set("v.ifErrorExists",true);
                            component.set('v.loaded',false);
                        }
                    } else {
                        component.set("v.error", $A.get("$Label.c.LC66_Erreur_Survenue"));
                        component.set("v.ifErrorExists",true);
                        component.set('v.loaded',false);
                    }
                }
        })
        $A.enqueueAction(action);
    },
    
    //get users verifying the filters
    getUsers : function(component, event, helper){
        var action = component.get("c.getUsersWrp");
        action.setParams({
            searchKey : component.get("v.memberName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var list = response.getReturnValue();
                component.set("v.picklistValues", list);
            }
            else if (state === "INCOMPLETE") {
                /*component.set("v.error", $A.get("$Label.c.LC66_Erreur_Survenue"));
                component.set("v.ifErrorExists",true);*/
                var emptyArray = [];
                component.set("v.picklistValues",emptyArray);
                component.set('v.loaded',false);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            /*component.set("v.error", errors[0].message);
                            component.set("v.ifErrorExists",true);*/
                            var emptyArray = [];
                            component.set("v.picklistValues",emptyArray);
                            component.set('v.loaded',false);
                        }
                    } else {
                        /*component.set("v.error", $A.get("$Label.c.LC66_Erreur_Survenue"));
                        component.set("v.ifErrorExists",true);*/
                        var emptyArray = [];
                        component.set("v.picklistValues",emptyArray);
                        component.set('v.loaded',false);
                    }
                }
        })
        $A.enqueueAction(action);
    },
    
    // create contract team member in apex
    createMember : function(component, event, helper){
        component.set('v.loaded',true);
        console.log(component.get("v.idChosen"));
        var mymembre = component.get("v.membre");
        if(mymembre.Role__c) {
            if(!(component.get("v.nameChosen")) || component.get("v.nameChosen") != component.get("v.memberName"))
            {
                //the user changed the name of the user after choosing one
                component.set("v.error", $A.get("$Label.c.LC66_Choisir_utilisateur_Valide"));
                component.set("v.ifErrorExists",true);
                component.set('v.loaded',false);
            }
            else{
                //create member
                var action = component.get("c.createContractMember");
                action.setParams({
                    user : component.get("v.idChosen"),
                    contrat: component.get("v.recordId"),
                    role: mymembre.Role__c
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        console.log('result'+result)
                        if(result == 'errorDup'){
                            component.set("v.error",  $A.get("$Label.c.LC66_DupMembres"));
                            component.set("v.ifErrorExists",true);
                            component.set('v.loaded',false);
                        }
                        else{                                     
                            /*var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": component.get("v.recordId"),
                                "slideDevName": "detail"
                            });
                            navEvt.fire();*/
                            window.parent.location = '/' + component.get("v.recordId");
                            component.set('v.loaded',false);
                        }
                    }
                    else if (state === "INCOMPLETE") {
                        component.set("v.error",  $A.get("$Label.c.LC66_Erreur_Survenue"));
                        component.set("v.ifErrorExists",true);
                        component.set('v.loaded',false);
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message);
                                    component.set("v.error", errors[0].message);
                                    component.set("v.ifErrorExists",true);
                                    component.set('v.loaded',false);
                                }
                            } else {
                                component.set("v.error",  $A.get("$Label.c.LC66_Erreur_Survenue"));
                                component.set("v.ifErrorExists",true);
                                component.set('v.loaded',false);
                            }
                        }
                })
                $A.enqueueAction(action);
            }
        }
        else
        {
            //empty fields
            component.set("v.error", $A.get("$Label.c.LC66_Choisir_Role"));
            component.set("v.ifErrorExists",true);
            component.set('v.loaded',false);
        }
    }
})