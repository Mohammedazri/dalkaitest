/**
 *@author Alain Ghoussoub
 *@date 03/04/2019
 *@description All methods that call the web-service contrat provided by Dalkia.
 */
public class AP48_ContractCallouts {
    public static void handleList(Map<Id, Contrat__c> oldMap, List<Contrat__c> listCont, string action){
        system.debug('AlaintestPrp');
        System.debug('handleList');
        System.debug('listCont ' + listCont);
        List<Contrat__c> listContrat = new List<Contrat__c>();
        List<Contrat__c> listContrat2 = new List<Contrat__c>();
        for(Contrat__c cont : listCont) {
            Contrat__c contOld = oldMap.get(cont.id);
            //C360-802 : impact de modifier le workflow en flow (le recordtype dans ce cas change avant de declencher le trigger)
            if(contOld.Statut__c != 'FER' && cont.Statut__c == 'FER' /*&& contOld.RecordTypeId == cont.RecordTypeId*/) {
                listContrat.add(cont);
            }
            if((contOld.Commentaire__c != cont.Commentaire__c
                || contOld.Langue__c != cont.Langue__c
                || contOld.Devise__c != cont.Devise__c
                || contOld.ownerId != cont.ownerId
                || contOld.UOPiloteContrat__c != cont.UOPiloteContrat__c
                || contOld.NomPartenaire__c != cont.NomPartenaire__c
                || contOld.SocieteVenteLookup__c != cont.SocieteVenteLookup__c
                || contOld.DateProchaineEcheance__c != cont.DateProchaineEcheance__c
                || contOld.DureePreavis__c != cont.DureePreavis__c
                || contOld.DatePriseEffet__c != cont.DatePriseEffet__c
                || contOld.DureeInitialeContrat__c != cont.DureeInitialeContrat__c
                || contOld.DureeProlongationTotale__c != cont.DureeProlongationTotale__c
                || contOld.NombreReconductionsAutorisees__c != cont.NombreReconductionsAutorisees__c
                || contOld.NombreReconductionsPassees__c != cont.NombreReconductionsPassees__c
                || contOld.DureeReconduction__c != cont.DureeReconduction__c)
               && String.isNotBlank(cont.DKCodeSurContrat__c )
               && (cont.Statut__c == 'ENOUV' || cont.Statut__c == 'OUV' || cont.Statut__c == 'ENFER')) {
                listContrat2.add(cont);
            }
        }
        if(action == 'update') {
            system.debug('action update');
            if(listContrat.size() > 0) {
                String jsonString = Json.serialize(listContrat);
                ModifierContrat(jsonString);
            }
            if(listContrat2.size() > 0) {
                String jsonString = Json.serialize(listContrat2);
                ModifierContrat2(jsonString);
            }
        }
    }
    /**
     *@author Alain Ghoussoub
     *@date 03/04/2019
     *@description invokes the web-service ModifierContrat
     *@param String json of a serialized list
     *@return void
     */
    @Future(callout = true)
    public static void ModifierContrat(String jsonList){
        List<Document_Contractuel__c> docListToInsert = new List<Document_Contractuel__c>();
        Datetime dateDeclenchement = System.now();
        List<WebserviceLog__c> wsLogs = new List<WebserviceLog__c>();
        List<Contrat__c> contList = new List<Contrat__c>();
        String wsType = '';
        String wsCont = '';
        String wsResponse = '';
        String wsFlux = '';
        String wsCodeRetour = '';
        List<Contrat__c> contratList = new List<Contrat__c>();
        if(String.isNotBlank(jsonList)) {
            contratList = (List<Contrat__c>)Json.deserialize(jsonList, List<Contrat__c> .class);
        }
        System.debug('ModifierContratResiliation');
        Contrat__c cont =  new Contrat__c();
        if(contratList != null && contratList.size() > 0) {
            cont = contratList[0];
            String objectDocName = 'Document_Contractuel__c';
            String queryDoc = 'Select contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c,contrat__r.DKCodeSurContrat__c,contrat__r.DureeProlongationTotale__c,OpportuniteRattachee__r.NumeroOpportunite__c,contrat__r.DureeInitialeContrat__c,contrat__r.TypeReconduction__c,contrat__r.DureeReconduction__c,contrat__r.DureePreavis__c,contrat__r.NombreReconductionsAutorisees__c,contrat__r.Motif_fermeture_contrat__c,contrat__r.Condition_de_fermeture__c,';
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
            String contratListId = contratList[0].id;
            queryDoc += ' WHERE Contrat__c = :contratListId';
            System.debug(queryDoc);
            List<Document_Contractuel__c> docList = new List<Document_Contractuel__c>();
            Try {
                //Added By Jimmy for ApexSOQLInjection
                String sQueryEscaped = String.escapeSingleQuotes(queryDoc);
                docList = Database.query(sQueryEscaped);
            }
            Catch(Exception e){
                System.debug('Exception ' + e.getMessage());
            }
            system.debug('modifierContrat');
            wsType = 'ModifierContrat';
            wsCont = json.serialize(cont);
            wsFlux = 'sortant';
            try {
                wwwDalkiaFrReferentielContrat.modifierContratRequete cons = Contrat_Mapper.fillModifierContratRequete(cont, true);
                System.debug('cons ' + cons);
                wwwDalkiaFrReferentielContrat.modifierContratReponse resp = DalkiaManager.doCallOutModifierContrat(cons);
                System.debug('resp ' + resp);

                if(resp.informationsRetour != null) {
                    if(resp.informationsRetour.codeRetour == 'OK') {
                        wsCodeRetour = 'OK';
                        Contrat__c contResp = Contrat_Mapper.getModifierContratRequete(resp, contratList[0].id, docList);
                        System.debug('contratcree ' + contResp);
                        wsResponse = 'OK';
                        contResp.SynchronisationErrorType__c = '';
                        contResp.SynchronisationStatutModification__c = Label.WS_Modification_OK;
                        contResp.WSModificationDate__c = System.now();
                        contResp.id = cont.id;
                        contResp.DateDeclenchement__c = dateDeclenchement;
                        contResp.ZZZ_Bypass_VR05_DocCont__c = false;
                        contList.add(contResp);

                    } else if(resp.informationsRetour.codeRetour == 'KO') {
                        wsCodeRetour = 'KO'; wsResponse = resp.informationsRetour.messageRetour;
                        system.debug('contratNoncree');
                        if(resp.informationsRetour.messageRetour != null && resp.informationsRetour.messageRetour.length() > 990) {
                            cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour.substring(0, 990);
                        } else {
                            cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                        }
                        cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; cont.WSModificationDate__c = System.now(); cont.DateDeclenchement__c = dateDeclenchement;
                        cont.ZZZ_Bypass_VR05_DocCont__c = false; contList.add(cont);
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR'; cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier Contrat' + e.getMessage();
                system.debug('Modifier Contrat erreur ' + e.getMessage());
                if(e.getMessage().length() > 990) {
                    cont.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                } else {
                    cont.SynchronisationErrorType__c = e.getMessage();
                }
                cont.WSModificationDate__c = System.now(); cont.DateDeclenchement__c = dateDeclenchement; cont.ZZZ_Bypass_VR05_DocCont__c = false; contList.add(cont);
            } finally {
                WebserviceLog__c ws = new WebserviceLog__c();
                ws.Type__c = wsType;
                ws.flux__c = wsFlux;
                ws.Response__c = wsResponse;
                ws.Request__c = wsCont;
                ws.ObjectId__c = cont.Id;
                ws.CodeRetour__c = wsCodeRetour;
                wsLogs.add(ws);
            }

            List<Document_Contractuel__c> docToSync = new List<Document_Contractuel__c>();

            for(Document_Contractuel__c docLoop : docList) {
                wsCont = json.serialize(docLoop);
                if(String.isBlank(docLoop.numeroPiece__c)) {
                    docToSync.add(docLoop);
                }
            }

            if(docToSync.size() > 0) {
                try {
                    system.debug('ajouterDocumentContractuelRequete');
                    wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete docContList = Document_Contractuel_Mapper.fillAjouterDocumentContractuelRequete(docToSync);
                    wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse respDoc = DalkiaManager.doCallOutAjouterDocumentContractuel(docContList);

                    if(respDoc.informationsRetour != null) {
                        if(respDoc.informationsRetour.codeRetour == 'OK') {
                            wsCodeRetour = 'OK';
                            wsResponse = 'OK';
                            for(Document_Contractuel__c doc : docToSync) {
                                Document_Contractuel__c docToUpdate = Document_Contractuel_Mapper.getAjouterDocumentsContractuelsRequete(respDoc, doc.id);
                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK;
                                docToUpdate.SynchronisationDate__c = System.now();
                                docToUpdate.SynchronisationStatutConsultation__c = 'OK';
                                docToUpdate.SynchronisationErrorType__c = '';
                                docToUpdate.WSCreationDate__c = System.now();
                                docListToInsert.add(docToUpdate);
                            }
                        } else if(respDoc.informationsRetour.codeRetour == 'KO') {

                            for(Document_Contractuel__c docKO : docToSync) {
                                wsCodeRetour = 'KO'; wsResponse = 'Ajouter document contractuel KO ' + respDoc.informationsRetour.messageRetour;
                                system.debug('Ajouter document contractuel erreur ' + respDoc.informationsRetour.messageRetour);
                                docKO.SynchronisationStatutCreation__c = Label.WS_Creation_KO; docKO.SynchronisationDate__c = System.now();
                                docKO.SynchronisationStatutConsultation__c = 'KO'; docKO.SynchronisationErrorType__c =  wsResponse;
                                if(docKO.SynchronisationErrorType__c != null && docKO.SynchronisationErrorType__c.length() > 990) {
                                    docKO.SynchronisationErrorType__c = docKO.SynchronisationErrorType__c.substring(0, 990);
                                }
                                docKO.WSCreationDate__c = System.now(); docListToInsert.add(docKO);
                            }
                        }
                    }
                }
                catch(Exception e) {
                    system.debug('Ajouter document contractuel erreur ' + e.getMessage());
                    wsCodeRetour = 'ERROR'; wsResponse = 'Ajouter document contractuel erreur ' + e.getMessage();
                    for(Document_Contractuel__c doc : docToSync) {
                        doc.SynchronisationStatutCreation__c = Label.WS_Creation_KO; doc.SynchronisationDate__c = System.now();
                        doc.SynchronisationStatutConsultation__c = 'KO'; doc.SynchronisationErrorType__c =  wsResponse;
                        if(doc.SynchronisationErrorType__c != null && doc.SynchronisationErrorType__c.length() > 990) {
                            doc.SynchronisationErrorType__c = doc.SynchronisationErrorType__c.substring(0, 990);
                        }
                        doc.WSCreationDate__c = System.now(); docListToInsert.add(doc);
                    }
                } finally {

                    wsCont = '';
                    String[] docIds = New String[] {};

                    for(Document_contractuel__c doc : docToSync) {
                        wsCont = wsCont + json.serialize(doc);
                        docIds.add(doc.Id);
                    }
                    WebserviceLog__c ws = new WebserviceLog__c();
                    ws.Type__c = 'Ajouter document contractuel';
                    ws.flux__c = wsFlux;
                    ws.Response__c = wsResponse;
                    ws.Request__c = wsCont;
                    ws.ObjectId__c = string.join(docIds, ',');
                    ws.CodeRetour__c = wsCodeRetour;
                    wsLogs.add(ws);
                }
            }
        }

        try {
            PAD.PAD_BypassTrigger += ';AP52_DocumentContractuel;AP01_DocumentContractuel;AP77_ContratFerme;';
            if(docListToInsert != null && docListToInsert.size() > 0) {
                for(Document_Contractuel__c doc : docListToInsert) {
                    doc.DateDeclenchement__c = dateDeclenchement;
                }
                update docListToInsert;
            }

        }
        catch(Exception e) {
            System.debug('Excpetion ' + e.getMessage());
            for(WebserviceLog__c ws : wsLogs) {
                ws.Response__c = e.getMessage();
            }
        } finally {
            insert wsLogs;
        }

        try {
            PAD.PAD_BypassTrigger += ';AP48_ContractCallouts;';
            insert wsLogs;
            update contList;
        }
        catch(Exception e) {
            system.debug('Error ' + e);
        }
    }
    /**
     *@author Alain Ghoussoub
     *@date 02/13/2020
     *@description invokes the web-service ModifierContrat
     *@param String json of a serialized list
     *@return void
     */
    @Future(callout = true)
    public static void ModifierContrat2(String jsonList){
        system.debug('modifier contrat 2');
        Datetime dateDeclenchement = System.now();
        List<WebserviceLog__c> wsLogs = new List<WebserviceLog__c>();
        List<Contrat__c> contList = new List<Contrat__c>();
        String wsType = '';
        String wsCont = '';
        String wsResponse = '';
        String wsFlux = '';
        String wsCodeRetour = '';
        List<Contrat__c> contratList = new List<Contrat__c>();
        if(String.isNotBlank(jsonList)) {
            contratList = (List<Contrat__c>)Json.deserialize(jsonList, List<Contrat__c> .class);
        }
        System.debug('ModifierContratResiliation');
        Contrat__c cont =  new Contrat__c();
        if(contratList != null && contratList.size() > 0) {
            cont = contratList[0];
            String objectDocName = 'Document_Contractuel__c';
            String queryDoc = 'Select contrat__r.OpportuniteCommerciale__r.NumeroOpportunite__c,contrat__r.DKCodeSurContrat__c,contrat__r.DureeInitialeContrat__c,contrat__r.TypeReconduction__c,contrat__r.DureeReconduction__c,contrat__r.DureePreavis__c,contrat__r.NombreReconductionsAutorisees__c,';
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
            String contratListId = contratList[0].id;
            queryDoc += ' WHERE Contrat__c = :contratListId';
            System.debug(queryDoc);
            List<Document_Contractuel__c> docList = new List<Document_Contractuel__c>();
            Try {
                //Added By Jimmy for ApexSOQLInjection
                String sQueryEscaped = String.escapeSingleQuotes(queryDoc);
                docList = Database.query(sQueryEscaped);
            }
            Catch(Exception e){
                System.debug('Exception ' + e.getMessage());
            }
            system.debug('modifierContrat');
            wsType = 'ModifierContrat';
            wsCont = json.serialize(cont);
            wsFlux = 'sortant';
            try {
                system.debug('1234');
                wwwDalkiaFrReferentielContrat.modifierContratRequete cons = Contrat_Mapper.fillModifierContratRequete(cont, false);
                System.debug('cons ' + cons);
                wwwDalkiaFrReferentielContrat.modifierContratReponse resp = DalkiaManager.doCallOutModifierContrat(cons);
                System.debug('resp ' + resp);

                if(resp.informationsRetour != null) {
                    if(resp.informationsRetour.codeRetour == 'OK') {
                        wsCodeRetour = 'OK';
                        Contrat__c contResp = Contrat_Mapper.getModifierContratRequete(resp, contratList[0].id, docList);
                        System.debug('contratcree ' + contResp);
                        wsResponse = 'OK';
                        contResp.SynchronisationErrorType__c = '';
                        contResp.SynchronisationStatutModification__c = Label.WS_Modification_OK;
                        contResp.WSModificationDate__c = System.now();
                        contResp.id = cont.id;
                        contResp.DateDeclenchement__c = dateDeclenchement;
                        contList.add(contResp);

                    } else if(resp.informationsRetour.codeRetour == 'KO') {
                        wsCodeRetour = 'KO'; wsResponse = resp.informationsRetour.messageRetour;
                        system.debug('contratNoncree');
                        if(resp.informationsRetour.messageRetour != null && resp.informationsRetour.messageRetour.length() > 990) {
                            cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour.substring(0, 990);
                        } else {
                            cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                        }
                        cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; cont.WSModificationDate__c = System.now();
                        cont.DateDeclenchement__c = dateDeclenchement; contList.add(cont);
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR'; cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier Contrat' + e.getMessage();
                system.debug('Modifier Contrat erreur ' + e.getMessage());
                if(e.getMessage().length() > 990) {
                    cont.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                } else {
                    cont.SynchronisationErrorType__c = e.getMessage();
                }
                cont.WSModificationDate__c = System.now(); cont.DateDeclenchement__c = dateDeclenchement; contList.add(cont);
            } finally {
                WebserviceLog__c ws = new WebserviceLog__c();
                ws.Type__c = wsType;
                ws.flux__c = wsFlux;
                ws.Response__c = wsResponse;
                ws.Request__c = wsCont;
                ws.ObjectId__c = cont.Id;
                ws.CodeRetour__c = wsCodeRetour;
                wsLogs.add(ws);
            }
        }
        try {
            PAD.PAD_BypassTrigger += ';AP48_ContractCallouts;';
            insert wsLogs;
            update contList;
        }
        catch(Exception e) {
            system.debug('Error ' + e);
        }
    }
}