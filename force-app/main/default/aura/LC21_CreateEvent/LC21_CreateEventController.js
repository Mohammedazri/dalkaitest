({
    doInit : function(component, event, helper) {
        var newEventObj= component.get("v.newEvent");
        /////// default start/end time
        var startDate = new Date();
        newEventObj.StartDateTime = startDate.toISOString();
        		//component.set("v.newEvent.StartDateTime", startDate.toISOString());
        startDate.setHours(startDate.getHours() + 1);
        newEventObj.EndDateTime = startDate.toISOString();
        		//component.set("v.newEvent.EndDateTime", startDate.toISOString());        
        ///// default Associé (account)
        newEventObj.WhatId=component.get("v.recordId");
        		//component.set("v.newEvent.WhatId", component.get("v.recordId"));
        		//console.log('component.get("v.recordId") '+ component.get("v.recordId"));
        //// default Attribué (user)
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        		//console.log('aaaauserId '+ userId);
        newEventObj.OwnerId=userId;
        		//component.set("v.newEvent.OwnerId", userId);
        //// default Type
        //newEventObj.Type = component.get("v.newEvent.Type");
        //// default Activity Type
        //newEventObj.genre_comite__c = component.get("v.newEvent.genre_comite__c");
        /// set all default parameters
        //component.set("v.newEvent", newEventObj);
        setTimeout(function(){ var action = component.get("c.getpickvalType");
                              var opts=[];
                              action.setCallback(this, function(a) {
                                  for(var i=0;i< a.getReturnValue().length;i++){
                                      if(i==0)
                                      {
                                         newEventObj.Type = a.getReturnValue()[i]; 
                                      }
                                      opts.push({ value: a.getReturnValue()[i], label: a.getReturnValue()[i] });
                                  }
                                  component.set("v.TypeOptions", opts);
                              });
                              $A.enqueueAction(action);
                              var action1 = component.get("c.getpickvalTypeActivity");
                              var opts1=[];
                              action1.setCallback(this, function(a) {
                                  for(var i=0;i< a.getReturnValue().length;i++){
                                      if(i==0)
                                      {
                                          newEventObj.genre_comite__c = a.getReturnValue()[i];
                                      }
                                      opts1.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                                  }
                                  component.set("v.ActivityTypeOptions", opts1);
                              });
                              $A.enqueueAction(action1); }, 500);
        component.set("v.newEvent", newEventObj);
        ////// get picklist values
        
    },
    
    ExitCreateEvent : function(component, event, helper) {
        component.set("v.IfCreateEvent", false);       
    },
    
    Save : function(component, event, helper) {
        component.set("v.disbaleButton", true);
        component.set("v.errorMessage", "");
        //////check date debut/ fin////////////////
        var startDate = component.find("EvtStartTime");
        var endDate = component.find("EvtEndTime");
        var goodDate = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/
        if (!(goodDate.test(startDate.get("v.value")) && goodDate.test(endDate.get("v.value"))))
        {
            component.set("v.errorMessage", "Date Non Valide !");
            component.set("v.disbaleButton", false);
        }
        else
        {
            //////check Event Owner and Subject/////////
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
                ////save Event//////
                var action = component.get('c.SaveEvent');  
                action.setParams({ 
                    newEvent : component.get("v.newEvent"),
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();           
                    if (component.isValid() && state === "SUCCESS") {
                        if(response.getReturnValue()==="SUCCESS")
                        {
                            ////reload calendar
                            component.set("v.IfRefreshEvent", !component.get("v.IfRefreshEvent"));
                            component.set("v.IfCreateEvent", false); 
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