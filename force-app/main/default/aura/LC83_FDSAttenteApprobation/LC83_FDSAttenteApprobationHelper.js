({
    fetchAppHelper : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Commercial de l\'opportunité', fieldName: 'OppOwner', type: 'text'},
            {label: 'Fiche de Synthèse', fieldName: 'FDS', type: 'url', typeAttributes: { label: { fieldName: 'FDSName' },target: '_blank' } },
            {label: 'Date de soumission', fieldName: 'CreatedDate', type: 'text'}
        ]);
        var action = component.get("c.getApprobation");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var listApp = response.getReturnValue();
            if (state === "SUCCESS" &&  listApp != null && listApp != "") {
                for (var i = 0; i < listApp.length; i++) {
                    var row = listApp[i];
                    if(row.Date_de_soumission__c!=null)
                    {
                        var date = new Date(row.Date_de_soumission__c);
                        var formatted_date = date.getFullYear() + "-" + (((date.getMonth()+1)<10?'0':'')+(date.getMonth() + 1)) + "-" +(date.getDate()<10?'0':'')+ date.getDate() + " " +(date.getHours()<10?'0':'')+ date.getHours() + ":" + (date.getMinutes()<10?'0':'')+date.getMinutes() ;
                        row.CreatedDate = formatted_date.toString();
                    }
                    row.FDSName = row.tech_FicheDeSynthese__r.Name;
                    row.FDS = '/'+ row.tech_FicheDeSynthese__c;
                    row.OppOwner = row.tech_FicheDeSynthese__r.Opportunit_commerciale__r.Owner.Name ;
                    
                }
                component.set("v.appList", listApp);
                
                var pageSize = component.get("v.pageSize");
                component.set("v.totalRecords", component.get("v.appList").length);
                
                component.set("v.startPage", 0);                
                component.set("v.endPage", pageSize - 1);
                var PagList = [];
                for ( var i=0; i< pageSize; i++ ) {
                    if ( component.get("v.appList").length> i )
                        PagList.push(listApp[i]);    
                }
                component.set('v.PaginationappList', PagList);
                component.set('v.noData', false);
                
            }else{
                component.set('v.EmptyMessage', $A.get("$Label.c.LC83_messageApprob"));
                component.set('v.noData', true);
            }
            
        });
        $A.enqueueAction(action);
    }
})