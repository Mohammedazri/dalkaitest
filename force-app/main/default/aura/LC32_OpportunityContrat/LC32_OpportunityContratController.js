({
    doInit: function(component, event, helper) 
    {
        var action = component.get("c.Displaymessage");
        action.setParams({"FicheId": component.get("v.recordId")});
        action.setCallback(this, function(resp)  
                           {
                               var state=resp.getState();
                               if(state === "SUCCESS")
                               {
                                   var res = resp.getReturnValue();
                                   if(res != null && res.split(";") !="") 
                                   {
                                       component.set("v.Closing", true); 
                                       component.set("v.fields", res.split(";")); 
                                   } 
                               }
                           });
        $A.enqueueAction(action);  
    },
    
    closeModel: function(component, event, helper) {
        
        var action4 = component.get("c.changeTechField");
        action4.setParams({"FicheId": component.get("v.recordId")});
        action4.setCallback(this, function(resp1)  
                            {
                                var state1=resp1.getState();
                                if(state1 === "SUCCESS")
                                {
                                    var res1 = resp1.getReturnValue();
                                    if(res1 =='OK') 
                                    {
                                        component.set("v.Closing", false);
                                    }
                                    else
                                    {
                                        component.set("v.error", res1);
                                    } 
                                }
                                
                            });
        $A.enqueueAction(action4);
    },
    
})