({
    doInit : function(component, event, helper) {
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
    }
})