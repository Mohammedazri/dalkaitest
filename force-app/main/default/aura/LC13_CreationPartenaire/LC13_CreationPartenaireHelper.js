({
	loadRecordTypes : function(component, event, helper) {
        //call server side to load record types but first check if user can create account records
        var actionCheckCreation = component.get("c.canCreateAcc");
        actionCheckCreation.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                var res = resp.getReturnValue();
                //user can create accpount records
                if(res){
                    component.set("v.canCreateAcc", true);
                    //call method that retrieves the record types
                    helper.getListRT(component, event, helper);
                    
                }else{
                    component.set("v.canCreateAcc", false);
                }               
            }
        });
        $A.enqueueAction(actionCheckCreation);
    },
    fetchSegmentPicklist : function(component, event, helper){
        var action = component.get("c.getSegmentValues");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.SegmentPicklist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },
    fetchSousSegmentPicklist : function(component, event, helper){
        var action = component.get("c.getSousSegmentValues");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set("v.SousSegmentPicklist", a.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },
    fetchEffectifPicklist : function(component, event, helper){
        var action = component.get("c.getEffectifValues");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var response = a.getReturnValue();
                var listy = [];
                for (var key in response) {
                    if (response.hasOwnProperty(key)) {
                        listy.push({value: key, label: response[key]});
                    }
                };
                component.set("v.EffectifPicklist", listy);
                
            } 
        });
        $A.enqueueAction(action);
    },
    fetchSegmentDependenciesCodeNaf : function(component, helper , codeNaf){
        var action = component.get("c.getMapSSCodeNAF");
        
        action.setParams({ 
            codeNAF : codeNaf
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var segList = [];
                for(var key in a.getReturnValue()){
                    segList.push({segment:key, value:a.getReturnValue()[key]});
                }
                component.set("v.segmentValues", segList);
                component.set("v.newAccountModal", true);
                $A.util.toggleClass(component.find("mySpinner"), "slds-hide");
            } 
        });
        $A.enqueueAction(action);
    },
    fetchSegmentDependencies : function(component, helper){
        var action = component.get("c.getMapSS");
        
        action.setParams({ 
            parentPicklist : 'Segment_client__c',
            childPicklist : 'Sous_segment_client__c',
            objectAPIName : 'Account'
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                //component.set("v.segmentValues", a.getReturnValue());
                //var SSMap = component.get('v.segmentValues');
                var segList = [];
                for(var key in a.getReturnValue()){
                    segList.push({segment:key, value:a.getReturnValue()[key]});
                }
                component.set("v.segmentValues", segList);
                var testList = component.get("v.segmentValues");
                /*for(var key in testList){
                    alert(testList[key].segment);
                    for(var innerKey in testList[key].value){
                        alert(testList[key].value[innerKey]);
                    }
                }*/
            } 
        });
        $A.enqueueAction(action);
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
                var myRTs=component.find("myRt");
                if (myRTs instanceof Array)
                {
                    myRTs[0].set("v.value",true);
                    var rtId= myRTs[0].get("v.text");
                    component.set("v.selectRT", rtId);
                }
                else
                {
                    myRTs.set("v.value",true);
                    var rtId= myRTs.get("v.text");
                    component.set("v.selectRT", rtId);
                }
                console.log('rtId '+ rtId);
                if(rtId==$A.get("$Label.c.PartenaireSociete"))
                {
                    component.set("v.IFsociete",true);
                }
                else
                {
                    component.set("v.IFsociete",false);
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
        var cmpMaintenance = component.find('ModeMaintenance');
        
        var action = component.get("c.checkIfModeMaintenance");
        action.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                var res = resp.getReturnValue();
                if(res == true)
                {
                    $A.util.addClass(cmpMaintenance, 'slds-fade-in-open');
                }
                else
                {
                    $A.util.addClass(cmpTarget, 'slds-fade-in-open');
                    $A.util.addClass(cmpBack, 'slds-backdrop--open');    
                }
            }
        });
        $A.enqueueAction(action);
         
    },
    CreateAccountWithoutDefaultValues: function(component)
    {
        var recordtyeId=component.get("v.selectRT");
        var createRecordEvent =$A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account",
            "recordTypeId":recordtyeId,                           
        });
        createRecordEvent.fire();
    }
})