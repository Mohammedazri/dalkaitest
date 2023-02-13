/**
*@author Hussein Farran
*@description 
*/
public class AP47_ModifierAdresse {
    public static Set<Id> accountIds = new Set<Id>();
    public static List<Account> accountList = new List<Account>();
    
    public static void handleList(List<Account> listAcc,String type){
        System.debug('handleList');
        System.debug('listAcc ' + listAcc);
        if(type.equals('update')){
            for(Account acc : listAcc){ 
                if(acc.IsPersonAccount == true && String.isNotBlank(acc.DKCodeSurPartenaire__c)){
                    accountList.add(acc);
                }
            }
        }
        
        String jsonString = Json.serialize(accountList);
        WebserviceLog__c ws = new WebserviceLog__c();
        ws.Type__c = 'ModifierAdresse';
        ws.flux__c = 'sortant';
        String jsonLog = Json.serialize(ws);
        modifierAdresse(jsonString,jsonLog); 
    }
    
    @Future(callout=true)
    public static void ModifierAdresse(String jsonList,String jsonLog){
        String wsResponse = '';
        String wsRequest = '';
        String wsCodeRetour = '';
        String wsFlux = '';
        String wsType = '';
        List<Account> accountList = new List<Account>();
        if(String.isNotBlank(jsonList)){
            accountList = (List<Account>)Json.deserialize(jsonList, List<Account>.class);
        }
        System.debug('ModifierAdresse');
        List<Account> lstAcct = new List<Account>();
        boolean appel = true;
        WebserviceLog__c ws = (WebserviceLog__c)Json.deserialize(jsonLog, WebserviceLog__c.class);
        if(accountList != null && accountList.size()>0){
            Account acc = accountList[0];
            try {
                System.debug('ACCOUNT DEBUG ---> '+ acc);
                wwwDalkiaFrReferentielPartenaire.modifierAdresseRequete request = Adresse_Mapper.fillModifierAdresseRequete(acc);
                System.debug('AP47 ModifierAdresse request ' + request);
                wwwDalkiaFrReferentielPartenaire.modifierAdresseReponse response = DalkiaManager.doCallOutModifierAdresse(request);
                System.debug('AP47 ModifierAdresse response ' + response);
                wsRequest  = json.serialize(acc);
                if(response.informationsRetour != null){
                    if (response.informationsRetour.codeRetour == 'OK'){
                        wsCodeRetour = 'OK';
                        wsResponse = 'OK';
                        lstAcct.add(acc);
                    }
                    else if (response.informationsRetour.codeRetour == 'KO'){
                        wsCodeRetour = 'KO';
                        wsResponse = response.informationsRetour.messageRetour;
                        lstAcct.add(acc);
                    }
                }
            }
            catch (Exception e){
                wsRequest  = json.serialize(acc);
                wsCodeRetour = 'ERROR';
                wsResponse = e.getMessage();
                System.debug('e.getMessage() ' + e);
                //update lstAcct; //nthng to update since the statusFields are used by ap45modifierPArtenaire
            }
            finally{
                ws.Type__c = 'ModifierAdresse';
                ws.flux__c = 'sortant';
                ws.Response__c = wsResponse;
                ws.Request__c = wsRequest;
                ws.ObjectId__c = acc.Id;
                ws.CodeRetour__c = wsCodeRetour;
                insert ws;
            }
        }
        if(lstAcct.size()>0){
            PAD.PAD_BypassTrigger+=';AP45_Account;';
            //update lstAcct; //nthng to update since the statusFields are used by ap45modifierPArtenaire
        }
    }
}