({
    doInit : function(component, event, helper) 
    {
        helper.Loadcontrat(component);
    },
    
    handleConcurrente : function(component, event, helper) 
    {
        component.set("v.ShowConcurrente",false);
        var action = component.get('c.cancelConcurrente');
        action.setParams({ 
            oppID : component.get("v.recordId")
        });
        action.setCallback(this, function(resp1){
        }
                          );
        $A.enqueueAction(action);
    },
    
    Handle_Annuler: function(component, event, helper) 
    {
        component.set("v.ShowSpinner",true);
        component.set("v.ShowPopUp",false);
        
        var oppStatus = component.get("v.OppNow.Statut__c");
        var oppType = component.get("v.OppNow.Qualification__c");
        
        
        var action = component.get('c.cancel');
        action.setParams({ 
            oppID : component.get("v.recordId")
        });
        action.setCallback(this, function(resp1){
            var state=resp1.getState();
            if(state === "SUCCESS")
            {
                var res1 = resp1.getReturnValue();
                if(res1=="OK")
                {
                    component.set("v.newOpp",component.get("v.recordId"));
                    //LC52 ne s'affiche pas pour les opportunités nouvelles sans suite
                    if(oppStatus == $A.get("$Label.c.LC35_OppStatus") && oppType == $A.get("$Label.c.LC35_OppType")){
                        component.set("v.ShowPopUp",false);
                        component.set("v.ShowSpinner",false);
                    }else{
                        helper.LoadComp(component);
                        component.set("v.ShowPopUp",false);
                        component.set("v.ShowSpinner",false);
                    }
                }
                else 
                {
                    component.set("v.error",resp1.getReturnValue());
                    component.set("v.ShowSpinner",false);
                    component.set("v.ShowPopUp",true);
                }
            }
        }
                          );
        $A.enqueueAction(action);
    },
    
    Handle_ok: function(component, event, helper) 
    {
        component.set("v.ShowSpinner",true);
        component.set("v.ShowPopUp",false);
        
        
        var oppStatus = component.get("v.OppNow.Statut__c");
        var oppType = component.get("v.OppNow.Qualification__c");
        
        var action = component.get('c.duplicate');
        
        action.setParams({ 
            oppID : component.get("v.recordId")
        });
        action.setCallback(this, function(resp1)  
                           {
                               var state=resp1.getState();
                               if(state === "SUCCESS")
                               {
                                   var res1 = resp1.getReturnValue();
                                   if(res1.substring(0, 3)=="006")
                                   {
                                       component.set("v.ShowPopUp",false);
                                       component.set("v.ShowSpinner",false);
                                       component.set("v.newOpp",res1);
                                       //LC52 ne s'affiche pas pour les opportunités nouvelles sans suite
                                       //Si une opp concurrente est creer, on l'ouvre
                                       if(oppStatus == $A.get("$Label.c.LC35_OppStatus") && oppType == $A.get("$Label.c.LC35_OppType")){
                                           var navEvt = $A.get("e.force:navigateToSObject");
                                           navEvt.setParams({
                                               "recordId": res1
                                           });
                                           navEvt.fire();
                                       }else{
                                           
                                           helper.LoadComp(component);
                                       }
                                   }
                                   else 
                                   {
                                       component.set("v.error",resp1.getReturnValue());
                                       component.set("v.ShowSpinner",false);
                                       component.set("v.ShowPopUp",true);
                                   }
                               }
                               
                           });
        $A.enqueueAction(action);
    },
    
    
})