({
    Loadcontrat : function(component) 
    {
        var action2 = component.get('c.getOppNow');
        
        action2.setParams({ 
            oppID : component.get("v.recordId")
        });
        action2.setCallback(this, function(resp1)  
                            {
                                var res1 = resp1.getReturnValue();
                                component.set("v.OppNow",res1);
                            }
                           );
        $A.enqueueAction(action2);
        
        var action = component.get('c.getMessage');
        action.setParams({
            oppID : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //alert(response.getReturnValue());
            if( response.getReturnValue()==1)
            {
                component.set("v.ShowPopUp",true);
            }
            
            if( response.getReturnValue()==2)
            {                
                component.set("v.ShowPopUp",false);
            }
            if( response.getReturnValue()==4)
            {                
                var action1 = component.get('c.getOppConcurente');
                
                action1.setParams({ 
                    oppID : component.get("v.recordId")
                });
                action1.setCallback(this, function(resp1)  
                                    {
                                        var res1 = resp1.getReturnValue();
                                        component.set("v.OppConc",res1);
                                        component.set("v.ShowConcurrente",true);
                                        component.set("v.ShowConcurrentePerdu",true);
                                        component.set("v.ShowConcurrenteGagne",false);
                                    }
                                   );
                $A.enqueueAction(action1);
            }
            if( response.getReturnValue()==5)
            {                
                var action1 = component.get('c.getOppConcurente');
                
                action1.setParams({ 
                    oppID : component.get("v.recordId")
                });
                action1.setCallback(this, function(resp1)  
                                    {
                                        var res1 = resp1.getReturnValue();
                                        component.set("v.OppConc",res1);
                                        component.set("v.ShowConcurrente",true);
                                        component.set("v.ShowConcurrenteGagne",true);
                                        component.set("v.ShowConcurrentePerdu",false);
                                    }
                                   );
                $A.enqueueAction(action1);
            }
            if(response.getReturnValue()==3)
            {
                var evt = $A.get("e.force:navigateToComponent");
                var OppId = component.get("v.recordId");
                evt.setParams({
                    componentDef  : "c:LC52_MettreOffreZero" ,
                    componentAttributes  : {
                        oppId : OppId,
                        newOpp : component.get("v.recordId")
                    }
                    
                    
                });
                
                evt.fire();   
            }
        });
        $A.enqueueAction(action);
    },
    
    
    LoadComp : function(component) 
    {
        var evt = $A.get("e.force:navigateToComponent");
        var OppId = component.get("v.recordId");
        evt.setParams({
            componentDef  : "c:LC52_MettreOffreZero" ,
            componentAttributes  : {
                oppId : OppId,
                newOpp : component.get("v.newOpp")
            }
            
        });
        
        evt.fire();  
    }
    
})