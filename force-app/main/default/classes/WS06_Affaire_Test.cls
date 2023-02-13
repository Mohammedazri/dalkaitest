@isTest
public class WS06_Affaire_Test {
    
    @isTest
    public static void insertUpdateAffaireTest(){
        
        CentreFinance__c cf = new CentreFinance__c();
        cf.Name = 'cfWS06';
        cf.DkCode__c = 'K0935243';
        insert cf;
        
		Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        insert user;
        
        //affaire
        WS06_Affaire.Affaire affaire = new WS06_Affaire.Affaire();
        
        WS06_Affaire.ProprietesAffaire propAff = new WS06_Affaire.ProprietesAffaire();
        propAff.dkCodeAffaire = '12345';
        propAff.libelle = 'testWS06';
        propAff.statutFinance = 'PREP';
        propAff.UODalkiaPilote = 'K0935243';
        propAff.commentaire = 'test';
        propAff.dateDebut = Date.today();
        propAff.dateFermeture = Date.today();
        propAff.dateFin = Date.today();
        propAff.localisationAffaire = 'testLoc';
        propAff.reportingAffaire = 'testRep';
        
        affaire.proprietesAffaire = propAff;
        
        WS06_Affaire.LienDas lienD = new WS06_Affaire.LienDas();
        lienD.dasDalkia = 'RES';
        lienD.dateDebut = Date.today();
        lienD.dateFin = Date.today();
        List<WS06_Affaire.LienDas> listLienD = new List<WS06_Affaire.LienDas>();
        listLienD.add(lienD);
        
        affaire.lienDas = listLienD;
        
        WS06_Affaire.LienResponsable lienR = new WS06_Affaire.LienResponsable();
        lienR.responsableAffaire = 'resAff';
        lienR.dateDebut = Date.today();
        lienR.dateFin = Date.today();
        List<WS06_Affaire.LienResponsable> listLienR = new List<WS06_Affaire.LienResponsable>();
        listLienR.add(lienR);
        
        affaire.lienResponsable = listLienR;
        
        WS06_Affaire.Metadonnees meta = new WS06_Affaire.Metadonnees();
        meta.creationDate  = date.today();
        meta.creationId = 'client360';
        meta.updateDate = date.today();
        meta.updateId = 'K0935246';
        meta.validationDate = date.today();
        meta.validationId = 'K0935246';
        
        affaire.metadonnees = meta;
        
        //affaire2
        WS06_Affaire.Affaire affaire2 = new WS06_Affaire.Affaire();
        
        WS06_Affaire.ProprietesAffaire propAff2 = new WS06_Affaire.ProprietesAffaire();
        propAff2.dkCodeAffaire = '';
        propAff2.libelle = '';
        propAff2.statutFinance = '';
        propAff2.UODalkiaPilote = '';
        propAff2.commentaire = 'test';
        propAff2.dateDebut = Date.today();
        propAff2.dateFermeture = Date.today();
        propAff2.dateFin = Date.today();
        propAff2.localisationAffaire = 'testLoc';
        propAff2.reportingAffaire = 'testRep';
        
        affaire2.proprietesAffaire = propAff2;
        
        WS06_Affaire.LienDas lienD2 = new WS06_Affaire.LienDas();
        lienD2.dasDalkia = '';
        lienD2.dateDebut = Date.today();
        lienD2.dateFin = Date.today();
        List<WS06_Affaire.LienDas> listLienD2 = new List<WS06_Affaire.LienDas>();
        listLienD2.add(lienD2);
        
        affaire2.lienDas = null;
        
        WS06_Affaire.LienResponsable lienR2 = new WS06_Affaire.LienResponsable();
        lienR2.responsableAffaire = '';
        lienR2.dateDebut = null;
        lienR2.dateFin = Date.today();
        List<WS06_Affaire.LienResponsable> listLienR2 = new List<WS06_Affaire.LienResponsable>();
        listLienR2.add(lienR2);
        
        affaire2.lienResponsable = null;
        
        WS06_Affaire.Metadonnees meta2 = new WS06_Affaire.Metadonnees();
        meta2.creationDate  = null;
        meta2.creationId = '';
        meta2.updateDate = date.today();
        meta2.updateId = 'K0935246';
        meta2.validationDate = date.today();
        meta2.validationId = 'K0935246';
        
        affaire2.metadonnees = meta2;
        
        test.startTest();
        Response resp = WS06_Affaire.insertUpdateAffaire(affaire);
        Response resp2 = WS06_Affaire.insertUpdateAffaire(affaire2);
        test.stopTest();
        
    }

}