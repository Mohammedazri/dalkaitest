({
    doInit : function(component, event, helper) {
        var action = component.get("c.loadFDS");
        action.setParams({ 
            oppID : component.get("v.oppId")
        });
        action.setCallback(this, function(resp1){
            var res1 = resp1.getReturnValue();
            if (res1!=null)
            {
            component.set("v.FDSname",res1);
            component.set("v.ShowSpinner",false);
            component.set("v.ShowPopUp",true);
            }
            else{
                helper.ReloadUrl(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    
     Handle_Annuler: function(component, event, helper) 
    {
      var action = component.get("c.modifyTech");
        action.setParams({ 
            oppID : component.get("v.oppId")
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
                                       helper.ReloadUrl(component);
                                   }
                                   else 
                                   {
                                       component.set("v.error",resp1.getReturnValue());
                                   }
                               }
                           } 
                          );
        $A.enqueueAction(action);
        
      
    },
    
    Handle_ok: function(component, event, helper) 
    {
        var action = component.get("c.annulerOffre");
        action.setParams({ 
            oppID : component.get("v.oppId")
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
                                       helper.ReloadUrl(component);
                                   }
                                   else 
                                   {
                                       component.set("v.error",resp1.getReturnValue());
                                   }
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },

    
})