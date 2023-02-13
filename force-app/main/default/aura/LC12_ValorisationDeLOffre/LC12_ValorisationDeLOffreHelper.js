({
    GetTechCdtRefSelected : function(component) {
        var action1 = component.get("c.GetConditionDeReferenceSelected");
        action1.setParams({ 
            FicheId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var numb;
                component.set('v.CdtRefSelectionnee', response.getReturnValue());
                if(response.getReturnValue() == $A.get("$Label.c.LC12_Budget")){
                    numb='Budget';
                }else if(response.getReturnValue() == $A.get("$Label.c.LC12_Realise")){
                    numb='Realise';
                }else if(response.getReturnValue() == $A.get("$Label.c.LC12_Saisie")){
                    numb='Saisie';
                }else if(response.getReturnValue() == null ){
                    numb='Budget';
                }
                
                var action2 = component.get('c.LoadWrapper'+numb);
                action2.setParams({ 
                    FicheId : component.get("v.recordId")
                });
                
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        component.set("v.wrapper", response.getReturnValue());
                        component.set("v.Currentrecord", response.getReturnValue().CurrentFiche);
                        component.set('v.CdtRefSelectionnee', response.getReturnValue().CurrentFiche.Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c);
                        var CdtRefSelectionnee = component.get('v.CdtRefSelectionnee');
                        
                        var action3 = component.get("c.GetConditionDeReferencePicklistValues");
                        action3.setCallback(this, function(a){
                            component.set("v.listOfCdts", a.getReturnValue());
                            if(CdtRefSelectionnee != '' && CdtRefSelectionnee != null ){
                                component.set("v.ConditionValue", CdtRefSelectionnee);
                            }else{
                                component.set("v.ConditionValue", 'Budget');
                            }
                        });
                        $A.enqueueAction(action3); 
                        
                    }
                    else
                    {
                        component.set("v.error", response.getReturnValue());
                    }
                });
                $A.enqueueAction(action2);
            }
        });
        $A.enqueueAction(action1);
    },
    
    getConditionOfPicklist : function(component) {
        var action = component.get('c.getConditionOfPicklist');
        action.setParams({ 
            FicheId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.IfNotSelectable", response.getReturnValue());
            }
           
        });
        $A.enqueueAction(action);
    },
    
    GetTableWrapper : function(component, numb ) {
        var action = component.get('c.LoadWrapper'+numb);
        action.setParams({ 
            FicheId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.wrapper", response.getReturnValue());
                component.set("v.Currentrecord", response.getReturnValue().CurrentFiche);
                component.set('v.CdtRefSelectionnee', response.getReturnValue().CurrentFiche.Opportunit_commerciale__r.Tech_CdtRefSelectionnee__c);
                var CdtRefSelectionnee = component.get('v.CdtRefSelectionnee');
            }
            else
            {
                component.set("v.error", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})