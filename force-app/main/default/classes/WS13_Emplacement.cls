/**
* @author: Alexandre Grosset-Grange - EI Technologies / Cognizant
* @date: 19/05/2022
* @description: Classe qui gère le web service entrant Emplacement
*/
global class WS13_Emplacement {
    
    global class Emplacement {
        webservice Header header;
        webservice Proprietes_Emplacement proprietesEmplacement{get; set;}
        webservice List<Lien_See> listLienSee;
        webservice Arborescence_Emplacement arborescenceEmplacement{get; set;}
        webservice Usage_Emplacement usageEmplacement{get; set;}
        webservice ERP_Site erpSite{get; set;}
        webservice Partenaire_Site partenaireSite{get; set;}
        webservice List<Emplacement_Acces> listEmplacementAcces;
        webservice Site_Meteo siteMeteo{get; set;}
        webservice Genie_Civil genieCivil{get; set;}
        webservice Operation operation{get; set;}
        webservice Service service{get; set;}
        webservice List<Imputations> listImputations;
        webservice List<Transco_CodesDI> listTranscoCodesDI;
        webservice SecuriteSite securiteSite{get; set;}
        webservice Metadonnees metadonnees{get; set;}
    }
    
    global class Proprietes_Emplacement {
        webservice String dkCodeEmplacement{get; set;}
        webservice String libelle{get; set;}
        webservice String commentaire{get; set;} 
        webservice String statutEmplacement{get; set;}
        webservice String natureEmplacement{get; set;}
        webservice Boolean emplacementSupprime{get; set;}
        webservice String statutImputation{get; set;}
        webservice String idBim{get; set;} 
        webservice String telephone{get; set;}
        webservice String statutService{get; set;} 
    }
    
    global class Lien_See {
        webservice String dkCodeSee{get; set;}
        webservice Boolean statutLienSee{get; set;}
        webservice DateTime dateCreationLienSee{get; set;}
    }
    
    global class Arborescence_Emplacement {
        webservice String dkCodeEmplacementParent{get; set;}
        webservice String dkCodeEmplacementSite{get; set;}
    }
    
    global class Usage_Emplacement {
        webservice String usage{get; set;}
        webservice Integer dimensionUsage{get; set;} 
    }
    
    global class ERP_Site {
        webservice Boolean siteERP{get; set;} 
        webservice String natureERP{get; set;} 
        webservice String categorieERP{get; set;} 
    }
    
    global class Partenaire_Site {
        webservice String dkCodePartenaire{get; set;}
    }
    
    global class Emplacement_Acces {  
        webservice String dkCodeAdresse{get; set;}
        webservice String numeroVoie{get; set;} 
        webservice String typeVoie{get; set;}
        webservice String libelleVoie{get; set;}
        webservice String complementAdresse{get; set;} 
        webservice String codePostal{get; set;}
        webservice String ville{get; set;}
        webservice String codeCanton{get; set;} 
        webservice String codeINSEE{get; set;}
        webservice String pays{get; set;}
        webservice GeoCodage_Adresse geoCodageAdresse{get; set;} 
        webservice Metadonnees metadonnees{get; set;}
        webservice List<Nature_Acces_Dalkia> listNatureAccesDalkia{get; set;}
    }
    
    global class GeoCodage_Adresse {
        webservice String longitude{get; set;}
        webservice String lattitude{get; set;}
        webservice String qualiteGeocodage{get; set;}
    }
    
    global class Metadonnees {
        webservice DateTime dateCreation{get; set;}
        webservice String utilisateurCreation{get; set;}
        webservice DateTime dateModification{get; set;} 
        webservice String utilisateurModification{get; set;} 
    }
    
    global class Nature_Acces_Dalkia {
        webservice String natureAccesDalkia{get; set;}
    } 
    
    global class Site_Meteo {
        webservice String zoneClimatique{get; set;}
        webservice String stationMeteo{get; set;}
        webservice String stationMeteoLocale{get; set;}
    }
    
    global class Genie_Civil {  
        webservice Integer surfaceCadastrale{get; set;} 
        webservice Integer surfaceShob{get; set;} 
        webservice Integer surfaceShon{get; set;} 
        webservice Integer surfaceShonRT{get; set;} 
        webservice Integer hauteurConstruction{get; set;} 
        webservice Boolean igh{get; set;} 
        webservice String classeIGH{get; set;} 
        webservice Integer anneeFinConstruction{get; set;} 
        webservice Integer anneeRenovationBati{get; set;} 
        webservice String etiquetteEnergie{get; set;} 
        webservice String etiquetteClimat{get; set;} 
    }
    
    global class Operation {  
        webservice String environnementSpecifique{get; set;}
        webservice Boolean systemeSTIRequis{get; set;}
        webservice Boolean risqueLegionelle{get; set;}
        webservice Boolean risqueRayonnementsIonisants{get; set;}
        webservice Boolean risquePoussiereZoneAtex{get; set;}
        webservice Boolean risqueAmiante{get; set;}
        webservice DateTime datePriseEnChargeExploitation{get; set;}
        webservice DateTime dateRestitutionExploitation{get; set;}
        webservice String presenceDalkia{get; set;}
        webservice String releveEnergetique{get; set;}
        webservice String dkCodeEntiteExploitation{get; set;} 
    }
    
    global class Service {   
        webservice String identifiantExterne{get; set;}
        webservice String libelleExterne{get; set;}
        webservice String emplacementAlias{get; set;}
    }
    
    global class Imputations { 
        webservice String dkCodeTache{get; set;}
        webservice String categoriePrestation{get; set;}
        webservice Boolean statutLienTacheFinance{get; set;}
        webservice DateTime dateCreationImputation{get; set;}
        webservice String transcoCodeDI{get; set;}
    }
    
    global class Transco_CodesDI {
        webservice String codeDI{get; set;}
    }
    
    global class SecuriteSite {
        webservice String environnementUrbain{get; set;}
        webservice String niveauOccupation{get; set;}
        webservice String numInscriptionRegistreSP{get; set;}
        webservice String numRegistreEuropeenCO2{get; set;}
        webservice String idUniqueEutlSiteClasse{get; set;}
        webservice String codeGidicSiteClasse{get; set;}
        webservice String statutSeveso{get; set;}
    }
    
    // Transcodage de la nature de l'accès secondaire
    static final Map<String, String> TRANSCODAGE_NATURE_ACCES = new Map<String, String> {
        'INT' => 'INTERVENTIONS',
        'LIV' => 'LIVRAISON COMBUSTIBLE',
        'AUT' => 'AUTRES LIVRAISONS'};
            
    webservice static Response upsertEmplacement(Emplacement emplacement) {
        
        // Initialisation et insertion de l'enregistrement WebserviceLog__c
        WebserviceLog__c webServiceLog = new WebserviceLog__c(
            Flux__c = Label.WSTypeFluxEntrant,
            Type__c = 'upsertEmplacement',
            Request__c = String.valueOf(emplacement)
        );
        
        insert webServiceLog;
        
        // Initialisation de la réponse du web service
        Response response = new Response(Label.WS_Response_OK, '', false);
        
        // Initialisation de l'enregistrement Emplacement__c
        Emplacement__c emplacementToUpsert = new Emplacement__c();

        String errorFound = '';
        Boolean natureEmplacementSite = false;
        
        // Racine
        if(emplacement != null){
            
            // Attributs header et transactionId
            if (emplacement.header != null && String.isNotBlank(emplacement.header.transactionId)) {
                webServiceLog.TransactionId__c = emplacement.header.transactionId;
            }
            
            // Attribut proprietesEmplacement
            if(emplacement.proprietesEmplacement != null) {
                
                // Attribut dkCodeEmplacement
                if(String.isNotBlank(emplacement.proprietesEmplacement.dkCodeEmplacement)){
                    emplacementToUpsert.DKCode_Emplacement__c = emplacement.proprietesEmplacement.dkCodeEmplacement;
                    webServiceLog.DkCode__c = emplacement.proprietesEmplacement.dkCodeEmplacement;
                } else {
                    errorFound += 'Le champ emplacement.proprietesEmplacement.dkCodeEmplacement est obligatoire' + '\n';
                }
                
                // Attribut libelle
                if (String.isNotBlank(emplacement.proprietesEmplacement.libelle)) {
                    emplacementToUpsert.Name = emplacement.proprietesEmplacement.libelle;
                } else {
                    errorFound += 'Le champ emplacement.proprietesEmplacement.libelle est obligatoire' + '\n';
                }
                
                // Attribut commentaire
                if (String.isNotBlank(emplacement.proprietesEmplacement.commentaire)) {
                    emplacementToUpsert.Commentaire__c = emplacement.proprietesEmplacement.commentaire;
                } else {
                    emplacementToUpsert.Commentaire__c = null;
                }
                
                // Attribut natureEmplacement
                if (String.isNotBlank(emplacement.proprietesEmplacement.natureEmplacement)) {
                    emplacementToUpsert.Nature_Emplacement__c = emplacement.proprietesEmplacement.natureEmplacement;
                    
                    // Vérification si l'emplacement est de nature Site
                    if(emplacement.proprietesEmplacement.natureEmplacement.equals('SIT')){
                        natureEmplacementSite = true;
                    }
                    
                } else {
                    errorFound += 'Le champ emplacement.proprietesEmplacement.natureEmplacement est obligatoire' + '\n';
                }
                
                // Attribut emplacementSupprime
                if (emplacement.proprietesEmplacement.emplacementSupprime != null) {
                    emplacementToUpsert.Emplacement_Supprime__c = emplacement.proprietesEmplacement.emplacementSupprime;
                } else {
                    errorFound += 'Le champ emplacement.proprietesEmplacement.emplacementSupprime est obligatoire' + '\n';
                }
                
                // Attribut idBim
                if (String.isNotBlank(emplacement.proprietesEmplacement.idBim)) {
                    emplacementToUpsert.IdBim__c = emplacement.proprietesEmplacement.idBim;
                } else {
                    emplacementToUpsert.IdBim__c = null;
                }
                
                // Attribut telephone
                if (String.isNotBlank(emplacement.proprietesEmplacement.telephone)) {
                    emplacementToUpsert.Telephone__c = emplacement.proprietesEmplacement.telephone;
                } else {
                    emplacementToUpsert.Telephone__c = null;
                }
                
                // Attribut statutService
                if (String.isNotBlank(emplacement.proprietesEmplacement.statutService)) {
                    emplacementToUpsert.StatutService__c = emplacement.proprietesEmplacement.statutService;
                } else {
                    emplacementToUpsert.StatutService__c = null;
                }
            } else {
                errorFound += 'Le champ emplacement.proprietesEmplacement est obligatoire' + '\n';
            }
            
            // Attribut listLienSee
            if(emplacement.listLienSee != null && emplacement.listLienSee.size() > 0){
                
                Boolean activeLinkFound = false;
                
                for(Lien_See lienSee : emplacement.listLienSee){
                    
                    // Attribut statutLienSee
                    if(lienSee.statutLienSee != null) {
 
                        // Gestion : Lien actif
                        if(lienSee.statutLienSee == true){
                            
                            activeLinkFound = true;
                            
                            // Attribut dkCodeSee
                            if(String.IsNotBlank(lienSee.dkCodeSee)){
                                emplacementToUpsert.DKCode_SEE__c = lienSee.dkCodeSee;
                            } else {
                                errorFound += 'Le champ emplacement.listLienSee[].dkCodeSee est obligatoire' + '\n';
                            }
                            
                            // Attribut dateCreationLienSee
                            if(lienSee.dateCreationLienSee != null){
                                emplacementToUpsert.DateCreationLienSee__c = lienSee.dateCreationLienSee;
                            } else {
                                errorFound += 'Le champ emplacement.listLienSee[].dateCreationLienSee est obligatoire' + '\n';
                            }
                        }
                        
                        if(activeLinkFound == false){
                            emplacementToUpsert.DKCode_SEE__c = null;
                            emplacementToUpsert.DateCreationLienSee__c = null;
                        }
                        
                    } else {
                        errorFound += 'Le champ emplacement.listLienSee[].statutLienSee est obligatoire' + '\n';
                    }
                }
            } else {
                emplacementToUpsert.DKCode_SEE__c = null;
                emplacementToUpsert.DateCreationLienSee__c = null;
            }
            
            // Attribut arborescenceEmplacement, Gestion : Uniquement dans le cas d'une nature emplacement différente de Site
            if(emplacement.arborescenceEmplacement != null && natureEmplacementSite == false){
                
                // Attribut dkCodeEmplacementParent
                if (String.isNotBlank(emplacement.arborescenceEmplacement.dkCodeEmplacementParent)) {
                    emplacementToUpsert.DKCode_Emplacement_Parent__c = emplacement.arborescenceEmplacement.dkCodeEmplacementParent;
                    
                    List<Emplacement__c> parentId = [SELECT Id FROM Emplacement__c
                                                     WHERE DKCode_Emplacement__c = :emplacement.arborescenceEmplacement.dkCodeEmplacementParent
                                                     LIMIT 1];
                    
                    if(parentId.size() > 0){
                        emplacementToUpsert.EmplacementParent__c = parentId.get(0).Id;
                    } else {
                        emplacementToUpsert.EmplacementParent__c = null;
                    }
                    
                } else {
                    errorFound += 'Le champ emplacement.arborescenceEmplacement[].dkCodeEmplacementParent est obligatoire' + '\n';
                }
                
                // Attribut dkCodeEmplacementSite
                if (String.isNotBlank(emplacement.arborescenceEmplacement.dkCodeEmplacementSite)) {
                    emplacementToUpsert.DKCode_Emplacement_Site__c = emplacement.arborescenceEmplacement.dkCodeEmplacementSite;
                    
                    List<Emplacement__c> siteId = [SELECT Id FROM Emplacement__c
                                                   WHERE DKCode_Emplacement__c = :emplacement.arborescenceEmplacement.dkCodeEmplacementSite
                                                   LIMIT 1];
                    
                    if(siteId.size() > 0){
                        emplacementToUpsert.EmplacementSite__c = siteId.get(0).Id;
                    } else {
                        emplacementToUpsert.EmplacementSite__c = null;
                    }
                    
                } else {
                    errorFound += 'Le champ emplacement.arborescenceEmplacement[].dkCodeEmplacementSite est obligatoire' + '\n';
                }
                
            } else {
                emplacementToUpsert.DKCode_Emplacement_Parent__c = null;
                emplacementToUpsert.EmplacementParent__c = null;
                emplacementToUpsert.DKCode_Emplacement_Site__c = null;
                emplacementToUpsert.EmplacementSite__c = null;
            }
            
            // Attribut usageEmplacement
            if(emplacement.usageEmplacement != null){
                
                // Attribut usage
                if(String.isNotBlank(emplacement.usageEmplacement.usage)){
                    emplacementToUpsert.Usage__c = emplacement.usageEmplacement.usage;
                } else {
                    errorFound += 'Le champ emplacement.usageEmplacement.usage est obligatoire' + '\n';
                }
                
                // Attribut dimensionUsage
                if(emplacement.usageEmplacement.dimensionUsage != null){
                    emplacementToUpsert.DimensionUsage__c = emplacement.usageEmplacement.dimensionUsage;
                } else {
                    emplacementToUpsert.DimensionUsage__c = null;
                }
            } else {
                emplacementToUpsert.Usage__c = null;
                emplacementToUpsert.DimensionUsage__c = null;
            }
            
            // Attribut listEmplacementAcces
            if(emplacement.listEmplacementAcces != null && emplacement.listEmplacementAcces.size() > 0) {
                
                Boolean mainAddressFound = false;
                Boolean secondaryAddressFound = false;
                
                for(Emplacement_Acces emplacementAcces : emplacement.listEmplacementAcces) {
                    
                    Boolean stopIterateSecondaryAddress = false;
                    
                    // Attribut listNatureAccesDalkia
                    if(emplacementAcces.listNatureAccesDalkia != null && emplacementAcces.listNatureAccesDalkia.size() > 0){

                        for(Nature_Acces_Dalkia natureAccesDalkia : emplacementAcces.listNatureAccesDalkia){
                            
                            // Attribut natureAccesDalkia
                            if(String.isNotBlank(natureAccesDalkia.natureAccesDalkia)){
                                
                                // Gestion : Adresse principale
                                if(natureAccesDalkia.natureAccesDalkia.equals('GEN')){
                                    
                                    mainAddressFound = true;
                                    
                                    // Attribut dkCodeAdresse
                                    if(String.isNotBlank(emplacementAcces.dkCodeAdresse)){
                                        emplacementToUpsert.DKCodeAdresse__c = emplacementAcces.dkCodeAdresse;
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].dkCodeAdresse est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut numeroVoie
                                    if(String.isNotBlank(emplacementAcces.numeroVoie)){
                                        emplacementToUpsert.Numero_Voie__c = emplacementAcces.numeroVoie;
                                    } else {
                                        emplacementToUpsert.Numero_Voie__c = null;
                                    }
                                    
                                    // Attribut typeVoie
                                    if(String.isNotBlank(emplacementAcces.typeVoie)){
                                        emplacementToUpsert.Type_Voie__c = emplacementAcces.typeVoie;
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].typeVoie est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut libelleVoie
                                    if(String.isNotBlank(emplacementAcces.libelleVoie)){
                                        emplacementToUpsert.Libelle_Voie__c = emplacementAcces.libelleVoie;
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].libelleVoie est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut complementAdresse
                                    if(String.isNotBlank(emplacementAcces.complementAdresse)){
                                        emplacementToUpsert.Complement_Adresse__c = emplacementAcces.complementAdresse;
                                    } else {
                                        emplacementToUpsert.Complement_Adresse__c = null;
                                    }
                                    
                                    // Attribut codePostal
                                    if(String.isNotBlank(emplacementAcces.codePostal)){
                                        emplacementToUpsert.Code_Postal__c = emplacementAcces.codePostal;
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].codePostal est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut typeVoie
                                    if(String.isNotBlank(emplacementAcces.ville)){
                                        emplacementToUpsert.Ville__c = emplacementAcces.ville;
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].ville est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut pays
                                    if(String.isNotBlank(emplacementAcces.pays)){
                                        emplacementToUpsert.Pays__c = emplacementAcces.pays;
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].pays est obligatoire' + '\n';
                                    }
                                }
                                
                                // Gestion : Adresse(s) secondaire(s)  
                                if(!natureAccesDalkia.natureAccesDalkia.equals('GEN') && stopIterateSecondaryAddress == false){
                                    
                                    secondaryAddressFound = true;
                                    stopIterateSecondaryAddress = true;
                                    
                                    if(emplacementToUpsert.AdresseSecondaire__c == null){
                                        emplacementToUpsert.AdresseSecondaire__c = '';
                                    }
                                    
                                    for(Nature_Acces_Dalkia natureAcces : emplacementAcces.listNatureAccesDalkia){
                                        emplacementToUpsert.AdresseSecondaire__c += TRANSCODAGE_NATURE_ACCES.get(natureAcces.natureAccesDalkia) + '\n';
                                    }
                                    
                                    
                                    // Attribut numeroVoie
                                    if(String.isNotBlank(emplacementAcces.numeroVoie)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.numeroVoie + ' ';
                                    }
                                    
                                    // Attribut typeVoie
                                    if(String.isNotBlank(emplacementAcces.typeVoie)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.typeVoie + ' ';
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].typeVoie est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut libelleVoie
                                    if(String.isNotBlank(emplacementAcces.libelleVoie)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.libelleVoie + '\n';
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].libelleVoie est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut complementAdresse
                                    if(String.isNotBlank(emplacementAcces.complementAdresse)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.complementAdresse + '\n';
                                    }
                                    
                                    // Attribut codePostal
                                    if(String.isNotBlank(emplacementAcces.codePostal)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.codePostal + ' ';
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].codePostal est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut typeVoie
                                    if(String.isNotBlank(emplacementAcces.ville)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.ville + '\n';
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].ville est obligatoire' + '\n';
                                    }
                                    
                                    // Attribut pays
                                    if(String.isNotBlank(emplacementAcces.pays)){
                                        emplacementToUpsert.AdresseSecondaire__c += emplacementAcces.pays + '\n';
                                    } else {
                                        errorFound += 'Le champ emplacement.emplacementAcces[].pays est obligatoire' + '\n';
                                    }
                                    
                                    emplacementToUpsert.AdresseSecondaire__c += '\n';
                                }
                                
                                if(mainAddressFound == false){
                                    emplacementToUpsert.DKCodeAdresse__c = null;
                                    emplacementToUpsert.Numero_Voie__c = null;
                                    emplacementToUpsert.Type_Voie__c = null;
                                    emplacementToUpsert.Libelle_Voie__c = null;
                                    emplacementToUpsert.Complement_Adresse__c = null;
                                    emplacementToUpsert.Code_Postal__c = null;
                                    emplacementToUpsert.Ville__c = null;
                                    emplacementToUpsert.Pays__c = null;
                                }
                                
                                if(secondaryAddressFound == false){
                                    emplacementToUpsert.AdresseSecondaire__c = null;
                                }
                                
                            } else {
                                errorFound += 'Le champ emplacement.emplacementAcces[].listNatureAccesDalkia[].natureAccesDalkia est obligatoire' + '\n';
                            }
                        }
                        
                    } else {
                        errorFound += 'Le champ emplacement.emplacementAcces[].listNatureAccesDalkia[] est obligatoire' + '\n';
                    } 
                }
            } else {
                emplacementToUpsert.DKCodeAdresse__c = null;
                emplacementToUpsert.Numero_Voie__c = null;
                emplacementToUpsert.Type_Voie__c = null;
                emplacementToUpsert.Libelle_Voie__c = null;
                emplacementToUpsert.Complement_Adresse__c = null;
                emplacementToUpsert.Code_Postal__c = null;
                emplacementToUpsert.Ville__c = null;
                emplacementToUpsert.Pays__c = null;
                emplacementToUpsert.AdresseSecondaire__c = null;
            }
            
            // Attribut genieCivil
            if(emplacement.genieCivil != null){
                
                // Attribut anneeFinConstruction
                if(emplacement.genieCivil.anneeFinConstruction != null){
                    emplacementToUpsert.AnneeFinConstruction__c = String.valueOf(emplacement.genieCivil.anneeFinConstruction);
                } else {
                    emplacementToUpsert.AnneeFinConstruction__c = null;
                }
                
                // Attribut etiquetteEnergie
                if(String.isNotBlank(emplacement.genieCivil.etiquetteEnergie)){
                    emplacementToUpsert.EtiquetteEnergie__c = emplacement.genieCivil.etiquetteEnergie;
                } else {
                    emplacementToUpsert.EtiquetteEnergie__c = null;
                }
                
                // Attribut etiquetteClimat
                if(String.isNotBlank(emplacement.genieCivil.etiquetteClimat)){
                    emplacementToUpsert.EtiquetteClimat__c = emplacement.genieCivil.etiquetteClimat;
                } else {
                    emplacementToUpsert.EtiquetteClimat__c = null;
                }
            } else {
                emplacementToUpsert.AnneeFinConstruction__c = null;
                emplacementToUpsert.EtiquetteEnergie__c = null;
                emplacementToUpsert.EtiquetteClimat__c = null;
            }
            
            // Attribut operation
            if(emplacement.operation != null){
                
                // Attribut systemeSTIRequis
                if(emplacement.operation.systemeSTIRequis != null){
                    emplacementToUpsert.SystemeStiRequis__c = emplacement.operation.systemeSTIRequis;
                } else {
                    emplacementToUpsert.SystemeStiRequis__c = false;
                }
                
                // Attribut risqueLegionelle
                if(emplacement.operation.risqueLegionelle != null){
                    emplacementToUpsert.RisqueLegionnelle__c = emplacement.operation.risqueLegionelle;
                } else {
                    emplacementToUpsert.RisqueLegionnelle__c = false;
                }
                
                // Attribut risqueRayonnementsIonisants
                if(emplacement.operation.risqueRayonnementsIonisants != null){
                    emplacementToUpsert.RisqueRayonnementsIonisants__c = emplacement.operation.risqueRayonnementsIonisants;
                } else {
                    emplacementToUpsert.RisqueRayonnementsIonisants__c = false;
                }
                
                // Attribut risquePoussiereZoneAtex
                if(emplacement.operation.risquePoussiereZoneAtex != null){
                    emplacementToUpsert.RisquePoussiereZoneAtex__c = emplacement.operation.risquePoussiereZoneAtex;
                } else {
                    emplacementToUpsert.RisquePoussiereZoneAtex__c = false;
                }
                
                // Attribut risqueAmiante
                if(emplacement.operation.risqueAmiante != null){
                    emplacementToUpsert.RisqueAmiante__c = emplacement.operation.risqueAmiante;
                } else {
                    emplacementToUpsert.RisqueAmiante__c = false;
                }
                
                // Attribut dkCodeEntiteExploitation
                if(String.isNotBlank(emplacement.operation.dkCodeEntiteExploitation)){
                    emplacementToUpsert.DKCode_Entite_Exploitation__c = emplacement.operation.dkCodeEntiteExploitation;
                } else {
                    emplacementToUpsert.DKCode_Entite_Exploitation__c = null;
                }
            } else {
                emplacementToUpsert.SystemeStiRequis__c = false;
                emplacementToUpsert.RisqueLegionnelle__c = false;
                emplacementToUpsert.RisqueRayonnementsIonisants__c = false;
                emplacementToUpsert.RisquePoussiereZoneAtex__c = false;
                emplacementToUpsert.RisqueAmiante__c = false;
                emplacementToUpsert.DKCode_Entite_Exploitation__c = null;
            }
            
            // Attribut service
            if(emplacement.service != null){
                
                // Attribut identifiantExterne
                if(String.isNotBlank(emplacement.service.identifiantExterne)){
                    emplacementToUpsert.ServiceIdentifiantExterne__c = emplacement.service.identifiantExterne;
                } else {
                    emplacementToUpsert.ServiceIdentifiantExterne__c = null;
                }
                
                // Attribut libelleExterne
                if(String.isNotBlank(emplacement.service.libelleExterne)){
                    emplacementToUpsert.ServiceLibelleExterne__c = emplacement.service.libelleExterne;
                } else {
                    emplacementToUpsert.ServiceLibelleExterne__c = null;
                }
                
                // Attribut emplacementAlias
                if(String.isNotBlank(emplacement.service.emplacementAlias)){
                    emplacementToUpsert.ServiceEmplacementAlias__c = emplacement.service.emplacementAlias;
                } else {
                    emplacementToUpsert.ServiceEmplacementAlias__c = null;
                }
            } else {
                emplacementToUpsert.ServiceIdentifiantExterne__c = null;
                emplacementToUpsert.ServiceLibelleExterne__c = null;
                emplacementToUpsert.ServiceEmplacementAlias__c = null;
            }
            
            // Attribut listTranscoCodesDI
            if(emplacement.listTranscoCodesDI != null && emplacement.listTranscoCodesDI.size() > 0){
                
                emplacementToUpsert.CodesDI__c = '';
                
                for(Integer i = 0; i < emplacement.listTranscoCodesDI.size(); i++){
                    
                    // Attribut codeDI
                    if(String.isNotBlank(emplacement.listTranscoCodesDI.get(i).codeDI)) {
                        
                        emplacementToUpsert.CodesDI__c += emplacement.listTranscoCodesDI.get(i).codeDI;
                        
                        if((i + 1) < emplacement.listTranscoCodesDI.size()){
                            emplacementToUpsert.CodesDI__c += ', ';
                        }
                        
                    } else {
                        errorFound += 'Le champ emplacement.listTranscoCodesDI[].codeDI est obligatoire' + '\n';
                    }
                }
            } else {
                emplacementToUpsert.CodesDI__c = null;
            }
            
            // Attribut metadonnees
            if(emplacement.metadonnees != null){
                
                // Attribut dateCreation
                if(emplacement.metadonnees.dateCreation != null) {
                    emplacementToUpsert.DateCreation__c = emplacement.metadonnees.dateCreation;
                } else {
                    errorFound += 'Le champ emplacement.metadonnees[].dateCreation est obligatoire' + '\n';
                }
                
                // Attribut utilisateurCreation
                if(String.isNotBlank(emplacement.metadonnees.utilisateurCreation)) {
                    
                    List<User> utilisateurCreationId = [SELECT Id FROM User
                                                        WHERE ReferentielId__c = :emplacement.metadonnees.utilisateurCreation
                                                        LIMIT 1];
                    
                    if(utilisateurCreationId.size() > 0){
                        emplacementToUpsert.UtilisateurCreation__c = utilisateurCreationId.get(0).Id;
                    } else {
                        emplacementToUpsert.UtilisateurCreation__c = null;
                    }
                    

                } else {
                    errorFound += 'Le champ emplacement.metadonnees[].utilisateurCreation est obligatoire' + '\n';
                }
                
                // Attribut dateModification
                if(emplacement.metadonnees.dateModification != null) {
                    emplacementToUpsert.DateModification__c = emplacement.metadonnees.dateModification;
                } else {
                    emplacementToUpsert.DateModification__c = null;
                }
                
                // Attribut utilisateurModification
                if(String.isNotBlank(emplacement.metadonnees.utilisateurModification)) {
                    
                    List<User> utilisateurModificationId = [SELECT Id FROM User
                                                            WHERE ReferentielId__c = :emplacement.metadonnees.utilisateurModification
                                                            LIMIT 1];
                    
                    if(utilisateurModificationId.size() > 0){
                        emplacementToUpsert.UtilisateurModification__c = utilisateurModificationId.get(0).Id;
                    } else {
                        emplacementToUpsert.UtilisateurModification__c = null;
                    }
                } else {
                    emplacementToUpsert.UtilisateurModification__c = null;
                }
            } 
            
        } else {
            errorFound += 'Le champ emplacement est obligatoire' + '\n';
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
                upsert emplacementToUpsert DKCode_Emplacement__c;
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
    }
}