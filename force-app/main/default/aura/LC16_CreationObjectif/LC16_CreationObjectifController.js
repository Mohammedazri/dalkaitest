({
	doInit : function(component, event, helper) {
        //call method to load the record types available for the user
        helper.loadCreateObject(component,event,helper);
        //helper.openmodal(component, helper);
    },
    
    /*Annuler : function(component, event, helper) {
        //hide the modal + clear the selected record type from the attribute
        helper.closeModal(component, helper);
        component.set("v.selectRT", '');
        window.location.href = "/a0B/o";
    },
    
    onRadio: function(component, event) {
        // on radio button change save the text (text contains record type id) of the chosen radio
        var rtId = event.getSource().get("v.text");
        component.set("v.selectRT", rtId);
    },
    
    clearSelection : function(component, event, helper){
        //blur -> uncheck the selected radio button
        event.getSource().set("v.value", false);
    },
    
    newObjectif : function(component, event, helper) {
        var recordtyeId=component.get("v.selectRT");
        var createRecordEvent =$A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Objectif__c",
            "recordTypeId":recordtyeId,
            "defaultFieldValues": {
                'Name':'Champ Rempli Automatiquement',
                'Annee__c':new Date().getFullYear(),                               
            }            
        });
        createRecordEvent.fire();
    },*/
})