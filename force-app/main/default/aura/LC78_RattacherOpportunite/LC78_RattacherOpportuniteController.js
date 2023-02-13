({
	doInit : function(component, event, helper) {
        component.set("v.Spinner", true); 
        helper.CheckOpp(component);
        helper.getCurrentOppMere(component);
        helper.LoadNaturePicklist(component);
    },
    //fires when the user chooses a member
    selectOpp: function(component, event, helper) { 
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.myvalue;
        var myid = selectedItem.dataset.myid;
        component.set("v.idChosen", myid);
        component.set("v.picklistValues",null);  
        component.set("v.oppName",Name);
        component.set("v.nameChosen",Name);
        component.set("v.canSave",true);
        if(Name != null && Name != '' && Name.length >0){
            component.set("v.natureChosen",$A.get("$Label.c.National_Regional"));
            component.find("oppNature").set("v.value", $A.get("$Label.c.National_Regional"));
        }
        else{
            component.set("v.natureChosen","");
        }
    },
    displayOppOptions: function(component, event, helper) { 
        if(component.get("v.oppName") != null && component.get("v.oppName").length > 0){
            component.set("v.canSave",false);
        }
        else{
            component.set("v.canSave",true);
        }
        if(component.get("v.oppName") == null || component.get("v.oppName").length > 0 || component.get("v.oppName") == ''){
            helper.getOpps(component, event, helper);
        }
        if(component.get("v.oppName") == null || component.get("v.oppName") == '' ){
            component.set("v.idChosen", "");
            component.set("v.natureChosen","");
        }
        
    },
    //create contract team member
    Soumettre: function(component, event, helper) { 
        helper.updateOpp(component, event, helper);
    },
    Cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})