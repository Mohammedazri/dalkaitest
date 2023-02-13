/**
* @author: David Attali - EI Technologies / Cognizant
* @date: 19/08/2022
* @description: Intégration des données d'installation
*/
global class WS14_Installation {
    
    global class Installation {
        webservice Header header;
        webservice ProprietesInstallation proprietesInstallation {get; set;}
        webservice List<LienSite> listLienSite;
        webservice List<SystemeInstallation> listSystemeInstallation;
        webservice Operation operation {get; set;}
        webservice Service service {get; set;}
        webservice List<LienImputation> listLienImputation;
        webservice List<TranscoCodeDI> listTranscoCodeDI;
        webservice Metadonnees metadonnees {get; set;}
    }
    
    global class ProprietesInstallation {
        webservice String dkCodeInstallation {get; set;}
        webservice String codeInstallationDalkia {get; set;}
        webservice String codeInstallationDalkiaComplement {get; set;}
        webservice String libelleInstallation {get; set;}
        webservice String determinationGrandeurTechnique {get; set;}
        webservice Boolean installationSupprime {get; set;}
        webservice String statutImputation {get; set;}
        webservice String ficheTechnique {get; set;}
    }
    
    global class LienSite {
        webservice String dkCodeSite {get; set;}
        webservice Boolean statutLienSite {get; set;}
        webservice DateTime dateCreationLienSite {get; set;}
    }
    
    global class SystemeInstallation {
        webservice String codeSystemeRDSPP {get; set;}
        webservice String libelleSysteme {get; set;}
        webservice String codeSystemeRDSPPParent {get; set;}
    }
    
    global class Operation {  
        webservice String criticiteInstallation {get; set;}
        webservice String etatOperationnel {get; set;}
        webservice String dureeAnnuelleFonctionnement {get; set;}
        webservice String modeGestionEnergetique {get; set;}
        webservice String modeGestionTravauxInterne {get; set;}
    }
    
    global class Service {  
        webservice String identifiantExterne {get; set;}
        webservice String libelleExterne {get; set;}
        webservice String dkCodeSiteAlias {get; set;}
    }
    
    global class LienImputation {
        webservice String dkCodeTache {get; set;}
        webservice String codeCategoriePrestation {get; set;}
        webservice Boolean statutLienTacheFinance {get; set;}
        webservice DateTime dateModificationImputation {get; set;}
    }
    
    global class TranscoCodeDI {
        webservice String codeDI {get; set;}
    }

    global class Metadonnees {
        webservice DateTime dateCreation {get; set;}
        webservice String utilisateurCreation {get; set;}
        webservice DateTime dateModification {get; set;}
        webservice String utilisateurModification {get; set;}
        webservice DateTime dateValidation {get; set;}
                                                                                                                                                                                                                                                                                                                        webservice String utilisateurValidation {get; set;} 
    }
    
    
    webservice static Response upsertInstallation(Installation installation) {
    
     // Initialisation et insertion de l'enregistrement WebserviceLog__c
        WebserviceLog__c webServiceLog = new WebserviceLog__c(
            Flux__c = Label.WSTypeFluxEntrant,
            Type__c = 'upsertInstallation',
            Request__c = String.valueOf(installation)
        );
        
        insert webServiceLog;
        
        // Initialisation de la réponse du web service
        Response response = new Response(Label.WS_Response_OK, '', false);
        
        // Initialisation de l'enregistrement Installation__c
        Installation__c installationToUpsert = new Installation__c();
        
        String errorFound = '';
        
        // Racine
        if(installation != null){
            
            // Attributs header et transactionId
            if (installation.header != null && String.isNotBlank(installation.header.transactionId)) {
                webServiceLog.TransactionId__c = installation.header.transactionId;
            }
            
            // Attribut proprietesInstallation
            if(installation.proprietesInstallation != null) {
                
                // Attribut dkCodeInstallation
                if(String.isNotBlank(installation.proprietesInstallation.dkCodeInstallation)){
                    installationToUpsert.DKCodeInstallation__c = installation.proprietesinstallation.dkCodeInstallation;
                    webServiceLog.DkCode__c = installation.proprietesInstallation.dkCodeInstallation;
                } else {
                    errorFound += 'Le champ installation.proprietesInstallation.dkCodeInstallation est obligatoire' + '\n';
                }
                
                // Attribut libelleInstallation
                if(String.isNotBlank(installation.proprietesInstallation.libelleInstallation)){
                 if (installation.proprietesInstallation.libelleInstallation.length() > 80) {
                    installationToUpsert.Name = (installation.proprietesinstallation.libelleInstallation).substring(0, 79);
                    installationToUpsert.LongName__c = installation.proprietesinstallation.libelleInstallation;
                } else {
                    installationToUpsert.Name = installation.proprietesinstallation.libelleInstallation;
                    installationToUpsert.LongName__c = installation.proprietesinstallation.libelleInstallation;
                }    
                } else {
                    errorFound += 'Le champ installation.proprietesInstallation.libelleInstallation est obligatoire' + '\n';
                } 
                
                // Attribut installationSupprime
                if (installation.proprietesInstallation.installationSupprime != null && installation.proprietesInstallation.installationSupprime == true) {
                    installationToUpsert.InstallationSupprime__c = installation.proprietesInstallation.installationSupprime;
                } else {
                    //errorFound += 'Le champ installation.proprietesInstallation.installationSupprime est obligatoire' + '\n';
                    installationToUpsert.InstallationSupprime__c = false;
                }
            } else {
                errorFound += 'Le champ installation.proprietesinstallation est obligatoire' + '\n';
            }  
                
                
                // Attribut listLienSite
            	if(installation.listLienSite != null && installation.listLienSite.size() > 0){
                    
                Set<String> SetemplacementSiteId = new Set <String>();
                for (LienSite lienSite : installation.listLienSite)
                {
                    if (lienSite.dkCodeSite != null)
                        SetemplacementSiteId.add(lienSite.dkCodeSite);
                }   
                    
                List<Emplacement__c> emplacementSiteId = [SELECT Id, DKCode_Emplacement__c FROM Emplacement__c
                                                        WHERE DKCode_Emplacement__c in : SetemplacementSiteId];
                
                Boolean activeLinkFound = false;
                
                for(LienSite lienSite : installation.listLienSite){
                    
                    // Attribut statutLienSite
                    if(lienSite.statutLienSite != null) { 
 
                        // Gestion : Lien actif
                        if(lienSite.statutLienSite == true){
                            
                            activeLinkFound = true;
                            
                            // Attribut dkCodeSite
                            if(String.IsNotBlank(lienSite.dkCodeSite)){
                             installationToUpsert.DKCodeSite__c = lienSite.dkCodeSite;
                              if(emplacementSiteId.size() > 0){
                                for (Emplacement__c empId : emplacementSiteId) {
                                    if (empId.DKCode_Emplacement__c == lienSite.dkCodeSite) {
                                      installationToUpsert.Site__c = empId.Id;
                                      break;
                                    }
                                }
                            } else {
                        		installationToUpsert.Site__c = null;
                            }
                           }    
                         else {
                                errorFound += 'Le champ installation.listLienSite[].dkCodeSite est obligatoire' + '\n';
                         }
                            
                            // Attribut dateCreationLienSite
                            if(lienSite.dateCreationLienSite != null){
                                installationToUpsert.DateCreationLienSite__c = lienSite.dateCreationLienSite;
                            } else {
                                errorFound += 'Le champ installation.listLienSite[].dateCreationLienSite est obligatoire' + '\n';
                            }
                        }
                        
                        if(activeLinkFound == false){
                            installationToUpsert.DKCodeSite__c = null;
                            installationToUpsert.Site__c = null;
                            installationToUpsert.DateCreationLienSite__c = null;
                        }
                        
                    } else {
                        errorFound += 'Le champ installation.listLienSite[].statutLienSite est obligatoire' + '\n';
                    }
                }
                    
            } else {
                installationToUpsert.DKCodeSite__c = null;
                installationToUpsert.DateCreationLienSite__c = null;
            }
            
             // Attribut listSystemeInstallation
            	if(installation.listSystemeInstallation != null && installation.listSystemeInstallation.size() > 0){
                    // Attribut codeSystemeRDSPP & Attribut libelleSysteme
                            if(String.IsNotBlank(installation.listSystemeInstallation.get(0).codeSystemeRDSPP)){
                                installationToUpsert.CodeSystemeRDSPP__c = installation.listSystemeInstallation.get(0).codeSystemeRDSPP;
								installationToUpsert.LibelleSysteme__c = installation.listSystemeInstallation.get(0).codeSystemeRDSPP;                              
                            } else {
                                errorFound += 'Le champ installation.listSystemeInstallation[].codeSystemeRDSPP est obligatoire' + '\n';
                            }
                    /*
                    // Attribut libelleSysteme
                            if(String.IsNotBlank(installation.listSystemeInstallation.get(0).libelleSysteme)){
                                installationToUpsert.LibelleSysteme__c = installation.listSystemeInstallation.get(0).libelleSysteme;
                            } else {
                                errorFound += 'Le champ installation.listSystemeInstallation[].libelleSysteme est obligatoire' + '\n';
                            }
                    */
			 }
            else {
                installationToUpsert.CodeSystemeRDSPP__c = null;
                installationToUpsert.LibelleSysteme__c = null;
            }
            
            // Attribut operation
            if(installation.operation != null) {
                
            	// Attribut criticiteInstallation
                if (installation.operation.criticiteInstallation != null) {
                    installationToUpsert.CriticiteInstallation__c = installation.operation.criticiteInstallation;
                } else {
                    errorFound += 'Le champ installation.operation.criticiteInstallation est obligatoire' + '\n';
                }
                
                // Attribut etatOperationnel
                if (installation.operation.etatOperationnel != null) {
                    installationToUpsert.EtatOperationnel__c = installation.operation.etatOperationnel;
                } else {
                    errorFound += 'Le champ installation.operation.etatOperationnel est obligatoire' + '\n';
                }
                
                // Attribut dureeAnnuelleFonctionnement
                if (installation.operation.dureeAnnuelleFonctionnement != null) {
                    installationToUpsert.DureeAnnuelleFonctionnement__c = installation.operation.dureeAnnuelleFonctionnement;
                } else {
                    errorFound += 'Le champ installation.operation.dureeAnnuelleFonctionnement est obligatoire' + '\n';
                }
                
                // Attribut modeGestionEnergetique
                if (installation.operation.modeGestionEnergetique != null) {
                    installationToUpsert.ModeGestionEnergetique__c = installation.operation.modeGestionEnergetique;
                } else {
                    errorFound += 'Le champ installation.operation.modeGestionEnergetique est obligatoire' + '\n';
                }  
                
                // Attribut modeGestionTravauxInterne
                if (installation.operation.modeGestionTravauxInterne != null) {
                    installationToUpsert.ModeGestionTravauxInterne__c = installation.operation.modeGestionTravauxInterne;
                } else {
                    errorFound += 'Le champ installation.operation.modeGestionTravauxInterne est obligatoire' + '\n';
                }  
            } else {
                errorFound += 'Le champ installation.operation est obligatoire' + '\n';
            }  
                
                 // Attribut listTranscoCodesDI
            	if(installation.listTranscoCodeDI != null && installation.listTranscoCodeDI.size() > 0){
                
                installationToUpsert.CodesDI__c = '';
                
                for(Integer i = 0; i < installation.listTranscoCodeDI.size(); i++){
                    
                    // Attribut codeDI
                    if(String.isNotBlank(installation.listTranscoCodeDI.get(i).codeDI)) {
                        
                        installationToUpsert.CodesDI__c += installation.listTranscoCodeDI.get(i).codeDI;
                        
                        if((i + 1) < installation.listTranscoCodeDI.size()){
                            installationToUpsert.CodesDI__c += ', ';
                        }
                        
                    } /*else {
                        errorFound += 'Le champ installation.listTranscoCodeDI[].codeDI est obligatoire' + '\n';
                    }
					*/
                }
            } else {
                installationToUpsert.CodesDI__c = null;
            }
                
                // Attribut metadonnees
            if(installation.metadonnees != null){
                
                // Attribut dateCreation
                if(installation.metadonnees.dateCreation != null) {
                    installationToUpsert.DateCreation__c = installation.metadonnees.dateCreation;
                } else {
                    errorFound += 'Le champ installation.metadonnees[].dateCreation est obligatoire' + '\n';
                }
                
                // Attribut utilisateurCreation
                if(String.isNotBlank(installation.metadonnees.utilisateurCreation)) {
                    
                    List<User> utilisateurCreationId = [SELECT Id FROM User
                                                        WHERE ReferentielId__c = :installation.metadonnees.utilisateurCreation
                                                        LIMIT 1];
                    
                    if(utilisateurCreationId.size() > 0){
                        installationToUpsert.UtilisateurCreation__c = utilisateurCreationId.get(0).Id;
                        installationToUpsert.UtilisateurCreationText__c = installation.metadonnees.utilisateurCreation;
                    } else {
                        installationToUpsert.UtilisateurCreation__c = null;
                        installationToUpsert.UtilisateurCreationText__c = null;
                    }
                    

                } else {
                    errorFound += 'Le champ installation.metadonnees[].utilisateurCreation est obligatoire' + '\n';
                }
                
                // Attribut dateModification
                if(installation.metadonnees.dateModification != null) {
                    installationToUpsert.DateModification__c = installation.metadonnees.dateModification;
                } else {
                    installationToUpsert.DateModification__c = null;
                }
                
                // Attribut utilisateurModification
                if(String.isNotBlank(installation.metadonnees.utilisateurModification)) {
                    
                    List<User> utilisateurModificationId = [SELECT Id FROM User
                                                            WHERE ReferentielId__c = :installation.metadonnees.utilisateurModification
                                                            LIMIT 1];
                    
                    if(utilisateurModificationId.size() > 0){
                        installationToUpsert.UtilisateurModification__c = utilisateurModificationId.get(0).Id;
                        installationToUpsert.UtilisateurModificationText__c = installation.metadonnees.utilisateurModification;
                    } else {
                        installationToUpsert.UtilisateurModification__c = null;
                        installationToUpsert.UtilisateurModificationText__c = null;
                    }
                } else {
                    installationToUpsert.UtilisateurModification__c = null;
                }
            }
            else {
                errorFound += 'Le champ installation.metadonnees[] est obligatoire' + '\n';
            }
        }
        // Gestion : Erreur rencontrée avant l'upsert
        if(String.isNotBlank(errorFound)) {
            
            // Gestion de la réponse
            response.responseCode = Label.WS_Response_KO;
            response.error = true;
            response.errorText = errorFound;
            
            // Gestion : Enregistrement WebserviceLog__c
            webServiceLog.Statut__c = Label.WS_Response_KO;
            
            if(errorFound.length() > 254) {
                webServiceLog.ErrorText__c =  errorFound.substring(0, 254);
            } else {
                webServiceLog.ErrorText__c = errorFound;
            }
            
            webServiceLog.Response__c = String.valueOf(response);

        // Gestion : Aucune erreur rencontrée avant upsert
        } else {

            webServiceLog.Statut__c = Label.WS_Response_OK;            
            webServiceLog.Response__c = String.valueOf(response);

            try {
                upsert installationToUpsert DKCodeInstallation__c;
            } catch(Exception ex){
                
                // Gestion : enregistrement WebserviceLog__c
                response.responseCode = Label.WS_Response_KO;
                response.error = true;
                
                errorFound += 'Erreur durant l\'upsert : ' + ex.getMessage() + '\n'; 
                response.errorText = errorFound;
                
                // Gestion : Enregistrement WebserviceLog__c
                webServiceLog.Statut__c = Label.WS_Response_KO;

                if(errorFound.length() > 254) {
                    webServiceLog.ErrorText__c =  errorFound.substring(0, 254);
                } else {
                    webServiceLog.ErrorText__c = errorFound;
                }
                
                webServiceLog.Response__c = String.valueOf(response);
            }
        }
        
        update webServiceLog; 
        

         
       
     return response;
   //return new Response();
    }
   }