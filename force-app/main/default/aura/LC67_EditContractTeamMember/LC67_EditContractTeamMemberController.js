({
    //cal function on load
    doInit: function(component, event, helper) {
		//get contract member Info
		helper.getContractMemberInfo(component, event, helper);
    },
    
    //display users options
	displayUserOptions: function(component, event, helper) { 
        if(component.get("v.memberName") == null || component.get("v.memberName").length > 0 || component.get("v.memberName") == '' ){
            
            helper.getUsers(component, event, helper);
        }
        
    },
    
    //edit contract team member
    Soumettre: function(component, event, helper) { 
        helper.EditMember(component, event, helper);
    },
    
    //fires when the user chooses a member
    selectMembre: function(component, event, helper) { 
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.myvalue;
        var myid = selectedItem.dataset.myid;
        component.set("v.idChosen", myid);
        component.set("v.picklistValues",null);  
        component.set("v.memberName",Name);
        component.set("v.nameChosen",Name);
        
        
    },
    
    //cancel button
    Cancel: function(component, event, helper) { 
        window.parent.location = '/' + component.get("v.membre").Contrat__c;
    },
    
    //fires when the user clicks outside of the users'menu
    closeMenu: function(component, event, helper) {
        var emptyArray = [];
        component.set("v.picklistValues",emptyArray);
    },
})