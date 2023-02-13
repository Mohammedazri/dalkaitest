@isTest
public class WS09_TacheFinance_Test {
    
    @isTest
    public static void insertUpdateTacheFinanceTest()
    {
        ProjetFinance__c pf = new ProjetFinance__c();
        pf.Name = 'cfWS06';
        pf.DkCode__c = 'K0935243';
        insert pf;
        
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        insert user;
        
        //tacheFinance1
        WS09_TacheFinance.TacheFinance tacheFinance1 = new WS09_TacheFinance.TacheFinance();
        
        WS09_TacheFinance.ProprietesTacheFinance propTf = new WS09_TacheFinance.ProprietesTacheFinance();
        propTf.dkCodeTache = '12345';
        propTf.libelle = 'testWS06';
        propTf.typeTache = 'L';
        propTf.statutFinance = 'PREP';
        propTf.dateDebut = Date.today();
        
        propTf.commentaire = 'test';
        propTf.modeGestion = 'XPF';
        propTf.montantPrevisionnelRecettes = 123;
        propTf.montantPrevisionnelCouts = 456;
        propTf.dateFin = Date.today();
        propTf.dateFermeture = Date.today();
        propTf.dateFinPrevisionnelle = date.today();
        
        tacheFinance1.proprietesTacheFinance = propTf;
        
        WS09_TacheFinance.LienProjetFinance lienPF = new WS09_TacheFinance.LienProjetFinance();
        lienPF.dkCodeProjet = 'K0935243';
        
        tacheFinance1.lienProjetFinance = lienPF;
        
        WS09_TacheFinance.Metadonnees meta = new WS09_TacheFinance.Metadonnees();
        meta.creationDate  = date.today();
        meta.creationId = 'client360';
        meta.updateDate = date.today();
        meta.updateId = 'K0935246';
        meta.validationDate = date.today();
        meta.validationId = 'K0935246';
        
        tacheFinance1.metadonnees = meta;
        
         //tacheFinance2
        WS09_TacheFinance.TacheFinance tacheFinance2 = new WS09_TacheFinance.TacheFinance();
        
        WS09_TacheFinance.ProprietesTacheFinance propTf2 = new WS09_TacheFinance.ProprietesTacheFinance();
        propTf2.dkCodeTache = '';
        propTf2.libelle = '';
        propTf2.typeTache = '';
        propTf2.statutFinance = '';
        propTf2.dateDebut = null;
        
        propTf2.commentaire = 'test';
        propTf2.modeGestion = 'XPF';
        propTf2.montantPrevisionnelRecettes = 123;
        propTf2.montantPrevisionnelCouts = 456;
        propTf2.dateFin = Date.today();
        propTf2.dateFermeture = Date.today();
        propTf2.dateFinPrevisionnelle = date.today();
        
        tacheFinance2.proprietesTacheFinance = propTf2;
        
        WS09_TacheFinance.LienProjetFinance lienPF2 = new WS09_TacheFinance.LienProjetFinance();
        lienPF2.dkCodeProjet = '';
        
        tacheFinance2.lienProjetFinance = lienPF2;
        
        WS09_TacheFinance.Metadonnees meta2 = new WS09_TacheFinance.Metadonnees();
        meta2.creationDate  = null;
        meta2.creationId = '';
        meta2.updateDate = date.today();
        meta2.updateId = 'K0935246';
        meta2.validationDate = date.today();
        meta2.validationId = 'K0935246';
        
        tacheFinance2.metadonnees = meta2;
        
        
        test.startTest();
        Response resp = WS09_TacheFinance.insertUpdateTacheFinance(tacheFinance1);
        Response resp2 = WS09_TacheFinance.insertUpdateTacheFinance(tacheFinance2);
        test.stopTest();
    }

}