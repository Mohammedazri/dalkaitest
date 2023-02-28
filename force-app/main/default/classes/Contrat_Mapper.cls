/**
 *@author Alain Ghoussoub
 *@date 18/02/2020
 *@description List of functions that map salesforce fields to WS fields - Contrat
 */
public class Contrat_Mapper {
    public static wwwDalkiaFrReferentielContrat.consulterContratRequete fillConsulterContratRequete(Contrat__c cont){
        wwwDalkiaFrReferentielContrat.consulterContratRequete retVal = new wwwDalkiaFrReferentielContrat.consulterContratRequete();
        //fields
        retVal.DKCodeContrat = cont.DKCodeSurContrat__c;

        return retVal;
    }

    public static wwwDalkiaFrReferentielContrat.creerContratRequete fillCreerContratRequete(Contrat__c cont){
        wwwDalkiaFrReferentielContrat.creerContratRequete retVal = new wwwDalkiaFrReferentielContrat.creerContratRequete();
        retVal.contrat = new wwwDalkiaFrReferentielContrat.contratCDC1();
        retVal.contrat = fillContratInfo(cont, 'creer');

        return retVal;
    }

    public static wwwDalkiaFrReferentielContrat.renouvelerContratRequete fillRenouvelerContratRequete(Contrat__c cont){
        wwwDalkiaFrReferentielContrat.renouvelerContratRequete retVal = new wwwDalkiaFrReferentielContrat.renouvelerContratRequete();
        //retVal.dateDeFinContratRemplace = Date.today();
        retVal.motifDeFermeture = cont.OpportuniteCommerciale__r.ContratOrigine__r.Motif_fermeture_contrat__c;
        retVal.conditionDeFermeture = cont.OpportuniteCommerciale__r.ContratOrigine__r.Condition_de_fermeture__c;
        retval.contratDorigine = cont.OpportuniteCommerciale__r.ContratOrigine__r.DKCodeSurContrat__c;
        retval.dateDeFinContratRemplace = cont.OpportuniteCommerciale__r.ContratOrigine__r.DateFin__c;
        //retVal.contrat = new wwwDalkiaFrReferentielContrat.contratCDC1();
        retVal.contrat = fillContratInfo(cont, 'renouveler');

        return retVal;
    }

    public static wwwDalkiaFrReferentielContrat.modifierContratRequete fillModifierContratRequete(Contrat__c cont, boolean avecService){
        wwwDalkiaFrReferentielContrat.modifierContratRequete retVal = new wwwDalkiaFrReferentielContrat.modifierContratRequete();
        retVal.contrat = new wwwDalkiaFrReferentielContrat.contratC1();
        retVal.contrat.proprietesContrat = new wwwDalkiaFrReferentielContrat.proprietesContratC1();
        retVal.contrat.proprietesContrat.DKCodeContrat = cont.DKCodeSurContrat__c != null ? cont.DKCodeSurContrat__c : '';
        retVal.contrat.proprietesContrat.libelle = cont.Name != null ? cont.Name : '';
        retVal.contrat.proprietesContrat.commentaire = cont.Commentaire__c != null ? cont.Commentaire__c : '';
        retVal.contrat.proprietesContrat.statutFacturation = cont.Statut_Facturation__c != null ? cont.Statut_Facturation__c : '';
        retVal.contrat.proprietesContrat.motifRejet = cont.MotifRejet__c != null ? cont.MotifRejet__c : '';
        retVal.contrat.proprietesContrat.formeJuridique = cont.FormeJuridique__c != null ? cont.FormeJuridique__c : '';
        retVal.contrat.proprietesContrat.langue = cont.Langue__c != null ? cont.Langue__c : '';
        retVal.contrat.proprietesContrat.devise = cont.Devise__c != null ? cont.Devise__c : '';
        retVal.contrat.proprietesContrat.numeroDossier = cont.Numdossier__c != null ? cont.Numdossier__c : '';
        retVal.contrat.proprietesContrat.estContratNational = cont.EstContratNational__c != null ? cont.EstContratNational__c : false;
        retVal.contrat.proprietesContrat.natureContrat = cont.NatureContrat__c != null ? cont.NatureContrat__c : '';
        retVal.contrat.proprietesContrat.provenanceContrat = cont.OrigineContrat__c != null ? cont.OrigineContrat__c : '';
        retVal.contrat.proprietesContrat.dateDeValidation = cont.Datevalidation__c;
        //retVal.contrat.proprietesContrat.motifDeFermeture = cont.Motif_fermeture_contrat__c != null ? cont.Motif_fermeture_contrat__c : '';
        //retVal.contrat.proprietesContrat.conditionDeFermeture = cont.Condition_de_fermeture__c != null ? cont.Condition_de_fermeture__c : '';
        //retVal.contrat.proprietesContrat.DateDeFin = cont.DateFin__c;
        retVal.contrat.proprietesContrat.reportingContrat = cont.ReportingContrat__c != null ? cont.ReportingContrat__c : '';
        List<CentreFinance__c> cf = [SELECT DkCode__c from CentreFinance__c where id = : cont.UOPiloteContrat__c];
        if(cf != null && cf.size() > 0) {
            retVal.contrat.proprietesContrat.UOPiloteContrat = cf[0].DkCode__c != null ? cf[0].DkCode__c : '';
        }

        //17/02/2023: C360-922 Added by Jimmy, TypeContrat__c n'est plus envoyé à la modif du contrat
        //retVal.contrat.proprietesContrat.typeContratFacturation = cont.TypeContrat__c != null ? cont.TypeContrat__c : '';
        //07-03-2022 Added by Jimmy US C360-655
        retVal.contrat.proprietesContrat.typeContrat = cont.NatureContratCadre__c != null ? cont.NatureContratCadre__c : '';
        //end US C360-655

        retVal.contrat.durees = new wwwDalkiaFrReferentielContrat.dureesC1();
        retVal.contrat.durees.dureeInitialeContrat = cont.DureeInitialeContrat__c != null ? Integer.valueOf(cont.DureeInitialeContrat__c) : 0;
        retVal.contrat.durees.reconductionFaitAutorisee = cont.ReconductionFaitAutorisee__c != null ? cont.ReconductionFaitAutorisee__c : false;
        retVal.contrat.durees.dateProchaineEcheance = cont.DateProchaineEcheance__c;
        retval.contrat.durees.nombreReconductionsPassees = cont.NombreReconductionsPassees__c != null ? Integer.valueOf(cont.NombreReconductionsPassees__c) : 0;
        retVal.contrat.durees.dateProchainPreavis = cont.DateProchainPreavis__c;
        retVal.contrat.durees.dateDerniereEcheance = cont.DateDeDerniereEcheance__c;
        retval.contrat.durees.typeReconduction = cont.TypeReconduction__c;
        retval.contrat.durees.dureeReconduction = cont.DureeReconduction__c != null ? Integer.valueOf(cont.DureeReconduction__c) : 0;
        retval.contrat.durees.nombreReconductionAutorise = cont.NombreReconductionsAutorisees__c != null ? Integer.valueOf(cont.NombreReconductionsAutorisees__c) : 0;
        retval.contrat.durees.dureePreavis = cont.DureePreavis__c != null ? Integer.valueOf(cont.DureePreavis__c) : 0;
        retval.contrat.durees.dureeProlongation = cont.DureeProlongationTotale__c != null ? Integer.valueOf(cont.DureeProlongationTotale__c) : 0;

        /*if(cont.DureeProlongationTotale__c == null){
            cont.DureeProlongationTotale__c = 0;
           }*/
        //retVal.contrat.durees.dureeProlongation = Integer.valueOf(cont.DureeProlongationTotale__c);
        if(avecService == true) {
            retVal.contrat.listeServices = new wwwDalkiaFrReferentielContrat.listeServicesC1();
            retVal.contrat.listeServices.service = new List<wwwDalkiaFrReferentielContrat.serviceC1>();

            //Added by Jimmy 08/02/2022 - CVS

            retVal.contrat.proprietesCvs = new wwwDalkiaFrReferentielContrat.proprietesCvsC1();

            retVal.contrat.proprietesCvs.natureOffre = cont.natureOffre__c != null ? cont.natureOffre__c : '';
            retVal.contrat.proprietesCvs.engagementEnergetique = cont.engagementEnergetique__c != null ? cont.engagementEnergetique__c : '';
            retVal.contrat.proprietesCvs.paiementDesEnergies = cont.paiementDesEnergies__c != null ? cont.paiementDesEnergies__c : '';
            retVal.contrat.proprietesCvs.niveauDeMaintenance = cont.niveauDeMaintenance__c != null ? cont.niveauDeMaintenance__c : '';
            //end CVS

            //13-1-2022 Commneted By Jimmy - CVS: the objects Service__c and LienContratService__c are deleted
            /*List<LienContratService__c> lienContSer = [SELECT id,PenalitesAssociees__c,PerimetreRealisation__c,Statut__c,Service__r.CodeService__c
                                                       FROM LienContratService__c
               WHERE Contrat__c =: cont.id];
               for(LienContratService__c lien : lienContSer){
                wwwDalkiaFrReferentielContrat.serviceC1 serviceObj = new wwwDalkiaFrReferentielContrat.serviceC1();
                serviceObj.service = lien.Service__r.CodeService__c != null ? lien.Service__r.CodeService__c : '';
                serviceObj.penalitesAssociees = lien.PenalitesAssociees__c != null ? lien.PenalitesAssociees__c : false;
               if(lien.Statut__c == 'ACTIF'){
                    serviceObj.statutLienService =  true;
               }
               else{
                    serviceObj.statutLienService =  false;
                }
                serviceObj.perimetreRealisation = lien.PerimetreRealisation__c != null ? lien.Service__r.CodeService__c : '';
                retVal.contrat.listeServices.service.add(serviceObj);
               }*/
            //end CVS

        } else {
            retVal.contrat.field_order_type_info = removeListValue(retVal.contrat.field_order_type_info, 'listeServices');
        }

        List<Contrat__c> contAcc = [SELECT NomPartenaire__r.DkCodeAdressePrincipale__c, NomPartenaire__r.Mode_Reglement__c, SocieteVenteLookup__r.DkCodeAdressePrincipale__c, SocieteVenteLookup__r.Mode_Reglement__c
                                    FROM Contrat__c
                                    WHERE id = : cont.id];
        retVal.contrat.listePartenaires = new wwwDalkiaFrReferentielContrat.listePartenairesC1();
        retVal.contrat.listePartenaires.partenaire = new List<wwwDalkiaFrReferentielContrat.partenaireC1>();
        //retVal.contrat.listePartenaires.partenaire.partenaireC1.field_order_type_info = removeListValue(retVal.contrat.listePartenaires.partenaire.partenaireC1.field_order_type_info,'etablissement');
        wwwDalkiaFrReferentielContrat.partenaireC1 partenaireObjContractant = new wwwDalkiaFrReferentielContrat.partenaireC1();
        partenaireObjContractant.field_order_type_info = removeListValue(partenaireObjContractant.field_order_type_info, 'modeReglement');
        if(contAcc != null && contAcc.size() > 0) {
            partenaireObjContractant.adressePartenaire = contAcc[0].NomPartenaire__r.DkCodeAdressePrincipale__c != null ? contAcc[0].NomPartenaire__r.DkCodeAdressePrincipale__c : '';
        }
        partenaireObjContractant.rolePartenaire = 'SIGN';
        //partenaireObjContractant.modeReglement = contAcc.NomPartenaire__r.Mode_Reglement__c != null ? contAcc.NomPartenaire__r.Mode_Reglement__c : '';
        partenaireObjContractant.statutLienPartenaire = true;

        /*partenaireObjContractant.listeContacts = new wwwDalkiaFrReferentielContrat.listeContactsC1();
           partenaireObjContractant.listeContacts.contact = new List<wwwDalkiaFrReferentielContrat.contactC1>();
           wwwDalkiaFrReferentielContrat.contactC1 contactObjContractant = new wwwDalkiaFrReferentielContrat.contactC1();
           contactObjContractant.contact = cont.Contact_du_partenaire__c;
           contactObjContractant.roleContact = cont.RoleContact__c;
           contactObjContractant.accesPSV = cont.AccesPSV__c;
           contactObjContractant.statutLienContact = cont.Statut_Lien_Contact__c;
           partenaireObjContractant.listeContacts.contact.add(contactObjContractant);*/
        retVal.contrat.listePartenaires.partenaire.add(partenaireObjContractant);

        wwwDalkiaFrReferentielContrat.partenaireC1 partenaireObjPrestataire = new wwwDalkiaFrReferentielContrat.partenaireC1();
        partenaireObjPrestataire.field_order_type_info = removeListValue(partenaireObjPrestataire.field_order_type_info, 'modeReglement');
        if(contAcc != null && contAcc.size() > 0) {
            partenaireObjPrestataire.adressePartenaire = contAcc[0].SocieteVenteLookup__r.DkCodeAdressePrincipale__c != null ? contAcc[0].SocieteVenteLookup__r.DkCodeAdressePrincipale__c : '';
        }
        partenaireObjPrestataire.rolePartenaire = 'PRST';
        //partenaireObjPrestataire.modeReglement = contAcc.SocieteVenteLookup__r.Mode_Reglement__c != null ? contAcc.SocieteVenteLookup__r.Mode_Reglement__c : '';
        partenaireObjPrestataire.statutLienPartenaire = true;

        /*partenaireObjPrestataire.listeContacts = new wwwDalkiaFrReferentielContrat.listeContactsC1();
           partenaireObjPrestataire.listeContacts.contact = new List<wwwDalkiaFrReferentielContrat.contactC1>();
           wwwDalkiaFrReferentielContrat.contactC1 contactObjPrestataire = new wwwDalkiaFrReferentielContrat.contactC1();
           contactObjPrestataire.contact = cont.Contact_du_partenaire__c;
           contactObjPrestataire.roleContact = cont.RoleContact__c;
           contactObjPrestataire.accesPSV = cont.AccesPSV__c;
           contactObjPrestataire.statutLienContact = cont.Statut_Lien_Contact__c;
           partenaireObjPrestataire.listeContacts.contact.add(contactObjPrestataire);*/
        retVal.contrat.listePartenaires.partenaire.add(partenaireObjPrestataire);

        // select ecosysteme
        /*for(EcosystemePartenaire__c ecoSys : [SELECT id,name,Contrat__c,TypeRelation__c,PartenaireLie__c,Statut__c,PartenaireLie__r.DkCodeAdressePrincipale__c,
                                              PartenaireLie__r.Mode_Reglement__c
                                              FROM EcosystemePartenaire__c
                                              WHERE contrat__c =:cont.id
                                              AND (TypeRelation__c = 'REPR_1' OR TypeRelation__c = 'REPR_2'
                                                   OR TypeRelation__c = 'FACT_1' OR TypeRelation__c = 'FACT_2'
                                                   OR TypeRelation__c = 'DEST' OR TypeRelation__c = 'PRSC')])
           {
            String role = ecoSys.TypeRelation__c;
            if(role.contains('FACT')){
                role = 'FACT';
            }
            if(role.contains('REPR')){
                role = 'REPR';
            }
            wwwDalkiaFrReferentielContrat.partenaireC1 partenaireObjEcoSys = new wwwDalkiaFrReferentielContrat.partenaireC1();
            if(ecoSys.PartenaireLie__c!=null){
                partenaireObjEcoSys.adressePartenaire = ecoSys.PartenaireLie__r.DkCodeAdressePrincipale__c != null ? ecoSys.PartenaireLie__r.DkCodeAdressePrincipale__c : '';
                partenaireObjEcoSys.modeReglement = ecoSys.PartenaireLie__r.Mode_Reglement__c != null ? ecoSys.PartenaireLie__r.Mode_Reglement__c : '';
            }
            partenaireObjEcoSys.rolePartenaire = role;
            if(ecoSys.Statut__c!=null && ecoSys.Statut__c=='Actif'){
                partenaireObjEcoSys.statutLienPartenaire = true;
            }
            else{
                partenaireObjEcoSys.statutLienPartenaire = false;
            }
            retVal.contrat.listePartenaires.partenaire.add(partenaireObjEcoSys);

           }*/

        retVal.contrat.listeResponsables = new wwwDalkiaFrReferentielContrat.listeResponsablesC1();
        retVal.contrat.listeResponsables.responsable = new List<wwwDalkiaFrReferentielContrat.responsableC1>();
        wwwDalkiaFrReferentielContrat.responsableC1 responsableObj = new wwwDalkiaFrReferentielContrat.responsableC1();
        List<User> resUser = [ SELECT id, name, DkCode__c
                               FROM User
                               WHERE Id = : cont.OwnerId limit 1];
        if(resUser != null && resUser.size() > 0) {
            responsableObj.responsableContrat = resUser[0].DkCode__c != null ? resUser[0].DkCode__c : '';
        }
        responsableObj.perimetreResponsable = 'ROL01';
        responsableObj.statutLienResponsable = true;//cont.Statut_Lien_responsable__c;
        retVal.contrat.listeResponsables.responsable.add(responsableObj);
        system.debug('listeResponsables ' + retVal.contrat.listeResponsables.responsable);
        retVal.contrat.metadonneesContrat = new wwwDalkiaFrReferentielContrat.metadonneesC1();
        retVal.contrat.metadonneesContrat.updateDate = cont.LastModifiedDate;
        if(cont.LastModifiedById != null) {
            retVal.contrat.metadonneesContrat.updateId = label.userC360;
        }
        retVal.contrat.metadonneesContrat.validationDate = cont.ValidationDate__c;
        if(cont.Validation_Id__c != null) {
            List<User> usr = [ select id, name, ReferentielId__c from user where id = : cont.Validation_Id__c limit 1];
            if(usr != null && usr.size() > 0) {
                retVal.contrat.metadonneesContrat.validationId = usr[0].ReferentielId__c != null ? usr[0].ReferentielId__c : '';
            }
        }

        return retVal;
    }

    public static wwwDalkiaFrReferentielContrat.contratCDC1 fillContratInfo(Contrat__c cont, String flux){
        wwwDalkiaFrReferentielContrat.contratCDC1 retVal = new wwwDalkiaFrReferentielContrat.contratCDC1();
        retVal.proprietesContrat = new wwwDalkiaFrReferentielContrat.proprietesContratCDC1();
        retVal.proprietesContrat.libelle = cont.Name;
        retval.proprietesContrat.commentaire = cont.Commentaire__c;
        //retval.proprietesContrat.statutContrat = cont.Statut__c;
        retval.proprietesContrat.categorieContrat = cont.CategorieContrat__c;
        retval.proprietesContrat.formeJuridique = cont.FormeJuridique__c;
        retval.proprietesContrat.langue = cont.Langue__c;
        retval.proprietesContrat.devise = cont.Devise__c;
        retval.proprietesContrat.numeroDossier = cont.Numdossier__c;
        retval.proprietesContrat.estContratNational = cont.EstContratNational__c;
        retval.proprietesContrat.natureContrat = cont.NatureContrat__c;
        retval.proprietesContrat.provenanceContrat = cont.OrigineContrat__c;
        retval.proprietesContrat.dateDeValidation = system.now();//cont.Datevalidation__c;
        retval.proprietesContrat.estContratCadre = cont.EstContratcadre__c;
        retval.proprietesContrat.reportingContrat = cont.ReportingContrat__c;
        List<CentreFinance__c> cf = [SELECT id, DkCode__c FROM CentreFinance__c where id = : cont.UOPiloteContrat__c];
        if(cf != null && cf.size() > 0) {
            retval.proprietesContrat.UOPiloteContrat = cf[0].DkCode__c;
        }
        retval.proprietesContrat.typeContratFacturation = cont.TypeContrat__c;
        //07-03-2022 Added by Jimmy US C360-655
        retval.proprietesContrat.typeContrat = cont.NatureContratCadre__c;
        //end US C360-655
        if(cont.ContratCadre__c != null) {
            retVal.contratCadre = new wwwDalkiaFrReferentielContrat.contratCadreCDC1();
            List<Contrat__c> contratCadre = [SELECT id, DkCodesurcontrat__c FROM Contrat__c where id = : cont.ContratCadre__c];
            if(contratCadre != null && contratCadre.size() > 0) {
                retval.contratCadre.contratCadre = contratCadre[0].DkCodesurcontrat__c;
            }
        }
        List<Document_Contractuel__c> listDocs = [Select id, NatureDocument__c, StatutDocument__c, Contrat__c, /*ReferenceDocument__c,*/ Name, TitreDocument__c, DateStockage__c, DateSignature__c,
                                                  createdDate, ReferenceDuree__c, DatePriseEffet__c, ownerId,
                                                  contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c, NiveauDeConfidentialite__c, Commentaire__c, Titre_complet_du_document__c
                                                  from Document_Contractuel__c
                                                  where Contrat__c = : cont.id];
        Set<String> docOwnerIds = new Set<String>();
        Map<String, String> mapOnwerReferentiel = new Map<String, String>();

        Set<id> docIds = new Set<id>();

        for(Document_Contractuel__c doc : listDocs) {
            docOwnerIds.add(doc.OwnerId);
            docIds.add(doc.Id);
        }
        List<User> listUsers = [SELECT id, name, ReferentielId__c
                                FROM user
                                WHERE id in : docOwnerIds];
        for(User usr : listUsers) {
            mapOnwerReferentiel.put(usr.id, usr.ReferentielId__c);
        }
        retVal.listeDocuments = new wwwDalkiaFrReferentielContrat.listeDocumentsCDC1();
        retVal.listeDocuments.document = new List<wwwDalkiaFrReferentielContrat.documentCDC1>();
        Set<Id> cdlIds = new Set<Id>();
        Map<Id, Id> mapCDL = new Map<Id, Id>();
        Map<Id, ContentVersion> mapCV = new Map<Id, ContentVersion>();
        if(!test.isRunningTest()) {
            List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                FROM ContentDocumentLink
                                                WHERE LinkedEntityId in : docIds];

            for(ContentDocumentLink cdl : lstCDL) {
                mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId); cdlIds.add(cdl.ContentDocumentId);
            }

            List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                          FROM ContentVersion
                                          WHERE ContentDocumentId in : cdlIds];

            for(ContentVersion cv : lstCV) {
                mapCV.put(cv.ContentDocumentId, cv);
            }
        }
        for(Document_Contractuel__c doc : listDocs) {
            wwwDalkiaFrReferentielContrat.documentCDC1 documentObj = new wwwDalkiaFrReferentielContrat.documentCDC1();
            documentObj.referenceDuree = doc.ReferenceDuree__c;
            documentObj.natureDocument = doc.NatureDocument__c;
            documentObj.origineDocument = doc.contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c;
            //documentObj.referenceDocument = doc.ReferenceDocument__c; Rita
            documentObj.titreDocument = doc.Titre_complet_du_document__c;
            documentObj.dateSignature = doc.DateSignature__c;
            documentObj.datePriseEffet = doc.DatePriseEffet__c;
            documentObj.dateStockage = doc.DateStockage__c;
            documentObj.statutDocument = doc.StatutDocument__c;
            documentObj.metadonneesDocument = new wwwDalkiaFrReferentielContrat.metadonneesCDC1();
            documentObj.metadonneesDocument.creationDate = cont.CreatedDate;
            /*
               if(doc.OwnerId != null && mapOnwerReferentiel.keySet().Contains(doc.OwnerId) && mapOnwerReferentiel.get(doc.OwnerId) != null) {
                documentObj.metadonneesDocument.creationId = mapOnwerReferentiel.get(doc.OwnerId);
               }
             */
            documentObj.metadonneesDocument.creationId = Label.userC360;
            documentObj.metadonneesDocument.updateDate = cont.CreatedDate;
            documentObj.niveauConfidentialite = doc.NiveauDeConfidentialite__c;
            documentObj.commentaireDocument = doc.commentaire__c;

            if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null) {
                documentObj.IdDocumentC360 = mapCV.get(mapCDL.get(doc.Id)).Id; documentObj.formatScan = mapCV.get(mapCDL.get(doc.Id)).FileType; documentObj.tailleScan = mapCV.get(mapCDL.get(doc.Id)).ContentSize + '';
            }

            //documentObj.metadonneesDocument.updateId = ;
            //documentObj.metadonneesDocument.validationDate =;
            //documentObj.metadonneesDocument.validationId = ;*/
            retVal.listeDocuments.document.add(documentObj);
        }
        retVal.durees = new wwwDalkiaFrReferentielContrat.dureesCDC1();
        if(String.isNotBlank(String.valueOf(cont.DureeInitialeContrat__c))) {
            retVal.durees.dureeInitialeContrat = Integer.valueOf(cont.DureeInitialeContrat__c);
        } else {
            retVal.durees.dureeInitialeContrat = 0;
        }
        retVal.durees.dureeInitialeContrat = cont.DureeInitialeContrat__c != null ? Integer.valueOf(cont.DureeInitialeContrat__c) : 0;
        retVal.durees.typeReconduction = cont.TypeReconduction__c;
        retVal.durees.dureeReconduction = cont.DureeReconduction__c != null ? Integer.valueOf(cont.DureeReconduction__c) : 0;
        retVal.durees.dureePreavis = cont.DureePreavis__c != null ? Integer.valueOf(cont.DureePreavis__c) : 0;
        retVal.durees.nombreReconductionAutorise = cont.NombreReconductionsAutorisees__c != null ? Integer.valueOf(cont.NombreReconductionsAutorisees__c) : 0;
        retVal.durees.reconductionFaitAutorisee = cont.ReconductionFaitAutorisee__c;
        retVal.durees.dateProchaineEcheance = cont.DateProchaineEcheance__c;
        retval.durees.nombreReconductionsPassees = cont.NombreReconductionsPassees__c != null ? Integer.valueOf(cont.NombreReconductionsPassees__c) : 0;
        retVal.durees.dateProchainPreavis = cont.DateProchainPreavis__c;
        retVal.durees.dateDerniereEcheance = cont.DateDeDerniereEcheance__c;

        /*retVal.listeResumes = new wwwDalkiaFrReferentielContrat.listeResumesCDC1();
           retVal.listeResumes.resume = new List<wwwDalkiaFrReferentielContrat.resumeCDC1>();
           wwwDalkiaFrReferentielContrat.resumeCDC1 resumeObj = new wwwDalkiaFrReferentielContrat.resumeCDC1();
           resumeObj.parametrePortailClient = cont.ParametrePortailClient__c;
           resumeObj.precisionParametre = cont.PrecisionParametre__c;
           resumeObj.informationComplementaire = cont.InformationComplementaire__c;
           resumeObj.valeurContractuelle = Double.valueOf(cont.ValeurContractuelle__c);
           resumeObj.uniteValeurContractuelle = cont.UniteValeurContractuelle__c;
           retVal.listeResumes.resume.add(resumeObj);*/

        retVal.listeServices = new wwwDalkiaFrReferentielContrat.listeServicesCDC1();
        retVal.listeServices.service = new List<wwwDalkiaFrReferentielContrat.serviceCDC1>();

        //13-1-2022 Commneted By Jimmy - CVS: the objects Service__c and LienContratService__c are deleted
        /*List<LienContratService__c> lienContSer = [SELECT id,PenalitesAssociees__c,PerimetreRealisation__c,Statut__c,Service__r.CodeService__c
                                                   FROM LienContratService__c
           WHERE Contrat__c =: cont.id];
           for(LienContratService__c lien : lienContSer){
            wwwDalkiaFrReferentielContrat.serviceCDC1 serviceObj = new wwwDalkiaFrReferentielContrat.serviceCDC1();
            serviceObj.service = lien.Service__r.CodeService__c;
            serviceObj.penalitesAssociees = lien.PenalitesAssociees__c;
           if(lien.Statut__c == 'ACTIF'){
                serviceObj.statutLienService =  true;
           }
           else{
                serviceObj.statutLienService =  false;
            }
            serviceObj.perimetreRealisation = lien.PerimetreRealisation__c;
            retVal.listeServices.service.add(serviceObj);
           }*/
        //end CVS

        //Added by Jimmy 08/02/2022 - CVS

        retVal.proprietesCvs = new wwwDalkiaFrReferentielContrat.proprietesCvsCDC1();

        retVal.proprietesCvs.natureOffre = cont.natureOffre__c != null ? cont.natureOffre__c : '';
        retVal.proprietesCvs.engagementEnergetique = cont.engagementEnergetique__c != null ? cont.engagementEnergetique__c : '';
        retVal.proprietesCvs.paiementDesEnergies = cont.paiementDesEnergies__c != null ? cont.paiementDesEnergies__c : '';
        retVal.proprietesCvs.niveauDeMaintenance = cont.niveauDeMaintenance__c != null ? cont.niveauDeMaintenance__c : '';
        //end CVS

        //serviceObj.field_order_type_info = removeListValue(serviceObj.field_order_type_info,'listePrestations');
        Contrat__c contAcc = [SELECT NomPartenaire__r.DkCodeAdressePrincipale__c, NomPartenaire__r.Mode_Reglement__c, SocieteVenteLookup__r.DkCodeAdressePrincipale__c, SocieteVenteLookup__r.Mode_Reglement__c
                              FROM Contrat__c
                              WHERE id = : cont.id];
        retVal.listePartenaires = new wwwDalkiaFrReferentielContrat.listePartenairesCDC1();
        retVal.listePartenaires.partenaire = new List<wwwDalkiaFrReferentielContrat.partenaireCDC1>();
        wwwDalkiaFrReferentielContrat.partenaireCDC1 partenaireObjContractant = new wwwDalkiaFrReferentielContrat.partenaireCDC1();
        partenaireObjContractant.adressePartenaire = contAcc.NomPartenaire__r.DkCodeAdressePrincipale__c;
        partenaireObjContractant.rolePartenaire = 'SIGN';
        //partenaireObjContractant.modeReglement = contAcc.NomPartenaire__r.Mode_Reglement__c;
        partenaireObjContractant.statutLienPartenaire = true;

        /*partenaireObjContractant.listeContacts = new wwwDalkiaFrReferentielContrat.listeContactsCDC1();
           partenaireObjContractant.listeContacts.contact = new List<wwwDalkiaFrReferentielContrat.contactCDC1>();
           wwwDalkiaFrReferentielContrat.contactCDC1 contactObjContractant = new wwwDalkiaFrReferentielContrat.contactCDC1();
           contactObjContractant.contact = cont.Contact_du_partenaire__c;
           contactObjContractant.roleContact = cont.RoleContact__c;
           contactObjContractant.accesPSV = cont.AccesPSV__c;
           contactObjContractant.statutLienContact = cont.Statut_Lien_Contact__c;
           partenaireObjContractant.listeContacts.contact.add(contactObjContractant);
         */
        retVal.listePartenaires.partenaire.add(partenaireObjContractant);
        wwwDalkiaFrReferentielContrat.partenaireCDC1 partenaireObjPrestataire = new wwwDalkiaFrReferentielContrat.partenaireCDC1();
        partenaireObjPrestataire.adressePartenaire = contAcc.SocieteVenteLookup__r.DkCodeAdressePrincipale__c;
        partenaireObjPrestataire.rolePartenaire = 'PRST';
        //partenaireObjPrestataire.modeReglement = contAcc.SocieteVenteLookup__r.Mode_Reglement__c;
        partenaireObjPrestataire.statutLienPartenaire = true;
        /*partenaireObjPrestataire.listeContacts = new wwwDalkiaFrReferentielContrat.listeContactsCDC1();
           partenaireObjPrestataire.listeContacts.contact = new List<wwwDalkiaFrReferentielContrat.contactCDC1>();
           wwwDalkiaFrReferentielContrat.contactCDC1 contactObjPrestataire = new wwwDalkiaFrReferentielContrat.contactCDC1();
           contactObjPrestataire.contact = cont.Contact_du_partenaire__c;
           contactObjPrestataire.roleContact = cont.RoleContact__c;
           contactObjPrestataire.accesPSV = cont.AccesPSV__c;
           contactObjPrestataire.statutLienContact = cont.Statut_Lien_Contact__c;
           partenaireObjPrestataire.listeContacts.contact.add(contactObjPrestataire);*/
        retVal.listePartenaires.partenaire.add(partenaireObjPrestataire);

        // select ecosysteme a faire
        for(EcosystemePartenaire__c ecoSys : [SELECT id, name, Contrat__c, TypeRelation__c, PartenaireLie__c, Statut__c, PartenaireLie__r.DkCodeAdressePrincipale__c,
                                              PartenaireLie__r.Mode_Reglement__c
                                              FROM EcosystemePartenaire__c
                                              WHERE contrat__c = : cont.id
                                              AND (TypeRelation__c = 'REPR_1' OR TypeRelation__c = 'REPR_2'
                                                   OR TypeRelation__c = 'FACT_1' OR TypeRelation__c = 'FACT_2'
                                                   OR TypeRelation__c = 'DEST' OR TypeRelation__c = 'PRSC')]) {
            String role = ecoSys.TypeRelation__c;
            if(role.contains('FACT')) {
                role = 'FACT';
            }
            if(role.contains('REPR')) {
                role = 'REPR';
            }
            wwwDalkiaFrReferentielContrat.partenaireCDC1 partenaireObjEcoSys = new wwwDalkiaFrReferentielContrat.partenaireCDC1();
            if(ecoSys.PartenaireLie__c != null) {
                partenaireObjEcoSys.adressePartenaire = ecoSys.PartenaireLie__r.DkCodeAdressePrincipale__c;
                partenaireObjEcoSys.modeReglement = ecoSys.PartenaireLie__r.Mode_Reglement__c;
            }
            partenaireObjEcoSys.rolePartenaire = role;
            if(ecoSys.Statut__c != null && ecoSys.Statut__c == 'Actif') {
                partenaireObjEcoSys.statutLienPartenaire = true;
            } else {
                partenaireObjEcoSys.statutLienPartenaire = false;
            }
            retVal.listePartenaires.partenaire.add(partenaireObjEcoSys);

        }

        if(String.isNotBlank(cont.Affaire__c)) {
            retVal.listeAffaires = new wwwDalkiaFrReferentielContrat.listeAffairesCDC1();
            retVal.listeAffaires.affaire = new List<wwwDalkiaFrReferentielContrat.affaireCDC1>();
            wwwDalkiaFrReferentielContrat.affaireCDC1 affaireObj = new wwwDalkiaFrReferentielContrat.affaireCDC1();
            affaireObj.affaire = cont.Affaire__c;
            affaireObj.statutLienAffaire = cont.Statut_Lien_Affaire__c;
            retVal.listeAffaires.affaire.add(affaireObj);
        } else {
            retVal.field_order_type_info = removeListValue(retVal.field_order_type_info, 'listeAffaires');
        }
        retVal.field_order_type_info = removeListValue(retVal.field_order_type_info, 'listeProjetsFinance');
        retVal.listeProjetsFinance = new wwwDalkiaFrReferentielContrat.listeProjetsFinanceCDC1();
        retVal.listeProjetsFinance.projetFinance = new List<wwwDalkiaFrReferentielContrat.projetFinanceCDC1>();
        wwwDalkiaFrReferentielContrat.projetFinanceCDC1 projetFinanceObj = new wwwDalkiaFrReferentielContrat.projetFinanceCDC1();
        projetFinanceObj.tacheFinance = 'GL0044220A';// a revoir champ
        projetFinanceObj.projetFinance = cont.Projet_Finance__c;
        projetFinanceObj.statutLienTF = true;
        retVal.listeProjetsFinance.projetFinance.add(projetFinanceObj);

        retVal.listeResponsables = new wwwDalkiaFrReferentielContrat.listeResponsablesCDC1();
        retVal.listeResponsables.responsable = new List<wwwDalkiaFrReferentielContrat.responsableCDC1>();
        wwwDalkiaFrReferentielContrat.responsableCDC1 responsableObj = new wwwDalkiaFrReferentielContrat.responsableCDC1();
        List<User> resUser = [ SELECT id, name, DkCode__c
                               FROM User
                               WHERE Id = : cont.OwnerId];
        if(resUser != null && resUser.size() > 0) {
            responsableObj.responsableContrat = resUser[0].DkCode__c;
        }
        responsableObj.perimetreResponsable = 'ROL01';
        responsableObj.statutLienResponsable = true;
        retVal.listeResponsables.responsable.add(responsableObj);

        retVal.numerotationContrat = new wwwDalkiaFrReferentielContrat.numerotationContratCDC1();
        retVal.numerotationContrat.applicationSource = cont.Applicationsourcecontrat__c;
        retVal.numerotationContrat.codeSource = cont.NumeroContrat__c;
        //retVal.field_order_type_info = removeListValue(retVal.field_order_type_info,'numerotationContrat');
        retVal.metadonneesContrat = new wwwDalkiaFrReferentielContrat.metadonneesCDC1();
        if(cont.CreatedById != null) {
            retVal.metadonneesContrat.creationId = label.userC360;
        }
        retVal.metadonneesContrat.creationDate = cont.CreatedDate;
        retVal.metadonneesContrat.updateDate = cont.LastModifiedDate;
        if(cont.LastModifiedById != null) {
            retVal.metadonneesContrat.updateId = label.userC360;
        }
        retVal.metadonneesContrat.validationDate = cont.ValidationDate__c;
        if(cont.Validation_Id__c != null) {
            List<User> usr = [ select id, name, ReferentielId__c from user where id = : cont.Validation_Id__c ];
            if(usr != null && usr.size() > 0) {
                retVal.metadonneesContrat.validationId = usr[0].ReferentielId__c;
            }
        }

        return retVal;
    }

    public static webservicelog__c createWsLog(String Id, String flux){
        List<Document_Contractuel__c> listDocs = [Select id, NatureDocument__c, StatutDocument__c, Contrat__c, /*ReferenceDocument__c,*/ Name, TitreDocument__c, DateStockage__c, DateSignature__c,
                                                  createdDate, ReferenceDuree__c, DatePriseEffet__c, ownerId,
                                                  contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c, NiveauDeConfidentialite__c, Commentaire__c
                                                  from Document_Contractuel__c
                                                  where Contrat__c = : id];

        Map<Id, ContentVersion> mapCV = new Map<Id, ContentVersion>();
        Map<Id, Id> mapCDL = new Map<Id, Id>();
        if(!test.isRunningTest()) {
            Set<id> docContIds = new Set<id>();
            for(Document_contractuel__c doc : listDocs) {
                docContIds.add(doc.Id);
            }

            List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                FROM ContentDocumentLink
                                                WHERE LinkedEntityId in : docContIds];

            Set<Id> cdlIds = new Set<Id>();
            for(ContentDocumentLink cdl : lstCDL) {
                mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId); cdlIds.add(cdl.ContentDocumentId);
            }

            List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                          FROM ContentVersion
                                          WHERE ContentDocumentId in : cdlIds];

            for(ContentVersion cv : lstCV) {
                mapCV.put(cv.ContentDocumentId, cv);
            }
        }

        WebserviceLog__c ws = new WebserviceLog__c();
        if(listDocs != null && listDocs.size() > 0) {
            String wsDoc = '';

            for(Document_contractuel__c doc : listDocs) {
                wsDoc = wsDoc + json.serialize(doc);
                if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null) {
                    wsDoc = wsDoc + '[Information Scan: scanId=' + mapCV.get(mapCDL.get(doc.Id)).Id + ', ContentSize=' + mapCV.get(mapCDL.get(doc.Id)).ContentSize + ', FileType=' + mapCV.get(mapCDL.get(doc.Id)).FileType + ', relatedDocContractuel=' + doc.Id + ']';
                }
            }

            if(wsDoc.length() > 32700) {
                ws.Request__c = wsDoc.substring(0, 32700);
            } else {
                ws.Request__c = wsDoc;
            }
            if(flux == 'renouveler') {
                ws.Type__c = 'RenouvelerContratSortant - Document';
            } else {
                ws.Type__c = 'CreerContratSortant - Document';
            }
            ws.flux__c = 'sortant';
            ws.CodeRetour__c = 'OK';
        }

        return ws;
    }

    public static Contrat__c getCreerContratRequete(wwwDalkiaFrReferentielContrat.creerContratReponse retVal, String contratID, List<Document_contractuel__c> docListOld){
        Map<String, Id> mapNameDoc = new Map<String, Id>();
        for(Document_contractuel__c doc : docListOld) {
            mapNameDoc.put(doc.TitreDocument__c, doc.id);
        }
        Contrat__c cont = new Contrat__c();
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = retVal + '';
        ws.Type__c = 'creerContract';
        //retVal.informationsRetour.messageRetour;
        ws.StatusCode__c = retVal.informationsRetour.codeRetour;
        if(retval.contrat != null) {
            if(retval.contrat.proprietesContrat != null) {
                cont.DKCodeSurContrat__c = retval.contrat.proprietesContrat.DKCodeContrat;
                if(retval.contrat.proprietesContrat.libelle.length() > 80) {
                    cont.Name = retval.contrat.proprietesContrat.libelle.substring(0, 80);
                } else {
                    cont.Name = retval.contrat.proprietesContrat.libelle;
                }
                cont.Commentaire__c = retval.contrat.proprietesContrat.commentaire;
                //cont.ControleContrat__c = retval.contrat.proprietesContrat.controleContrat;
                //cont.Statut__c = retval.contrat.proprietesContrat.statutContrat; //ne pas sauveguarder dans SF, ça sera mis a jour par le flux entrant
                //cont.Staut_Facturation__c = retval.contrat.proprietesContrat.statutFacturation;
                cont.MotifRejet__c = retval.contrat.proprietesContrat.motifRejet;
                cont.StatutServices__c = retval.contrat.proprietesContrat.statutServices;
                cont.CategorieContrat__c     = retval.contrat.proprietesContrat.categorieContrat;
                cont.Interco__c = retval.contrat.proprietesContrat.interco;
                cont.FormeJuridique__c = retval.contrat.proprietesContrat.formeJuridique;
                cont.Langue__c = retval.contrat.proprietesContrat.langue;
                cont.Devise__c = retval.contrat.proprietesContrat.devise;
                cont.Numdossier__c = retval.contrat.proprietesContrat.numeroDossier;
                //cont.ContratOrigine__c = retval.contrat.proprietesContrat.contratDorigine;
                cont.EstContratNational__c = retval.contrat.proprietesContrat.estContratNational;
                cont.NatureContrat__c = retval.contrat.proprietesContrat.natureContrat;
                cont.OrigineContrat__c = retval.contrat.proprietesContrat.provenanceContrat;
                //cont.Datevalidation__c = retval.contrat.proprietesContrat.dateDeValidation;
                DateTime DateValidationOriginal = retval.contrat.proprietesContrat.dateDeValidation;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.Datevalidation__c = DateValidationConverted;
                }
                cont.Motif_fermeture_contrat__c = retval.contrat.proprietesContrat.motifDeFermeture;
                cont.Condition_de_fermeture__c = retval.contrat.proprietesContrat.conditionDeFermeture;
                //cont.DateFin__c = retval.contrat.proprietesContrat.dateDeFin;
                DateTime DateFinOriginal = retval.contrat.proprietesContrat.dateDeFin;
                if(DateFinOriginal != null) {
                    Date DateFinConverted = date.newinstance(DateFinOriginal.year(), DateFinOriginal.month(), DateFinOriginal.day());
                    cont.DateFin__c = DateFinConverted;
                }
                cont.EstContratcadre__c = retval.contrat.proprietesContrat.estContratCadre;
                cont.ReportingContrat__c = retval.contrat.proprietesContrat.reportingContrat;
                //CentreFinance__c cf = [SELECT DkCode__c from CentreFinance__c where id =: retval.contrat.proprietesContrat.UOPiloteContrat];
                //cont.UOPiloteContrat__c = cf.DkCode__c;
                cont.TypeContrat__c = retval.contrat.proprietesContrat.typeContratFacturation;
                //07-03-2022 Added by Jimmy US C360-655
                cont.NatureContratCadre__c = retval.contrat.proprietesContrat.typeContrat;
                //end US C360-655
            }

            //Added by Jimmy 08/02/2022 - CVS
            if(retval.contrat.proprietesCvs != null) {
                cont.natureOffre__c = retval.contrat.proprietesCvs.natureOffre;
                cont.engagementEnergetique__c = retval.contrat.proprietesCvs.engagementEnergetique;
                cont.paiementDesEnergies__c = retval.contrat.proprietesCvs.paiementDesEnergies;
                cont.niveauDeMaintenance__c = retval.contrat.proprietesCvs.niveauDeMaintenance;
            }
            //end CVS

            if(retval.contrat.contratCadre != null) {
                List<Contrat__c> contratCadre = [SELECT id, DkCodesurcontrat__c FROM Contrat__c where DkCodesurcontrat__c = : retval.contrat.contratCadre.contratCadre];
                if(contratCadre != null && contratCadre.size() > 0) {
                    cont.ContratCadre__c = contratCadre[0].id;
                }
            }
            if(retval.contrat.listeDocuments != null) {
                List<Document_contractuel__c> docList = new List<Document_contractuel__c>();
                Set<String> userIds = new Set<String>();
                for(wwwDalkiaFrReferentielContrat.document docloop : retval.contrat.listeDocuments.document) {
                    if(String.isNotBlank(docloop.metadonneesDocument.creationId)) {
                        userIds.add(docloop.metadonneesDocument.creationId);
                    }
                    if(String.isNotBlank(docloop.metadonneesDocument.UpdateId)) {
                        userIds.add(docloop.metadonneesDocument.UpdateId);
                    }
                    if(String.isNotBlank(docloop.metadonneesDocument.ValidationId)) {
                        userIds.add(docloop.metadonneesDocument.ValidationId);
                    }
                }
                List<User> userDoc = new List<User>();
                userDoc = [Select id, name, ReferentielId__c from user where ReferentielId__c in : userIds];
                for(wwwDalkiaFrReferentielContrat.document docloop : retval.contrat.listeDocuments.document) {
                    Document_contractuel__c doc = new Document_contractuel__c();
                    doc.DateDeclenchement__c = System.now();
                    doc.SynchronisationDate__c = System.now();
                    doc.NumeroPiece__c = docLoop.numeroPiece;
                    doc.ReferenceDuree__c = docLoop.referenceDuree;
                    doc.NatureDocument__c = docLoop.natureDocument;
                    doc.contrat__c = contratID;
                    doc.TitreDocument__c = docLoop.titreDocument;
                    if(doc.TitreDocument__c != null && mapNameDoc.keyset().contains(doc.TitreDocument__c) && mapNameDoc.get(doc.TitreDocument__c) != null) {
                        doc.id = mapNameDoc.get(doc.TitreDocument__c);
                    }
                    DateTime dateSignatureOriginal = docLoop.dateSignature;
                    if(dateSignatureOriginal != null) {
                        Date dateSignatureConverted = date.newinstance(dateSignatureOriginal.year(), dateSignatureOriginal.month(), dateSignatureOriginal.day());//
                        doc.DateSignature__c = dateSignatureConverted;
                    }
                    DateTime datePriseEffetOriginal = docLoop.datePriseEffet;
                    if(datePriseEffetOriginal != null) {
                        Date datePriseEffetConverted = date.newinstance(datePriseEffetOriginal.year(), datePriseEffetOriginal.month(), datePriseEffetOriginal.day());
                        doc.DatePriseEffet__c = datePriseEffetConverted;
                    }
                    doc.statutDocument__c = docLoop.statutDocument;
                    doc.DateStockage__c = docLoop.dateStockage;
                    if(docloop.avenants != null) {
                        cont.Misejourconditionsduree__c = docloop.avenants.MAJConditionsDuree;
                        cont.Misejourconditionstechniques__c = docloop.avenants.MAJConditionsTechniques;
                        cont.Misejourconditionsfacturation__c = docloop.avenants.MAJConditionsFacturation;
                        cont.Ajoutprestations__c = docloop.avenants.ajoutPrestations;
                        cont.Retraitprestations__c = docloop.avenants.retraitPrestations;
                        cont.Autresmodifications__c = docloop.avenants.autresModifications;
                    }
                    doc.CreateDate__c = docLoop.metadonneesDocument.creationDate;
                    if(userDoc != null && userDoc.size() > 0) {
                        for(User userLoop : userDoc) {
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.creationId) {
                                doc.CreateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.updateId) {
                                doc.updateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.validationId) {
                                doc.validationId__c = userLoop.id;
                            }
                        }
                    }
                    doc.UpdateDate__c = docLoop.metadonneesDocument.updateDate;
                    doc.ValidationDate__c = docLoop.metadonneesDocument.validationDate;
                    docList.add(doc);
                }
                try {
                    update docList;
                }
                catch(Exception e) {
                    system.debug('Error ' + e);
                    WebserviceLog__c wsLog = new WebserviceLog__c();
                    wsLog.Type__c = 'GetCreerContrat - Document Erreur';
                    wsLog.flux__c = 'sortant';
                    wsLog.ErrorText__c = e.getMessage();
                    if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                        ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
                    }
                    wsLog.Request__c = docList + '';
                    wsLog.ObjectId__c = cont.Id;
                    wsLog.CodeRetour__c = 'KO';
                    insert wsLog;
                }
            }
            if(retval.contrat.durees != null) {
                DateTime DatepriseeffetinitialeOriginal = retval.contrat.durees.datePriseEffetInitiale;
                /*if(DatepriseeffetinitialeOriginal!=null){
                   Date DatepriseeffetinitialeConverted = date.newinstance(DatepriseeffetinitialeOriginal.year(), DatepriseeffetinitialeOriginal.month(), DatepriseeffetinitialeOriginal.day());
                   cont.Datepriseeffetinitiale__c = DatepriseeffetinitialeConverted;
                   }*/
                //cont.DureeInitialeContrat__c = retval.contrat.durees.dureeInitialeContrat;
                //cont.TypeReconduction__c = retval.contrat.durees.typeReconduction;
                //cont.DureeReconduction__c = retval.contrat.durees.dureeReconduction;
                //cont.DureePreavis__c = retval.contrat.durees.dureePreavis;
                //cont.NombreReconductionsAutorisees__c = retval.contrat.durees.nombreReconductionAutorise;
                //cont.DureeMaximaleCumulee_del__c = retval.contrat.durees.dureeMaximaleCumulee;
                //cont.ReconductionFaitAutorisee__c = retval.contrat.durees.reconductionFaitAutorisee;
                //cont.NombreReconductionsPassees__c = retval.contrat.durees.nombreReconductionsPassees;
                /*
                   DateTime DateProchainPreavisOriginal = retval.contrat.durees.dateProchainPreavis;

                   if(DateProchainPreavisOriginal != null) {
                    Date DateProchainPreavisConverted = date.newinstance(DateProchainPreavisOriginal.year(), DateProchainPreavisOriginal.month(), DateProchainPreavisOriginal.day());
                    cont.DateProchainPreavis__c = DateProchainPreavisConverted;
                   }
                 */

                /*
                   DateTime DateProchaineEcheanceOriginal = retval.contrat.durees.dateProchaineEcheance;
                   if(DateProchaineEcheanceOriginal != null) {
                    Date DateProchaineEcheanceConverted = date.newinstance(DateProchaineEcheanceOriginal.year(), DateProchaineEcheanceOriginal.month(), DateProchaineEcheanceOriginal.day());
                    cont.DateProchaineEcheance__c = DateProchaineEcheanceConverted;
                   }
                 */
                //cont.DureeProlongationTotale__c = retval.contrat.durees.dureeProlongation;
            }
            if(retval.contrat.listeResumes != null) {
                if(retval.contrat.listeResumes.resume != null) {
                    for(wwwDalkiaFrReferentielContrat.resume res : retval.contrat.listeResumes.resume) {
                        cont.ParametrePortailClient__c = res.parametrePortailClient;
                        cont.PrecisionParametre__c = res.precisionParametre;
                        cont.InformationComplementaire__c = res.informationComplementaire;
                        //cont.ValeurContractuelle__c = res.valeurContractuelle;
                        cont.UniteValeurContractuelle__c = res.uniteValeurContractuelle;
                    }
                }
            }
            /*if(retval.contrat.listeServices != null){
               if(retval.contrat.listeServices.service != null){
               for(wwwDalkiaFrReferentielContrat.service ser : retval.contrat.listeServices.service){
               cont.Service__c = ser.service;
               cont.Penalitesassocies__c = ser.penalitesAssociees;
               cont.Perimtrerealisation__c = ser.perimetreRealisation;
               cont.Statut_Lien_Service__c = ser.statutLienService;
               if(ser.listePrestations != null){
               if(ser.listePrestations.prestation != null){
               for(wwwDalkiaFrReferentielContrat.prestation pres: ser.listePrestations.prestation){
               cont.Prestation__c = pres.prestation;
               //cont.Prestation_Personnalisee__c = pres.prestationExternalisee;
               cont.Mode_Remuneration__c = pres.modeRemuneration;
               //cont.Service__c = pres.gestionLivreOuvert;
               //cont.Service__c = pres.complementInformation;
               cont.Statut_Lien_Prestation__c = pres.statutLienPrestation;
               }
               }
               }
               }
               }
               }*/
            //a faire
            if(retval.contrat.listePartenaires != null) {
                if(retval.contrat.listePartenaires.partenaire != null) {
                    List<EcosystemePartenaire__c> listEcoSys = new List<EcosystemePartenaire__c>();
                    Set<String> dkCodeAcccounts = new set<String>();
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        dkCodeAcccounts.add(part.partenaire);
                    }
                    List<Account> listAcc = [Select id, DKCodeSurPartenaire__c from account where DKCodeSurPartenaire__c in : dkCodeAcccounts];
                    Map<String, String> dkCodeIdMap = new map<String, String>();
                    for(Account acc : listAcc) {
                        dkCodeIdMap.put(acc.DKCodeSurPartenaire__c, acc.id);
                    }
                    Integer countSignPart = 0;
                    String partCont = '';
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        if(part.statutLienPartenaire != null && part.statutLienPartenaire) {
                            if(!String.isBlank(part.rolePartenaire)) {
                                if(part.rolePartenaire.equals('SIGN') && countSignPart == 0) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        if(dkCodeIdMap.get(part.partenaire) != null) {
                                            cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                                            partCont = dkCodeIdMap.get(part.partenaire);
                                            ++countSignPart;
                                        }
                                    }
                                } else if(part.rolePartenaire.equals('PRST')) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        cont.SocieteVenteLookup__c = dkCodeIdMap.get(part.partenaire);
                                    }
                                } else if(part.rolePartenaire.equals('SIGN') && countSignPart > 0) {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    ecoSys.TypeRelation__c = part.rolePartenaire;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                } else {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    String role = part.rolePartenaire;
                                    if(role == 'FACT') {
                                        role = 'FACT_1';
                                    }
                                    if(role == 'REPR') {
                                        role = 'REPR_1';
                                    }
                                    ecoSys.TypeRelation__c = role;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                }
                            }
                        }
                    }
                }
            }
            if(retval.contrat.listeAffaires != null) {
                if(retval.contrat.listeAffaires.affaire != null) {
                    for(wwwDalkiaFrReferentielContrat.affaire aff : retval.contrat.listeAffaires.affaire) {
                        //cont.Affaire__c = aff.affaire;
                        cont.Statut_Lien_Affaire__c = aff.statutLienAffaire;
                    }
                }
            }
            if(retval.contrat.listeProjetsFinance != null) {
                if(retval.contrat.listeProjetsFinance.projetFinance != null) {
                    for(wwwDalkiaFrReferentielContrat.projetFinance proj : retval.contrat.listeProjetsFinance.projetFinance) {
                        //proj.tacheFinance;
                        //proj.projetFinance;
                        //proj.statutLienTF;
                    }
                }
            }
            if(retval.contrat.listeResponsables != null) {
                if(retval.contrat.listeResponsables.responsable != null) {
                    for(wwwDalkiaFrReferentielContrat.responsable resp : retval.contrat.listeResponsables.responsable) {
                        //resp.responsableContrat;
                        cont.Perimetreresponsable__c = resp.perimetreResponsable;
                        //cont.Statut_Lien_responsable__c = resp.statutLienResponsable = '';
                    }
                }
            }
            if(retval.contrat.numerotationContrat != null) {
                cont.Applicationsourcecontrat__c = retval.contrat.numerotationContrat.applicationSource;
                //cont.TechNumeroContrat2__c = retval.contrat.numerotationContrat.codeSource;
            }

            if(retval.contrat.metadonneesContrat != null) {

                cont.CreateDate__c = retVal.contrat.metadonneesContrat.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.creationId limit 1];
                if(usr1 != null && usr1.size() > 0) {
                    cont.CreateId__c = usr1[0].Id;
                }
                cont.UpdateDate__c = retval.contrat.metadonneesContrat.updateDate;
                List<User> usr2 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.updateId limit 1];
                if(usr2 != null && usr2.size() > 0) {
                    cont.UpdateId__c = usr2[0].Id;
                }
                DateTime DateValidationOriginal = retval.contrat.metadonneesContrat.validationDate;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.ValidationDate__c = DateValidationConverted;
                }
                if(!String.isBlank(retval.contrat.metadonneesContrat.validationId)) {
                    List<User> usr = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.validationId LIMIT 1];
                    if(usr != null && String.isNotBlank(usr[0].ReferentielId__c) && usr.size() > 0) {
                        cont.Validation_Id__c   = usr[0].Id;
                    }
                }
            }
        }

        return cont;
    }

    public static Contrat__c getConsulterContratRequete(wwwDalkiaFrReferentielContrat.consulterContratReponse retVal){
        Contrat__c cont = new Contrat__c();
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = retVal + '';
        ws.Type__c = 'creerContract';
        //retVal.informationsRetour.messageRetour;
        ws.StatusCode__c = retVal.informationsRetour.codeRetour;
        system.debug('cont2');
        List<Contrat__c> contID = [SELECT id
                                   FROM Contrat__c
                                   where DKCodeSurContrat__c = : retval.contrat.proprietesContrat.DKCodeContrat];
        if(retval.contrat != null) {
            if(retval.contrat.proprietesContrat != null) {
                cont.DKCodeSurContrat__c = retval.contrat.proprietesContrat.DKCodeContrat;
                if(retval.contrat.proprietesContrat.libelle.length() > 80) {
                    cont.Name = retval.contrat.proprietesContrat.libelle.substring(0, 80);
                } else {
                    cont.Name = retval.contrat.proprietesContrat.libelle;
                }
                cont.Commentaire__c = retval.contrat.proprietesContrat.commentaire;
                cont.ControleContrat__c = retval.contrat.proprietesContrat.controleContrat;
                cont.Statut__c = retval.contrat.proprietesContrat.statutContrat;
                cont.Statut_Facturation__c = retval.contrat.proprietesContrat.statutFacturation;
                cont.MotifRejet__c = retval.contrat.proprietesContrat.motifRejet;
                cont.StatutServices__c = retval.contrat.proprietesContrat.statutServices;
                cont.CategorieContrat__c = retval.contrat.proprietesContrat.categorieContrat;
                cont.Interco__c = retval.contrat.proprietesContrat.interco;
                cont.FormeJuridique__c = retval.contrat.proprietesContrat.formeJuridique;
                cont.Langue__c = retval.contrat.proprietesContrat.langue;
                cont.Devise__c = retval.contrat.proprietesContrat.devise;
                cont.Numdossier__c = retval.contrat.proprietesContrat.numeroDossier;
                //cont.ContratOrigine__c = retval.contrat.proprietesContrat.contratDorigine;
                cont.EstContratNational__c = retval.contrat.proprietesContrat.estContratNational;
                cont.NatureContrat__c = retval.contrat.proprietesContrat.natureContrat;
                cont.OrigineContrat__c = retval.contrat.proprietesContrat.provenanceContrat;
                DateTime DateValidationOriginal = retval.contrat.proprietesContrat.dateDeValidation;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.Datevalidation__c = DateValidationConverted;
                }
                cont.Motif_fermeture_contrat__c = retval.contrat.proprietesContrat.motifDeFermeture;
                cont.Condition_de_fermeture__c = retval.contrat.proprietesContrat.conditionDeFermeture;
                DateTime DateFinOriginal = retval.contrat.proprietesContrat.dateDeFin;
                if(DateFinOriginal != null) {
                    Date DateFinConverted = date.newinstance(DateFinOriginal.year(), DateFinOriginal.month(), DateFinOriginal.day());
                    cont.DateFin__c = DateFinConverted;
                }
                cont.EstContratcadre__c = retval.contrat.proprietesContrat.estContratCadre;
                cont.ReportingContrat__c = retval.contrat.proprietesContrat.reportingContrat;
                List<CentreFinance__c> cf = [SELECT id from CentreFinance__c where DkCode__c = : retval.contrat.proprietesContrat.UOPiloteContrat];
                if(cf != null && cf.size() > 0) {
                    cont.UOPiloteContrat__c = cf[0].id;
                }
                cont.TypeContrat__c = retval.contrat.proprietesContrat.typeContratFacturation;
                //07-03-2022 Added by Jimmy US C360-655
                cont.NatureContratCadre__c = retval.contrat.proprietesContrat.typeContrat;
                //end US C360-655
            }
            if(retval.contrat.contratCadre != null) {
                List<Contrat__c> contratParentList = [Select id, name
                                                      From Contrat__c
                                                      Where DKCodeSurContrat__c = : retval.contrat.contratCadre.contratCadre];
                if(contratParentList != null && contratParentList.size() > 0) {
                    cont.ContratCadre__c = contratParentList.get(0).id;
                }
            }
            List<Document_Contractuel__c> listDoc = new List<Document_Contractuel__c>();

            Set<String> docOwnerRef = new Set<String>();
            if(retval.contrat.listeDocuments != null) {
                for(wwwDalkiaFrReferentielContrat.document doc : retval.contrat.listeDocuments.document) {
                    docOwnerRef.add(doc.metadonneesDocument.validationId);
                }
            }
            Map<String, String> refId = new Map<String, String>();
            for(User userLoop : [Select id, ReferentielId__c from user where ReferentielId__c = : docOwnerRef]) {
                if(String.isNotBlank(userLoop.ReferentielId__c)) {
                    refId.put(userLoop.ReferentielId__c, userLoop.id);
                }
            }
            if(retval.contrat.listeDocuments != null) {
                for(wwwDalkiaFrReferentielContrat.document doc : retval.contrat.listeDocuments.document) {
                    Document_Contractuel__c docCont = new Document_Contractuel__c();
                    if(contID != null && contID.size() > 0) {
                        docCont.Contrat__c = contID[0].id;
                    }
                    docCont.NumeroPiece__c = doc.numeroPiece;
                    docCont.ReferenceDuree__c = doc.referenceDuree;
                    docCont.NatureDocument__c = doc.natureDocument;
                    //docCont. = doc.origineDocument;
                    //docCont.ReferenceDocument__c = doc.referenceDocument; Rita
                    // if(doc.titreDocument.length()>80){
                    // docCont.Name = doc.titreDocument.substring(0,80);
                    //}
                    //else{
                    docCont.TitreDocument__c = doc.titreDocument;
                    // }
                    DateTime DateSignatureOriginal = doc.dateSignature;
                    if(DateSignatureOriginal != null) {
                        Date DateSignatureConverted = date.newinstance(DateSignatureOriginal.year(), DateSignatureOriginal.month(), DateSignatureOriginal.day());
                        docCont.DateSignature__c = DateSignatureConverted;
                    }
                    DateTime DatePriseEffetOriginal = doc.datePriseEffet;
                    if(DatePriseEffetOriginal != null) {
                        Date DatePriseEffetConverted = date.newinstance(DatePriseEffetOriginal.year(), DatePriseEffetOriginal.month(), DatePriseEffetOriginal.day());
                        docCont.DatePriseEffet__c = DatePriseEffetConverted;
                    }
                    docCont.StatutDocument__c = doc.statutDocument;
                    docCont.NiveauDeConfidentialite__c = doc.niveauConfidentialite;
                    docCont.Commentaire__c = doc.commentaireDocument;
                    docCont.DateStockage__c = doc.dateStockage;
                    if(doc.avenants != null) {
                        //docCont.Misejourconditionsduree__c = doc.avenants.MAJConditionsDuree; existent sur contrat
                        //docCont.Misejourconditionstechniques__c = doc.avenants.MAJConditionsTechniques;
                        //docCont.Misejourconditionsfacturation__c = doc.avenants.MAJConditionsFacturation;
                        docCont.Ajoutprestations__c = doc.avenants.ajoutPrestations;
                        docCont.Retraitprestations__c = doc.avenants.retraitPrestations;
                        docCont.Autresmodifications__c = doc.avenants.autresModifications;
                    }
                    if(doc.metadonneesDocument != null) {
                        //docContdoc.CreationDate__c = doc.metadonneesDocument.creationDate; n'existe pas
                        //docContdoc.CreationById = doc.metadonneesDocument.creationId;n'existe pas
                        //docContdoc.LastModifiedDate__c = doc.metadonneesDocument.updateDate;n'existe pas
                        //docContdoc.LastModifiedById = doc.metadonneesDocument.updateId;n'existe pas
                        docCont.ValidationDate__c = doc.metadonneesDocument.validationDate;
                        if(String.isNotBlank(refId.get(doc.metadonneesDocument.validationId))) {
                            docCont.ValidationId__c = refId.get(doc.metadonneesDocument.validationId);
                        }
                    }
                    listDoc.add(docCont);
                }
            }
            try {
                upsert listDoc Name;
            }
            catch(Exception e) {
                system.debug('Doc du compte pas upserted ' + e);
            }
            if(retval.contrat.durees != null) {
                DateTime DatepriseeffetinitialeOriginal = retval.contrat.durees.datePriseEffetInitiale;
                /*if(DatepriseeffetinitialeOriginal != null){
                   Date DatepriseeffetinitialeConverted = date.newinstance(DatepriseeffetinitialeOriginal.year(), DatepriseeffetinitialeOriginal.month(), DatepriseeffetinitialeOriginal.day());
                   cont.Datepriseeffetinitiale__c = DatepriseeffetinitialeConverted;
                   }*/
                /*cont.DureeInitialeContrat__c = retval.contrat.durees.dureeInitialeContrat;
                   cont.TypeReconduction__c = retval.contrat.durees.typeReconduction;
                   cont.DureeReconduction__c = retval.contrat.durees.dureeReconduction;
                   cont.DureePreavis__c = retval.contrat.durees.dureePreavis;
                   cont.NombreReconductionsAutorisees__c = retval.contrat.durees.nombreReconductionAutorise;
                   cont.DureeMaximaleCumulee_del__c = retval.contrat.durees.dureeMaximaleCumulee;
                   cont.ReconductionFaitAutorisee__c = retval.contrat.durees.reconductionFaitAutorisee;*/
                //cont.NombreReconductionsPassees__c = retval.contrat.durees.nombreReconductionsPassees;
                /*
                   DateTime DateProchainPreavisOriginal = retval.contrat.durees.dateProchainPreavis;

                   if(DateProchainPreavisOriginal != null) {
                    Date DateProchainPreavisConverted = date.newinstance(DateProchainPreavisOriginal.year(), DateProchainPreavisOriginal.month(), DateProchainPreavisOriginal.day());
                    cont.DateProchainPreavis__c = DateProchainPreavisConverted;
                   }
                 */
                /*
                   DateTime DateProchaineEcheanceOriginal = retval.contrat.durees.dateProchaineEcheance;
                   if(DateProchaineEcheanceOriginal != null) {
                    Date DateProchaineEcheanceConverted = date.newinstance(DateProchaineEcheanceOriginal.year(), DateProchaineEcheanceOriginal.month(), DateProchaineEcheanceOriginal.day());
                    cont.DateProchaineEcheance__c = DateProchaineEcheanceConverted;
                   }
                 */
            }
            /*if(retval.contrat.listeResumes != null){
               if(retval.contrat.listeResumes.resume != null){
               for(wwwDalkiaFrReferentielContrat.resume res : retval.contrat.listeResumes.resume){
               cont.ParametrePortailClient__c = res.parametrePortailClient;
               cont.PrecisionParametre__c = res.precisionParametre;
               cont.InformationComplementaire__c = res.informationComplementaire;
               cont.ValeurContractuelle__c = String.valueOf(res.valeurContractuelle);
               cont.UniteValeurContractuelle__c = res.uniteValeurContractuelle;
               }
               }
               }*/
            /*
               if(retval.contrat.listeServices != null){
               if(retval.contrat.listeServices.service != null){
               for(wwwDalkiaFrReferentielContrat.service ser : retval.contrat.listeServices.service){
               if(ser.statutLienService == true){
               cont.Service__c = ser.service;
               cont.Penalitesassocies__c = ser.penalitesAssociees;
               cont.Perimtrerealisation__c = ser.perimetreRealisation;
               cont.Statut_Lien_Service__c = ser.statutLienService;
               if(ser.listePrestations != null){
               if(ser.listePrestations.prestation != null){
               for(wwwDalkiaFrReferentielContrat.prestation pres: ser.listePrestations.prestation){
               if(pres.statutLienPrestation == true){
               cont.Prestation__c = pres.prestation;
               cont.Prestation_Externalisee__c = pres.prestationExternalisee;
               cont.Mode_Remuneration__c = pres.modeRemuneration;
               //cont. = pres.gestionLivreOuvert; pas dans doc
               //cont. = pres.complementInformation; pas dans doc
               cont.Statut_Lien_Prestation__c = pres.statutLienPrestation;

               }
               }
               }
               }
               }
               }
               }
               }*/
            //a faire
            if(retval.contrat.listePartenaires != null) {
                if(retval.contrat.listePartenaires.partenaire != null) {
                    List<EcosystemePartenaire__c> listEcoSys = new List<EcosystemePartenaire__c>();
                    Set<String> dkCodeAcccounts = new set<String>();
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        dkCodeAcccounts.add(part.partenaire);
                    }
                    List<Account> listAcc = [Select id, DKCodeSurPartenaire__c from account where DKCodeSurPartenaire__c in : dkCodeAcccounts];
                    Map<String, String> dkCodeIdMap = new map<String, String>();
                    for(Account acc : listAcc) {
                        dkCodeIdMap.put(acc.DKCodeSurPartenaire__c, acc.id);
                    }
                    Integer countSignPart = 0;
                    String partCont = '';
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        if(part.statutLienPartenaire != null && part.statutLienPartenaire) {
                            if(!String.isBlank(part.rolePartenaire)) {
                                if(part.rolePartenaire.equals('SIGN') && countSignPart == 0) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        if(dkCodeIdMap.get(part.partenaire) != null) {
                                            cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                                            partCont = dkCodeIdMap.get(part.partenaire);
                                            ++countSignPart;
                                        }
                                    }
                                } else if(part.rolePartenaire.equals('PRST')) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        cont.SocieteVenteLookup__c = dkCodeIdMap.get(part.partenaire);
                                    }
                                } else if(part.rolePartenaire.equals('SIGN') && countSignPart > 0) {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    ecoSys.TypeRelation__c = part.rolePartenaire;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                } else {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    String role = part.rolePartenaire;
                                    if(role == 'FACT') {
                                        role = 'FACT_1';
                                    }
                                    if(role == 'REPR') {
                                        role = 'REPR_1';
                                    }
                                    ecoSys.TypeRelation__c = role;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                }
                            }
                        }
                    }
                }
            }
            if(retval.contrat.listeAffaires != null) {
                if(retval.contrat.listeAffaires.affaire != null) {
                    for(wwwDalkiaFrReferentielContrat.affaire aff : retval.contrat.listeAffaires.affaire) {
                        if(aff.statutLienAffaire == true) {
                            //cont.Affaire__c = aff.affaire;
                            cont.Statut_Lien_Affaire__c = aff.statutLienAffaire;
                        }
                    }
                }
            }
            /*if(retval.contrat.listeProjetsFinance != null){
               if(retval.contrat.listeProjetsFinance.projetFinance != null){
               for(wwwDalkiaFrReferentielContrat.projetFinance proj : retval.contrat.listeProjetsFinance.projetFinance){
               //proj.tacheFinance; pas pour le moment
               //proj.projetFinance; pas pour le moment
               //proj.statutLienTF; pas pour le moment
               }
               }
               }*/
            set<String> respDKCode = new set<String>();
            if(retval.contrat.listeResponsables != null) {
                if(retval.contrat.listeResponsables.responsable != null) {
                    for(wwwDalkiaFrReferentielContrat.responsable resp : retval.contrat.listeResponsables.responsable) {
                        if(resp.statutLienResponsable == true) {
                            respDKCode.add(resp.responsableContrat);
                        }
                    }
                }
            }
            List<User> contOwner = [SELECT id
                                    FROM User
                                    WHERE DkCode__c in : respDKCode LIMIT 1];
            if(retval.contrat.listeResponsables != null) {
                if(retval.contrat.listeResponsables.responsable != null) {
                    for(wwwDalkiaFrReferentielContrat.responsable resp : retval.contrat.listeResponsables.responsable) {
                        if(resp.statutLienResponsable == true && resp.perimetreResponsable == 'ROL01') {
                            if(contOwner != null && contOwner.size() > 0) {
                                cont.Ownerid = contOwner[0].id;
                            }
                            cont.Perimetreresponsable__c = 'ROL01';
                            cont.Statut_Lien_responsable__c = resp.statutLienResponsable;
                        }
                    }
                }
            }
            if(retval.contrat.numerotationContrat != null) {
                cont.Applicationsourcecontrat__c = retval.contrat.numerotationContrat.applicationSource;
                //cont.TechNumeroContrat2__c = retval.contrat.numerotationContrat.codeSource;
            }
            if(retval.contrat.metadonneesContrat != null) {
                //cont.CreatedDate = retval.contrat.metadonneesContrat.creationDate;

                //cont.createdByID = retval.contrat.metadonneesContrat.creationId;
                //cont.LastModifiedDate = retval.contrat.metadonneesContrat.updateDate;

                //cont.LastModifiedById = retval.contrat.metadonneesContrat.updateId;

                cont.CreateDate__c = retVal.contrat.metadonneesContrat.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.creationId limit 1];
                if(usr1 != null && usr1.size() > 0) {
                    cont.CreateId__c = usr1[0].Id;
                }
                cont.UpdateDate__c = retval.contrat.metadonneesContrat.updateDate;
                List<User> usr2 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.updateId limit 1];
                if(usr2 != null && usr2.size() > 0) {
                    cont.UpdateId__c = usr2[0].Id;
                }

                DateTime DateValidationOriginal = retval.contrat.metadonneesContrat.validationDate;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.ValidationDate__c = DateValidationConverted;
                }
                if(!String.isBlank(retval.contrat.metadonneesContrat.validationId)) {
                    List<User> usr = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.validationId LIMIT 1];
                    if(usr != null && String.isNotBlank(usr[0].ReferentielId__c) && usr.size() > 0) {
                        cont.Validation_Id__c   = usr[0].Id;
                    }
                }
            }
        }

        return cont;
    }

    public static Contrat__c getRenouvelerContratRequete(wwwDalkiaFrReferentielContrat.renouvelerContratReponse retVal, String contratId, List<Document_contractuel__c> docListOld){
        Contrat__c cont = new Contrat__c();
        Map<String, Id> mapNameDoc = new Map<String, Id>();
        for(Document_contractuel__c doc : docListOld) {
            mapNameDoc.put(doc.TitreDocument__c, doc.id);
        }
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = retVal + '';
        ws.Type__c = 'creerContract';
        //retVal.informationsRetour.messageRetour;
        ws.StatusCode__c = retVal.informationsRetour.codeRetour;
        if(retval.contrat != null) {
            if(retval.contrat.proprietesContrat != null) {
                cont.DKCodeSurContrat__c = retval.contrat.proprietesContrat.DKCodeContrat;
                if(retval.contrat.proprietesContrat.libelle != null) {
                    if(retval.contrat.proprietesContrat.libelle.length() > 80) {
                        cont.Name = retval.contrat.proprietesContrat.libelle.substring(0, 80);
                    } else {
                        cont.Name = retval.contrat.proprietesContrat.libelle;
                    }
                }
                cont.Commentaire__c = retval.contrat.proprietesContrat.commentaire;
                //cont.ControleContrat__c = retval.contrat.proprietesContrat.controleContrat;
                //cont.Statut__c = retval.contrat.proprietesContrat.statutContrat; //ne pas sauveguarder dans SF, ça sera mis a jour par le flux entrant
                //cont.Staut_Facturation__c = retval.contrat.proprietesContrat.statutFacturation;
                cont.MotifRejet__c = retval.contrat.proprietesContrat.motifRejet;
                cont.StatutServices__c = retval.contrat.proprietesContrat.statutServices;
                cont.CategorieContrat__c     = retval.contrat.proprietesContrat.categorieContrat;
                cont.Interco__c = retval.contrat.proprietesContrat.interco;
                cont.FormeJuridique__c = retval.contrat.proprietesContrat.formeJuridique;
                cont.Langue__c = retval.contrat.proprietesContrat.langue;
                cont.Devise__c = retval.contrat.proprietesContrat.devise;
                cont.Numdossier__c = retval.contrat.proprietesContrat.numeroDossier;
                //cont.ContratOrigine__c = retval.contrat.proprietesContrat.contratDorigine;
                cont.EstContratNational__c = retval.contrat.proprietesContrat.estContratNational;
                cont.NatureContrat__c = retval.contrat.proprietesContrat.natureContrat;
                cont.OrigineContrat__c = retval.contrat.proprietesContrat.provenanceContrat;
                //cont.Datevalidation__c = retval.contrat.proprietesContrat.dateDeValidation;
                DateTime DateValidationOriginal = retval.contrat.proprietesContrat.dateDeValidation;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.Datevalidation__c = DateValidationConverted;
                }
                cont.Motif_fermeture_contrat__c = retval.contrat.proprietesContrat.motifDeFermeture;
                cont.Condition_de_fermeture__c = retval.contrat.proprietesContrat.conditionDeFermeture;
                //cont.DateFin__c = retval.contrat.proprietesContrat.dateDeFin;
                DateTime DateFinOriginal = retval.contrat.proprietesContrat.dateDeFin;
                if(DateFinOriginal != null) {
                    Date DateFinConverted = date.newinstance(DateFinOriginal.year(), DateFinOriginal.month(), DateFinOriginal.day());
                    cont.DateFin__c = DateFinConverted;
                }
                cont.EstContratcadre__c = retval.contrat.proprietesContrat.estContratCadre;
                cont.ReportingContrat__c = retval.contrat.proprietesContrat.reportingContrat;
                //CentreFinance__c cf = [SELECT DkCode__c from CentreFinance__c where id =: retval.contrat.proprietesContrat.UOPiloteContrat];
                //cont.UOPiloteContrat__c = cf.DkCode__c;
                cont.TypeContrat__c = retval.contrat.proprietesContrat.typeContratFacturation;
                //07-03-2022 Added by Jimmy US C360-655
                cont.NatureContratCadre__c = retval.contrat.proprietesContrat.typeContrat;
                //end US C360-655
            }

            //Added by Jimmy 08/02/2022 - CVS
            if(retval.contrat.proprietesCvs != null) {
                cont.natureOffre__c = retval.contrat.proprietesCvs.natureOffre;
                cont.engagementEnergetique__c = retval.contrat.proprietesCvs.engagementEnergetique;
                cont.paiementDesEnergies__c = retval.contrat.proprietesCvs.paiementDesEnergies;
                cont.niveauDeMaintenance__c = retval.contrat.proprietesCvs.niveauDeMaintenance;
            }
            //end CVS

            if(retval.contrat.contratCadre != null) {
                List<Contrat__c> contratCadre = [SELECT id, DkCodesurcontrat__c FROM Contrat__c where DkCodesurcontrat__c = : retval.contrat.contratCadre.contratCadre];
                if(contratCadre != null && contratCadre.size() > 0) {
                    cont.ContratCadre__c = contratCadre[0].id;
                }
            }
            if(retval.contrat.listeDocuments != null) {
                List<Document_contractuel__c> docList = new List<Document_contractuel__c>();
                Set<String> userIds = new Set<String>();
                for(wwwDalkiaFrReferentielContrat.document docloop : retval.contrat.listeDocuments.document) {
                    if(String.isNotBlank(docloop.metadonneesDocument.creationId)) {
                        userIds.add(docloop.metadonneesDocument.creationId);
                    }
                    if(String.isNotBlank(docloop.metadonneesDocument.UpdateId)) {
                        userIds.add(docloop.metadonneesDocument.UpdateId);
                    }
                    if(String.isNotBlank(docloop.metadonneesDocument.ValidationId)) {
                        userIds.add(docloop.metadonneesDocument.ValidationId);
                    }
                }
                List<User> userDoc = new List<User>();
                userDoc = [Select id, name, ReferentielId__c from user where ReferentielId__c in : userIds];
                for(wwwDalkiaFrReferentielContrat.document docloop : retval.contrat.listeDocuments.document) {
                    Document_contractuel__c doc = new Document_contractuel__c();
                    doc.DateDeclenchement__c = System.now();
                    doc.SynchronisationDate__c = System.now();
                    doc.NumeroPiece__c = docLoop.numeroPiece;
                    doc.ReferenceDuree__c = docLoop.referenceDuree;
                    doc.NatureDocument__c = docLoop.natureDocument;
                    doc.contrat__c = contratID;
                    doc.TitreDocument__c = docLoop.titreDocument;
                    if(doc.TitreDocument__c != null && mapNameDoc.keyset().contains(doc.TitreDocument__c) && mapNameDoc.get(doc.TitreDocument__c) != null) {
                        doc.id = mapNameDoc.get(doc.TitreDocument__c);
                    }
                    DateTime dateSignatureOriginal = docLoop.dateSignature;
                    if(dateSignatureOriginal != null) {
                        Date dateSignatureConverted = date.newinstance(dateSignatureOriginal.year(), dateSignatureOriginal.month(), dateSignatureOriginal.day());//
                        doc.DateSignature__c = dateSignatureConverted;
                    }
                    DateTime datePriseEffetOriginal = docLoop.datePriseEffet;
                    if(datePriseEffetOriginal != null) {
                        Date datePriseEffetConverted = date.newinstance(datePriseEffetOriginal.year(), datePriseEffetOriginal.month(), datePriseEffetOriginal.day());
                        //doc.DatePriseEffet__c = datePriseEffetConverted;
                        doc.DatePriseEffet__c = datePriseEffetConverted;
                    }
                    doc.statutDocument__c = docLoop.statutDocument;
                    doc.DateStockage__c = docLoop.dateStockage;
                    if(docloop.avenants != null) {
                        cont.Misejourconditionsduree__c = docloop.avenants.MAJConditionsDuree;
                        cont.Misejourconditionstechniques__c = docloop.avenants.MAJConditionsTechniques;
                        cont.Misejourconditionsfacturation__c = docloop.avenants.MAJConditionsFacturation;
                        cont.Ajoutprestations__c = docloop.avenants.ajoutPrestations;
                        cont.Retraitprestations__c = docloop.avenants.retraitPrestations;
                        cont.Autresmodifications__c = docloop.avenants.autresModifications;
                    }
                    if(userDoc != null && userDoc.size() > 0) {
                        for(User userLoop : userDoc) {
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.creationId) {
                                doc.CreateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.updateId) {
                                doc.updateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.validationId) {
                                doc.validationId__c = userLoop.id;
                            }
                        }
                    }
                    doc.CreateDate__c = docLoop.metadonneesDocument.creationDate;
                    doc.UpdateDate__c = docLoop.metadonneesDocument.updateDate;
                    doc.ValidationDate__c = docLoop.metadonneesDocument.validationDate;
                    docList.add(doc);
                }
                try {
                    update docList;
                }
                catch(Exception e) {
                    system.debug('Error ' + e);
                    WebserviceLog__c wsLog = new WebserviceLog__c();
                    wsLog.Type__c = 'GetRenouvelerContrat - Document Erreur';
                    wsLog.flux__c = 'sortant';
                    wsLog.ErrorText__c = e.getMessage();
                    if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                        ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
                    }
                    wsLog.Request__c = docList + '';
                    wsLog.ObjectId__c = cont.Id;
                    wsLog.CodeRetour__c = 'KO';
                    insert wsLog;
                }
            }
            if(retval.contrat.durees != null) {
                DateTime DatepriseeffetinitialeOriginal = retval.contrat.durees.datePriseEffetInitiale;
                /*if(DatepriseeffetinitialeOriginal!=null){
                   Date DatepriseeffetinitialeConverted = date.newinstance(DatepriseeffetinitialeOriginal.year(), DatepriseeffetinitialeOriginal.month(), DatepriseeffetinitialeOriginal.day());
                   cont.Datepriseeffetinitiale__c = DatepriseeffetinitialeConverted;
                   }*/
                /*cont.DureeInitialeContrat__c = retval.contrat.durees.dureeInitialeContrat;
                   cont.TypeReconduction__c = retval.contrat.durees.typeReconduction;
                   cont.DureeReconduction__c = retval.contrat.durees.dureeReconduction;
                   cont.DureePreavis__c = retval.contrat.durees.dureePreavis;
                   cont.NombreReconductionsAutorisees__c = retval.contrat.durees.nombreReconductionAutorise;
                   cont.DureeMaximaleCumulee_del__c = retval.contrat.durees.dureeMaximaleCumulee;
                   cont.ReconductionFaitAutorisee__c = retval.contrat.durees.reconductionFaitAutorisee;
                   //cont.NombreReconductionsPassees__c = retval.contrat.durees.nombreReconductionsPassees;*/
                /*
                   DateTime DateProchainPreavisOriginal = retval.contrat.durees.dateProchainPreavis;

                   if(DateProchainPreavisOriginal != null) {
                    Date DateProchainPreavisConverted = date.newinstance(DateProchainPreavisOriginal.year(), DateProchainPreavisOriginal.month(), DateProchainPreavisOriginal.day());
                    cont.DateProchainPreavis__c = DateProchainPreavisConverted;
                   }
                 */
                /*
                   DateTime DateProchaineEcheanceOriginal = retval.contrat.durees.dateProchaineEcheance;
                   if(DateProchaineEcheanceOriginal != null) {
                    Date DateProchaineEcheanceConverted = date.newinstance(DateProchaineEcheanceOriginal.year(), DateProchaineEcheanceOriginal.month(), DateProchaineEcheanceOriginal.day());
                    cont.DateProchaineEcheance__c = DateProchaineEcheanceConverted;
                   }
                 */
                //cont.DureeProlongationTotale__c = retval.contrat.durees.dureeProlongation;
            }
            if(retval.contrat.listeResumes != null) {
                if(retval.contrat.listeResumes.resume != null) {
                    for(wwwDalkiaFrReferentielContrat.resume res : retval.contrat.listeResumes.resume) {
                        cont.ParametrePortailClient__c = res.parametrePortailClient;
                        cont.PrecisionParametre__c = res.precisionParametre;
                        cont.InformationComplementaire__c = res.informationComplementaire;
                        //cont.ValeurContractuelle__c = res.valeurContractuelle;
                        cont.UniteValeurContractuelle__c = res.uniteValeurContractuelle;
                    }
                }
            }
            /*if(retval.contrat.listeServices != null){
               if(retval.contrat.listeServices.service != null){
               for(wwwDalkiaFrReferentielContrat.service ser : retval.contrat.listeServices.service){
               cont.Service__c = ser.service;
               cont.Penalitesassocies__c = ser.penalitesAssociees;
               cont.Perimtrerealisation__c = ser.perimetreRealisation;
               cont.Statut_Lien_Service__c = ser.statutLienService;
               if(ser.listePrestations != null){
               if(ser.listePrestations.prestation != null){
               for(wwwDalkiaFrReferentielContrat.prestation pres: ser.listePrestations.prestation){
               cont.Prestation__c = pres.prestation;
               //cont.Prestation_Personnalisee__c = pres.prestationExternalisee;
               cont.Mode_Remuneration__c = pres.modeRemuneration;
               //cont.Service__c = pres.gestionLivreOuvert;
               //cont.Service__c = pres.complementInformation;
               cont.Statut_Lien_Prestation__c = pres.statutLienPrestation;
               }
               }
               }
               }
               }
               }*/
            //a faire
            if(retval.contrat.listePartenaires != null) {
                if(retval.contrat.listePartenaires.partenaire != null) {
                    List<EcosystemePartenaire__c> listEcoSys = new List<EcosystemePartenaire__c>();
                    Set<String> dkCodeAcccounts = new set<String>();
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        dkCodeAcccounts.add(part.partenaire);
                    }
                    List<Account> listAcc = [Select id, DKCodeSurPartenaire__c from account where DKCodeSurPartenaire__c in : dkCodeAcccounts];
                    Map<String, String> dkCodeIdMap = new map<String, String>();
                    for(Account acc : listAcc) {
                        dkCodeIdMap.put(acc.DKCodeSurPartenaire__c, acc.id);
                    }
                    Integer countSignPart = 0;
                    String partCont = '';
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        if(part.statutLienPartenaire != null && part.statutLienPartenaire) {
                            if(!String.isBlank(part.rolePartenaire)) {
                                if(part.rolePartenaire.equals('SIGN') && countSignPart == 0) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        if(dkCodeIdMap.get(part.partenaire) != null) {
                                            cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                                            partCont = dkCodeIdMap.get(part.partenaire);
                                            ++countSignPart;
                                        }
                                    }
                                } else if(part.rolePartenaire.equals('PRST')) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        cont.SocieteVenteLookup__c = dkCodeIdMap.get(part.partenaire);
                                    }
                                } else if(part.rolePartenaire.equals('SIGN') && countSignPart > 0) {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    ecoSys.TypeRelation__c = part.rolePartenaire;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                } else {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    String role = part.rolePartenaire;
                                    if(role == 'FACT') {
                                        role = 'FACT_1';
                                    }
                                    if(role == 'REPR') {
                                        role = 'REPR_1';
                                    }
                                    ecoSys.TypeRelation__c = role;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                }
                            }
                        }
                    }
                }
            }
            if(retval.contrat.listeAffaires != null) {
                if(retval.contrat.listeAffaires.affaire != null) {
                    for(wwwDalkiaFrReferentielContrat.affaire aff : retval.contrat.listeAffaires.affaire) {
                        //cont.Affaire__c = aff.affaire;
                        cont.Statut_Lien_Affaire__c = aff.statutLienAffaire;
                    }
                }
            }
            if(retval.contrat.listeProjetsFinance != null) {
                if(retval.contrat.listeProjetsFinance.projetFinance != null) {
                    for(wwwDalkiaFrReferentielContrat.projetFinance proj : retval.contrat.listeProjetsFinance.projetFinance) {
                        //proj.tacheFinance;
                        //proj.projetFinance;
                        //proj.statutLienTF;
                    }
                }
            }
            if(retval.contrat.listeResponsables != null) {
                if(retval.contrat.listeResponsables.responsable != null) {
                    for(wwwDalkiaFrReferentielContrat.responsable resp : retval.contrat.listeResponsables.responsable) {
                        //resp.responsableContrat;
                        cont.Perimetreresponsable__c = resp.perimetreResponsable;
                        //cont.Statut_Lien_responsable__c = resp.statutLienResponsable = '';
                    }
                }
            }
            if(retval.contrat.numerotationContrat != null) {
                cont.Applicationsourcecontrat__c = retval.contrat.numerotationContrat.applicationSource;
                //cont.TechNumeroContrat2__c = retval.contrat.numerotationContrat.codeSource;
            }

            if(retval.contrat.metadonneesContrat != null) {
                //retval.contrat.metadonneesContrat.creationDate;
                //cont.currentUser.ReferentielId__c = retval.contrat.metadonneesContrat.creationId;
                //retval.contrat.metadonneesContrat.updateDate;
                //cont.currentUser.ReferentielId__c = retval.contrat.metadonneesContrat.updateId;
                //retval.contrat.metadonneesContrat.validationDate;
                //retval.contrat.metadonneesContrat.validationId;

                cont.CreateDate__c = retVal.contrat.metadonneesContrat.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.creationId limit 1];
                if(usr1 != null && usr1.size() > 0) {
                    cont.CreateId__c = usr1[0].Id;
                }
                cont.UpdateDate__c = retval.contrat.metadonneesContrat.updateDate;
                List<User> usr2 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.updateId limit 1];
                if(usr2 != null && usr2.size() > 0) {
                    cont.UpdateId__c = usr2[0].Id;
                }
                DateTime DateValidationOriginal = retval.contrat.metadonneesContrat.validationDate;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.ValidationDate__c = DateValidationConverted;
                }
                if(!String.isBlank(retval.contrat.metadonneesContrat.validationId)) {
                    List<User> usr = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.validationId LIMIT 1];
                    if(usr != null && usr.size() > 0 && String.isNotBlank(usr[0].ReferentielId__c)) {
                        cont.Validation_Id__c   = usr[0].Id;
                    }
                }
            }
        }

        return cont;
    }

    public static Contrat__c getModifierContratRequete(wwwDalkiaFrReferentielContrat.modifierContratReponse retVal, String contratID, List<Document_contractuel__c> docListOld){
        Map<String, Id> mapNameDoc = new Map<String, Id>();
        for(Document_contractuel__c doc : docListOld) {
            mapNameDoc.put(doc.TitreDocument__c, doc.id);
        }
        Contrat__c cont = new Contrat__c();
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = retVal + '';
        ws.Type__c = 'getModifierContratRequete';
        //retVal.informationsRetour.messageRetour;
        ws.StatusCode__c = retVal.informationsRetour.codeRetour;
        if(retval.contrat != null) {
            if(retval.contrat.proprietesContrat != null) {
                cont.DKCodeSurContrat__c = retval.contrat.proprietesContrat.DKCodeContrat;
                cont.Tech_ModfierContrat__c = false;
                if(retval.contrat.proprietesContrat.libelle.length() > 80) {
                    cont.Name = retval.contrat.proprietesContrat.libelle.substring(0, 80);
                } else {
                    cont.Name = retval.contrat.proprietesContrat.libelle;
                }
                cont.Commentaire__c = retval.contrat.proprietesContrat.commentaire;
                //cont.ControleContrat__c = retval.contrat.proprietesContrat.controleContrat;
                //cont.Statut__c = retval.contrat.proprietesContrat.statutContrat;
                //cont.Staut_Facturation__c = retval.contrat.proprietesContrat.statutFacturation;
                cont.MotifRejet__c = retval.contrat.proprietesContrat.motifRejet;
                cont.StatutServices__c = retval.contrat.proprietesContrat.statutServices;
                cont.CategorieContrat__c = retval.contrat.proprietesContrat.categorieContrat;
                cont.Interco__c = retval.contrat.proprietesContrat.interco;
                if(retval.contrat.proprietesContrat.formeJuridique != null) {
                    cont.FormeJuridique__c = retval.contrat.proprietesContrat.formeJuridique.right(5);
                }
                cont.Langue__c = retval.contrat.proprietesContrat.langue;
                cont.Devise__c = retval.contrat.proprietesContrat.devise;
                cont.Numdossier__c = retval.contrat.proprietesContrat.numeroDossier;
                //cont.ContratOrigine__c = retval.contrat.proprietesContrat.contratDorigine;
                cont.EstContratNational__c = retval.contrat.proprietesContrat.estContratNational;
                cont.NatureContrat__c = retval.contrat.proprietesContrat.natureContrat;
                cont.OrigineContrat__c = retval.contrat.proprietesContrat.provenanceContrat;
                //cont.Datevalidation__c = retval.contrat.proprietesContrat.dateDeValidation;
                DateTime DateValidationOriginal = retval.contrat.proprietesContrat.dateDeValidation;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.Datevalidation__c = DateValidationConverted;
                }
                cont.Motif_fermeture_contrat__c = retval.contrat.proprietesContrat.motifDeFermeture;
                cont.Condition_de_fermeture__c = retval.contrat.proprietesContrat.conditionDeFermeture;
                //cont.DateFin__c = retval.contrat.proprietesContrat.dateDeFin;
                DateTime DateFinOriginal = retval.contrat.proprietesContrat.dateDeFin;
                if(DateFinOriginal != null) {
                    Date DateFinConverted = date.newinstance(DateFinOriginal.year(), DateFinOriginal.month(), DateFinOriginal.day());
                    cont.DateFin__c = DateFinConverted;
                }
                cont.EstContratcadre__c = retval.contrat.proprietesContrat.estContratCadre;
                cont.ReportingContrat__c = retval.contrat.proprietesContrat.reportingContrat;
                //CentreFinance__c cf = [SELECT DkCode__c from CentreFinance__c where id =: retval.contrat.proprietesContrat.UOPiloteContrat];
                //cont.UOPiloteContrat__c = cf.DkCode__c;
                cont.TypeContrat__c = retval.contrat.proprietesContrat.typeContratFacturation;
                //07-03-2022 Added by Jimmy US C360-655
                cont.NatureContratCadre__c = retval.contrat.proprietesContrat.typeContrat;
                //end US C360-655
            }
            if(retval.contrat.contratCadre != null) {
                List<Contrat__c> contratCadre = [SELECT id, DkCodesurcontrat__c FROM Contrat__c where DkCodesurcontrat__c = : retval.contrat.contratCadre.contratCadre];
                if(contratCadre != null && contratCadre.size() > 0) {
                    cont.ContratCadre__c = contratCadre[0].id;
                }
            }
            if(retval.contrat.listeDocuments != null) {
                List<Document_contractuel__c> docList = new List<Document_contractuel__c>();
                Set<String> userIds = new Set<String>();
                for(wwwDalkiaFrReferentielContrat.document docloop : retval.contrat.listeDocuments.document) {
                    if(String.isNotBlank(docloop.metadonneesDocument.creationId)) {
                        userIds.add(docloop.metadonneesDocument.creationId);
                    }
                    if(String.isNotBlank(docloop.metadonneesDocument.UpdateId)) {
                        userIds.add(docloop.metadonneesDocument.UpdateId);
                    }
                    if(String.isNotBlank(docloop.metadonneesDocument.ValidationId)) {
                        userIds.add(docloop.metadonneesDocument.ValidationId);
                    }
                }
                List<User> userDoc = new List<User>();
                userDoc = [Select id, name, ReferentielId__c from user where ReferentielId__c in : userIds];
                for(wwwDalkiaFrReferentielContrat.document docloop : retval.contrat.listeDocuments.document) {
                    Document_contractuel__c doc = new Document_contractuel__c();
                    doc.DateDeclenchement__c = System.now();
                    doc.SynchronisationDate__c = System.now();
                    doc.NumeroPiece__c = docLoop.numeroPiece;
                    doc.ReferenceDuree__c = docLoop.referenceDuree;
                    doc.NatureDocument__c = docLoop.natureDocument;
                    doc.contrat__c = contratID;
                    doc.TitreDocument__c = docLoop.titreDocument;
                    if(doc.TitreDocument__c != null && mapNameDoc.keyset().contains(doc.TitreDocument__c) && mapNameDoc.get(doc.TitreDocument__c) != null) {
                        doc.id = mapNameDoc.get(doc.TitreDocument__c);
                    }
                    DateTime dateSignatureOriginal = docLoop.dateSignature;
                    if(dateSignatureOriginal != null) {
                        Date dateSignatureConverted = date.newinstance(dateSignatureOriginal.year(), dateSignatureOriginal.month(), dateSignatureOriginal.day());//
                        doc.DateSignature__c = dateSignatureConverted;
                    }
                    DateTime datePriseEffetOriginal = docLoop.datePriseEffet;
                    if(datePriseEffetOriginal != null) {
                        Date datePriseEffetConverted = date.newinstance(datePriseEffetOriginal.year(), datePriseEffetOriginal.month(), datePriseEffetOriginal.day());
                        doc.DatePriseEffet__c = datePriseEffetConverted;
                    }
                    doc.statutDocument__c = docLoop.statutDocument;
                    doc.DateStockage__c = docLoop.dateStockage;
                    if(docloop.avenants != null) {
                        cont.Misejourconditionsduree__c = docloop.avenants.MAJConditionsDuree;
                        cont.Misejourconditionstechniques__c = docloop.avenants.MAJConditionsTechniques;
                        cont.Misejourconditionsfacturation__c = docloop.avenants.MAJConditionsFacturation;
                        cont.Ajoutprestations__c = docloop.avenants.ajoutPrestations;
                        cont.Retraitprestations__c = docloop.avenants.retraitPrestations;
                        cont.Autresmodifications__c = docloop.avenants.autresModifications;
                    }
                    doc.CreateDate__c = docLoop.metadonneesDocument.creationDate;
                    if(userDoc != null && userDoc.size() > 0) {
                        for(User userLoop : userDoc) {
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.creationId) {
                                doc.CreateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.updateId) {
                                doc.updateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonneesDocument.validationId) {
                                doc.validationId__c = userLoop.id;
                            }
                        }
                    }
                    doc.UpdateDate__c = docLoop.metadonneesDocument.updateDate;
                    doc.ValidationDate__c = docLoop.metadonneesDocument.validationDate;
                    docList.add(doc);
                }
                try {
                    //update docList;
                }
                catch(Exception e) {
                    system.debug('Error ' + e);
                    WebserviceLog__c wsLog = new WebserviceLog__c();
                    wsLog.Type__c = 'GetModifierContrat - Document Erreur'; wsLog.flux__c = 'sortant'; ws.ErrorText__c = e.getMessage();
                    if(ws.ErrorText__c != null && ws.ErrorText__c.length() > 254) {
                        ws.ErrorText__c =  ws.ErrorText__c.substring(0, 254);
                    }
                    wsLog.Request__c = docList + '';  wsLog.ObjectId__c = cont.Id; wsLog.CodeRetour__c = 'KO'; insert wsLog;
                }
            }
            if(retval.contrat.durees != null) {
                //DateTime DatepriseeffetinitialeOriginal = retval.contrat.durees.datePriseEffetInitiale;
                //if(DatepriseeffetinitialeOriginal!=null){
                //Date DatepriseeffetinitialeConverted = date.newinstance(DatepriseeffetinitialeOriginal.year(), DatepriseeffetinitialeOriginal.month(), DatepriseeffetinitialeOriginal.day());
                //cont.Datepriseeffetinitiale__c = DatepriseeffetinitialeConverted;
                //}
                //cont.DureeInitialeContrat__c = retval.contrat.durees.dureeInitialeContrat;
                //cont.TypeReconduction__c = retval.contrat.durees.typeReconduction ;
                //cont.DureeReconduction__c = retval.contrat.durees.dureeReconduction;
                //cont.DureePreavis__c = retval.contrat.durees.dureePreavis;
                //cont.NombreReconductionsAutorisees__c = retval.contrat.durees.nombreReconductionAutorise;
                //cont.DureeMaximaleCumulee_del__c = retval.contrat.durees.dureeMaximaleCumulee;
                //cont.ReconductionFaitAutorisee__c = retval.contrat.durees.reconductionFaitAutorisee;
                //cont.NombreReconductionsPassees__c = retval.contrat.durees.nombreReconductionsPassees;
                /*
                   DateTime DateProchainPreavisOriginal = retval.contrat.durees.dateProchainPreavis;

                   if(DateProchainPreavisOriginal != null) {
                    Date DateProchainPreavisConverted = date.newinstance(DateProchainPreavisOriginal.year(), DateProchainPreavisOriginal.month(), DateProchainPreavisOriginal.day());
                    cont.DateProchainPreavis__c = DateProchainPreavisConverted;
                   }
                 */
                /*
                   DateTime DateProchaineEcheanceOriginal = retval.contrat.durees.dateProchaineEcheance;
                   if(DateProchaineEcheanceOriginal != null) {
                    Date DateProchaineEcheanceConverted = date.newinstance(DateProchaineEcheanceOriginal.year(), DateProchaineEcheanceOriginal.month(), DateProchaineEcheanceOriginal.day());
                    cont.DateProchaineEcheance__c = DateProchaineEcheanceConverted;
                   }
                 */
                //cont.DureeProlongationTotale__c = retval.contrat.durees.dureeProlongation;
            }
            if(retval.contrat.listeResumes != null) {
                if(retval.contrat.listeResumes.resume != null) {
                    for(wwwDalkiaFrReferentielContrat.resume res : retval.contrat.listeResumes.resume) {
                        cont.ParametrePortailClient__c = res.parametrePortailClient;
                        cont.PrecisionParametre__c = res.precisionParametre;
                        cont.InformationComplementaire__c = res.informationComplementaire;
                        //cont.ValeurContractuelle__c = res.valeurContractuelle;
                        cont.UniteValeurContractuelle__c = res.uniteValeurContractuelle;
                    }
                }
            }

            //Added by Jimmy 08/02/2022 - CVS
            if(retval.contrat.proprietesCvs != null) {
                cont.natureOffre__c = retval.contrat.proprietesCvs.natureOffre;
                cont.engagementEnergetique__c = retval.contrat.proprietesCvs.engagementEnergetique;
                cont.paiementDesEnergies__c = retval.contrat.proprietesCvs.paiementDesEnergies;
                cont.niveauDeMaintenance__c = retval.contrat.proprietesCvs.niveauDeMaintenance;
            }
            //end CVS

            /*if(retval.contrat.listeServices != null){
               if(retval.contrat.listeServices.service != null){
               for(wwwDalkiaFrReferentielContrat.service ser : retval.contrat.listeServices.service){
               cont.Service__c = ser.service;
               cont.Penalitesassocies__c = ser.penalitesAssociees;
               cont.Perimtrerealisation__c = ser.perimetreRealisation;
               cont.Statut_Lien_Service__c = ser.statutLienService;
               if(ser.listePrestations != null){
               if(ser.listePrestations.prestation != null){
               for(wwwDalkiaFrReferentielContrat.prestation pres: ser.listePrestations.prestation){
               cont.Prestation__c = pres.prestation;
               //cont.Prestation_Personnalisee__c = pres.prestationExternalisee;
               cont.Mode_Remuneration__c = pres.modeRemuneration;
               //cont.Service__c = pres.gestionLivreOuvert;
               //cont.Service__c = pres.complementInformation;
               cont.Statut_Lien_Prestation__c = pres.statutLienPrestation;
               }
               }
               }
               }
               }
               }*/
            if(retval.contrat.listePartenaires != null) {
                if(retval.contrat.listePartenaires.partenaire != null) {
                    List<EcosystemePartenaire__c> listEcoSys = new List<EcosystemePartenaire__c>();
                    Set<String> dkCodeAcccounts = new set<String>();
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        dkCodeAcccounts.add(part.partenaire);
                    }
                    List<Account> listAcc = [Select id, DKCodeSurPartenaire__c from account where DKCodeSurPartenaire__c in : dkCodeAcccounts];
                    Map<String, String> dkCodeIdMap = new map<String, String>();
                    for(Account acc : listAcc) {
                        dkCodeIdMap.put(acc.DKCodeSurPartenaire__c, acc.id);
                    }
                    Integer countSignPart = 0;
                    String partCont = '';
                    for(wwwDalkiaFrReferentielContrat.partenaire part : retval.contrat.listePartenaires.partenaire) {
                        if(part.statutLienPartenaire != null && part.statutLienPartenaire) {
                            if(!String.isBlank(part.rolePartenaire)) {
                                if(part.rolePartenaire.equals('SIGN') && countSignPart == 0) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        if(dkCodeIdMap.get(part.partenaire) != null) {
                                            cont.NomPartenaire__c = dkCodeIdMap.get(part.partenaire);
                                            partCont = dkCodeIdMap.get(part.partenaire);
                                            ++countSignPart;
                                        }
                                    }
                                } else if(part.rolePartenaire.equals('PRST')) {
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        cont.SocieteVenteLookup__c = dkCodeIdMap.get(part.partenaire);
                                    }
                                } else if(part.rolePartenaire.equals('SIGN') && countSignPart > 0) {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    ecoSys.TypeRelation__c = part.rolePartenaire;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                } else {
                                    EcosystemePartenaire__c ecoSys = new EcosystemePartenaire__c();
                                    String role = part.rolePartenaire;
                                    if(role == 'FACT') {
                                        role = 'FACT_1';
                                    }
                                    if(role == 'REPR') {
                                        role = 'REPR_1';
                                    }
                                    ecoSys.TypeRelation__c = role;
                                    if(dkCodeIdMap.get(part.partenaire) != null) {
                                        //ecoSys.Partenaire__c = partCont;
                                        ecoSys.PartenaireLie__c = dkCodeIdMap.get(part.partenaire);
                                        ecoSys.Statut__c = 'Actif';
                                        ecoSys.Contrat__c = cont.id; //contrat already inserted before this call
                                    }
                                    listEcoSys.add(ecoSys);
                                }
                            }
                        }
                    }
                }
            }
            if(retval.contrat.listeAffaires != null) {
                if(retval.contrat.listeAffaires.affaire != null) {
                    for(wwwDalkiaFrReferentielContrat.affaire aff : retval.contrat.listeAffaires.affaire) {
                        //cont.Affaire__c = aff.affaire;
                        cont.Statut_Lien_Affaire__c = aff.statutLienAffaire;
                    }
                }
            }
            if(retval.contrat.listeProjetsFinance != null) {
                if(retval.contrat.listeProjetsFinance.projetFinance != null) {
                    for(wwwDalkiaFrReferentielContrat.projetFinance proj : retval.contrat.listeProjetsFinance.projetFinance) {
                        //proj.tacheFinance;
                        //proj.projetFinance;
                        //proj.statutLienTF;
                    }
                }
            }
            if(retval.contrat.listeResponsables != null) {
                if(retval.contrat.listeResponsables.responsable != null) {
                    for(wwwDalkiaFrReferentielContrat.responsable resp : retval.contrat.listeResponsables.responsable) {
                        //resp.responsableContrat;
                        cont.Perimetreresponsable__c = resp.perimetreResponsable;
                        //cont.Statut_Lien_responsable__c = resp.statutLienResponsable = '';
                    }
                }
            }
            if(retval.contrat.numerotationContrat != null) {
                cont.Applicationsourcecontrat__c = retval.contrat.numerotationContrat.applicationSource;
                //cont.TechNumeroContrat2__c = retval.contrat.numerotationContrat.codeSource;
            }
            if(retval.contrat.metadonneesContrat != null) {
                //retval.contrat.metadonneesContrat.creationDate;
                //cont.currentUser.ReferentielId__c = retval.contrat.metadonneesContrat.creationId;
                //retval.contrat.metadonneesContrat.updateDate;
                //cont.currentUser.ReferentielId__c = retval.contrat.metadonneesContrat.updateId;
                //retval.contrat.metadonneesContrat.validationDate;
                //retval.contrat.metadonneesContrat.validationId;

                cont.CreateDate__c = retVal.contrat.metadonneesContrat.creationDate;
                List<User> usr1 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.creationId limit 1];
                if(usr1 != null && usr1.size() > 0) {
                    cont.CreateId__c = usr1[0].Id;
                }
                cont.UpdateDate__c = retval.contrat.metadonneesContrat.updateDate;
                List<User> usr2 = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.updateId limit 1];
                if(usr2 != null && usr2.size() > 0) {
                    cont.UpdateId__c = usr2[0].Id;
                }
                DateTime DateValidationOriginal = retval.contrat.metadonneesContrat.validationDate;
                if(DateValidationOriginal != null) {
                    Date DateValidationConverted = date.newinstance(DateValidationOriginal.year(), DateValidationOriginal.month(), DateValidationOriginal.day());
                    cont.ValidationDate__c = DateValidationConverted;
                }
                if(!String.isBlank(retval.contrat.metadonneesContrat.validationId)) {
                    List<User> usr = [ select id, name, ReferentielId__c from user where ReferentielId__c = : retval.contrat.metadonneesContrat.validationId LIMIT 1];
                    if(usr != null && usr.size() > 0 && String.isNotBlank(usr[0].ReferentielId__c)) {
                        cont.Validation_Id__c   = usr[0].Id;
                    }
                }
            }
        }

        return cont;
    }

    private static List<String> removeListValue(List<String> listToModify, String valueToRemove){
        Set<String> temp = new Set<String>();
        temp.addAll(listToModify);
        temp.remove(valueToRemove);
        List<String> listNew = new List<String>();
        listNew.addAll(temp);

        return listNew;
    }
}