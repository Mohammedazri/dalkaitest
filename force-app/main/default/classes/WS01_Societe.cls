/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant Societe
*/
global class WS01_Societe {
    
    global class Societe{
        webservice Header Header;
        webservice ProprietesSociete proprietesSociete{get; set;}
        webservice ListeLogos listeLogos{get; set;}
        webservice Activite activite{get; set;}
        webservice Categorie categorie{get; set;}
        webservice ListeParents listeParents{get; set;}
        webservice ListeReporting listeReporting{get; set;}
        webservice Metadonnees metadonnees{get; set;}
    }
    
    global class ListeLogos{
        webservice List<logo> logo;
    }
    
    global class ListeParents{
        webservice List<parent> parent;
    }
    
    global class ListeReporting{
        webservice List<Reporting> reporting;
    }
    
    global class ProprietesSociete{
        webservice String DKCodeSociete;//DKCodeSurPartenaire__c
        webservice String statutSociete;//Statut__c
        webservice String commentaire;
        webservice String categorieSociete;//Categorie_partenaire__c
        webservice String utilisationSociete;//RolePartenaire__c
        webservice String typeImmatriculation;
        webservice String immatriculationLegale;
        webservice String denominationSociale;//Name
        webservice String acronymeSigle;//Sigle__c
        webservice String lieuImmatriculationLegale;
        webservice String formeJuridiqueINSEE;
        webservice String formeJuridique;//Ownership
        webservice String genreSociete;//Genre_partenaire__c
        webservice String deviseCapitalSocial;
        webservice Integer montantCapitalSocial;
        webservice String identifiantCreancierSEPA;
        webservice String numTVAIntracommunautaire;//TVA_intra_communautaire__c
        webservice String codeClientOracle;
        webservice String codeFournisseurOracle;
    }
    
    global class Logo{
        webservice String logoSocieteDalkia;
        webservice Boolean statutLogo;
    }
    
    global class Activite{
        webservice String codeActiviteLocal;
        webservice String codeActiviteInternational;
    }
    
    global class Categorie{
        webservice ListeGroupesDalkia listeGroupesDalkia;
        webservice ListeGroupesEDF listeGroupesEDF;
        webservice Externe externe; 
    }
    
    global class ListeGroupesDalkia{
        webservice List<GroupeDalkia> groupeDalkia;
    }
    
    global class ListeGroupesEDF{
        webservice List<GroupeEDF> groupeEDF;
    }
    
    global class GroupeDalkia{
        webservice String statutGroupeDalkia;
        webservice String perimetreGestion;
        webservice String zoneGeographique;
        webservice String UODalkiaPiloteSociete;
        webservice String statutActivite;
        webservice String modeGestionJuridique;
        webservice dateTime dateFinExercice;
        webservice String deviseComptable;
        webservice String modeGestionComptable;
        webservice String matriculeSociete;
        webservice String modeConsolidation;
        webservice String codeConsolidation;
        webservice String gestionTravauxExternes;
        webservice String groupeIntegrationFiscale;
        webservice String societeDediee;
        webservice Boolean statutGestionCO2;
        webservice String referenceCEE;
        webservice dateTime dateDebut;//Date_debut__pc
        webservice dateTime dateFin;//Date_fin__pc
    }
    
    global class GroupeEDF{
        webservice String statutGroupeEDF;
        webservice String matriculeSociete;
        webservice String modeConsolidation;
        webservice String codeConsolidation;
        webservice String groupeIntegrationFiscale;
        webservice dateTime dateDebut;//Date_debut__pc
        webservice dateTime dateFin;//Date_fin__pc
    }
    
    global class Externe{
        webservice String niveauRelationCommerciale;//Niveaurelationcommerciale__c
        webservice String qualiteRelationCommerciale;//Qualification__c
        webservice boolean grandCompteDalkia;//GrandCompteDalkia__c
        webservice boolean grandCompteEDF;//Grand_compte_EDF__c
        webservice String scoreRisque;
        webservice dateTime dateNotationExterne;
        webservice String appreciationRecouvrement;
        webservice dateTime dateNotationInterne;
    }
    
    global class Parent{
        webservice String societeParente;//Parent
        webservice String natureDeRelation;//NatureRelation__c
        webservice boolean statutLienParent;
        webservice String commentaireLienParent;
    }
    
    global class Reporting{
        webservice String reportingSociete;
    }
    
    global class Metadonnees{
        webservice dateTime creationDate;//CreatedDate
        webservice String creationId;//CreatedBy
        webservice dateTime updateDate;//LastModifiedDate
        webservice String updateId;//LastModifiedBy
        webservice dateTime validationDate;
        webservice String validationId;
    }
    
    webservice static Response insertAccount(Societe Societe) {
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = Societe+'';
        ws.Type__c = Label.WS_Societe;
        ws.flux__c = Label.WSTypeFluxEntrant;
        insert ws;
        
        TimeZone tz = TimeZone.getTimeZone('Europe/Paris');
        
        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        List<recordtype> recTypeList = new List<recordtype>();
        recTypeList = [Select id from recordtype where developername =:Label.societe_account];
        recordtype businessAccountRT = new recordtype();
        if(recTypeList != null && recTypeList.size()>0){
            businessAccountRT = recTypeList[0];
        }
        Account accountToInsert = new Account();
        accountToInsert.RecordTypeId = businessAccountRT.id;
        List<Account> listAcc = new List<Account>();
        //header
        if(Societe.header != null){
            if (Societe.header.transactionId!=null) {
                ws.TransactionId__c = Societe.header.transactionId;
            }
        }
        //proprietesSociete
        if(Societe.proprietesSociete != null){
            if(Societe.proprietesSociete.DKCodeSociete != null){
                ws.DkCode__c= Societe.ProprietesSociete.DKCodeSociete;  
                accountToInsert.DKCodeSurPartenaire__c = Societe.proprietesSociete.DKCodeSociete;
                listAcc = [Select id,DkCodeSociete__c,parentid
                           From Account
                           Where DkCodeSociete__c=:Societe.proprietesSociete.DKCodeSociete
                           And parentid=null];
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_DKCodeSocieteOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.statutSociete != null){
                accountToInsert.StatutPartenaire__c = Societe.proprietesSociete.statutSociete;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_statutSocieteOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.commentaire != null){
                accountToInsert.Commentaire__c = societe.proprietesSociete.commentaire;
            }
            if(Societe.proprietesSociete.categorieSociete != null){
                accountToInsert.Categorie_partenaire__c = Societe.proprietesSociete.categorieSociete;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_categorieSocieteOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.utilisationSociete != null){
                accountToInsert.RolePartenaire__c = Societe.proprietesSociete.utilisationSociete;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_utilisationSocieteOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.typeImmatriculation != null){
                accountToInsert.Type_immatriculation__c = SOCIETE.proprietesSociete.typeImmatriculation;
            }
            if(Societe.proprietesSociete.immatriculationLegale != null){
                accountToInsert.Immatriculation_Legale__c = SOCIETE.proprietesSociete.immatriculationLegale;
            }
            if(Societe.proprietesSociete.denominationSociale != null){
                String tempName = Societe.proprietesSociete.denominationSociale;
                if(tempName != null){
                    if(tempName.length()>80){
                        tempName =  tempName.substring(0,80);
                    }
                }
                accountToInsert.Name = tempName;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_denominationSocialeOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.acronymeSigle != null){
                accountToInsert.Sigle__c = Societe.proprietesSociete.acronymeSigle;
            }
            if(Societe.proprietesSociete.lieuImmatriculationLegale != null){
                accountToInsert.Lieu_immatriculation_legale__c = SOCIETE.proprietesSociete.lieuImmatriculationLegale;
            }
            if(Societe.proprietesSociete.formeJuridiqueINSEE != null){
                accountToInsert.FormeJuridiqueINSEE__c = SOCIETE.proprietesSociete.formeJuridiqueINSEE;
            }
            if(Societe.proprietesSociete.formeJuridique != null){
                accountToInsert.FormeJuridique__c = Societe.proprietesSociete.formeJuridique;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_formeJuridiqueOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.genreSociete != null){
                accountToInsert.Type = Societe.proprietesSociete.genreSociete;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_genreSocieteOB + '\n';
                resp.error = true;
            }
            if(Societe.proprietesSociete.deviseCapitalSocial != null){
                accountToInsert.Devise_Capital_Social__c = SOCIETE.proprietesSociete.deviseCapitalSocial;
            }
            if(Societe.proprietesSociete.montantCapitalSocial != null){
                accountToInsert.Montant_capital_Social__c = SOCIETE.proprietesSociete.montantCapitalSocial;
            }
            if(Societe.proprietesSociete.identifiantCreancierSEPA != null){
                accountToInsert.Identifiant_Creancier_SEPA__c = SOCIETE.proprietesSociete.identifiantCreancierSEPA;
            }
            if(Societe.proprietesSociete.numTVAIntracommunautaire != null){
                accountToInsert.TVA_intra_communautaire__c = Societe.proprietesSociete.numTVAIntracommunautaire;
            }
            if(Societe.proprietesSociete.codeClientOracle != null){
                accountToInsert.Code_Client_Oracle__c = SOCIETE.proprietesSociete.codeClientOracle;
            }
            if(Societe.proprietesSociete.codeFournisseurOracle != null){
                accountToInsert.Code_Fournisseur_Oracle__c= SOCIETE.proprietesSociete.codeFournisseurOracle;
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS01_proprietesSocieteOB + '\n';
            resp.error = true;
        }
        /*
        for (logo logoLoop : Societe.listeLogos.logo){
            if(logoLoop.logoSocieteDalkia != null){
                accountToInsert.Logo_Societe_Dalkia__c = logoLoop.logoSocieteDalkia;
                
            }
            else{
                resp.responseCode = 'KO';
                resp.errorText += 'Le champ logoSocieteDalkia est obligatoire \n';
                resp.error = true;
            }
            
            //if(logoLoop.statutLogo!=null && logoLoop.statutLogo.equals('Actif')){
            if(logoLoop.statutLogo != null){
                accountToInsert.Statut_Logo__c = logoLoop.statutLogo; 
            }
            //}
            else{
                resp.responseCode = 'KO';
                resp.errorText += 'Le champ statutLogo est obligatoire \n';
                resp.error = true;
            }
        }*/
        //activite
        if(Societe.activite!=null){
            if(Societe.activite.codeActiviteLocal != null){
                accountToInsert.Code_NAF__c = SOCIETE.activite.codeActiviteLocal;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_codeActiviteLocalOB + '\n';
                resp.error = true;
            }
            if(Societe.activite.codeActiviteInternational != null){
                accountToInsert.Code_NACE__c = SOCIETE.activite.codeActiviteInternational;
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_codeActiviteInternationalOB + '\n';
                resp.error = true;
            }
        }
        String UODalkia = '';
        //categorie
        if(Societe.categorie != null){
            if(Societe.categorie.listeGroupesDalkia!=null && Societe.categorie.listeGroupesDalkia.groupeDalkia != null){
                for(groupeDalkia groupDalkia : Societe.categorie.listeGroupesDalkia.groupeDalkia){
                    if(groupDalkia.statutGroupeDalkia != null){
                        accountToInsert.Statut_Groupe_Dalkia__c = groupDalkia.statutGroupeDalkia;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_statutGroupeDalkia + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.perimetreGestion != null){
                        accountToInsert.Perimetre_Gestion__c = groupDalkia.perimetreGestion;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_perimetreGestionOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.zoneGeographique != null){
                        accountToInsert.Zone_Geographique__c = groupDalkia.zoneGeographique;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_zoneGeographiqueOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.UODalkiaPiloteSociete != null){
                        UODalkia = groupDalkia.UODalkiaPiloteSociete;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_UODalkiaPiloteSocieteOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.statutActivite != null){
                        accountToInsert.Statut_Activite__c = groupDalkia.statutActivite;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_statutActiviteOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.modeGestionJuridique != null){
                        accountToInsert.Mode_Gestion_Juridique__c = groupDalkia.modeGestionJuridique;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_modeGestionJuridiqueOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.dateFinExercice != null){
                        DateTime dateFinExerciceOriginal = groupDalkia.dateFinExercice;
                        Date dateFinExerciceConverted = date.newinstance(dateFinExerciceOriginal.year(), dateFinExerciceOriginal.month(), dateFinExerciceOriginal.day());
                        accountToInsert.Date_Fin_Exercice__c =  dateFinExerciceConverted;
                        
                        groupDalkia.dateFinExercice = groupDalkia.dateFinExercice.addSeconds(tz.getOffset(groupDalkia.dateFinExercice) / 1000);
                        ws.Request__c = Societe+'';
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_dateFinExerciceOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.deviseComptable != null){
                        accountToInsert.Devise_Comptable__c = groupDalkia.deviseComptable;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_deviseComptableOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.modeGestionComptable != null){
                        accountToInsert.Mode_Gestion_Comptable__c = groupDalkia.modeGestionComptable;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_modeGestionComptableOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.matriculeSociete != null){
                        accountToInsert.Matricule_Societe__c = groupDalkia.matriculeSociete;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_matriculeSocieteOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.modeConsolidation != null){
                        accountToInsert.Mode_Consolidation__c = groupDalkia.modeConsolidation;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_modeConsolidationOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.codeConsolidation != null){
                        accountToInsert.Code_Consolidation__c = groupDalkia.codeConsolidation;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_codeConsolidationOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.gestionTravauxExternes != null){
                        accountToInsert.Gestion_Travaux_Externes__c = groupDalkia.gestionTravauxExternes;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_gestionTravauxExternesOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.groupeIntegrationFiscale != null){
                        accountToInsert.Groupe_Integration_Fiscale__c = groupDalkia.groupeIntegrationFiscale;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_groupeIntegrationFiscaleOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.societeDediee != null){
                        accountToInsert.Societe_Dediee__c = groupDalkia.societeDediee;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_societeDedieeOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.statutGestionCO2 != null){
                        accountToInsert.Statut_Gestion_CO2__c = groupDalkia.statutGestionCO2;
                    }
                    if(groupDalkia.referenceCEE != null){
                        accountToInsert.Reference_CEE__c = groupDalkia.referenceCEE;
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS01_referenceCEEOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.dateDebut != null){
                        Date dt = date.newInstance(groupDalkia.dateDebut.year(), groupDalkia.dateDebut.month(), groupDalkia.dateDebut.day());
                        accountToInsert.DateDebut__c = dt;
                        
                        groupDalkia.dateDebut = groupDalkia.dateDebut.addSeconds(tz.getOffset(groupDalkia.dateDebut) / 1000);
                        ws.Request__c = Societe+'';
                    }
                    else{
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_dateDebutOB + '\n';
                        resp.error = true;
                    }
                    if(groupDalkia.dateFin != null){
                        Date dt = date.newInstance(groupDalkia.dateFin.year(), groupDalkia.dateFin.month(), groupDalkia.dateFin.day());
                        accountToInsert.DateFin__c = dt;
                    }
                }
                if(UODalkia != '' && UODalkia != null){
                    List<CentreFinance__c> listCentre = [Select id,DkCode__c from CentreFinance__c where DkCode__c = : UODalkia];
                    if(listCentre != null && listCentre.size()>0){
                        accountToInsert.UODalkiaPilote__c = listCentre[0].id;   
                    }
                }
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS01_categorieOB + '\n';
            resp.error = true;
        }
        //listeGroupesEDF
        if(Societe.categorie != null && Societe.categorie.listeGroupesEDF!=null &&  Societe.categorie.listeGroupesEDF.groupeEDF != null){
            for(groupeEDF groupeEDF : Societe.categorie.listeGroupesEDF.groupeEDF){
                if(groupeEDF.statutGroupeEDF != null){
                    accountToInsert.Statut_Groupe_EDF__c = groupeEDF.statutGroupeEDF;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS01_statutGroupeEDFOB + '\n';
                    resp.error = true;
                }
                if(groupeEDF.matriculeSociete != null){
                    accountToInsert.Matricule_Societe__c = groupeEDF.matriculeSociete;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS01_matriculeSocieteOB + '\n';
                    resp.error = true;
                }
                if(groupeEDF.modeConsolidation != null){
                    accountToInsert.Mode_Consolidation__c = groupeEDF.modeConsolidation;
                }
                if(groupeEDF.codeConsolidation != null){
                    accountToInsert.Code_Consolidation__c = groupeEDF.codeConsolidation;
                }
                if(groupeEDF.groupeIntegrationFiscale != null){
                    accountToInsert.Groupe_Integration_Fiscale__c = groupeEDF.groupeIntegrationFiscale;
                }
                if(groupeEDF.dateDebut != null){
                    Date dt = date.newInstance(groupeEDF.dateDebut.year(), groupeEDF.dateDebut.month(), groupeEDF.dateDebut.day());
                    accountToInsert.DateDebut__c = dt;
                    
                    groupeEDF.dateDebut = groupeEDF.dateDebut.addSeconds(tz.getOffset(groupeEDF.dateDebut) / 1000);
                    ws.Request__c = Societe+'';
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_dateDebutOB + '\n';
                    resp.error = true;
                }
                if(groupeEDF.dateFin != null){
                    Date dt = date.newInstance(groupeEDF.dateFin.year(), groupeEDF.dateFin.month(), groupeEDF.dateFin.day());
                    accountToInsert.DateFin__c = dt;
                    
                    groupeEDF.dateFin = groupeEDF.dateFin.addSeconds(tz.getOffset(groupeEDF.dateFin) / 1000);
                    ws.Request__c = Societe+'';
                }
            }
        }
        //externe
        if(Societe.categorie!=null && Societe.categorie.externe != null){
            if(Societe.categorie.externe.niveauRelationCommerciale != null){
                //accountToInsert.Niveaurelationcommerciale__c = Societe.categorie.externe.niveauRelationCommerciale;
                accountToInsert.Qualification__c = Societe.categorie.externe.niveauRelationCommerciale;
            }
            if(Societe.categorie.externe.qualiteRelationCommerciale != null){
                //accountToInsert.QualitePartenaire__c = Societe.categorie.externe.qualiteRelationCommerciale;
                //accountToInsert.Qualification__c = Societe.categorie.externe.qualiteRelationCommerciale;
                accountToInsert.Visionrelationcommercialeterrain__c = Societe.categorie.externe.qualiteRelationCommerciale;
            }
            if(Societe.categorie.externe.grandCompteDalkia != null){
                accountToInsert.GrandCompteDalkia__c = SOCIETE.categorie.externe.grandCompteDalkia;
            }
            else{
                accountToInsert.GrandCompteDalkia__c = false;
            }
            if(Societe.categorie.externe.grandCompteEDF != null){
                accountToInsert.Grand_compte_EDF__c = SOCIETE.categorie.externe.grandCompteEDF;
            }
            else{
                accountToInsert.Grand_compte_EDF__c = false;
            }
            if(Societe.categorie.externe.scoreRisque != null){
                accountToInsert.Score_Risque__c = SOCIETE.categorie.externe.scoreRisque;
            }
            if(Societe.categorie.externe.dateNotationExterne != null){
                Date dt = date.newInstance(SOCIETE.categorie.externe.dateNotationExterne.year(), SOCIETE.categorie.externe.dateNotationExterne.month(), SOCIETE.categorie.externe.dateNotationExterne.day());
                accountToInsert.Date_Notation_Externe__c = dt;
                
                Societe.categorie.externe.dateNotationExterne = Societe.categorie.externe.dateNotationExterne.addSeconds(tz.getOffset(Societe.categorie.externe.dateNotationExterne) / 1000);
                ws.Request__c = Societe+'';
            }
            if(Societe.categorie.externe.appreciationRecouvrement != null){
                accountToInsert.Appreciation_Recouvrement__c = SOCIETE.categorie.externe.appreciationRecouvrement;
            }
            if(Societe.categorie.externe.dateNotationInterne != null){
                Date dt = date.newInstance(SOCIETE.categorie.externe.dateNotationInterne.year(), SOCIETE.categorie.externe.dateNotationInterne.month(), SOCIETE.categorie.externe.dateNotationInterne.day());
                accountToInsert.Date_Notation_Interne__c = dt;
                
                Societe.categorie.externe.dateNotationInterne = Societe.categorie.externe.dateNotationInterne.addSeconds(tz.getOffset(Societe.categorie.externe.dateNotationInterne) / 1000);
                ws.Request__c = Societe+'';
            }
        }
        //listeParents
        if(Societe.listeParents!=null && Societe.listeParents.parent != null){
            String socParent = '';
            for(parent prt : Societe.listeParents.parent){
                if(prt.societeParente != null){
                    socParent = prt.societeParente;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS01_societeParenteOB + '\n';
                    resp.error = true;
                }
                if(prt.natureDeRelation != null){
                    accountToInsert.NatureRelation__c = prt.natureDeRelation;
                }
                if(prt.statutLienParent != null){
                    accountToInsert.Statut_Lien_Parent__c = prt.statutLienParent;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS01_statutLienParentOB + '\n';
                    resp.error = true;
                }
                if(prt.commentaireLienParent != null){
                    accountToInsert.Commentaire_Lien_Parent__c = prt.commentaireLienParent;
                }
            }
            if(socParent != '' && socParent != null){
                List<Account> listParentAcc = new List<Account>();
                listParentAcc = [SELECT Id, Name,DKCodeSurPartenaire__c FROM ACcount WHERE DKCodeSurPartenaire__c=:socParent ] ;
                if(listParentAcc != null && listParentAcc.size()>0){
                    accountToInsert.Parent = listParentAcc[0];
                }
            }
        }
        //listeReporting
        if(Societe.listeReporting!=null && Societe.listeReporting.reporting != null){
            for(reporting rep : Societe.listeReporting.reporting){
                if(rep.reportingSociete != null){
                    accountToInsert.Reporting_Societe__c = rep.reportingSociete;
                }
                else{
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS01_reportingSocieteOB + '\n';
                    resp.error = true;
                }
            }
        }
        //metadonnees
        if(Societe.metadonnees != null){
            if(Societe.metadonnees.creationDate != null){
                accountToInsert.CreateDate__c = Societe.metadonnees.creationDate;
                
                Societe.metadonnees.creationDate = Societe.metadonnees.creationDate.addSeconds(tz.getOffset(Societe.metadonnees.creationDate) / 1000);
                ws.Request__c = Societe+'';
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationDateOB + '\n';
                resp.error = true;
            }
            List<User> userMetadonne = new List<User>();
            userMetadonne = [SELECT id,name,ReferentielId__c 
                             FROM user 
                             WHERE ReferentielId__c = : Societe.Metadonnees.creationId
                             OR ReferentielId__c = : Societe.Metadonnees.updateId
                             OR ReferentielId__c = : Societe.Metadonnees.validationId];
            if(Societe.metadonnees.creationId != null){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == Societe.Metadonnees.creationId){
                        accountToInsert.CreateId__c  = userLoop.id;  
                    }
                }
            }
            else{
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS06_creationId + '\n';
                resp.error = true;
            }
            if(Societe.metadonnees.updateDate != null){
                accountToInsert.UpdateDate__c = Societe.metadonnees.updateDate;
                
                Societe.metadonnees.updateDate = Societe.metadonnees.updateDate.addSeconds(tz.getOffset(Societe.metadonnees.updateDate) / 1000);
                ws.Request__c = Societe+'';
            }
            
            if(Societe.metadonnees.updateId != null){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == Societe.Metadonnees.updateId){
                        accountToInsert.updateId__c  = userLoop.id;  
                    }
                }
            }
            if(Societe.metadonnees.validationDate != null){
                accountToInsert.ValidationDate__c = SOCIETE.metadonnees.validationDate;
                
                Societe.metadonnees.validationDate = Societe.metadonnees.validationDate.addSeconds(tz.getOffset(Societe.metadonnees.validationDate) / 1000);
                ws.Request__c = Societe+'';
            }
            if(Societe.metadonnees.validationId != null){
                for(User userLoop : userMetadonne){
                    if(userLoop.ReferentielId__c == Societe.Metadonnees.validationId){
                        accountToInsert.validationId__c  = userLoop.id;  
                    }
                }
            }
        }
        else{
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS01_metadonneesOB + '\n';
            resp.error = true;
        }
        ws.Response__c = resp+'';
        if(resp.error == true){
            ws.Statut__c = 'KO';
            ws.ErrorText__c = resp.errorText;
            if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
            }
        }
        else{
            ws.Statut__c = 'OK';
        }
        update ws;
        if(!resp.error){
            try{
                upsert accountToInsert DKCodeSurPartenaire__c;
                for(Account acc : listAcc){
                    acc.parentId = accountToInsert.Id;
                }
                upsert listAcc;
            }
            catch(Exception e){
                ws.Statut__c ='KO';
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS01_Error + e.getMessage() + '\n';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                }
                System.debug('insertUpdateSociete error ' + e.getMessage());
                ws.Response__c = resp+ Label.WS01_AfterError + e.getMessage();
                update ws;
            }
        }
        return resp;
    }
}