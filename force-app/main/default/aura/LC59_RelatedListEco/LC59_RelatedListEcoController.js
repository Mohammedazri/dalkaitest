({
	doInit: function(component, event, helper) 
    {   
        component.set("v.ShowSpinner",true);
        component.set("v.Titre", $A.get("$Label.c.LC56_EcoPartenaire"));
        component.set('v.columns', [
            
            {label: 'CONTACT DU PARTENAIRE LIÉ', fieldName: 'ContPartenaireLie', type: 'url', typeAttributes: { label: { fieldName: 'ContPartenaireLieName' },target: '_blank' }},
            {label: 'TYPE DE RELATION', fieldName: 'TypeRel', type: 'text'},
            {label: 'PARTENAIRE', fieldName: 'Partenaire', type: 'url', typeAttributes: { label: { fieldName: 'PartenaireName' },target: '_blank' }},
            {label: 'PARTENAIRE LIÉ', fieldName: 'PartenaireLie', type: 'url', typeAttributes: { label: { fieldName: 'PartenaireLieName' },target: '_blank' }},
            {label: 'CONTRAT', fieldName: 'Contrat', type: 'url', typeAttributes: { label: { fieldName: 'ContratName' },target: '_blank' }},
            {label: 'OPPORTUNITÉ', fieldName: 'Opp', type: 'url', typeAttributes: { label: { fieldName: 'OppName' },target: '_blank' }},
            {type:  'button',
             typeAttributes: 
             {
                 iconName: 'utility:delete',
                 //label:'Supprimer',
                 name: 'deleteRecord', 
                 title: 'Supprimer', 
                 disabled: false,
                 value:'Supprimer',
                 iconPosition: 'center'
             },initialWidth: 80}
        ]);
        var action1 = component.get("c.getEcoSystems");
        action1.setParams({"AccId": component.get("v.recordId")});
        action1.setCallback(this, function(resp1)  
                            {
                                var state=resp1.getState();
                                if(state === "SUCCESS")
                                {
                                    component.set("v.ShowSpinner",false);
                                    var res1 = resp1.getReturnValue();
                                    
                                    if(res1 != null && res1.length!=0 ) 
                                    {
                                        for (var i = 0; i < res1.length; i++) 
                                        {
                                            var row = res1[i];
                                            if(row.PartenaireLie__c != null){
                                                row.PartenaireLieName = row.PartenaireLie__r.Name;
                                            }
                                            if(row.Partenaire__c != null){
                                                row.PartenaireName = row.Partenaire__r.Name;
                                            }
                                            if(row.Contrat__c != null){
                                                row.ContratName = row.Contrat__r.Name;
                                            }
                                            row.id = row.Id;
                                            row.TypeRel = row.TypeRelation__c;
                                            if(row.Opportunite__c != null){
                                                row.OppName = row.Opportunite__r.Name;
                                            }
                                            
                                            if(row.ContactDuPartenaireLie__c != null){
                                                row.ContPartenaireLieName = row.ContactDuPartenaireLie__r.Name;
                                            }
                                        }
                                        res1.forEach(function (record){
                                            if(record.PartenaireLie__c != null){
                                                record.PartenaireLie = '/'+ record.PartenaireLie__c;
                                            }
                                            if(record.Partenaire__c != null){
                                                record.Partenaire = '/'+ record.Partenaire__c;
                                            }
                                            if(record.Contrat__c != null){
                                                record.Contrat = '/'+ record.Contrat__c;
                                            }
                                            if(record.Opportunite__c != null){
                                                record.Opp = '/'+ record.Opportunite__c;
                                            }
                                            if(record.ContactDuPartenaireLie__c != null){
                                                record.ContPartenaireLie = '/'+record.ContactDuPartenaireLie__c;
                                            }
                                            return record;
                                        });
                                        component.set("v.listforItteration",res1);
                                       
                                    }
                                     component.set("v.numb",res1.length);
                                }
                            });
        $A.enqueueAction(action1);
    },
    
    handleDelete: function(component, event, helper) 
    {
        var row = event.getParam('row');
        component.set("v.viewModal", true);
        component.set("v.recordToDelete",row.Id);
    },  
    
    handleCancel: function(component, event, helper) 
    {
        component.set("v.viewModal", false);
        component.set("v.recordToDelete","");
        component.set("v.error", ""); 
    },
    
    handleRecordDelete: function(component, event, helper) 
    {
        var action1 = component.get("c.deleteEco");
        action1.setParams({"ecoID": component.get("v.recordToDelete") });
        action1.setCallback(this, function(resp1)  
                            {
                                var state=resp1.getState();
                                if(state === "SUCCESS")
                                {
                                    var res1 = resp1.getReturnValue();
                                    
                                    if(res1[1]=="OK")
                                    { 
                                        component.set("v.viewModal", false);
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            mode: 'dismissible',
                                            duration: '3000',
                                            message: 'Écosystème du partenaire "'+ res1[0]+'" a été supprimé.',
                                            type : 'success'
                                        });
                                        toastEvent.fire();
                                        $A.get('e.force:refreshView').fire();
                                    }
                                    else
                                    {
                                        component.set("v.error", res1[1]); 
                                    }
                                }
                            });
        $A.enqueueAction(action1);
    }
})