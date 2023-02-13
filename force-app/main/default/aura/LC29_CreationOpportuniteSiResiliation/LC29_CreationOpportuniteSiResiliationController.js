({
    doInit : function(component, event, helper) {
        var action = component.get('c.isSave');
        action.setParams({ 
            recID : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if ( state === "SUCCESS") {
                
                component.set("v.IsSave", response.getReturnValue());
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    handleSave : function(component, event, helper) {
        var btn = event.getSource();
        btn.set("v.disabled",true);
        var action = component.get('c.handler');
        
        action.setParams({ 
            recID : component.get("v.recordId"),
            IsCancel: false
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if ( state === "SUCCESS") 
            {
                var res = response.getReturnValue();
                if(res.substring(0,3)=="006")
                {
                    component.set("v.IsSave", false);
                    $A.get('e.force:refreshView').fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": "Opportunité",
                        messageTemplate:  $A.get("$Label.c.LC29_toast"),
                        messageTemplateData: [ {
                            url: '/'+res,                       
                            label: 'ici',
                        }
                                             ]
                    });
                    toastEvent.fire();
                    
                    btn.set("v.disabled",false);
                }
                else
                {
                    component.set("v.error", res);
                    btn.set("v.disabled",false);
                    
                }
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    handleCancel : function(component, event, helper) {
        
        var btn = event.getSource();
        btn.set("v.disabled",true);
        
        var action = component.get('c.handler');
        
        action.setParams({ 
            recID : component.get("v.recordId"),
            IsCancel: true
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if ( state === "SUCCESS") {
                
                component.set("v.IsSave", false);
                $A.get('e.force:refreshView').fire();
            }
            
        });
        $A.enqueueAction(action);
        
        btn.set("v.disabled",false);
    },
    
    
})