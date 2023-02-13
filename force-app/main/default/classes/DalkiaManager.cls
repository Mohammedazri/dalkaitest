/**
*@author Alain Ghoussoub - Hussein Farran
*@date 21/02/2019
*@description List of functions thap call all the WS
*/
public class DalkiaManager {
    /* REFERENTIEL CONTRAT */
    
    public static String getDocumentToken(){
        //transform all to labels
        String client_id = Label.client_id_document;
        String client_secret = Label.client_secret_document;
        String endpoint = Label.endpoint_token_document;
        String grant_type = Label.grant_type_document;
        String scope = Label.scope_document;
        Blob authToEncode = Blob.valueOf(client_id + ':' + client_secret);
        String authInHeader = 'Basic ' + EncodingUtil.base64Encode(authToEncode);
        System.debug('authInHeader ' + authInHeader);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', authInHeader);
        request.setHeader('Content-Type', Label.Content_Type);
        String reqBody='grant_type=client_credentials&client_id='+client_id+'&scope='+scope;
        request.setBody(reqBody);
        System.debug('tokenRequest'+request);
        //return '';
        if(!Test.isRunningTest()){
            HttpResponse response = http.send(request);
            System.debug('response : ' + response.getBody());
            Token tok = new Token();
            tok = Token.parse(response.getBody());
            System.debug('Response.getToken : ' + tok);
            if(tok!=null && tok.access_token!=null){
                return tok.access_token;
            }
        }
        return '';
    }
    
    public static String getSocieteToken(){
        //transform all to labels
        String client_id = Label.client_id_societe;
        String client_secret = Label.client_secret_societe;
        String endpoint = Label.endpoint_token_societe;
        String grant_type = Label.grant_type_societe;
        String scope = Label.scope_societe;
        Blob authToEncode = Blob.valueOf(client_id + ':' + client_secret);
        String authInHeader = 'Basic ' + EncodingUtil.base64Encode(authToEncode);
        System.debug('authInHeader ' + authInHeader);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', authInHeader);
        request.setHeader('Content-Type', Label.Content_Type);
        String reqBody='grant_type=client_credentials&client_id='+client_id+'&scope='+scope;
        request.setBody(reqBody);
        System.debug('tokenRequest'+request);
        //return '';
        if(!Test.isRunningTest()){
            HttpResponse response = http.send(request);
            System.debug('response : ' + response.getBody());
            Token tok = new Token();
            tok = Token.parse(response.getBody());
            System.debug('Response.getToken : ' + tok);
            if(tok!=null && tok.access_token!=null){
                return tok.access_token;
            }
        }
        return '';
    }
    
    public static String getContratToken(){
        //transform all to labels
        String client_id = Label.client_id_contrat;
        String client_secret = Label.client_secret_contrat;
        String endpoint = Label.endpoint_token_contrat;
        String grant_type = Label.grant_type_contrat;
        String scope = Label.scope_contrat;
        Blob authToEncode = Blob.valueOf(client_id + ':' + client_secret);
        String authInHeader = 'Basic ' + EncodingUtil.base64Encode(authToEncode);
        System.debug('authInHeader ' + authInHeader);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', authInHeader);
        request.setHeader('Content-Type', Label.Content_Type);
        String reqBody='grant_type=client_credentials&client_id='+client_id+'&scope='+scope;
        request.setBody(reqBody);
        System.debug('tokenRequest'+request);
        //return '';
        if(!Test.isRunningTest()){
            HttpResponse response = http.send(request);
            System.debug('response : ' + response.getBody());
            Token tok = new Token();
            tok = Token.parse(response.getBody());
            System.debug('Response.getToken : ' + tok);
            if(tok!=null && tok.access_token!=null){
                return tok.access_token;
            }
        }
        return '';
    }
    
    public static String getPartenaireToken(){
        //transform all to labels
        String client_id = Label.client_id_part;
        String client_secret = Label.client_secret_part;
        String endpoint = Label.endpoint_token_part;
        String grant_type = Label.grant_type_part;
        String scope = Label.scope_part;
        Blob authToEncode = Blob.valueOf(client_id + ':' + client_secret);
        String authInHeader = 'Basic ' + EncodingUtil.base64Encode(authToEncode);
        System.debug('authInHeader ' + authInHeader);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', authInHeader);
        request.setHeader('Content-Type', Label.Content_Type);
        String reqBody='grant_type=client_credentials&client_id='+client_id+'&scope='+scope;
        request.setBody(reqBody);
        System.debug('tokenRequest'+request);
        //return '';
        if(!Test.isRunningTest()){
            HttpResponse response = http.send(request);
            System.debug('response : ' + response.getBody());
            Token tok = new Token();
            tok = Token.parse(response.getBody());
            System.debug('Response.getToken : ' + tok);
            if(tok!=null && tok.access_token!=null){
                return tok.access_token;
            }
        }
        return '';
    }
    
    public static wwwDalkiaFrReferentielContrat.ContratServicePort fillContratServicePort(){
        wwwDalkiaFrReferentielContrat.ContratServicePort retVal = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        String token = getContratToken();
        System.debug('contrat token in fill port is ' + token);
        retVal.endpoint_x = Label.endpoint_WS_contrat;
        //retVal.clientCertName_x = '2p77tk8ob7qr54qiaecrkjbite';
        //retVal.clientCert_x = 'clientCert';
        //retVal.clientCertPasswd_x = 'clientCertPasswd';
        retVal.timeout_x = 100000;
        retVal.inputHttpHeaders_x = new Map<String,String>();
        retVal.inputHttpHeaders_x.put('Authorization',token);
        retVal.inputHttpHeaders_x.put('x-api-key',Label.x_api_key_contrat);
        retVal.inputHttpHeaders_x.put('scope',Label.scope_contrat);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.creerContratReponse doCallOutCreerContrat(wwwDalkiaFrReferentielContrat.creerContratRequete creerContratObj){
        wwwDalkiaFrReferentielContrat.creerContratReponse retVal = new wwwDalkiaFrReferentielContrat.creerContratReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.CreerContrat(creerContratObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.renouvelerContratReponse doCallOutRenouvelerContrat(wwwDalkiaFrReferentielContrat.renouvelerContratRequete renouvelerContratObj){
        wwwDalkiaFrReferentielContrat.renouvelerContratReponse retVal = new wwwDalkiaFrReferentielContrat.renouvelerContratReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.RenouvelerContrat(renouvelerContratObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse doCallOutAjouterDocumentContractuel(wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsRequete ajouterDocumentContractuelObj){
        wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse retVal = new wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.AjouterDocumentsContractuels(ajouterDocumentContractuelObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.modifierContratReponse doCallOutModifierContrat(wwwDalkiaFrReferentielContrat.modifierContratRequete modifierContratObj){
        wwwDalkiaFrReferentielContrat.modifierContratReponse retVal = new wwwDalkiaFrReferentielContrat.modifierContratReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.ModifierContrat(modifierContratObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.consulterContratReponse doCallOutConsulterContrat(wwwDalkiaFrReferentielContrat.consulterContratRequete consulterContratObj){
        wwwDalkiaFrReferentielContrat.consulterContratReponse retVal = new wwwDalkiaFrReferentielContrat.consulterContratReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.ConsulterContrat(consulterContratObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.consulterDocumentReponse doCallOutConsulterDocument(wwwDalkiaFrReferentielContrat.consulterDocumentRequete consulterDocumentObj){
        wwwDalkiaFrReferentielContrat.consulterDocumentReponse retVal = new wwwDalkiaFrReferentielContrat.consulterDocumentReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.ConsulterDocument(consulterDocumentObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielContrat.modifierDocumentContractuelReponse doCallOutModifierDocumentContractuel(wwwDalkiaFrReferentielContrat.modifierDocumentContractuelRequete modifierDocumentContractuelObj){
        wwwDalkiaFrReferentielContrat.modifierDocumentContractuelReponse retVal = new wwwDalkiaFrReferentielContrat.modifierDocumentContractuelReponse();
        wwwDalkiaFrReferentielContrat.ContratServicePort contratServicePort = new wwwDalkiaFrReferentielContrat.ContratServicePort();
        contratServicePort = fillContratServicePort();
        retVal = contratServicePort.ModifierDocumentContractuel(modifierDocumentContractuelObj);
        return retVal;
    }
    
    /* REFERENTIEL SOCIETE */
    public static wwwDalkiaFrReferentielSociete.SocieteServicePort fillSocieteServicePort(){
        wwwDalkiaFrReferentielSociete.SocieteServicePort retVal = new wwwDalkiaFrReferentielSociete.SocieteServicePort();
        String token = getSocieteToken();
        System.debug('Societe token in fill port is ' + token);
        retVal.endpoint_x = Label.endpoint_WS_societe;
        //retVal.clientCertName_x = '2p77tk8ob7qr54qiaecrkjbite';
        //retVal.clientCert_x = 'clientCert';
        //retVal.clientCertPasswd_x = 'clientCertPasswd';
        retVal.timeout_x = 50000;
        retVal.inputHttpHeaders_x = new Map<String,String>();
        retVal.inputHttpHeaders_x.put('Authorization',token);
        retVal.inputHttpHeaders_x.put('x-api-key',Label.x_api_key_societe);
        retVal.inputHttpHeaders_x.put('scope',Label.scope_societe);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielSociete.consulterSocieteReponse doCallOutConsulterSociete(wwwDalkiaFrReferentielSociete.consulterSocieteRequete consulterSocieteRequeteObj){
        wwwDalkiaFrReferentielSociete.consulterSocieteReponse retVal = new wwwDalkiaFrReferentielSociete.consulterSocieteReponse();
        wwwDalkiaFrReferentielSociete.SocieteServicePort societeServicePort = new wwwDalkiaFrReferentielSociete.SocieteServicePort();
        societeServicePort = fillSocieteServicePort();
        retVal = societeServicePort.ConsulterSociete(consulterSocieteRequeteObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielSociete.modifierSocieteRestreintReponse doCallOutModifierSocieteRestreint(wwwDalkiaFrReferentielSociete.modifierSocieteRestreintRequete modifierSocieteRestreintRequeteObj){
        wwwDalkiaFrReferentielSociete.modifierSocieteRestreintReponse retVal = new wwwDalkiaFrReferentielSociete.modifierSocieteRestreintReponse();
        wwwDalkiaFrReferentielSociete.SocieteServicePort societeServicePort = new wwwDalkiaFrReferentielSociete.SocieteServicePort();
        societeServicePort = fillSocieteServicePort();
        retVal = societeServicePort.ModifierSocieteRestreint(modifierSocieteRestreintRequeteObj);
        return retVal;
    }
    
    /* REFERENTIEL PARTENAIRE */
    public static wwwDalkiaFrReferentielPartenaire.PartenaireServicePort fillPartenaireServicePort(){
        String token = getPartenaireToken();
        System.debug('partenaire token in fill port is ' + token);
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort retVal = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        retVal.endpoint_x = Label.endpoint_WS_part;
        //retVal.clientCertName_x = '2p77tk8ob7qr54qiaecrkjbite';
        //retVal.clientCert_x = 'clientCert';
        //retVal.clientCertPasswd_x = 'clientCertPasswd';
        retVal.timeout_x = 50000;
        retVal.inputHttpHeaders_x = new Map<String,String>();
        retVal.inputHttpHeaders_x.put('Authorization',token);
        retVal.inputHttpHeaders_x.put('x-api-key',Label.x_api_key_part);
        retVal.inputHttpHeaders_x.put('scope',Label.scope_part);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneReponse doCallOutCreerPartenaireIdExterne (wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete creerPartenaireIdExterneObj){
        wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneReponse retVal = new wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.CreerPartenaireIdExterne(creerPartenaireIdExterneObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintReponse doCallOutModifierPartenaireRestreint(wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintRequete modifierPartenaireRestreintObj){
        wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintReponse retVal = new wwwDalkiaFrReferentielPartenaire.modifierPartenaireRestreintReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.ModifierPartenaireRestreint(modifierPartenaireRestreintObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.rechercherPartenaireReponse doCallOutRechercherPartenaire(wwwDalkiaFrReferentielPartenaire.rechercherPartenaireRequete RechercherPartenaireObj){
        wwwDalkiaFrReferentielPartenaire.rechercherPartenaireReponse retVal = new wwwDalkiaFrReferentielPartenaire.rechercherPartenaireReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.RechercherPartenaire(RechercherPartenaireObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse doCallOutConsulterPartenaire (wwwDalkiaFrReferentielPartenaire.consulterPartenaireRequete ConsulterPartenaireObj){
        wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse retVal = new wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        //if(Test.isRunningTest()){
        //    retVal=LC41_MockHttpResponseGenerator.respond();
        //}
        //else{
            retVal = partenaireServicePort.ConsulterPartenaire(ConsulterPartenaireObj);
        //}
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse doCallOutCreerPartenaire (wwwDalkiaFrReferentielPartenaire.creerPartenaireRequete creerPartenaireObj){
        wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse retVal = new wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.CreerPartenaire(creerPartenaireObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.modifierPartenaireReponse doCallOutModifierPartenaire (wwwDalkiaFrReferentielPartenaire.modifierPartenaireRequete modifierPartenaireObj){
        wwwDalkiaFrReferentielPartenaire.modifierPartenaireReponse retVal = new wwwDalkiaFrReferentielPartenaire.modifierPartenaireReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.ModifierPartenaire(modifierPartenaireObj);
        return retVal;
    }
    
    
    public static wwwDalkiaFrReferentielPartenaire.consulterAdresseReponse doCallOutConsulterAdresse (wwwDalkiaFrReferentielPartenaire.consulterAdresseRequete consulterAdresseObj){
        wwwDalkiaFrReferentielPartenaire.consulterAdresseReponse retVal = new wwwDalkiaFrReferentielPartenaire.consulterAdresseReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.ConsulterAdresse(consulterAdresseObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.creerAdresseReponse doCallOutCreerAdresse (wwwDalkiaFrReferentielPartenaire.creerAdresseRequete creerAdresseObj){
        wwwDalkiaFrReferentielPartenaire.creerAdresseReponse retVal = new wwwDalkiaFrReferentielPartenaire.creerAdresseReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.CreerAdresse(creerAdresseObj);
        return retVal;
    }
    
    public static wwwDalkiaFrReferentielPartenaire.modifierAdresseReponse doCallOutModifierAdresse (wwwDalkiaFrReferentielPartenaire.modifierAdresseRequete modifierAdresseObj){
        wwwDalkiaFrReferentielPartenaire.modifierAdresseReponse retVal = new wwwDalkiaFrReferentielPartenaire.modifierAdresseReponse();
        wwwDalkiaFrReferentielPartenaire.PartenaireServicePort partenaireServicePort = new wwwDalkiaFrReferentielPartenaire.PartenaireServicePort();
        partenaireServicePort = fillPartenaireServicePort();
        retVal = partenaireServicePort.ModifierAdresse(modifierAdresseObj);
        return retVal;
    }
}