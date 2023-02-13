({
    goToRecord:function(component,helper){
        //var navEvt = $A.get("e.force:navigateToSObject");
        var navEvt = $A.get("e.force:editRecord");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
        //$A.get("e.force:closeQuickAction").fire();
        //$A.get('e.force:refreshView').fire();
    }
})