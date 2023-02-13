@isTest
public class WS02_Partenaire_Test {
    @isTest
    public static void insertUpdatePartenaireTest(){
        User user = testUtilsC360.CreateUser('testU', 'testU@testorg.com', 'testU', Label.AdminProfileId, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        insert user;

        //part1
        WS02_Partenaire.Partenaire part1 = new WS02_Partenaire.Partenaire();

        WS02_Partenaire.ProprietesPartenaire propPart = new WS02_Partenaire.ProprietesPartenaire();
        propPart.DKCodePartenaire = 'KO12345';
        propPart.statutPartenaire = 'OUV';
        propPart.commentaire = 'test';
        propPart.naturePartenaire = 'PART';
        propPart.dateDerniereMajSiren = System.today();
        part1.proprietesPartenaire = propPart;

        WS02_Partenaire.Particulier part = new WS02_Partenaire.Particulier();
        part.civilite = 'M';
        part.nomUsage = 'Doe';
        part.prenomUsage = 'John';
        part.dateDeNaissance = System.today();
        part.lieuDeNaissance = 'Paris';
        part.paysDeNaissance = 'FR';
        part.statutParticulier = 'test';
        part1.particulier = part;

        WS02_Partenaire.Client client = new WS02_Partenaire.Client();
        client.utilisationFiliereCommerce = 'test';
        client.segmentClient = 'test';
        client.sousSegmentClient = 'test';
        client.entiteCommercialeDalkia = 'test';
        client.entiteCommercialeEdf = 'test';
        client.societeMandataire = true;
        WS02_Partenaire.Recouvrement rec = new WS02_Partenaire.Recouvrement();
        rec.codeRecouvrement = '123';
        WS02_Partenaire.ListeRecouvrements listRec = new WS02_Partenaire.ListeRecouvrements();
        listRec.recouvrement = new List<WS02_Partenaire.Recouvrement> {rec};
        client.listeRecouvrements = listRec;
        WS02_Partenaire.ConditionsPaiementDefaut cond = new WS02_Partenaire.ConditionsPaiementDefaut();
        cond.departExigibilite = 'test';
        cond.delaiPaiementJours = '1';
        cond.reportFinMois = true;
        cond.jourMoisSuivant = '2';
        cond.methodeInteretsRetard = 'test';
        cond.modeReglement = 'test';
        client.conditionsPaiementDefaut = cond;
        part1.client = client;

        WS02_Partenaire.Fournisseur four = new WS02_Partenaire.Fournisseur();
        four.utilisationFiliereAchats = true;
        four.societeAffacturage = true;
        WS02_Partenaire.ListeClassification listClass = new WS02_Partenaire.ListeClassification();
        WS02_Partenaire.Classification classif = new WS02_Partenaire.Classification();
        classif.niveauClassificationAchat = 'test';
        classif.perimetreAchat = 'test';
        listClass.classification = new List<WS02_Partenaire.Classification> {classif};
        four.listeClassification = listClass;
        part1.fournisseur = four;

        WS02_Partenaire.ListeAdresses listAdd = new WS02_Partenaire.ListeAdresses();
        WS02_Partenaire.Adresse add = new WS02_Partenaire.Adresse();
        add.DKCodeAdresse = 'DK909090';
        add.adressePrincipale = true;
        add.statutAdresse = 'ACTIF';
        add.precisionDestinataire = 'test';
        add.precisionIdentificationAdresse = 'test';
        add.numeroVoie = '1';
        add.typeDeVoie = 'RUE';
        add.libelleVoie = 'De Victor Hugo';
        add.complementAdresse = 'test';
        add.codePostal = '1445';
        add.ville = 'Paris';
        add.pays = 'FR';
        add.telephone = '01020202';
        add.fax = '01020202';
        add.codeClientOracle = '123';
        add.codeFournisseurOracle = '123';
        add.referenceAdresseClient = 'test';
        add.referenceAdresseFournisseur = 'test';
        add.dematerialise = false;
        WS02_Partenaire.MetadonneesAdressePartenaire metaAdd = new WS02_Partenaire.MetadonneesAdressePartenaire();
        metaAdd.creationDate  = date.today();
        metaAdd.creationId = 'client360';
        metaAdd.updateDate = date.today();
        metaAdd.updateId = 'K0935246';
        metaAdd.validationDate = date.today();
        metaAdd.validationId = 'K0935246';
        add.metadonneesAdressePartenaire = new List<WS02_Partenaire.MetadonneesAdressePartenaire> {metaAdd};
        listAdd.adresse = new List<WS02_Partenaire.Adresse> {add};
        part1.listeAdresses = listAdd;

        WS02_Partenaire.Metadonnees meta = new WS02_Partenaire.Metadonnees();
        meta.creationDate  = date.today();
        meta.creationId = 'client360';
        meta.updateDate = date.today();
        meta.updateId = 'K0935246';
        meta.validationDate = date.today();
        meta.validationId = 'K0935246';

        part1.metadonnees = meta;

        //part2
        WS02_Partenaire.Partenaire part2 = new WS02_Partenaire.Partenaire();

        WS02_Partenaire.ProprietesPartenaire propPart2 = new WS02_Partenaire.ProprietesPartenaire();
        propPart2.naturePartenaire = 'ETAB';
        part2.proprietesPartenaire = propPart2;

        WS02_Partenaire.Etablissement etab = new WS02_Partenaire.Etablissement();
        etab.typeImmatriculation = 'test';
        etab.immatriculationLegale = 'test';
        etab.libelleEtablissement = 'test';
        etab.denominationCommerciale = 'test';
        etab.complementLibelle = 'test';
        etab.typeIdentificationExterne = 'test';
        etab.identificationExterne = 'test';
        etab.nomNaissance = 'test';
        etab.nomUsage = 'test';
        etab.PRENOMS = 'test';
        etab.siegeSocialPartenaire = false;
        etab.effectifSalarie = '1';
        etab.dateDebut = System.today();
        etab.dateFin = System.today();
        etab.statutEtablissement = 'test';
        etab.UODalkiaPilote = 'test';
        etab.statutGestionRH = true;
        etab.codeActiviteLocal = 'test';
        etab.codeActiviteInternational = 'test';
        part2.etablissement = etab;

        WS02_Partenaire.Client client2 = new WS02_Partenaire.Client();

        WS02_Partenaire.ConditionsPaiementDefaut cond2 = new WS02_Partenaire.ConditionsPaiementDefaut();
        client2.conditionsPaiementDefaut = cond2;
        part2.client = client2;

        WS02_Partenaire.Fournisseur four2 = new WS02_Partenaire.Fournisseur();
        part2.fournisseur = four2;

        WS02_Partenaire.ListeAdresses listAdd2 = new WS02_Partenaire.ListeAdresses();

        part2.listeAdresses = listAdd2;

        WS02_Partenaire.Metadonnees meta2 = new WS02_Partenaire.Metadonnees();

        part2.metadonnees = meta2;

        //part3
        WS02_Partenaire.Partenaire part3 = new WS02_Partenaire.Partenaire();

        WS02_Partenaire.ProprietesPartenaire propPartEmpty = new WS02_Partenaire.ProprietesPartenaire();
        part3.proprietesPartenaire = propPartEmpty;

        WS02_Partenaire.Partenaire part4 = new WS02_Partenaire.Partenaire();

        WS02_Partenaire.ProprietesPartenaire propPartEmpty2 = new WS02_Partenaire.ProprietesPartenaire();
        propPartEmpty2.naturePArtenaire = 'ETAB';
        part4.proprietesPartenaire = propPartEmpty2;
        WS02_Partenaire.Etablissement etabEmpty = new WS02_Partenaire.Etablissement();
        etabEmpty.libelleEtablissement = null;
        part4.etablissement = etabEmpty;
        part4.listeResponsables = new WS02_Partenaire.listeResponsables();
        part4.listeResponsables.responsable = new List<WS02_Partenaire.responsable>();
        WS02_Partenaire.responsable resp1 = new WS02_Partenaire.responsable();
        resp1.responsableCompte = '';
        resp1.perimetreResponsable = '';
        resp1.statutLienResponsable = true;
        part4.listeResponsables.responsable.add(resp1);

        test.startTest();
        Response resp = WS02_Partenaire.insertUpdatePartenaire(part1);
        Response resp2 = WS02_Partenaire.insertUpdatePartenaire(part2);
        Response resp3 = WS02_Partenaire.insertUpdatePartenaire(new WS02_Partenaire.Partenaire());
        Response resp4 = WS02_Partenaire.insertUpdatePartenaire(part3);
        Response resp5 = WS02_Partenaire.insertUpdatePartenaire(part4);
        test.stopTest();
    }

}