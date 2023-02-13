({
    affichageCurrentOppCont : function(component,event) {
        var action = component.get("c.showCurrentOppOrContract");
        action.setParams({
            'recordId' : component.get("v.recordId"),
            'ObjectName': component.get("v.objectAPIName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selectedRecord = response.getReturnValue();
                var ecoSys = component.get("v.EcoSys");
                
                if(component.get("v.objectAPIName") == 'Account'){
                    ecoSys.Partenaire__c = selectedRecord.Id;
                    component.set("v.EcoSys", ecoSys);
                    component.set("v.SearchKeyWordPartenaire", selectedRecord.Name);
                    component.set("v.ifShowPart",true);
                    component.set("v.PartExistant",true);
                    
                }else  if(component.get("v.objectAPIName") == 'Contact'){
                    
                    if(selectedRecord.AccountId != null){
                        
                        ecoSys.Partenaire__c = selectedRecord.AccountId;
                        ecoSys.ContactDuPartenaire__c = selectedRecord.Id;
                        
                        component.set("v.EcoSys", ecoSys);
                        component.set("v.SearchKeyWordPartenaire", selectedRecord.Account.Name);
                        component.set("v.SearchKeyWordContactPartenaire", selectedRecord.Name);
                        
                        component.set("v.ifShowPart",true);
                        component.set("v.PartExistant",true);
                    }
                    else {
                        
                        ecoSys.ContactDuPartenaire__c = selectedRecord.Id;
                        component.set("v.EcoSys", ecoSys);
                        component.set("v.SearchKeyWordContactPartenaire", selectedRecord.Name);
                        component.set("v.ifShowPart",false);
                        component.set("v.PartExistant",false);
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
    },
})