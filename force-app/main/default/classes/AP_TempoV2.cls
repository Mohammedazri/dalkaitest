public class AP_TempoV2 {
    
    public class ConsigneWrapper {
        public Boolean isError = false;
        public String strError = '';
        public Boolean presencePlanificateur;
        public Boolean isSIU;
        public String idSIA;
        public dateTime dateTraitementDiffere;
        public cls_consignes[] consignes;
    }
        
    public class cls_consignes {
        public String idSIA;
        public Integer numero;
        public String matricule;
        public String dkCodeRessource;
        public Integer typeRessource;
        public String denomination;
        public Boolean isRemplacant;
        public Integer delai;
        public String moyenContact;
        public String numeroAppel;
    }
    
    /**
     * @description Methode appellé pour créer un ConsigneWrapper contenant l'ensemble des consignes.
     * @param json
     * @return  ConsigneWrapper
     */

    public static ConsigneWrapper parse(String json) {
            return (ConsigneWrapper) System.JSON.deserialize(json, ConsigneWrapper.class);
    }

    /**
     * @description Methode appellé pour récupérer le token d'authentifiaction.
     * @param consigneWrapper
     * @return  String
     */

    @TestVisible
    private static String getToken(ConsigneWrapper consigneWrapper) {
        String theToken = '';
        webservicelog__c wsLog = new WebserviceLog__c();
        String endpoint = 'callout:WebSite';

        try {
            WebServiceToken__mdt webServiceToken = WebServiceToken__mdt.getInstance('consigne');
            String clientId = webServiceToken.ClientId__c;
            String clientSecret = webServiceToken.ClientSecret__c;
            String authorization = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret));
            String bodyRequest='grant_type=' + 'client_credentials' + '&client_id=' + clientId;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setTimeout(2 * 60 * 1000);
            request.setHeader('Authorization', authorization);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setBody(bodyRequest);
            HttpResponse response = http.send(request);
            
            System.debug('getToken.getStatusCode : '  + response.getStatusCode());
            System.debug('getToken.getBody : '  + response.getBody());
            
            if(response.getStatusCode() == 200) {
                Token tok = new Token();
                tok = Token.parse(response.getBody());
                return tok.access_token;
            } 
            else {
                consigneWrapper.isError = true;
                consigneWrapper.strError = response.getBody();
                wsLog.StatusCode__c = 'KO';
                wsLog.Response__c = response.getBody();
                wsLog.CodeRetour__c = '' + response.getStatusCode();
                wsLog.Type__c = 'recevoir les consignes';
                wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
                wsLog.Endpoint__c = endpoint;
                insert wsLog;
            }
        } 
        catch(exception e) { 
            consigneWrapper.isError = true;
            consigneWrapper.strError = e.getMessage();
            System.debug('exception getToken() ');
            System.debug(e.getMessage());
            wsLog.Response__c = e.getMessage();
            wsLog.StatusCode__c = 'KO';
            wsLog.Type__c = 'recevoir les consignes';
            wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
            wsLog.Endpoint__c = endpoint;
            insert wsLog;
        }
        return '';
    }
    
    /*
    test 
    */
    
    @TestVisible
    private static Case getDemande(Id recordId) {
        return [SELECT Id, PlanificateurPresent__c, OwnerId /*idsia__c*/ FROM Case WHERE Id = :recordId]; 
    }

    /**
     * @description Methode appellé pour récupérer les consignes.
     * @param access_token, dateDemande site, typeDemande
     * @return  ConsigneWrapper
     */

    @TestVisible
    private static ConsigneWrapper getConsigne(String access_token, Case demande, String dateDemande, String site, 
        String typeDemande) {
        ConsigneWrapper consigneWrapper;
        WebServiceCall__mdt consigne = WebServiceCall__mdt.getInstance('consigneCall');
        webservicelog__c wsLog = new WebserviceLog__c();


        String scope = consigne.Scope__c;
        String apiKey = consigne.APIKey__c;
        String suffixeUrl = consigne.suffixeURL__c;
        
        String endpoint = 'callout:WebSiteConsigneURL' + suffixeUrl + '?typeDemande=' 
            + typeDemande + '&dateDemande=' + dateDemande + '&site=' + site;
        String authorization = 'Bearer ' + access_token;
        wsLog.Request__c = endpoint;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        try {
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setTimeout(2 * 60 * 1000);
            request.setHeader('scope', scope);
            request.setHeader('x-api-key', apiKey);

            request.setHeader('Authorization', authorization);
            request.setHeader('Accept', 'application/json');
            
            HttpResponse response = http.send(request);
            
            System.debug('getConsigne.getStatusCode : '  + response.getStatusCode());
            System.debug('getConsigne.getBody : '  + response.getBody());
            
            if(response.getStatusCode() == 200) {
                demande.AppelTempoV2__c = true; 
                consigneWrapper = parse(response.getBody());
                consigneWrapper.isError = false;
                consigneWrapper.strError = '';
                System.debug('consigneWrapper.presencePlanificateur : '  + consigneWrapper.presencePlanificateur);
                demande.PlanificateurPresent__c = consigneWrapper.presencePlanificateur;
                if (demande.PlanificateurPresent__c == False) {
                demande.OwnerId = Label.FileCRC;
                }
                else {
                demande.OwnerId = Label.FileTemporaire;
                }
                //demande.idsia__c = consigneWrapper.idsia;
                update demande;
                

                wsLog.Response__c = response.getBody();
                wsLog.CodeRetour__c = '' + response.getStatusCode();
            }
            else {
                consigneWrapper = new ConsigneWrapper();
                consigneWrapper.isError = true;
                consigneWrapper.strError = response.getBody();
                wsLog.StatusCode__c = 'KO';
                wsLog.Response__c = response.getBody();
                wsLog.CodeRetour__c = '' + response.getStatusCode();
            }
        }
        catch(exception e) {
            consigneWrapper = new ConsigneWrapper();
            consigneWrapper.isError = True;
            consigneWrapper.strError = e.getMessage();
            System.debug('exception getConsigne() ');
            System.debug(e.getMessage());
            wsLog.Response__c = e.getMessage();
            wsLog.StatusCode__c = 'KO';
        }
        finally {
            wsLog.Type__c = 'recevoir les consignes';
            wsLog.flux__c = 'sortant'; // 'entrant' ou 'sortant'
            wsLog.Endpoint__c = endpoint;
            insert wsLog;
        }
        return consigneWrapper;
    }

    
    /**
    Test Hatem
    */
    
    @future(callout=true)
    //add comments about source
    public static void sendCase_trigger(Id idDemande, String dateDemande, String site, String typeDemande)
    {
      sendCase(idDemande, dateDemande, site, typeDemande);
     }
     
    
    /**
     * @description Methode pour appeller les fonctions afin de récupérer le token d'authentifiaction et les consignes.
     * @param dateDemande, site, typeDemande
     * @return  ConsigneWrapper
     */

    public static /*ConsigneWrapper*/ void sendCase(Id idDemande, String dateDemande, 
        String site, String typeDemande) {
        ConsigneWrapper consigneWrapper = new ConsigneWrapper();
        consigneWrapper.isError = false;
        String accessToken = getToken(consigneWrapper);
        Case demande = getDemande(idDemande);
        if (consigneWrapper.isError == false) {
            consigneWrapper = getConsigne(accessToken, demande, dateDemande, site, typeDemande);
        }
        //return consigneWrapper;
        }
}