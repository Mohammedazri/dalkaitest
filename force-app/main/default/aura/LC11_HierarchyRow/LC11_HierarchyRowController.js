({
    doInit : function(component, event, helper) {
   		if(component.get("v.HierarchyWrapper").isParentOfCurrent)
        {
            component.set("v.IfExpand", true);
        }
    },
    
    ExpandBelow : function(component, event, helper) {
        component.set("v.FirstTime", false);
        
        if(component.get("v.IfExpand"))
        {
            component.set("v.IfExpand", false);
        }
        else 
        {
            component.set("v.IfExpand", true);
        }
    }
})