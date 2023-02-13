@isTest
private class wwwDalkiaFrReferentielSocieteWebErrTest {
    
    @isTest static void coverGeneratedCodeTypes() {
        Test.setMock(WebServiceMock.class, new wwwDalkiaFrReferentielSocieteMockErr());
        wwwDalkiaFrReferentielSociete parentObject = new wwwDalkiaFrReferentielSociete();
        new wwwDalkiaFrReferentielSociete.activite();
        new wwwDalkiaFrReferentielSociete.activiteRS();
        new wwwDalkiaFrReferentielSociete.categorie();
        new wwwDalkiaFrReferentielSociete.categorieRS();
        new wwwDalkiaFrReferentielSociete.ConsulterSociete();
        new wwwDalkiaFrReferentielSociete.consulterSocieteReponse();
        new wwwDalkiaFrReferentielSociete.consulterSocieteRequete();
        new wwwDalkiaFrReferentielSociete.ConsulterSocieteResponse();
        new wwwDalkiaFrReferentielSociete.externe();
        new wwwDalkiaFrReferentielSociete.externeRS();
        new wwwDalkiaFrReferentielSociete.groupeDalkia();
        new wwwDalkiaFrReferentielSociete.groupeEDF();
        new wwwDalkiaFrReferentielSociete.informationsRetour();
        new wwwDalkiaFrReferentielSociete.listeGroupesDalkia();
        new wwwDalkiaFrReferentielSociete.listeGroupesEDF();
        new wwwDalkiaFrReferentielSociete.listeLogos();
        new wwwDalkiaFrReferentielSociete.listeLogosRS();
        new wwwDalkiaFrReferentielSociete.listeParents();
        new wwwDalkiaFrReferentielSociete.listeParentsRS();
        new wwwDalkiaFrReferentielSociete.listeReporting();
        new wwwDalkiaFrReferentielSociete.listeReportingRS();
        new wwwDalkiaFrReferentielSociete.listeSocietes();
        new wwwDalkiaFrReferentielSociete.logo();
        new wwwDalkiaFrReferentielSociete.logoRS();
        new wwwDalkiaFrReferentielSociete.metadonnees();
        new wwwDalkiaFrReferentielSociete.metadonneesRS();
        new wwwDalkiaFrReferentielSociete.ModifierSocieteRestreint();
        new wwwDalkiaFrReferentielSociete.modifierSocieteRestreintReponse();
        new wwwDalkiaFrReferentielSociete.modifierSocieteRestreintRequete();
        new wwwDalkiaFrReferentielSociete.ModifierSocieteRestreintResponse();
        new wwwDalkiaFrReferentielSociete.parent();
        new wwwDalkiaFrReferentielSociete.parentRS();
        new wwwDalkiaFrReferentielSociete.proprietesSociete();
        new wwwDalkiaFrReferentielSociete.proprietesSocieteRS();
        new wwwDalkiaFrReferentielSociete.RechercherSociete();
        new wwwDalkiaFrReferentielSociete.rechercherSocieteReponse();
        new wwwDalkiaFrReferentielSociete.rechercherSocieteRequete();
        new wwwDalkiaFrReferentielSociete.RechercherSocieteResponse();
        new wwwDalkiaFrReferentielSociete.reporting();
        new wwwDalkiaFrReferentielSociete.reportingRS();
        new wwwDalkiaFrReferentielSociete.societe();
        new wwwDalkiaFrReferentielSociete.societeRecherche();
        new wwwDalkiaFrReferentielSociete.societeRS();
    }
    @isTest static void coverCodeForConsulterSociete(){
        Test.setMock(WebServiceMock.class, new wwwDalkiaFrReferentielSocieteMockErr());
        wwwDalkiaFrReferentielSociete.SocieteServicePort testObject = new wwwDalkiaFrReferentielSociete.SocieteServicePort();
        String RecTypeId= [select Id from RecordType where (DeveloperName='societe_account') and (SobjectType='Account')].Id;
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity ='test';
        acc.DKCodeSurPartenaire__c = 'K00000089B';
        acc.BillingPostalCode = '1234';
        acc.Immatriculation_Legale__c = 'test'; 
        acc.EntiteCommercialeDalkia__c = 'J00001002N';
        ACC.Lieu_immatriculation_legale__c = 'TEST';
        acc.LibelleEtablissement__c = 'test';
        acc.RecordTypeId = RecTypeId;
        acc.Utilisation_filiere_Commerce__c = 'Actif';
        acc.CodeRecouvrement__c = 'DCWAC02';
        acc.Depart_Exigibilite__c = '2';
        acc.DelaiPaiementJour__c = 2;
        acc.Methode_Interet_Retard__c = '123';
        acc.JourMoisSuivant__c = 3;
        insert acc;
        test.startTest();
        LC41_EditAccount_Controller.synchronizeAccount(acc.id);
        test.stopTest();
        //System.assertEquals(null, testObject.ConsulterSociete(null));
    }
    @isTest static void coverCodeForModifierSocieteRestreint(){
        Test.setMock(WebServiceMock.class, new wwwDalkiaFrReferentielSocieteMockErr());
        wwwDalkiaFrReferentielSociete.SocieteServicePort testObject = new wwwDalkiaFrReferentielSociete.SocieteServicePort();
        String RecTypeId= [select Id from RecordType where (DeveloperName='societe_account') and (SobjectType='Account')].Id;
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity ='test';
        acc.DKCodeSurPartenaire__c = 'K00000089B';
        acc.BillingPostalCode = '1234';
        acc.Immatriculation_Legale__c = 'test'; 
        acc.EntiteCommercialeDalkia__c = 'J00001002N';
        ACC.Lieu_immatriculation_legale__c = 'TEST';
        acc.LibelleEtablissement__c = 'test';
        acc.RecordTypeId = RecTypeId;
        acc.Code_NACE__c = '123';
        acc.Utilisation_filiere_Commerce__c = 'Actif';
        acc.CodeRecouvrement__c = 'DCWAC02';
        acc.Depart_Exigibilite__c = '2';
        acc.DelaiPaiementJour__c = 2;
        acc.Montant_capital_Social__c = 123;
        acc.Methode_Interet_Retard__c = '123';
        acc.JourMoisSuivant__c = 3;
        insert acc;
        List<Account> listAcc = new List<Account>();
        listAcc.add(acc);
        test.startTest();
        AP45_AccountCallouts.handleList(listAcc,'update');
        test.stopTest();
        //System.assertEquals(null, testObject.ModifierSocieteRestreint(null));
    }
    @isTest static void coverCodeForRechercherSociete(){
        Test.setMock(WebServiceMock.class, new wwwDalkiaFrReferentielSocieteMockErr());
        wwwDalkiaFrReferentielSociete.SocieteServicePort testObject = new wwwDalkiaFrReferentielSociete.SocieteServicePort();
        System.assertEquals(null, testObject.RechercherSociete(null));
    }
}