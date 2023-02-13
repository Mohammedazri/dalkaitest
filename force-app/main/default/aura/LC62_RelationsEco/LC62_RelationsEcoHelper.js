({
    getAccountEcoSysWrapperhelper : function(component, event, helper) {
        
        component.set('v.columns', [
            {label: 'PARTENAIRE LIÉ', fieldName: 'PartenaireLie', type: 'url', typeAttributes: { label: { fieldName: 'PartenaireLieName' },tooltip: { fieldName: 'PartenaireLieName' },target: '_blank' }},
            {label: 'TYPE DE RELATION', fieldName: 'TypeRel', type: 'text'},
            {label: 'CONTRAT', fieldName: 'Contrat', type: 'url', typeAttributes: { label: { fieldName: 'ContratName' },tooltip: { fieldName: 'ContratName' },target: '_blank' }},
            {label: 'CA en cours du contrat', fieldName: 'ContratCAEnCours', type: 'currency', typeAttributes: { currencyCode: "EUR" }},
            {label: 'OPPORTUNITÉ', fieldName: 'Opportunite', type: 'url', typeAttributes: { label: { fieldName: 'OpportuniteName' },tooltip: { fieldName: 'OpportuniteName' },target: '_blank' }},
            {label: 'CA Offre ', fieldName: 'OpportuniteCAOffre', type: 'currency', typeAttributes: { currencyCode: "EUR" }},
            { label: 'Statut', fieldName: 'Statut', type: 'text' }
        ]);

        var action = component.get('c.getAccountEcoSys');
        action.setParams({
            accountId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert(response.getReturnValue().length);
                var results = response.getReturnValue();
                if(results != null && results.length>0 )
                {
                    for (var i = 0; i < results.length; i++) 
                    {
                         var row = results[i];
                        if(row.PartenaireLie__c != null){
                            row.PartenaireLieName = row.PartenaireLie__r.Name;
                        }
                        if(row.Contrat__c != null){
                            row.ContratName = row.Contrat__r.Name;
                            row.ContratCAEnCours = row.Contrat__r.TotalCABudgetP1P2P3P4__c;
                        }
        				if(row.Opportunite__c != null){
                            row.OpportuniteName = row.Opportunite__r.Name;
                            row.OpportuniteCAOffre = row.Opportunite__r.Amount;
                        }
                        
                        row.id = row.Id;
                        row.TypeRel = row.TypeRelation__c;
                        
        				//row.Statut= row.Statut__c;
                    }
    				results.forEach(function (record){
                        if(record.PartenaireLie__c != null){
                        record.PartenaireLie = '/'+ record.PartenaireLie__c;
                    }
                     if(record.Contrat__c != null){
                        record.Contrat = '/'+ record.Contrat__c;
                    }
                    if(record.Opportunite__c != null){
                        record.Opportunite = '/'+ record.Opportunite__c;
                    }
                    return record;
                    });

                    component.set('v.showTable',true);
					component.set("v.listofEco", results);
                    //component.set('v.ecoSysWrappers', results);
                    
                    var i;
                    var partEco = component.get("v.partofEco");
                    partEco=[];
                    var initval=$A.get("$Label.c.LC33_NumDEcoAffic");
                    for (i = 0; i < initval; i++) 
                    {  
                        if(results[i]==null)
                        {
                            break; 
                        }
                        partEco.push(results[i]);
                        
                    }
                    component.set("v.partofEco",partEco);
                    component.set("v.listforItteration",partEco);
                    
                }else
                {
                    component.set('v.showTable',false);
                    component.set('v.error',$A.get("$Label.c.LC62_PartErrorMsg"));
                }
					component.set("v.numb",results.length);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContactEcoSysWrapperhelper: function(component, event, helper) {
        
         component.set('v.columns', [
            {label: 'CONTACT DU PARTENAIRE LIÉ', fieldName: 'ContPartenaireLie', type: 'url', typeAttributes: { label: { fieldName: 'ContPartenaireLieName' },target: '_blank' }},
            {label: 'PARTENAIRE LIÉ', fieldName: 'PartenaireLie', type: 'url', typeAttributes: { label: { fieldName: 'PartenaireLieName' },target: '_blank' }},
            {label: 'TYPE DE RELATION', fieldName: 'TypeRel', type: 'text'},
            {label: 'OPPORTUNITÉ', fieldName: 'Opportunite', type: 'url', typeAttributes: { label: { fieldName: 'OpportuniteName' },target: '_blank' }},
            {label: 'CONTRAT', fieldName: 'Contrat', type: 'url', typeAttributes: { label: { fieldName: 'ContratName' },target: '_blank' }},
        ]);
             
        var action = component.get('c.getContactEcoSys');
        action.setParams({
            contactId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert(response.getReturnValue().length);
                var results = response.getReturnValue();
                if(results != null && results.length>0 )
                {
                    for (var i = 0; i < results.length; i++) 
                    {
                        var row = results[i];
                        if(row.ContactDuPartenaireLie__c != null){
                            row.ContPartenaireLieName = row.ContactDuPartenaireLie__r.Name;
                        }
                        if(row.PartenaireLie__c != null){
                            row.PartenaireLieName = row.PartenaireLie__r.Name;
                        }
                        if(row.Contrat__c != null){
                            row.ContratName = row.Contrat__r.Name;
                        }
        				if(row.Opportunite__c != null){
                            row.OpportuniteName = row.Opportunite__r.Name;
                        }
                        
                        row.id = row.Id;
                        row.TypeRel = row.TypeRelation__c;
                    }
    				results.forEach(function (record){
                     if(record.ContactDuPartenaireLie__c != null){
                        record.ContPartenaireLie = '/'+record.ContactDuPartenaireLie__c;
                    }
                     if(record.PartenaireLie__c != null){
                        record.PartenaireLie = '/'+ record.PartenaireLie__c;
                    }
                     if(record.Contrat__c != null){
                        record.Contrat = '/'+ record.Contrat__c;
                    }
                    if(record.Opportunite__c != null){
                        record.Opportunite = '/'+ record.Opportunite__c;
                    }
                    return record;
                    });

                    component.set('v.showTable',true);
					component.set("v.listofEco", results);
                    //component.set('v.ecoSysWrappers', results);
                    
                    var i;
                    var partEco = component.get("v.partofEco");
                    partEco=[];
                    var initval=$A.get("$Label.c.LC33_NumDEcoAffic");
                    for (i = 0; i < initval; i++) 
                    {  
                        if(results[i]==null)
                        {
                            break; 
                        }
                        partEco.push(results[i]);
                        
                    }
                    component.set("v.partofEco",partEco);
                    component.set("v.listforItteration",partEco);
                    
                }else
                {
                    component.set('v.showTable',false);
                    component.set('v.error',$A.get("$Label.c.LC62_ContErrorMsg"));
                }
					component.set("v.numb",results.length);
            }
        });
        $A.enqueueAction(action);
    }
})