({
	ReloadUrl : function(component) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
                    "url": 'lightning/r/Opportunity/'+component.get("v.newOpp")+'/view'
                });
                urlEvent.fire();
		
	}
})