/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 10/01/2019
* @description: Class qui gère le web service entrant Document Contractuel
*/
global class WS05_ContratDocument {
    global class Document{
        webservice Header Header;
        webservice listeDocuments listeDocuments;
        webservice String DKCodeContrat;
        webservice String categorieContrat;
    }
    global class listeDocuments{
        webservice List<Documents> document;
    }
    global class Documents{
        webservice String numeroPiece;
        webservice Boolean referenceDuree;
        webservice String natureDocument;
        webservice String origineDocument;
        webservice String referenceDocument;//DocumentReference__c
        webservice String titreDocument;
        webservice DateTime dateSignature;
        webservice DateTime datePriseEffet;//DatePriseEffet__c
        webservice String statutDocument;//Statutdocument__c
        webservice DateTime dateStockage;
        webservice Avenants avenants;
        webservice String niveauConfidentialite;//NiveauDeConfidentialite__c
        webservice String commentaireDocument;//Commentaire__c
        webservice Metadonnees_document metadonnees;
    }
    global class Avenants{
        webservice Boolean MAJConditionsDuree;//Misejourconditionsduree__c
        webservice Boolean MAJConditionsTechniques;//Misejourconditionstechniques__c
        webservice Boolean MAJConditionsFacturation;//Misejourconditionsfacturation__c
        webservice Boolean ajoutPrestations;//Ajoutprestations__c
        webservice Boolean retraitPrestations;//Retraitprestations__c
        webservice Boolean autresModifications;//Autresmodifications__c
    }
    global class Metadonnees_document{
        webservice DateTime creationDate;//CreatedDate
        webservice String creationId;//CreatedBy
        webservice DateTime updateDate;//LastModifiedDate
        webservice String updateId;//LastModifiedBy
        webservice DateTime validationDate;
        webservice String validationId;
    }
    webservice static Response insertContratDocument(Document documentsFields) {
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Request__c = documentsFields+'';
        ws.Type__c = Label.WS_Document;
        ws.flux__c = Label.WSTypeFluxEntrant;
        Database.insert(ws, false);
        
        TimeZone tz = TimeZone.getTimeZone('Europe/Paris');
        
        Response resp = new Response();
        Contrat__c cont = new Contrat__c();
        resp.errorText = '';
        resp.error = false;
        resp.responseCode = Label.WS_Response_OK;
        boolean dkExists = false;
        List<Document_Contractuel__c> listDoc = new List<Document_Contractuel__c>();
        
        //délaration des champs WebServiceLog 
        if(documentsFields.header != null){
            if (documentsFields.header.transactionId!=null) {
                ws.TransactionId__c = documentsFields.header.transactionId;
            }
        }
        
        if(String.isBlank(documentsFields.DKCodeContrat)){
            resp.responseCode = Label.WS_Response_KO;
            resp.errorText += Label.WS03_DKCodeContratOB + '\n';
            resp.error = true;
        }
        else{
            ws.DkCode__c= documentsFields.DKCodeContrat; 
            List<Contrat__c> contList = [Select id,name,DKCodeSurContrat__c from Contrat__c where DKCodeSurContrat__c = :documentsFields.DKCodeContrat];
            if(contList.size()>0 && String.isNotBlank(contList.get(0).DKCodeSurContrat__c)){
                cont = contList.get(0);
                dkExists = true;
            }
        }
        
        if(dkExists || Test.isRunningTest())
        {
            //ListDocuments
            if(documentsFields.listeDocuments==null || documentsFields.listeDocuments.document==null || documentsFields.listeDocuments.document.size()==0){
                resp.responseCode = Label.WS_Response_KO;
                resp.errorText += Label.WS03_documentOB + '\n';
                resp.error = true;
            }
            else{
                Set<String> userRefIds = new Set<String>();
                List<User> userMetadonne = new List<User>();
                for(Documents docLoop : documentsFields.listeDocuments.document){
                    if(docLoop.metadonnees != null){
                        if(String.isNotBlank(docLoop.metadonnees.creationId)){
                            userRefIds.add(docLoop.metadonnees.creationId);
                        }
                        if(String.isNotBlank(docLoop.metadonnees.updateId)){
                            userRefIds.add(docLoop.metadonnees.updateId);
                        }
                        if(String.isNotBlank(docLoop.metadonnees.validationId)){
                            userRefIds.add(docLoop.metadonnees.validationId);
                        }
                    }
                }
                if(userRefIds != null && userRefIds.size()>0){
                    userMetadonne = [SELECT id,name,ReferentielId__c 
                                     FROM user 
                                     WHERE ReferentielId__c = :userRefIds];
                }
                Map<String,Id> mapUserRefId = new Map<String,Id>();
                if(userMetadonne != null && userMetadonne.size()>0){
                    for(User userLoop : userMetadonne){
                        mapUserRefId.put(userLoop.ReferentielId__c,userLoop.id);
                    }
                }
                for(Documents docLoop : documentsFields.listeDocuments.document){
                    Document_Contractuel__c doc = new Document_Contractuel__c();
                    if(String.isBlank(docLoop.numeroPiece)){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS03_numeroPieceOB + '\n';
                        resp.error = true;
                    }
                    else{
                        doc.NumeroPiece__c = docLoop.numeroPiece;
                    }
                    if(docLoop.referenceDuree==null){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_referenceDureeOB + '\n';
                        resp.error = true;
                    }
                    else{
                        doc.ReferenceDuree__c = docLoop.referenceDuree;
                    }
                    if(String.isBlank(docLoop.natureDocument)){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_natureDocumentOB + '\n';
                        resp.error = true;
                    }
                    else{
                        doc.NatureDocument__c = docLoop.natureDocument;
                    }
                    
                    /*
if(!String.isBlank(docLoop.origineDocument)){
//doc.? = docLoop.origineDocument; // a demander
}

*/
                    
                    if(!String.isBlank(docLoop.referenceDocument)){
                        doc.ReferenceDocument__c = docLoop.referenceDocument;
                    }
                    if(String.isBlank(docLoop.titreDocument)){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_titreDocumentOB + '\n';
                        resp.error = true;
                    }
                    else{
                        //doc.name = docLoop.titreDocument;
                        doc.TitreDocument__c = docLoop.titreDocument;
                    }
                    if(docLoop.dateSignature==null){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_dateSignatureOB + '\n';
                        resp.error = true;
                    }
                    else{
                        Date DateSignatureConverted = date.newinstance(docLoop.dateSignature.year(), docLoop.dateSignature.month(), docLoop.dateSignature.day());
                        doc.DateSignature__c = DateSignatureConverted;
                        
                        docLoop.dateSignature = docLoop.dateSignature.addSeconds(tz.getOffset(docLoop.dateSignature) / 1000);
                        ws.Request__c = documentsFields+'';
                    }
                    if(docLoop.datePriseEffet==null){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_datePriseEffetOB + '\n';
                        resp.error = true;
                    }
                    else{
                        DateTime DatePriseEffetOriginal = docLoop.datePriseEffet;
                        Date DatePriseEffetConverted = date.newinstance(DatePriseEffetOriginal.year(), DatePriseEffetOriginal.month(), DatePriseEffetOriginal.day());
                        doc.DatePriseEffet__c = DatePriseEffetConverted;
                        
                        docLoop.datePriseEffet = docLoop.datePriseEffet.addSeconds(tz.getOffset(docLoop.datePriseEffet) / 1000);
                        ws.Request__c = documentsFields+'';
                    }
                    if(String.isBlank(docLoop.statutDocument)){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_statutDocumentOB + '\n';
                        resp.error = true;
                    }
                    else{
                        doc.Statutdocument__c = docLoop.statutDocument;
                    }
                    
                    if(String.isBlank(docLoop.niveauConfidentialite)){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_niveauConfOB + '\n';
                        resp.error = true;
                    }
                    else{
                        doc.NiveauDeConfidentialite__c = docLoop.niveauConfidentialite;
                    }
                    
                    if(!String.isBlank(docLoop.commentaireDocument)){
                        doc.Commentaire__c = docLoop.commentaireDocument;
                    }

                    if(docLoop.dateStockage!=null){
                        doc.DateStockage__c = docLoop.dateStockage;
                        
                        docLoop.dateStockage = docLoop.dateStockage.addSeconds(tz.getOffset(docLoop.dateStockage) / 1000);
                        ws.Request__c = documentsFields+'';
                    }
                    if(docLoop.avenants!=null){
                        if(docLoop.avenants.MAJConditionsDuree==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_MAJConditionsDureeOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.MajConditionsDuree__c = docLoop.avenants.MAJConditionsDuree; 
                        }
                        if(docLoop.avenants.MAJConditionsTechniques==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_MAJConditionsTechniquesOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.MajConditionsTechniques__c = docLoop.avenants.MAJConditionsTechniques;
                        }
                        if(docLoop.avenants.MAJConditionsFacturation==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_MAJConditionsFacturationOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.MAJConditionsFacturation__c = docLoop.avenants.MAJConditionsFacturation;
                        }
                        if(docLoop.avenants.ajoutPrestations==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_ajoutPrestationsOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.Ajoutprestations__c = docLoop.avenants.ajoutPrestations;
                        }
                        if(docLoop.avenants.retraitPrestations==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_retraitPrestationsOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.Retraitprestations__c = docLoop.avenants.retraitPrestations;
                        }
                        if(docLoop.avenants.autresModifications==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS05_autresModificationsOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.Autresmodifications__c = docLoop.avenants.autresModifications;
                        }
                    }
                    if(docLoop.metadonnees==null){
                        resp.responseCode = Label.WS_Response_KO;
                        resp.errorText += Label.WS05_metadonneesDocumentOB + '\n';
                        resp.error = true;
                    }
                    else{
                        if(docLoop.metadonnees.creationDate==null){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS06_creationDateOB + '\n';
                            resp.error = true;
                        }
                        else{
                            doc.WSCreationDate__c = docLoop.metadonnees.creationDate;
                            
                            docLoop.metadonnees.creationDate = docLoop.metadonnees.creationDate.addSeconds(tz.getOffset(docLoop.metadonnees.creationDate) / 1000);
                            ws.Request__c = documentsFields+'';
                        }
                        if(String.isBlank(docLoop.metadonnees.creationId)){
                            resp.responseCode = Label.WS_Response_KO;
                            resp.errorText += Label.WS06_creationId + '\n';
                            resp.error = true;
                        }
                        else{
                            if(mapUserRefId.keySet().contains(docLoop.metadonnees.creationId)){
                                doc.CreateId__c = mapUserRefId.get(docLoop.metadonnees.creationId);
                            }
                        }
                        if(docLoop.metadonnees.updateDate!=null){
                            doc.WSModificationDate__c = docLoop.metadonnees.updateDate;
                            
                            docLoop.metadonnees.updateDate = docLoop.metadonnees.updateDate.addSeconds(tz.getOffset(docLoop.metadonnees.updateDate) / 1000);
                            ws.Request__c = documentsFields+'';
                        }
                        if(!String.isBlank(docLoop.metadonnees.updateId)){
                            if(mapUserRefId.keySet().contains(docLoop.metadonnees.updateId)){
                                doc.UpdateId__c = mapUserRefId.get(docLoop.metadonnees.updateId);
                            }
                        }
                        if(docLoop.metadonnees.validationDate!=null){
                            doc.ValidationDate__c = docLoop.metadonnees.validationDate;
                            
                            docLoop.metadonnees.validationDate = docLoop.metadonnees.validationDate.addSeconds(tz.getOffset(docLoop.metadonnees.validationDate) / 1000);
                            ws.Request__c = documentsFields+'';
                        }
                        if(!String.isBlank(docLoop.metadonnees.validationId)){
                            if(mapUserRefId.keySet().contains(docLoop.metadonnees.validationId)){
                                doc.ValidationId__c = mapUserRefId.get(docLoop.metadonnees.validationId);
                            }
                        }
                    }
                    listDoc.add(doc);
                }
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
            system.debug('*** resp.errorText = '+resp.errorText);
            if(!resp.error){
                try{
                    
                    PAD.PAD_BypassTrigger+=';AP52_DocumentContractuel;AP01_DocumentContractuel;';
                    upsert cont;
                    List<Document_Contractuel__c> docsToInsert = new List<Document_Contractuel__c>();
                    List<Document_Contractuel__c> docsToUpdateNumPiece = new List<Document_Contractuel__c>();
                    List<Document_Contractuel__c> docsToUpdateTitre = new List<Document_Contractuel__c>();
                    
                    Set<String> numPieceIds = new Set<String>();
                    Set<String> docUniqueIds = new Set<String>();
                    
                    for(Document_Contractuel__c doc : listDoc)
                    {
                        numPieceIds.add(doc.NumeroPiece__c);
                        docUniqueIds.add(cont.Id + doc.TitreDocument__c);
                    }
                    
                    List<Document_Contractuel__c> lstExistingDocsNumPiece = [SELECT id, NumeroPiece__c
                                                                             FROM Document_Contractuel__c
                                                                             WHERE NumeroPiece__c in :numPieceIds ];
                    
                    Map<String,Id> mapIdNumPiece = new Map<String,Id>();
                    for(Document_Contractuel__c doc : lstExistingDocsNumPiece)
                    {
                        mapIdNumPiece.put(doc.NumeroPiece__c,doc.id);
                    }

                    List<Document_Contractuel__c> lstExistingDocsTitre = [SELECT id, DocUniqueText__c
                                                                             FROM Document_Contractuel__c
                                                                             WHERE DocUniqueText__c in :docUniqueIds ];
                    
                    Map<String,Id> mapIdTitre = new Map<String,Id>();
                    for(Document_Contractuel__c doc : lstExistingDocsTitre)
                    {
                        mapIdTitre.put(doc.DocUniqueText__c,doc.id);
                    }
                    
                    for(Document_Contractuel__c doc : listDoc){
                        doc.Contrat__c = cont.id;
                        doc.DocUniqueText__c = doc.Contrat__c + doc.TitreDocument__c;
                        
                        if(mapIdNumPiece.containsKey(doc.NumeroPiece__c))
                        {
                            doc.Id = mapIdNumPiece.get(doc.NumeroPiece__c);
                            docsToUpdateNumPiece.add(doc);
                        }
                        else if(mapIdTitre.containsKey(doc.DocUniqueText__c))
                        {
                            doc.Id = mapIdTitre.get(doc.DocUniqueText__c);
                            docsToUpdateTitre.add(doc);
                        }
                        else
                        {
                            docsToInsert.add(doc);
                        }
                    }
                    
					if(docsToUpdateNumPiece.size() > 0)
                    {
                        update docsToUpdateNumPiece;
                    }
                    
                    if(docsToUpdateTitre.size() > 0)
                    {
                        update docsToUpdateTitre;
                    }
                    
                    if(docsToInsert.size() > 0)
                    {
                        insert docsToInsert;
                    }
                    
                }
                catch(Exception e){
                    ws.Statut__c ='KO';
                    ws.ErrorText__c = e.getMessage();
                    if(ws.ErrorText__c != null && ws.ErrorText__c.length()>254){
                        ws.ErrorText__c =  ws.ErrorText__c.substring(0,254);
                    }
                    resp.error = true;
                    resp.responseCode = Label.WS_Response_KO;
                    resp.errorText += Label.WS05_Error + e.getMessage() + '\n';
                    System.debug('insertUpdateContratDocument error ' + e.getMessage());
                    ws.Response__c = resp+ Label.WS05_AfterError + e.getMessage();
                    update ws;
                }
            }
        }
        else
        {
            resp.errorText = Label.WS05_ContInexistant1 + ' ' + documentsFields.DKCodeContrat +' ' + Label.WS05_ContInexistant2;
            ws.Statut__c ='OK';
            resp.responseCode = Label.WS_Response_OK;
            ws.Response__c = resp+'';
            update ws;
        }
        
        return resp;
    }
}