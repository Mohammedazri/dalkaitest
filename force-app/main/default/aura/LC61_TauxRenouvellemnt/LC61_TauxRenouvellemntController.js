({
    doInit : function(component, event, helper) {
        var action1 = component.get('c.calculTauxdeRenouvellementGlobal');
        action1.setParams({ 
            Segment : 'N/A',
        });
        action1.setCallback(this, function(response) {
            component.set("v.TauxGlobal", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);
        
        var action2 = component.get('c.calculTauxdeRenouvellementRegion');
        action2.setParams({ 
            Segment : 'N/A',
        });
        action2.setCallback(this, function(response) {
            component.set("v.TauxRegion", response.getReturnValue()); 
        });
        $A.enqueueAction(action2);
        
        var action3 = component.get('c.calculTauxdeRenouvellementAgence');
        action3.setParams({ 
            Segment : 'N/A',
        });
        action3.setCallback(this, function(response) {
            component.set("v.TauxAgence", response.getReturnValue()); 
        });
        $A.enqueueAction(action3);
        
        var action4 = component.get('c.calculTauxdeRenouvellementUtilisateur');
        action4.setParams({ 
            Segment : 'N/A',
        });
        action4.setCallback(this, function(response) {
            component.set("v.TauxUtilisateur", response.getReturnValue()); 
        });
        $A.enqueueAction(action4);
        
        
        var action5 = component.get("c.GetSegementPicklistValues");
        action5.setCallback(this, function(a){
            component.set("v.listOfSegments", a.getReturnValue());
        });
        $A.enqueueAction(action5); 
    },
    
    onPicklistChangeG:function(component, event, helper) {
        component.set("v.TauxGlobal",null);
        var action1 = component.get('c.calculTauxdeRenouvellementGlobal');
        action1.setParams({ 
            Segment : component.get('v.GlobalValueG')
        });
        action1.setCallback(this, function(response) {
            component.set("v.TauxGlobal", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);
    },
    
    onPicklistChangeR:function(component, event, helper) {
        component.set("v.TauxRegion",null);
        var action1 = component.get('c.calculTauxdeRenouvellementRegion');
        action1.setParams({ 
            Segment : component.get('v.GlobalValueR')
        });
        action1.setCallback(this, function(response) {
            component.set("v.TauxRegion", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);
    },
    
    
    onPicklistChangeA:function(component, event, helper) {
        component.set("v.TauxAgence",null);
        var action1 = component.get('c.calculTauxdeRenouvellementAgence');
        action1.setParams({ 
            Segment : component.get('v.GlobalValueA')
        });
        action1.setCallback(this, function(response) {
            component.set("v.TauxAgence", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);
    },
    
    onPicklistChangeU:function(component, event, helper) {
        component.set("v.TauxUtilisateur",null);
        var action1 = component.get('c.calculTauxdeRenouvellementUtilisateur');
        action1.setParams({ 
            Segment : component.get('v.GlobalValueU')
        });
        action1.setCallback(this, function(response) {
            component.set("v.TauxUtilisateur", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);    
    },
    
})