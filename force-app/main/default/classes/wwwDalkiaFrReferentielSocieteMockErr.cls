@isTest
public class wwwDalkiaFrReferentielSocieteMockErr implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'wwwDalkiaFrReferentielSocieteMockImpl.doInvoke() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf wwwDalkiaFrReferentielSociete.ConsulterSociete) {
                system.debug('ConsulterSociete');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielSociete.ConsulterSocieteResponse retValRes = new wwwDalkiaFrReferentielSociete.ConsulterSocieteResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielSociete.ConsulterSocieteReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielSociete.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielSociete.ModifierSocieteRestreint) {
                system.debug('ModifierSocieteRestreint');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielSociete.ModifierSocieteRestreintResponse retValRes = new wwwDalkiaFrReferentielSociete.ModifierSocieteRestreintResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielSociete.ModifierSocieteRestreintReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielSociete.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielSociete.RechercherSociete) {
                response.put( 'response_x', new wwwDalkiaFrReferentielSociete.RechercherSocieteResponse());
            }
        }
}