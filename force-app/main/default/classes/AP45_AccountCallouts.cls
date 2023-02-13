/**
 *@author Hussein Farran
 *@date 04/03/2019
 *@description All methods that call the web-service partenaire provided by Dalkia.
 */
public class AP45_AccountCallouts {
    public static Set<Id> accountIds = new Set<Id>();
    public static List<Account> accountListMPR = new List<Account>();//Modifier Partenaire Restreinte
    public static List<Account> accountListMP = new List<Account>();//Modifier Partenaire
    public static List<Account> accountListCP = new List<Account>();//Creer Partenaire
    public static List<Account> accountListMSR = new List<Account>();//Modifier Societe Resrteinte
    public static List<Account> accountListCPIE = new List<Account>();//Creer partenaire ID externe
    public static List<Account> accountListMA = new List<Account>();//ModifierAdresse
    /**
     *@author Hussein Farran
     *@date 04/03/2019
     *@description creates lists respective for the type of calls that need to be made and invokes the future method.
     *@params List of account (Trigger.new), type of call (edit or create)
     *@return void
     */
    public static void handleList(List<Account> listAcc, String type){
        System.debug('handleList');
        System.debug('listAcc ' + listAcc);
        String partenaireAvecSiret = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.Business_Account).getRecordTypeId();
        //String partenaireSansValid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.Coproprietes).getRecordTypeId();
        String partenaireSociete = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.societe_account).getRecordTypeId();
        //after update
        if(type.equals('update')) {
            for(Account acc : listAcc) {
                if(String.isNotBlank(acc.DKCodeSurPartenaire__c)) {
                    //partenaire avec siret et sans validation
                    if(acc.RecordTypeId == partenaireAvecSiret) {
                        accountListMPR.add(acc);
                    }
                    //particulier
                    else if(acc.IsPersonAccount == true) {
                        accountListMA.add(acc);
                        accountListMP.add(acc);
                    } else if(acc.RecordTypeId == partenaireSociete)   {
                        accountListMSR.add(acc);
                    }
                } else   {//dk code n'existe pas
                    if(acc.IsPersonAccount == true) {//particulier
                        accountListCP.add(acc);
                    }
                }
            }
        }
        //after insert
        else if(type.equals('create')) {
            for(Account acc : listAcc) {
                if(acc.IsPersonAccount == true) {//particulier
                    accountListCP.add(acc);
                } else if(acc.RecordTypeId == partenaireAvecSiret)   {
                    accountListCPIE.add(acc);
                }

            }
        }
        if(accountListMP.size() > 0) {
            String jsonString = Json.serialize(accountListMP);
            WebserviceLog__c ws = new WebserviceLog__c();
            ws.Type__c = 'ModifierPartenaire';
            ws.flux__c = 'sortant';
            String jsonLog = Json.serialize(ws);
            ModifierPartenaire(jsonString, jsonLog);
        }
        if(accountListMPR.size() > 0) {
            String jsonString = Json.serialize(accountListMPR);
            WebserviceLog__c ws = new WebserviceLog__c();
            ws.Type__c = 'ModifierPartenaireRestreint';
            ws.flux__c = 'sortant';
            String jsonLog = Json.serialize(ws);
            ModifierPartenaireRestreint(jsonString, jsonLog);
        }
        if(accountListCP.size() > 0) {
            String jsonString = Json.serialize(accountListCP);
            WebserviceLog__c ws = new WebserviceLog__c();
            ws.Type__c = 'CreerPartenaire';
            ws.flux__c = 'sortant';
            String jsonLog = Json.serialize(ws);
            CreerPartenaire(jsonString, jsonLog);
        }
        if(accountListMSR.size() > 0) {
            String jsonString = Json.serialize(accountListMSR);
            WebserviceLog__c ws = new WebserviceLog__c();
            ws.Type__c = 'ModifierSocieteRestreint';
            ws.flux__c = 'sortant';
            String jsonLog = Json.serialize(ws);
            ModifierSocieteRestreint(jsonString, jsonLog);
        }
        if(accountListCPIE.size() > 0) {
            String jsonString = Json.serialize(accountListCPIE);
            //CreerPartenaireIdExterne(jsonString);
        }
    }

    /**
     *@author Alain Ghoussoub
     *@date 11/12/2019
     *@description invokes the web-service ModifierPartenaire
     *@param String json of a serialized list
     *@return void
     */

    /* @Future(callout=true) Pour après envoyer pilote
       public static void ModifierPartenaireIdExterne(String accountId){
         system.debug('ModifierPartenaireIdExterne');
         String wsResponse = '';
         String wsRequest = '';
         String wsCodeRetour = '';
         Account acc = new Account();
         String objectDocName = 'Account';
         String queryAcc = 'Select ';
         Map<String, Schema.SObjectField> docFields = Schema.getGlobalDescribe().get(objectDocName).getDescribe().fields.getMap();

         // Grab the fields from the describe method and append them to the queryString one by one.
         for(String s : docFields.keySet()) {
             queryAcc += ' ' + s + ', ';
         }
         // Strip off the last comma if it exists.
         if (queryAcc.subString(queryAcc.Length()-2,queryAcc.Length()) == ', '){
             queryAcc = queryAcc.subString(0,queryAcc.Length()-2);
         }
         queryAcc += ' FROM ' + objectDocName;
         queryAcc += ' WHERE Contrat__c = \''+accountId+'\'';
         System.debug(queryAcc);
         Try{
             acc = Database.query(queryAcc);
         }
         Catch(Exception e){
             System.debug('Exception ' + e.getMessage());
         }


         System.debug('ModifierPartenaire');
         List<Account> lstAcct = new List<Account>();
         WebserviceLog__c ws = new WebserviceLog__c();
         try {
             wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintRequete request = Partenaire_Mapper.fillModifierPartenaireRestreintRequete(acc);
             System.debug('AP45 request ' + request);
             wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintReponse response = DalkiaManager.doCallOutModifierPartenaireRestreint(request);
             System.debug('AP45 response ' + response);
             wsRequest  = json.serialize(acc);
             if(response !=null && response.informationsRetour != null){
                 if (response.informationsRetour.codeRetour == 'OK'){
                     system.debug('ws ok');
                     wsResponse = 'OK';
                     wsCodeRetour = 'OK';
                     //Account newAcc = Partenaire_Mapper.getModifierPartenaireRestreintRequete(response,acc);
                     //newAcc.SynchronisationErrorType__c = '';
                     //newAcc.SynchronisedStatutCreation__c = Label.WS_Creation_OK;
                     //newAcc.WSCreationDate__c = System.now();
                     //lstAcct.add(newAcc);
                 }
                 else if (response.informationsRetour.codeRetour == 'KO'){
                     wsCodeRetour = 'KO';
                     wsResponse = response.informationsRetour.messageRetour;
                     acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                     acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                     acc.WSModificationDate__c = System.now();
                     //lstAcct.add(acc);
                 }
                 else {
                     system.debug('erreur ws');
                     wsCodeRetour = 'ERROR';
                     acc.SynchronisationErrorType__c = Label.WS_PartenaireError;
                     acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                     acc.WSModificationDate__c = System.now();
                     //lstAcct.add(acc);
                 }
             }
         }
         catch (Exception e){
             system.debug('erreur ws');
             wsCodeRetour = 'ERROR';
             wsRequest = json.serialize(acc);
             wsResponse = e.getMessage();
             acc.SynchronisationErrorType__c = e.getMessage();
             acc.WSModificationDate__c = System.now();
             PAD.PAD_BypassTrigger+=';AP45_Account;';
             System.debug('Exception ' + e);
             //update acc;
         }
         finally{
             system.debug('finally ws');
             ws.Response__c = wsResponse;
             ws.Request__c = wsRequest;
             ws.ObjectId__c = acc.Id;
             ws.CodeRetour__c = wsCodeRetour;
             insert ws;
         }
       }
     */

    /**
     *@author Hussein Farran
     *@date 04/03/2019
     *@description invokes the web-service ModifierPartenaire
     *@param String json of a serialized list
     *@return void
     */
    @Future(callout = true)
    public static void ModifierPartenaire(String jsonList, String jsonLog){
        String type = 'ModifierPartenaire';
        String wsResponse = '';
        String wsRequest = '';
        String wsCodeRetour = '';
        List<Account> accountList = new List<Account>();
        if(String.isNotBlank(jsonList)) {
            accountList = (List<Account>)Json.deserialize(jsonList, List<Account> .class);
        }
        System.debug('ModifierPartenaire');
        List<Account> lstAcct = new List<Account>();
        WebserviceLog__c ws = (WebserviceLog__c)Json.deserialize(jsonLog, WebserviceLog__c.class);
        if(accountList != null && accountList.size() > 0) {
            Account acc = accountList[0];
            try {
                wwwDalkiaFrReferentielPartenaire.modifierPartenaireRequete request = Partenaire_Mapper.fillModifierPartenaireRequete(acc);
                System.debug('AP45 request ' + request);
                wwwDalkiaFrReferentielPartenaire.modifierPartenaireReponse response = DalkiaManager.doCallOutModifierPartenaire(request);
                System.debug('AP45 response ' + response);
                wsRequest  = json.serialize(acc);
                wsResponse = '';
                wsCodeRetour = '';
                if(response != null && response.informationsRetour != null) {
                    if(response.informationsRetour.codeRetour == 'OK') {
                        wsResponse = 'OK';
                        wsCodeRetour = 'OK';
                        Account newAcc = Partenaire_Mapper.getModifierPartenaireRequete(response, acc);
                        newAcc.SynchronisationErrorType__c = '';
                        newAcc.SynchronisedStatutModification__c = Label.WS_Modification_OK;
                        newAcc.WSCreationDate__c = System.now();
                        lstAcct.add(newAcc);
                    } else if(response.informationsRetour.codeRetour == 'KO')   {
                        wsCodeRetour = 'KO';
                        wsResponse = response.informationsRetour.messageRetour;
                        if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                        } else   {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                        }
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                        acc.WSModificationDate__c = System.now();
                        lstAcct.add(acc);
                    } else   {
                        wsCodeRetour = 'ERROR';
                        acc.SynchronisationErrorType__c = Label.WS_PartenaireError;
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                        acc.WSModificationDate__c = System.now();
                        lstAcct.add(acc);
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR';
                wsRequest = json.serialize(acc);
                wsResponse = e.getMessage();
                if(e.getMessage().length() > 990) {
                    acc.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                } else   {
                    acc.SynchronisationErrorType__c = e.getMessage();
                }
                acc.WSModificationDate__c = System.now();
                PAD.PAD_BypassTrigger += ';AP45_Account;';
                System.debug('Exception ' + e);
                update acc;
            } finally {
                ws.Response__c = wsResponse;
                ws.Request__c = wsRequest;
                ws.ObjectId__c = acc.Id;
                ws.CodeRetour__c = wsCodeRetour;
                insert ws;
            }
        }
        if(lstAcct.size() > 0) {
            PAD.PAD_BypassTrigger += ';AP45_Account;';
            update updateOwnerwithoutVR(lstAcct);
        }
    }

    /**
     *@author Hussein Farran
     *@date 04/03/2019
     *@description invokes the web-service ModifierPartenaireRestreint
     *@param String json of a serialized list
     *@return void
     */
    @Future(callout = true)
    public static void ModifierPartenaireRestreint(String jsonList, String jsonLog){
        String type = 'ModifierPartenaireRestreint';
        String wsResponse = '';
        String wsRequest = '';
        String wsCodeRetour = '';
        List<Account> accountList = new List<Account>();
        if(String.isNotBlank(jsonList)) {
            accountList = (List<Account>)Json.deserialize(jsonList, List<Account> .class);
        }
        WebserviceLog__c ws = (WebserviceLog__c)Json.deserialize(jsonLog, WebserviceLog__c.class);
        System.debug('ModifierPartenaireRestreint');
        List<Account> lstAcct = new List<Account>();

        if(accountList != null && accountList.size() > 0) {
            Account acc = accountList[0];
            try {
                wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintRequete request = Partenaire_Mapper.fillModifierPartenaireRestreintRequete(acc);
                System.debug('AP45 request ' + request);
                wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintReponse response = DalkiaManager.doCallOutModifierPartenaireRestreint(request);
                System.debug('AP45 response ' + response);
                wsRequest  = json.serialize(acc);
                wsResponse = '';
                wsCodeRetour = '';
                system.debug('response.informationsRetour.codeRetour ' + response.informationsRetour.codeRetour);
                if(response != null && response.informationsRetour != null) {
                    if(response.informationsRetour.codeRetour == 'OK') {
                        wsResponse = 'OK';
                        wsCodeRetour = 'OK';
                        acc.SynchronisationErrorType__c = '';
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_OK;
                        acc.WSModificationDate__c = System.now(); // Returns the current Datetime based on a GMT calendar.
                        lstAcct.add(acc);
                    } else if(response.informationsRetour.codeRetour == 'KO')   {
                        wsCodeRetour = 'KO';
                        wsResponse = response.informationsRetour.messageRetour;
                        if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                        } else   {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                        }
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                        acc.WSModificationDate__c = System.now();
                        lstAcct.add(acc);
                    } else   {
                        wsCodeRetour = 'ERROR';
                        acc.SynchronisationErrorType__c = Label.WS_PartenaireError;
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                        acc.WSModificationDate__c = System.now();
                        lstAcct.add(acc);
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR';
                wsRequest = json.serialize(acc);
                wsResponse = e.getMessage();
                if(e.getMessage().length() > 990) {
                    acc.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                } else   {
                    acc.SynchronisationErrorType__c = e.getMessage();
                }
                acc.WSModificationDate__c = System.now();
                PAD.PAD_BypassTrigger += ';AP45_Account;';
                System.debug('Exception ' + e);
                update acc;
            } finally {
                ws.Response__c = wsResponse;
                ws.Request__c = wsRequest;
                ws.ObjectId__c = acc.Id;
                ws.CodeRetour__c = wsCodeRetour;
                insert ws;
            }
        }
        if(lstAcct.size() > 0) {
            PAD.PAD_BypassTrigger += ';AP45_Account;';
            update updateOwnerwithoutVR(lstAcct);
        }
    }

    /**
     *@author Chadi Geara
     *@date 03/05/2019
     *@description invokes the web-service CreerPartenaire
     *@param String json of a serialized list
     *@return void
     */
    @Future(callout = true)
    public static void CreerPartenaire(String jsonList, String jsonLog){
        String type = 'CreerPartenaire';
        String wsResponse = '';
        String wsRequest = '';
        String wsCodeRetour = '';
        List<Account> accountList = new List<Account>();
        if(String.isNotBlank(jsonList)) {
            accountList = (List<Account>)Json.deserialize(jsonList, List<Account> .class);
        }
        WebserviceLog__c ws = (WebserviceLog__c)Json.deserialize(jsonLog, WebserviceLog__c.class);
        System.debug('CreerPartenaire');
        List<Account> accountsToInsert = new List<Account>();
        wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse response =  new wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse();
        if(accountList != null && accountList.size() > 0) {
            Account acc = accountList[0];
            try {
                System.debug('ACCOUNT DEBUG ---> ' + acc);
                wwwDalkiaFrReferentielPartenaire.creerPartenaireRequete request = Partenaire_Mapper.fillCreerPartenaireRequete(acc);
                System.debug('AP45 CreerPartenaire request ' + request);
                response = DalkiaManager.doCallOutCreerPartenaire(request);
                System.debug('AP45 CreerPartenaire response ' + response);
                wsRequest  = json.serialize(acc);
                wsCodeRetour = '';
                wsResponse = '';
                if(response != null && response.informationsRetour != null) {
                    if(response.informationsRetour.codeRetour == 'OK') {
                        wsCodeRetour = 'OK';
                        wsResponse = 'OK';
                        Account newAcc = Partenaire_Mapper.getCreerPartenaireRequete(response, acc);
                        newAcc.SynchronisationErrorType__c = '';
                        newAcc.SynchronisedStatutCreation__c = Label.WS_Creation_OK;
                        newAcc.WSCreationDate__c = System.now();
                        System.debug('AP45 getCreerPartenaire response ' + newAcc);
                        accountsToInsert.add(newAcc);

                    } else if(response.informationsRetour.codeRetour == 'KO')   {
                        wsCodeRetour = 'KO';
                        wsResponse = response.informationsRetour.messageRetour;
                        if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                        } else   {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                        }
                        acc.SynchronisedStatutCreation__c = Label.WS_Creation_KO;
                        acc.WSCreationDate__c = System.now();
                        accountsToInsert.add(acc);
                    } else   {
                        if(response.informationsRetour.messageRetour != null) {
                            wsResponse = response.informationsRetour.messageRetour;
                            if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                                acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                            } else   {
                                acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                            }
                        }
                        wsCodeRetour = 'ERROR';
                        acc.SynchronisedStatutCreation__c = Label.WS_Creation_KO;
                        acc.WSCreationDate__c = System.now();
                        accountsToInsert.add(acc);
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR';
                wsRequest = json.serialize(acc);
                wsResponse = e.getMessage();
                if(e.getMessage().length() > 990) {
                    acc.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                } else   {
                    acc.SynchronisationErrorType__c = e.getMessage();
                }
                acc.WSCreationDate__c = System.now();
                PAD.PAD_BypassTrigger += ';AP45_Account;';
                System.debug('Exception ' + e);
                upsert acc;
            } finally {
                ws.Response__c = wsResponse;
                ws.Request__c = wsRequest;
                ws.ObjectId__c = acc.Id;
                ws.CodeRetour__c = wsCodeRetour;
                insert ws;
            }
        }
        try {
            PAD.PAD_BypassTrigger += ';AP45_Account;';
            upsert accountsToInsert;
        }
        catch(Exception e) {
            System.debug('Exception ' + e.getMessage());
        }
    }
    /**
     *@author Hussein Farran
     *@date 03/25/2019
     *@description invokes the web-service ModifierSocieteRestreint
     *@param String json of a serialized list
     *@return void
     */
    @Future(callout = true)
    public static void ModifierSocieteRestreint(String jsonList, String jsonLog){
        String typeAppel = 'ModifierSocieteRestreint';
        String wsResponse = '';
        String wsRequest = '';
        String wsCodeRetour = '';
        List<Account> accountList = new List<Account>();
        if(String.isNotBlank(jsonList)) {
            accountList = (List<Account>)Json.deserialize(jsonList, List<Account> .class);
        }
        WebserviceLog__c ws = (WebserviceLog__c)Json.deserialize(jsonLog, WebserviceLog__c.class);
        System.debug('ModifierSocieteRestreint');
        List<Account> lstAcct = new List<Account>();

        if(accountList != null && accountList.size() > 0) {
            Account acc = accountList[0];
            try {
                String type = 'ModifierSocieteRestreint';
                System.debug('ACCOUNT DEBUG ---> ' + acc);
                wwwDalkiaFrReferentielSociete.modifierSocieteRestreintRequete request = Societe_Mapper.fillModifierSocieteRestreintRequete(acc);
                System.debug('AP45 ModifierSocieteRestreint request ' + request);
                wwwDalkiaFrReferentielSociete.modifierSocieteRestreintReponse response = DalkiaManager.doCallOutModifierSocieteRestreint(request);
                System.debug('AP45 ModifierSocieteRestreint response ' + response);
                ws.Request__c  = json.serialize(acc);
                wsCodeRetour = '';
                ws.Response__c = '';
                if(response != null && response.informationsRetour != null) {
                    if(response.informationsRetour.codeRetour == 'OK') {
                        wsCodeRetour = 'OK';
                        ws.Response__c = 'OK';
                        Account newAcc = Societe_Mapper.getModifierSocieteRestreintRequete(response, acc);
                        newAcc.SynchronisationErrorType__c = '';
                        newAcc.SynchronisedStatutModification__c = Label.WS_Modification_OK;
                        newAcc.WSModificationDate__c = System.now(); // Returns the current Datetime based on a GMT calendar.
                        lstAcct.add(newAcc);
                    } else if(response.informationsRetour.codeRetour == 'KO')   {
                        wsCodeRetour = 'KO';
                        ws.Response__c = response.informationsRetour.messageRetour;
                        if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                        } else   {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                        }
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                        acc.WSModificationDate__c = System.now();
                        lstAcct.add(acc);
                    } else   {
                        if(response.informationsRetour.messageRetour != null) {
                            ws.Response__c = response.informationsRetour.messageRetour;
                            if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                                acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                            } else   {
                                acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                            }
                        }
                        wsCodeRetour = 'ERROR';
                        acc.SynchronisedStatutModification__c = Label.WS_Modification_KO;
                        acc.WSModificationDate__c = System.now();
                        lstAcct.add(acc);
                    }

                }
            }
            catch(Exception e) {
                wsCodeRetour = 'ERROR';
                ws.Request__c = json.serialize(acc);
                ws.Response__c = e.getMessage();
                if(e.getMessage().length() > 990) {
                    acc.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                } else   {
                    acc.SynchronisationErrorType__c = e.getMessage();
                }
                acc.WSModificationDate__c = System.now();
                System.debug('Exception [ModifierSocieteRestreint] ' + e);
                PAD.PAD_BypassTrigger += ';AP45_Account;';
                update acc;
            } finally {
                //ws.Response__c = wsResponse;
                //ws.Request__c = wsRequest;
                ws.ObjectId__c = acc.Id;
                //ws.CodeRetour__c = wsCodeRetour;
                system.debug('web log ' + ws);
                insert ws;
            }
        }
        if(lstAcct.size() > 0) {
            PAD.PAD_BypassTrigger += ';AP45_Account;';
            update updateOwnerwithoutVR(lstAcct);
        }
    }

    /**
     *@author Chadi Geara
     *@date 03/28/2019
     *@description invoke the web-service CreerPartenaireIdExterne and get the return and upsert the account
     *@param String json of a serialized list
     *@return void
     */
    public static String CreerPartenaireIdExterne(String jsonList){
        String type = 'CreerPartenaireIdExterne';
        String wsResponse = '';
        String wsRequest = '';
        String wsCodeRetour = '';
        List<Account> accountList = new List<Account>();
        system.debug('jsonList ' + jsonList);
        if(String.isNotBlank(jsonList)) {
            accountList = (List<Account>)Json.deserialize(jsonList, List<Account> .class);
        }
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Type__c = 'CreerPartenaireIdExterne';
        ws.flux__c = 'sortant';
        System.debug('CreerPartenaireIdExterne');
        List<Account> accountsToInsert = new List<Account>();

        if(accountList != null && accountList.size() > 0) {
            Account acc = accountList[0];
            try {
                DateTime dateDeclenchement = System.now();
                System.debug('ACCOUNT DEBUG ---> ' + acc);
                wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete request = Partenaire_Mapper.fillCreerPartenaireIdExterneRequete(acc);
                System.debug('AP45 CreerPartenaireIdExterne request ' + request);
                wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneReponse response = DalkiaManager.doCallOutCreerPartenaireIdExterne(request);
                System.debug('AP45 CreerPartenaireIdExterne response ' + response);
                wsRequest  = json.serialize(acc);
                wsCodeRetour = '';
                wsResponse = '';
                if(response != null && response.informationsRetour != null) {

                    if(response.informationsRetour.codeRetour == 'OK') {
                        wsCodeRetour = 'OK';
                        wsResponse = 'OK';
                        Account newAcc = Partenaire_Mapper.getCreerPartenaireIdExterneRequete(response, acc);
                        newAcc.IdExterne__c = true;
                        newAcc.DateDeclenchement__c = dateDeclenchement;
                        system.debug('newAcc ' + newAcc.Segment_client__c);
                        system.debug('newAcc ' + newAcc.Sous_segment_client__c);
                        if(response.informationsRetour.messageRetour != null && response.informationsRetour.messageRetour.length() > 990) {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour.substring(0, 990);
                        } else   {
                            acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                        }
                        newAcc.SynchronisedStatutCreation__c = Label.WS_Creation_OK;
                        newAcc.WSCreationDate__c = System.now();
                        accountsToInsert.add(newAcc);
                    } else if(response.informationsRetour.codeRetour == 'KO')   {
                        wsCodeRetour = 'KO';
                        wsResponse = response.informationsRetour.messageRetour;
                        upsert ws;
                        if(wsResponse != null && wsResponse.contains('doublon')) {
                            return Label.DoublonMessage;
                        }

                        return response.informationsRetour.messageRetour;
                        //acc.SynchronisationErrorType__c = response.informationsRetour.messageRetour;
                        //acc.SynchronisedStatutCreation__c = Label.WS_Creation_KO;
                        //acc.WSCreationDate__c = System.now();
                        //accountsToInsert.add(acc);
                    }
                }
            }
            catch(Exception e) {
                wsCodeRetour = 'KO';
                System.debug('CreerPartenaireIdExterne');
                wsRequest = json.serialize(acc);
                wsResponse = e.getMessage();
                System.debug('Exception [CreerPartenaireIdExterne] ' + e);
                upsert ws;

                return 'Une erreur technique a empêché la création, veuillez contacter le support';
            } finally {
                ws.Response__c = wsResponse;
                ws.Request__c = wsRequest;
                ws.CodeRetour__c = wsCodeRetour;
                if(!Test.isRunningTest()) {
                    upsert ws;
                }
            }
        }

        String partenaireAvecSiret = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.Business_Account).getRecordTypeId();
        try {
            if(accountsToInsert.size() > 0) {
                accountsToInsert[0].techBypassVR__c = true;
                accountsToInsert[0].recordTypeId = partenaireAvecSiret;
                accountsToInsert[0].Type_immatriculation__c = 'RCS';
                PAD.PAD_BypassTrigger += ';AP45_Account;';
                upsert accountsToInsert DKCodeSurPartenaire__c;
                accountsToInsert[0].techBypassVR__c = false;
                upsert accountsToInsert DKCodeSurPartenaire__c;
                ws.ObjectId__c = accountsToInsert[0].Id;
                upsert ws;

                return accountsToInsert[0].id;
            }

            return '';

        }
        catch(Exception e) {
            if(accountsToInsert.size() > 0) {
                ws.ObjectId__c = accountsToInsert[0].Id;
                upsert ws;
            }
            System.debug('Exception ' + e.getMessage());

            return e.getMessage();
        }
    }
    /**
     *@author Alain Ghoussoub
     *@date 27/05/2019
     *@description updates uoPilote
     *@param
     *@return void

       public static void updateUOPilote(List<Account> listAcc){
       Set<Id> accountIds = new Set<Id>();
       for(Account acc : listAcc){
        accountIds.add(acc.id);
       }
       //List<Account> accountsUpdated = [Select id,Agence__r.Region__r.CentreFinance__c
                                    //FROM Account
                                    //WHERE id in :accountIds];

       }*/
    /**
     *@author Jacques Akiki
     *@date 28/07/2022
     *@description updates technical fields on Account to bypass VR
     *@param
     *@return void
     */
    public static list<Account> updateOwnerwithoutVR(List<Account> listAcc){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : listAcc) {
            accountIds.add(acc.id);
        }
        List<Account> accountsUpdated = [Select id, TechEditAccountOwner__c
                                         FROM Account
                                         WHERE id in :accountIds];
        for(Account acc : accountsUpdated) {
            acc.TechEditAccountOwner__c = !acc.TechEditAccountOwner__c;
        }

        return accountsUpdated;

    }

}