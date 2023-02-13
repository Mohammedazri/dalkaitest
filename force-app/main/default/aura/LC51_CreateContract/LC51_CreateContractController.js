({
    doInit : function(component, event, helper) {
        
        let button = component.find('buttonid');
        button.set('v.disabled',true);
        
        var profileAction = component.get('c.getCurrentUserProfile');
        
        profileAction.setCallback(this, function(response){
            var profileName = response.getReturnValue();
            var profileusr = profileName.split('--')[0];
            var usrId = profileName.split('--')[1];
            if(!($A.get("$Label.c.Profil_Synchronisation").includes(','+profileusr+','))
               && !($A.get("$Label.c.User_Synchronisation").includes(','+usrId+',')))
            {
                component.set("v.error",'La synchronisation des contrats ne peut pas être effectuée par le profil '+profileusr);
                component.set('v.title', 'Synchronisation');
                component.set('v.showSpinner', false);
                button.set('v.disabled',false);
            }
            else{
                
                var actionMM = component.get("c.checkIfModeMaintenance");
                actionMM.setCallback(this, function(resp) {
                    var state=resp.getState();
                    if(state === "SUCCESS"){
                        var res = resp.getReturnValue();
                        if(res == true)
                        {
                            component.set("v.error", $A.get("$Label.c.LC51_ModeMaintenance"));
                            component.set('v.title', 'Synchronisation');
                            component.set('v.showSpinner', false);
                            button.set('v.disabled',false);
                        }
                        else
                        {
                            var action = component.get('c.getCurrentObject');
                            
                            action.setParams({ 
                                contractId : component.get("v.recordId")
                            });
                            
                            action.setCallback(this, function(response) {
                                component.set("v.CurrentContrat", response.getReturnValue());
                                if(component.get("v.CurrentContrat").Documents_Contractuels__r == undefined)
                                {
                                    component.set("v.error",'Il faut associer au moins un document contractuel à ce contrat.');
                                    component.set('v.title', 'Synchronisation');
                                    component.set('v.showSpinner', false);
                                    button.set('v.disabled',false);
                                }
                                    else if((component.get("v.CurrentContrat").DKCodeSurContrat__c != null && component.get("v.CurrentContrat").DKCodeSurContrat__c != '' && component.get("v.CurrentContrat").DKCodeSurContrat__c != undefined ) && component.get("v.CurrentContrat").Statut__c == 'PREP')
                                    {
                                        component.set("v.error",'Il faut attendre la validation du modéliseur contrat pour relancer une synchronisation.');
                                        component.set('v.title', 'Synchronisation');
                                        component.set('v.showSpinner', false);
                                        button.set('v.disabled',false);
                                    }
                                        else{
                                            
                                            var scanResult = component.get("c.checkDocRelatedScan");
                                            scanResult.setParams({ 
                                                contractId : component.get("v.recordId")
                                            });
                                            
                                            scanResult.setCallback(this, function(response) {
                                                var reqScans = response.getReturnValue();
                                                if(reqScans == 'KO')
                                                {
                                                    component.set("v.error",$A.get("$Label.c.LC51_ScanObligatoire"));
                                                    component.set('v.title', 'Synchronisation');
                                                    component.set('v.showSpinner', false);
                                                    button.set('v.disabled',false);
                                                }
                                                
                                                else
                                                {
                                                    
                                                    var resiliationResult = component.get("c.checkDocResiliation");
                                                    resiliationResult.setParams({ 
                                                        contractId : component.get("v.recordId")
                                                    });
                                                    
                                                    resiliationResult.setCallback(this, function(response) {
                                                        var reqScansResiliation = response.getReturnValue();
                                                        if(reqScansResiliation == 'KO')
                                                        {
                                                            component.set("v.error",$A.get("$Label.c.LC51_DocResiliation"));
                                                            component.set('v.title', 'Synchronisation');
                                                            component.set('v.showSpinner', false);
                                                            button.set('v.disabled',false);
                                                        }
                                                        
                                                        else {
                                                            
                                                            var combinationResult = component.get("c.checkDocsCombination");
                                                            combinationResult.setParams({
                                                                contractId : component.get("v.recordId")
                                                            });
                                                            
                                                            combinationResult.setCallback(this, function(response){
                                                                
                                                                var responseCombination = response.getReturnValue();
                                                                if(responseCombination != 'OK')
                                                                {
                                                                    component.set("v.error", responseCombination);
                                                                    component.set('v.title', 'Synchronisation');
                                                                    component.set('v.showSpinner', false);
                                                                    button.set('v.disabled',false);
                                                                }
                                                                else
                                                                {
                                                                    var contractResult = component.get("c.checkContract");
                                                                    contractResult.setParams({ 
                                                                        contractId : component.get("v.recordId")
                                                                    });
                                                                    
                                                                    contractResult.setCallback(this, function(response) {
                                                                        
                                                                        var stateContract = response.getState();
                                                                        var reqFieldsContract = response.getReturnValue();
                                                                        if (component.isValid() && stateContract === "SUCCESS" && reqFieldsContract == 'OK')
                                                                        {
                                                                            
                                                                            var synchronizeAction = component.get("c.creerContrat");
                                                                            synchronizeAction.setParams({ 
                                                                                contractId : component.get("v.recordId")
                                                                            });
                                                                            
                                                                            synchronizeAction.setCallback(this, function(response) {
                                                                                var state = response.getState();
                                                                                var reqFields = response.getReturnValue();
                                                                                component.set("v.reqFields",reqFields);
                                                                                if (component.isValid() && state === "SUCCESS" && reqFields == '') {
                                                                                    component.set('v.title', 'Synchronisation');
                                                                                    component.set('v.showSpinner', false);
                                                                                    helper.goToRecord(component, helper);
                                                                                    button.set('v.disabled',false);
                                                                                }
                                                                                else if(component.isValid() && state === "SUCCESS" && reqFields == 'Forme et type'){
                                                                                    component.set("v.error",'Il faut choisir la forme juridique et le type de reconduction pour pouvoir synchroniser le contrat.');
                                                                                    component.set('v.title', 'Synchronisation');
                                                                                    component.set('v.showSpinner', false);
                                                                                    button.set('v.disabled',false);
                                                                                }
                                                                                    else if(component.isValid() && state === "SUCCESS" && reqFields == 'Opportunity stage'){
                                                                                        component.set("v.error",'L\'opportunité d\'origine doit être à l\'étape Réalisation pour synchroniser un contrat.');
                                                                                        component.set('v.title', 'Synchronisation');
                                                                                        component.set('v.showSpinner', false);
                                                                                        button.set('v.disabled',false);                                        
                                                                                    }
                                                                                        else if(component.isValid() && state === "SUCCESS" && reqFields == 'Contrat Cadre'){
                                                                                            component.set("v.error",'Le contrat cadre du contrat doit avoir un DkCode et son statut doit être different de préparation.');
                                                                                            component.set('v.title', 'Synchronisation');
                                                                                            component.set('v.showSpinner', false);
                                                                                            button.set('v.disabled',false);                                        
                                                                                        }
                                                                                            else if(component.isValid() && state === "SUCCESS" && reqFields == 'error'){
                                                                                                component.set("v.error",'Une erreur technique est survenue, veuillez contacter le support informatique.');
                                                                                                component.set('v.title', 'Synchronisation');
                                                                                                component.set('v.showSpinner', false);
                                                                                                button.set('v.disabled',false);                                        
                                                                                            }
                                                                                
                                                                            });
                                                                            $A.enqueueAction(synchronizeAction);
                                                                            
                                                                        }
                                                                        
                                                                        else if(component.isValid() && stateContract === "SUCCESS" && reqFieldsContract.includes('Veuillez corriger')) 
                                                                        {
                                                                            var str_esc=escape(reqFieldsContract);
                                                                            var str_unesc = unescape(str_esc);
                                                                            var message = str_unesc.replaceAll('&quot;', '\"');
                                                                            component.set("v.error",message);
                                                                            component.set('v.title', 'Synchronisation');
                                                                            component.set('v.showSpinner', false);
                                                                            button.set('v.disabled',false); 
                                                                        }
                                                                        
                                                                        
                                                                    });
                                                                    $A.enqueueAction(contractResult);
                                                                }
                                                            });
                                                            $A.enqueueAction(combinationResult);
                                                            
                                                            
                                                        }
                                                    });
                                                    $A.enqueueAction(resiliationResult);	
                                                }
                                                
                                            });
                                            $A.enqueueAction(scanResult);
                                            
                                        }
                            });
                            $A.enqueueAction(action);
                        }
                    }
                });
                $A.enqueueAction(actionMM);
                
            }
            
        });
        $A.enqueueAction(profileAction);
    },
    
    annuler :  function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
    
})