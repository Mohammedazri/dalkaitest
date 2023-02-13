@isTest
public class WS03_AdressePartenaire_Test {
    @isTest
    public static void modifierAdressePartenaireTest()
    {
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        insert user;
        
        //part1
        WS03_AdressePartenaire.Adresse_Partenaire part1 = new WS03_AdressePartenaire.Adresse_Partenaire();
        part1.DKCodePartenaire = 'DK9090901';
        part1.utilisationFiliereCommerce = 'true';
        part1.utilisationFiliereAchats = 'true';
        part1.categorieSociete = 'DLK';
        part1.naturePartenaire = 'PART';
        
        WS03_AdressePartenaire.ListeAdresses listAdd = new WS03_AdressePartenaire.ListeAdresses();
        WS03_AdressePartenaire.Adresse add = new WS03_AdressePartenaire.Adresse();
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
        WS03_AdressePartenaire.MetadonneesAdressePartenaire metaAdd = new WS03_AdressePartenaire.MetadonneesAdressePartenaire();
        metaAdd.creationDate  = date.today();
        metaAdd.creationId = 'client360';
        metaAdd.updateDate = date.today();
        metaAdd.updateId = 'K0935246';
        metaAdd.validationDate = date.today();
        metaAdd.validationId = 'K0935246';
        add.metadonneesAdressePartenaire = metaAdd;
        listAdd.adresse = new List<WS03_AdressePartenaire.Adresse>{add};
        part1.listeAdresses = listAdd;
        
        //part 2
        WS03_AdressePartenaire.Adresse_Partenaire part2 = new WS03_AdressePartenaire.Adresse_Partenaire();
        WS03_AdressePartenaire.ListeAdresses listAdd2 = new WS03_AdressePartenaire.ListeAdresses();
        WS03_AdressePartenaire.Adresse add2 = new WS03_AdressePartenaire.Adresse();
        add2.DKCodeAdresse = 'DK909090';
        add2.adressePrincipale = true;
        WS03_AdressePartenaire.MetadonneesAdressePartenaire metaAdd2 = new WS03_AdressePartenaire.MetadonneesAdressePartenaire();
        add2.metadonneesAdressePartenaire = metaAdd2;
        listAdd2.adresse = new List<WS03_AdressePartenaire.Adresse>{add2};
        part2.listeAdresses = listAdd2;
        
        test.startTest();
        Response resp = WS03_AdressePartenaire.modifierAdressePartenaire(part1);
        Response resp2 = WS03_AdressePartenaire.modifierAdressePartenaire(part2);
        Response resp3 = WS03_AdressePartenaire.modifierAdressePartenaire(new WS03_AdressePartenaire.Adresse_Partenaire());
        test.stopTest();
    }
    
}