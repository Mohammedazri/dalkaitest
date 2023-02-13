({
    affichageCurrentOppCont : function(component,event) {
        var action = component.get("c.showCurrentOppOrContract");
        action.setParams({
            'ObjectName' : component.get("v.objectAPIName"),
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selectedRecord = response.getReturnValue();
                component.set("v.SearchKeyWordOppOrContract", selectedRecord.Name);
                
                if(component.get("v.objectAPIName") == 'Opportunity'){
                    var ecoSys = component.get("v.EcoSys");
                    ecoSys.Opportunite__c = selectedRecord.Id;
                    //ecoSys.Partenaire__c = selectedRecord.Account.Id;
                    component.set("v.EcoSys", ecoSys);
                    //component.set("v.SearchKeyWordPartenaire", selectedRecord.Account.Name);
                    
                }else if(component.get("v.objectAPIName") == 'Contrat__c'){
                    var ecoSys = component.get("v.EcoSys");
                    ecoSys.Contrat__c = selectedRecord.Id;
                    /*if(selectedRecord.NomPartenaire__c != undefined){
                        //ecoSys.Partenaire__c = selectedRecord.OpportuniteCommerciale__r.AccountId;
                        ecoSys.Partenaire__c = selectedRecord.NomPartenaire__c;
                        component.set("v.SearchKeyWordPartenaire", selectedRecord.NomPartenaire__r.Name);
                        
                    }*/
                    component.set("v.EcoSys", ecoSys);
                   /* var value = [{ 
                            type: 'Contact', 
                            id: "0031j00000AQXT8AAP", 
                            label: "ALAIN TEST TEST", 
                        }];
                    component.find("PartenaireContrat").get("v.body")[0].set("v.values",value );*/
                    //alert(component.find("PartenaireContrat").get("v.body")[0].get("v.values"));
                    //alert( selectedRecord.Contact_du_partenaire__r.Name);
                    //alert(selectedRecord.Contact_du_partenaire__c + selectedRecord.Contact_du_partenaire__r.Name);
                    //ecoSys.ContactDuPartenaire__c = selectedRecord.Contact_du_partenaire__c;
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
})