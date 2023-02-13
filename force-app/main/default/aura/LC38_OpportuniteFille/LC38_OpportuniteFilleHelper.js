({
	 getStages: function(component) {
        var action = component.get('c.getStages');
        
        action.setCallback(this, function(response) {
            component.set("v.lstStages", response.getReturnValue());
            //alert (JSON.stringify(response.getReturnValue()));
        });
        $A.enqueueAction(action);
    },
})