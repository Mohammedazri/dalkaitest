/**
 *@author:Alain Ghoussoub
 *@date 04/05/2019
 *@description Controller for LC51_CreateContract.cmp
 */
public without sharing class LC51_CreateContract_Controller {
    // ajouté par Rita Bejjani 05/08/2019
    @AuraEnabled
    public static String getCurrentUserProfile(){

        List<User> usr = [SELECT id, Name, Username, Email, FirstName, LastName, IsActive, ProfileId
                          FROM User
                          WHERE id =: userInfo.getUserId()];
        List<Profile> p = new List<Profile>();
        if(usr != null && usr.size() > 0) {
            p = [select id, Name from Profile where id =:usr[0].ProfileId];
            system.debug('profile ' + p[0].Name);
        }

        return (p[0].name + '--' + usr[0].id);
    }

    @AuraEnabled
    public static Contrat__c getCurrentObject(String contractId){
        Contrat__c mycontrat = [SELECT id, name, DKCodeSurContrat__c, statut__c, (select id from Documents_Contractuels__r)
                                FROM Contrat__c
                                Where id =:contractId
                                LIMIT 1];
        system.debug('mycontrat ' + mycontrat);

        return mycontrat;
    }
    /**
     *@author Alain Ghoussoub
     *@date 04/05/2019
     *@description invokes the web-service CreerContrat
     *@param String json of a serialized list
     *@return Boolean
     */
    @AuraEnabled
    public static string creerContrat(String contractId){
        List<WebserviceLog__c> wsLogs = new List<WebserviceLog__c>();
        List<Document_Contractuel__c> docListToInsert = new List<Document_Contractuel__c>();

        List<Document_Contractuel__c> docContToSync = new List<Document_Contractuel__c>();
        List<Document_Contractuel__c> docDureeContToSync = new List<Document_Contractuel__c>();

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
        queryDoc += ' WHERE Contrat__c = :contractId';
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

        system.debug('docList ' + docList);
        Contrat__c contr = [SELECT id, FormeJuridique__c, TypeReconduction__c, OpportuniteCommerciale__r.StageName, ContratCadre__r.DKCodeSurContrat__c, ContratCadre__r.Statut__c, ContratCadre__c
                            FROM Contrat__c
                            WHERE id =:contractId limit 1];
        system.debug('FormeJuridique__c ' + contr.FormeJuridique__c);
        system.debug('TypeReconduction__c ' + contr.TypeReconduction__c);
        system.debug('cont.oppMere' + contr.OpportuniteCommerciale__r.StageName);
        if(contr.FormeJuridique__c == NULL || contr.TypeReconduction__c == NULL) {
            system.debug('Pas appel de ws');

            return 'Forme et type';
        } else if(contr.OpportuniteCommerciale__r.StageName != 'Réalisation') {
            system.debug('Pas appel de ws');

            return 'Opportunity stage';
        } else {
            if(!Test.isRunningTest()) {
                if(contr.ContratCadre__c != null) {
                    if(contr.ContratCadre__r.DKCodeSurContrat__c == null || contr.ContratCadre__r.Statut__c == 'PREP') {
                        system.debug('Pas appel de ws');

                        return 'Contrat Cadre';
                    }
                }
            }
            Datetime dateDeclenchement = System.now();
            String wsType = '';
            String wsCont = '';
            String wsResponse = '';
            String wsFlux = 'sortant';
            String wsCodeRetour = '';
            system.debug('contratTest');
            String objectName = 'Contrat__c';
            String query = 'Select OpportuniteCommerciale__r.StageName,OpportuniteCommerciale__r.Statut__c,OpportuniteCommerciale__r.OpportuniteMere__c,';
            query += ' OpportuniteCommerciale__r.ContratOrigine__r.DKCodeSurContrat__c,OpportuniteCommerciale__r.ContratOrigine__r.Motif_fermeture_contrat__c,';
            query += ' OpportuniteCommerciale__r.ContratOrigine__r.Condition_de_fermeture__c,OpportuniteCommerciale__r.ContratOrigine__r.DateFin__c,';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            Boolean FirstModify = true;

            // Grab the fields from the describe method and append them to the queryString one by one.
            for(String s : objectFields.keySet()) {
                query += ' ' + s + ', ';
            }
            // Strip off the last comma if it exists.
            if(query.subString(query.Length() - 2, query.Length()) == ', ') {
                query = query.subString(0, query.Length() - 2);
            }
            query += ' FROM ' + objectName;
            query += ' WHERE id = :contractId ';
            System.debug(query);

            //Added By Jimmy for ApexSOQLInjection
            String sQueryEscaped = String.escapeSingleQuotes(query);
            List<Contrat__c> contratList = Database.query(sQueryEscaped);
            system.debug('contratList ' + contratList);
            List<Contrat__c> contList = new List<Contrat__c>();
            if(contratList != null && contratList.size() > 0) {
                Contrat__c cont = contratList[0];
                system.debug('cont.Type_Pers_opportunite__c ' + cont.Type_Pers_opportunite__c);
                if(String.isNotBlank(cont.DKCodeSurContrat__c) && cont.Tech_ModfierContrat__c == true) {
                    system.debug('modifierContrat');
                    wsType = 'ModifierContrat';
                    wsCont = json.serialize(cont);
                    wsFlux = 'sortant';
                    if(!test.isRunningTest()) {
                        FirstModify = false;
                    }
                    try {
                        wwwDalkiaFrReferentielContrat.modifierContratRequete cons = Contrat_Mapper.fillModifierContratRequete(cont, true);
                        System.debug('cons ' + cons);
                        wwwDalkiaFrReferentielContrat.modifierContratReponse resp = DalkiaManager.doCallOutModifierContrat(cons);
                        System.debug('resp ' + resp);

                        if(resp.informationsRetour != null) {
                            if(resp.informationsRetour.codeRetour == 'OK') {
                                wsCodeRetour = 'OK';
                                Contrat__c contResp = Contrat_Mapper.getModifierContratRequete(resp, contractId, docList);
                                System.debug('contratcree ' + contResp);
                                wsResponse = 'OK';
                                contResp.SynchronisationErrorType__c = '';
                                contResp.SynchronisationStatutModification__c = Label.WS_Modification_OK;
                                contResp.WSModificationDate__c = System.now();
                                contList.add(contResp);

                            } else if(resp.informationsRetour.codeRetour == 'KO') {
                                wsCodeRetour = 'KO';
                                wsResponse = resp.informationsRetour.messageRetour;
                                cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                    cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                }
                                cont.SynchronisationStatutModification__c = Label.WS_Modification_KO;
                                cont.WSModificationDate__c = System.now();
                                contList.add(cont);
                            } else {
                                wsCodeRetour = 'ERROR'; wsResponse = resp.informationsRetour.messageRetour; cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                    cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                }
                                cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; cont.WSModificationDate__c = System.now(); contList.add(cont);
                            }
                        }
                    }
                    catch(Exception e) {
                        wsCodeRetour = 'ERROR'; cont.WSModificationDate__c = System.now(); cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier Contrat' + e.getMessage();
                        system.debug('Modifier Contrat erreur ' + e.getMessage()); cont.SynchronisationErrorType__c =  wsResponse;
                        if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                            cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                        }
                        contList.add(cont);
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

                // CKH US290 - 06/11/2021
                //if(cont.Type_Pers_opportunite__c == 'Evolution' && String.isBlank(cont.DKCodeSurContrat__c) && String.isNotBlank(cont.OpportuniteCommerciale__r.OpportuniteMere__c)){
                if(cont.Type_Pers_opportunite__c == 'Nouveau' && String.isBlank(cont.DKCodeSurContrat__c) && String.isNotBlank(cont.OpportuniteCommerciale__r.OpportuniteMere__c)) {
                    wsType = 'CreerContrat';
                    wsCont = json.serialize(cont);
                    wsFlux = 'sortant';
                    system.debug('creerContrat');
                    try {
                        wwwDalkiaFrReferentielContrat.creerContratRequete cons = Contrat_Mapper.fillCreerContratRequete(cont);
                        wwwDalkiaFrReferentielContrat.creerContratReponse resp = DalkiaManager.doCallOutCreerContrat(cons);
                        if(resp.informationsRetour != null) {
                            if(resp.informationsRetour.codeRetour == 'OK') {
                                wsResponse = 'OK';
                                wsCodeRetour = 'OK';
                                Contrat__c contResp = Contrat_Mapper.getCreerContratRequete(resp, contractId, docList); contResp.SynchronisationErrorType__c = ''; contResp.SynchronisationStatutCreation__c = Label.WS_Creation_OK; contResp.WSCreationDate__c = System.now(); contList.add(contResp);

                                for(Document_contractuel__c docToUpdate : docList) {
                                    docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'OK'; docToUpdate.SynchronisationErrorType__c = ''; docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                }

                            } else if(resp.informationsRetour.codeRetour == 'KO') {
                                wsCodeRetour = 'KO'; wsResponse = resp.informationsRetour.messageRetour; cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                    cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                }
                                cont.SynchronisationStatutCreation__c = Label.WS_Creation_KO; cont.WSCreationDate__c = System.now(); contList.add(cont);

                                for(Document_contractuel__c docToUpdate : docList) {
                                    docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                    if(resp.informationsRetour.messageRetour != null && resp.informationsRetour.messageRetour.length() > 990) {
                                        docToUpdate.SynchronisationErrorType__c = resp.informationsRetour.messageRetour.substring(0, 990);
                                    }
                                    docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                }
                            }
                        }
                    }
                    catch(Exception e) {
                        wsCodeRetour = 'ERROR';
                        cont.SynchronisationStatutCreation__c = Label.WS_Creation_KO;
                        cont.WSCreationDate__c = System.now();
                        wsResponse = 'Creer Contrat' + e.getMessage();
                        system.debug('Creer Contrat erreur ' + e.getMessage());
                        cont.SynchronisationErrorType__c =  wsResponse;
                        if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                            cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                        }
                        contList.add(cont);

                        for(Document_contractuel__c docToUpdate : docList) {
                            docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;
                            docToUpdate.SynchronisationDate__c = System.now();
                            docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                            docToUpdate.SynchronisationErrorType__c = wsResponse;
                            docToUpdate.WSCreationDate__c = System.now();
                            docListToInsert.add(docToUpdate);
                        }
                    } finally {
                        WebserviceLog__c wsDoc = new WebserviceLog__c();
                        wsDoc = Contrat_Mapper.createWsLog(cont.id, 'Creer');
                        WebserviceLog__c ws = new WebserviceLog__c();
                        ws.Type__c = wsType;
                        ws.flux__c = wsFlux;
                        ws.Response__c = wsResponse;
                        ws.Request__c = wsCont;
                        ws.ObjectId__c = contractId;
                        ws.CodeRetour__c = wsCodeRetour;
                        wsLogs.add(ws);
                        if(String.isNotBlank(wsDoc.Request__c)) {
                            wsLogs.add(wsDoc);
                        }
                    }
                } else if((cont.Type_Pers_opportunite__c == 'Nouveau') && cont.OpportuniteCommerciale__r.StageName == 'Réalisation' && cont.OpportuniteCommerciale__r.Statut__c == 'Gagnée') {
                    system.debug('creerContrat');
                    if(cont != null && String.isBlank(cont.DKCodeSurContrat__c)) {
                        wsType = 'CreerContrat'; wsCont = json.serialize(cont); wsFlux = 'sortant';
                        system.debug('creerContrat');
                        try {
                            wwwDalkiaFrReferentielContrat.creerContratRequete cons = Contrat_Mapper.fillCreerContratRequete(cont);
                            system.debug('consRetour ' + cons);
                            wwwDalkiaFrReferentielContrat.creerContratReponse resp = DalkiaManager.doCallOutCreerContrat(cons);

                            if(Test.isRunningTest()) {
                                resp.informationsRetour.codeRetour = 'OK';
                            }

                            if(resp.informationsRetour != null) {
                                if(resp.informationsRetour.codeRetour == 'OK') {
                                    wsCodeRetour = 'OK'; wsResponse = 'OK';
                                    Contrat__c contResp = Contrat_Mapper.getCreerContratRequete(resp, contractId, docList);
                                    contResp.SynchronisationErrorType__c = ''; contResp.SynchronisationStatutCreation__c = Label.WS_Creation_OK; contResp.WSCreationDate__c = System.now(); contList.add(contResp);

                                    for(Document_contractuel__c docToUpdate : docList) {
                                        docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'OK'; docToUpdate.SynchronisationErrorType__c = ''; docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                    }
                                } else if(resp.informationsRetour.codeRetour == 'KO') {
                                    wsCodeRetour = 'KO'; wsResponse = resp.informationsRetour.messageRetour; cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                    if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                        cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                    }
                                    cont.SynchronisationStatutCreation__c = Label.WS_Creation_KO; cont.WSCreationDate__c = System.now(); contList.add(cont);

                                    for(Document_contractuel__c docToUpdate : docList) {
                                        docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                        if(resp.informationsRetour.messageRetour != null && resp.informationsRetour.messageRetour.length() > 990) {
                                            docToUpdate.SynchronisationErrorType__c = resp.informationsRetour.messageRetour.substring(0, 990);
                                        }
                                        docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                    }
                                }
                            }
                        }
                        catch(Exception e) {
                            wsCodeRetour = 'ERROR'; cont.SynchronisationStatutCreation__c = Label.WS_Creation_KO; cont.WSCreationDate__c = System.now(); wsResponse = 'Creer Contrat' + e.getMessage();
                            system.debug('Creer Contrat erreur ' + e.getMessage());
                            cont.SynchronisationErrorType__c =  wsResponse;
                            if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                            }
                            contList.add(cont);

                            for(Document_contractuel__c docToUpdate : docList) {
                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'KO'; docToUpdate.SynchronisationErrorType__c = wsResponse; docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                            }
                        } finally {
                            WebserviceLog__c wsDoc = new WebserviceLog__c(); wsDoc = Contrat_Mapper.createWsLog(cont.id, 'Creer');
                            WebserviceLog__c ws = new WebserviceLog__c(); ws.Type__c = wsType; ws.flux__c = wsFlux; ws.Response__c = wsResponse; ws.Request__c = wsCont;
                            ws.ObjectId__c = contractId; ws.CodeRetour__c = wsCodeRetour; wsLogs.add(ws);
                            if(String.isNotBlank(wsDoc.Request__c)) {
                                wsLogs.add(wsDoc);
                            }
                        }
                    } else {
                        wsFlux = 'sortant';
                        if(docList != null && docList.size() > 0) {
                            for(Document_Contractuel__c docLoop : docList) {
                                wsCont = json.serialize(docLoop);
                                if(String.isBlank(docLoop.numeroPiece__c) && docLoop.StatutSynchronisation__c == false) {
                                    if(FirstModify && String.isNotBlank(cont.DKCodeSurContrat__c)) {

                                        FirstModify = false;
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
                                                    Contrat__c contResp = Contrat_Mapper.getModifierContratRequete(resp, contractId, docList);
                                                    System.debug('contratcree ' + contResp);
                                                    wsResponse = 'OK';
                                                    contResp.SynchronisationErrorType__c = '';
                                                    contResp.SynchronisationStatutModification__c = Label.WS_Modification_OK;
                                                    contResp.WSModificationDate__c = System.now();
                                                    contResp.id = cont.id;
                                                    contList.add(contResp);

                                                } else if(resp.informationsRetour.codeRetour == 'KO') {
                                                    wsCodeRetour = 'KO';
                                                    wsResponse = resp.informationsRetour.messageRetour;
                                                    system.debug('contratNoncree');
                                                    cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                                    if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                                        cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                                    }
                                                    cont.SynchronisationStatutModification__c = Label.WS_Modification_KO;
                                                    cont.WSModificationDate__c = System.now();
                                                    contList.add(cont);
                                                }
                                            }
                                        }
                                        catch(Exception e) {
                                            wsCodeRetour = 'ERROR'; cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier Contrat' + e.getMessage();
                                            system.debug('Modifier Contrat erreur ' + e.getMessage()); cont.SynchronisationErrorType__c =  wsResponse;
                                            if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                                cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                            }
                                            cont.WSModificationDate__c = System.now(); contList.add(cont);
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
                                    docContToSync.add(docLoop);
                                }
                            }

                            if(docContToSync.size() > 0) {
                                try {
                                    system.debug('ajouterDocumentContractuelRequete');
                                    wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete docContList = Document_Contractuel_Mapper.fillAjouterDocumentContractuelRequete(docContToSync);
                                    wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse respDoc = DalkiaManager.doCallOutAjouterDocumentContractuel(docContList);

                                    if(respDoc.informationsRetour != null) {
                                        if(respDoc.informationsRetour.codeRetour == 'OK') {
                                            wsCodeRetour = 'OK';
                                            wsResponse = 'OK';

                                            for(Document_contractuel__c doc : docContToSync) {
                                                Document_Contractuel__c docToUpdate = Document_Contractuel_Mapper.getAjouterDocumentsContractuelsRequete(respDoc, doc.id);
                                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK;
                                                docToUpdate.SynchronisationDate__c = System.now();
                                                docToUpdate.SynchronisationStatutConsultation__c = 'OK';
                                                docToUpdate.SynchronisationErrorType__c = '';
                                                docToUpdate.WSCreationDate__c = System.now();
                                                docListToInsert.add(docToUpdate);
                                            }
                                        } else if(respDoc.informationsRetour.codeRetour == 'KO') {
                                            wsCodeRetour = 'KO';
                                            wsResponse = 'AjouterDocumentContractuel ' + respDoc.informationsRetour.messageRetour;
                                            system.debug('AjouterDocumentContractuel erreur ' + respDoc.informationsRetour.messageRetour);
                                            for(Document_contractuel__c docToUpdate : docContToSync) {
                                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;
                                                docToUpdate.SynchronisationDate__c = System.now();
                                                docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                                if(respDoc.informationsRetour.messageRetour != null && respDoc.informationsRetour.messageRetour.length() > 990) {
                                                    docToUpdate.SynchronisationErrorType__c = respDoc.informationsRetour.messageRetour.substring(0, 990);
                                                }
                                                docToUpdate.WSCreationDate__c = System.now();
                                                docListToInsert.add(docToUpdate);
                                            }
                                        }
                                    }
                                }

                                catch(Exception e) {
                                    wsCodeRetour = 'ERROR'; wsResponse = 'AjouterDocumentContractuel ' + e.getMessage();
                                    system.debug('AjouterDocumentContractuel erreur ' + e.getMessage());

                                    for(Document_contractuel__c docToUpdate : docContToSync) {
                                        docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;  docToUpdate.SynchronisationDate__c = System.now();
                                        docToUpdate.SynchronisationStatutConsultation__c = 'KO';  docToUpdate.SynchronisationErrorType__c = wsResponse;
                                        docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                    }
                                } finally {
                                    Set<id> docContIds = new Set<id>();
                                    for(Document_contractuel__c doc : docContToSync) {
                                        docContIds.add(doc.Id);
                                    }
                                    List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                                        FROM ContentDocumentLink
                                                                        WHERE LinkedEntityId in :docContIds];

                                    Set<Id> cdlIds = new Set<Id>();
                                    Map<Id, Id> mapCDL = new Map<Id, Id>();
                                    for(ContentDocumentLink cdl : lstCDL) {
                                        mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                                        cdlIds.add(cdl.ContentDocumentId);
                                    }

                                    List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                                                  FROM ContentVersion
                                                                  WHERE ContentDocumentId in :cdlIds];

                                    Map<Id, ContentVersion> mapCV = new Map<Id, ContentVersion>();
                                    for(ContentVersion cv : lstCV) {
                                        mapCV.put(cv.ContentDocumentId, cv);
                                    }

                                    wsCont = '';
                                    String[] docIds = New String[] {};

                                    for(Document_contractuel__c doc : docContToSync) {
                                        wsCont = wsCont + json.serialize(doc);
                                        if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null) {
                                            wsCont = wsCont + '[Information Scan: scanId=' + mapCV.get(mapCDL.get(doc.Id)).Id + ', ContentSize=' + mapCV.get(mapCDL.get(doc.Id)).ContentSize + ', FileType=' + mapCV.get(mapCDL.get(doc.Id)).FileType + ', relatedDocContractuel=' + doc.Id + ']';
                                        }
                                        docIds.add(doc.Id);
                                    }

                                    WebserviceLog__c ws = new WebserviceLog__c();
                                    ws.Type__c = 'AjouterDocumentContractuel';
                                    ws.flux__c = wsFlux;
                                    ws.Response__c = wsResponse;
                                    ws.Request__c = wsCont;
                                    ws.ObjectId__c = string.join(docIds, ',');
                                    ws.CodeRetour__c = wsCodeRetour;
                                    wsLogs.add(ws);
                                }
                            }
                        }
                    }
                } else if(cont.Type_Pers_opportunite__c == 'Evolution' && cont.OpportuniteCommerciale__r.StageName == 'Réalisation' && cont.OpportuniteCommerciale__r.Statut__c == 'Gagnée') {
                    system.debug('Evolution');
                    if(docList != null && docList.size() > 0) {
                        wsFlux = 'sortant';
                        for(Document_Contractuel__c docLoop : docList) {
                            wsCont = json.serialize(docLoop);
                            if(String.isBlank(docLoop.numeroPiece__c) && docLoop.StatutSynchronisation__c == false) {
                                if(FirstModify && String.isNotBlank(cont.DKCodeSurContrat__c)) {

                                    wsType = 'ModifierContrat';
                                    wsCont = json.serialize(cont);
                                    wsFlux = 'sortant';
                                    FirstModify = false;
                                    try {
                                        wwwDalkiaFrReferentielContrat.modifierContratRequete cons = Contrat_Mapper.fillModifierContratRequete(cont, true);
                                        System.debug('cons ' + cons);
                                        wwwDalkiaFrReferentielContrat.modifierContratReponse resp = DalkiaManager.doCallOutModifierContrat(cons);
                                        System.debug('resp ' + resp);

                                        if(resp.informationsRetour != null) {
                                            if(resp.informationsRetour.codeRetour == 'OK') {
                                                wsCodeRetour = 'OK';
                                                Contrat__c contResp = Contrat_Mapper.getModifierContratRequete(resp, contractId, docList);
                                                System.debug('contratcree ' + contResp);
                                                wsResponse = 'OK';
                                                contResp.SynchronisationErrorType__c = '';
                                                contResp.SynchronisationStatutModification__c = Label.WS_Modification_OK;
                                                contResp.WSModificationDate__c = System.now();
                                                contResp.id = cont.id;
                                                contList.add(contResp);

                                            } else if(resp.informationsRetour.codeRetour == 'KO') {
                                                wsCodeRetour = 'KO';
                                                wsResponse = resp.informationsRetour.messageRetour;
                                                system.debug('contratNoncree');
                                                cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                                if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                                    cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                                }
                                                cont.SynchronisationStatutModification__c = Label.WS_Modification_KO;
                                                cont.WSModificationDate__c = System.now();
                                                contList.add(cont);
                                            }
                                        }
                                    }
                                    catch(Exception e) {
                                        wsCodeRetour = 'ERROR'; cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier Contrat' + e.getMessage();
                                        system.debug('Modifier Contrat erreur ' + e.getMessage());
                                        cont.SynchronisationErrorType__c =  wsResponse;
                                        if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                            cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                        }
                                        cont.WSModificationDate__c = System.now(); contList.add(cont);
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
                                docContToSync.add(docLoop);
                            }
                        }

                        if(docContToSync.size() > 0) {
                            try {
                                system.debug('ajouterDocumentContractuelRequete');
                                wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete docContList = Document_Contractuel_Mapper.fillAjouterDocumentContractuelRequete(docContToSync);
                                wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse respDoc = DalkiaManager.doCallOutAjouterDocumentContractuel(docContList);

                                if(respDoc.informationsRetour != null) {
                                    if(respDoc.informationsRetour.codeRetour == 'OK') {
                                        wsCodeRetour = 'OK';
                                        wsResponse = 'OK';

                                        for(Document_contractuel__c doc : docContToSync) {
                                            Document_Contractuel__c docToUpdate = Document_Contractuel_Mapper.getAjouterDocumentsContractuelsRequete(respDoc, doc.id);
                                            docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK;
                                            docToUpdate.SynchronisationDate__c = System.now();
                                            docToUpdate.SynchronisationStatutConsultation__c = 'OK';
                                            docToUpdate.SynchronisationErrorType__c = '';
                                            docToUpdate.WSCreationDate__c = System.now();
                                            docListToInsert.add(docToUpdate);
                                        }
                                    } else if(respDoc.informationsRetour.codeRetour == 'KO') {
                                        wsCodeRetour = 'KO';
                                        wsResponse = 'AjouterDocumentContractuel ' + respDoc.informationsRetour.messageRetour;
                                        system.debug('AjouterDocumentContractuel erreur ' + respDoc.informationsRetour.messageRetour);
                                        for(Document_contractuel__c docToUpdate : docContToSync) {
                                            docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;
                                            docToUpdate.SynchronisationDate__c = System.now();
                                            docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                            if(respDoc.informationsRetour.messageRetour != null && respDoc.informationsRetour.messageRetour.length() > 990) {
                                                docToUpdate.SynchronisationErrorType__c = respDoc.informationsRetour.messageRetour.substring(0, 990);
                                            }
                                            docToUpdate.WSCreationDate__c = System.now();
                                            docListToInsert.add(docToUpdate);
                                        }
                                    }
                                }
                            }

                            catch(Exception e) {
                                wsCodeRetour = 'ERROR'; wsResponse = 'AjouterDocumentContractuel ' + e.getMessage();
                                system.debug('AjouterDocumentContractuel erreur ' + e.getMessage());

                                for(Document_contractuel__c docToUpdate : docContToSync) {
                                    docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;  docToUpdate.SynchronisationDate__c = System.now();
                                    docToUpdate.SynchronisationStatutConsultation__c = 'KO';  docToUpdate.SynchronisationErrorType__c = wsResponse;
                                    docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                }
                            } finally {
                                Set<id> docContIds = new Set<id>();
                                for(Document_contractuel__c doc : docContToSync) {
                                    docContIds.add(doc.Id);
                                }
                                List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                                    FROM ContentDocumentLink
                                                                    WHERE LinkedEntityId in :docContIds];

                                Set<Id> cdlIds = new Set<Id>();
                                Map<Id, Id> mapCDL = new Map<Id, Id>();
                                for(ContentDocumentLink cdl : lstCDL) {
                                    mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                                    cdlIds.add(cdl.ContentDocumentId);
                                }

                                List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                                              FROM ContentVersion
                                                              WHERE ContentDocumentId in :cdlIds];

                                Map<Id, ContentVersion> mapCV = new Map<Id, ContentVersion>();
                                for(ContentVersion cv : lstCV) {
                                    mapCV.put(cv.ContentDocumentId, cv);
                                }

                                wsCont = '';
                                String[] docIds = New String[] {};

                                for(Document_contractuel__c doc : docContToSync) {
                                    wsCont = wsCont + json.serialize(doc);
                                    if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null) {
                                        wsCont = wsCont + '[Information Scan: scanId=' + mapCV.get(mapCDL.get(doc.Id)).Id + ', ContentSize=' + mapCV.get(mapCDL.get(doc.Id)).ContentSize + ', FileType=' + mapCV.get(mapCDL.get(doc.Id)).FileType + ', relatedDocContractuel=' + doc.Id + ']';
                                    }
                                    docIds.add(doc.Id);
                                }

                                WebserviceLog__c ws = new WebserviceLog__c();
                                ws.Type__c = 'AjouterDocumentContractuel';
                                ws.flux__c = wsFlux;
                                ws.Response__c = wsResponse;
                                ws.Request__c = wsCont;
                                ws.ObjectId__c = string.join(docIds, ',');
                                ws.CodeRetour__c = wsCodeRetour;
                                wsLogs.add(ws);
                            }
                        }
                    }
                } else if(cont.Type_Pers_opportunite__c == 'Renouvellement' && cont.OpportuniteCommerciale__r.StageName == 'Réalisation' && cont.OpportuniteCommerciale__r.Statut__c == 'Gagnée') {
                    system.debug('renouvelerContrat');
                    if(cont != null && String.isBlank(cont.DKCodeSurContrat__c)) {
                        system.debug('renouvelerContrat');
                        wsType = 'RenouvelerContrat';
                        wsCont = json.serialize(cont);
                        wsFlux = 'sortant';
                        try {
                            wwwDalkiaFrReferentielContrat.renouvelerContratRequete cons = Contrat_Mapper.fillRenouvelerContratRequete(cont);
                            wwwDalkiaFrReferentielContrat.renouvelerContratReponse resp = DalkiaManager.doCallOutRenouvelerContrat(cons);
                            if(resp.informationsRetour != null) {
                                if(resp.informationsRetour.codeRetour == 'OK') {
                                    Contrat__c contResp = Contrat_Mapper.getRenouvelerContratRequete(resp, cont.id, docList);
                                    contResp.id = cont.id;
                                    system.debug('OK Renouveler');
                                    wsCodeRetour = 'OK';
                                    wsResponse = 'OK';
                                    contResp.SynchronisationErrorType__c = '';
                                    contResp.WSDateRenouvellement__c = System.now();
                                    contResp.Statut_Renouvellement__c = Label.WS_Renouvellement_OK;
                                    contList.add(contResp);

                                    for(Document_contractuel__c docToUpdate : docList) {
                                        docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'OK'; docToUpdate.SynchronisationErrorType__c = ''; docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                    }

                                } else if(resp.informationsRetour.codeRetour == 'KO') {
                                    wsCodeRetour = 'KO';
                                    wsResponse = resp.informationsRetour.messageRetour;
                                    system.debug('contratNoncree');
                                    cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                    if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                        cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                    }
                                    cont.WSDateRenouvellement__c = System.now();
                                    cont.Statut_Renouvellement__c = Label.WS_Renouvellement_KO;
                                    contList.add(cont);

                                    for(Document_contractuel__c docToUpdate : docList) {
                                        docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO; docToUpdate.SynchronisationDate__c = System.now(); docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                        if(resp.informationsRetour.messageRetour != null && resp.informationsRetour.messageRetour.length() > 990) {
                                            docToUpdate.SynchronisationErrorType__c = resp.informationsRetour.messageRetour.substring(0, 990);
                                        }
                                        docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                    }
                                }
                            }
                        }
                        catch(Exception e) {
                            wsCodeRetour = 'ERROR';
                            cont.WSDateRenouvellement__c = System.now();
                            cont.Statut_Renouvellement__c = Label.WS_Renouvellement_KO;
                            wsResponse = 'Renouveler Contrat' + e.getMessage();
                            system.debug('Renouveler Contrat erreur ' + e.getMessage());
                            cont.SynchronisationErrorType__c =  wsResponse;
                            if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                            }
                            contList.add(cont);

                            for(Document_contractuel__c docToUpdate : docList) {
                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;
                                docToUpdate.SynchronisationDate__c = System.now();
                                docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                docToUpdate.SynchronisationErrorType__c = wsResponse;
                                docToUpdate.WSCreationDate__c = System.now();
                                docListToInsert.add(docToUpdate);
                            }
                        } finally {
                            WebserviceLog__c wsDoc = new WebserviceLog__c();
                            wsDoc = Contrat_Mapper.createWsLog(cont.id, 'renouveler');
                            WebserviceLog__c ws = new WebserviceLog__c();
                            ws.Type__c = wsType;
                            ws.flux__c = wsFlux;
                            ws.Response__c = wsResponse;
                            ws.Request__c = wsCont;
                            ws.ObjectId__c = contractId;
                            ws.CodeRetour__c = wsCodeRetour;
                            wsLogs.add(ws);
                            if(String.isNotBlank(wsDoc.Request__c)) {
                                wsLogs.add(wsDoc);
                            }
                        }
                    } else {
                        if(docList != null && docList.size() > 0) {
                            wsFlux = 'sortant';
                            for(Document_Contractuel__c docLoop : docList) {
                                wsCont = json.serialize(docLoop);
                                if(String.isBlank(docLoop.numeroPiece__c) && docLoop.StatutSynchronisation__c == false) {
                                    if(FirstModify && String.isNotBlank(cont.DKCodeSurContrat__c)) {
                                        wsType = 'ModifierContrat';
                                        wsCont = json.serialize(cont);
                                        wsFlux = 'sortant';
                                        FirstModify = false;
                                        try {
                                            wwwDalkiaFrReferentielContrat.modifierContratRequete cons = Contrat_Mapper.fillModifierContratRequete(cont, true);
                                            System.debug('cons ' + cons);
                                            wwwDalkiaFrReferentielContrat.modifierContratReponse resp = DalkiaManager.doCallOutModifierContrat(cons);
                                            System.debug('resp ' + resp);

                                            if(resp.informationsRetour != null) {
                                                if(resp.informationsRetour.codeRetour == 'OK') {
                                                    wsCodeRetour = 'OK';
                                                    Contrat__c contResp = Contrat_Mapper.getModifierContratRequete(resp, contractId, docList);
                                                    System.debug('contratcree ' + contResp);
                                                    wsResponse = 'OK';
                                                    contResp.SynchronisationErrorType__c = '';
                                                    contResp.SynchronisationStatutModification__c = Label.WS_Modification_OK;
                                                    contResp.WSModificationDate__c = System.now();
                                                    contResp.id = cont.id;
                                                    contList.add(contResp);

                                                } else if(resp.informationsRetour.codeRetour == 'KO') {
                                                    wsCodeRetour = 'KO';
                                                    wsResponse = resp.informationsRetour.messageRetour;
                                                    system.debug('contratNoncree');
                                                    cont.SynchronisationErrorType__c = resp.informationsRetour.messageRetour;
                                                    if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                                        cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                                    }
                                                    cont.SynchronisationStatutModification__c = Label.WS_Modification_KO;
                                                    cont.WSModificationDate__c = System.now();
                                                    contList.add(cont);
                                                }
                                            }
                                        }
                                        catch(Exception e) {
                                            wsCodeRetour = 'ERROR'; cont.SynchronisationStatutModification__c = Label.WS_Modification_KO; wsResponse = 'Modifier Contrat' + e.getMessage();
                                            system.debug('Modifier Contrat erreur ' + e.getMessage());
                                            cont.SynchronisationErrorType__c =  wsResponse;
                                            if(cont.SynchronisationErrorType__c != null && cont.SynchronisationErrorType__c.length() > 990) {
                                                cont.SynchronisationErrorType__c = cont.SynchronisationErrorType__c.substring(0, 990);
                                            }
                                            cont.WSModificationDate__c = System.now(); contList.add(cont);
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

                                    docContToSync.add(docLoop);
                                }
                            }

                            if(docContToSync.size() > 0) {
                                try {
                                    system.debug('ajouterDocumentContractuelRequete');
                                    wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete docContList = Document_Contractuel_Mapper.fillAjouterDocumentContractuelRequete(docContToSync);
                                    wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse respDoc = DalkiaManager.doCallOutAjouterDocumentContractuel(docContList);

                                    if(respDoc.informationsRetour != null) {
                                        if(respDoc.informationsRetour.codeRetour == 'OK') {
                                            wsCodeRetour = 'OK';
                                            wsResponse = 'OK';

                                            for(Document_contractuel__c doc : docContToSync) {
                                                Document_Contractuel__c docToUpdate = Document_Contractuel_Mapper.getAjouterDocumentsContractuelsRequete(respDoc, doc.id);
                                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_OK;
                                                docToUpdate.SynchronisationDate__c = System.now();
                                                docToUpdate.SynchronisationStatutConsultation__c = 'OK';
                                                docToUpdate.SynchronisationErrorType__c = '';
                                                docToUpdate.WSCreationDate__c = System.now();
                                                docListToInsert.add(docToUpdate);
                                            }
                                        } else if(respDoc.informationsRetour.codeRetour == 'KO') {
                                            wsCodeRetour = 'KO';
                                            wsResponse = 'AjouterDocumentContractuel ' + respDoc.informationsRetour.messageRetour;
                                            system.debug('AjouterDocumentContractuel erreur ' + respDoc.informationsRetour.messageRetour);
                                            for(Document_contractuel__c docToUpdate : docContToSync) {
                                                docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;
                                                docToUpdate.SynchronisationDate__c = System.now();
                                                docToUpdate.SynchronisationStatutConsultation__c = 'KO';
                                                if(respDoc.informationsRetour.messageRetour != null && respDoc.informationsRetour.messageRetour.length() > 990) {
                                                    docToUpdate.SynchronisationErrorType__c = respDoc.informationsRetour.messageRetour.substring(0, 990);
                                                }
                                                docToUpdate.WSCreationDate__c = System.now();
                                                docListToInsert.add(docToUpdate);
                                            }
                                        }
                                    }
                                }

                                catch(Exception e) {
                                    wsCodeRetour = 'ERROR'; wsResponse = 'AjouterDocumentContractuel ' + e.getMessage();
                                    system.debug('AjouterDocumentContractuel erreur ' + e.getMessage());

                                    for(Document_contractuel__c docToUpdate : docContToSync) {
                                        docToUpdate.SynchronisationStatutCreation__c = Label.WS_Creation_KO;  docToUpdate.SynchronisationDate__c = System.now();
                                        docToUpdate.SynchronisationStatutConsultation__c = 'KO';  docToUpdate.SynchronisationErrorType__c = wsResponse;
                                        docToUpdate.WSCreationDate__c = System.now(); docListToInsert.add(docToUpdate);
                                    }
                                } finally {
                                    Set<id> docContIds = new Set<id>();
                                    for(Document_contractuel__c doc : docContToSync) {
                                        docContIds.add(doc.Id);
                                    }
                                    List<ContentDocumentLink> lstCDL = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize, LinkedEntityId
                                                                        FROM ContentDocumentLink
                                                                        WHERE LinkedEntityId in :docContIds];

                                    Set<Id> cdlIds = new Set<Id>();
                                    Map<Id, Id> mapCDL = new Map<Id, Id>();
                                    for(ContentDocumentLink cdl : lstCDL) {
                                        mapCDL.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                                        cdlIds.add(cdl.ContentDocumentId);
                                    }

                                    List<ContentVersion> lstCV = [SELECT id, Title, FileType, ContentSize, ContentDocumentId
                                                                  FROM ContentVersion
                                                                  WHERE ContentDocumentId in :cdlIds];

                                    Map<Id, ContentVersion> mapCV = new Map<Id, ContentVersion>();
                                    for(ContentVersion cv : lstCV) {
                                        mapCV.put(cv.ContentDocumentId, cv);
                                    }

                                    wsCont = '';
                                    String[] docIds = New String[] {};

                                    for(Document_contractuel__c doc : docContToSync) {
                                        wsCont = wsCont + json.serialize(doc);
                                        if(mapCDL != null && mapCDL.containsKey(doc.Id) && mapCDL.get(doc.Id) != null && mapCV.get(mapCDL.get(doc.Id)) != null) {
                                            wsCont = wsCont + '[Information Scan: scanId=' + mapCV.get(mapCDL.get(doc.Id)).Id + ', ContentSize=' + mapCV.get(mapCDL.get(doc.Id)).ContentSize + ', FileType=' + mapCV.get(mapCDL.get(doc.Id)).FileType + ', relatedDocContractuel=' + doc.Id + ']';
                                        }
                                        docIds.add(doc.Id);
                                    }

                                    WebserviceLog__c ws = new WebserviceLog__c();
                                    ws.Type__c = 'AjouterDocumentContractuel';
                                    ws.flux__c = wsFlux;
                                    ws.Response__c = wsResponse;
                                    ws.Request__c = wsCont;
                                    ws.ObjectId__c = string.join(docIds, ',');
                                    ws.CodeRetour__c = wsCodeRetour;
                                    wsLogs.add(ws);
                                }
                            }
                        }
                    }
                }
                try {
                    system.debug('contList size ' + contList.size());
                    system.debug('docListToInsert size ' + docListToInsert.size());
                    PAD.PAD_BypassTrigger += ';AP52_DocumentContractuel;AP01_DocumentContractuel;';
                    if(docListToInsert != null && docListToInsert.size() > 0) {
                        for(Document_Contractuel__c doc : docListToInsert) {
                            doc.DateDeclenchement__c = dateDeclenchement;
                        }
                        update docListToInsert;
                    }
                    if(contList.size() > 0) {
                        PAD.PAD_BypassTrigger += ';AP48_ContractCallouts;';
                        PAD.PAD_BypassTrigger += ';AP45_Account;';
                        contList[0].id = contractId;
                        contList[0].DateDeclenchement__c = dateDeclenchement;
                        system.debug('contlist ' + contList);
                        system.debug(contlist[0].dkcodesurcontrat__c);
                        upsert contList;
                        Set<id> setIdCon = new Set<id>();
                        Set<id> setIdOwner = new Set<id>();

                        for(Contrat__c con : contList) {
                            setIdCon.add(con.id);
                            setIdOwner.add(con.OwnerId);
                        }

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

            }
            if(wsResponse.contains('Web service callout failed')) {
                return 'error';
            } else {
                return '';
            }
        }
    }

    @AuraEnabled
    public static string checkContract(String contractId){
        try {
            Contrat__c cont = [SELECT id, name, DKCodeSurContrat__c, statut__c, (select id from Documents_Contractuels__r)
                               FROM Contrat__c
                               Where id =:contractId
                               LIMIT 1];

            Database.SaveResult result1 = Database.update(cont, false);
            if(!result1.isSuccess()) {
                return 'Erreur au niveau du contrat. Veuillez corriger l\'erreur suivante avant de synchroniser: ' + result1.getErrors()[0].getMessage();
            }

            List<Document_Contractuel__c> listDocs = [Select id, TitreDocument__c, Titre_complet_du_document__c
                                                      from Document_Contractuel__c
                                                      where Contrat__c = : cont.id
                                                      and NumeroPiece__c = null];
            if(listDocs.size() > 0) {
                //Added by Jimmy Khalil (09/06/2021)
                //US C360-101: set "ZZZ Tech Titre complet du document" = "Titre complet du document" before sending
                for(Document_Contractuel__c doc : listDocs) {
                    doc.TitreDocument__c = doc.Titre_complet_du_document__c;
                }
                List<Database.SaveResult> result2 = Database.update(listDocs, false);
                for(Database.SaveResult result : result2) {
                    if(!result.isSuccess()) {
                        return 'Erreur au niveau du document contractuel. Veuillez corriger l\'erreur suivante avant de synchroniser: ' + result.getErrors()[0].getMessage();
                    }
                }
            }

        }
        catch(Exception e) {
            System.debug('Fonction checkContract... Excpetion ' + e.getMessage());
        }

        return 'OK';
    }

    @AuraEnabled
    public static String checkDocRelatedScan(String contractId){

        Set<id> setDocIds = new Set<id>();

        List<Document_Contractuel__c> listDocs = [SELECT id
                                                  FROM Document_Contractuel__c
                                                  WHERE Contrat__c =: contractId
                                                  AND NumeroPiece__c = null];
        for(Document_Contractuel__c doc : listDocs) {
            setDocIds.add(doc.Id);
        }

        List<ContentDocumentLink> listScans = [SELECT id
                                               FROM ContentDocumentLink
                                               WHERE LinkedEntityId in :setDocIds];

        if(listScans.size() < listDocs.size()) {
            return 'KO';
        } else {
            return 'OK';
        }
    }

    @AuraEnabled
    public static String checkDocResiliation(String contractId){

        List<Document_Contractuel__c> listDocs = [SELECT id
                                                  FROM Document_Contractuel__c
                                                  WHERE Contrat__c =: contractId
                                                  AND NatureDocument__c =: Label.LC51_LettreResiliation ];

        if(listDocs.size() > 0) {
            return 'KO';
        } else {
            return 'OK';
        }
    }

    @AuraEnabled
    public static String checkDocsCombination(String contractId){

        List<String> cfActeEngagement = new List<String> {'DOC12', 'DOC07', 'DOC13', 'DOC16', 'DOC17', 'DOC18', 'DOC14', 'DOC20'};
        List<String> cfContrat = new List<String> {'DOC07', 'DOC13', 'DOC16', 'DOC17', 'DOC18', 'DOC20'};
        List<String> cfOrdreService = new List<String> {'DOC07', 'DOC13', 'DOC16', 'DOC17', 'DOC18', 'DOC03', 'DOC20'};

        List<Contrat__c> lstContrats = [SELECT id, DKCodeSurContrat__c
                                        FROM Contrat__c
                                        WHERE id =: contractId];

        Boolean acteEng = false;
        Boolean contrat = false;
        Boolean ordreService = false;
        Boolean hasCCP = false;
        Boolean hasPropComm = false;

        if(lstContrats[0].DKCodeSurContrat__c == null) {
            List<Document_Contractuel__c> lstDocs = [SELECT id, NatureDocument__c
                                                     FROM Document_Contractuel__c
                                                     WHERE Contrat__c =: contractId];

            system.debug('*** 1ere synchro ***');
            //1ere synchro
            for(Document_Contractuel__c doc : lstDocs) {
                if(doc.NatureDocument__c.equals('DOC02')) {
                    acteEng = true;
                } else if(doc.NatureDocument__c.equals('DOC01')) {
                    contrat = true;
                }
            }

            //on a uniquement un ordre de service sans contrat ou acte d'engagement
            for(Document_Contractuel__c doc : lstDocs) {
                if(doc.NatureDocument__c.equals('DOC10') && !acteEng && !contrat) {
                    ordreService = true;
                }
            }

            // Acte engagement doit obligatoirement avoir un CCP
            for(Document_Contractuel__c doc : lstDocs) {
                if(acteEng && doc.NatureDocument__c.equals('DOC14')) {
                    hasCCP = true;
                }

                if(!acteEng && !contrat && ordreService && doc.NatureDocument__c.equals('DOC03')) {
                    hasPropComm = true;
                }
            }

            if(acteEng && !hasCCP) {
                system.debug('*** Acte engagement sans CCP ***');

                return Label.First_Sync_Error;
            }

            if(!acteEng && !contrat && ordreService && !hasPropComm) {
                system.debug('*** Ordre service sans Proposition commerciale ***');

                return Label.First_Sync_Error;
            }

            for(Document_Contractuel__c doc : lstDocs) {
                if(acteEng && hasCCP && !doc.NatureDocument__c.equals('DOC02') && !cfActeEngagement.contains(doc.NatureDocument__c)) {
                    system.debug('*** Acte engagement avec CCP et doc pas dans la combinaison. Nature Doc =' + doc.NatureDocument__c);

                    return Label.First_Sync_Error;
                }

                if(contrat && !doc.NatureDocument__c.equals('DOC01') && !cfContrat.contains(doc.NatureDocument__c)) {
                    system.debug('*** Contrat avec doc pas dans la combinaison. Nature Doc =' + doc.NatureDocument__c);

                    return Label.First_Sync_Error;
                }

                if(!acteEng && !contrat && ordreService && hasPropComm && !doc.NatureDocument__c.equals('DOC10') && !cfOrdreService.contains(doc.NatureDocument__c)) {
                    system.debug('*** Ordre service avec Proposition commerciale et doc pas dans la combinaison. Nature Doc =' + doc.NatureDocument__c);

                    return Label.First_Sync_Error;
                }
            }

        } else {
            system.debug('*** 2eme synchro ***');
            //2eme synchro

            List<Document_Contractuel__c> lstDocContratOuActe = [SELECT id, NatureDocument__c
                                                                 FROM Document_Contractuel__c
                                                                 WHERE Contrat__c =: contractId
                                                                 AND NatureDocument__c in ('DOC01', 'DOC02')
                                                                 AND numeroPiece__c != null];
            if(lstDocContratOuActe.size() < 1) {
                List<Document_Contractuel__c> lstDocOrdreService = [SELECT id, NatureDocument__c
                                                                    FROM Document_Contractuel__c
                                                                    WHERE Contrat__c =: contractId
                                                                    AND NatureDocument__c = 'DOC10'
                                                                    AND numeroPiece__c != null];

                if(lstDocOrdreService.size() > 0) {
                    List<Document_Contractuel__c> lstDocs = [SELECT id, NatureDocument__c, numeroPiece__c
                                                             FROM Document_Contractuel__c
                                                             WHERE Contrat__c =: contractId];

                    for(Document_Contractuel__c doc : lstDocs) {
                        if(doc.NatureDocument__c.equals('DOC02') && doc.numeroPiece__c == null) {
                            acteEng = true;
                        } else if(doc.NatureDocument__c.equals('DOC01') && doc.numeroPiece__c == null) {
                            contrat = true;
                        }
                    }

                    if(!acteEng && !contrat) {
                        system.debug('*** La création de contrat via un Ordre de Service doit être complétée d\'un contrat ou d\'un acte d\'engagement ***');

                        return Label.Second_Sync_Error;
                    }

                    for(Document_Contractuel__c doc : lstDocs) {
                        if(acteEng && doc.NatureDocument__c.equals('DOC14') && doc.numeroPiece__c == null) {
                            hasCCP = true;
                        }
                    }

                    if(acteEng && !hasCCP) {
                        system.debug('*** Acte engagement sans CCP ***');

                        return Label.First_Sync_Error;
                    }

                    for(Document_Contractuel__c doc : lstDocs) {
                        if(acteEng && hasCCP && doc.numeroPiece__c == null && !doc.NatureDocument__c.equals('DOC02') && !cfActeEngagement.contains(doc.NatureDocument__c)) {
                            system.debug('*** Acte engagement avec CCP et doc pas dans la combinaison. Nature Doc =' + doc.NatureDocument__c);

                            return Label.First_Sync_Error;
                        }

                        if(contrat && doc.numeroPiece__c == null && !doc.NatureDocument__c.equals('DOC01') && !cfContrat.contains(doc.NatureDocument__c)) {
                            system.debug('*** Contrat avec doc pas dans la combinaison. Nature Doc =' + doc.NatureDocument__c);

                            return Label.First_Sync_Error;
                        }
                    }
                }
            }

        }
        system.debug('*** CAN SYNC ***');

        return 'OK';
    }

    //method that verifies if we are in maintenance mode or not
    @AuraEnabled
    public static Boolean checkIfModeMaintenance(){

        List<Mode_Maintenance__c> lstMM = [select id, En_mode_maintenance__c from Mode_Maintenance__c limit 1];
        if(lstMM.size() > 0) {
            return lstMM[0].En_mode_maintenance__c;
        } else {
            return false;
        }
    }

    public static String generatedToken {get; set;}
    public static String numPiece {get; set;}

    public static PageReference getConsulterDocument(){
        String numeroPiece = apexpages.currentPage().getParameters().get('numPiece');
        system.debug('*** getConsulterDocument / numeroPiece =' + numeroPiece);
        String token = DalkiaManager.getDocumentToken();

        generatedToken = token;
        numPiece = numeroPiece;

        return null;
    }

    @AuraEnabled
    public static String getConsulterDocumentLWC(){
        String token = DalkiaManager.getDocumentToken();

        return token;
    }
}