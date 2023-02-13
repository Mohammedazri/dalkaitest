({
    Loadcontrat : function(component) 
    {
        var action = component.get('c.getContratdOrigine');
        action.setParams({
            OppID : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var res = response.getReturnValue();
            if( res != null )
            {
                component.set("v.myContrat", res);
                component.set("v.ShowPopUp",true);
                
                if(res.DateFin__c != null){
                     component.set("v.disableDate",true);
                }
                
                var action1 = component.get('c.GetMotifsDeFermeture');
                action1.setParams({
                    oppId : component.get("v.recordId")
                });
                action1.setCallback(this, function(response) 
                                    {
                                        component.set("v.MotifsList", response.getReturnValue());
                                        if(response.getReturnValue()[0].value != '')
                                        {
                                            alert(response.getReturnValue()[0].value);
                                            var action2 = component.get('c.LoadDependantConditionValues');
                                            action2.setParams({ 
                                                MotifFermetureSelected : response.getReturnValue()[0].value
                                            });
                                            action2.setCallback(this, function(resp1)  
                                                                {
                                                                    var state=resp1.getState();
                                                                    if(state === "SUCCESS")
                                                                    {
                                                                        var res1 = resp1.getReturnValue();
                                                                        component.set("v.ConditionsList", resp1.getReturnValue());
                                                                    }
                                                                }
                                                               );
                                            $A.enqueueAction(action2);
                                        }
                                    });
                $A.enqueueAction(action1);
            }
            else
            {                
                component.set("v.ShowPopUp",false);
            }
        });
        $A.enqueueAction(action);
    },
    
})