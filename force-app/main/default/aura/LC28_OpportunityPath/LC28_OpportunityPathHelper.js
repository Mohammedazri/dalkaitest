({
	helperMethod : function(component) {
		 var action = component.get("c.getCurrentStage");
        action.setParams({"FicheId": component.get("v.recordId")});
        action.setCallback(this, function(resp)  
                           {
                               var state=resp.getState();
                               if(state === "SUCCESS")
                               {
                                   var res = resp.getReturnValue();
                                   if(res != null) 
                                   {
                                       component.set("v.currentstage", res);
                                       
                                       if(component.get("v.currentstage")==$A.get("$Label.c.LC28_Realise"))
                                       {
                                           component.set("v.hideUpdateButton", true);
                                       }
                                   }
                                   
                               }
                           });
        $A.enqueueAction(action);
        
        var action2 = component.get("c.getUserInfo");
        action2.setCallback(this, function(resp2)  
                           {
                               var state2=resp2.getState();
                               if(state2 === "SUCCESS")
                               {
                                   var res2 = resp2.getReturnValue();
                                   if(res2 != null) 
                                   {
                                       component.set("v.BypassUser", res2);
                                   }
                                   
                               }
                           });
        $A.enqueueAction(action2);
	},
    
    Loadcontrat : function(component) 
    {
        var action = component.get('c.getContratdOrigine');
        action.setParams({
            OppID : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if( response.getReturnValue()!= null)
            {
                //alert('OK');
                component.set("v.myContrat", response.getReturnValue());
                component.set("v.ShowPopUp",true);
                var action1 = component.get('c.GetMotifsDeFermeture');
                action1.setParams({ 
                    stat : component.get("v.selectedStatus")
                });
                action1.setCallback(this, function(response) 
                                    {
                                        component.set("v.MotifsList", response.getReturnValue());
                                        //alert(component.get("v.myContrat.Motif_fermeture_contrat__c"));
                                        if( component.get("v.myContrat.Motif_fermeture_contrat__c") != '')
                                        {
                                            //alert('1 2 3');
                                            var action2 = component.get('c.LoadDependantConditionValues');
                                            action2.setParams({ 
                                                MotifFermetureSelected : component.get("v.myContrat.Motif_fermeture_contrat__c")
                                            });
                                            action2.setCallback(this, function(resp1)  
                                                                {
                                                                    var state=resp1.getState();
                                                                    if(state === "SUCCESS")
                                                                    {
                                                                        var res1 = resp1.getReturnValue();
                                                                        //alert('res1.....'+res1);
                                                                        component.set("v.ConditionsList", resp1.getReturnValue());
                                                                        component.set("v.disableCondition",false);
                                                                    }
                                                                }
                                                               );
                                            $A.enqueueAction(action2);
                                        }
                                    });
                $A.enqueueAction(action1);
            }
            else
            {   
                //alert('else');
                component.set("v.ShowPopUp",false);
            }
        });
        $A.enqueueAction(action);
        
        if('Perdue' == component.get("v.selectedStatus"))
        {
            component.set("v.showMotifPerte",true);
        }
        else
        {
            component.set("v.showMotifPerte",false);
        }
    },
    
    checkifcanRealiseopp : function(component) 
    {
        var action = component.get("c.checkIfCanRealiseOpp");
        action.setParams({"OppID": component.get("v.recordId")});
        action.setCallback(this, function(resp)  {
            var state=resp.getState();
            if(state === "SUCCESS")
            {
                var res = resp.getReturnValue();
                if(res!= null){
                    if(res.canRealise ===true){
                        component.set("v.hideUpdateButton", true);
                        component.set("v.Closing", true);
                    }
                    else{
                        var myerror=$A.get("$Label.c.LC28_RealiseOppError");
                        if(res.ifContratNonSynchroniseexiste ===true){
                            myerror+="<br/><br/>" + $A.get("$Label.c.LC28_OppPossContratNonSync") + ":<br/>";
                            myerror+=res.NumerosContratsNonsynchronises;
                        }
                        if(res.ifOppNonRealise ===true){
                            myerror+="<br/><br/>" + $A.get("$Label.c.LC28_PossOppNonrealise") + ":<br/>";
                            myerror+=res.NumerosContratsOppNonRealise;
                        }
                        if(res.ifDocumentNonSyncNonValidExiste ===true){
                            myerror+="<br/><br/>" + $A.get("$Label.c.LC28_DocContNonSyncNonValid");
                            //myerror+=res.numerosDocContNonSyncNonValid;
                        }
                        component.set("v.error",myerror);
                        component.set("v.hideSpin" , true);
                        component.set("v.ifnoErrorExists",false);
                        //component.set("v.hideUpdateButton", true);
                        component.set("v.Closing", true);
                    }
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getIfShowMsg : function(component) {
         var action = component.get("c.getIfShowHelpText");
        action.setParams({"OppID": component.get("v.recordId")});
        action.setCallback(this, function(resp)  {
            var state=resp.getState();
            if(state === "SUCCESS")
            {
                var res = resp.getReturnValue();
                if(res!= null){
                    if(res ===true){
                        component.set("v.ifShowHelpText",true);
                    }
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);  
    },
    
    helperdoinit : function(component, event, helper) {
         helper.helperMethod(component);
        component.set("v.title", $A.get("$Label.c.LC28_titre")   );  
        
        var action2 = component.get("c.getContratdOrigine");
        action2.setParams({
            "OppID": component.get("v.recordId")
        });
        action2.setCallback(this, function(resp2)  
                            {
                                var state=resp2.getState();
                                if(state === "SUCCESS")
                                {
                                    var res2 = resp2.getReturnValue();
                                    if(res2 != null && res2.DateFin__c!=null) 
                                    {
                                        //('res2 '+ res2.Condition_de_fermeture__c + res2.Motif_fermeture_contrat__c);
                                        component.set("v.myContrat",res2);
                                        component.set("v.disableDate",true);
                                    }
                                }
                            });
        $A.enqueueAction(action2);
        
        
        var action1 = component.get("c.getselectOptions");
        action1.setParams({"OppId": component.get("v.recordId")});
        action1.setCallback(this, function(resp1)  
                            {
                                var state=resp1.getState();
                                if(state === "SUCCESS")
                                {
                                    var res1 = resp1.getReturnValue();
                                    if(res1 != null) 
                                    {
                                        component.set("v.Stagenames", res1);
                                        
                                        if(res1.length<=1)
                                        {
                                            component.set("v.StageNameDisable",true);
                                            
                                        }
                                        component.set("v.selectedStageName",res1[0]);
                                    }
                                    console.log(res1);
                                }
                            });
        $A.enqueueAction(action1);
        
        var action2 = component.get("c.getStatus");
        action2.setParams({"OppId": component.get("v.recordId")});
        action2.setCallback(this, function(resp2)  
                            {
                                var state2=resp2.getState();
                                if(state2 === "SUCCESS")
                                {
                                    //alert(res2);
                                    var res2 = resp2.getReturnValue();
                                    if(res2 != null) 
                                    {
                                        component.set("v.Status", res2);
                                        if(component.get("v.disableDate") == true)
                                        {
                                        	component.set("v.selectedStatus",res2[1]);
                                            component.set("v.disableStatus",true);
                                        }
                                        else
                                        {
                                            component.set("v.selectedStatus",res2[0]);
                                        }
                                    }
                                    console.log(res2);
                                }
                            });
        $A.enqueueAction(action2);
        
        var action10 = component.get('c.QueryingOpportunityFields');
        action10.setParams({ 
            OppID : component.get("v.recordId")
        });
        action10.setCallback(this, function(resp)  
                             {
                                 var state=resp.getState();
                                 if(state === "SUCCESS")
                                 { 
                                     var oppObject = resp.getReturnValue();
                                     helper.Loadcontrat(component);
                                 }
                             });
        $A.enqueueAction(action10);

        var action3 = component.get("c.getMotifPerteValues");
        action3.setCallback(this, function(response3) {
            var state3 = response3.getState();
            if (state3 === "SUCCESS") {
                var result3 = response3.getReturnValue();
                var fieldMap = [];
                for(var key in result3){
                    fieldMap.push({key: key, value: result3[key]});
                }
                component.set("v.fieldMap", fieldMap);
            }
        });
        $A.enqueueAction(action3);
        
        
        var action4 = component.get("c.getSelectedMotifPerte");
        action4.setParams({ 
            OppID : component.get("v.recordId")
        });
        action4.setCallback(this, function(response4) {
            var state4 = response4.getState();
            if (state4 === "SUCCESS") {
                var result4 = response4.getReturnValue();
                component.set("v.opportunity.Motif__c",result4);
            }
        });
        $A.enqueueAction(action4);
        
        helper.getIfShowMsg(component);
        
    }
})