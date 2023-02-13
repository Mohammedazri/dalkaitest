({
    doInit : function(component, event, helper) {
        var action = component.get("c.load");
        action.setParams({ 
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var state = a.getReturnValue();
            if(state)
            {
                component.set("v.hasAccess",true);
                component.set("v.NoAccess",false);
            }
            else
            {
                component.set("v.hasAccess",false);
                component.set("v.NoAccess",true);
            }
        })
        $A.enqueueAction(action); 
    },
    
    
    Soumettre : function(component, event, helper) {
        component.set("v.ShowSpinner",true);
        var action = component.get("c.refuser");
        action.setParams({ 
            recordId : component.get("v.recordId"),
            comm: component.get("v.ApprobCommentaire")
        });
        action.setCallback(this, function(a) {
            if(a.getReturnValue())
            {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
                component.set("v.ShowSpinner",false);
            }
            
        })
        $A.enqueueAction(action); 
    },
    
    
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
    },
})