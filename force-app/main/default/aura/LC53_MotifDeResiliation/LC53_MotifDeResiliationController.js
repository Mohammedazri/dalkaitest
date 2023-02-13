({
    doInit : function(component, event, helper) 
    {
        var action10 = component.get('c.QueryingOpportunityFields');
        action10.setParams({ 
            OppID : component.get("v.recordId")
        });
        action10.setCallback(this, function(resp)  
                             {
                                 var state=resp.getState();
                                 if(state === "SUCCESS")
                                 { 
                                     helper.Loadcontrat(component);
                                 }
                             });
        $A.enqueueAction(action10);
    },
    
    Handle_Annuler: function(component, event, helper) 
    {
        component.set("v.ShowPopUp",false);
    },
    
    Handle_ok: function(component, event, helper) 
    {
        var val = component.get("v.myContrat.Condition_de_fermeture__c");
        var dateF = component.get("v.myContrat.DateFin__c"); 
        
        if (val == undefined || dateF == undefined)
        {
            component.set("v.error","Veuillez remplir les champs obligatoires");
        }
        else
        {
        var action = component.get('c.updateContratdOrigine');
        action.setParams({ 
            contratorigine : component.get("v.myContrat"),
            OppID : component.get("v.recordId")
        });
        action.setCallback(this, function(resp1)  
                           {
                               var state=resp1.getState();
                               if(state === "SUCCESS")
                               {
                                   var res1 = resp1.getReturnValue();
                                   if(res1=="OK")
                                   {
                                       component.set("v.ShowPopUp",false);
                                       $A.get('e.force:refreshView').fire();
                                   }
                                   else 
                                   {
                                       component.set("v.error",resp1.getReturnValue());
                                   }
                               }
                           }
                          );
        $A.enqueueAction(action);
        }
    },
    
    onSelectChange: function(component, event, helper) 
    {
        var motifSelected = component.get("v.myContrat").Motif_fermeture_contrat__c;
        if(motifSelected != null && motifSelected != ''){
            component.set('v.disableCondition', false);
            var action = component.get('c.LoadDependantConditionValues');
            action.setParams({ 
                MotifFermetureSelected : component.get("v.myContrat").Motif_fermeture_contrat__c
            });
            action.setCallback(this, function(resp1)  
                               {
                                   var state=resp1.getState();
                                   if(state === "SUCCESS")
                                   {
                                       var res1 = resp1.getReturnValue();
                                       component.set("v.ConditionsList", resp1.getReturnValue());
                                   }
                               }
                              );
            $A.enqueueAction(action);
        }else{
            component.set('v.disableCondition', true);
        }
    },
    
})