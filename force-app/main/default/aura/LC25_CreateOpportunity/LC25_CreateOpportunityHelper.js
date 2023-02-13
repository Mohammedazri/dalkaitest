({
    loadRecordTypes : function(component, event, helper) {
        //call server side to load record types but first check if user can create Oportunity records
        var actionCheckCreation = component.get("c.canCreateOpp");
        actionCheckCreation.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                var res = resp.getReturnValue();
                //user can create Opportunity records
                if(res){
                    component.set("v.canCreateOpp", true);
                    //call method that retrieves the record types
                    helper.getListRT(component, event, helper);
                    
                }else{
                    component.set("v.canCreateOpp", false);
                }               
            }
        });
        $A.enqueueAction(actionCheckCreation);
    },
    
    getListRT : function(component, event, helper){
        //call server side method that retrieves the list of record types based on the connected user
        var action = component.get("c.getRecordTypes");

        action.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                //save the returned values in an array attribute
                var res = resp.getReturnValue();
                component.set("v.recordTypes", res);
                //set the first radio button as a defualt value              
                if (res instanceof Array && res.length>1)
                {
                    component.set("v.ChooseRT", true);
                    var cmpTarget = component.find('Modalbox');
                    var cmpBack = component.find('Modalbackdrop');
                    $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                    $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
                    var myRTs=component.find("myRt");
                    component.set("v.ChooseRT", true);
                    myRTs[0].set("v.value",true);
                    var rtId= myRTs[0].get("v.text");
                    component.set("v.selectRT", res[0].RTName);
                    component.set("v.selectRTId", res[0].RTId);
                }
                else
                {
                    //var myRTs=component.find("myRt");
                    //myRTs.set("v.value",true);
                    component.set("v.ChooseRT", false);
                    //var rtId= myRTs.get("v.text");
                    var rtId=res[0].RTId;
                    component.set("v.selectRT", res[0].RTName);
                    component.set("v.selectRTId", res[0].RTId);
                    var recordtypeId=rtId;
                    var createRecordEvent =$A.get("e.force:createRecord");
                    var accid = null;
                    var dte = new Date();
                    var dYear = dte.getFullYear().toString();
                    var oppMere = false;
                    if (res[0].RTName == 'Indépendante')
                    {
                       oppMere = false; 
                    }
                    else
                    {
                       oppMere = true; 
                    }
                    if(component.get("v.recordId")!=undefined)
                    {
                        accid = component.get("v.recordId");
                        createRecordEvent.setParams({
                            "entityApiName": "Opportunity",
                            "recordTypeId":recordtypeId,
                            "defaultFieldValues": {
                                'StageName' : $A.get("$Label.c.Piste_PicklistValue"),
                                'Societevente__c':$A.get("$Label.c.SDV_Defaut"),
                                'AccountId':accid,
                                'Annee_de_signature__c':dYear,
                                'EstOpportuniteMere__c':oppMere,
                                'Type_pers__c':$A.get("$Label.c.PV_Opp_Type_Nouveau"),
                            }     
                        });
                        createRecordEvent.fire();
                    }
                    else{
                        createRecordEvent.setParams({
                            "entityApiName": "Opportunity",
                            "recordTypeId":recordtypeId,
                            "defaultFieldValues": {
                                'StageName' : $A.get("$Label.c.Piste_PicklistValue"),
                                'Societevente__c':$A.get("$Label.c.SDV_Defaut"),
                                'Annee_de_signature__c':dYear,
                                'EstOpportuniteMere__c':oppMere,
                                'Type_pers__c':$A.get("$Label.c.PV_Opp_Type_Nouveau"),
                                
                            }     
                        });
                        createRecordEvent.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    closeModal:function(component,helper){    
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
    },
})