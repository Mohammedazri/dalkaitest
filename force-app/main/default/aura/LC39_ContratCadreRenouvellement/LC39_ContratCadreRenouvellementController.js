({
    doInit : function(component, event, helper) {
        if(component.get('v.reseau') == undefined){
            //component.set('v.Spinner', true);
           
        }
        helper.CheckContrat(component, event, helper);
        helper.Loadcontrat(component);
        helper.LoadStagesPicklist(component);
        helper.LoadMoisPicklist(component);
        helper.LoadAnneePicklist(component);   
        
       
    },
    
    Save : function(component, event, helper) {
        if(component.get("v.NewOpp.Name")==""||component.get("v.NewOpp.Name")==undefined||component.get("v.NewOpp.CloseDate")==undefined)
        {
            alert($A.get("$Label.c.MissingFields"));
        }
        else
        {
            if(isNaN( Date.parse(component.get("v.NewOpp.CloseDate"))))
            {
                alert($A.get("$Label.c.InvalidDate"));
            }
            else
            {
                helper.SaveOpportunity(component, event, helper);
            }    
        }
    },
    
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    CreateOpp : function(component, event, helper) {
        /*var RenouvError = component.find('RenouvError');
        var RenouvFormResilie = component.find('RenouvFormResilie');
        $A.util.removeClass(RenouvError, 'slds-show');
        $A.util.addClass(RenouvError, 'slds-hide');*/
        component.set("v.ifShowRenouvError", false);
        /*$A.util.removeClass(RenouvFormResilie, 'slds-hide');
        $A.util.addClass(RenouvFormResilie, 'slds-show');*/
        component.set("v.ifShowRenouvFormResilie", true);
    },
    SaveResilie : function(component, event, helper) {
        if(component.get("v.NewOpp.Name")==""||component.get("v.NewOpp.Name")==undefined||component.get("v.NewOpp.CloseDate")==undefined)
        {
            alert($A.get("$Label.c.MissingFields"));
        }
        else
        {
            if(isNaN( Date.parse(component.get("v.NewOpp.CloseDate"))))
            {
                alert($A.get("$Label.c.InvalidDate"));
            }
            else
            {
                helper.SaveOpportunityResilie(component, event, helper);
            }    
        }
    },
    
 
})