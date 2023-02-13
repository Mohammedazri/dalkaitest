({       
    viscssLoaded : function(component, event, helper) {
        helper.GetDataFromController(component, true, true, true);
    },
    
    GetDatas : function(component, event, helper) {
        document.getElementById('visualization').innerHTML = "";
        helper.GetDataFromController(component, component.get("v.SatisfactionClient"), component.get("v.EnjeuxContractuels"), component.get("v.RelationnelClient"))
    },
    
    CreateEvent: function(component, event, helper) {
        component.set("v.IfCreateEvent", true);
    },
    
    CreateTask: function(component, event, helper) {
        component.set("v.IfCreateTask", true);
    }
})