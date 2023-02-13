({
    Loadcontrat : function(component) {
        var action = component.get('c.getCurrentObject');
        
        action.setParams({ 
            ContratId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            component.set("v.CurrentContrat", response.getReturnValue()); 
            var opp = component.get("v.NewOpp");
            opp.Name = component.get("v.CurrentContrat").Name;
            if(component.get("v.CurrentContrat").Statut__c == 'PREP'){
                component.set("v.error",'Il faut attendre la synchronisation et validation du contrat pour effectuer une évolution ou un renouvellement.');
            }
            component.set("v.NewOpp", opp);
        });
        $A.enqueueAction(action);
    },
    
    SaveOpportunity:function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        var action = component.get('c.CreateOpportunityEvolution');
        
        action.setParams({ 
            opp : component.get("v.NewOpp"),
            ContratId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state=response.getState();
            if(state === "SUCCESS")
            {
                var resp=response.getReturnValue()
                if(resp.substring(0, 3)=="006")
                {
                    component.set("v.NewOppId", response.getReturnValue());     
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.NewOppId"),
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                    helper.hideSpinner(component, event, helper);
                }
                else
                {
                    component.set("v.error", response.getReturnValue());
                    helper.hideSpinner(component, event, helper);
                }
            }
            else
            {
                component.set("v.error", response.getError());
                helper.hideSpinner(component, event, helper);
            }
            
        });
        $A.enqueueAction(action);
        //alert(oppid);
        
    },
    
    LoadStagesPicklist: function(component) {
        var action = component.get('c.GetStagesPicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Oppstage", response.getReturnValue()); 
            component.set(("v.NewOpp.StageName"),component.get("v.Oppstage")[0].value);
            
        });
        $A.enqueueAction(action);
    },
    
    LoadMoisPicklist: function(component) {
        var action = component.get('c.GetMoisPicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Mois", response.getReturnValue()); 
            component.set(("v.NewOpp.Moisdesignature__c"),component.get("v.Mois")[0].value);
        });
        $A.enqueueAction(action);
    },
    
    LoadAnneePicklist: function(component) {
        var action = component.get('c.GetAnneePicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Annee", response.getReturnValue()); 
            var d = new Date();
            var dYear = d.getFullYear().toString();
            component.set(("v.NewOpp.Annee_de_signature__c"),dYear);
        });
        $A.enqueueAction(action);
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
})