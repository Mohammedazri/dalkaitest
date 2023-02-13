({
    FillData : function(component, event, helper) {
        if(!component.get("v.IfCreateMode"))
        {
            if(component.get("v.RelationToEdit"))
            {              
                component.set("v.newRC", component.get("v.RelationToEdit"));
            }
        }
    },
    
    
    ExitCreateRC : function(component, event, helper) {
        component.set("v.disableButton", false);
        component.set("v.IfModalRC", false);          
    },
    
    Save : function(component, event, helper) {
        component.set("v.disableSave", true);
        component.set("v.errorMessage", "");
        //////check RC Partenaire and Contact/////////
        var InputContact = component.find("InputContact");
        var InputUser = component.find("InputUser");
        if(InputContact.get("v.value") == null || InputContact.get("v.value") == '' 
           || InputUser.get("v.value") == null || InputUser.get("v.value") == '' )
        {
            var staticLabel = $A.get("$Label.c.CmpCreateRCErreur");
            component.set("v.errorMessage", staticLabel);
            component.set("v.disableSave", false);
        }
        else
        {
            ////save RC//////
            var action = component.get('c.SaveRC');
            //alert(component.get("v.newRC"));
            var newRCString = JSON.stringify(component.get("v.newRC"));
            action.setParams({ 
                "newRCStr" : newRCString,
            });
            action.setCallback(this, function(response) {
                var state = response.getState();           
                if (component.isValid() && state === "SUCCESS") {
                    if(response.getReturnValue()==="SUCCESS")
                    {
                        ////reload calendar
                        component.set("v.IfRefreshRC", !component.get("v.IfRefreshRC"));
                        component.set("v.IfModalRC", false); 
                        component.set("v.disableSave", false);
                    }
                    else
                    {
                        component.set("v.errorMessage", response.getReturnValue());
                        component.set("v.disableSave", false);
                    }    
                }
                component.set("v.disableButton", false);
            });
            $A.enqueueAction(action);
        }
    }
})