({
    doInit: function(component, event, helper) 
    {   
        var tempId = component.get("v.recordId").substring(0, 3);
        if(tempId == "001")
        {
            component.set("v.Titre", $A.get("$Label.c.LC56_EcoPartenaire"));
        }
        else if(tempId == "003")
        {
            component.set("v.Titre", $A.get("$Label.c.LC56_EcoContact"));
        }
        
        
        component.set("v.accountId", component.get("v.recordId"));
        component.set('v.columns', [
            {label: 'TYPE DE RELATION', fieldName: 'TypeRel', type: 'text'},
            {label: 'CONTACT DU PARTENAIRE LIÉ', fieldName: 'ContPartenaireLie', type: 'url', typeAttributes: { label: { fieldName: 'ContPartenaireLieName' },target: '_blank' }},
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
                                    var res1 = resp1.getReturnValue();
                                    
                                    if(res1 != null && res1.length!=0 ) 
                                    {
                                        for (var i = 0; i < res1.length; i++) 
                                        {
                                            var row = res1[i];
                                            if(row.PartenaireLie__c != null){
                                                row.PartenaireLieName = row.PartenaireLie__r.Name;
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
                                        component.set("v.showTable", true);
                                        component.set("v.listofEco", res1);
                                    }
                                    component.set("v.numb",res1.length);
                                    var i;
                                    var partEco = component.get("v.partofEco");
                                    partEco=[];
                                    var initval=$A.get("$Label.c.LC33_NumDEcoAffic");
                                    for (i = 0; i < initval; i++) 
                                    {  
                                        if(res1[i]==null)
                                        {
                                            break; 
                                        }
                                        partEco.push(res1[i]);
                                        
                                    }
                                    component.set("v.partofEco",partEco);
                                    component.set("v.listforItteration",partEco);
                                }
                            });
        $A.enqueueAction(action1);
        
        
    },
    
    handleViewAllClick: function(component, event, helper) 
    {
        //component.set("v.listforItteration",component.get("v.listofEco"));
        //component.set("v.viewAll", true);
        var tempId = component.get("v.recordId").substring(0, 3);
        var stringtoUrl ;
        if(tempId == "001")
        {
            //stringtoUrl= 'Ecosystemes_du_partenaire__r';
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:LC59_RelatedListEco",
                componentAttributes :{ recordId : component.get("v.recordId") }
            });
            evt.fire();
        }
        else if(tempId == "003")
        {
            stringtoUrl= 'ContactDuPartenaire__r';
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lightning/r/"+component.get("v.recordId")+"/related/"+stringtoUrl+"/view"
            });
            
            urlEvent.fire();
        }
        
    },
    
    handleViewLessClick: function(component, event, helper) 
    {
        component.set("v.listforItteration",component.get("v.partofEco"));
        component.set("v.viewAll", false);
    }, 
    handleRowAction: function (cmp, event, helper) {
       
     	var row = event.getParam('row');   
        
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
    },
    
    handleEdits: function(component, event, helper) 
    {
        var ediRecordEvent = $A.get("e.force:editRecord");
        ediRecordEvent.setParams({
            "recordId": event.currentTarget.dataset.value
        });
        ediRecordEvent.fire();   
    }, 
    
    handleNewClick: function(component, event, helper) 
    {
        var visibility = component.find('visibility');
        $A.util.addClass(visibility, 'slds-backdrop--open');
        
        var recordId = component.get("v.recordId");
        var showDiv = document.getElementById("showCreateCmp_"+recordId);
        showDiv.style.display = "block";
    },
    
    ifShowCreateCmpChange: function(component, event, helper) 
    {
        var recordId = component.get("v.recordId");
        var showDiv = document.getElementById("showCreateCmp_"+recordId);
        showDiv.style.display = "none";
        $A.get('e.force:refreshView').fire();
    },
})