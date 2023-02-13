/**
 *@author Alain Ghoussoub
 *@date 18/02/2020
 *@description List of functions thap map salesforce fields to WS fields - Partenaire
 */
public class Partenaire_Mapper {
    public static wwwDalkiaFrReferentielPartenaire.creerPartenaireRequete fillCreerPartenaireRequete(Account acc){
        wwwDalkiaFrReferentielPartenaire.creerPartenaireRequete retVal = new wwwDalkiaFrReferentielPartenaire.creerPartenaireRequete();
        retVal.partenaire = new wwwDalkiaFrReferentielPartenaire.partenairePA1();
        //remove etablissement car creerPartenaire est pour particulier seulement
        retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'etablissement');
        retVal.partenaire.proprietesPartenaire = new wwwDalkiaFrReferentielPartenaire.proprietesPartenairePA1();
        retVal.partenaire.proprietesPartenaire.commentaire = acc.Commentaire__c;
        //particulier
        retVal.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulierPA1();
        retVal.partenaire.particulier.civilite = acc.Salutation;
        retVal.partenaire.particulier.nomUsage = acc.LastName;
        retVal.partenaire.particulier.prenomUsage = acc.FirstName;
        retVal.partenaire.particulier.dateDeNaissance = acc.PersonBirthdate;
        retVal.partenaire.particulier.lieuDeNaissance = acc.tech_lieu_particulier__c;
        retVal.partenaire.particulier.paysDeNaissance = acc.tech_pays_particulier__c;
        retVal.partenaire.particulier.statutParticulier = acc.statutPartenaire__c;
        retVal.partenaire.Client = new wwwDalkiaFrReferentielPartenaire.clientPA1();
        Boolean utilisationFiliereCommerceBool = false;
        if(String.isNotBlank(acc.Utilisation_filiere_Commerce__c) && acc.Utilisation_filiere_Commerce__c.equals('Actif')) {
            utilisationFiliereCommerceBool = true;
        }

        retVal.partenaire.Client.utilisationFiliereCommerce = utilisationFiliereCommerceBool; //string to boolean
        retVal.partenaire.Client.segmentClient = acc.Segment_client__c;
        retVal.partenaire.Client.sousSegmentClient = acc.Sous_segment_client__c;
        retVal.partenaire.Client.entiteCommercialeDalkia = acc.EntiteCommercialeDalkia__c;
        retVal.partenaire.Client.entiteCommercialeEdf = acc.EntiteCommercialeEDF__c;
        retVal.partenaire.Client.societeMandataire = acc.Societe_Mandataire__c;
        retVal.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrementsPA1();
        retVal.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrementPA1>();
        //retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info,'client');
        if(acc.CodeRecouvrement__c != null) {
            List<String> codeRecList = acc.CodeRecouvrement__c.split(';');
            for(String strLoop : codeRecList) {
                wwwDalkiaFrReferentielPartenaire.recouvrementPA1 rec = new wwwDalkiaFrReferentielPartenaire.recouvrementPA1();
                rec.codeRecouvrement = strLoop;
                retVal.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
            }
        }
        retVal.partenaire.client.field_order_type_info = removeListValue(retVal.partenaire.client.field_order_type_info, 'listeRecouvrements');
        // CG Updated 29/03/19
        if(String.isNotBlank(acc.Depart_Exigibilite__c) &&
           acc.DelaiPaiementJour__c != null &&
           String.isNotBlank(acc.Methode_Interet_Retard__c)) {
            retVal.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautPA1();
            retVal.partenaire.client.conditionsPaiementDefaut.departExigibilite = acc.Depart_Exigibilite__c;
            if(acc.DelaiPaiementJour__c != null) {
                retVal.partenaire.client.conditionsPaiementDefaut.delaiPaiementJours = Integer.valueOf(acc.DelaiPaiementJour__c);
            }

            retVal.partenaire.client.conditionsPaiementDefaut.reportFinMois = acc.Report_Fin_Mois__c;
            if(acc.JourMoisSuivant__c != null) {
                retVal.partenaire.client.conditionsPaiementDefaut.jourMoisSuivant = Integer.valueOf(acc.JourMoisSuivant__c);
            }
            retVal.partenaire.client.conditionsPaiementDefaut.methodeInteretsRetard = acc.Methode_Interet_Retard__c;
            retVal.partenaire.client.conditionsPaiementDefaut.modeReglement = acc.Mode_Reglement__c;
        } else {
            retVal.partenaire.client.field_order_type_info = removeListValue(retVal.partenaire.client.field_order_type_info, 'conditionsPaiementDefaut');
        }

        retVal.partenaire.client.field_order_type_info = removeListValue(retVal.partenaire.client.field_order_type_info, 'fournisseur');
        /*retVal.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseurPA1();
           retVal.partenaire.fournisseur.utilisationFiliereAchats = acc.Utilisation_Filiere_Achat__c;
           retVal.partenaire.fournisseur.societeAffacturage = acc.Societe_Affacturage__c;
           retVal.partenaire.fournisseur.listeClassification =  new wwwDalkiaFrReferentielPartenaire.listeClassificationPA1();
           retVal.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classificationPA1>();
           wwwDalkiaFrReferentielPartenaire.classificationPA1 classification = new wwwDalkiaFrReferentielPartenaire.classificationPA1();
           classification.perimetreAchat = acc.Perimetre_Achat__c;
           classification.niveauClassificationAchat = acc.Niveau_Classification_Achat__c;
           retVal.partenaire.fournisseur.listeClassification.classification.add(classification);*/
        retVal.partenaire.adresse = new wwwDalkiaFrReferentielPartenaire.adressePA1();

        retVal.partenaire.adresse.DKCodeAdresse = acc.DkCodeAdressePrincipale__c;
        retVal.partenaire.adresse.adressePrincipale = true;
        //retVal.partenaire.adresse.statutAdresse = acc.Statut_adresse_1__c;
        retVal.partenaire.adresse.statutAdresse = 'ACTIF';
        retVal.partenaire.adresse.precisionDestinataire = acc.PrecisionDestinataire__c;
        retVal.partenaire.adresse.precisionIdentificationAdresse = acc.PrecisionIdentificationAdresse__c;

        List<String> lstBilling = getBillingAddressFields(acc.BillingStreet);
        retVal.partenaire.adresse.numeroVoie = lstBilling[0];
        retVal.partenaire.adresse.typeDeVoie = lstBilling[1];
        retVal.partenaire.adresse.libelleVoie = lstBilling[2];

        retVal.partenaire.adresse.complementAdresse = acc.ComplementAdresse__c;
        retVal.partenaire.adresse.codePostal = acc.BillingPostalCode;
        String billingCountry = acc.BillingCountry;
        if(billingCountry != null && billingCountry.length() > 0) {
            //enlever les accents pour selectionner le pays du custom setting
            billingCountry = Accents_Utils.removeDiacritics(billingCountry);
            List<Pays__c> Pays = [SELECT id, Abreviation__c, Nom__c from Pays__c where nom__c = :billingCountry];
            if(Pays != null && Pays.size() > 0) {
                retVal.partenaire.adresse.pays = Pays[0].Abreviation__c;
            }
        }
        retVal.partenaire.adresse.ville = acc.BillingCity;
        retVal.partenaire.adresse.telephone = acc.Phone;
        retVal.partenaire.adresse.fax = acc.fax;
        retVal.partenaire.adresse.codeClientOracle = acc.Code_Client_Oracle__c;
        retVal.partenaire.adresse.codeFournisseurOracle = acc.Numero_fournisseur_DK_client__c;
        retVal.partenaire.adresse.referenceAdresseClient = acc.Reference_adresse__c;
        retVal.partenaire.adresse.referenceAdresseFournisseur = acc.Reference_adresse_2__c;
        retVal.partenaire.adresse.dematerialise = acc.Dematerialise__c;
        /*
           retVal.partenaire.adresse.listeAffacturages = new wwwDalkiaFrReferentielPartenaire.listeAffacturagesPA1();
           retVal.partenaire.adresse.listeAffacturages.affacturage = new List<wwwDalkiaFrReferentielPartenaire.affacturagePA1>();
           wwwDalkiaFrReferentielPartenaire.affacturagePA1 aff =  new wwwDalkiaFrReferentielPartenaire.affacturagePA1();
           //aff.DKCPartenaireAffacturage=''; ce champ n'est pas à mapper
           //aff.DKCAdressePartenaireAffacturage=''; ce champ n'est pas à mapper
           //aff.statutLienAffacturage=''; ce champ n'est pas à mapper
           //retVal.partenaire.adresse.listeAffacturages.affacturage.add(aff);*/
        retVal.partenaire.adresse.field_order_type_info = removeListValue(retVal.partenaire.adresse.field_order_type_info, 'listeMandatairesPA1');
        retVal.partenaire.adresse.field_order_type_info = removeListValue(retVal.partenaire.adresse.field_order_type_info, 'listeAffacturages');
        /*
           retVal.partenaire.adresse.listeMandatairesPA1 = new wwwDalkiaFrReferentielPartenaire.listeMandatairesPA1();
           retVal.partenaire.adresse.listeMandatairesPA1.mandataire = new List<wwwDalkiaFrReferentielPartenaire.madatairePA1>();
           wwwDalkiaFrReferentielPartenaire.madatairePA1 mand = new wwwDalkiaFrReferentielPartenaire.madatairePA1();
           mand.DKCPartenaireMandataire = acc.DKC_Partenaire_Mandataire__c;
           mand.DKCAdressePartenaireMandataire = acc.DKC_Adresse_Partenaire_Mandataire__c;
           mand.statutLienMandataire = acc.Statut_Lien_Mandataire__c;
           retVal.partenaire.adresse.listeMandatairesPA1.mandataire.add(mand);
         */
        retVal.partenaire.adresse.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonneesPA1();
        retVal.partenaire.adresse.metadonneesAdressePartenaire.creationDate = acc.CreatedDate;
        retVal.partenaire.adresse.metadonneesAdressePartenaire.creationId = label.userc360;
        retVal.partenaire.adresse.metadonneesAdressePartenaire.updateDate = acc.LastModifiedDate;
        retVal.partenaire.adresse.metadonneesAdressePartenaire.updateId = label.userc360;
        retVal.partenaire.adresse.metadonneesAdressePartenaire.validationDate = acc.AdresseValidationDate__c;

        List<User> usr3 = [ select id, name, ReferentielId__c from user where id = :acc.AdresseValidationID__c limit 1];
        if(usr3 != null && usr3.size() > 0) {
            retVal.partenaire.adresse.metadonneesAdressePartenaire.validationId = usr3[0].ReferentielId__c;
        }

        retVal.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsablesPA1();
        retVal.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsablePA1>();

        List<User> listRespPart = [SELECT id, DkCode__c
                                   FROM User
                                   WHERE id = :UserInfo.getUserId()];

        for(User respLoop : listRespPart) {
            wwwDalkiaFrReferentielPartenaire.responsablePA1 resp = new wwwDalkiaFrReferentielPartenaire.responsablePA1();
            resp.responsableCompte = respLoop.DkCode__c;
            resp.perimetreResponsable = 'ROL01';
            resp.statutLienResponsable = true;
            retVal.partenaire.listeResponsables.responsable.add(resp);
        }

        if(retVal.partenaire.listeResponsables.responsable.size() == 0) {
            retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'listeResponsables');
        }
        retVal.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonneesPA1();
        retVal.partenaire.metadonnees.creationDate = acc.CreatedDate;
        if(acc.CreatedById != null) {
            retVal.partenaire.metadonnees.creationId = label.userC360;
        }
        retVal.partenaire.metadonnees.updateDate = acc.LastModifiedDate;
        if(acc.LastModifiedById != null) {
            retVal.partenaire.metadonnees.updateId = label.userC360;
        }
        retVal.partenaire.metadonnees.validationDate = acc.ValidationDate__c;
        if(acc.ValidationId__c != null) {
            List<User> usr = [ select id, name, ReferentielId__c from user where id = :acc.ValidationId__c limit 1];
            if(usr != null && usr.size() > 0) {
                retVal.partenaire.metadonnees.validationId = usr[0].ReferentielId__c;
            }
        }

        return retVal;
    }

    public static Account getCreerPartenaireRequete(wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse retVal, Account accountToInsert){

        if(retval.informationsRetour != null) {
            if(retVal.informationsRetour.codeRetour != null) {
                String code = retVal.informationsRetour.codeRetour;
            }
        }
        if(retVal.partenaire != null) {
            if(retVal.partenaire.proprietesPartenaire != null) {
                accountToInsert.DKCodeSurPartenaire__c = retVal.partenaire.proprietesPartenaire.DKCodePartenaire;
                accountToInsert.StatutPartenaire__c = retVal.partenaire.proprietesPartenaire.statutPartenaire;
                accountToInsert.Commentaire__c = retVal.partenaire.proprietesPartenaire.commentaire;
                accountToInsert.NaturePartenaire__c = retVal.partenaire.proprietesPartenaire.naturePartenaire;

                DateTime dateDerniereMAJSireneOriginal = retVal.partenaire.proprietesPartenaire.dateDerniereMajSiren;
                if(dateDerniereMAJSireneOriginal != null) {
                    Date dateDerniereMAJSireneConverted = date.newinstance(dateDerniereMAJSireneOriginal.year(), dateDerniereMAJSireneOriginal.month(), dateDerniereMAJSireneOriginal.day());
                    accountToInsert.DateDerniereMajSirene__c = dateDerniereMAJSireneConverted;
                }
            }
            if(retVal.partenaire.particulier != null) {
                accountToInsert.Salutation = retVal.partenaire.particulier.civilite;
                accountToInsert.LastName = retVal.partenaire.particulier.nomUsage;
                accountToInsert.FirstName = retVal.partenaire.particulier.prenomUsage;

                DateTime dateDeNaissanceOriginal = retVal.partenaire.particulier.dateDeNaissance;
                if(dateDeNaissanceOriginal != null) {
                    Date dateDeNaissanceConverted = date.newinstance(dateDeNaissanceOriginal.year(), dateDeNaissanceOriginal.month(), dateDeNaissanceOriginal.day());
                    accountToInsert.PersonBirthdate = dateDeNaissanceConverted;
                }
                accountToInsert.tech_lieu_particulier__c = retVal.partenaire.particulier.lieuDeNaissance;
                accountToInsert.tech_pays_particulier__c = retVal.partenaire.particulier.paysDeNaissance;
                accountToInsert.tech_statut_particulier__c = retVal.partenaire.particulier.statutParticulier;
            }
            if(retVal.partenaire.etablissement != null) {
                accountToInsert.Type_immatriculation__c = retVal.partenaire.Etablissement.typeImmatriculation;
                accountToInsert.SIRET__c = retVal.partenaire.Etablissement.immatriculationLegale;
                accountToInsert.LibelleEtablissement__c = retVal.partenaire.Etablissement.libelleEtablissement;
                accountToInsert.Sigle__c = retVal.partenaire.Etablissement.denominationCommerciale;
                accountToInsert.Site = retVal.partenaire.Etablissement.complementLibelle;
                accountToInsert.TypeIdentificationExterne__c = retVal.partenaire.Etablissement.typeIdentificationExterne;
                accountToInsert.Identification_externe__c = retVal.partenaire.Etablissement.identificationExterne;
                accountToInsert.tech_nom_naissance__c = retVal.partenaire.Etablissement.nomNaissance;
                accountToInsert.tech_nom_usage__c = retVal.partenaire.Etablissement.nomUsage;
                accountToInsert.tech_prenom__c = retVal.partenaire.Etablissement.PRENOMS;
                accountToInsert.Siege_social_partenaire__c = retVal.partenaire.Etablissement.siegeSocialPartenaire;

                if(String.isNotBlank(retVal.partenaire.Etablissement.effectifSalarie)) {
                    accountToInsert.effectif__c  = retVal.partenaire.Etablissement.effectifSalarie;
                }

                DateTime DatedebutOriginal = retVal.partenaire.Etablissement.dateDebut;
                if(DatedebutOriginal != null) {
                    Date DatedebutConverted = date.newinstance(DatedebutOriginal.year(), DatedebutOriginal.month(), DatedebutOriginal.day());
                    accountToInsert.Datedebut__c = DatedebutConverted;
                }
                DateTime DatefinOriginal = retVal.partenaire.Etablissement.dateFin;
                if(DatefinOriginal != null) {
                    Date DatefinConverted = date.newinstance(DatefinOriginal.year(), DatefinOriginal.month(), DatefinOriginal.day());
                    accountToInsert.Datefin__c = DatefinConverted;
                }
                //accountToInsert?? = retVal.partenaire.Etablissement.statutEtablissement; //Ne pas utiliser
                List<CentreFinance__c> centre = [Select id, DkCode__c from CentreFinance__c where DkCode__c = : retVal.partenaire.Etablissement.UODalkiaPilote];
                if(centre != null && centre.size() > 0) {
                    accountToInsert.UODalkiaPilote__c = centre[0].Id;
                }
                accountToInsert.Code_NAF__c = retVal.partenaire.Etablissement.codeActiviteLocal;

                if(String.isNotBlank(retVal.partenaire.Etablissement.codeActiviteInternational) && retVal.partenaire.Etablissement.codeActiviteInternational.isNumeric() ) {
                    accountToInsert.Code_NACE__c = retVal.partenaire.Etablissement.codeActiviteInternational;
                }

                if(retVal.partenaire.Etablissement.societe != null && String.isNotBlank(retVal.partenaire.Etablissement.societe.DKCodeSociete)) {
                    accountToInsert.DkCodeSociete__c = retVal.partenaire.Etablissement.societe.DKCodeSociete;
                    List<Account> acc = new List<Account>();
                    acc = [select id, Categorie_partenaire__c from account where DKCodeSurPartenaire__c = : retVal.partenaire.Etablissement.societe.DKCodeSociete];
                    if(acc != null && acc.size() > 0) {
                        accountToInsert.parentid  = acc[0].id;
                        accountToInsert.Categorie_partenaire__c = acc[0].Categorie_partenaire__c;
                    } else {
                        accountToInsert.parentid  = null;
                    }
                } else {
                    accountToInsert.parentid  = null;
                }
                if(retVal.partenaire.Etablissement.chorus != null) {
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.EJObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEOuEJObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEParDefaut;on ne récupère pas , a supprimer
                }
            }
            if(retVal.partenaire.client != null) {
                accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
                if(retVal.partenaire.client.utilisationFiliereCommerce != null && retVal.partenaire.client.utilisationFiliereCommerce == true) {
                    accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
                }
                accountToInsert.Segment_client__c = retVal.partenaire.Client.segmentClient;
                accountToInsert.Sous_segment_client__c = retVal.partenaire.Client.sousSegmentClient;
                accountToInsert.EntiteCommercialeDalkia__c = retVal.partenaire.Client.entiteCommercialeDalkia;
                accountToInsert.EntiteCommercialeEDF__c = retVal.partenaire.Client.entiteCommercialeEdf;
                accountToInsert.Societe_Mandataire__c = false;
                if(retVal.partenaire.Client.societeMandataire != null) {
                    accountToInsert.Societe_Mandataire__c = retVal.partenaire.Client.societeMandataire;
                }
                if(retVal.partenaire.Client.listeRecouvrements != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement.size() > 0) {
                    String codeValues = '';
                    for(wwwDalkiaFrReferentielPartenaire.recouvrement rec : retVal.partenaire.Client.listeRecouvrements.recouvrement) {
                        if(rec.codeRecouvrement != null && String.isNotBlank(rec.codeRecouvrement)) {
                            codeValues += rec.codeRecouvrement + ';';
                        }
                    }
                    if(codeValues.length() > 1) {
                        codeValues = codeValues.substring(0, codeValues.length() - 1);
                    }
                    accountToInsert.CodeRecouvrement__c = codeValues;
                }
                if(retVal.partenaire.Client.conditionsPaiementDefaut != null) {
                    accountToInsert.Depart_Exigibilite__c = retVal.partenaire.Client.conditionsPaiementDefaut.departExigibilite;
                    accountToInsert.DelaiPaiementJour__c = retVal.partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours;
                    accountToInsert.Report_Fin_Mois__c = retVal.partenaire.Client.conditionsPaiementDefaut.reportFinMois;
                    accountToInsert.JourMoisSuivant__c = retVal.partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant;
                    accountToInsert.Methode_Interet_Retard__c = retVal.partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard;
                    accountToInsert.Mode_Reglement__c = retVal.partenaire.Client.conditionsPaiementDefaut.modeReglement;
                }
            }
            if(retVal.partenaire.fournisseur != null) {
                accountToInsert.Utilisation_Filiere_Achat__c = retVal.partenaire.fournisseur.utilisationFiliereAchats;
                accountToInsert.Societe_Affacturage__c = retVal.partenaire.fournisseur.societeAffacturage;
                if(retVal.partenaire.fournisseur.listeClassification != null && retVal.partenaire.fournisseur.listeClassification.classification.size() > 0) {
                    accountToInsert.Perimetre_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).perimetreAchat;
                    accountToInsert.Niveau_Classification_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).niveauClassificationAchat;
                }
            }
            //address
            if(retVal.partenaire.listeAdresses != null && retVal.partenaire.listeAdresses.adresse != null) {
                set<String> addresseIds = new Set<String>();

                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    addresseIds.add(add.metadonneesAdressePartenaire.creationId);
                    addresseIds.add(add.metadonneesAdressePartenaire.updateId);
                    addresseIds.add(add.metadonneesAdressePartenaire.validationId);
                }
                List<User> userAdd = new List<User>();
                userAdd = [Select id, name, ReferentielId__c from user where ReferentielId__c in:addresseIds];
                String pays = '';
                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    if(add.adressePrincipale != null && add.adressePrincipale == true) {
                        accountToInsert.DkCodeAdressePrincipale__c = add.DKCodeAdresse;
                        accountToInsert.Statut_adresse_1__c = add.statutAdresse;
                        accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
                        accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;
                        accountToInsert.BillingStreet = '';
                        if(add.numeroVoie != null) {
                            accountToInsert.BillingStreet += add.numeroVoie + ' ';
                        }
                        if(add.typeDeVoie != null) {
                            if(add.typeDeVoie == 'VIDE') {
                                accountToInsert.BillingStreet = '';
                            } else {
                                accountToInsert.BillingStreet += add.typeDeVoie + ' ';
                            }
                        }
                        if(String.isNotBlank(add.libelleVoie) || add.libelleVoie == ' ') {
                            accountToInsert.BillingStreet += add.libelleVoie;
                        }
                        accountToInsert.ComplementAdresse__c = add.complementAdresse;
                        accountToInsert.BillingPostalCode = add.codePostal;
                        accountToInsert.BillingCity = add.ville;
                        //accountToInsert.BillingCountry = add.pays;
                        pays = add.pays;
                        accountToInsert.Phone = add.telephone;
                        accountToInsert.fax = add.fax;
                        accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
                        //accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle; //on ne récupère pas (info fournisseur)
                        accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
                        ///accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
                        if(add.dematerialise != null) {
                            accountToInsert.Dematerialise__c = add.dematerialise;
                        }
                        //affacturage (champs en rouge, a verifier)
                        if(add.listeMandataires != null && add.listeMandataires.mandataire.size() > 0) {
                            //accountToInsert.DKC_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCPartenaireMandataire;
                            //accountToInsert.DKC_Adresse_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCAdressePartenaireMandataire;
                            //accountToInsert.Statut_Lien_Mandataire__c = add.listeMandataires.mandataire.get(0).statutLienMandataire;
                        }
                        if(add.metadonneesAdressePartenaire != null) {
                            for(User userLoop : userAdd) {
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.creationId) {
                                    accountToInsert.AdresseCreationID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.updateId) {
                                    accountToInsert.AdresseUpdateID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.validationId) {
                                    accountToInsert.AdresseValidationID__c = userLoop.id;
                                }
                            }
                            accountToInsert.AdresseCreationDate__c = add.metadonneesAdressePartenaire.creationDate;
                            accountToInsert.AdresseUpdateDate__c = add.metadonneesAdressePartenaire.updateDate;
                            accountToInsert.AdresseValidationDate__c = add.metadonneesAdressePartenaire.validationDate;

                        }
                    }
                }
                List<Pays__c> paysList = [SELECT id, Abreviation__c, Nom__c from Pays__c where Abreviation__c = :pays];
                if(paysList != null && paysList.size() > 0) {
                    accountToInsert.BillingCountry = paysList[0].Nom__c;
                } else {
                    accountToInsert.BillingCountry = pays;
                }
            }
            //immatriculation
            if(retVal.partenaire.listeImmatriculationsAnterieures != null && retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.size() > 0) {
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).ImmatriculationAnterieure;
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).dateFinImmatriculation;
            }
            //metadonnes
            if(retVal.partenaire.metadonnees != null) {
                accountToInsert.CreateDate__c = retVal.partenaire.metadonnees.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.creationId limit 1];
                if(usr1 != null && usr1.size() > 0) {
                    accountToInsert.CreateId__c = usr1[0].Id;
                }
                accountToInsert.UpdateDate__c = retVal.partenaire.metadonnees.updateDate;
                List<User> usr2 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.updateId limit 1];
                if(usr2 != null && usr2.size() > 0) {
                    accountToInsert.UpdateId__c = usr2[0].Id;
                }

                accountToInsert.ValidationDate__c = retVal.partenaire.metadonnees.validationDate;
                List<User> usr3 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.validationId limit 1];
                if(usr3 != null && usr3.size() > 0 && String.isNotBlank(usr3[0].ReferentielId__c)) {
                    accountToInsert.ValidationId__c = usr3[0].Id;
                }
            }
        }

        return accountToInsert;
    }

    /* public static wwwDalkiaFrReferentielPartenaire.rechercherPartenaireRequete fillRechercherPartenaireRequete(Account acc){
       wwwDalkiaFrReferentielPartenaire.rechercherPartenaireRequete retVal = new wwwDalkiaFrReferentielPartenaire.rechercherPartenaireRequete();
       retval.dateDerniereMAJSirene = acc.DateDerniereMajSirene__c;
       retval.nomUsage = acc.LastName;
       retval.prenomUsage = acc.FirstName;
       retval.immatriculationLegale = acc.SIRET__c;
       retval.libelleEtablissement = acc.LibelleEtablissement__c;
       retval.complementLibelle = acc.Site;
       retval.identificationExterne = acc.Identification_externe__c;
       return retVal;
       } */

    /* public static Account getRechercherPartenaireRequete(wwwDalkiaFrReferentielPartenaire.rechercherPartenaireReponse retVal){
       Account accountToInsert = new Account();
       String code = retVal.informationsRetour.codeRetour;
       for(wwwDalkiaFrReferentielPartenaire.partenaireRecherche ref : retVal.listePartenaires.partenaire){
       accountToInsert.DKCodeSurPartenaire__c = ref.DKCodePartenaire;
       //convert dateDerniereMAJSirene from dateTime to date
       DateTime dateDerniereMAJSireneOriginal = ref.dateDerniereMAJSirene;
       Date dateDerniereMAJSireneConverted = date.newinstance(dateDerniereMAJSireneOriginal.year(), dateDerniereMAJSireneOriginal.month(), dateDerniereMAJSireneOriginal.day());
       accountToInsert.DateDerniereMajSirene__c = dateDerniereMAJSireneConverted;
       accountToInsert.LastName = ref.nomUsage;
       accountToInsert.FirstName = ref.prenomUsage;
       accountToInsert.SIRET__c = ref.immatriculationLegale;
       accountToInsert.LibelleEtablissement__c = ref.libelleEtablissement;
       accountToInsert.site = ref.complementLibelle;
       accountToInsert.Identification_externe__c = ref.identificationExterne;
       }
       return accountToInsert;
       }*/

    public static wwwDalkiaFrReferentielPartenaire.consulterPartenaireRequete fillConsulterPartenaireRequete(Account acc){
        wwwDalkiaFrReferentielPartenaire.consulterPartenaireRequete retVal = new wwwDalkiaFrReferentielPartenaire.consulterPartenaireRequete();
        //retVal.DKCodePartenaire = 'K00000077L';
        retVal.DKCodePartenaire = acc.DKCodeSurPartenaire__c;

        return retVal;
    }

    public static Account getConsulterPartenaireRequete(wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse retVal){
        Account accountToInsert = new Account();
        if(retval.informationsRetour != null) {
            if(retVal.informationsRetour.codeRetour != null) {
                String code = retVal.informationsRetour.codeRetour;
            }
        }
        if(retVal.partenaire != null) {
            if(retVal.partenaire.proprietesPartenaire != null) {
                accountToInsert.DKCodeSurPartenaire__c = retVal.partenaire.proprietesPartenaire.DKCodePartenaire;
                accountToInsert.StatutPartenaire__c = retVal.partenaire.proprietesPartenaire.statutPartenaire;
                accountToInsert.Commentaire__c = retVal.partenaire.proprietesPartenaire.commentaire;
                accountToInsert.NaturePartenaire__c = retVal.partenaire.proprietesPartenaire.naturePartenaire;

                DateTime dateDerniereMAJSireneOriginal = retVal.partenaire.proprietesPartenaire.dateDerniereMajSiren;
                if(dateDerniereMAJSireneOriginal != null) {
                    Date dateDerniereMAJSireneConverted = date.newinstance(dateDerniereMAJSireneOriginal.year(), dateDerniereMAJSireneOriginal.month(), dateDerniereMAJSireneOriginal.day());
                    accountToInsert.DateDerniereMajSirene__c = dateDerniereMAJSireneConverted;
                }
            }
            if(retVal.partenaire.particulier != null) {
                accountToInsert.Salutation = retVal.partenaire.particulier.civilite;
                accountToInsert.LastName = retVal.partenaire.particulier.nomUsage;
                accountToInsert.FirstName = retVal.partenaire.particulier.prenomUsage;

                DateTime dateDeNaissanceOriginal = retVal.partenaire.particulier.dateDeNaissance;
                if(dateDeNaissanceOriginal != null) {
                    Date dateDeNaissanceConverted = date.newinstance(dateDeNaissanceOriginal.year(), dateDeNaissanceOriginal.month(), dateDeNaissanceOriginal.day());
                    accountToInsert.PersonBirthdate = dateDeNaissanceConverted;
                }
                accountToInsert.tech_lieu_particulier__c = retVal.partenaire.particulier.lieuDeNaissance;
                accountToInsert.tech_pays_particulier__c = retVal.partenaire.particulier.paysDeNaissance;
                accountToInsert.tech_statut_particulier__c = retVal.partenaire.particulier.statutParticulier;
            }
            if(retVal.partenaire.etablissement != null) {
                accountToInsert.Type_immatriculation__c = retVal.partenaire.Etablissement.typeImmatriculation;
                //accountToInsert.SIRET__c = retVal.partenaire.Etablissement.immatriculationLegale;
                accountToInsert.LibelleEtablissement__c = retVal.partenaire.Etablissement.libelleEtablissement;
                accountToInsert.Sigle__c = retVal.partenaire.Etablissement.denominationCommerciale;
                accountToInsert.Site = retVal.partenaire.Etablissement.complementLibelle;
                accountToInsert.TypeIdentificationExterne__c = retVal.partenaire.Etablissement.typeIdentificationExterne;
                accountToInsert.Identification_externe__c = retVal.partenaire.Etablissement.identificationExterne;
                accountToInsert.tech_nom_naissance__c = retVal.partenaire.Etablissement.nomNaissance;
                accountToInsert.tech_nom_usage__c = retVal.partenaire.Etablissement.nomUsage;
                accountToInsert.tech_prenom__c = retVal.partenaire.Etablissement.PRENOMS;
                accountToInsert.Siege_social_partenaire__c = retVal.partenaire.Etablissement.siegeSocialPartenaire;

                if(String.isNotBlank(retVal.partenaire.Etablissement.effectifSalarie)) {
                    accountToInsert.effectif__c = retVal.partenaire.Etablissement.effectifSalarie;
                }

                DateTime DatedebutOriginal = retVal.partenaire.Etablissement.dateDebut;
                if(DatedebutOriginal != null) {
                    Date DatedebutConverted = date.newinstance(DatedebutOriginal.year(), DatedebutOriginal.month(), DatedebutOriginal.day());
                    accountToInsert.Datedebut__c = DatedebutConverted;
                }
                DateTime DatefinOriginal = retVal.partenaire.Etablissement.dateFin;
                if(DatefinOriginal != null) {
                    Date DatefinConverted = date.newinstance(DatefinOriginal.year(), DatefinOriginal.month(), DatefinOriginal.day());
                    accountToInsert.Datefin__c = DatefinConverted;
                }
                List<CentreFinance__c> centre = [Select id, DkCode__c from CentreFinance__c where DkCode__c = : retVal.partenaire.Etablissement.UODalkiaPilote];
                if(centre != null && centre.size() > 0) {
                    accountToInsert.UODalkiaPilote__c = centre[0].Id;
                }
                accountToInsert.Code_NAF__c = retVal.partenaire.Etablissement.codeActiviteLocal;

                if(String.isNotBlank(retVal.partenaire.Etablissement.codeActiviteInternational) && retVal.partenaire.Etablissement.codeActiviteInternational.isNumeric() ) {
                    accountToInsert.Code_NACE__c = retVal.partenaire.Etablissement.codeActiviteInternational;
                }

                if(retVal.partenaire.Etablissement.societe != null && String.isNotBlank(retVal.partenaire.Etablissement.societe.DKCodeSociete)) {
                    accountToInsert.DkCodeSociete__c = retVal.partenaire.Etablissement.societe.DKCodeSociete;
                    List<Account> acc = new List<Account>();
                    acc = [select id, Categorie_partenaire__c from account where DKCodeSurPartenaire__c = : retVal.partenaire.Etablissement.societe.DKCodeSociete];
                    if(acc != null && acc.size() > 0) {
                        accountToInsert.parentid  = acc[0].id;
                        accountToInsert.Categorie_partenaire__c = acc[0].Categorie_partenaire__c;
                    } else {
                        accountToInsert.parentid  = null;
                    }
                } else {
                    accountToInsert.parentid  = null;
                }
                if(retVal.partenaire.Etablissement.chorus != null) {
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.EJObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEOuEJObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEParDefaut;on ne récupère pas , a supprimer
                }
            }
            if(retVal.partenaire.client != null) {
                accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
                if(retVal.partenaire.client.utilisationFiliereCommerce != null && retVal.partenaire.client.utilisationFiliereCommerce == true) {
                    accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
                }
                accountToInsert.Segment_client__c = retVal.partenaire.Client.segmentClient;
                accountToInsert.Sous_segment_client__c = retVal.partenaire.Client.sousSegmentClient;
                accountToInsert.EntiteCommercialeDalkia__c = retVal.partenaire.Client.entiteCommercialeDalkia;
                accountToInsert.EntiteCommercialeEDF__c = retVal.partenaire.Client.entiteCommercialeEdf;
                accountToInsert.Societe_Mandataire__c = false;
                if(retVal.partenaire.Client.societeMandataire != null) {
                    accountToInsert.Societe_Mandataire__c = retVal.partenaire.Client.societeMandataire;
                }
                if(retVal.partenaire.Client.listeRecouvrements != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement.size() > 0) {
                    String codeValues = '';
                    for(wwwDalkiaFrReferentielPartenaire.recouvrement rec : retVal.partenaire.Client.listeRecouvrements.recouvrement) {
                        if(rec.codeRecouvrement != null && String.isNotBlank(rec.codeRecouvrement)) {
                            codeValues += rec.codeRecouvrement + ';';
                        }
                    }
                    if(codeValues.length() > 1) {
                        codeValues = codeValues.substring(0, codeValues.length() - 1);
                    }
                    accountToInsert.CodeRecouvrement__c = codeValues;
                }
                if(retVal.partenaire.Client.conditionsPaiementDefaut != null) {
                    accountToInsert.Depart_Exigibilite__c = retVal.partenaire.Client.conditionsPaiementDefaut.departExigibilite;
                    accountToInsert.DelaiPaiementJour__c = retVal.partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours;
                    accountToInsert.Report_Fin_Mois__c = retVal.partenaire.Client.conditionsPaiementDefaut.reportFinMois;
                    accountToInsert.JourMoisSuivant__c = retVal.partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant;
                    accountToInsert.Methode_Interet_Retard__c = retVal.partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard;
                    accountToInsert.Mode_Reglement__c = retVal.partenaire.Client.conditionsPaiementDefaut.modeReglement;
                }
            }
            if(retVal.partenaire.fournisseur != null) {
                accountToInsert.Utilisation_Filiere_Achat__c = retVal.partenaire.fournisseur.utilisationFiliereAchats;
                accountToInsert.Societe_Affacturage__c = retVal.partenaire.fournisseur.societeAffacturage;
                if(retVal.partenaire.fournisseur.listeClassification != null && retVal.partenaire.fournisseur.listeClassification.classification.size() > 0) {
                    accountToInsert.Perimetre_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).perimetreAchat;
                    accountToInsert.Niveau_Classification_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).niveauClassificationAchat;
                }
            }
            //address
            if(retVal.partenaire.listeAdresses != null && retVal.partenaire.listeAdresses.adresse != null) {
                set<String> addresseIds = new Set<String>();
                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    addresseIds.add(add.metadonneesAdressePartenaire.creationId);
                    addresseIds.add(add.metadonneesAdressePartenaire.updateId);
                    addresseIds.add(add.metadonneesAdressePartenaire.validationId);
                }
                List<User> userAdd = new List<User>();
                userAdd = [Select id, name, ReferentielId__c from user where ReferentielId__c in:addresseIds];

                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    if(add.adressePrincipale != null && add.adressePrincipale == true) {
                        accountToInsert.DkCodeAdressePrincipale__c = add.DKCodeAdresse;
                        accountToInsert.Statut_adresse_1__c = add.statutAdresse;
                        accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
                        accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;
                        accountToInsert.BillingStreet = '';
                        if(add.numeroVoie != null) {
                            accountToInsert.BillingStreet += add.numeroVoie + ' ';
                        }
                        if(add.typeDeVoie != null) {
                            if(add.typeDeVoie == 'VIDE') {
                                accountToInsert.BillingStreet = '';
                            } else {
                                accountToInsert.BillingStreet += add.typeDeVoie + ' ';
                            }
                        }
                        if(String.isNotBlank(add.libelleVoie) || add.libelleVoie == ' ') {
                            accountToInsert.BillingStreet += add.libelleVoie;
                        }
                        accountToInsert.ComplementAdresse__c = add.complementAdresse;
                        accountToInsert.BillingPostalCode = add.codePostal;
                        accountToInsert.BillingCity = add.ville;
                        accountToInsert.BillingCountry = add.pays;
                        accountToInsert.Phone = add.telephone;
                        accountToInsert.fax = add.fax;
                        accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
                        //accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle; //on ne récupère pas (info fournisseur)
                        accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
                        ///accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
                        if(add.dematerialise != null) {
                            accountToInsert.Dematerialise__c = add.dematerialise;
                        }
                        //affacturage (champs en rouge, a verifier)
                        if(add.listeMandataires != null && add.listeMandataires.mandataire.size() > 0) {
                            //accountToInsert.DKC_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCPartenaireMandataire;
                            //accountToInsert.DKC_Adresse_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCAdressePartenaireMandataire;
                            //accountToInsert.Statut_Lien_Mandataire__c = add.listeMandataires.mandataire.get(0).statutLienMandataire;
                        }
                        if(add.metadonneesAdressePartenaire != null) {
                            for(User userLoop : userAdd) {
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.creationId) {
                                    accountToInsert.AdresseCreationID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.updateId) {
                                    accountToInsert.AdresseUpdateID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.validationId) {
                                    accountToInsert.AdresseValidationID__c = userLoop.id;
                                }
                            }
                            accountToInsert.AdresseCreationDate__c = add.metadonneesAdressePartenaire.creationDate;
                            accountToInsert.AdresseUpdateDate__c = add.metadonneesAdressePartenaire.updateDate;
                            accountToInsert.AdresseValidationDate__c = add.metadonneesAdressePartenaire.validationDate;

                        }
                    }
                }
            }
            //immatriculation
            if(retVal.partenaire.listeImmatriculationsAnterieures != null && retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.size() > 0) {
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).ImmatriculationAnterieure;
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).dateFinImmatriculation;
            }
            //metadonnes
            if(retVal.partenaire.metadonnees != null) {
                accountToInsert.CreateDate__c = retVal.partenaire.metadonnees.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.creationId limit 1];
                if(usr1 != null && usr1.size() > 0) {
                    accountToInsert.CreateId__c = usr1[0].Id;
                }
                accountToInsert.UpdateDate__c = retVal.partenaire.metadonnees.updateDate;
                List<User> usr2 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.updateId limit 1];
                if(usr2 != null && usr2.size() > 0) {
                    accountToInsert.UpdateId__c = usr2[0].Id;
                }

                accountToInsert.ValidationDate__c = retVal.partenaire.metadonnees.validationDate;
                List<User> usr3 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.validationId limit 1];
                if(usr3 != null && usr3.size() > 0 && String.isNotBlank(usr3[0].ReferentielId__c)) {
                    accountToInsert.ValidationId__c   = usr3[0].Id;
                }
            }
        }

        return accountToInsert;
    }

    public static wwwDalkiaFrReferentielPartenaire.modifierPartenaireRequete fillModifierPartenaireRequete(Account acc){
        wwwDalkiaFrReferentielPartenaire.modifierPartenaireRequete retVal = new wwwDalkiaFrReferentielPartenaire.modifierPartenaireRequete();
        retVal.partenaire = new wwwDalkiaFrReferentielPartenaire.partenaireP1();
        retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'etablissement');
        retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'fournisseur');
        retVal.partenaire.proprietesPartenaire = new wwwDalkiaFrReferentielPartenaire.proprietesPartenaireP1();

        retVal.partenaire.proprietesPartenaire.commentaire = acc.Commentaire__c;
        retVal.partenaire.proprietesPartenaire.DKCodePartenaire = acc.DKCodeSurPartenaire__c;

        retVal.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulierP1();
        retVal.partenaire.particulier.civilite = acc.Salutation;
        retVal.partenaire.particulier.nomUsage = acc.LastName;
        retVal.partenaire.particulier.prenomUsage = acc.FirstName;
        retVal.partenaire.particulier.dateDeNaissance = acc.PersonBirthdate;
        retVal.partenaire.particulier.lieuDeNaissance = acc.tech_lieu_particulier__c;
        retVal.partenaire.particulier.paysDeNaissance = acc.tech_pays_particulier__c;
        retVal.partenaire.particulier.statutParticulier = acc.tech_statut_particulier__c;
        /*
           retVal.partenaire.Etablissement = new wwwDalkiaFrReferentielPartenaire.etablissementP1();
           retVal.partenaire.Etablissement.typeImmatriculation = acc.Type_immatriculation__c;
           retVal.partenaire.Etablissement.immatriculationLegale = acc.SIRET__c;
           retVal.partenaire.Etablissement.libelleEtablissement = acc.LibelleEtablissement__c;
           retVal.partenaire.Etablissement.denominationCommerciale = acc.Sigle__c;
           retVal.partenaire.Etablissement.complementLibelle = acc.Site;
           retVal.partenaire.Etablissement.typeIdentificationExterne = acc.TypeIdentificationExterne__c;
           retVal.partenaire.Etablissement.identificationExterne = acc.Identification_externe__c;
           //retVal.partenaire.Etablissement.nomNaissance = acc.??; //To get from consulter
           //retVal.partenaire.Etablissement.nomUsage = acc.??; //To get from consulter
           //retVal.partenaire.Etablissement.PRENOMS = acc.??; //To get from consulter
           retVal.partenaire.Etablissement.siegeSocialPartenaire = acc.Siege_social_partenaire__c;
           //retVal.partenaire.Etablissement.effectifSalarie = acc.effectif__c ;
           retVal.partenaire.Etablissement.dateDebut = acc.DateDebut__c;
           retVal.partenaire.Etablissement.dateFin = acc.DateFin__c;
           //retVal.partenaire.Etablissement.statutGestionRH = acc.??;
           retVal.partenaire.Etablissement.codeActiviteLocal = acc.Code_NAF__c;
           //retVal.partenaire.Etablissement.codeActiviteInternational = acc.Code_NACE__c; //Decimal to string
           retVal.partenaire.Etablissement.chorus = new wwwDalkiaFrReferentielPartenaire.chorusP1();
           //retVal.partenaire.Etablissement.chorus.SEObligatoire = acc.??;
           //retVal.partenaire.Etablissement.chorus.EJObligatoire = acc.??;
           //retVal.partenaire.Etablissement.chorus.SEOuEJObligatoire = acc.??;
           //retVal.partenaire.Etablissement.chorus.SEParDefaut = acc.??;
         */
        retVal.partenaire.client = new wwwDalkiaFrReferentielPartenaire.clientP1();
        Boolean utilisationFiliereCommerceBool = false;
        if(String.isNotBlank(acc.Utilisation_filiere_Commerce__c) && acc.Utilisation_filiere_Commerce__c.equals('Actif')) {
            utilisationFiliereCommerceBool = true;
        }
        retVal.partenaire.Client.utilisationFiliereCommerce = utilisationFiliereCommerceBool; //string to boolean
        retVal.partenaire.Client.segmentClient = acc.Segment_client__c;
        retVal.partenaire.Client.sousSegmentClient = acc.Sous_segment_client__c;
        retVal.partenaire.Client.entiteCommercialeDalkia = acc.EntiteCommercialeDalkia__c;
        retVal.partenaire.Client.entiteCommercialeEdf = acc.EntiteCommercialeEDF__c;
        retVal.partenaire.Client.societeMandataire = acc.Societe_Mandataire__c;

        retVal.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrementsP1();
        retVal.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrementP1>();
        if(acc.CodeRecouvrement__c != null) {
            List<String> codeRecList = acc.CodeRecouvrement__c.split(';');
            for(String strLoop : codeRecList) {
                wwwDalkiaFrReferentielPartenaire.recouvrementP1 rec = new wwwDalkiaFrReferentielPartenaire.recouvrementP1();
                rec.codeRecouvrement = strLoop;
                retVal.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
            }
        }
        /*
           //testing only
           retVal.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautP1();
           retVal.partenaire.client.conditionsPaiementDefaut.departExigibilite = 'EMI';
           retVal.partenaire.client.conditionsPaiementDefaut.delaiPaiementJours = 1;
           retVal.partenaire.client.conditionsPaiementDefaut.reportFinMois = false;
           retVal.partenaire.client.conditionsPaiementDefaut.jourMoisSuivant = 1;
           retVal.partenaire.client.conditionsPaiementDefaut.methodeInteretsRetard = 'tontaine';
         */
        if(String.isNotBlank(acc.Depart_Exigibilite__c) &&
           acc.DelaiPaiementJour__c != null &&
           String.isNotBlank(acc.Methode_Interet_Retard__c)) {
            retVal.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautP1();
            retVal.partenaire.client.conditionsPaiementDefaut.departExigibilite = acc.Depart_Exigibilite__c;
            if(acc.DelaiPaiementJour__c != null) {
                retVal.partenaire.client.conditionsPaiementDefaut.delaiPaiementJours = Integer.valueOf(acc.DelaiPaiementJour__c);
            }
            retVal.partenaire.client.conditionsPaiementDefaut.reportFinMois = acc.Report_Fin_Mois__c;
            if(acc.JourMoisSuivant__c != null) {
                retVal.partenaire.client.conditionsPaiementDefaut.jourMoisSuivant = Integer.valueOf(acc.JourMoisSuivant__c);
            }
            retVal.partenaire.client.conditionsPaiementDefaut.methodeInteretsRetard = acc.Methode_Interet_Retard__c;
            retVal.partenaire.client.conditionsPaiementDefaut.modeReglement = acc.Mode_Reglement__c;
        } else {
            retVal.partenaire.client.field_order_type_info = removeListValue(retVal.partenaire.client.field_order_type_info, 'conditionsPaiementDefaut');
            System.debug('ENTERED THE "ELSE" SCOPE');
        }

        /*
           retVal.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseurP1();
           retVal.partenaire.fournisseur.utilisationFiliereAchats = acc.Utilisation_Filiere_Achat__c;
           retVal.partenaire.fournisseur.societeAffacturage = acc.Societe_Affacturage__c;
           retVal.partenaire.fournisseur.listeClassification = new wwwDalkiaFrReferentielPartenaire.listeClassificationP1();
           retVal.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classificationP1>();
           wwwDalkiaFrReferentielPartenaire.classificationP1 classification = new wwwDalkiaFrReferentielPartenaire.classificationP1();
           classification.perimetreAchat = acc.Perimetre_Achat__c;
           classification.niveauClassificationAchat = acc.Niveau_Classification_Achat__c;
           retVal.partenaire.fournisseur.listeClassification.classification.add(classification);
         */
        retVal.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsablesP1();
        retVal.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsableP1>();
        try {
            //03/01/2023: Modified by jimmy, US C360-266 on envoie uniquement le proprietaire comme responsable partenaire
            List<User> userDkcode = [Select id, name, DkCode__c From user Where id = :acc.OwnerId];
            if(userDkcode != null && userDkcode.size() > 0) {
                wwwDalkiaFrReferentielPartenaire.responsableP1 resp = new wwwDalkiaFrReferentielPartenaire.responsableP1();
                resp.responsableCompte = userDkcode[0].DkCode__c;
                resp.perimetreResponsable = 'ROL01';
                resp.statutLienResponsable = true;
                retVal.partenaire.listeResponsables.responsable.add(resp);
            }

            if(retVal.partenaire.listeResponsables.responsable.size() == 0) {
                retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'listeResponsables');
            }
        }
        Catch(Exception e){
            retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'listeResponsables');
            system.debug('error ' + e);
        }
        retVal.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonneesP1();
        retVal.partenaire.metadonnees.updateDate = acc.LastModifiedDate;
        retVal.partenaire.metadonnees.updateId = label.userC360;
        retVal.partenaire.metadonnees.validationDate = acc.ValidationDate__c;

        List<User> usr2 = [select id, name, ReferentielId__c from user where id = :acc.ValidationId__c limit 1];
        if(usr2 != null && usr2.size() > 0) {
            retVal.partenaire.metadonnees.validationId = usr2[0].ReferentielId__c;
        }

        return retVal;
    }

    public static Account getModifierPartenaireRequete(wwwDalkiaFrReferentielPartenaire.modifierPartenaireReponse retVal, account accountToInsert){
        String code = retVal.informationsRetour.codeRetour;
        if(retVal.partenaire != null) {
            if(retVal.partenaire.proprietesPartenaire != null) {
                accountToInsert.DKCodeSurPartenaire__c = retVal.partenaire.proprietesPartenaire.DKCodePartenaire;
                accountToInsert.StatutPartenaire__c = retVal.partenaire.proprietesPartenaire.statutPartenaire;
                accountToInsert.Commentaire__c = retVal.partenaire.proprietesPartenaire.commentaire;
                accountToInsert.NaturePartenaire__c = retVal.partenaire.proprietesPartenaire.naturePartenaire;
                DateTime DateDerniereMajSireneOriginal = retVal.partenaire.proprietesPartenaire.dateDerniereMajSiren;
                if(DateDerniereMajSireneOriginal != null) {
                    Date DateDerniereMajSireneConverted = date.newinstance(DateDerniereMajSireneOriginal.year(), DateDerniereMajSireneOriginal.month(), DateDerniereMajSireneOriginal.day());
                    accountToInsert.DateDerniereMajSirene__c = DateDerniereMajSireneConverted;
                }
            }
            if(retVal.partenaire.particulier != null) {
                accountToInsert.Salutation = retVal.partenaire.particulier.civilite;
                accountToInsert.LastName = retVal.partenaire.particulier.nomUsage;
                accountToInsert.FirstName = retVal.partenaire.particulier.prenomUsage;
                //convert dateDeNaissance from dateTime to date
                DateTime dateDeNaissanceOriginal = retVal.partenaire.particulier.dateDeNaissance;
                if(dateDeNaissanceOriginal != null) {
                    Date dateDeNaissanceConverted = date.newinstance(dateDeNaissanceOriginal.year(), dateDeNaissanceOriginal.month(), dateDeNaissanceOriginal.day());
                    accountToInsert.PersonBirthdate = dateDeNaissanceConverted;
                }
                accountToInsert.tech_lieu_particulier__c = retVal.partenaire.particulier.lieuDeNaissance;
                accountToInsert.tech_pays_particulier__c = retVal.partenaire.particulier.paysDeNaissance;
                accountToInsert.tech_statut_particulier__c = retVal.partenaire.particulier.statutParticulier;
            }
            if(retVal.partenaire.etablissement != null) {
                accountToInsert.Type_immatriculation__c = retVal.partenaire.Etablissement.typeImmatriculation;
                accountToInsert.SIRET__c = retVal.partenaire.Etablissement.immatriculationLegale;
                accountToInsert.LibelleEtablissement__c = retVal.partenaire.Etablissement.libelleEtablissement;
                accountToInsert.Sigle__c = retVal.partenaire.Etablissement.denominationCommerciale;
                accountToInsert.Site = retVal.partenaire.Etablissement.complementLibelle;
                accountToInsert.TypeIdentificationExterne__c = retVal.partenaire.Etablissement.typeIdentificationExterne;
                accountToInsert.Identification_externe__c = retVal.partenaire.Etablissement.identificationExterne;
                accountToInsert.tech_nom_naissance__c = retVal.partenaire.Etablissement.nomNaissance;
                accountToInsert.tech_nom_usage__c = retVal.partenaire.Etablissement.nomUsage;
                accountToInsert.tech_prenom__c = retVal.partenaire.Etablissement.PRENOMS;
                accountToInsert.Siege_social_partenaire__c = retVal.partenaire.Etablissement.siegeSocialPartenaire;
                accountToInsert.effectif__c = retVal.partenaire.Etablissement.effectifSalarie;
                DateTime dateDebutOriginal = retVal.partenaire.Etablissement.dateDebut;
                if(dateDebutOriginal != null) {
                    Date dateDebutConverted = date.newinstance(dateDebutOriginal.year(), dateDebutOriginal.month(), dateDebutOriginal.day());
                    accountToInsert.DateDebut__c = dateDebutConverted;
                }
                DateTime dateFinOriginal = retVal.partenaire.Etablissement.dateFin;
                if(dateFinOriginal != null) {
                    Date dateFinConverted = date.newinstance(dateFinOriginal.year(), dateFinOriginal.month(), dateFinOriginal.day());
                    accountToInsert.DateFin__c = dateFinConverted;
                }
                //accountToInsert.?? = retVal.partenaire.Etablissement.statutEtablissement;
                try {
                    CentreFinance__c centre = [Select id, DkCode__c, Responsable_Defaut__c from CentreFinance__c where DkCode__c = : retVal.partenaire.Etablissement.UODalkiaPilote];
                    accountToInsert.UODalkiaPilote__c = centre.id;
                }
                Catch(Exception e ){
                    system.debug('Erreur ' + e);
                }
                //accountToInsert.?? = retVal.partenaire.Etablissement.statutGestionRH;
                accountToInsert.Code_NAF__c = retVal.partenaire.Etablissement.codeActiviteLocal;
                accountToInsert.Code_NACE__c = retVal.partenaire.Etablissement.codeActiviteInternational;
                if(retVal.partenaire.Etablissement.societe != null && String.isNotBlank(retVal.partenaire.Etablissement.societe.DKCodeSociete)) {
                    accountToInsert.DkCodeSociete__c = retVal.partenaire.Etablissement.societe.DKCodeSociete;
                    List<Account> acc = new List<Account>();

                    acc = [select id, Categorie_partenaire__c from account where DKCodeSurPartenaire__c = : retVal.partenaire.Etablissement.societe.DKCodeSociete];

                    if(acc != null && acc.size() > 0) {
                        accountToInsert.parentid  = acc[0].id;
                        accountToInsert.Categorie_partenaire__c = acc[0].Categorie_partenaire__c;
                    } else {
                        accountToInsert.parentid  = null;
                    }
                } else {
                    //accountToInsert.DKCodeSurPartenaire__c = null;
                    accountToInsert.parentid  = null;
                }
                if(retVal.partenaire.Etablissement.chorus != null) {
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEObligatoire;
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.EJObligatoire;
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEOuEJObligatoire;
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEParDefaut;
                }
            }
            if(retVal.partenaire.client != null) {
                accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
                if(retVal.partenaire.client.utilisationFiliereCommerce != null && retVal.partenaire.client.utilisationFiliereCommerce == true) {
                    accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
                }
                accountToInsert.Segment_client__c = retVal.partenaire.Client.segmentClient;
                accountToInsert.Sous_segment_client__c = retVal.partenaire.Client.sousSegmentClient;
                accountToInsert.EntiteCommercialeDalkia__c = retVal.partenaire.Client.entiteCommercialeDalkia;
                accountToInsert.EntiteCommercialeEDF__c = retVal.partenaire.Client.entiteCommercialeEdf;
                accountToInsert.Societe_Mandataire__c = retVal.partenaire.Client.societeMandataire;
                if(retVal.partenaire.Client.listeRecouvrements != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement.size() > 0) {
                    String codeValues = '';
                    for(wwwDalkiaFrReferentielPartenaire.recouvrement rec : retVal.partenaire.Client.listeRecouvrements.recouvrement) {
                        if(rec.codeRecouvrement != null && String.isNotBlank(rec.codeRecouvrement)) {
                            codeValues += rec.codeRecouvrement + ';';
                        }
                    }
                    if(codeValues.length() > 1) {
                        codeValues = codeValues.substring(0, codeValues.length() - 1);
                    }
                    accountToInsert.CodeRecouvrement__c = codeValues;
                }
                if(retVal.partenaire.Client.conditionsPaiementDefaut != null) {
                    accountToInsert.Depart_Exigibilite__c = retVal.partenaire.Client.conditionsPaiementDefaut.departExigibilite;
                    accountToInsert.DelaiPaiementJour__c = retVal.partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours;
                    accountToInsert.Report_Fin_Mois__c = retVal.partenaire.Client.conditionsPaiementDefaut.reportFinMois;
                    accountToInsert.JourMoisSuivant__c = retVal.partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant;
                    accountToInsert.Methode_Interet_Retard__c = retVal.partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard;
                    accountToInsert.Mode_Reglement__c = retVal.partenaire.Client.conditionsPaiementDefaut.modeReglement;
                }
            }
            if(retVal.partenaire.fournisseur != null) {
                accountToInsert.Utilisation_Filiere_Achat__c = retVal.partenaire.fournisseur.utilisationFiliereAchats;
                accountToInsert.Societe_Affacturage__c = retVal.partenaire.fournisseur.societeAffacturage;
                if(retVal.partenaire.fournisseur.listeClassification != null && retVal.partenaire.fournisseur.listeClassification.classification.size() > 0) {
                    accountToInsert.Perimetre_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).perimetreAchat;
                    accountToInsert.Niveau_Classification_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).niveauClassificationAchat;
                }

            }
            //address
            if(retVal.partenaire.listeAdresses != null && retVal.partenaire.listeAdresses.adresse.size() > 0) {
                set<String> addresseIds = new Set<String>();

                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    addresseIds.add(add.metadonneesAdressePartenaire.creationId);
                    addresseIds.add(add.metadonneesAdressePartenaire.updateId);
                    addresseIds.add(add.metadonneesAdressePartenaire.validationId);
                }
                List<User> userAdd = new List<User>();
                userAdd = [Select id, name, ReferentielId__c from user where ReferentielId__c in:addresseIds];
                string pays = '';
                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    if(add.adressePrincipale != null && add.adressePrincipale == true) {
                        accountToInsert.DkCodeAdressePrincipale__c = add.DKCodeAdresse;
                        accountToInsert.Statut_adresse_1__c = add.statutAdresse;
                        accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
                        accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;
                        accountToInsert.BillingStreet = '';
                        if(add.numeroVoie != null) {
                            accountToInsert.BillingStreet += add.numeroVoie + ' ';
                        }
                        if(add.typeDeVoie != null) {
                            if(add.typeDeVoie == 'VIDE') {
                                accountToInsert.BillingStreet = '';
                            } else {
                                accountToInsert.BillingStreet += add.typeDeVoie + ' ';
                            }
                        }
                        if(String.isNotBlank(add.libelleVoie) || add.libelleVoie == ' ') {
                            accountToInsert.BillingStreet += add.libelleVoie;
                        }
                        accountToInsert.ComplementAdresse__c = add.complementAdresse;
                        accountToInsert.BillingPostalCode = add.codePostal;
                        accountToInsert.BillingCity = add.ville;
                        //accountToInsert.BillingCountry = add.pays;
                        pays = add.pays;
                        accountToInsert.Phone = add.telephone;
                        accountToInsert.fax = add.fax;
                        accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
                        accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle;
                        accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
                        accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
                        accountToInsert.Dematerialise__c = add.dematerialise;
                        //affacturage (champs en rouge, a verifier)
                        if(add.listeMandataires != null && add.listeMandataires.mandataire.size() > 0) {
                            //accountToInsert.DKC_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCPartenaireMandataire;
                            //accountToInsert.DKC_Adresse_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCAdressePartenaireMandataire;
                            //accountToInsert.Statut_Lien_Mandataire__c = add.listeMandataires.mandataire.get(0).statutLienMandataire;
                        }
                        if(add.metadonneesAdressePartenaire != null) {
                            accountToInsert.AdresseCreationDate__c = add.metadonneesAdressePartenaire.creationDate;
                            accountToInsert.AdresseUpdateDate__c = add.metadonneesAdressePartenaire.updateDate;
                            accountToInsert.AdresseValidationDate__c = add.metadonneesAdressePartenaire.validationDate;
                            for(User userLoop : userAdd) {
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.creationId) {
                                    accountToInsert.AdresseCreationID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.updateId) {
                                    accountToInsert.AdresseUpdateID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.validationId) {
                                    accountToInsert.AdresseValidationID__c = userLoop.id;
                                }
                            }
                        }
                    }
                }
                List<Pays__c> paysList = [SELECT id, Abreviation__c, Nom__c from Pays__c where Abreviation__c = :pays];
                if(paysList != null && paysList.size() > 0) {
                    accountToInsert.BillingCountry = paysList[0].Nom__c;
                } else {
                    accountToInsert.BillingCountry = pays;
                }
            }

            if(retVal.partenaire.Etablissement != NULL) {
                List<CentreFinance__c> centre = [Select id, DkCode__c, Responsable_Defaut__c from CentreFinance__c where DkCode__c = : retVal.partenaire.Etablissement.UODalkiaPilote];
                if(centre != null && centre.size() > 0) {
                    accountToInsert.UODalkiaPilote__c = centre[0].id;
                }
            }

            //immatriculation
            if(retVal.partenaire.listeImmatriculationsAnterieures != null && retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.size() > 0) {
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).ImmatriculationAnterieure;
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).dateFinImmatriculation;
            }
            //metadonnes
            if(retVal.partenaire.metadonnees != null) {
                accountToInsert.CreateDate__c = retVal.partenaire.metadonnees.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.creationId LIMIT 1];
                if(usr1 != null && usr1.size() > 0) {
                    accountToInsert.CreateId__c = usr1[0].Id;
                }
                accountToInsert.UpdateDate__c = retVal.partenaire.metadonnees.updateDate;
                List<User> usr2 = [SELECT id from user where ReferentielId__c = :retVal.partenaire.metadonnees.updateId LIMIT 1];
                if(usr2 != null && usr2.size() > 0) {
                    accountToInsert.UpdateId__c = usr2[0].id;
                }
                accountToInsert.ValidationDate__c = retVal.partenaire.metadonnees.validationDate;
                List<User> usr3 = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.validationId LIMIT 1];
                if(usr3 != null && usr3.size() > 0 && String.isNotBlank(usr3[0].ReferentielId__c)) {
                    accountToInsert.ValidationId__c   = usr3[0].Id;
                }
            }
        }

        return accountToInsert;
    }

    public static wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintRequete fillModifierPartenaireRestreintRequete(Account acc){
        wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintRequete retVal = new wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintRequete();
        retVal.partenaire = new wwwDalkiaFrReferentielPartenaire.partenairePR1();
        retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'particulier');
        retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'fournisseur');

        retVal.partenaire.proprietesPartenaire = new wwwDalkiaFrReferentielPartenaire.proprietesPartenairePR1();

        retVal.partenaire.proprietesPartenaire.DKCodePartenaire = acc.DKCodeSurPartenaire__c;
        retVal.partenaire.proprietesPartenaire.commentaire = acc.Commentaire__c;

        /*retVal.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulierPR1();
           retVal.partenaire.particulier.civilite = acc.Salutation;
           retVal.partenaire.particulier.nomUsage = acc.LastName;
           retVal.partenaire.particulier.prenomUsage = acc.FirstName;
           retVal.partenaire.particulier.dateDeNaissance = acc.PersonBirthdate;
           //retVal.partenaire.particulier.lieuDeNaissance = acc.??; To get from consulter
           //retVal.partenaire.particulier.paysDeNaissance = acc.??; To get from consulter
           //retVal.partenaire.particulier.statutParticulier = acc.??; To get from consulter
         */
        retVal.partenaire.etablissement = new wwwDalkiaFrReferentielPartenaire.etablissementPR1();
        retVal.partenaire.etablissement.complementLibelle = acc.ComplementLibelle__c;

        retVal.partenaire.client = new wwwDalkiaFrReferentielPartenaire.clientPR1();
        retVal.partenaire.client.utilisationFiliereCommerce = false;
        Boolean utilisationFiliereCommerceBool = false;
        if(String.isNotBlank(acc.Utilisation_filiere_Commerce__c) && acc.Utilisation_filiere_Commerce__c.equals('Actif')) {
            utilisationFiliereCommerceBool = true;
        }
        retVal.partenaire.client.utilisationFiliereCommerce = utilisationFiliereCommerceBool;
        retVal.partenaire.client.segmentClient = acc.Segment_client__c;
        retVal.partenaire.client.sousSegmentClient = acc.Sous_segment_client__c;
        retVal.partenaire.client.entiteCommercialeDalkia = acc.EntiteCommercialeDalkia__c;
        retVal.partenaire.client.entiteCommercialeEdf = acc.EntiteCommercialeEDF__c;
        retVal.partenaire.client.societeMandataire = acc.Societe_Mandataire__c;

        // Updated by CG 23/09/19
        /* retVal.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautPR1();

           retVal.partenaire.client.conditionsPaiementDefaut.departExigibilite = acc.Depart_Exigibilite__c;
           retVal.partenaire.client.conditionsPaiementDefaut.delaiPaiementJours = 1;
           retVal.partenaire.client.conditionsPaiementDefaut.reportFinMois = acc.Report_Fin_Mois__c;
           retVal.partenaire.client.conditionsPaiementDefaut.jourMoisSuivant = 2;
           retVal.partenaire.client.conditionsPaiementDefaut.methodeInteretsRetard = acc.Methode_Interet_Retard__c;
           retVal.partenaire.client.conditionsPaiementDefaut.modeReglement = acc.Mode_Reglement__c; */

        if(String.isNotBlank(acc.Depart_Exigibilite__c) &&
           acc.DelaiPaiementJour__c != null &&
           String.isNotBlank(acc.Methode_Interet_Retard__c)) {
            retVal.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautPR1();
            retVal.partenaire.client.conditionsPaiementDefaut.departExigibilite = acc.Depart_Exigibilite__c;
            if(acc.DelaiPaiementJour__c != null) {
                retVal.partenaire.client.conditionsPaiementDefaut.delaiPaiementJours = Integer.valueOf(acc.DelaiPaiementJour__c);
            }
            retVal.partenaire.client.conditionsPaiementDefaut.reportFinMois = acc.Report_Fin_Mois__c;
            if(acc.JourMoisSuivant__c != null) {
                retVal.partenaire.client.conditionsPaiementDefaut.jourMoisSuivant = Integer.valueOf(acc.JourMoisSuivant__c);
            }
            retVal.partenaire.client.conditionsPaiementDefaut.methodeInteretsRetard = acc.Methode_Interet_Retard__c;
            retVal.partenaire.client.conditionsPaiementDefaut.modeReglement = acc.Mode_Reglement__c;
        } else {
            retVal.partenaire.client.field_order_type_info = removeListValue(retVal.partenaire.client.field_order_type_info, 'conditionsPaiementDefaut');
        }

        /*retVal.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseurPR1();
           retVal.partenaire.fournisseur.utilisationFiliereAchats = acc.Utilisation_Filiere_Achat__c;
           retVal.partenaire.fournisseur.societeAffacturage = acc.Societe_Affacturage__c;
           retVal.partenaire.fournisseur.listeClassification = new wwwDalkiaFrReferentielPartenaire.listeClassificationPR1();
           retVal.partenaire.fournisseur.listeClassification.classification = new List<wwwDalkiaFrReferentielPartenaire.classificationPR1>();
           wwwDalkiaFrReferentielPartenaire.classificationPR1 classificationObj = new wwwDalkiaFrReferentielPartenaire.classificationPR1();
           classificationObj.perimetreAchat = acc.Perimetre_Achat__c;
           classificationObj.niveauClassificationAchat = acc.Niveau_Classification_Achat__c;
           retVal.partenaire.fournisseur.listeClassification.classification.add(classificationObj);*/

        retVal.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsablesPR1();
        retVal.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsablePR1>();

        //03/01/2023: Modified by jimmy, US C360-266 on envoie uniquement le proprietaire comme responsable partenaire
        List<User> userDkcode = [Select id, name, DkCode__c From user Where id = :acc.OwnerId];
        if(userDkcode != null && userDkcode.size() > 0) {
            wwwDalkiaFrReferentielPartenaire.responsablePR1 resp = new wwwDalkiaFrReferentielPartenaire.responsablePR1();
            resp.responsableCompte = userDkcode[0].DkCode__c;
            resp.perimetreResponsable = 'ROL01';
            resp.statutLienResponsable = true;
            retVal.partenaire.listeResponsables.responsable.add(resp);
        }
        if(retVal.partenaire.listeResponsables.responsable.size() == 0) {
            retVal.partenaire.field_order_type_info = removeListValue(retVal.partenaire.field_order_type_info, 'listeResponsables');
        }
        /*if(ownerInPart == false){
           wwwDalkiaFrReferentielPartenaire.responsablePR1 resp = new wwwDalkiaFrReferentielPartenaire.responsablePR1();
           resp.responsableCompte = userDkcode.DkCode__c;
           resp.perimetreResponsable = 'ROL01';
           resp.statutLienResponsable = true;
           //retVal.partenaire.listeResponsables.responsable.add(resp);
           }*/
        retVal.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonneesPR1();
        retVal.partenaire.metadonnees.updateDate = acc.LastModifiedDate;
        retVal.partenaire.metadonnees.validationDate = acc.ValidationDate__c;
        /*List<User> usr = [select id,name,ReferentielId__c from user where id = :acc.LastModifiedById limit 1];
           if (usr !=null && usr.size()>0){
            retVal.partenaire.metadonnees.updateId = usr[0].ReferentielId__c;
           }
           List<User> usr1 = [select id,name,ReferentielId__c from user where id = :acc.ValidationId__c limit 1];
           if (usr1 !=null && usr1.size()>0){
            retVal.partenaire.metadonnees.validationId = usr1[0].ReferentielId__c;
           }*/
        retVal.partenaire.metadonnees.updateId = label.userC360;

        List<User> usr1 = [select id, name, ReferentielId__c from user where id = :acc.ValidationId__c limit 1];
        if(usr1 != null && usr1.size() > 0) {
            retVal.partenaire.metadonnees.validationId = usr1[0].ReferentielId__c;
        }

        return retVal;
    }

    /* public static Account getModifierPartenaireRestreintRequete(wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintReponse retVal){
       Account accountToInsert = new Account();
       String code = retVal.informationsRetour.codeRetour;
       if(retVal.partenaire!=null){
       if(retVal.partenaire.proprietesPartenaire!=null){
       accountToInsert.DKCodeSurPartenaire__c = retVal.partenaire.proprietesPartenaire.DKCodePartenaire;
       accountToInsert.Description = retVal.partenaire.proprietesPartenaire.commentaire;
       }
       if(retVal.partenaire.particulier!=null){
       accountToInsert.Salutation = retVal.partenaire.particulier.civilite;
       accountToInsert.LastName = retVal.partenaire.particulier.nomUsage;
       accountToInsert.FirstName = retVal.partenaire.particulier.prenomUsage;
       //convert dateDeNaissance from dateTime to date
       DateTime dateDeNaissanceOriginal = retVal.partenaire.particulier.dateDeNaissance;
       if(dateDeNaissanceOriginal!=null){
       Date dateDeNaissanceConverted = date.newinstance(dateDeNaissanceOriginal.year(), dateDeNaissanceOriginal.month(), dateDeNaissanceOriginal.day());
       accountToInsert.PersonBirthdate = dateDeNaissanceConverted;
       }
       accountToInsert.tech_lieu_particulier__c = retVal.partenaire.particulier.lieuDeNaissance;
       accountToInsert.tech_pays_particulier__c = retVal.partenaire.particulier.paysDeNaissance;
       accountToInsert.tech_statut_particulier__c = retVal.partenaire.particulier.statutParticulier;
       }
       if(retVal.partenaire.etablissement!=null){
       accountToInsert.Type_immatriculation__c = retVal.partenaire.Etablissement.typeImmatriculation;
       accountToInsert.SIRET__c = retVal.partenaire.Etablissement.immatriculationLegale;
       accountToInsert.LibelleEtablissement__c = retVal.partenaire.Etablissement.libelleEtablissement;
       accountToInsert.Sigle__c = retVal.partenaire.Etablissement.denominationCommerciale;
       accountToInsert.Site = retVal.partenaire.Etablissement.complementLibelle;
       accountToInsert.TypeIdentificationExterne__c = retVal.partenaire.Etablissement.typeIdentificationExterne;
       accountToInsert.Identification_externe__c = retVal.partenaire.Etablissement.identificationExterne;
       accountToInsert.tech_nom_naissance__c = retVal.partenaire.Etablissement.nomNaissance;
       accountToInsert.tech_nom_usage__c = retVal.partenaire.Etablissement.nomUsage;
       accountToInsert.tech_prenom__c = retVal.partenaire.Etablissement.PRENOMS;
       accountToInsert.Siege_social_partenaire__c = retVal.partenaire.Etablissement.siegeSocialPartenaire;
       //accountToInsert.effectif__c = retVal.partenaire.Etablissement.effectifSalarie;
       //convert date debut from dateTime to date
       DateTime DatedebutOriginal = retVal.partenaire.Etablissement.dateDebut;
       if(DatedebutOriginal!=null){
       Date DatedebutConverted = date.newinstance(DatedebutOriginal.year(), DatedebutOriginal.month(), DatedebutOriginal.day());
       accountToInsert.Datedebut__c = DatedebutConverted;
       }
       //convert date fin from dateTime to date
       DateTime DatefinOriginal = retVal.partenaire.Etablissement.dateFin;
       if(DatefinOriginal!=null){
       Date DatefinConverted = date.newinstance(DatefinOriginal.year(), DatefinOriginal.month(), DatefinOriginal.day());
       accountToInsert.Datefin__c = DatefinConverted;
       }
       //accountToInsert.?? = retVal.partenaire.Etablissement.statutEtablissement; Ne pas utiliser
       //accountToInsert.?? = retVal.partenaire.Etablissement.statutGestionRH; EntiteCommercialeDalkia__c
       accountToInsert.Code_NAF__c = retVal.partenaire.Etablissement.codeActiviteLocal;
       accountToInsert.Code_NACE__c = retVal.partenaire.Etablissement.codeActiviteInternational;
       if(retVal.partenaire.Etablissement.chorus!=null){
       //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEObligatoire; a supprimer
       //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.EJObligatoire; a supprimer
       //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEOuEJObligatoire; a supprimer
       //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEParDefaut; a supprimer
       }
       }
       if(retVal.partenaire.client!=null){
       accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
       if(retVal.partenaire.client.utilisationFiliereCommerce!=null && retVal.partenaire.client.utilisationFiliereCommerce==true){
       accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
       }
       accountToInsert.Segment_client__c = retVal.partenaire.Client.segmentClient;
       accountToInsert.Sous_segment_client__c = retVal.partenaire.Client.sousSegmentClient;
       accountToInsert.EntiteCommercialeDalkia__c = retVal.partenaire.Client.entiteCommercialeDalkia;
       accountToInsert.EntiteCommercialeEDF__c = retVal.partenaire.Client.entiteCommercialeEdf;
       accountToInsert.Societe_Mandataire__c = retVal.partenaire.Client.societeMandataire;
       if(retVal.partenaire.Client.listeRecouvrements!= null
       && retVal.partenaire.Client.listeRecouvrements.recouvrement!= null
       && retVal.partenaire.Client.listeRecouvrements.recouvrement.size()>0){
       String codeValues = '';
       for(wwwDalkiaFrReferentielPartenaire.recouvrementP1 rec : retVal.partenaire.Client.listeRecouvrements.recouvrement ){
       if(rec.codeRecouvrement != null && String.isNotBlank(rec.codeRecouvrement)){
       codeValues += rec.codeRecouvrement+';';
       }
       }
       if(codeValues.length()>1){
       codeValues = codeValues.substring(0, codeValues.length()-1);
       }
       accountToInsert.CodeRecouvrement__c = codeValues;
       }

       if(retVal.partenaire.Client.conditionsPaiementDefaut != null ){
       accountToInsert.Depart_Exigibilite__c = retVal.partenaire.Client.conditionsPaiementDefaut.departExigibilite;
       accountToInsert.DelaiPaiementJour__c = retVal.partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours;
       accountToInsert.Report_Fin_Mois__c = retVal.partenaire.Client.conditionsPaiementDefaut.reportFinMois;
       accountToInsert.JourMoisSuivant__c = retVal.partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant;
       accountToInsert.Methode_Interet_Retard__c = retVal.partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard;
       accountToInsert.Mode_Reglement__c = retVal.partenaire.Client.conditionsPaiementDefaut.modeReglement;
       }
       }
       if(retVal.partenaire.fournisseur!=null){
       accountToInsert.Utilisation_Filiere_Achat__c = retVal.partenaire.fournisseur.utilisationFiliereAchats;
       accountToInsert.Societe_Affacturage__c = retVal.partenaire.fournisseur.societeAffacturage;
       if(retVal.partenaire.fournisseur.listeClassification!= null && retVal.partenaire.fournisseur.listeClassification.classification.size()>0){
       accountToInsert.Perimetre_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).perimetreAchat;
       accountToInsert.Niveau_Classification_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).niveauClassificationAchat;
       }

       }
       if(retVal.partenaire.listeResponsables!=null && retVal.partenaire.listeResponsables.responsable.size()>0){
       //accountToInsert.?? = retVal.partenaire.listeResponsables.responsable.get(0).responsableCompte; // pas de api name
       //accountToInsert.?? = retVal.partenaire.listeResponsables.responsable.get(0).perimetreResponsable; // pas de api name
       //accountToInsert.?? = retVal.partenaire.listeResponsables.responsable.get(0).statutLienResponsable; // pas de api name
       }
       //metadonnes
       if(retVal.partenaire.metadonnees!=null){
       //accountToInsert.CreatedBy = retVal.partenaire.metadonnees.creationId; string to user
       accountToInsert.LastModifiedDate = retVal.partenaire.metadonnees.updateDate;
       //accountToInsert.LastModifiedBy = retVal.partenaire.metadonnees.updateId; string to user
       //accountToInsert.?? = retVal.partenaire.metadonnees.validationDate;
       //accountToInsert.?? = retVal.partenaire.metadonnees.validationId;

       }
       }



       return accountToInsert;
       }*/

    public static wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete fillCreerPartenaireIdExterneRequete(Account acc){
        wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete retVal = new wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete();
        system.debug('acc ' + acc);
        retVal.siret = acc.SIRET__c;
        retVal.numeroRegistreCopropriete = acc.Identification_externe__c;
        retVal.DKCodeSociete = acc.DkCodeSociete__c;
        retVal.segmentClient = acc.Segment_client__c;
        retVal.sousSegmentClient = acc.Sous_segment_client__c;
        retVal.utilisationDonnee = 'COM';

        //String userId = UserInfo.getUserId();
        //List<User> usr = [Select id,name,ReferentielId__c From user Where id = :userId];
        system.debug('acc.CreatedById ' + acc.CreatedById);
        //if (usr !=null && usr.size()>0){
        retVal.login = label.userC360;
        //}

        retVal.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsablesPA1();
        retVal.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsablePA1>();

        List<User> listRespPart = [SELECT id, DkCode__c
                                   FROM User
                                   WHERE id = :UserInfo.getUserId()];

        for(User respLoop : listRespPart) {
            wwwDalkiaFrReferentielPartenaire.responsablePA1 resp = new wwwDalkiaFrReferentielPartenaire.responsablePA1();
            resp.responsableCompte = respLoop.DkCode__c;
            resp.perimetreResponsable = 'ROL01';
            resp.statutLienResponsable = true;
            retVal.listeResponsables.responsable.add(resp);
        }

        return retVal;
    }

    public static Account getCreerPartenaireIdExterneRequete(wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneReponse retVal, Account accountToInsert){
        if(retval.informationsRetour != null) {
            if(retVal.informationsRetour.codeRetour != null) {
                String code = retVal.informationsRetour.codeRetour;
            }
        }
        if(retVal.partenaire != null) {
            if(retVal.partenaire.proprietesPartenaire != null) {
                accountToInsert.DKCodeSurPartenaire__c = retVal.partenaire.proprietesPartenaire.DKCodePartenaire;
                accountToInsert.StatutPartenaire__c = retVal.partenaire.proprietesPartenaire.statutPartenaire;
                accountToInsert.Commentaire__c = retVal.partenaire.proprietesPartenaire.commentaire;
                accountToInsert.NaturePartenaire__c = retVal.partenaire.proprietesPartenaire.naturePartenaire;

                DateTime dateDerniereMAJSireneOriginal = retVal.partenaire.proprietesPartenaire.dateDerniereMajSiren;
                if(dateDerniereMAJSireneOriginal != null) {
                    Date dateDerniereMAJSireneConverted = date.newinstance(dateDerniereMAJSireneOriginal.year(), dateDerniereMAJSireneOriginal.month(), dateDerniereMAJSireneOriginal.day());
                    accountToInsert.DateDerniereMajSirene__c = dateDerniereMAJSireneConverted;
                }
            }
            if(retVal.partenaire.particulier != null) {
                accountToInsert.Salutation = retVal.partenaire.particulier.civilite;
                accountToInsert.LastName = retVal.partenaire.particulier.nomUsage;
                accountToInsert.FirstName = retVal.partenaire.particulier.prenomUsage;

                DateTime dateDeNaissanceOriginal = retVal.partenaire.particulier.dateDeNaissance;
                if(dateDeNaissanceOriginal != null) {
                    Date dateDeNaissanceConverted = date.newinstance(dateDeNaissanceOriginal.year(), dateDeNaissanceOriginal.month(), dateDeNaissanceOriginal.day());
                    accountToInsert.PersonBirthdate = dateDeNaissanceConverted;
                }
                accountToInsert.tech_lieu_particulier__c = retVal.partenaire.particulier.lieuDeNaissance;
                accountToInsert.tech_pays_particulier__c = retVal.partenaire.particulier.paysDeNaissance;
                accountToInsert.tech_statut_particulier__c = retVal.partenaire.particulier.statutParticulier;
            }
            if(retVal.partenaire.etablissement != null) {
                accountToInsert.Type_immatriculation__c = retVal.partenaire.Etablissement.typeImmatriculation;
                //accountToInsert.SIRET__c = retVal.partenaire.Etablissement.immatriculationLegale;
                accountToInsert.Name = retVal.partenaire.Etablissement.libelleEtablissement;
                accountToInsert.enseigne__c = retVal.partenaire.Etablissement.denominationCommerciale;
                accountToInsert.ComplementLibelle__c = retVal.partenaire.Etablissement.complementLibelle;
                accountToInsert.TypeIdentificationExterne__c = retVal.partenaire.Etablissement.typeIdentificationExterne;
                accountToInsert.Identification_externe__c = retVal.partenaire.Etablissement.identificationExterne;
                accountToInsert.tech_nom_naissance__c = retVal.partenaire.Etablissement.nomNaissance;
                accountToInsert.tech_nom_usage__c = retVal.partenaire.Etablissement.nomUsage;
                accountToInsert.tech_prenom__c = retVal.partenaire.Etablissement.PRENOMS;
                accountToInsert.Siege_social_partenaire__c = retVal.partenaire.Etablissement.siegeSocialPartenaire;
                if(String.isNotBlank(retVal.partenaire.Etablissement.effectifSalarie)) {
                    accountToInsert.effectif__c = retVal.partenaire.Etablissement.effectifSalarie;
                }

                DateTime DatedebutOriginal = retVal.partenaire.Etablissement.dateDebut;
                if(DatedebutOriginal != null) {
                    Date DatedebutConverted = date.newinstance(DatedebutOriginal.year(), DatedebutOriginal.month(), DatedebutOriginal.day());
                    accountToInsert.Datedebut__c = DatedebutConverted;
                }
                DateTime DatefinOriginal = retVal.partenaire.Etablissement.dateFin;
                if(DatefinOriginal != null) {
                    Date DatefinConverted = date.newinstance(DatefinOriginal.year(), DatefinOriginal.month(), DatefinOriginal.day());
                    accountToInsert.Datefin__c = DatefinConverted;
                }
                List<CentreFinance__c> centre = [Select id, DkCode__c from CentreFinance__c where DkCode__c = : retVal.partenaire.Etablissement.UODalkiaPilote];
                if(centre != null && centre.size() > 0) {
                    accountToInsert.UODalkiaPilote__c = centre[0].Id;
                }
                accountToInsert.Code_NAF__c = retVal.partenaire.Etablissement.codeActiviteLocal;

                if(String.isNotBlank(retVal.partenaire.Etablissement.codeActiviteInternational) && retVal.partenaire.Etablissement.codeActiviteInternational.isNumeric() ) {
                    accountToInsert.Code_NACE__c = retVal.partenaire.Etablissement.codeActiviteInternational;
                }

                if(retVal.partenaire.Etablissement.societe != null && String.isNotBlank(retVal.partenaire.Etablissement.societe.DKCodeSociete)) {
                    accountToInsert.DkCodeSociete__c = retVal.partenaire.Etablissement.societe.DKCodeSociete;
                    List<Account> acc = new List<Account>();
                    acc = [select id, Categorie_partenaire__c from account where DKCodeSurPartenaire__c = : retVal.partenaire.Etablissement.societe.DKCodeSociete];
                    if(acc != null && acc.size() > 0) {
                        accountToInsert.parentid  = acc[0].id;
                        accountToInsert.Categorie_partenaire__c = acc[0].Categorie_partenaire__c;
                    } else {
                        accountToInsert.parentid  = null;
                    }
                } else {
                    accountToInsert.parentid  = null;
                }
                if(retVal.partenaire.Etablissement.chorus != null) {
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.EJObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEOuEJObligatoire;on ne récupère pas , a supprimer
                    //accountToInsert.?? = retVal.partenaire.Etablissement.chorus.SEParDefaut;on ne récupère pas , a supprimer
                }
            }
            if(retVal.partenaire.client != null) {
                accountToInsert.Utilisation_filiere_Commerce__c = 'Inactif';
                if(retVal.partenaire.client.utilisationFiliereCommerce != null && retVal.partenaire.client.utilisationFiliereCommerce == true) {
                    accountToInsert.Utilisation_filiere_Commerce__c = 'Actif';
                }
                accountToInsert.Segment_client__c = retVal.partenaire.Client.segmentClient;
                accountToInsert.Sous_segment_client__c = retVal.partenaire.Client.sousSegmentClient;
                accountToInsert.EntiteCommercialeDalkia__c = retVal.partenaire.Client.entiteCommercialeDalkia;
                accountToInsert.EntiteCommercialeEDF__c = retVal.partenaire.Client.entiteCommercialeEdf;
                accountToInsert.Societe_Mandataire__c = false;
                if(retVal.partenaire.Client.societeMandataire != null) {
                    accountToInsert.Societe_Mandataire__c = retVal.partenaire.Client.societeMandataire;
                }
                if(retVal.partenaire.Client.listeRecouvrements != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement != null
                   && retVal.partenaire.Client.listeRecouvrements.recouvrement.size() > 0) {
                    String codeValues = '';
                    for(wwwDalkiaFrReferentielPartenaire.recouvrement rec : retVal.partenaire.Client.listeRecouvrements.recouvrement) {
                        if(rec.codeRecouvrement != null && String.isNotBlank(rec.codeRecouvrement)) {
                            codeValues += rec.codeRecouvrement + ';';
                        }
                    }
                    if(codeValues.length() > 1) {
                        codeValues = codeValues.substring(0, codeValues.length() - 1);
                    }
                    accountToInsert.CodeRecouvrement__c = codeValues;
                }
                if(retVal.partenaire.Client.conditionsPaiementDefaut != null) {
                    accountToInsert.Depart_Exigibilite__c = retVal.partenaire.Client.conditionsPaiementDefaut.departExigibilite;
                    accountToInsert.DelaiPaiementJour__c = retVal.partenaire.Client.conditionsPaiementDefaut.delaiPaiementJours;
                    accountToInsert.Report_Fin_Mois__c = retVal.partenaire.Client.conditionsPaiementDefaut.reportFinMois;
                    accountToInsert.JourMoisSuivant__c = retVal.partenaire.Client.conditionsPaiementDefaut.jourMoisSuivant;
                    accountToInsert.Methode_Interet_Retard__c = retVal.partenaire.Client.conditionsPaiementDefaut.methodeInteretsRetard;
                    accountToInsert.Mode_Reglement__c = retVal.partenaire.Client.conditionsPaiementDefaut.modeReglement;
                }
            }
            if(retVal.partenaire.fournisseur != null) {
                accountToInsert.Utilisation_Filiere_Achat__c = retVal.partenaire.fournisseur.utilisationFiliereAchats;
                accountToInsert.Societe_Affacturage__c = retVal.partenaire.fournisseur.societeAffacturage;
                if(retVal.partenaire.fournisseur.listeClassification != null && retVal.partenaire.fournisseur.listeClassification.classification.size() > 0) {
                    accountToInsert.Perimetre_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).perimetreAchat;
                    accountToInsert.Niveau_Classification_Achat__c = retVal.partenaire.fournisseur.listeClassification.classification.get(0).niveauClassificationAchat;
                }
            }
            //address
            if(retVal.partenaire.listeAdresses != null && retVal.partenaire.listeAdresses.adresse != null) {
                set<String> addresseIds = new Set<String>();

                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    addresseIds.add(add.metadonneesAdressePartenaire.creationId);
                    addresseIds.add(add.metadonneesAdressePartenaire.updateId);
                    addresseIds.add(add.metadonneesAdressePartenaire.validationId);
                }
                List<User> userAdd = new List<User>();
                userAdd = [Select id, name, ReferentielId__c from user where ReferentielId__c in:addresseIds];
                String pays = '';
                for(wwwDalkiaFrReferentielPartenaire.adresse add : retVal.partenaire.listeAdresses.adresse) {
                    if(add.adressePrincipale != null && add.adressePrincipale == true) {
                        accountToInsert.DkCodeAdressePrincipale__c = add.DKCodeAdresse;
                        accountToInsert.Statut_adresse_1__c = add.statutAdresse;
                        accountToInsert.PrecisionDestinataire__c = add.precisionDestinataire;
                        accountToInsert.PrecisionIdentificationAdresse__c = add.precisionIdentificationAdresse;
                        accountToInsert.BillingStreet = '';
                        if(add.numeroVoie != null) {
                            accountToInsert.BillingStreet += add.numeroVoie + ' ';
                        }
                        if(add.typeDeVoie != null) {
                            if(add.typeDeVoie == 'VIDE') {
                                accountToInsert.BillingStreet = '';
                            } else {
                                accountToInsert.BillingStreet += add.typeDeVoie + ' ';
                            }
                        }
                        if(String.isNotBlank(add.libelleVoie) || add.libelleVoie == ' ') {
                            accountToInsert.BillingStreet += add.libelleVoie;
                        }
                        accountToInsert.ComplementAdresse__c = add.complementAdresse;
                        accountToInsert.BillingPostalCode = add.codePostal;
                        accountToInsert.BillingCity = add.ville;
                        //accountToInsert.BillingCountry = add.pays;
                        pays = add.pays;
                        accountToInsert.Phone = add.telephone;
                        accountToInsert.fax = add.fax;
                        accountToInsert.Code_Client_Oracle__c = add.codeClientOracle;
                        //accountToInsert.Numero_fournisseur_DK_client__c = add.codeFournisseurOracle; //on ne récupère pas (info fournisseur)
                        accountToInsert.Reference_adresse__c = add.referenceAdresseClient;
                        ///accountToInsert.Reference_adresse_2__c = add.referenceAdresseFournisseur;
                        if(add.dematerialise != null) {
                            accountToInsert.Dematerialise__c = add.dematerialise;
                        }
                        //affacturage (champs en rouge, a verifier)
                        if(add.listeMandataires != null && add.listeMandataires.mandataire.size() > 0) {
                            //accountToInsert.DKC_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCPartenaireMandataire;
                            //accountToInsert.DKC_Adresse_Partenaire_Mandataire__c = add.listeMandataires.mandataire.get(0).DKCAdressePartenaireMandataire;
                            //accountToInsert.Statut_Lien_Mandataire__c = add.listeMandataires.mandataire.get(0).statutLienMandataire;
                        }
                        if(add.metadonneesAdressePartenaire != null) {
                            accountToInsert.AdresseCreationDate__c = add.metadonneesAdressePartenaire.creationDate;
                            accountToInsert.AdresseUpdateDate__c = add.metadonneesAdressePartenaire.updateDate;
                            accountToInsert.AdresseValidationDate__c = add.metadonneesAdressePartenaire.validationDate;
                            for(User userLoop : userAdd) {
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.creationId) {
                                    accountToInsert.AdresseCreationID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.updateId) {
                                    accountToInsert.AdresseUpdateID__c = userLoop.id;
                                }
                                if(userLoop.ReferentielId__c == add.metadonneesAdressePartenaire.validationId) {
                                    accountToInsert.AdresseValidationID__c = userLoop.id;
                                }
                            }
                        }
                    }
                }
                List<Pays__c> paysList = [SELECT id, Abreviation__c, Nom__c from Pays__c where Abreviation__c = :pays];
                if(paysList != null && paysList.size() > 0) {
                    accountToInsert.BillingCountry = paysList[0].Nom__c;
                } else {
                    accountToInsert.BillingCountry = pays;
                }
            }
            List<CentreFinance__c> centre = [Select id, DkCode__c, Responsable_Defaut__c from CentreFinance__c where DkCode__c = : retVal.partenaire.Etablissement.UODalkiaPilote];
            if(centre != null && centre.size() > 0) {
                accountToInsert.UODalkiaPilote__c = centre[0].id;
            }
            //immatriculation
            if(retVal.partenaire.listeImmatriculationsAnterieures != null && retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.size() > 0) {
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).ImmatriculationAnterieure;
                //accountToInsert.?? = retVal.partenaire.listeImmatriculationsAnterieures.immatriculationsAnterieures.get(0).dateFinImmatriculation;
            }
            //metadonnes
            if(retVal.partenaire.metadonnees != null) {
                //accountToInsert.CreatedDate = retVal.partenaire.metadonnees.creationDate;
                //accountToInsert.CreatedBy = retVal.partenaire.metadonnees.creationId;
                //accountToInsert.LastModifiedDate = retVal.partenaire.metadonnees.updateDate;
                //accountToInsert.LastModifiedBy = retVal.partenaire.metadonnees.updateId;
                //
                accountToInsert.ValidationDate__c = retVal.partenaire.metadonnees.validationDate;
                List<User> usr = [ select id, name, ReferentielId__c from user where ReferentielId__c = :retVal.partenaire.metadonnees.validationId limit 1];
                if(usr != null && usr.size() > 0 && String.isNotBlank(usr[0].ReferentielId__c)) {
                    accountToInsert.ValidationId__c   = usr[0].Id;
                }
            }
        }

        return accountToInsert;
    }

    private static List<String> removeListValue(List<String> listToModify, String valueToRemove){
        Set<String> temp = new Set<String>();
        temp.addAll(listToModify);
        temp.remove(valueToRemove);
        List<String> listNew = new List<String>();
        listNew.addAll(temp);

        return listNew;
    }

    public static List<String> getBillingAddressFields(String strAddress){
        boolean typeVoieExiste = false;
        List<String> returnedFields = new List<String> {'', '', ''};
        if(strAddress != null && String.isNotBlank(strAddress)) {
            Set<String> typesVoie = new Set<String> {'RUE', 'AVENUE', 'ROUTE', 'CHEMIN', 'BOULEVARD', 'PLACE', 'ALLEE', 'LIEU DIT', 'IMPASSE', 'QUAI', 'COURS', 'LIEU'};
            strAddress = strAddress.toLowerCase();
            for(String str : typesVoie) {
                if(strAddress.contains(str.toLowerCase())) {
                    List<String> addSubString = strAddress.split(str.toLowerCase());
                    if(addSubString.size() > 0) {
                        returnedFields[0] = addSubString[0].trim();
                    }
                    returnedFields[1] = str.trim();
                    if(addSubString.size() > 1) {
                        returnedFields[2] = addSubString[1].trim();
                    }
                    typeVoieExiste = true;
                } else {
                    returnedFields[0] = '';
                    returnedFields[1] = 'VIDE';
                    returnedFields[2] = strAddress;
                }
            }
        } else {
            returnedFields[0] = '';
            returnedFields[1] = 'VIDE';
            returnedFields[2] = ' ';
        }
        try {
            if(typeVoieExiste == true) {
                TypeVoie__c typeVoie = [SELECT TypeVoie__c, Abreviation__c from TypeVoie__c where TypeVoie__c =: returnedFields[1]];
                returnedFields[1] = typeVoie.Abreviation__c;
            }
        }
        catch(Exception e) {
            System.debug('Exception ' + e.getMessage());
            returnedFields[1] = '';
        }

        return returnedFields;
    }
}