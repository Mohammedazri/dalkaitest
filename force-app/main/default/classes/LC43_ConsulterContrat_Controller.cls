/**
*@author Alain Ghoussoub
*@date 21/02/2019
*@description Calls WS consulterContrat
*/
public without sharing class LC43_ConsulterContrat_Controller {

/*@author Alain Ghoussoub
*@date 21/02/2019
*@description Calls WS consulterContrat and adds details of response 
*@param String
*@return void
*/
    @AuraEnabled
    public static void consulterContrat(String contractId){
        Datetime dateDeclenchement = System.now();
        system.debug('contractId ' + contractId);
        Contrat__c cont = [Select id,DKCodeSurContrat__c from Contrat__c where id=:contractId]; 
        String wsType = 'ConsulterContrat';
        String wsResponse = '';
        String wsFlux = 'sortant';
        system.debug('cont ' + cont);
        if(cont!=null){
            String wsRequest= json.serialize(cont);
            try {
                wwwDalkiaFrReferentielContrat.consulterContratRequete cons = Contrat_Mapper.fillConsulterContratRequete(cont);
                System.debug('contCons ' + cons);
                wwwDalkiaFrReferentielContrat.consulterContratReponse resp = DalkiaManager.doCallOutConsulterContrat(cons);
                System.debug('contResp ' + resp);
                if(resp.informationsRetour != null){
                    system.debug('test1');
                    if(resp.informationsRetour.codeRetour == 'OK'){
                        wsResponse = 'OK';
                        system.debug('test2');
                        Contrat__c contResp = Contrat_Mapper.getConsulterContratRequete(resp); 
                        system.debug('test3');
                        System.debug('contratcree ' + contResp);
                        List<Contrat__c> lstCont = new List<Contrat__c>();
                        contResp.SynchronisationErrorType__c = resp.informationsRetour.messageREtour;
                        contResp.SynchronisationStatutConsultation__c = Label.WS_Consultation_OK;
                        contResp.SynchronisationDate__c = System.now();
                        contResp.DateDeclenchement__c = dateDeclenchement;
                        lstCont.add(contResp);
                        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
                        upsert lstCont DKCodeSurContrat__c;
                    } 
                    else if (resp.informationsRetour.codeRetour == 'KO'){
                        wsResponse = resp.informationsRetour.messageRetour;
                        system.debug('contratNoncree');
                        cont.SynchronisationErrorType__c = resp.informationsRetour.messageREtour;
                        cont.SynchronisationStatutConsultation__c = Label.WS_Consultation_KO;
                        cont.SynchronisationDate__c = System.now();
                        cont.DateDeclenchement__c = dateDeclenchement;
                        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
                        update cont;
                    }
                    
                    
                }
            }
            Catch ( Exception e){
                wsResponse = e.getMessage();
                cont.SynchronisationErrorType__c = e.getMessage();
                cont.SynchronisationDate__c = System.now();
                cont.DateDeclenchement__c = dateDeclenchement;
                PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
                System.debug('e.getMessage() ' + e);
                update cont;
            }
            finally{
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