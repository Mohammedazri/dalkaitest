({
	doInit : function(component, event, helper) {
        var action = component.get("c.getCurrentObject");
        action.setParams({ 
            FicheId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Currentrecord", response.getReturnValue());
                if(component.get("v.Currentrecord") != null)
                {
                    component.set("v.BudgetIDFromCont",  component.get("v.Currentrecord").Id);
                }
               //alert( component.get("v.Currentrecord").Id);
            }
       });
        $A.enqueueAction(action); 
        if(component.get("v.recordId").substring(0,3)==$A.get("$Label.c.LC27_ContratID"))
        {
            component.set("v.onContrat", true);
            component.set("v.onOpportunity", false);
           // helper.helperMethod(component);
            /*if(component.get("v.recordId").substring(0,3)==$A.get("$Label.c.LC27_OpportuntyID"))
            {
                component.set("v.showContrat", true);
            }*/
        }
        else if(component.get("v.recordId").substring(0,3)==$A.get("$Label.c.LC27_OpportuntyID")){
            component.set("v.onOpportunity", true);
            component.set("v.onContrat", false);
            //component.set("v.showNombreHeuresP2", false);
            //helper.helperMethod(component);
        }
        else
        {
            component.set("v.onContrat", false);
            component.set("v.onOpportunity", false);
        }
    }
      

})