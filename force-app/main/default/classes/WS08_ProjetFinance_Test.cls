@isTest
public class WS08_ProjetFinance_Test {
    @isTest
    public static void insertUpdateProjetFinanceTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'client360';
        insert user;
        
        //affaire
        WS08_ProjetFinance.ProjetFinance projetFinance = new WS08_ProjetFinance.ProjetFinance();
        
        WS08_ProjetFinance.ProprietesProjetFinance propProj = new WS08_ProjetFinance.ProprietesProjetFinance();
        propProj.dkProjet = '12345';
        propProj.libelleProjetFinance = 'testWS08';
        propProj.commentaire = 'test';
        propProj.StatutFinance = 'PREP';
        propProj.classeProjet = 'testClasseProj';
        propProj.dateDebut = Date.today();
        propProj.dateFermeture = Date.today();
        propProj.dateFin = Date.today();        
        projetFinance.ProprietesProjetFinance = propProj;
        
        WS08_ProjetFinance.LienProjetInvestissement lienPI = new WS08_ProjetFinance.LienProjetInvestissement();
        lienPI.tacheProjetParent = 'tpp';
        lienPI.projetParent = 'pp';
        projetFinance.LienProjetInvestissement = lienPI;
        
        WS08_ProjetFinance.LienSociete lienS = new WS08_ProjetFinance.LienSociete();
        lienS.matriculeSociete = 'RES';
        lienS.dkCodePartenaire = 'K00010221';
        lienS.dateDebut = Date.today();
        lienS.dateFin = Date.today();
        List<WS08_ProjetFinance.LienSociete> listLienS = new List<WS08_ProjetFinance.LienSociete>();
        listLienS.add(lienS);
        projetFinance.listLienSociete = listLienS;
        
        WS08_ProjetFinance.LienCentreFinance lienCF = new WS08_ProjetFinance.LienCentreFinance();
        lienCF.dkCodeCentreFinance = 'K00010221';
        lienCF.dateDebut = Date.today();
        lienCF.dateFin = Date.today();
        List<WS08_ProjetFinance.LienCentreFinance> listLienCF = new List<WS08_ProjetFinance.LienCentreFinance>();
        listLienCF.add(lienCF);
        projetFinance.listLienCentreFinance = listLienCF;
        
        WS08_ProjetFinance.LienAffaire lienAffaire = new WS08_ProjetFinance.LienAffaire();
        lienAffaire.dkCodeAffaire = 'B010101';
        projetFinance.LienAffaire = lienAffaire;
        
        WS08_ProjetFinance.LienConfiguration lienConfiguration = new WS08_ProjetFinance.LienConfiguration();
        lienConfiguration.filiere = 'test';
        lienConfiguration.destinationDK = 'test';
        //lienConfiguration.listTypeTacheAutorisee = null;
        lienConfiguration.nature = 'test';
        lienConfiguration.gestionTravauxInterne = 'test';
        lienConfiguration.modeRestitutionTravauxInterne = 'test';
        projetFinance.LienConfiguration = lienConfiguration;
        
        WS08_ProjetFinance.LienAffectation lienAF = new WS08_ProjetFinance.LienAffectation();
        lienAF.affectionCouts = 'test';
        lienAF.dateDebut = Date.today();
        lienAF.dateFin = Date.today();
        List<WS08_ProjetFinance.LienAffectation> listLienAF = new List<WS08_ProjetFinance.LienAffectation>();
        listLienAF.add(lienAF);
        projetFinance.listLienAffectation = listLienAF;
        
        WS08_ProjetFinance.LienTaux lienT = new WS08_ProjetFinance.LienTaux();
        lienT.tauxUniteOeuvre = 'test';
        lienT.baseUniteOeuvre = 'test';
        lienT.dateDebut = Date.today();
        lienT.dateFin = Date.today();
        List<WS08_ProjetFinance.LienTaux> listLienT = new List<WS08_ProjetFinance.LienTaux>();
        listLienT.add(lienT);
        projetFinance.listLienTaux = listLienT;
        
        WS08_ProjetFinance.LienInformation lienInformation = new WS08_ProjetFinance.LienInformation();
        lienInformation.comiteEngagementUODalkia = 'test';
        lienInformation.comiteEngagementGroupe = 'test';
        lienInformation.reportingAffaire = 'test';
        lienInformation.reportingProjetFinance = 'test';
        projetFinance.LienInformation = lienInformation;
        
        WS08_ProjetFinance.LienResponsable lienR = new WS08_ProjetFinance.LienResponsable();
        lienR.responsableProjetFinance = 'test';
        lienR.dateDebut = Date.today();
        lienR.dateFin = Date.today();
        List<WS08_ProjetFinance.LienResponsable> listLienR = new List<WS08_ProjetFinance.LienResponsable>();
        listLienR.add(lienR);
        projetFinance.listLienResponsable = listLienR;
        
        WS08_ProjetFinance.Metadonnees meta = new WS08_ProjetFinance.Metadonnees();
        meta.creationDate  = date.today();
        meta.creationId = 'client360';
        meta.updateDate = date.today();
        meta.updateId = 'client360';
        meta.validationDate = date.today();
        meta.validationId = 'client360';
        projetFinance.metadonnees = meta;
        
       	WS08_ProjetFinance.ProjetFinance projetFinance2 = new WS08_ProjetFinance.ProjetFinance();
        WS08_ProjetFinance.ProprietesProjetFinance propProj2 = new WS08_ProjetFinance.ProprietesProjetFinance();   
        projetFinance2.ProprietesProjetFinance = propProj2;
        
        WS08_ProjetFinance.ProjetFinance projetFinance3 = new WS08_ProjetFinance.ProjetFinance();
        test.startTest();
        Response resp = WS08_ProjetFinance.insertUpdateProjetFinance(projetFinance);
        Response resp2 = WS08_ProjetFinance.insertUpdateProjetFinance(projetFinance2);
        Response resp3 = WS08_ProjetFinance.insertUpdateProjetFinance(projetFinance3);
        test.stopTest();
        
    }
    
}