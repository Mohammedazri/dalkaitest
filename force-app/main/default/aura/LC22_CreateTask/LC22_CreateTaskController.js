({
    doInit : function(component, event, helper) {
        ///// default Associé (account)
        component.set("v.newTask.WhatId", component.get("v.recordId"));
        //// default Attribué (user)
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.newTask.OwnerId", userId);
        ////// get picklist values
        var action = component.get("c.getpickvalPriority");
        var inputsel = component.find("InputSelectPriority");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
        });
        $A.enqueueAction(action);
        var action1 = component.get("c.getpickvalStatus");
        var inputsel1 = component.find("InputSelectStatus");
        var opts1=[];
        action1.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts1.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel1.set("v.options", opts1);
        });
        $A.enqueueAction(action1);
        var action2 = component.get("c.getpickvalActivityType");
        var inputsel2 = component.find("InputSelectTypeActivity");
        var opts2=[];
        action2.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts2.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel2.set("v.options", opts2);
            
        });
        $A.enqueueAction(action2);
    },
    
    ExitCreateTask : function(component, event, helper) {
        component.set("v.IfCreateTask", false);
		component.set("v.IfRefreshTask", true);        
    },
    
    Save : function(component, event, helper) {
        component.set("v.disbaleButton", true);
        component.set("v.errorMessage", "");
        //////check date////////////////
        var inputDate = component.find("inputActivityDate");
        var goodDate = /^\d{4}-\d{2}-\d{2}$/;
        if (!goodDate.test(inputDate.get("v.value")))
        {
            component.set("v.errorMessage", "Date Non Valide !");
            component.set("v.disbaleButton", false);
        } 
        else
        {
            //////check Task Owner and object/////////
            var inputAttribue = component.find("InputAttribue");
            var inputObject = component.find("InputSubject");
            if(inputAttribue.get("v.value") == null || inputAttribue.get("v.value") == ''
               || inputObject.get("v.value") == null || inputObject.get("v.value") == '')
            {
                var staticLabel = $A.get("$Label.c.CmpCreateEventErreur");
                component.set("v.errorMessage", staticLabel);
                component.set("v.disbaleButton", false);
            }
            else if((inputAttribue.get("v.value")!=null && inputAttribue.get("v.value").trim()== '') 
                    || (inputObject.get("v.value")!=null && inputObject.get("v.value").trim()== ''))
            {
                var staticLabel = $A.get("$Label.c.CmpCreateEventErreur");
                component.set("v.errorMessage", staticLabel);
                component.set("v.disbaleButton", false);
            }
                else
                {
                    ////save Task//////
                    var action = component.get('c.SaveTask');  
                    action.setParams({ 
                        newTask : component.get("v.newTask"),
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();           
                        if (component.isValid() && state === "SUCCESS") {
                            if(response.getReturnValue()==="SUCCESS")
                            {
                                ////reload calendar
                                component.set("v.IfRefreshTask", !component.get("v.IfRefreshTask"));
                                component.set("v.IfCreateTask", false); 
                            }
                            else
                            {
                                component.set("v.errorMessage", response.getReturnValue());
                                component.set("v.disbaleButton", false);
                            }
                            
                        }
                    });
                    $A.enqueueAction(action);
                }
        }                
    }
})