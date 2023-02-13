({
    doInit: function(component, event, helper) 
    {
        helper.helperdoinit(component, event, helper);
        var action = component.get("c.getCurrentStage");
        action.setParams({"FicheId": component.get("v.recordId")});
        action.setCallback(this, function(resp)  
                           {
                               var state=resp.getState();
                               if(state === "SUCCESS")
                               {
                                   if(resp.getReturnValue()==$A.get("$Label.c.LC28_Proposition")
                                      ||resp.getReturnValue()==$A.get("$Label.c.LC28_Realise"))
                                   {
                                       component.set("v.hideUpdateButton", true);
                                   }
                                   else
                                   {
                                       component.set("v.hideUpdateButton", false);
                                   }
                               }
                           });
        $A.enqueueAction(action);
        
    },
    
    handleCancel: function(component, event, helper) 
    {
        component.set("v.Closing", false);
    },
    
    handleSelect : function (component, event, helper) 
    {
        component.set("v.error", '');
        component.set("v.ifnoErrorExists",true);
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
                                   }
                                   var stepName = event.getParam("detail").value;
                                   
                                   if(stepName == $A.get("$Label.c.LC28_Closed")&& component.get("v.currentstage")!=$A.get("$Label.c.LC28_Realise"))
                                   {
                                       //faire controle s'il existe des opportunités de renouvellement non réalisées sur les contrats fils ou des contrats fils générés non synchronisés
                                       helper.checkifcanRealiseopp(component);
                                       //component.set("v.hideUpdateButton", true);
                                       //component.set("v.Closing", true);
                                   }    
                                   else if(component.get("v.currentstage")==$A.get("$Label.c.LC28_Realise"))
                                   {
                                       if(stepName==$A.get("$Label.c.LC28_Proposition") )
                                       {
                                           component.set("v.hideUpdateButton", false);
                                       }
                                       else
                                       {
                                           component.set("v.hideUpdateButton", true);
                                           component.set("v.Closing", false);
                                       }
                                   }
                                       else
                                       {
                                           component.set("v.hideUpdateButton", false);
                                           component.set("v.Closing", false);
                                           
                                       }
                                   if(res==$A.get("$Label.c.LC28_Proposition"))
                                   {
                                       if(stepName ==$A.get("$Label.c.LC28_Proposition") || 
                                          stepName ==$A.get("$Label.c.LC28_Realise"))
                                       {
                                           component.set("v.hideUpdateButton", true);
                                       }
                                       else
                                       {
                                           component.set("v.hideUpdateButton", false);
                                       }
                                   }
                               }
                           });
        $A.enqueueAction(action);
    },
    
    handleSave: function(component, event, helper) 
    {
        component.set("v.hideSpin" , false);
        var val = component.get("v.myContrat.Condition_de_fermeture__c");
        var dateF = component.get("v.myContrat.DateFin__c");
        var popUp =  component.get("v.ShowPopUp");
        var motifP = component.get("v.opportunity.Motif__c");
        var currentStatuts = component.get("v.selectedStatus");
        component.set("v.error",null);
        
        if ((val == undefined||dateF==undefined||dateF==null || (currentStatuts=="Perdue" && (motifP==undefined || motifP==""))) && popUp == true )
        {
            component.set("v.error","Veuillez remplir les champs obligatoires");
            component.set("v.hideSpin" , true);
        }
        else if(popUp == false)
        {
            if(currentStatuts=="Perdue" && (motifP==undefined || motifP==""))
            {
                component.set("v.error","Veuillez remplir les champs obligatoires");
                component.set("v.hideSpin" , true);
            }
            else
            {
                var action = component.get("c.setfields");
                action.setParams({ 
                    "OppId": component.get("v.recordId"),
                    "stat": component.get("v.selectedStatus") ,
                    "stage": component.get("v.selectedStageName"),
                    "contratorigine": null,
                    "motifPerte": component.get("v.opportunity.Motif__c")
                });
                action.setCallback(this, function(resp)  
                                   {
                                       var state=resp.getState();
                                       if(state === "SUCCESS")
                                       {
                                           var res = resp.getReturnValue();
                                           if(res=="OK")
                                           {
                                               component.set("v.Closing", false);
                                               component.set("v.currentstage" ,$A.get("$Label.c.LC28_Realise"));
                                               component.set("v.hideSpin" , true);
                                               $A.get('e.force:refreshView').fire();
                                           }
                                           else if(res.includes("OK_Evol_Syncro")){
                                            //Added By Jimmy Ano C360-475: pour les opp d'evol qui ont des doc syncro,
                                            //afficher un popup au user pour montre les champs qui ne redescend pas au contrat apre realisation
                                            let msg = res.replace("OK_Evol_Syncro,", "");
                                               component.set("v.Closing", false);
                                               component.set("v.ShowPopUpLWCEvol",true);
                                               component.set("v.evolMSG",msg);
                                               component.set("v.currentstage" ,$A.get("$Label.c.LC28_Realise"));
                                               component.set("v.hideSpin" , true);
                                               $A.get('e.force:refreshView').fire();
                                           }
                                           else if(res.includes("OK_Reouv_Contrat")){
                                                   //Added By CKH Ano C360-885: pour réouverture d'une opportunité d'origine sur un contrat synchronisé,
                                                   // à la réalisation de l'opportunité, mettre une alerte
                                                   component.set("v.ShowPopUpLWCReouvContrat",true);
                                                   component.set("v.ShowPopUp",false);
                                                   $A.get('e.force:refreshView').fire();
                                                   component.set("v.Closing", false);
                                                   component.set("v.currentstage" ,$A.get("$Label.c.LC28_Realise"));
                                                   component.set("v.hideSpin" , true);
                                               }
                                           else
                                           {
                                               component.set("v.error", res);
                                               component.set("v.hideSpin" , true);
                                           }
                                       }
                                       
                                   });
                
                $A.enqueueAction(action);   
            }
            
        }
            else
            {
                var action = component.get("c.setfields");
                action.setParams({ 
                    "OppId": component.get("v.recordId"),
                    "stat": component.get("v.selectedStatus") ,
                    "stage": component.get("v.selectedStageName"),
                    "contratorigine": component.get("v.myContrat"),
                    "motifPerte": component.get("v.opportunity.Motif__c")
                });
                action.setCallback(this, function(resp)  
                                   {
                                       var state=resp.getState();
                                       if(state === "SUCCESS")
                                       {
                                           var res = resp.getReturnValue();
                                           if(res=="OK")
                                           {
                                               component.set("v.ShowPopUp",false);
                                               $A.get('e.force:refreshView').fire();
                                               component.set("v.Closing", false);
                                               component.set("v.currentstage" ,$A.get("$Label.c.LC28_Realise"));
                                               component.set("v.hideSpin" , true);
                                           }
                                           else if(res.includes("OK_Evol_Syncro")){
                                            //Added By Jimmy Ano C360-475: pour les opp d'evol qui ont des doc syncro,
                                            //afficher un popup au user pour montre les champs qui ne redescend pas au contrat apre realisation
                                            let msg = res.replace("OK_Evol_Syncro,", "");
                                            component.set("v.ShowPopUpLWCEvol",true);
                                            component.set("v.evolMSG",msg);
                                            component.set("v.ShowPopUp",false);
                                               $A.get('e.force:refreshView').fire();
                                               component.set("v.Closing", false);
                                               component.set("v.currentstage" ,$A.get("$Label.c.LC28_Realise"));
                                               component.set("v.hideSpin" , true);
                                        }
                                               else if(res.includes("OK_Reouv_Contrat")){
                                                   //Added By CKH Ano C360-885: pour réouverture d'une opportunité d'origine sur un contrat synchronisé,
                                                   // à la réalisation de l'opportunité, mettre une alerte
                                                   component.set("v.ShowPopUpLWCReouvContrat",true);
                                                   component.set("v.ShowPopUp",false);
                                                   $A.get('e.force:refreshView').fire();
                                                   component.set("v.Closing", false);
                                                   component.set("v.currentstage" ,$A.get("$Label.c.LC28_Realise"));
                                                   component.set("v.hideSpin" , true);
                                               }
                                           else 
                                           {
                                               component.set("v.error",resp.getReturnValue());
                                               component.set("v.hideSpin" , true);
                                           }
                                       }
                                   }
                                  );
                $A.enqueueAction(action);
            }
    },
    
    
    onSelectChange: function(component, event, helper) 
    {
        var motifSelected = component.get("v.myContrat").Motif_fermeture_contrat__c;
        if(motifSelected != null && motifSelected != ''){
            component.set('v.disableCondition', false);
            var action = component.get('c.LoadDependantConditionValues');
            action.setParams({ 
                MotifFermetureSelected : component.get("v.myContrat").Motif_fermeture_contrat__c
            });
            action.setCallback(this, function(resp1)  
                               {
                                   var state=resp1.getState();
                                   if(state === "SUCCESS")
                                   {
                                       var res1 = resp1.getReturnValue();
                                       component.set("v.ConditionsList", resp1.getReturnValue());
                                   }
                               }
                              );
            $A.enqueueAction(action);
        }else{
            component.set("v.ConditionsList", ' ');
            component.set('v.disableCondition', true);
        }
    },
    
    loadMotifvalues: function(component, event, helper)
    {
        component.set('v.hideSpin',false);
        helper.Loadcontrat(component);
        component.set('v.hideSpin',true);
    }
    
    
})