@isTest
public class wwwDalkiaFrReferentielPartenaireMockImpl implements WebServiceMock {
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
                retValRes.reponse.informationsRetour.codeRetour = 'OK';
                retValRes.reponse.partenaire = new wwwDalkiaFrReferentielPartenaire.partenaire();
                retValRes.reponse.partenaire.proprietesPartenaire =  new wwwDalkiaFrReferentielPartenaire.proprietesPartenaire();
                retValRes.reponse.partenaire.proprietesPartenaire.DKCodePartenaire = 'K00000089B';
                retValRes.reponse.partenaire.proprietesPartenaire.statutPartenaire = 'OUV';
                retValRes.reponse.partenaire.proprietesPartenaire.commentaire = 'Test pour C360';
                retValRes.reponse.partenaire.proprietesPartenaire.naturePartenaire = 'PART';
                retValRes.reponse.partenaire.proprietesPartenaire.dateDerniereMajSiren = dt;
                retValRes.reponse.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulier();
                retValRes.reponse.partenaire.particulier.dateDeNaissance = dt;
                retValRes.reponse.partenaire.particulier.nomUsage = 'test';
                retValRes.reponse.partenaire.etablissement = new wwwDalkiaFrReferentielPartenaire.etablissement();
                retValRes.reponse.partenaire.Etablissement.effectifSalarie = '02';
                retValRes.reponse.partenaire.Etablissement.siegeSocialPartenaire = true;
                retValRes.reponse.partenaire.Etablissement.dateDebut = dt;
                retValRes.reponse.partenaire.Etablissement.dateFin = dt; 
                retValRes.reponse.partenaire.Etablissement.codeActiviteInternational = '123';
                retValRes.reponse.partenaire.Etablissement.societe = new wwwDalkiaFrReferentielPartenaire.societe(); 
                retValRes.reponse.partenaire.Etablissement.societe.DKCodeSociete ='123';
                retValRes.reponse.partenaire.Client = new wwwDalkiaFrReferentielPartenaire.client();
                retValRes.reponse.partenaire.client.utilisationFiliereCommerce=true;
                retValRes.reponse.partenaire.Client.societeMandataire=true;
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefaut();
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut.reportFinMois=true;
                retValRes.reponse.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrements();
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrement>();
                wwwDalkiaFrReferentielPartenaire.recouvrement rec = new wwwDalkiaFrReferentielPartenaire.recouvrement();
                rec.codeRecouvrement = 'DCWAC01';
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
                retValRes.reponse.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseur();
                retValRes.reponse.partenaire.fournisseur.utilisationFiliereAchats = true;
                retValRes.reponse.partenaire.fournisseur.societeAffacturage = true;
                retValRes.reponse.partenaire.fournisseur.listeClassification =  new wwwDalkiaFrReferentielPartenaire.listeClassification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification = new List<wwwDalkiaFrReferentielPartenaire.classification>();
                wwwDalkiaFrReferentielPartenaire.classification classification = new wwwDalkiaFrReferentielPartenaire.classification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification.add(classification);
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classification>();
                retValRes.reponse.partenaire.listeAdresses = new wwwDalkiaFrReferentielPartenaire.listeAdresses();
                retValRes.reponse.partenaire.listeAdresses.adresse = new List<wwwDalkiaFrReferentielPartenaire.adresse>();
                wwwDalkiaFrReferentielPartenaire.adresse add = new wwwDalkiaFrReferentielPartenaire.adresse();
                add.adressePrincipale = true;
                add.numeroVoie = 'test';
                add.typeDeVoie = 'test';
                add.libelleVoie = 'test';
                add.DKCodeAdresse = 'test';
                add.dematerialise = true;
                add.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonnees();
                retValRes.reponse.partenaire.listeAdresses.adresse.add(add);
                retValRes.reponse.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsables();
                retValRes.reponse.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsable>();
                wwwDalkiaFrReferentielPartenaire.responsable resp = new wwwDalkiaFrReferentielPartenaire.responsable();
                resp.statutLienResponsable = true;
                retValRes.reponse.partenaire.listeResponsables.responsable.add(resp);
                retValRes.reponse.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonnees();
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
                retValRes.reponse.informationsRetour.codeRetour = 'OK';
                retValRes.reponse.partenaire = new wwwDalkiaFrReferentielPartenaire.partenaire();
                retValRes.reponse.partenaire.proprietesPartenaire =  new wwwDalkiaFrReferentielPartenaire.proprietesPartenaire();
                retValRes.reponse.partenaire.proprietesPartenaire.DKCodePartenaire = 'K00000089B';
                retValRes.reponse.partenaire.proprietesPartenaire.statutPartenaire = 'OUV';
                retValRes.reponse.partenaire.proprietesPartenaire.commentaire = 'Test pour C360';
                retValRes.reponse.partenaire.proprietesPartenaire.naturePartenaire = 'PART';
                retValRes.reponse.partenaire.proprietesPartenaire.dateDerniereMajSiren = dt;
                retValRes.reponse.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulier();
                retValRes.reponse.partenaire.particulier.dateDeNaissance = dt;
                retValRes.reponse.partenaire.particulier.nomUsage = 'test';
                retValRes.reponse.partenaire.etablissement = new wwwDalkiaFrReferentielPartenaire.etablissement();
                retValRes.reponse.partenaire.Etablissement.effectifSalarie = '02';
                retValRes.reponse.partenaire.Etablissement.siegeSocialPartenaire = true;
                retValRes.reponse.partenaire.Etablissement.dateDebut = dt;
                retValRes.reponse.partenaire.Etablissement.dateFin = dt;
                retValRes.reponse.partenaire.Etablissement.codeActiviteInternational = '123';
                retValRes.reponse.partenaire.Etablissement.societe = new wwwDalkiaFrReferentielPartenaire.societe(); 
                retValRes.reponse.partenaire.Etablissement.societe.DKCodeSociete ='123';
                retValRes.reponse.partenaire.Client = new wwwDalkiaFrReferentielPartenaire.client();
                retValRes.reponse.partenaire.client.utilisationFiliereCommerce=true;
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefaut();
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut.reportFinMois=true;
                retValRes.reponse.partenaire.Client.societeMandataire=true;
                retValRes.reponse.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrements();
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrement>();
                wwwDalkiaFrReferentielPartenaire.recouvrement rec = new wwwDalkiaFrReferentielPartenaire.recouvrement();
                rec.codeRecouvrement = 'DCWAC01';
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
                retValRes.reponse.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseur();
                retValRes.reponse.partenaire.fournisseur.utilisationFiliereAchats = true;
                retValRes.reponse.partenaire.fournisseur.societeAffacturage = true;
                retValRes.reponse.partenaire.fournisseur.listeClassification =  new wwwDalkiaFrReferentielPartenaire.listeClassification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification = new List<wwwDalkiaFrReferentielPartenaire.classification>();
                wwwDalkiaFrReferentielPartenaire.classification classification = new wwwDalkiaFrReferentielPartenaire.classification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification.add(classification);
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classification>();
                retValRes.reponse.partenaire.listeAdresses = new wwwDalkiaFrReferentielPartenaire.listeAdresses();
                retValRes.reponse.partenaire.listeAdresses.adresse = new List<wwwDalkiaFrReferentielPartenaire.adresse>();
                wwwDalkiaFrReferentielPartenaire.adresse add = new wwwDalkiaFrReferentielPartenaire.adresse();
                add.adressePrincipale = true;
                add.numeroVoie = 'test';
                add.typeDeVoie = 'test';
                add.libelleVoie = 'test';
                add.DKCodeAdresse = 'test';
                add.dematerialise = true;
                add.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonnees();
                retValRes.reponse.partenaire.listeAdresses.adresse.add(add);
                retValRes.reponse.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsables();
                retValRes.reponse.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsable>();
                wwwDalkiaFrReferentielPartenaire.responsable resp = new wwwDalkiaFrReferentielPartenaire.responsable();
                resp.statutLienResponsable = true;
                retValRes.reponse.partenaire.listeResponsables.responsable.add(resp);
                retValRes.reponse.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonnees();
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
                retValRes.reponse.informationsRetour.codeRetour = 'OK';
                retValRes.reponse.partenaire = new wwwDalkiaFrReferentielPartenaire.partenaire();
                retValRes.reponse.partenaire.proprietesPartenaire =  new wwwDalkiaFrReferentielPartenaire.proprietesPartenaire();
                retValRes.reponse.partenaire.proprietesPartenaire.DKCodePartenaire = 'K00000089B';
                retValRes.reponse.partenaire.proprietesPartenaire.statutPartenaire = 'OUV';
                retValRes.reponse.partenaire.proprietesPartenaire.commentaire = 'Test pour C360';
                retValRes.reponse.partenaire.proprietesPartenaire.naturePartenaire = 'PART';
                retValRes.reponse.partenaire.proprietesPartenaire.dateDerniereMajSiren = dt;
                retValRes.reponse.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulier();
                retValRes.reponse.partenaire.particulier.dateDeNaissance = dt;
                retValRes.reponse.partenaire.particulier.nomUsage = 'test';
                retValRes.reponse.partenaire.etablissement = new wwwDalkiaFrReferentielPartenaire.etablissement();
                retValRes.reponse.partenaire.Etablissement.effectifSalarie = '02';
                retValRes.reponse.partenaire.Etablissement.siegeSocialPartenaire = true;
                retValRes.reponse.partenaire.Etablissement.dateDebut = dt;
                retValRes.reponse.partenaire.Etablissement.dateFin = dt; 
                retValRes.reponse.partenaire.Etablissement.codeActiviteInternational = '123';
                retValRes.reponse.partenaire.Etablissement.societe = new wwwDalkiaFrReferentielPartenaire.societe(); 
                retValRes.reponse.partenaire.Etablissement.societe.DKCodeSociete ='123';
                retValRes.reponse.partenaire.Client = new wwwDalkiaFrReferentielPartenaire.client();
                retValRes.reponse.partenaire.client.utilisationFiliereCommerce=true;
                retValRes.reponse.partenaire.Client.societeMandataire=true;
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefaut();
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut.reportFinMois=true;
                retValRes.reponse.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrements();
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrement>();
                wwwDalkiaFrReferentielPartenaire.recouvrement rec = new wwwDalkiaFrReferentielPartenaire.recouvrement();
                rec.codeRecouvrement = 'DCWAC01';
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
                retValRes.reponse.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseur();
                retValRes.reponse.partenaire.fournisseur.utilisationFiliereAchats = true;
                retValRes.reponse.partenaire.fournisseur.societeAffacturage = true;
                retValRes.reponse.partenaire.fournisseur.listeClassification =  new wwwDalkiaFrReferentielPartenaire.listeClassification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification = new List<wwwDalkiaFrReferentielPartenaire.classification>();
                wwwDalkiaFrReferentielPartenaire.classification classification = new wwwDalkiaFrReferentielPartenaire.classification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification.add(classification);
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classification>();
                retValRes.reponse.partenaire.listeAdresses = new wwwDalkiaFrReferentielPartenaire.listeAdresses();
                retValRes.reponse.partenaire.listeAdresses.adresse = new List<wwwDalkiaFrReferentielPartenaire.adresse>();
                wwwDalkiaFrReferentielPartenaire.adresse add = new wwwDalkiaFrReferentielPartenaire.adresse();
                add.adressePrincipale = true;
                add.numeroVoie = 'test';
                add.typeDeVoie = 'test';
                add.libelleVoie = 'test';
                add.DKCodeAdresse = 'test';
                add.dematerialise = true;
                add.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonnees();
                retValRes.reponse.partenaire.listeAdresses.adresse.add(add);
                retValRes.reponse.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsables();
                retValRes.reponse.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsable>();
                wwwDalkiaFrReferentielPartenaire.responsable resp = new wwwDalkiaFrReferentielPartenaire.responsable();
                resp.statutLienResponsable = true;
                retValRes.reponse.partenaire.listeResponsables.responsable.add(resp);
                retValRes.reponse.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonnees();
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
                retValRes.reponse.informationsRetour.codeRetour = 'OK';
                retValRes.reponse.adresse = new wwwDalkiaFrReferentielPartenaire.adressePartenaire();
                
                retValRes.reponse.adresse.listeAdresses = new wwwDalkiaFrReferentielPartenaire.listeAdresses();
                retValRes.reponse.adresse.listeAdresses.adresse = new List<wwwDalkiaFrReferentielPartenaire.adresse>();
                wwwDalkiaFrReferentielPartenaire.adresse add = new wwwDalkiaFrReferentielPartenaire.adresse();
                add.DKCodeAdresse = '12345';
                add.adressePrincipale = true;
                add.numeroVoie = 'test';
                add.typeDeVoie = 'test';
                add.libelleVoie = 'test';
                add.DKCodeAdresse = 'test';
                add.dematerialise = true;
                add.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonnees();
                retValRes.reponse.adresse.listeAdresses.adresse.add(add);
                
                retValRes.reponse = new wwwDalkiaFrReferentielPartenaire.ConsulterAdresseReponse();
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
                retValRes.reponse.informationsRetour.codeRetour = 'OK';
                retValRes.reponse.partenaire = new wwwDalkiaFrReferentielPartenaire.partenaire();
                retValRes.reponse.partenaire.proprietesPartenaire =  new wwwDalkiaFrReferentielPartenaire.proprietesPartenaire();
                retValRes.reponse.partenaire.proprietesPartenaire.DKCodePartenaire = 'K00000089B';
                retValRes.reponse.partenaire.proprietesPartenaire.statutPartenaire = 'OUV';
                retValRes.reponse.partenaire.proprietesPartenaire.commentaire = 'Test pour C360';
                retValRes.reponse.partenaire.proprietesPartenaire.naturePartenaire = 'PART';
                retValRes.reponse.partenaire.proprietesPartenaire.dateDerniereMajSiren = dt;
                retValRes.reponse.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulier();
                retValRes.reponse.partenaire.particulier.dateDeNaissance = dt;
                retValRes.reponse.partenaire.particulier.nomUsage = 'test';
                retValRes.reponse.partenaire.etablissement = new wwwDalkiaFrReferentielPartenaire.etablissement();
                retValRes.reponse.partenaire.Etablissement.effectifSalarie = '02';
                retValRes.reponse.partenaire.Etablissement.dateDebut = dt;
                retValRes.reponse.partenaire.Etablissement.siegeSocialPartenaire = true;
                retValRes.reponse.partenaire.Etablissement.dateFin = dt; 
                retValRes.reponse.partenaire.Etablissement.codeActiviteInternational = '123';
                retValRes.reponse.partenaire.Etablissement.societe = new wwwDalkiaFrReferentielPartenaire.societe(); 
                retValRes.reponse.partenaire.Etablissement.societe.DKCodeSociete ='123';
                retValRes.reponse.partenaire.Client = new wwwDalkiaFrReferentielPartenaire.client();
                retValRes.reponse.partenaire.client.utilisationFiliereCommerce=true;
                retValRes.reponse.partenaire.Client.societeMandataire=true;
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefaut();
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut.reportFinMois=true;
                retValRes.reponse.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrements();
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrement>();
                wwwDalkiaFrReferentielPartenaire.recouvrement rec = new wwwDalkiaFrReferentielPartenaire.recouvrement();
                rec.codeRecouvrement = 'DCWAC01';
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
                retValRes.reponse.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseur();
                retValRes.reponse.partenaire.fournisseur.utilisationFiliereAchats = true;
                retValRes.reponse.partenaire.fournisseur.societeAffacturage = true;
                retValRes.reponse.partenaire.fournisseur.listeClassification =  new wwwDalkiaFrReferentielPartenaire.listeClassification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification = new List<wwwDalkiaFrReferentielPartenaire.classification>();
                wwwDalkiaFrReferentielPartenaire.classification classification = new wwwDalkiaFrReferentielPartenaire.classification();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification.add(classification);
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classification>();
                retValRes.reponse.partenaire.listeAdresses = new wwwDalkiaFrReferentielPartenaire.listeAdresses();
                retValRes.reponse.partenaire.listeAdresses.adresse = new List<wwwDalkiaFrReferentielPartenaire.adresse>();
                wwwDalkiaFrReferentielPartenaire.adresse add = new wwwDalkiaFrReferentielPartenaire.adresse();
                add.adressePrincipale = true;
                add.numeroVoie = 'test';
                add.typeDeVoie = 'test';
                add.libelleVoie = 'test';
                add.DKCodeAdresse = 'test';
                add.dematerialise = true;
                add.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonnees();
                retValRes.reponse.partenaire.listeAdresses.adresse.add(add);
                retValRes.reponse.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsables();
                retValRes.reponse.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsable>();
                wwwDalkiaFrReferentielPartenaire.responsable resp = new wwwDalkiaFrReferentielPartenaire.responsable();
                resp.statutLienResponsable = true;
                retValRes.reponse.partenaire.listeResponsables.responsable.add(resp);
                retValRes.reponse.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonnees();
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
                retValRes.reponse.informationsRetour.codeRetour = 'OK';
                retValRes.reponse.partenaire = new wwwDalkiaFrReferentielPartenaire.partenaireP1();
                retValRes.reponse.partenaire.proprietesPartenaire =  new wwwDalkiaFrReferentielPartenaire.proprietesPartenaireP1();
                retValRes.reponse.partenaire.proprietesPartenaire.DKCodePartenaire = 'K00000089B';
                //retValRes.reponse.partenaire.proprietesPartenaire.statutPartenaire = 'OUV';
                retValRes.reponse.partenaire.proprietesPartenaire.commentaire = 'Test pour C360';
                //retValRes.reponse.partenaire.proprietesPartenaire.naturePartenaire = 'PART';
                //retValRes.reponse.partenaire.proprietesPartenaire.dateDerniereMajSiren = dt;
                retValRes.reponse.partenaire.particulier = new wwwDalkiaFrReferentielPartenaire.particulierP1();
                retValRes.reponse.partenaire.particulier.dateDeNaissance = dt;
                retValRes.reponse.partenaire.particulier.nomUsage = 'test';
                retValRes.reponse.partenaire.etablissement = new wwwDalkiaFrReferentielPartenaire.etablissementP1();
                retValRes.reponse.partenaire.Etablissement.effectifSalarie = '02';
                retValRes.reponse.partenaire.Etablissement.siegeSocialPartenaire = true;
                retValRes.reponse.partenaire.Etablissement.dateDebut = dt;
                retValRes.reponse.partenaire.Etablissement.dateFin = dt; 
                retValRes.reponse.partenaire.Etablissement.codeActiviteInternational = '123';
                //retValRes.reponse.partenaire.Etablissement.societe = new wwwDalkiaFrReferentielPartenaire.societeP1(); 
                //retValRes.reponse.partenaire.Etablissement.societe.DKCodeSociete ='123';
                retValRes.reponse.partenaire.Client = new wwwDalkiaFrReferentielPartenaire.clientP1();
                retValRes.reponse.partenaire.client.utilisationFiliereCommerce=true;
                retValRes.reponse.partenaire.Client.societeMandataire=true;
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautP1();
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut.reportFinMois=true;
                retValRes.reponse.partenaire.Client.listeRecouvrements = new wwwDalkiaFrReferentielPartenaire.listeRecouvrementsP1();
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement = new List<wwwDalkiaFrReferentielPartenaire.recouvrementP1>();
                wwwDalkiaFrReferentielPartenaire.recouvrementP1 rec = new wwwDalkiaFrReferentielPartenaire.recouvrementP1();
                rec.codeRecouvrement = 'DCWAC01';
                retValRes.reponse.partenaire.Client.listeRecouvrements.recouvrement.add(rec);
                retValRes.reponse.partenaire.client.conditionsPaiementDefaut = new wwwDalkiaFrReferentielPartenaire.conditionsPaiementDefautP1();
                retValRes.reponse.partenaire.fournisseur = new wwwDalkiaFrReferentielPartenaire.fournisseurP1();
                retValRes.reponse.partenaire.fournisseur.utilisationFiliereAchats = true;
                retValRes.reponse.partenaire.fournisseur.societeAffacturage = true;
                retValRes.reponse.partenaire.fournisseur.listeClassification =  new wwwDalkiaFrReferentielPartenaire.listeClassificationP1();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification = new List<wwwDalkiaFrReferentielPartenaire.classificationP1>();
                wwwDalkiaFrReferentielPartenaire.classificationP1 classification = new wwwDalkiaFrReferentielPartenaire.classificationP1();
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification.add(classification);
                retValRes.reponse.partenaire.fournisseur.listeClassification.classification =  new List<wwwDalkiaFrReferentielPartenaire.classificationP1>();
                //retValRes.reponse.partenaire.listeAdresses = new wwwDalkiaFrReferentielPartenaire.listeAdresses();
                //retValRes.reponse.partenaire.listeAdresses.adresse = new List<wwwDalkiaFrReferentielPartenaire.adresse>();
                //wwwDalkiaFrReferentielPartenaire.adresse add = new wwwDalkiaFrReferentielPartenaire.adresse();
                //add.adressePrincipale = true;
                //add.numeroVoie = 'test';
                //add.typeDeVoie = 'test';
                //add.libelleVoie = 'test';
                //add.DKCodeAdresse = 'test';
                //add.dematerialise = true;
                //add.metadonneesAdressePartenaire = new wwwDalkiaFrReferentielPartenaire.metadonnees();
                //retValRes.reponse.partenaire.listeAdresses.adresse.add(add);
                retValRes.reponse.partenaire.listeResponsables = new wwwDalkiaFrReferentielPartenaire.listeResponsablesP1();
                retValRes.reponse.partenaire.listeResponsables.responsable =  new List<wwwDalkiaFrReferentielPartenaire.responsableP1>();
                wwwDalkiaFrReferentielPartenaire.responsableP1 resp = new wwwDalkiaFrReferentielPartenaire.responsableP1();
                resp.statutLienResponsable = true;
                retValRes.reponse.partenaire.listeResponsables.responsable.add(resp);
                retValRes.reponse.partenaire.metadonnees = new wwwDalkiaFrReferentielPartenaire.metadonneesP1();
                response.put( 'response_x', retValRes);
            }
            else if(request instanceOf wwwDalkiaFrReferentielPartenaire.RechercherPartenaire) {
                response.put( 'response_x', new wwwDalkiaFrReferentielPartenaire.RechercherPartenaireResponse());
            }
        }
}