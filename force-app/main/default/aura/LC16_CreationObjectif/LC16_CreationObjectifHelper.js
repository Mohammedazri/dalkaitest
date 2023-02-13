({
	loadCreateObject : function(component, event, helper) {
        //call server side to load record types but first check if user can create account records
        var actionCheckCreation = component.get("c.canCreateObjectif");
        actionCheckCreation.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                var res = resp.getReturnValue();
                //user can create accpount records
                if(res){
                    component.set("v.canCreateObjectif", true);
                    //call method that retrieves the record types
                    //not needed anymore
                    //helper.getListRT(component, event, helper);
                    var recordTypeId = component.get("v.pageReference").state.recordTypeId;
                    var createRecordEvent =$A.get("e.force:createRecord");
                    createRecordEvent.setParams({
                        "entityApiName": "Objectif__c",
                        "recordTypeId":recordTypeId,
                        "defaultFieldValues": {
                            'Name':'Champ Rempli Automatiquement',
                            'Annee__c':String(new Date().getFullYear()),  
                        }            
                    });
                    createRecordEvent.fire();
                    
                }else{
                    component.set("v.canCreateObjectif", false);
                }               
            }
        });
        $A.enqueueAction(actionCheckCreation);
    },
    
    /*getListRT : function(component, event, helper){
        //call server side method that retrieves the list of record types based on the connected user
        var action = component.get("c.getRecordTypes");

        action.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                //save the returned values in an array attribute
                var res = resp.getReturnValue();
                component.set("v.recordTypes", res);
                //set the first radio button as a defualt value
                var myRTs=component.find("myRt");
                //myRTs[0].set("v.value",true);//uncomment this line if we have more than one RT
                myRTs.set("v.value",true);//comment this line if we have more than one RT
                //var rtId= myRTs[0].get("v.text");//uncomment this line if we have more than one RT
                var rtId= myRTs.get("v.text");//comment this line if we have more than one RT
                component.set("v.selectRT", rtId);
            }
        });
        $A.enqueueAction(action);
    },*/
    
    /*closeModal:function(component,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openmodal: function(component,helper) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },*/

})