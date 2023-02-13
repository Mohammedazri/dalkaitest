({
    doInit: function(component, event, helper){
       
        var tempId = component.get("v.recordId").substring(0, 3);
        if(tempId == $A.get("$Label.c.LC27_OpportuntyID"))
        {
            var ecoSys = component.get("v.EcoSys");
            ecoSys.TypeRelation__c = 'Représenté par';
            component.set("v.EcoSys", ecoSys);
            
            component.set('v.ifOpportunity', true);
            component.set('v.objectAPIName', 'Opportunity');
            component.set('v.title', $A.get("$Label.c.LC36_titreOpp"));
            helper.affichageCurrentOppCont(component,event);
        }
        else if(tempId == $A.get("$Label.c.LC27_ContratID"))
        {
            var ecoSys = component.get("v.EcoSys");
            ecoSys.TypeRelation__c = 'Représenté par';
            component.set("v.EcoSys", ecoSys);
            
            component.set('v.ifOpportunity', false);
            component.set('v.objectAPIName', 'Contrat__c');
            component.set('v.title', $A.get("$Label.c.LC36_titreContrat"));
            helper.affichageCurrentOppCont(component,event);
        }
        component.set('v.isLoading', false);
        
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
        component.set('v.isLoading', true);
        component.set('v.error', null);
        var ecoSys = component.get("v.EcoSys");
        if(ecoSys.TypeRelation__c == 'DEST'  || ecoSys.TypeRelation__c == 'FACT_1'){
            component.set('v.error', $A.get("$Label.c.LC36_TypeDestOuFactMessage"));
            component.set('v.isLoading', false);
        }
        else{
            var action = component.get("c.createEcoSystem");
            action.setParams({
                "OppId": component.get("v.recordId"),
                "ecoSys": ecoSys
            });
            action.setCallback(this, function(response)  
                               {
                                   var state=response.getState();
                                   if(state === "SUCCESS")
                                   {
                                       var resp = response.getReturnValue();
                                       if(! resp[0].startsWith('OK')){
                                           component.set('v.error', resp[0]);
                                           component.set('v.isLoading', false);
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

                                               component.set('v.isLoading', false);
                                               
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
        }
        
    }, 
})