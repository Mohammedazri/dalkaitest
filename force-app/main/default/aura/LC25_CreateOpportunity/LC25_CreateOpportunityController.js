({
    doInit : function(component, event, helper) {
        //call method to load the record types available for the user
        helper.loadRecordTypes(component,event,helper);
        helper.openmodal(component, helper);
    },
    
    Annuler : function(component, event, helper) {
        //hide the modal + clear the selected record type from the attribute
        helper.closeModal(component, helper);
        component.set("v.selectRT", '');
        component.set("v.selectRTId", '');
        //redirect to opportunity list view
        window.location.href = "/006/o";
    },
    
    onRadio: function(component, event) {
        // on radio button change save the text (text contains record type id) of the chosen radio
        var rtName = event.getSource().get("v.text").RTName;
        var rtId = event.getSource().get("v.text").RTId;
        component.set("v.selectRTId", rtId);
        component.set("v.selectRT",rtName);
    },
    
   /* clearSelection : function(component, event, helper){
        //blur -> uncheck the selected radio button
        event.getSource().set("v.value", false);
    },*/
    
    creationOPP : function(component, event, helper){
        var recordtypeName=component.get("v.selectRT");
        var recordtypeId = component.get("v.selectRTId");
        var oppMere = false;
        if (recordtypeName == 'Indépendante')
        {
            oppMere = false; 
        }
        else
        {
            oppMere = true; 
        }
        var createRecordEvent =$A.get("e.force:createRecord");
        var dte = new Date();
        var dYear = dte.getFullYear().toString();
        if(component.get("v.recordId")!=undefined)
        {
            createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId":recordtypeId,
                "defaultFieldValues": {
                    'StageName' : $A.get("$Label.c.Piste_PicklistValue"),
                    'AccountId': component.get("v.recordId"),
                    'Societevente__c':$A.get("$Label.c.SDV_Defaut"),
                    'Annee_de_signature__c':dYear,
                    'Type_pers__c':$A.get("$Label.c.PV_Opp_Type_Nouveau"),
                    'EstOpportuniteMere__c':oppMere,
                }     
            });
            
        }
        else
        {
            createRecordEvent.setParams({
                "entityApiName": "Opportunity",
                "recordTypeId":recordtypeId,
                "defaultFieldValues": {
                    'StageName' : $A.get("$Label.c.Piste_PicklistValue"),
                    'Societevente__c':$A.get("$Label.c.SDV_Defaut"),
                    'Annee_de_signature__c':dYear,
                    'Type_pers__c':$A.get("$Label.c.PV_Opp_Type_Nouveau"),
                    'EstOpportuniteMere__c':oppMere,
                }     
            });
        }
        createRecordEvent.fire();
    }
})