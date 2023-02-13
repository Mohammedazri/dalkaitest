@isTest
public class WS01_Societe_Test {    
    @isTest
    public static void insertUpdateSocieteTest()
    {   
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        insert user;
        
        //societe1
        WS01_Societe.Societe societe1 = new WS01_Societe.Societe();
        
        WS01_Societe.ProprietesSociete propSoc = new WS01_Societe.ProprietesSociete();
        propSoc.DKCodeSociete = 'KO12345';
        propSoc.statutSociete = 'OUV';
        propSoc.commentaire = 'test';
        propSoc.categorieSociete = 'EXT';
        propSoc.denominationSociale = 'Test soc name';
        propSoc.typeImmatriculation = 'RCS';
        propSoc.statutSociete = 'OUV';
        propSoc.utilisationSociete = 'NA';
        propSoc.formeJuridiqueINSEE = '5499';
        propSoc.genreSociete = 'PRV';
        propSoc.immatriculationLegale = '377636105';
        propSoc.lieuImmatriculationLegale = 'NANTERRE';
        propSoc.numTVAIntracommunautaire = 'FR28377636105';
        societe1.proprietesSociete = propSoc;
        
        WS01_Societe.Activite act = new WS01_Societe.Activite();
        act.codeActiviteInternational = '4675Z';
        act.codeActiviteLocal = '4675Z';
        societe1.activite = act;
        

        WS01_Societe.Categorie cat= new WS01_Societe.Categorie();
        WS01_Societe.ListeGroupesDalkia dalk = new WS01_Societe.ListeGroupesDalkia();
        WS01_Societe.ListeGroupesEDF edf = new WS01_Societe.ListeGroupesEDF();
        WS01_Societe.Externe ext = new WS01_Societe.Externe();
        
        WS01_Societe.GroupeDalkia group1 = new WS01_Societe.GroupeDalkia();
        WS01_Societe.GroupeEDF group2 = new WS01_Societe.GroupeEDF();
        group1.statutGestionCO2 =  true;
        group1.dateFin = System.today();
        group2.modeConsolidation = 'test';
        group2.codeConsolidation = 'test';
        group2.groupeIntegrationFiscale = 'test';
        group2.dateFin = System.today();
        ext.niveauRelationCommerciale = 'test';
        ext.qualiteRelationCommerciale = 'test';
        ext.scoreRisque = 'test';
        ext.dateNotationExterne = System.today();
        ext.appreciationRecouvrement = 'test';
        ext.dateNotationInterne = System.today();
        dalk.groupeDalkia = new List<WS01_Societe.GroupeDalkia>{group1};
        edf.groupeEDF = new List<WS01_Societe.GroupeEDF>{group2};
        
        cat.listeGroupesDalkia = dalk;
        cat.listeGroupesEDF = edf;
        cat.externe = ext;
		societe1.categorie = cat;


        WS01_Societe.Metadonnees meta = new WS01_Societe.Metadonnees();
        meta.creationDate  = date.today();
        meta.creationId = 'client360';
        meta.updateDate = date.today();
        meta.updateId = 'K0935246';
        meta.validationDate = date.today();
        meta.validationId = 'K0935246';
        
        societe1.metadonnees = meta;
	
        WS01_Societe.Societe societe2 = new WS01_Societe.Societe();
        
        WS01_Societe.ProprietesSociete propSoc2 = new WS01_Societe.ProprietesSociete();
        propSoc2.formeJuridique = '5499';
        propSoc2.deviseCapitalSocial = 'test';
        propSoc2.montantCapitalSocial = 1;
        propSoc2.identifiantCreancierSEPA = 'test';
        propSoc2.codeClientOracle = 'test';
        propSoc2.codeFournisseurOracle = 'test';
        propSoc2.acronymeSigle = 'test';
        societe2.proprietesSociete = propSoc2;
        
        WS01_Societe.Activite act2 = new WS01_Societe.Activite();
        societe2.activite = act2;

        WS01_Societe.Metadonnees meta2 = new WS01_Societe.Metadonnees();
        societe2.metadonnees = meta2;
        test.startTest();
        Response resp = WS01_Societe.insertAccount(societe1);
        Response resp2 = WS01_Societe.insertAccount(societe2);
        Response resp3 = WS01_Societe.insertAccount(new WS01_Societe.Societe());
        test.stopTest();
    }
    
}