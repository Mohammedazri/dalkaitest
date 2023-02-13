({
    CheckOpp : function(component) {
        var action = component.get('c.getCurrentObject');
        
        action.setParams({ 
            OppId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'profile')
                {
                    component.set("v.errorMessage", $A.get("$Label.c.LC78_ErreurProfile"));
                    component.set("v.showError", true);
                }
                else if (response.getReturnValue() == 'opp')
                {
                    component.set("v.errorHeight", "height: 180px");
                    component.set("v.errorMessage", $A.get("$Label.c.LC78_ErreurOpportunite"));
                    component.set("v.errorMessageEvo", $A.get("$Label.c.LC78_ErreurOpportuniteEvo"));
                    component.set("v.showError", true);
                }
                    else if (response.getReturnValue() == 'ok')
                    {
                        component.set("v.showError", false);
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
    LoadNaturePicklist: function(component) {
        var action = component.get('c.GetNaturePicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Natures", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getCurrentOppMere : function(component, event, helper){
        var action = component.get("c.getCurrentOppMere");
        action.setParams({
            OppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opp = response.getReturnValue();
                component.set("v.currentOppMere", opp);
                component.set("v.idChosen", opp.Id);
                component.set("v.oppName",opp.Name);
                component.set("v.nameChosen",opp.Name);
                component.set("v.natureChosen",opp.Nature);
                component.set("v.Spinner", false); 
            }
            else if (state === "INCOMPLETE") {
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
                            var emptyArray = [];
                            component.set("v.picklistValues",emptyArray);
                            component.set('v.loaded',false);
                        }
                    } else {
                        var emptyArray = [];
                        component.set("v.picklistValues",emptyArray);
                        component.set('v.loaded',false);
                    }
                }
        })
        $A.enqueueAction(action);
    },
    getOpps : function(component, event, helper){
        var action = component.get("c.getOppssWrp");
        action.setParams({
            searchKey : component.get("v.oppName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var list = response.getReturnValue();
                component.set("v.picklistValues", list);
            }
            else if (state === "INCOMPLETE") {
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
                            var emptyArray = [];
                            component.set("v.picklistValues",emptyArray);
                            component.set('v.loaded',false);
                        }
                    } else {
                        var emptyArray = [];
                        component.set("v.picklistValues",emptyArray);
                        component.set('v.loaded',false);
                    }
                }
        })
        $A.enqueueAction(action);
    },
    
    // create contract team member in apex
    updateOpp : function(component, event, helper){
        if(component.get("v.canSave")){
            component.set("v.Spinner", true); 
            console.log(component.get("v.idChosen"));
            var mymembre = component.get("v.membre");
            //create member
            var action = component.get("c.updateOppMere");
            action.setParams({
                oppId : component.get("v.recordId"),
                oppMereId: component.get("v.idChosen"),
                Nature: component.get("v.natureChosen")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.Spinner", false); 
                    var msg = response.getReturnValue();
                    if(msg == "success"){
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                    }
                    else{
                        component.set("v.errorMessage",  msg);
                        component.set("v.showError",true);
                    }
                }
                else if (state === "INCOMPLETE") {
                    component.set("v.errorMessage",  'Erreur lors de la mise a jour de l\'enregistrement');
                    component.set("v.showError",true);
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                component.set("v.errorMessage",  errors[0].message);
                                component.set("v.showError",true);
                            }
                        } else {
                            component.set("v.errorMessage",  'Erreur lors de la mise a jour de l\'enregistrement');
                            component.set("v.showError",true);                   
                        }
                    }
            })
            $A.enqueueAction(action);
        }
        else{
            component.set("v.errorMessage",'L\'opportunité mère renseignée n\'est pas valable');
            component.set("v.showError",true);
        }
    }
})