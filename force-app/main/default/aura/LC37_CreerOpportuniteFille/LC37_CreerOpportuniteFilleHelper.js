({
    CheckOpp : function(component) {
        var action = component.get('c.getCurrentObject');
        
        action.setParams({ 
            OppId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            if (response.getReturnValue() != undefined){
                if(response.getReturnValue() == 'Non')
                {
                    component.set("v.ifNotShowOppFille", true);
                }
                else if (response.getReturnValue() == 'Oui')
                {
                    component.set("v.ifShowOppFille", true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    LoadOpp: function(component) {
        var action = component.get('c.getOpp');
        
        action.setParams({ 
            OppId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            component.set("v.OppMere", response.getReturnValue()); 
            var opp = component.get("v.NewOpp");
            if (component.get("v.OppMere").Name.includes("DSP"))
            {
            var NameF = component.get("v.OppMere").Name.split("DSP");
            var nameff = '';
            if (NameF.length==1)
            {
                opp.Name = component.get("v.OppMere").Name;
            }
            if (NameF.length==2)
            {
                opp.Name = NameF[0] +"SST";
            }
            if (NameF.length>2)
            {
                for (var i = 0; i < NameF.length-2; i++) 
                {
                    nameff=nameff+NameF[i]+"DSP";
                }
                nameff=nameff+NameF[NameF.length-2];
                opp.Name = nameff + "SST";
            }
            }
            if (component.get("v.OppMere").Name.includes("MAITRE"))
            {
            var NameF = component.get("v.OppMere").Name.split("MAITRE");
            var nameff = '';
            if (NameF.length==1)
            {
                opp.Name = component.get("v.OppMere").Name;
            }
            if (NameF.length==2)
            {
                opp.Name = NameF[0] +"SST";
            }
            if (NameF.length>2)
            {
                for (var i = 0; i < NameF.length-2; i++) 
                {
                    nameff=nameff+NameF[i]+"MAITRE";
                }
                nameff=nameff+NameF[NameF.length-2];
                opp.Name = nameff + "SST";
            }
            }
            if (component.get("v.OppMere").Name.includes("MAÎTRE"))
            {
            var NameF = component.get("v.OppMere").Name.split("MAÎTRE");
            var nameff = '';
            if (NameF.length==1)
            {
                opp.Name = component.get("v.OppMere").Name;
            }
            if (NameF.length==2)
            {
                opp.Name = NameF[0] +"SST";
            }
            if (NameF.length>2)
            {
                for (var i = 0; i < NameF.length-2; i++) 
                {
                    nameff=nameff+NameF[i]+"MAÎTRE";
                }
                nameff=nameff+NameF[NameF.length-2];
                opp.Name = nameff + "SST";
            }
            }
            if (component.get("v.OppMere").Name.includes("MAITRE (DSP)"))
            {
            var NameF = component.get("v.OppMere").Name.split("MAITRE (DSP)");
            var nameff = '';
            if (NameF.length==1)
            {
                opp.Name = component.get("v.OppMere").Name;
            }
            if (NameF.length==2)
            {
                opp.Name = NameF[0] +"SST";
            }
            if (NameF.length>2)
            {
                for (var i = 0; i < NameF.length-2; i++) 
                {
                    nameff=nameff+NameF[i]+"MAITRE (DSP)";
                }
                nameff=nameff+NameF[NameF.length-2];
                opp.Name = nameff + "SST";
            }
            }
            component.set("v.NewOpp", opp);
            
        });
        $A.enqueueAction(action);
    },
    
    SaveOpportunity:function(component,event, helper) {
        helper.showSpinner(component, event, helper);
        var action = component.get('c.CreateOpportunity');
        
        action.setParams({ 
            opp : component.get("v.NewOpp"),
            OppId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state=response.getState();
            if(state === "SUCCESS")
            {
                var resp=response.getReturnValue()
                if(resp.substring(0, 3)=="006")
                {
                    component.set("v.NewOppId", response.getReturnValue());     
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.NewOppId"),
                        "slideDevName": "Detail"
                    });
                    navEvt.fire();
                    helper.hideSpinner(component, event, helper);
                }
                else
                {
                    component.set("v.error", response.getReturnValue());
                    helper.hideSpinner(component, event, helper);
                    
                }
            }
            else
            {
                component.set("v.error", response.getError());
                helper.hideSpinner(component, event, helper);
                
            }
            
        });
        $A.enqueueAction(action);
        //alert(oppid);
        
    },
    
    LoadStagesPicklist: function(component) {
        var action = component.get('c.GetStagesPicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Oppstage", response.getReturnValue()); 
            component.set(("v.NewOpp.StageName"),component.get("v.Oppstage")[0].value);
            
        });
        $A.enqueueAction(action);
    },
    
    LoadMoisPicklist: function(component) {
        var action = component.get('c.GetMoisPicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Mois", response.getReturnValue()); 
            component.set(("v.NewOpp.Moisdesignature__c"),component.get("v.Mois")[0].value);
        });
        $A.enqueueAction(action);
    },
    
    LoadAnneePicklist: function(component) {
        var action = component.get('c.GetAnneePicklist');
        
        action.setCallback(this, function(response) {
            component.set("v.Annee", response.getReturnValue()); 
            var d = new Date();
            var dYear = d.getFullYear().toString();
            component.set(("v.NewOpp.Annee_de_signature__c"),dYear);
        });
        $A.enqueueAction(action);
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
})