({
    Save : function(component, event, helper) {
        
        component.set("v.ifErrorExists",false) ;
        var in1 = component.find("InputUser1").get("v.value");
        var in2 = component.find("InputUser2").get("v.value");
        var in3 = component.find("InputUser3").get("v.value");
        var in4 = component.find("InputUser4").get("v.value");
        if (in1=== "" && in2=== "" && in3=== "" && in4 === "") 
        {
            component.set("v.ifErrorExists",true) ;
            component.set("v.errorMsg", $A.get("$Label.c.LC48_ErrorAuMoins1"));
        }
        else
        {
            component.set("v.ifErrorExists",false) ;
            if((in1===in2 && in1!=""&&in2!="")
               ||(in1===in3&& in1!=""&&in3!="")
               ||(in1===in4&& in1!=""&&in4!="")
               ||(in2===in3&& in2!=""&&in3!="")
               ||(in2===in4&& in2!=""&&in4!="")
               ||(in3===in4&& in3!=""&&in4!=""))
            {
                component.set("v.ifErrorExists",true) ;
            	component.set("v.errorMsg", $A.get("$Label.c.LC48_ErrorAppDiff"));
            }
            else
            {
                component.set("v.ShowSpinner",true);
                component.set("v.ifErrorExists",false) ;
                var action = component.get('c.lunchApprove');
                action.setParams({ 
                    recordId:component.get("v.recordId"),
                    FDS : component.get("v.CurrentRecord"),
                    ApprobComm: component.get("v.ApprobCommentaire")      
                });
                action.setCallback(this, function(response) {
                    if(response.getReturnValue() != 'OK'){
                        component.set("v.ShowSpinner",false);
                        component.set("v.ifErrorExists",true) ;
                        component.set("v.errorMsg", response.getReturnValue());
                    }else{
                        component.set("v.ifErrorExists",false) ;
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                    }
                    
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})