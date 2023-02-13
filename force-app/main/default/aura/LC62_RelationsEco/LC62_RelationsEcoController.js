({
	doInit : function(component, event, helper) {
        
        var tempId = component.get("v.recordId").substring(0, 3);
        if(tempId == "001")
        {
            helper.getAccountEcoSysWrapperhelper(component, event, helper);
        }
        else if(tempId == "003")
        {
           helper.getContactEcoSysWrapperhelper(component, event, helper);
        }
		
	},
    handleViewAllClick: function(component, event, helper) 
    {
        component.set("v.listforItteration",component.get("v.listofEco"));
        component.set("v.viewAll", true);
    },
    
    handleViewLessClick: function(component, event, helper) 
    {
        component.set("v.listforItteration",component.get("v.partofEco"));
        component.set("v.viewAll", false);
    }, 
})