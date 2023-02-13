({
	// Your renderer method overrides go here
    rerender : function (component) {
        this.superRerender();
        // do custom afterRender here
        //component.set("v.contactWrapper.listChildren", '{}');
        //alert('superUnrender');
    }
})