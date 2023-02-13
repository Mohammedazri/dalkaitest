({
    doInit : function(component, event, helper) {
        
        helper.getStages(component);
        var action = component.get("c.getOpportunitiesFilles");
        action.setParams({ 
            contractId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.lstWrap", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    save : function(component, event, helper) {
        var action = component.get("c.saveOppFille");
        var params  = component.get("v.lstWrap");
        var jsonParams = JSON.stringify(params);  
        action.setParams({
            jsonParams : jsonParams
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.lstWrap", response.getReturnValue());
                
            }
            else{
                component.set("v.errorMsg", 'Erreur de connection');
                var errorDiv = component.find('errorDiv');
                $A.util.removeClass(errorDiv, 'slds-hide');
                $A.util.addClass(errorDiv, 'slds-show');
            }
        });
        $A.enqueueAction(action);  
    },
    modify : function(component, event, helper) {
        var globStage = component.find('globalStage').get("v.value");
        if(globStage==null || globStage=='')
            return;
        var wrapper = component.get("v.lstWrap");
        for(var i=0;i<wrapper.length;i++){
            if(wrapper[i].isSelected==true){
                wrapper[i].opp.StageName = globStage;
            }
        }
        component.set("v.lstWrap", wrapper);
    },
    
})