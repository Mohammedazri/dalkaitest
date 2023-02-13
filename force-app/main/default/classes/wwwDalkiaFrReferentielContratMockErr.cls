@isTest
public class wwwDalkiaFrReferentielContratMockErr implements WebServiceMock {
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            System.debug(LoggingLevel.INFO, 'wwwDalkiaFrReferentielContratMockImpl.doInvoke() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuels) {
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuelsResponse retValRes = new wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuelsResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.ajouterDocumentsContractuelsReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuels) {
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuelsResponse retValRes = new wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuelsResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.AjouterDocumentsContractuelsReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.ConsulterContrat) {
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielContrat.ConsulterContratResponse retValRes = new wwwDalkiaFrReferentielContrat.ConsulterContratResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.ConsulterContratReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.ConsulterDocument) {
                response.put( 'response_x', new wwwDalkiaFrReferentielContrat.ConsulterDocumentResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.CreerContrat) {
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielContrat.CreerContratResponse retValRes = new wwwDalkiaFrReferentielContrat.CreerContratResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.CreerContratReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.CreerModifierResumeContrat) {
                response.put( 'response_x', new wwwDalkiaFrReferentielContrat.CreerModifierResumeContratResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.ModifierContrat) {
                wwwDalkiaFrReferentielContrat.ModifierContratResponse retValRes = new wwwDalkiaFrReferentielContrat.ModifierContratResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.ModifierContratReponse();
                retValRes.reponse.informationsRetour =  new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.ModifierContratCID) {
                response.put( 'response_x', new wwwDalkiaFrReferentielContrat.ModifierContratCIDResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.ModifierDocumentContractuel) {
                wwwDalkiaFrReferentielContrat.ModifierDocumentContractuelResponse retValRes = new wwwDalkiaFrReferentielContrat.ModifierDocumentContractuelResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.ModifierDocumentContractuelReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.RechercherContrat) {
                response.put( 'response_x', new wwwDalkiaFrReferentielContrat.RechercherContratResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielContrat.RenouvelerContrat) {
                wwwDalkiaFrReferentielContrat.RenouvelerContratResponse retValRes = new wwwDalkiaFrReferentielContrat.RenouvelerContratResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielContrat.RenouvelerContratReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielContrat.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
        }
}