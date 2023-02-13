@isTest
public class WS07_CentreFinance_Test {

    @isTest
    public static void insertUpdateCentreFinanceTest()
    {
        CentreFinance__c cf = new CentreFinance__c();
        cf.Name = 'cfWS06';
        cf.DkCode__c = 'K0935243';
        insert cf;
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        insert user;
        
        //centreFinance1
        WS07_CentreFinance.CentreFinance centreFinance1 = new WS07_CentreFinance.CentreFinance();
        
        WS07_CentreFinance.ProprietesCentreFinance propCf = new WS07_CentreFinance.ProprietesCentreFinance();
        propCf.dkCentreFinance = '12345';
        propCf.libelleCentreFinance = 'testWS06';
        propCf.controleNiveau = 123;
        propCf.statutFinance = 'PREP';
        propCf.dateDebut = Date.today();
        propCf.estUODalkia = true;
        propCf.imputationsOperationnelles = true;
        
        propCf.commentaire = 'test';
        propCf.dateFin = Date.today();
        propCf.dateFermeture = Date.today();
        propCf.acronymeSigle = 'testAcro';
        propCf.categorieUODalkia = 'testCat';
        propCf.ReportingCentreFinance = 'testRep';
        
        centreFinance1.proprietesCentreFinance = propCf;
        
        WS07_CentreFinance.LienParent lienR = new WS07_CentreFinance.LienParent();
        lienR.CentreParent = 'K0935243';
        lienR.dateDebut = Date.today();
        lienR.dateFin = Date.today();
        List<WS07_CentreFinance.LienParent> listLienR = new List<WS07_CentreFinance.LienParent>();
        listLienR.add(lienR);
        
        centreFinance1.lienParent = listLienR;
        
        WS07_CentreFinance.UODalkia uoD = new WS07_CentreFinance.UODalkia();
        uoD.UODalkia = 'K0935243';
        uoD.dateDebut = Date.today();
        uoD.dateFin = Date.today();
        List<WS07_CentreFinance.UODalkia> listUOD = new List<WS07_CentreFinance.UODalkia>();
        listUOD.add(uoD);
        
        centreFinance1.listUODalkia = listUOD;
        
        WS07_CentreFinance.Responsable res = new WS07_CentreFinance.Responsable();
        res.responsable = 'K0935246';
        res.dateDebut = Date.today();
        res.dateFin = Date.today();
        List<WS07_CentreFinance.Responsable> listRes = new List<WS07_CentreFinance.Responsable>();
        listRes.add(res);
        
        centreFinance1.listResponsable = listRes;
        
        WS07_CentreFinance.Metadonnees meta = new WS07_CentreFinance.Metadonnees();
        meta.creationDate  = date.today();
        meta.creationId = 'client360';
        meta.updateDate = date.today();
        meta.updateId = 'K0935246';
        meta.validationDate = date.today();
        meta.validationId = 'K0935246';
        
        centreFinance1.metadonnees = meta;
        
        //centreFinance2
        WS07_CentreFinance.CentreFinance centreFinance2 = new WS07_CentreFinance.CentreFinance();
        
        WS07_CentreFinance.ProprietesCentreFinance propCf2 = new WS07_CentreFinance.ProprietesCentreFinance();
        propCf2.dkCentreFinance = '';
        propCf2.libelleCentreFinance = '';
        propCf2.controleNiveau = null;
        propCf2.statutFinance = '';
        propCf2.dateDebut = null;
        propCf2.estUODalkia = null;
        propCf2.imputationsOperationnelles = null;
        
        propCf2.commentaire = 'test';
        propCf2.dateFin = Date.today();
        propCf2.dateFermeture = Date.today();
        propCf2.acronymeSigle = 'testAcro';
        propCf2.categorieUODalkia = 'testCat';
        propCf2.ReportingCentreFinance = 'testRep';
        
        centreFinance2.proprietesCentreFinance = propCf2;
        
        WS07_CentreFinance.LienParent lienR2 = new WS07_CentreFinance.LienParent();
        lienR2.CentreParent = '';
        lienR2.dateDebut = null;
        lienR2.dateFin = Date.today();
        List<WS07_CentreFinance.LienParent> listLienR2 = new List<WS07_CentreFinance.LienParent>();
        listLienR2.add(lienR2);
        
        centreFinance2.lienParent = listLienR2;
        
        WS07_CentreFinance.UODalkia uoD2 = new WS07_CentreFinance.UODalkia();
        uoD2.UODalkia = '';
        uoD2.dateDebut = null;
        uoD2.dateFin = Date.today();
        List<WS07_CentreFinance.UODalkia> listUOD2 = new List<WS07_CentreFinance.UODalkia>();
        listUOD2.add(uoD2);
        
        centreFinance2.listUODalkia = listUOD2;
        
        WS07_CentreFinance.Responsable res2 = new WS07_CentreFinance.Responsable();
        res2.responsable = '';
        res2.dateDebut = null;
        res2.dateFin = Date.today();
        List<WS07_CentreFinance.Responsable> listRes2 = new List<WS07_CentreFinance.Responsable>();
        listRes2.add(res2);
        
        centreFinance2.listResponsable = listRes2;
        
        WS07_CentreFinance.Metadonnees meta2 = new WS07_CentreFinance.Metadonnees();
        meta2.creationDate  = null;
        meta2.creationId = '';
        meta2.updateDate = date.today();
        meta2.updateId = 'K0935246';
        meta2.validationDate = date.today();
        meta2.validationId = 'K0935246';
        
        centreFinance2.metadonnees = meta2;
        
        test.startTest();
        Response resp = WS07_CentreFinance.insertUpdateCentreFinance(centreFinance1);
        Response resp2 = WS07_CentreFinance.insertUpdateCentreFinance(centreFinance2);
        test.stopTest();
    }
}