({
    doInit: function(component, event, helper){
        
        var tempId = component.get("v.recordId").substring(0, 3);
        if(tempId == "001")
        {
            component.set("v.ifContact", false);
            component.set("v.objectAPIName", "Account");
        }
        else if(tempId == "003")
        {
            component.set("v.ifContact", true);
            component.set("v.objectAPIName", "Contact");
        }
        
        var ecoSys = component.get("v.EcoSys");
        ecoSys.TypeRelation__c = 'Représenté par';
        component.set("v.EcoSys", ecoSys);
        helper.affichageCurrentOppCont(component,event);
        
    },
    
    handleCancel: function(component, event, helper) 
    {        
        var boolShowCreation = component.get("v.ifShowCreateCmp");
        component.set("v.ifShowCreateCmp", !boolShowCreation); 
        
        var navigateEvent = $A.get("e.force:navigateToSObject");
        navigateEvent.setParams({
            "recordId": component.get('v.recordId'),
        });
        navigateEvent.fire();
    },
    
    handleCreateEcoSys: function(component, event, helper) 
    {
        var ecoSys = component.get("v.EcoSys");
        var action = component.get("c.createEcoSystem");
        action.setParams({
            "AccId": component.get("v.recordId"),
            "ecoSys": ecoSys,
            "partExistant": component.get("v.PartExistant")
        });
        action.setCallback(this, function(response)  
                           {
                               var state=response.getState();
                               if(state === "SUCCESS")
                               {
                                   var resp = response.getReturnValue();
                                   if(! resp[0].startsWith('OK')){
                                       component.set('v.error', resp[0]);
                                   }else{
                                       component.set('v.error', '');
                                       if(resp != null) 
                                       {
                                           component.set("v.ifShowCreateCmp", false);
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               mode: 'dismissible',
                                               duration: '3000',
                                               //message: 'Ecosystème du partenaire "'+ resp[1]+'" was created.',
                                               message: 'L\' écosystème a été créé',
                                               type : 'success'
                                           });
                                           toastEvent.fire();
                                           
                                           var boolShowCreation = component.get("v.ifShowCreateCmp");
                                           component.set("v.ifShowCreateCmp", !boolShowCreation);
                                           
                                           var navigateEvent = $A.get("e.force:navigateToSObject");
                                           navigateEvent.setParams({
                                               "recordId": component.get('v.recordId'),
                                           });
                                           navigateEvent.fire();
                                       }
                                   }
                               }
                           });
        $A.enqueueAction(action);
    }, 
})