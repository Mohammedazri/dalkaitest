/**
 *@author:Charbel Khoury Hanna
 *@date 09/15/2021
 *@description Appeler le WS modifier document
 */
public class AP101_DocumentContractuel {

    @future (callout = true)
    public static void updateScan (String cdls){
        List<ContentDocumentLink> lstCdl = (List<ContentDocumentLink>)JSON.deserialize(cdls, List<ContentDocumentLink> .class);

        Set<id> cdlIds = new Set<id>();
        for(ContentDocumentLink cdl : lstCdl) {
            cdlIds.add(cdl.LinkedEntityId);
        }

        List<Document_Contractuel__c> allDocs = [SELECT id, Contrat__c, StatutDocument__c, NumeroPiece__c
                                                 FROM Document_Contractuel__c
                                                 WHERE id in :cdlIds];

        List<Document_Contractuel__c> lstDocs = new List<Document_Contractuel__c>();
        for(Document_Contractuel__c doc : allDocs) {
            if(doc.StatutDocument__c.equals('ACT') && doc.NumeroPiece__c != null) {
                lstDocs.add(doc);
            }
        }

        if(lstDocs.size() > 0) {
            Datetime dateDeclenchement = System.now();
            String wsType = '';
            String wsCont = '';
            String wsResponse = '';
            String wsFlux = 'sortant';
            String wsCodeRetour = '';

            String objectDocName = 'Document_Contractuel__c';
            String queryDoc = 'Select contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c,contrat__r.DKCodeSurContrat__c,contrat__r.DureeProlongationTotale__c,OpportuniteRattachee__r.NumeroOpportunite__c,contrat__r.DureeInitialeContrat__c,contrat__r.TypeReconduction__c,contrat__r.DureeReconduction__c,contrat__r.DureePreavis__c,contrat__r.NombreReconductionsAutorisees__c,';
            Map<String, Schema.SObjectField> docFields = Schema.getGlobalDescribe().get(objectDocName).getDescribe().fields.getMap();

            // Grab the fields from the describe method and append them to the queryString one by one.
            for(String s : docFields.keySet()) {
                queryDoc += ' ' + s + ', ';
            }
            // Strip off the last comma if it exists.
            if(queryDoc.subString(queryDoc.Length() - 2, queryDoc.Length()) == ', ') {
                queryDoc = queryDoc.subString(0, queryDoc.Length() - 2);
            }
            queryDoc += ' FROM ' + objectDocName;
            String lstDocsId = lstDocs[0].id;
            queryDoc += ' WHERE id = :lstDocsId';

            List<Document_Contractuel__c> docList = new List<Document_Contractuel__c>();
            Try {
                //Added By Jimmy for ApexSOQLInjection
                String sQueryEscaped = String.escapeSingleQuotes(queryDoc);
                docList = Database.query(sQueryEscaped);
            }
            Catch(Exception e){
                System.debug('Exception ' + e.getMessage());
            }

            try {
                system.debug('modifierDocumentContractuelRequete');
                wsCont = json.serialize(docList[0]);
                wwwDalkiaFrReferentielContrat.modifierDocumentContractuelRequete doc = Document_Contractuel_Mapper.fillModifierDocumentContractuelRequete(docList[0]);
                wwwDalkiaFrReferentielContrat.modifierDocumentContractuelReponse respDoc = DalkiaManager.doCallOutModifierDocumentContractuel(doc);
                if(respDoc.informationsRetour != null) {
                    if(respDoc.informationsRetour.codeRetour == 'OK') {
                        wsCodeRetour = 'OK'; wsResponse = 'OK';
                        docList[0].SynchronisationStatutModification__c = Label.WS_Modification_OK; docList[0].SynchronisationErrorType__c =  '';
                        docList[0].SynchronisationDate__c = System.now(); docList[0].SynchronisationStatutConsultation__c = 'OK';
                        docList[0].WSModificationDate__c = System.now(); docList[0].StatutSynchronisation__c = true; docList[0].DateDeclenchement__c = dateDeclenchement;

                    } else {
                        wsCodeRetour = 'KO';
                        docList[0].SynchronisationStatutModification__c = Label.WS_Modification_KO;
                        wsResponse = 'Modifier document contractuel KO: ' + respDoc.informationsRetour.messageRetour;
                        system.debug('Modifier document contractuel erreur ' + respDoc.informationsRetour.messageRetour);
                        docList[0].SynchronisationErrorType__c =  wsResponse;
                        docList[0].SynchronisationDate__c = System.now();
                        docList[0].SynchronisationStatutConsultation__c = 'KO';
                        docList[0].WSModificationDate__c = System.now();
                        docList[0].DateDeclenchement__c = dateDeclenchement;
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR'; docList[0].SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier document contractuel Exception: ' + e.getMessage();
                system.debug('Modifier document contractuel erreur ' + e.getMessage());
                docList[0].SynchronisationErrorType__c =  wsResponse; docList[0].WSModificationDate__c = System.now(); docList[0].SynchronisationDate__c = System.now();
                docList[0].SynchronisationStatutConsultation__c = 'KO'; docList[0].DateDeclenchement__c = dateDeclenchement;
            } finally {

                Set<Id> contentdlIds = new Set<Id>();
                Map<Id, Id> mapCDL = new Map<Id, Id>();
                for(ContentDocumentLink cdl : lstCDL) {
                    mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                    contentdlIds.add(cdl.ContentDocumentId);
                }

                List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                              FROM ContentVersion
                                              WHERE ContentDocumentId in :contentdlIds];

                Map<Id, ContentVersion> mapCV = new Map<Id, ContentVersion>();
                for(ContentVersion cv : lstCV) {
                    mapCV.put(cv.ContentDocumentId, cv);
                }

                for(Document_contractuel__c doc : docList) {
                    if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null) {
                        wsCont = wsCont + '[Information Scan: scanId=' + mapCV.get(mapCDL.get(doc.Id)).Id + ', ContentSize=' + mapCV.get(mapCDL.get(doc.Id)).ContentSize + ', FileType=' + mapCV.get(mapCDL.get(doc.Id)).FileType + ', relatedDocContractuel=' + doc.Id + ']';
                    }
                }

                WebserviceLog__c ws = new WebserviceLog__c();
                ws.Type__c = 'ModifierDocumentContractuel';
                ws.flux__c = wsFlux;
                ws.Response__c = wsResponse;
                ws.Request__c = wsCont;
                ws.ObjectId__c = docList[0].Id;
                ws.CodeRetour__c = wsCodeRetour;
                insert ws;
                update docList;
            }
        }

    }

    // Delete the link between the file and the document contractuel record and modify the name of the file
    public static void removeScanLink(List<ContentDocumentLink> lstCDLToDelete){
        Set<id> cdlIds = new Set<id>();
        Set<id> docIds = new Set<id>();
        Map<id, id> mapLE = new Map<id, id>();
        for(ContentDocumentLink cdl : lstCDLToDelete) {
            cdlIds.add(cdl.ContentDocumentId);
            docIds.add(cdl.LinkedEntityId);
            mapLE.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
        }

        List<Document_Contractuel__c> lstDocs = [SELECT id, NumeroPiece__c
                                                 FROM Document_Contractuel__c
                                                 WHERE id in :docIds];

        Map<id, Document_Contractuel__c> mapDocs = new Map<id, Document_Contractuel__c>();
        for(Document_Contractuel__c doc : lstDocs) {
            mapDocs.put(doc.id, doc);
        }

        List<ContentDocument> lstCD = [SELECT id, Title
                                       FROM ContentDocument
                                       WHERE id in :cdlIds];

        for(ContentDocument cd : lstCD) {
            if(mapLE.containsKey(cd.id) && mapDocs.get(mapLE.get(cd.id)) != null) {
                cd.title = 'REMPLACEMENT_' + mapLE.get(cd.id) + '_' + mapDocs.get(mapLE.get(cd.id)).NumeroPiece__c + '_' + System.today() + '_' + cd.title;
            }
        }

        update lstCD;
    }
}