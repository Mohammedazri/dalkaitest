({
	doSearch : function(component,event, helper) {
        //component.set("v.listWrapper", null);
        var compEvent = $A.get("e.c:LE02_ContactSearch");
        compEvent.setParams({"IFCloseRoot" : true });
        compEvent.fire();
        
        var action = component.get('c.getAccountContacts');
        
        action.setParams({ 
            AccountId : component.get("v.recordId"),
            searchItem:component.get("v.SearchVar")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                //alert("From server: " + response.getReturnValue());
                //console.log(response.getReturnValue());
                component.set("v.listWrapper", response.getReturnValue());
                component.set("v.ColorOfSearched", 'redColor');
                window.setTimeout(
                    $A.getCallback(function() {
                        if(component.isValid()){
                            //var toastDiv= component.find('toastDiv');
                            //$A.util.removeClass(toastDiv, "slds-show");
                            //$A.util.addClass(toastDiv, "slds-hide");
                            component.set("v.ColorOfSearched", 'normal');
                            //alert('after 3 seconds');
                        }
                        else{
                            console.log('Component is Invalid');
                        }
                    }), 3000
                );
            }
            else if (component.isValid() && state === "INCOMPLETE") {
            }
            else if (component.isValid() && state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            $A.get("e.force:refreshView");
        });
        $A.enqueueAction(action);
		
	},
    
    SetEvent : function(component,event, helper) 
    {
        
        var action = component.get('c.setEvent');
        
        action.setParams({ 
            mapEventIDRvt : component.get("v.EventsToUpdate")
        });
        
        $A.enqueueAction(action); 
    }
})