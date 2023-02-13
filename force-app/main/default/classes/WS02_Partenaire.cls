/**
 * @author: Alain Ghoussoub -EI Technologies
 * @date: 10/01/2019
 * @description: Class qui gère le web service entrant Partenaire
 */
global class WS02_Partenaire {
    global class partenaire {
        webservice Header Header;
        webservice proprietesPartenaire proprietesPartenaire;
        webservice Particulier particulier;
        webservice Etablissement etablissement;
        //webservice particulierOuEtablissement particulierOuEtablissement;
        webservice client client;
        webservice fournisseur fournisseur;
        webservice listeAdresses listeAdresses;
        webservice listeResponsables listeResponsables;
        webservice listeImmatriculationsAnterieures listeImmatriculationsAnterieures;
        webservice metadonnees metadonnees;
    }
    global class listeResponsables {
        webservice List<responsable> responsable;
    }

    global class listeImmatriculationsAnterieures {
        webservice List<immatriculationsAnterieures> immatriculationsAnterieures;
    }
    global class listeAdresses {
        webservice List<adresse> adresse;
    }
    global class proprietesPartenaire {
        webservice string DKCodePartenaire;//DKCodeSurPartenaire__c
        webservice string statutPartenaire;//Statut__c
        webservice string commentaire;//Description
        webservice string naturePartenaire;//NaturePartenaire__c
        webservice Datetime dateDerniereMajSiren;
    }
    /*global class particulierOuEtablissement{
       webservice Particulier particulier;
       webservice Etablissement etablissement;
       }*/
    global class particulier {
        webservice string civilite;//PersonTitle
        webservice string nomUsage;//LastName
        webservice string prenomUsage;//FirstName
        webservice dateTime dateDeNaissance;//PersonBirthdate
        webservice string lieuDeNaissance;
        webservice string paysDeNaissance;
        webservice string statutParticulier;
    }
    global class etablissement {
        webservice string typeImmatriculation;//to create
        webservice string immatriculationLegale;//SIRET__c
        webservice string libelleEtablissement;//LibelleEtablissement__c
        webservice string denominationCommerciale;//Trouver champ avec mapping siren
        webservice string complementLibelle;//Site
        webservice string typeIdentificationExterne;//to create
        webservice string identificationExterne;//Identification_externe__c
        webservice string nomNaissance;//NO?
        webservice string nomUsage;//NO?
        webservice string PRENOMS;//NO?
        webservice boolean siegeSocialPartenaire;//Siege_social_partenaire__c
        webservice String effectifSalarie;//effectif__c
        webservice dateTime dateDebut;//TO CREATE
        webservice dateTime dateFin;//TO CREATE
        webservice string statutEtablissement;//NO?
        webservice string UODalkiaPilote;//EntiteCommercialeDalkia__c
        webservice boolean statutGestionRH;//NO?
        webservice string codeActiviteLocal;//Code_NAF__c
        webservice string codeActiviteInternational;//TO CREATE
        webservice societe societe;
        webservice chorus chorus;
    }

    global class societe {
        webservice string DKCodeSociete;//PARENT ID ET DkCodeSociete__c
        webservice string categorieSociete;//PARENTID.Categorie_Partenaire__c
    }
    global class chorus {
        webservice boolean SEObligatoire;
        webservice boolean EJObligatoire;
        webservice boolean SEOuEJObligatoire;
        webservice string SEParDefaut;
    }
    global class client {
        webservice string utilisationFiliereCommerce;//Utilisation_filiere_Commerce__c
        webservice string segmentClient;//Segment_client__c
        webservice string sousSegmentClient;//Sous_segment_client__c
        webservice string entiteCommercialeDalkia;//EntiteCommercialeDalkia__c
        webservice string entiteCommercialeEdf;//EntiteCommercialeEDF__c
        webservice boolean societeMandataire;
        webservice listeRecouvrements listeRecouvrements;
        webservice conditionsPaiementDefaut conditionsPaiementDefaut;
    }
    global class listeRecouvrements {
        webservice List<recouvrement> recouvrement;
    }
    global class recouvrement {
        webservice string codeRecouvrement;
    }
    global class conditionsPaiementDefaut {
        webservice string departExigibilite;
        webservice string delaiPaiementJours;
        webservice boolean reportFinMois;
        webservice string jourMoisSuivant;
        webservice string methodeInteretsRetard;
        webservice string modeReglement;
    }
    global class fournisseur {
        webservice boolean utilisationFiliereAchats;
        webservice boolean societeAffacturage;
        webservice listeClassification listeClassification;
    }
    global class listeClassification {
        webservice List<classification> classification;
    }
    global class classification {
        webservice string perimetreAchat;
        webservice string niveauClassificationAchat;
    }
    global class adresse {
        webservice string DKCodeAdresse;//TO CREATE
        webservice boolean adressePrincipale;
        webservice string statutAdresse;//Statut_adresse_1__c
        webservice string precisionDestinataire;//to create
        webservice string precisionIdentificationAdresse;//to create
        webservice string numeroVoie;//BillingStreet
        webservice string typeDeVoie;//BillingStreet
        webservice string libelleVoie;//BillingStreet
        webservice string complementAdresse;//BillingStreet
        webservice string codePostal;//BillingPostalCode
        webservice string ville;//BillingCity
        webservice string pays;//BillingCountry
        webservice string telephone;//Phone
        webservice string fax;//Fax
        webservice string codeClientOracle;//NO?
        webservice string codeFournisseurOracle;//NO?
        webservice string referenceAdresseClient;//Reference_adresse__c
        webservice string referenceAdresseFournisseur;//NO?
        webservice boolean dematerialise;//NO?
        webservice listeAffacturages listeAffacturages;
        //webservice List<affacturage> affacturage;
        webservice listeMandataires listeMandataires;

        webservice List<metadonneesAdressePartenaire> metadonneesAdressePartenaire;
    }
    global class listeMandataires {
        webservice List<mandataire> mandataire;
    }
    global class listeAffacturages {
        webservice List<affacturage> affacturage;
    }
    global class metadonneesAdressePartenaire {
        webservice dateTime creationDate;
        webservice string creationId;
        webservice dateTime updateDate;
        webservice string updateId;
        webservice dateTime validationDate;
        webservice string validationId;
    }
    global class affacturage {
        webservice string DKCPartenaireAffacturage;//NO?
        webservice string DKCAdressePartenaireAffacturage;//NO?
        webservice boolean statutLienAffacturage;//NO?
    }
    global class mandataire {
        webservice string DKCPartenanireMandataire;
        webservice string DKCAdressePartenaireMandataire;
        webservice boolean statutLienMandataire;
    }
    global class responsable {
        webservice string responsableCompte;
        webservice string perimetreResponsable;
        webservice boolean statutLienResponsable;
    }
    global class immatriculationsAnterieures {
        webservice string ImmatriculationAnterieure;
        webservice dateTime dateFinImmatriculation;
    }
    global class metadonnees {
        webservice dateTime creationDate;//CreatedDate
        webservice string creationId;//CreatedBy
        webservice dateTime updateDate;//LastModifiedDate
        webservice string updateId;//LastModifiedBy
        webservice dateTime validationDate;
        webservice string validationId;
    }

    webservice static Response insertUpdatePartenaire(Partenaire partenaire) {

        List<CentreFinance__c> listCentre = new List<CentreFinance__c>();

        Response resp = new Response();
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        resp.errorText = '';
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = partenaire + '';
        ws.Type__c = Label.WS_Partenaire;
        ws.flux__c = Label.WSTypeFluxEntrant;
        Boolean dkCodeExiste = false;
        insert ws;

        TimeZone tz = TimeZone.getTimeZone('Europe/Paris');

        String businessAccountRT;
        String personAccountRT;
        String partenaireSansSiret;
        List<recordtype> accountRecordTypes = new List<recordtype>();
        accountRecordTypes = [Select id, developername
                              From recordtype
                              Where developername =:Label.Business_Account
                              OR developername = :Label.PersonAccount];
        if(accountRecordTypes != null && accountRecordTypes.size() > 0) {
            for(recordtype rt : accountRecordTypes) {
                if(rt.developername == Label.Business_Account) {
                    businessAccountRT = rt.id;
                }
                if(rt.developername == Label.PersonAccount) {
                    personAccountRT = rt.id;
                }
            }
        }

        Account accountToInsert = new Account();

        //Ajout des champs WS
        if(partenaire.header != null) {
            if(partenaire.header.transactionId != null) {
                ws.TransactionId__c = partenaire.header.transactionId;
            }
        }

        if(partenaire != null) {
            if(partenaire.proprietesPartenaire != null) {
                if(String.isNotBlank(partenaire.proprietesPartenaire.DKCodePartenaire)) {
                    ws.DkCode__c = partenaire.proprietesPartenaire.DKCodePartenaire;
                    accountToInsert.DKCodeSurPartenaire__c = partenaire.proprietesPartenaire.DKCodePartenaire;
                    List<Account> accList = new List<Account>();
                    accList = [Select id, name
                               From Account
                               Where DKCodeSurPartenaire__c = :partenaire.proprietesPartenaire.DKCodePartenaire];
                    if(accList != null && accList.size() > 0) {
                        dkCodeExiste = true;
                    }
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_DKCodePartenaireOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(partenaire.proprietesPartenaire.statutPartenaire) ) {
                    accountToInsert.StatutPartenaire__c = partenaire.proprietesPartenaire.statutPartenaire;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_statutPartenaireOB + '\n';
                    resp.error = true;
                }
                if(partenaire.proprietesPartenaire.commentaire != null) {
                    accountToInsert.commentaire__c = partenaire.proprietesPartenaire.commentaire;
                }
                if(String.isNotBlank(partenaire.proprietesPartenaire.naturePartenaire) ) {
                    accountToInsert.NaturePartenaire__c = partenaire.proprietesPartenaire.naturePartenaire;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_naturePartenaireOB + '\n';
                    resp.error = true;
                }
                if(partenaire.proprietesPartenaire.dateDerniereMajSiren != null) {
                    Date dt = date.newinstance(partenaire.proprietesPartenaire.dateDerniereMajSiren.year(), partenaire.proprietesPartenaire.dateDerniereMajSiren.month(), partenaire.proprietesPartenaire.dateDerniereMajSiren.day());
                    accountToInsert.DateDerniereMajSirene__c = dt;

                    partenaire.proprietesPartenaire.dateDerniereMajSiren = partenaire.proprietesPartenaire.dateDerniereMajSiren.addSeconds(tz.getOffset(partenaire.proprietesPartenaire.dateDerniereMajSiren) / 1000);
                    ws.Request__c = partenaire + '';
                }
            } else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS02_proprietesPartenaireOB + '\n';
                resp.error = true;
            }
            if(partenaire.etablissement != null || partenaire.particulier != null) {
                if(partenaire.etablissement != null && partenaire.proprietesPartenaire.naturePartenaire != null && partenaire.proprietesPartenaire.naturePartenaire.equals('ETAB')) {
                    accountToInsert.RecordTypeId = businessAccountRT;
                    if(partenaire.Etablissement.typeImmatriculation != null) {
                        /*if(partenaire.Etablissement.typeImmatriculation=='RCS'){
                           }
                           else{
                           accountToInsert.RecordTypeId = partenaireSansSiret;
                           }*/
                        accountToInsert.Type_immatriculation__c = partenaire.Etablissement.typeImmatriculation;
                    }
                    /*else{
                       accountToInsert.RecordTypeId = partenaireSansSiret;
                       }*/
                    if(partenaire.Etablissement.immatriculationLegale != null) {
                        accountToInsert.SIRET__c = partenaire.Etablissement.immatriculationLegale;
                    }
                    if(partenaire.Etablissement.libelleEtablissement != null) {
                        accountToInsert.LibelleEtablissement__c = partenaire.Etablissement.libelleEtablissement;
                        String tempName = partenaire.Etablissement.libelleEtablissement;
                        if(tempName != null) {
                            if(tempName.length() > 80) {
                                tempName =  tempName.substring(0, 80);
                            }
                        }
                        accountToInsert.Name = tempName;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_libelleEtablissementOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Etablissement.denominationCommerciale != null) {
                        accountToInsert.Sigle__c = partenaire.Etablissement.denominationCommerciale;
                    }
                    if(partenaire.Etablissement.complementLibelle != null) {
                        accountToInsert.ComplementLibelle__c = partenaire.Etablissement.complementLibelle;
                    }
                    if(partenaire.Etablissement.typeIdentificationExterne != null) {
                        accountToInsert.TypeIdentificationExterne__c = partenaire.Etablissement.typeIdentificationExterne;
                    }
                    if(partenaire.Etablissement.identificationExterne != null) {
                        accountToInsert.Identification_externe__c = partenaire.Etablissement.identificationExterne;
                    }
                    if(partenaire.Etablissement.nomNaissance != null) {
                        accountToInsert.tech_nom_naissance__c =  partenaire.Etablissement.nomNaissance;
                    }
                    if(partenaire.Etablissement.nomUsage != null) {
                        accountToInsert.tech_nom_usage__c =  partenaire.Etablissement.nomUsage;
                    }
                    if(partenaire.Etablissement.PRENOMS != null) {
                        accountToInsert.tech_prenom__c =  partenaire.Etablissement.PRENOMS;
                    }
                    if(partenaire.Etablissement.siegeSocialPartenaire != null) {
                        accountToInsert.Siege_social_partenaire__c = partenaire.Etablissement.siegeSocialPartenaire;
                    }
                    if(partenaire.Etablissement.effectifSalarie != null) {
                        accountToInsert.effectif__c = partenaire.Etablissement.effectifSalarie;
                    }
                    if(partenaire.Etablissement.dateDebut != null) {
                        Date dt = date.newinstance(partenaire.Etablissement.dateDebut.year(), partenaire.Etablissement.dateDebut.month(), partenaire.Etablissement.dateDebut.day());
                        accountToInsert.DateDebut__c = dt;

                        partenaire.Etablissement.dateDebut = partenaire.Etablissement.dateDebut.addSeconds(tz.getOffset(partenaire.Etablissement.dateDebut) / 1000);
                        ws.Request__c = partenaire + '';
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_dateDebutOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Etablissement.dateFin != null) {
                        Date dt = date.newinstance(partenaire.Etablissement.dateFin.year(), partenaire.Etablissement.dateFin.month(), partenaire.Etablissement.dateFin.day());
                        accountToInsert.DateFin__c = dt;

                        partenaire.Etablissement.dateFin = partenaire.Etablissement.dateFin.addSeconds(tz.getOffset(partenaire.Etablissement.dateFin) / 1000);
                        ws.Request__c = partenaire + '';
                    }
                    if(partenaire.Etablissement.statutEtablissement != null) {
                        //accountToInsert.?? = partenaire.Etablissement.statutEtablissement;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_statutEtablissementOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Etablissement.UODalkiaPilote != null) {
                        listCentre = [Select id, DkCode__c, Responsable_Defaut__c from CentreFinance__c where DkCode__c = : partenaire.Etablissement.UODalkiaPilote];
                        if(listCentre != null && listCentre.size() > 0) {
                            accountToInsert.UODalkiaPilote__c = listCentre[0].id;
                        }
                    }
                    if(partenaire.Etablissement.statutGestionRH != null) {
                        //accountToInsert.?? = partenaire.Etablissement.statutGestionRH;
                    }
                    if(partenaire.Etablissement.codeActiviteLocal != null) {
                        accountToInsert.Code_NAF__c = partenaire.Etablissement.codeActiviteLocal;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_codeActiviteLocalOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Etablissement.codeActiviteInternational != null) {
                        accountToInsert.Code_NACE__c = partenaire.Etablissement.codeActiviteInternational;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_codeActiviteInternationalOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Etablissement.societe != null && String.isNotBlank(partenaire.Etablissement.societe.DKCodeSociete) ) {
                        accountToInsert.DkCodeSociete__c = partenaire.Etablissement.societe.DKCodeSociete;
                        List<Account> accList = [select id, Categorie_partenaire__c from account where DKCodeSurPartenaire__c = : partenaire.Etablissement.societe.DKCodeSociete];
                        if(accList != null && accList.size() > 0) {
                            accountToInsert.parentid  = accList[0].id;
                            accountToInsert.Categorie_partenaire__c = accList[0].Categorie_partenaire__c;
                        }
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_DKCodeSocieteOB + '\n';
                        resp.error = true;
                    }
                }
                if(partenaire.particulier != null && partenaire.proprietesPartenaire.naturePartenaire.equals('PART')) {
                    accountToInsert.RecordTypeId = personAccountRT;
                    if(String.isNotBlank(partenaire.particulier.civilite) ) {
                        accountToInsert.PersonTitle = partenaire.particulier.civilite;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_civiliteOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(partenaire.particulier.nomUsage) ) {
                        accountToInsert.LastName = partenaire.particulier.nomUsage;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_nomUsageOB + '\n';
                        resp.error = true;
                    }
                    if(String.isNotBlank(partenaire.particulier.prenomUsage) ) {
                        accountToInsert.FirstName = partenaire.particulier.prenomUsage;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_prenomUsageOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.particulier.dateDeNaissance != null) {
                        Date dt = date.newinstance(partenaire.particulier.dateDeNaissance.year(), partenaire.particulier.dateDeNaissance.month(), partenaire.particulier.dateDeNaissance.day());
                        accountToInsert.PersonBirthdate = dt;

                        partenaire.particulier.dateDeNaissance = partenaire.particulier.dateDeNaissance.addSeconds(tz.getOffset(partenaire.particulier.dateDeNaissance) / 1000);
                        ws.Request__c = partenaire + '';
                    }
                    if(partenaire.particulier.lieuDeNaissance != null) {
                        accountToInsert.tech_lieu_particulier__c = partenaire.particulier.lieuDeNaissance;
                    }
                    if(partenaire.particulier.paysDeNaissance != null) {
                        accountToInsert.tech_pays_particulier__c =  partenaire.particulier.paysDeNaissance;
                    }
                    if(String.isNotBlank(partenaire.particulier.statutParticulier)) {
                        accountToInsert.tech_statut_particulier__c = partenaire.particulier.statutParticulier;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_statutParticulierOB + '\n';
                        resp.error = true;
                    }
                }
                /*
                   if(partenaire.Etablissement.chorus.SEObligatoire != null ){
                   //accountToInsert.?? = partenaire.Etablissement.chorus.SEObligatoire;
                   }
                   else{
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += 'Le champ SEObligatoire est obligatoire \n';
                   resp.error = true;
                   }
                   if(partenaire.Etablissement.chorus.EJObligatoire != null ){
                   //accountToInsert.?? = partenaire.Etablissement.chorus.EJObligatoire;
                   }
                   else{
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += 'Le champ EJObligatoire est obligatoire \n';
                   resp.error = true;
                   }
                   if(partenaire.Etablissement.chorus.SEOuEJObligatoire != null ){
                   //accountToInsert.?? = partenaire.Etablissement.chorus.SEOuEJObligatoire;
                   }
                   else{
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += 'Le champ SEOuEJObligatoire est obligatoire \n';
                   resp.error = true;
                   }
                   if(partenaire.Etablissement.chorus.SEParDefaut != null ){
                   //accountToInsert.?? = partenaire.Etablissement.chorus.SEParDefaut;
                   }
                   else{
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += 'Le champ SEParDefaut est obligatoire \n';
                   resp.error = true;
                   }
                 */
            } else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS02_particulierOuEtablissementOB + '\n';
                resp.error = true;
            }
            if(partenaire.client != null) {
                if(String.isNotBlank(partenaire.Client.utilisationFiliereCommerce) ) {
                    if(partenaire.Client.utilisationFiliereCommerce == Label.WS02_true) {
                        accountToInsert.Utilisation_filiere_Commerce__c = Label.WS02_Actif;
                    } else {
                        accountToInsert.Utilisation_filiere_Commerce__c = Label.WS02_Inactif;
                    }
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_utilisationFiliereCommerceOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(partenaire.Client.segmentClient) ) {
                    accountToInsert.Segment_client__c = partenaire.Client.segmentClient;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_segmentClientOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(partenaire.Client.sousSegmentClient) ) {
                    accountToInsert.Sous_segment_client__c = partenaire.Client.sousSegmentClient;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_sousSegmentClientOB + '\n';
                    resp.error = true;
                }
                if(String.isNotBlank(partenaire.Client.entiteCommercialeDalkia) ) {
                    accountToInsert.EntiteCommercialeDalkia__c = partenaire.Client.entiteCommercialeDalkia;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_entiteCommercialeDalkiaOB + '\n';
                    resp.error = true;
                }
                if(partenaire.Client.entiteCommercialeEdf != null) {
                    accountToInsert.EntiteCommercialeEDF__c = partenaire.Client.entiteCommercialeEdf;
                }
                if(partenaire.Client.societeMandataire != null) {
                    accountToInsert.Societe_Mandataire__c = partenaire.Client.societeMandataire;
                }
                if(partenaire.Client.listeRecouvrements != null
                   && partenaire.Client.listeRecouvrements.recouvrement != null
                   && partenaire.Client.listeRecouvrements.recouvrement.size() > 0) {
                    String codeValues = '';
                    for(recouvrement rec : partenaire.Client.listeRecouvrements.recouvrement) {
                        if(rec.codeRecouvrement != null && String.isNotBlank(rec.codeRecouvrement)) {
                            codeValues += rec.codeRecouvrement + ';';
                        }
                    }
                    if(codeValues.length() > 1) {
                        codeValues = codeValues.substring(0, codeValues.length() - 1);
                    }
                    accountToInsert.CodeRecouvrement__c = codeValues;
                }

                if(partenaire.Client.conditionsPaiementDefaut != null) {
                    if(partenaire.Client.conditionsPaiementDefaut.departExigibilite != null) {
                        accountToInsert.Depart_Exigibilite__c = partenaire.Client.conditionsPaiementDefaut.departExigibilite;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_departExigibiliteOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours != null) {
                        accountToInsert.DelaiPaiementJour__c = Integer.valueOf(partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours);
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_delaiPaiementJoursOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Client.conditionsPaiementDefaut.reportFinMois != null) {
                        accountToInsert.Report_Fin_Mois__c = partenaire.Client.conditionsPaiementDefaut.reportFinMois;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_reportFinMoisOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant != null) {
                        accountToInsert.JourMoisSuivant__c = Integer.valueOf(partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant);
                    }
                    if(partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard != null) {
                        accountToInsert.Methode_Interet_Retard__c = partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard;
                    } else {
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS02_methodeInteretsRetardOB + '\n';
                        resp.error = true;
                    }
                    if(partenaire.Client.conditionsPaiementDefaut.modeReglement != null) {
                        accountToInsert.Mode_Reglement__c = partenaire.Client.conditionsPaiementDefaut.modeReglement;
                    }
                }
            }
            if(partenaire.fournisseur != null && partenaire.proprietesPartenaire.naturePartenaire == 'ETAB') {
                if(partenaire.fournisseur.utilisationFiliereAchats != null) {
                    accountToInsert.Utilisation_Filiere_Achat__c = partenaire.fournisseur.utilisationFiliereAchats;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_utilisationFiliereAchatsOB + '\n';
                    resp.error = true;
                }
                if(partenaire.fournisseur.societeAffacturage != null) {
                    accountToInsert.Societe_Affacturage__c = partenaire.fournisseur.societeAffacturage;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS02_societeAffacturageOB + '\n';
                    resp.error = true;
                }
                /*
                   if(partenaire.fournisseur.listeClassification.classification != null ){
                   for(classification cla : partenaire.fournisseur.listeClassification.classification){
                   if(cla.perimetreAchat != null){
                   //accountToInsert.?? = cla.perimetreAchat;
                   }
                   else{
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += 'Le champ perimetreAchat est obligatoire \n';
                   resp.error = true;
                   }
                   if(cla.niveauClassificationAchat != null){
                   //accountToInsert.?? = cla.niveauClassificationAchat;
                   }
                   else{
                   resp.responseCode = Label.WS_Response_KO;
                   resp.errorText += 'Le champ niveauClassificationAchat est obligatoire \n';
                   resp.error = true;
                   }
                   }
                   }*/
            }

            if(partenaire.listeAdresses != null && partenaire.listeAdresses.adresse != null) {
                Boolean principal = false;
                String pays = '';
                String creationId = '';
                String updateId = '';
                String validationId = '';
                for(adresse add : partenaire.listeAdresses.adresse) {
                    if(add.adressePrincipale != null && add.adressePrincipale == true) {
                        principal = true;
                        if(String.isNotBlank(add.DKCodeAdresse)) {
                            accountToInsert.DkCodeAdressePrincipale__c = add.DKCodeAdresse;
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS03_DKCodeAdresseOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.statutAdresse)) {
                            accountToInsert.Statut_adresse_1__c = add.statutAdresse;
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS03_statutAdresseOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.precisionDestinataire)) {
                            accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
                        }
                        if(String.isNotBlank(add.precisionIdentificationAdresse)) {
                            accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;
                        }
                        accountToInsert.BillingStreet = '';
                        if(add.numeroVoie != null) {
                            accountToInsert.BillingStreet += add.numeroVoie + ' ';
                        }
                        if(add.typeDeVoie != null) {
                            if(add.typeDeVoie == Label.WS03_Vide) {
                                accountToInsert.BillingStreet = '';
                            } else {
                                accountToInsert.BillingStreet += add.typeDeVoie + ' ';
                            }
                        }
                        if(add.libelleVoie != null && add.libelleVoie != '') {
                            accountToInsert.BillingStreet += add.libelleVoie;
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS03_libelleVoieOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.complementAdresse)) {
                            accountToInsert.ComplementAdresse__c = add.complementAdresse;
                        }
                        if(String.isNotBlank(add.codePostal)) {
                            accountToInsert.BillingPostalCode = add.codePostal;
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS03_codePostalOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.ville)) {
                            accountToInsert.BillingCity = add.ville;
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS03_VilleOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.pays)) {
                            pays = add.pays;
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS03_PaysOB + '\n';
                            resp.error = true;
                        }
                        if(String.isNotBlank(add.telephone)) {
                            accountToInsert.Phone = add.telephone;
                        }
                        if(String.isNotBlank(add.fax)) {
                            accountToInsert.fax = add.fax;
                        }
                        if(String.isNotBlank(add.codeClientOracle)) {
                            accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
                        }
                        if(String.isNotBlank(add.codeFournisseurOracle)) {
                            //accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle;
                        }
                        if(String.isNotBlank(add.referenceAdresseClient)) {
                            accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
                        }
                        if(String.isNotBlank(add.referenceAdresseFournisseur)) {
                            //accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
                        }
                        if(add.dematerialise != null) {
                            accountToInsert.Dematerialise__c = add.dematerialise;
                        }
                        if(add.listeAffacturages != null && add.listeAffacturages.affacturage != null) {
                            //accountToInsert.?? = add.affacturage;
                            for(affacturage aff : add.listeAffacturages.affacturage) {
                                //if(add.affacturage.DKCPartenaireAffacturage != null){
                                //accountToInsert.?? = add.affacturage.DKCPartenaireAffacturage;
                                //}
                                //else{
                                //resp.responseCode = Label.WS_Response_KO;
                                //resp.errorText += 'Le champ DKCPartenaireAffacturage est obligatoire \n';
                                //resp.error = true;
                                //}
                                //if(add.affacturage.DKCAdressePartenaireAffacturage != null){
                                //accountToInsert.?? = add.affacturage.DKCAdressePartenaireAffacturage;
                                //}
                                //else{
                                //resp.responseCode = Label.WS_Response_KO;
                                //resp.errorText += 'Le champ DKCAdressePartenaireAffacturage est obligatoire \n';
                                //resp.error = true;
                                //}
                                //if(add.affacturage.statutLienAffacturage != null){
                                //accountToInsert.?? = add.affacturage.statutLienAffacturage;
                                //}
                                //else{
                                //resp.responseCode = Label.WS_Response_KO;
                                //resp.errorText += 'Le champ statutLienAffacturage est obligatoire \n';
                                //resp.error = true;
                                //}
                            }
                        }
                        if(add.listeMandataires != null && add.listeMandataires.mandataire != null) {
                            //for(mandataire aff : add.mandataire){
                            //if(add.mandataire.DKCPartenaireMandataire != null){
                            //accountToInsert.?? = add.mandataire.DKCPartenaireMandataire;
                            // }
                            // else{
                            //resp.responseCode = Label.WS_Response_KO;
                            //resp.errorText += 'Le champ DKCPartenaireMandataire est obligatoire \n';
                            //resp.error = true;
                            //}
                            // if(add.mandataire.DKCAdressePartenaireMandataire != null){
                            //accountToInsert.?? = add.mandataire.DKCAdressePartenaireMandataire;
                            // }
                            // else{
                            //resp.responseCode = Label.WS_Response_KO;
                            //resp.errorText += 'Le champ DKCAdressePartenaireMandataire est obligatoire \n';
                            //resp.error = true;
                            //}
                            // if(add.mandataire.statutLienMandataire != null){
                            //accountToInsert.?? = add.mandataire.statutLienMandataire;
                            // }
                            // else{
                            //resp.responseCode = Label.WS_Response_KO;
                            //resp.errorText += 'Le champ statutLienMandataire est obligatoire \n';
                            //resp.error = true;
                            // }
                            // }
                        }
                        if(add.metadonneesAdressePartenaire != null) {
                            for(metadonneesAdressePartenaire meta : add.metadonneesAdressePartenaire) {
                                if(meta.creationDate != null) {
                                    accountToInsert.AdresseCreationDate__c = meta.creationDate;

                                    meta.creationDate = meta.creationDate.addSeconds(tz.getOffset(meta.creationDate) / 1000);
                                    ws.Request__c = partenaire + '';
                                } else {
                                    resp.responseCode = Label.WS_Response_KO;
                                    resp.errorText += Label.WS06_creationDateOB + '\n';
                                    resp.error = true;
                                }
                                if(String.isNotBlank(meta.creationId)) {
                                    creationId = meta.creationId;
                                } else {
                                    resp.responseCode = Label.WS_Response_KO;
                                    resp.errorText += Label.WS06_creationId + '\n';
                                    resp.error = true;
                                }
                                if(meta.updateDate != null) {
                                    accountToInsert.AdresseUpdateDate__c = meta.updateDate;

                                    meta.updateDate = meta.updateDate.addSeconds(tz.getOffset(meta.updateDate) / 1000);
                                    ws.Request__c = partenaire + '';
                                }
                                if(String.isNotBlank(meta.updateId)) {
                                    updateId = meta.updateId;
                                }
                                if(meta.validationDate != null) {
                                    accountToInsert.AdresseValidationDate__c = meta.validationDate;
                                }
                                if(String.isNotBlank(meta.validationId)) {
                                    validationId = meta.validationId;
                                }
                            }
                        } else {
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += 'Le champ metadonneesAdressePartenaire est obligatoire' + '\n';
                            resp.error = true;
                        }
                    }
                }
                if(principal == false) {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS03_adressePrincipaleOB + '\n';
                    resp.error = true;
                }
                if(principal == true) {
                    List<Pays__c> paysList = new List<Pays__c>();
                    if(pays != '') {
                        paysList = [SELECT id, Abreviation__c, Nom__c from Pays__c where Abreviation__c = :pays];
                    }
                    if(paysList != null && paysList.size() > 0) {
                        accountToInsert.BillingCountry = paysList[0].Nom__c;
                    } else {
                        accountToInsert.BillingCountry = pays;
                    }
                }
                List<User> userMetadonne = new List<User>();
                userMetadonne = [SELECT id, name, ReferentielId__c
                                 FROM user
                                 WHERE ReferentielId__c = : creationId
                                 OR ReferentielId__c = : updateId
                                 OR ReferentielId__c = : validationId];
                if(creationId != '') {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == creationId) {
                            accountToInsert.AdresseCreationID__c  = userLoop.id;
                        }
                    }
                }
                if(updateId != '') {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == updateId) {
                            accountToInsert.AdresseUpdateID__c  = userLoop.id;
                        }
                    }
                }
                if(validationId != '') {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == validationId) {
                            accountToInsert.AdresseValidationID__c     = userLoop.id;
                        }
                    }
                }
            }

            //03/01/2023, Modified by Jimmy, US C360-266 nouvelles conditions pour la MAJ du proprietaire
            //Si le partenaire existe dans C360 (dkCode Existe), pas d'action
            if(dkCodeExiste == false) {
                String resp01 = '';
                List<User> userRole01 = new List<User>();
                if(partenaire.listeResponsables != null && partenaire.listeResponsables.responsable != null) {
                    for(responsable responsab : partenaire.listeResponsables.responsable) {
                        if(responsab.perimetreResponsable == Label.WS02_ROL01) {
                            resp01 = responsab.responsableCompte;
                        }
                    }
                }
                if(resp01 != '') {
                    userRole01 = [SELECT id, name, DkCode__c
                                  FROM User
                                  WHERE DkCode__c = : resp01 and isActive = true];
                }
                if(userRole01 != null && userRole01.size() > 0) {
                    //le responsable transmis par Kador et existe dans C360 -> le mettre en propriétaire
                    accountToInsert.OwnerId = userRole01[0].id;
                } else {
                    //le responsable n'est pas transmis par Kador ou n'existe pas dans C360 ou inactif -> mettre VALERIE POUPARD en propriétaire
                    accountToInsert.OwnerId = Label.WS02_IdDefautOwner;
                }

            }

            if(partenaire.listeImmatriculationsAnterieures != null && partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures != null) {
                //if(partenaire.immatriculationsAnterieures.ImmatriculationAnterieure != null){
                //accountToInsert.?? = partenaire.immatriculationsAnterieures.ImmatriculationAnterieure;
                //}
                //else{
                //resp.responseCode = Label.WS_Response_KO;
                //resp.errorText += 'Le champ ImmatriculationAnterieure est obligatoire \n';
                //resp.error = true;
                //}
                //if(partenaire.immatriculationsAnterieures.dateFinImmatriculation != null){
                //accountToInsert.?? = partenaire.immatriculationsAnterieures.dateFinImmatriculation;
                //}
                //else{
                //resp.responseCode = Label.WS_Response_KO;
                //resp.errorText += 'Le champ dateFinImmatriculation est obligatoire \n';
                //resp.error = true;
                //}
            }

            if(partenaire.metadonnees != null) {
                if(partenaire.metadonnees.creationDate != null) {
                    accountToInsert.CreateDate__c = partenaire.metadonnees.creationDate;
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS06_creationDateOB + '\n';
                    resp.error = true;
                }
                List<User> userMetadonne = new List<User>();
                userMetadonne = [SELECT id, name, ReferentielId__c
                                 FROM user
                                 WHERE ReferentielId__c = : partenaire.Metadonnees.creationId
                                 OR ReferentielId__c = : partenaire.Metadonnees.updateId
                                 OR ReferentielId__c = : partenaire.Metadonnees.validationId];
                if(partenaire.metadonnees.creationId != null) {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == partenaire.Metadonnees.creationId) {
                            accountToInsert.CreateId__c  = userLoop.id;
                        }
                    }
                } else {
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS06_creationId + '\n';
                    resp.error = true;
                }
                if(partenaire.metadonnees.updateDate != null) {
                    accountToInsert.UpdateDate__c = partenaire.metadonnees.updateDate;

                    partenaire.metadonnees.updateDate = partenaire.metadonnees.updateDate.addSeconds(tz.getOffset(partenaire.metadonnees.updateDate) / 1000);
                    ws.Request__c = partenaire + '';
                }
                if(partenaire.metadonnees.updateId != null) {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == partenaire.Metadonnees.updateId) {
                            accountToInsert.UpdateId__c  = userLoop.id;
                        }
                    }
                }
                if(partenaire.metadonnees.validationDate != null) {
                    accountToInsert.ValidationDate__c = partenaire.metadonnees.validationDate;
                }
                if(partenaire.metadonnees.validationId != null) {
                    for(User userLoop : userMetadonne) {
                        if(userLoop.ReferentielId__c == partenaire.Metadonnees.ValidationId) {
                            accountToInsert.ValidationId__c  = userLoop.id;
                        }
                    }
                }
            } else {
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS02_MetadonneeOB + '\n';
                resp.error = true;
            }
        }
        ws.Response__c = resp + '';
        if(resp.error == true) {
            ws.Statut__c = 'KO';
            ws.ErrorText__c = resp.errorText;
            if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
            }
        } else {
            ws.Statut__c = 'OK';
        }
        upsert ws;
        if(!dkCodeExiste && accountToInsert.RecordTypeId == personAccountRT) {
            //new person account is not allowed by this WS
            resp.error = false;
            resp.responseCode = Label.WS_Response_OK;
            resp.errorText = Label.WS02_ParticulierOK + '\n';
            ws.Response__c = resp + '';
            ws.Statut__c = 'OK';
            update ws;

            return resp;
        }
        if(!resp.error) {
            try {
                PAD.PAD_BypassTrigger += ';AP59_PostalCodeUOPilote;';
                upsert accountToInsert DKCodeSurPartenaire__c;
            }
            catch(Exception e) {
                ws.Statut__c = 'KO';
                ws.ErrorText__c = e.getMessage();
                if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                    ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
                }
                resp.error = true;
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS02_Error + e.getMessage() + '\n';
                System.debug('insertUpdatePartenaire error ' + e.getMessage());
                ws.Response__c = resp + Label.WS02_AfterError + e.getMessage();
                update ws;
            }
        }

        return resp;
    }
}