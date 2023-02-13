({
    doInit : function(component, event, helper) {

        if(component.get("v.contactWrapper").isParentOfSearched)
        {
            component.set("v.IfExpand", true);
        }	
    },
    
    ActionClicked : function(component, event, helper) {
        var compEvent = $A.get("e.c:LE01_ContactAction");
        var theContact=component.get("v.contactWrapper");
        compEvent.setParams({"contactWrapper" : theContact });
        compEvent.fire();
    },
    
    ExpandBelow : function(component, event, helper) {
        if(component.get("v.IfExpand"))
        {
            component.set("v.IfExpand", false);
        }
        else
        {
            component.set("v.IfExpand", true);
        }
    },
    
    INSearchResults: function(component, event, helper) {
        if(! component.get("v.contactWrapper").listChildren.length>=1)
        {
            component.set("v.contactWrapper", null);
        }
        if( component.get("v.contactWrapper") && component.get("v.contactWrapper").isRoot)
        {
        	component.set("v.IfExpand", false);
        }
    },

    DeleteContactInterne: function(component, event, helper) {   
        //get the id of the selected contcat interne
        var RelationId=event.currentTarget.id;
        component.set("v.IdOfElementToDelete", RelationId);
        
        var ModalSection = component.find('ModalSectionDelete');
        var visibility = component.find('visibilityDelete');
        $A.util.addClass(ModalSection, 'slds-fade-in-open');
        $A.util.addClass(visibility, 'slds-backdrop--open');
    },
    
    EditContactInterne: function(component, event, helper) {  
        //disable buttons
        component.set("v.disableButton", true);
        //get the id of the selected contcat interne
        var RelationId=event.currentTarget.id;
        console.log('RelationId ' + RelationId);
        //get the selected contact interne Object
        var theSelectedContactInterne;
        var listOfContactsInterne=component.get("v.contactWrapper.theContact.Relation_Clients_et_Internes__r");
        for(var key in listOfContactsInterne)
        {
            console.log('key '+ key);
            var theContactInterne=listOfContactsInterne[key];
            console.log('in 07 elt '+ theContactInterne.Id+ ' ' + theContactInterne.Contact_Interne__c);
            console.log('avant if ' + theContactInterne.Id + ' ' + RelationId);
            if(theContactInterne.Id===RelationId)
            {
                theSelectedContactInterne=theContactInterne;               
                break;
            }
        } 
        if(theSelectedContactInterne!= null)
        {
            component.set("v.IfModalRC", true);             
            component.set("v.IfCreateMode", false);  
            component.set("v.RelationToEdit", theSelectedContactInterne);
        }
    },
    
    hideModalofDelete: function(component, event, helper) {
        component.set("v.disableButton", false);
        var ModalSection = component.find('ModalSectionDelete');
        var visibility = component.find('visibilityDelete');
        $A.util.removeClass(visibility,'slds-backdrop--open');
        $A.util.removeClass(ModalSection, 'slds-fade-in-open');
    },
    
    DeleteTheRecord: function(component, event, helper) {
        //disable buttons
        component.set("v.disableButton", true);
        //hide the modal
        var ModalSection = component.find('ModalSectionDelete');
        var visibility = component.find('visibilityDelete');
        $A.util.removeClass(visibility,'slds-backdrop--open');
        $A.util.removeClass(ModalSection, 'slds-fade-in-open');
        
        //delete the selected contact inrene
        var RelationId= component.get("v.IdOfElementToDelete");
        var action = component.get('c.DeleteRelationInterne');  
        action.setParams({ 
            RelationId : RelationId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue()==="SUCCESS")
                {
                    ////reload calendar
                    component.set("v.IfRefreshRC", !component.get("v.IfRefreshRC"));
                    component.set("v.disableButton", false);
                }
                else
                {
                    component.set("v.errorMessage", response.getReturnValue());
                    component.set("v.IfErrorExists", true);
                    component.set("v.disableButton", false);
                }    
            }
        });
        $A.enqueueAction(action);
    },
    
})