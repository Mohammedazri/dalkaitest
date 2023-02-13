({
    doInit : function(component, event, helper) {
        //call method to load the record types available for the user
        helper.loadRecordTypes(component,event,helper);
        helper.openmodal(component, helper);
        helper.fetchSegmentPicklist(component,event,helper);
        helper.fetchSousSegmentPicklist(component,event,helper);
        helper.fetchEffectifPicklist(component,event,helper);
        helper.fetchSegmentDependencies(component,helper);
        
    },
    saveAccount : function(component, event, helper) {
        var spinner = component.find("mySpinnerTop");
        $A.util.toggleClass(spinner, "slds-hide");
        var action = component.get("c.insertAccounts");
        var acc = component.get("v.accountToInsert");
        if(component.get("v.accountToInsert").Segment_client__c == '' 
           || component.get("v.accountToInsert").Segment_client__c == null)
        {
            component.set("v.emptySegment",true);
            component.get("v.accountToInsert").Sous_segment_client__c = '';
            $A.util.toggleClass(spinner, "slds-hide");
        }
        else if ( (component.get("v.accountToInsert").Sous_segment_client__c == '' || component.get("v.accountToInsert").Sous_segment_client__c == ' '
                   || component.get("v.accountToInsert").Sous_segment_client__c == null) && (component.get("v.accountToInsert").Segment_client__c != '' 
                                                                                             || component.get("v.accountToInsert").Segment_client__c != null))
        {
            component.set("v.emptySegment",false);
            component.set("v.emptySousSegment",true);
            $A.util.toggleClass(spinner, "slds-hide");
        }
            else if ( component.get("v.accountToInsert").Sous_segment_client__c == '' || component.get("v.accountToInsert").Sous_segment_client__c == ' '
                     || component.get("v.accountToInsert").Sous_segment_client__c == null)
            {
                component.set("v.emptySousSegment",true);
                $A.util.toggleClass(spinner, "slds-hide");
            }
        
        //alert(component.get("v.accountToInsert").Segment_client__c);
        //alert(component.get("v.accountToInsert").Sous_segment_client__c);
        
                else{
                    //  alert(component.get("v.accountToInsert").Segment_client__c);
                    //  alert(component.get("v.accountToInsert").Sous_segment_client__c);  
                    //  alert(component.get("v.accountToInsert")); 
                    component.set("v.emptySegment",false);
                    component.set("v.emptySousSegment",false);
                    
                    action.setParams({ 
                        acc : JSON.stringify(component.get("v.accountToInsert"))
                    });
                    
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        //alert(state);
                        if (state === "SUCCESS") {
                            if(response.getReturnValue().startsWith("001")){
                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId": response.getReturnValue(),
                                    "slideDevName": "related"
                                });
                                navEvt.fire();
                            }
                            else{
                                component.set("v.newAccountModal",false);
                                component.set("v.errorSaveMsg",response.getReturnValue());
                                component.set("v.errorModal",true);
                            }
                        }
                        else{
                            component.set("v.newAccountModal",false);
                            component.set("v.errorSaveMsg",response.getReturnValue());
                            component.set("v.errorModal",true);
                        }
                        $A.util.toggleClass(spinner, "slds-hide");
                    });
                    $A.enqueueAction(action);
                }
    },
    Annuler : function(component, event, helper) {
        //hide the modal + clear the selected record type from the attribute
        helper.closeModal(component, helper);
        component.set("v.selectRT", '');
        window.location.href = "/001/o";
    },
    
    onRadio: function(component, event) {
        // on radio button change save the text (text contains record type id) of the chosen radio
        var rtId = event.getSource().get("v.text");
        component.set("v.selectRT", rtId);
        if(rtId==$A.get("$Label.c.PartenaireSociete"))
        {
            component.set("v.IFsociete",true);
        }
        else
        {
            component.set("v.IFsociete",false);
        }
    },
    
    clearSelection : function(component, event, helper){
        //blur -> uncheck the selected radio button
        event.getSource().set("v.value", false);
    },
    
    creationAcc : function(component, event, helper) {
        if(component.get("v.IFsociete"))
        {
            component.set("v.ChooseRT", false);
        }
        else
        {
            helper.CreateAccountWithoutDefaultValues(component);
        }
    },
    
    SiretChanged : function(component, event, helper) {
        var enteredvalue=event.target.value;
        if(enteredvalue.replace(/ /g,'').length>0)
        {
            component.set("v.IsSiretEmpty", false);
        }
        else
        {
            component.set("v.IsSiretEmpty", true);
        }
        component.set("v.SiretEntered",enteredvalue);
    },
    
    newAccount : function(component, event, helper) { 
        component.set("v.emptySegment",false);
        component.set("v.emptySousSegment",false);
        //load the spinner
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        if(component.get("v.SiretEntered")!= null && component.get("v.SiretEntered").replace(/ /g,'')!= '')
        {
            //check if siret entered already exists in Salesforce
            var action = component.get('c.getIfSiretExists');
            action.setParams({ 
                SiretEntered : component.get("v.SiretEntered").replace(/ /g,''),
            });
            
            action.setCallback(this, function(response) {
                if(response.getReturnValue())
                {
                    component.set("v.ErrorMsg", $A.get("$Label.c.LC13_SiretDupliquee"))
                    component.set("v.IsSiretValid", false);
                    helper.openmodal(component, helper);
                    $A.util.toggleClass(spinner, "slds-hide");
                }
                else
                {
                    //call webservice siret to get Account informations based on the siret enter
                    var action = component.get('c.getAccountInfos');
                    action.setParams({ 
                        SiretEntered : component.get("v.SiretEntered").replace(/ /g,''),
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (component.isValid() && state === "SUCCESS") {
                            var myresponse=response.getReturnValue();
                            if(response.getReturnValue()!= null)
                            {
                                var result = JSON.parse(myresponse);
                                var recordtyeId=component.get("v.selectRT");
                                var createRecordEvent =$A.get("e.force:createRecord");
                                var acc = component.get("v.accountToInsert");
                                acc.Name  = result.etablissement.libelleEtablissement;
                                acc.Enseigne__c = result.etablissement.denominationCommerciale;
                                acc.Siege_social_partenaire__c = result.etablissement.siegeSocialPartenaire;
                                acc.SIRET__c = result.etablissement.immatriculationLegale;
                                acc.Code_NAF__c = result.etablissement.codeActiviteLocal.split('.').join("");;
                                acc.Effectif__c = result.etablissement.effectifSalarie;
                                acc.Enseigne__c = result.etablissement.denominationCommerciale;
                                acc.BillingStreet = result.etablissement.adresse[0].numeroVoie + ' ' + result.etablissement.adresse[0].typeDeVoie + ' ' + result.etablissement.adresse[0].libelleVoie;
                                acc.BillingPostalCode =  result.etablissement.adresse[0].codePostal;
                                acc.BillingCity = result.etablissement.adresse[0].ville;
                                acc.BillingCountry = result.etablissement.adresse[0].pays;
                                acc.ComplementAdresse__c = result.etablissement.adresse[0].complementAdresse;
                                acc.PresicionIdentificationAdresse__c = result.etablissement.adresse[0].precisionIdentificationAdresse;
                                acc.Segment_client__c = result.etablissement.Segment;
                                acc.Sous_segment_client__c = result.etablissement.SousSegment;
                               
                                if(acc.Segment_client__c == null || acc.Segment_client__c == '' || acc.Segment_client__c == ' '){
                                    component.set("v.segmentExists",false);
                                }
                                else{
                                    component.set("v.segmentExists",true);
                                }
                                if(acc.Sous_segment_client__c == null || acc.Sous_segment_client__c == '' || acc.Sous_segment_client__c == ' '){
                                    component.set("v.sousSegmentExists",false);
                                }
                                else{
                                    component.set("v.sousSegmentExists",true);
                                }
                                helper.fetchSegmentDependenciesCodeNaf(component,helper, acc.Code_NAF__c);
                            }
                            else{
                                component.set("v.IsSiretValid", false);
                                component.set("v.ErrorMsg", $A.get("$Label.c.LC13_SiretInvalide"))
                                helper.openmodal(component, helper);
                                $A.util.toggleClass(spinner, "slds-hide");
                            }
                            
                        }
                        else if (component.isValid() && state === "INCOMPLETE") {
                            $A.util.toggleClass(spinner, "slds-hide");
                        }
                            else if (component.isValid() && state === "ERROR") {
                                $A.util.toggleClass(spinner, "slds-hide");
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
                }
            });
            $A.enqueueAction(action);
        }
        else
        {
            // do not call the webservice because no siret was chosen
            // create an account normally without default values
            helper.CreateAccountWithoutDefaultValues(component);
            $A.util.toggleClass(spinner, "slds-hide");
            
            
            //helper.openmodal(component, helper);
            //component.set("v.IsSiretEmpty", true);
        }
        
    },
    closeAccountModel: function(component, event, helper) {
        component.set("v.newAccountModal", false);
    },
    closeErrorModel: function(component, event, helper) {
        component.set("v.errorModal", false);
    },
    ClearSiret : function(component, event, helper) {
        component.set("v.ChooseRT", false);
        component.set("v.IsSiretValid", true);
        component.set("v.SiretEntered", '');
        component.set("v.IsSiretEmpty", true);       
    }
})