@isTest
public class wwwDalkiaFrReferentielPartenaireMockErr implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'wwwDalkiaFrReferentielPartenaireMockImpl.doInvoke() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf wwwDalkiaFrReferentielPartenaire.ConsulterAdresse) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.ConsulterAdresseResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ConsulterDemandeAdresse) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.ConsulterDemandeAdresseResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ConsulterDemandePartenaire) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.ConsulterDemandePartenaireResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ConsulterPartenaire) {
                system.debug('ConsulterPartenaire');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielPartenaire.consulterPartenaireResponse retValRes = new wwwDalkiaFrReferentielPartenaire.consulterPartenaireResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.consulterPartenaireReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielPartenaire.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.CreerAdresse) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.CreerAdresseResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.CreerPartenaire) {
                system.debug('CreerPartenaire');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielPartenaire.creerPartenaireResponse retValRes = new wwwDalkiaFrReferentielPartenaire.creerPartenaireResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.creerPartenaireReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielPartenaire.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.CreerPartenaireIdExterne) {
                system.debug('CreerPartenaireIdExterne');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielPartenaire.CreerPartenaireIdExterneResponse retValRes = new wwwDalkiaFrReferentielPartenaire.CreerPartenaireIdExterneResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.CreerPartenaireIdExterneReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielPartenaire.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.DemanderCreationAdresse) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.DemanderCreationAdresseResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.DemanderCreationPartenaire) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.DemanderCreationPartenaireResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.DemanderModificationAdresse) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.DemanderModificationAdresseResponse());
            } 
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.DemanderModificationPartenaire) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.DemanderModificationPartenaireResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ModifierAdresse) {
                system.debug('modifierAdresse');
                wwwDalkiaFrReferentielPartenaire.ConsulterAdresseResponse retValRes= new wwwDalkiaFrReferentielPartenaire.ConsulterAdresseResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.ConsulterAdresseReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielPartenaire.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.ModifierAdresseResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ModifierDemandeAdresse) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.ModifierDemandeAdresseResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ModifierDemandePartenaire) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.ModifierDemandePartenaireResponse());
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ModifierPartenaire) {
                system.debug('ModifierPartenaire');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielPartenaire.ModifierPartenaireResponse retValRes = new wwwDalkiaFrReferentielPartenaire.ModifierPartenaireResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.ModifierPartenaireReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielPartenaire.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.ModifierPartenaireRestreint) {
                system.debug('ModifierPartenaireRestreint');
                Date myDate = Date.newInstance(2019, 03, 20);
                Time myTime = Time.newInstance(9, 11, 44, 88);
                DateTime dt = DateTime.newInstance(myDate, myTime);
                wwwDalkiaFrReferentielPartenaire.ModifierPartenaireRestreintResponse retValRes = new wwwDalkiaFrReferentielPartenaire.ModifierPartenaireRestreintResponse();
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.ModifierPartenaireRestreintReponse();
                retValRes.reponse.informationsRetour = new wwwDalkiaFrReferentielPartenaire.informationsRetour();
                retValRes.reponse.informationsRetour.codeRetour = 'KO';
                retValRes.reponse.informationsRetour.messageRetour = 'Erreur';
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.RechercherPartenaire) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.RechercherPartenaireResponse());
            }
        }
}