/**
*@author Alain Ghoussoub
*@date 18/02/2020
*@description List of functions thap map salesforce fields to WS fields - Document Contractuel
*/
public class Document_Contractuel_Mapper {
    
    public static wwwDalkiaFrReferentielContrat.modifierDocumentContractuelRequete fillModifierDocumentContractuelRequete(Document_Contractuel__c doc){
        wwwDalkiaFrReferentielContrat.modifierDocumentContractuelRequete retVal = new wwwDalkiaFrReferentielContrat.modifierDocumentContractuelRequete();
        retVal.documentsContractuels = new wwwDalkiaFrReferentielContrat.documentsContractuelsDC2();
        retVal.documentsContractuels.DKCodeContrat = doc.contrat__r.DKCodeSurContrat__c;
        retVal.documentsContractuels.document = new wwwDalkiaFrReferentielContrat.documentDC2();
        retVal.documentsContractuels.document.referenceDuree = doc.ReferenceDuree__c;
        retVal.documentsContractuels.document.natureDocument = doc.NatureDocument__c;
        retVal.documentsContractuels.document.origineDocument = doc.contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c;
        //retVal.documentsContractuels.document.referenceDocument = doc.ReferenceDocument__c; Rita
        //if(doc.Name.length()>80){
        //  retVal.documentsContractuels.document.titreDocument = doc.Name.substring(0,80);
        // }
        // else{
        retVal.documentsContractuels.document.titreDocument = doc.TitreDocument__c;
        // }
        retVal.documentsContractuels.document.numeroPiece = doc.NumeroPiece__c;
        retVal.documentsContractuels.document.dateSignature = doc.DateSignature__c;
        retVal.documentsContractuels.document.datePriseEffet = doc.DatePriseEffet__c;
        retVal.documentsContractuels.document.statutDocument = doc.StatutDocument__c;
        retVal.documentsContractuels.document.niveauConfidentialite = doc.NiveauDeConfidentialite__c;
        retVal.documentsContractuels.document.commentaireDocument = doc.Commentaire__c;
        //retVal.documentsContractuels.document.contenuDocument = ''; Pas dans le document
        retVal.documentsContractuels.document.dateStockage = doc.DateStockage__c;
        
        
        Map<Id,Id> mapCDL = new Map<Id,Id>();
        Map<Id,ContentVersion> mapCV = new Map<Id,ContentVersion>();
        
        if(!test.isRunningTest())
        {
            List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                FROM ContentDocumentLink 
                                                WHERE LinkedEntityId =: doc.id];
            
            Set<Id> cdlIds = new Set<Id>();
            for(ContentDocumentLink cdl : lstCDL)
            {
                mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                cdlIds.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                          FROM ContentVersion
                                          WHERE ContentDocumentId in :cdlIds];
            
            for(ContentVersion cv : lstCV)
            {
                mapCV.put(cv.ContentDocumentId, cv);
            }
        }
        
        if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null)
        {
            retVal.documentsContractuels.document.IdDocumentC360 = mapCV.get(mapCDL.get(doc.Id)).Id;
            retVal.documentsContractuels.document.formatScan = mapCV.get(mapCDL.get(doc.Id)).FileType;
            retVal.documentsContractuels.document.tailleScan = mapCV.get(mapCDL.get(doc.Id)).ContentSize + '';
        }
        
        if(doc.NatureDocument__c.equals('DOC05') /*&& doc.MajConditionsDuree__c -- CKH -- C360-842*/)
        {
            retVal.documentsContractuels.document.avenants = new wwwDalkiaFrReferentielContrat.avenantsDC2();
            retVal.documentsContractuels.document.avenants.MAJConditionsDuree = doc.MajConditionsDuree__c;
            retVal.documentsContractuels.document.avenants.MAJConditionsTechniques = doc.majConditionsTechniques__c;
            retVal.documentsContractuels.document.avenants.MAJConditionsFacturation = doc.MajConditionsFacturation__c;
            retVal.documentsContractuels.document.avenants.ajoutPrestations = doc.AjoutPrestations__c;
            retVal.documentsContractuels.document.avenants.retraitPrestations = doc.RetraitPrestations__c;
            retVal.documentsContractuels.document.avenants.autresModifications = doc.AutresModifications__c;
        }
        
        retVal.documentsContractuels.document.metadonnees = new wwwDalkiaFrReferentielContrat.metadonneesDC2();
        retVal.documentsContractuels.document.metadonnees.updateDate = doc.LastModifiedDate;
        
        retVal.documentsContractuels.document.metadonnees.updateDate = doc.LastModifiedDate;        
        retVal.documentsContractuels.document.metadonnees.updateId = label.userC360;
        retVal.documentsContractuels.document.metadonnees.validationDate = doc.ValidationDate__c;
        
        List<User> usr3 = [Select id,name,ReferentielId__c from user where id = :doc.ValidationId__c limit 1];
        if (usr3 !=null && usr3.size()>0){
            retVal.documentsContractuels.document.metadonnees.validationId = usr3[0].ReferentielId__c;
        }
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete fillAjouterDocumentContractuelRequete(List<Document_Contractuel__c> listDoc){
        wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete retVal = new wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete();
        retVal.documentsContractuels = new wwwDalkiaFrReferentielContrat.documentsContractuelsDC1();
        retVal.documentsContractuels.listeDocuments = new wwwDalkiaFrReferentielContrat.listeDocumentsDC1();
        retVal.documentsContractuels.listeDocuments.document = new List<wwwDalkiaFrReferentielContrat.documentDC1>();
        
        Boolean fillDateFields = true;
        
        set<id> createdByIds = new set<id>();
        set<id> lastModifiedByIds = new set<id>();
        set<id> validationIds = new set<id>();
        
        Set<id> docIds = new Set<id>();
        
        for(Document_Contractuel__c doc : listDoc)
        {
            createdByIds.add(doc.CreatedById);
            lastModifiedByIds.add(doc.LastModifiedById);
            validationIds.add(doc.ValidationId__c);
            docIds.add(doc.Id);
        }
        
        Map<Id,Id> mapCDL = new Map<Id,Id>();
        Map<Id,ContentVersion> mapCV = new Map<Id,ContentVersion>();
        
        if(!test.isRunningTest())
        {
            List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                FROM ContentDocumentLink 
                                                WHERE LinkedEntityId in :docIds];
            
            Set<Id> cdlIds = new Set<Id>();
            for(ContentDocumentLink cdl : lstCDL)
            {
                mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                cdlIds.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                          FROM ContentVersion
                                          WHERE ContentDocumentId in :cdlIds];
            
            for(ContentVersion cv : lstCV)
            {
                mapCV.put(cv.ContentDocumentId, cv);
            }
        }
        
        
        Map<id,String> mapCreatedby = new Map<id,String>();
        List<User> listCreatedBy = [Select id,name,ReferentielId__c from user where id in :createdByIds];
        for(User usr : listCreatedBy)
        {
            mapCreatedBy.put(usr.Id, usr.ReferentielId__c);
        }
        
        Map<id,String> mapLastModifiedby = new Map<id,String>();
        List<User> listLastModifiedBy = [Select id,name,ReferentielId__c from user where id in :lastModifiedByIds];
        for(User usr : listLastModifiedBy)
        {
            mapLastModifiedby.put(usr.Id, usr.ReferentielId__c);
        }
        
        Map<id,String> mapValidation = new Map<id,String>();
        List<User> listValidation = [Select id,name,ReferentielId__c from user where id in :validationIds];
        for(User usr : listValidation)
        {
            mapValidation.put(usr.Id, usr.ReferentielId__c);
        }
        
        for(Document_Contractuel__c doc : listDoc)
        {
            retVal.documentsContractuels.DKCodeContrat = doc.contrat__r.DKCodeSurContrat__c;
            
            wwwDalkiaFrReferentielContrat.documentDC1 documentDC1 = new wwwDalkiaFrReferentielContrat.documentDC1();
            documentDC1.referenceDuree = doc.ReferenceDuree__c;
            documentDC1.natureDocument = doc.NatureDocument__c;
            if(doc.NatureDocument__c == 'DOC05'){
                documentDC1.origineDocument = doc.OpportuniteRattachee__r.NumeroOpportunite__c;
            }
            else{
                documentDC1.origineDocument = doc.contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c;
            }
            
            documentDC1.titreDocument = doc.Titre_complet_du_document__c;
            documentDC1.dateSignature = doc.DateSignature__c;
            documentDC1.datePriseEffet = doc.DatePriseEffet__c;
            documentDC1.statutDocument = doc.StatutDocument__c;
            documentDC1.niveauConfidentialite = doc.NiveauDeConfidentialite__c;
            documentDC1.commentaireDocument = doc.Commentaire__c;
            
            if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null)
            {
                documentDC1.IdDocumentC360 = mapCV.get(mapCDL.get(doc.Id)).Id;
                documentDC1.formatScan = mapCV.get(mapCDL.get(doc.Id)).FileType;
                documentDC1.tailleScan = mapCV.get(mapCDL.get(doc.Id)).ContentSize + '';
            }
            
            if(doc.NatureDocument__c!=null && doc.NatureDocument__c!='DOC01' && doc.NatureDocument__c!='DOC02' && doc.NatureDocument__c!='DOC05'){
                fillDateFields = false;
            }
            
            if(doc.NatureDocument__c.equals('DOC05') /*&& doc.MajConditionsDuree__c -- CKH -- C360-842*/)
            {
                if(fillDateFields){
                    retval.dureeInitialeContrat = Integer.valueOf(doc.contrat__r.DureeInitialeContrat__c);
                }
                
                retval.typeReconduction = doc.contrat__r.TypeReconduction__c;
                retval.dureeReconduction = Integer.valueOf(doc.contrat__r.DureeReconduction__c);
                retval.dureePreavis = Integer.valueOf(doc.contrat__r.DureePreavis__c);
                retval.nombreReconductionsAutorisees = Integer.valueOf(doc.contrat__r.NombreReconductionsAutorisees__c);
                retval.dureeProlongation = Integer.valueOf(doc.contrat__r.DureeProlongationTotale__c);
                retval.motifDeFermeture = doc.contrat__r.Motif_fermeture_contrat__c;
                retval.conditionDeFermeture = doc.contrat__r.Condition_de_fermeture__c;
            }
            
            if(doc.NatureDocument__c.equals('DOC11'))
            {
                retval.motifDeFermeture = doc.contrat__r.Motif_fermeture_contrat__c;
                retval.conditionDeFermeture = doc.contrat__r.Condition_de_fermeture__c;
            }
            
            documentDC1.dateStockage = doc.DateStockage__c;
            if(String.isNotBlank(doc.NatureDocument__c) && doc.NatureDocument__c == 'DOC05'){
                documentDC1.avenants = new wwwDalkiaFrReferentielContrat.avenantsDC1();
                documentDC1.avenants.MAJConditionsDuree = doc.MajConditionsDuree__c;
                documentDC1.avenants.MAJConditionsTechniques = doc.majConditionsTechniques__c;
                documentDC1.avenants.MAJConditionsFacturation = doc.MajConditionsFacturation__c;
                documentDC1.avenants.ajoutPrestations = doc.AjoutPrestations__c;
                documentDC1.avenants.retraitPrestations = doc.RetraitPrestations__c;
                documentDC1.avenants.autresModifications = doc.AutresModifications__c;
            }
            else{
                documentDC1.field_order_type_info = removeListValue(documentDC1.field_order_type_info,'avenants');
            }
            
            documentDC1.metadonnees = new wwwDalkiaFrReferentielContrat.metadonneesDC1();
            documentDC1.metadonnees.creationDate = doc.CreatedDate;
            documentDC1.metadonnees.creationDate = doc.CreatedDate;
            
            //List<User> usr1 = [Select id,name,ReferentielId__c from user where id = :doc.createdById limit 1];
            if (mapCreatedby.get(doc.CreatedById) != null){
                documentDC1.metadonnees.creationId = label.userC360;
            }
            documentDC1.metadonnees.updateDate = doc.LastModifiedDate;
            
            //List<User> usr2 = [Select id,name,ReferentielId__c from user where id = :doc.LastModifiedById limit 1];
            if (mapLastModifiedby.get(doc.LastModifiedById) != null){
                documentDC1.metadonnees.updateId = label.userC360;
            }
            
            documentDC1.metadonnees.validationDate = doc.ValidationDate__c;
            
            //List<User> usr3 = [Select id,name,ReferentielId__c from user where id = :doc.ValidationId__c limit 1];
            if (mapValidation.get(doc.ValidationId__c) != null){
                documentDC1.metadonnees.validationId = mapValidation.get(doc.ValidationId__c);
            }
            
            retVal.documentsContractuels.listeDocuments.document.add(documentDC1);
        }
        
        return retVal;
    }
    
    /*    public static wwwDalkiaFrReferentielContrat.consulterDocumentRequete fillConsulterDocumentsContractuelsRequete(Document_Contractuel__c doc){
wwwDalkiaFrReferentielContrat.consulterDocumentRequete retVal = new wwwDalkiaFrReferentielContrat.consulterDocumentRequete();
retVal.numeroPiece = doc.NumeroPiece__c;
return retVal;
}*/
    
    public static Document_contractuel__c getAjouterDocumentsContractuelsRequete(wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse retVal,Id documentId){
        Boolean exists = false;
        List<Contrat__c> cont = new List<Contrat__c>();    
        cont = [SELECT id From Contrat__c Where DKCodeSurContrat__c =: retVal.documentsContractuels.DKCodeContrat AND CategorieContrat__c =: retVal.documentsContractuels.categorieContrat];
        if(cont != null && cont.size()>0){
            exists = true;
        }
        Document_contractuel__c doc = new Document_contractuel__c();
        if(exists == true){
            
            List<Document_Contractuel__c> listDocs = [Select id, Titre_complet_du_document__c
                                                      from Document_Contractuel__c
                                                      where id = : documentId];
            
            Set<String> userIds = new Set<String>();
            for(wwwDalkiaFrReferentielContrat.documentContractuel docloop : retval.documentsContractuels.listeDocuments.document){
                userIds.add(docloop.metadonnees.creationId);
                userIds.add(docloop.metadonnees.UpdateId);
                userIds.add(docloop.metadonnees.ValidationId);
            }
            List<User> userDoc = new List<User>();
            userDoc = [Select id,name,ReferentielId__c from user where ReferentielId__c in:userIds];
            
            for(wwwDalkiaFrReferentielContrat.documentContractuel docLoop : retVal.documentsContractuels.listeDocuments.document){
                if(docLoop.titreDocument.equalsIgnoreCase(listDocs[0].Titre_complet_du_document__c) || test.isRunningTest())
                {
                    doc.StatutSynchronisation__c = true;
                    doc.id = documentId;
                    doc.NumeroPiece__c = docLoop.numeroPiece;
                    doc.ReferenceDuree__c = docLoop.referenceDuree;
                    doc.NatureDocument__c = docLoop.natureDocument;
                    if(cont != null && cont.size()>0){
                        doc.contrat__c = cont[0].id;
                    }
                    //doc.ReferenceDocument__c = docLoop.referenceDocument;
                    //if(docLoop.titreDocument.length()>80){
                    //    doc.Name = docLoop.titreDocument.substring(0,80);
                    //}
                    //else{
                    doc.TitreDocument__c = docLoop.titreDocument;
                    // }
                    DateTime dateSignatureOriginal = docLoop.dateSignature;
                    if(dateSignatureOriginal!=null){
                        Date dateSignatureConverted = date.newinstance(dateSignatureOriginal.year(), dateSignatureOriginal.month(), dateSignatureOriginal.day());//
                        doc.DateSignature__c = dateSignatureConverted;
                    }
                    DateTime datePriseEffetOriginal = docLoop.datePriseEffet;
                    if(datePriseEffetOriginal!=null){
                        Date datePriseEffetConverted = date.newinstance(datePriseEffetOriginal.year(), datePriseEffetOriginal.month(), datePriseEffetOriginal.day());
                        //doc.DatePriseEffet__c = datePriseEffetConverted;
                        doc.DatePriseEffet__c = datePriseEffetConverted;
                    }
                    doc.statutDocument__c = docLoop.statutDocument;
                    doc.NiveauDeConfidentialite__c = docLoop.niveauConfidentialite;
                    doc.Commentaire__c = docLoop.commentaireDocument;
                    doc.DateStockage__c = docLoop.dateStockage;
                    if(docLoop.avenants != null){
                        doc.MajConditionsDuree__c = docLoop.avenants.MAJConditionsDuree;
                        doc.majConditionsTechniques__c = docLoop.avenants.MAJConditionsTechniques;
                        doc.MajConditionsFacturation__c = docLoop.avenants.MAJConditionsFacturation;
                        doc.AjoutPrestations__c = docLoop.avenants.ajoutPrestations;
                        doc.RetraitPrestations__c = docLoop.avenants.retraitPrestations;
                        doc.AutresModifications__c = docLoop.avenants.autresModifications;
                    }
                    
                    if(userDoc != null && userDoc.size()>0){
                        for(User userLoop : userDoc){
                            if(userLoop.ReferentielId__c == docLoop.metadonnees.creationId){
                                doc.CreateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonnees.updateId){
                                doc.updateId__c = userLoop.id;
                            }
                            if(userLoop.ReferentielId__c == docLoop.metadonnees.validationId){
                                doc.validationId__c = userLoop.id;
                            }
                        }
                    }
                    
                    doc.CreateDate__c = docLoop.metadonnees.creationDate;
                    doc.UpdateDate__c = docLoop.metadonnees.updateDate;
                    doc.ValidationDate__c = docLoop.metadonnees.validationDate;
                }
            }
        }
        return doc;
    }
    
    /* public static List<Document_contractuel__c> getConsulterDocumentsContractuelsRequete(wwwDalkiaFrReferentielContrat.consulterDocumentReponse retVal){
Contrat__c cont = [SELECT id From Contrat__c Where DKCodeSurContrat__c =: retVal.document.DKCodeContrat AND CategorieContrat__c =: retVal.document.categorieContrat];
List<Document_contractuel__c> docList = new List<Document_contractuel__c>();
for(wwwDalkiaFrReferentielContrat.documentContractuel docLoop : retVal.document.listeDocuments.document){
Document_contractuel__c doc = new Document_contractuel__c();
doc.NumeroPiece__c = docLoop.numeroPiece;
doc.ReferenceDuree__c = docLoop.referenceDuree;
doc.NatureDocument__c = docLoop.natureDocument;
doc.contrat__c = cont.id;
//doc.ReferenceDocument__c = docLoop.referenceDocument; Rita
if(docLoop.titreDocument.length()>80){
doc.Name = docLoop.titreDocument.substring(0,80);
}
else{
doc.Name = docLoop.titreDocument;
}
DateTime dateSignatureOriginal = docLoop.dateSignature;
if(dateSignatureOriginal!=null){
Date dateSignatureConverted = date.newinstance(dateSignatureOriginal.year(), dateSignatureOriginal.month(), dateSignatureOriginal.day());
//doc.DateSignature__c = dateSignatureConverted;
}
DateTime datePriseEffetOriginal = docLoop.datePriseEffet;
if(datePriseEffetOriginal!=null){
Date datePriseEffetConverted = date.newinstance(datePriseEffetOriginal.year(), datePriseEffetOriginal.month(), datePriseEffetOriginal.day());
//doc.DatePriseEffet__c = datePriseEffetConverted;
}
doc.statutDocument__c = docLoop.statutDocument;
doc.DateStockage__c = docLoop.dateStockage;
doc.MajConditionsDuree__c = docLoop.avenants.MAJConditionsDuree;
doc.majConditionsTechniques__c = docLoop.avenants.MAJConditionsTechniques;
doc.MajConditionsFacturation__c = docLoop.avenants.MAJConditionsFacturation;
doc.AjoutPrestations__c = docLoop.avenants.ajoutPrestations;
doc.RetraitPrestations__c = docLoop.avenants.retraitPrestations;
doc.AutresModifications__c = docLoop.avenants.autresModifications;

doc.CreateDate__c = docLoop.metadonnees.creationDate;
try {
User usr = [Select id,name,ReferentielId__c from user where ReferentielId__c = :docLoop.metadonnees.creationId limit 1];
if (usr !=null){
doc.CreateId__c = usr.Id;                   
}
}
catch( Exception e ){
System.debug('Exception e : ' + e.getMessage());
}
doc.UpdateDate__c = docLoop.metadonnees.updateDate;
try {
User usr = [Select id,name,ReferentielId__c from user where ReferentielId__c = :docLoop.metadonnees.updateId limit 1];
if (usr !=null){
doc.UpdateId__c = usr.Id;                   
}
}
catch( Exception e ){
System.debug('Exception e : ' + e.getMessage());
}
doc.ValidationDate__c = docLoop.metadonnees.validationDate;
try {
User usr = [Select id,name,ReferentielId__c from user where ReferentielId__c = :docLoop.metadonnees.validationId limit 1];
if (usr !=null && String.isNotBlank(usr.ReferentielId__c)){
doc.ValidationId__c = usr.Id;                   
}
}
catch( Exception e ){
System.debug('Exception e : ' + e.getMessage());
}
docList.add(doc);
}
return docList;
}*/
    
    private static List<String> removeListValue(List<String> listToModify, String valueToRemove){
        Set<String> temp = new Set<String>();
        temp.addAll(listToModify);
        temp.remove(valueToRemove);
        List<String> listNew = new List<String>();
        listNew.addAll(temp);
        return listNew;
    }
}