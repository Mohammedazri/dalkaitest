({
	doInit : function(component, event, helper) {
        var ModalSection = component.find('ModalSection');
        var visibility = component.find('visibility');
        $A.util.removeClass(visibility,'slds-backdrop--open');
        $A.util.removeClass(ModalSection, 'slds-fade-in-open');
        var action = component.get('c.getAccountContacts');
        
        action.setParams({ 
            AccountId : component.get("v.recordId"),
            searchItem:''
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                //alert("From server: " + response.getReturnValue());
				console.log(response.getReturnValue());
                component.set("v.listWrapper", response.getReturnValue());
                component.set("v.IfInitEnded", true);
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
        });
        $A.enqueueAction(action);        
    },
    
    searchKeyChange : function(component, event, helper) {
    	if(event.getParams().keyCode === 13){
            helper.doSearch(component,event, helper);
        }
    },
    handleClick: function(component, event, helper)
    {
        var myEvents= component.get("v.EventsToUpdate");
        var EvtID = event.getSource().get("v.text");
        var myValue= event.getSource().get("v.value");
        myEvents[EvtID]=myValue;
    },
    handleComponentEvent : function(component, event, helper) {
        var myContact=event.getParam("contactWrapper");
        component.set("v.ModalTitle",myContact.theContact.Name);
        component.set("v.MessageForModal",myContact.listEvents);
        /*document.getElementById("visibility").style.visibility = "visible";
        document.getElementById("ModalSection").style.display = "block";*/
        var ModalSection = component.find('ModalSection');
        var visibility = component.find('visibility');
        $A.util.addClass(ModalSection, 'slds-fade-in-open');
        $A.util.addClass(visibility, 'slds-backdrop--open');
    },
    
    hideModal : function(component,event, helper){  
        
        var myEvents= component.get("v.EventsToUpdate");
        helper.SetEvent(component,event, helper);
       /*document.getElementById("visibility").style.visibility = "hidden";
       document.getElementById("ModalSection").style.display = "none" ;  SetEvent*/
        var ModalSection = component.find('ModalSection');
        var visibility = component.find('visibility');
        $A.util.removeClass(visibility,'slds-backdrop--open');
        $A.util.removeClass(ModalSection, 'slds-fade-in-open'); 
        
   },
    
    hideModalofError : function(component,event, helper){ 
        var ModalSection = component.find('ModalSectionError');
        var visibility = component.find('visibilityError');
        $A.util.removeClass(visibility,'slds-backdrop--open');
        $A.util.removeClass(ModalSection, 'slds-fade-in-open');
        component.set("v.IfErrorExists", false);
    },
    
    SearchData : function(component,event, helper){
        helper.doSearch(component,event, helper);
    },
    
    CreateRC : function(component,event, helper){
        component.set("v.IfModalRC", true);
        component.set("v.IfCreateMode", true);
    },
    
    OpenErrorModel : function(component,event, helper){
        if(component.get("v.IfErrorExists"))
        {
            var ModalSection = component.find('ModalSectionError');
            var visibility = component.find('visibilityError');
            $A.util.addClass(ModalSection, 'slds-fade-in-open');
            $A.util.addClass(visibility, 'slds-backdrop--open');
        }
    }
    
})