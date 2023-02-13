/**
 *@author Hussein Farran
 *@date 21/02/2019
 *@description Controller for LC41_EditAccount.cmp
 */
public without sharing class LC41_EditAccount_Controller {
    /**
     *@author Hussein Farran
     *@date 21/02/2019
     *@description Invoke the ConsulterPartenaire web-service to get the latest data of that account record and update it.
     *@param Account ID
     *@return void
     */
    @AuraEnabled
    public static void synchronizeAccount(String AccountId){
        Account acc = [Select id, DKCodeSurPartenaire__c, recordtype.Developername from Account where id =:AccountId];
        String wsType = 'ConsulterPartenaire';
        String wsResponse = '';
        String wsFlux = 'sortant';
        wsType = '';
        if(acc != null && acc.recordtype != null && acc.recordtype.Developername != null) {
            String wsRequest = json.serialize(acc);
            //societe record type
            if(acc.recordtype.Developername == Label.societe_account) {
                try {
                    wsType = 'ConsulterSociete';
                    wwwDalkiaFrReferentielSociete.consulterSocieteRequete cons1 = Societe_Mapper.fillConsulterSocieteRequete(acc);
                    System.debug('consulterSocieteRequete ' + cons1);
                    wwwDalkiaFrReferentielSociete.consulterSocieteReponse resp1 = DalkiaManager.doCallOutConsulterSociete(cons1);
                    System.debug('consulterSocieteReponse ' + resp1);

                    if(resp1.informationsRetour != null) {

                        List<Account> lstAcct = new List<Account>();

                        if(resp1.informationsRetour.codeRetour == 'OK') {
                            wsResponse = 'OK';
                            Account newAcc = Societe_Mapper.getConsulterSocieteRequete(resp1);
                            newAcc.SynchronisationErrorType__c = '';
                            newAcc.SynchronisationStatutConsultation__c = Label.WS_Consultation_OK;
                            newAcc.SynchronisationDate__c = System.now(); // Returns the current Datetime based on a GMT calendar.
                            System.debug('newAcc ' + newAcc);
                            lstAcct.add(newAcc);
                            PAD.PAD_BypassTrigger += ';AP45_Account;';
                            upsert lstAcct DKCodeSurPartenaire__c;

                        } else if(resp1.informationsRetour.codeRetour == 'KO')   {
                            wsResponse = resp1.informationsRetour.messageRetour;
                            if(resp1.informationsRetour.messageRetour != null && resp1.informationsRetour.messageRetour.length() > 990) {
                                acc.SynchronisationErrorType__c = resp1.informationsRetour.messageRetour.substring(0, 990);
                            } else   {
                                acc.SynchronisationErrorType__c = resp1.informationsRetour.messageRetour;
                            }
                            acc.SynchronisationStatutConsultation__c = Label.WS_Consultation_KO;
                            acc.SynchronisationDate__c = System.now();// Returns the current Datetime based on a GMT calendar.
                            PAD.PAD_BypassTrigger += ';AP45_Account;';
                            update acc;
                        }

                    }

                }
                catch(Exception e) {
                    wsResponse = e.getMessage();
                    if(e.getMessage().length() > 990) {
                        acc.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                    } else   {
                        acc.SynchronisationErrorType__c = e.getMessage();
                    }
                    acc.SynchronisationDate__c = System.now();
                    PAD.PAD_BypassTrigger += ';AP45_Account;';
                    System.debug('Exception ' + e);
                    update acc;
                } finally {
                    WebserviceLog__c ws = new WebserviceLog__c();
                    ws.Type__c = wsType;
                    ws.flux__c = wsFlux;
                    ws.Response__c = wsResponse;
                    ws.Request__c = wsRequest;
                    insert ws;
                }
            }
            //avec siret, sans validation, particulier
            else {
                wsType = 'ConsulterPartenaire';
                wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse resp1 = new wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse();
                try {
                    wwwDalkiaFrReferentielPartenaire.consulterPartenaireRequete cons1 = Partenaire_Mapper.fillConsulterPartenaireRequete(acc);
                    System.debug('consulterPartenaireRequete ' + cons1);
                    resp1 = DalkiaManager.doCallOutConsulterPartenaire(cons1);
                    System.debug('consulterPartenaireReponse ' + resp1);

                    if(resp1.informationsRetour != null) {

                        if(resp1.informationsRetour.codeRetour == 'OK') {
                            wsResponse = 'OK';
                            Account newAcc = Partenaire_Mapper.getConsulterPartenaireRequete(resp1);
                            newAcc.SynchronisationErrorType__c = '';
                            newAcc.SynchronisationStatutConsultation__c = Label.WS_Consultation_OK;
                            newAcc.SynchronisationDate__c = System.now();
                            System.debug('newAcc ' + newAcc);
                            List<Account> lstAcct = new List<Account>();
                            lstAcct.add(newAcc);
                            PAD.PAD_BypassTrigger += ';AP45_Account;';
                            upsert lstAcct DKCodeSurPartenaire__c;
                        } else if(resp1.informationsRetour.codeRetour == 'KO')   {
                            wsResponse = resp1.informationsRetour.messageRetour;
                            System.debug('KO STATUS');
                            if(resp1.informationsRetour.messageRetour != null && resp1.informationsRetour.messageRetour.length() > 990) {
                                acc.SynchronisationErrorType__c = resp1.informationsRetour.messageRetour.substring(0, 990);
                            } else   {
                                acc.SynchronisationErrorType__c = resp1.informationsRetour.messageRetour;
                            }
                            acc.SynchronisationStatutConsultation__c = Label.WS_Consultation_KO;
                            acc.SynchronisationDate__c = System.now();// Returns the current Datetime based on a GMT calendar.
                            PAD.PAD_BypassTrigger += ';AP45_Account;';
                            update acc;

                        }
                    }

                }
                catch(Exception e) {
                    wsResponse = e.getMessage();
                    if(e.getMessage().length() > 990) {
                        acc.SynchronisationErrorType__c = e.getMessage().substring(0, 990);
                    } else   {
                        acc.SynchronisationErrorType__c = e.getMessage();
                    }
                    acc.SynchronisationDate__c = System.now();
                    PAD.PAD_BypassTrigger += ';AP45_Account;';
                    System.debug('Exception ' + e);
                    update acc;
                } finally {
                    WebserviceLog__c ws = new WebserviceLog__c();
                    ws.Type__c = wsType;
                    ws.flux__c = wsFlux;
                    ws.Response__c = wsResponse;
                    ws.Request__c = wsRequest;
                    insert ws;
                }

            }
        }
    }
}