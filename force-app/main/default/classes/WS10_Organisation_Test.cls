@isTest
public class WS10_Organisation_Test {
@isTest
    public static void insertUpdateOrganisation()
    {
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935242';
        user.DkCode__c = 'K123456';
        insert user;
        
        WS10_Organisation.Organisation org1 = new WS10_Organisation.Organisation();
        WS10_Organisation.ProprietesOrganisation prop1 = new WS10_Organisation.ProprietesOrganisation();
        prop1.dkCodeOrganisation = '123';
        prop1.libelle = '123';
        prop1.commentaire = '123';
        prop1.controleNiveau = 1;
        prop1.statutOrganisation = 'PREP';
        prop1.dateDebut = System.today();
        prop1.dateFin = System.today();
        prop1.acronymeSigle = '123';
        prop1.estUODalkia = true;
        prop1.UODalkia = '123';
        prop1.estGroupeExploitation = true;
        prop1.reportingOrganisation = '123';
        org1.proprietesOrganisation = prop1;
        
        WS10_Organisation.LienParent lienParent1 = new WS10_Organisation.LienParent();
        lienParent1.dateDebut = System.today();
        lienParent1.organisationParente = 'K123123';
        List<WS10_Organisation.LienParent> listParent = new List<WS10_Organisation.LienParent>();
        listParent.add(lienParent1);
        org1.lienParent = listParent;
        
        WS10_Organisation.LienResponsable lienResp1 = new WS10_Organisation.LienResponsable();
        lienResp1.dateDebut = System.today();
        lienResp1.responsableOrganisation = 'K123456';
        List<WS10_Organisation.LienResponsable> listResp = new List<WS10_Organisation.LienResponsable>();
        listResp.add(lienResp1);
        org1.lienResponsable = listResp;
        
        WS10_Organisation.Metadonnees meta1 = new WS10_Organisation.Metadonnees();
        meta1.creationDate = System.today();
        meta1.updateDate = System.today();
        meta1.validationDate = System.today();
        meta1.creationId = 'K0935242';
        meta1.updateId = 'K0935242';
        meta1.validationId = 'K0935242';
        org1.metadonnees = meta1;
        
        WS10_Organisation.Organisation org2 = new WS10_Organisation.Organisation();
        WS10_Organisation.ProprietesOrganisation prop2 = new WS10_Organisation.ProprietesOrganisation();
        prop2.dkCodeOrganisation = '123';
        prop2.libelle = '123';
        prop2.commentaire = '123';
        prop2.controleNiveau = 1;
        prop2.statutOrganisation = 'PREP';
        prop2.dateDebut = System.today();
        prop2.dateFin = System.today();
        prop2.acronymeSigle = '123';
        prop2.estUODalkia = true;
        prop2.UODalkia = '123';
        prop2.estGroupeExploitation = true;
        prop2.reportingOrganisation = '123';
        org2.proprietesOrganisation = prop2;
        
        WS10_Organisation.LienParent lienParent2 = new WS10_Organisation.LienParent();
        lienParent2.dateDebut = System.today();
        lienParent2.organisationParente = '1234';
        List<WS10_Organisation.LienParent> listParent2 = new List<WS10_Organisation.LienParent>();
        listParent2.add(lienParent2);
        org2.lienParent = listParent2;
        
        WS10_Organisation.LienResponsable lienResp2 = new WS10_Organisation.LienResponsable();
        lienResp2.dateDebut = System.today();
        lienResp2.responsableOrganisation = 'K123456';
        List<WS10_Organisation.LienResponsable> listResp2 = new List<WS10_Organisation.LienResponsable>();
        listResp2.add(lienResp2);
        org2.lienResponsable = listResp2;
        
        WS10_Organisation.Metadonnees meta2 = new WS10_Organisation.Metadonnees();
        org2.metadonnees = meta2;
        
        WS10_Organisation.Organisation org3 = new WS10_Organisation.Organisation();
        WS10_Organisation.ProprietesOrganisation prop3 = new WS10_Organisation.ProprietesOrganisation();
        prop3.dkCodeOrganisation = '456';
        org3.proprietesOrganisation = prop3;
        
        WS10_Organisation.LienParent lienParent3 = new WS10_Organisation.LienParent();
        List<WS10_Organisation.LienParent> listParent3 = new List<WS10_Organisation.LienParent>();
        listParent3.add(lienParent3);
        org3.lienParent = listParent3;
        
        WS10_Organisation.LienResponsable lienResp3 = new WS10_Organisation.LienResponsable();
        List<WS10_Organisation.LienResponsable> listResp3 = new List<WS10_Organisation.LienResponsable>();
        listResp3.add(lienResp3);
        org3.lienResponsable = listResp3;
        
        WS10_Organisation.Metadonnees meta3 = new WS10_Organisation.Metadonnees();
        meta3.creationId = '444';
        meta3.updateId = '555';
        meta3.validationId = '666';
        org3.metadonnees = meta3;
        
        Agence__c ag = new Agence__c();
        ag.Libelle__c = 'test';
        ag.DkCode__c = '1234';
        insert ag;
        
        Test.startTest();
        Response resp = WS10_Organisation.insertUpdateOrganisation(org1);
        Response resp2 = WS10_Organisation.insertUpdateOrganisation(org2);
        Response resp3 = WS10_Organisation.insertUpdateOrganisation(org3);
        
        WS10_Organisation.Organisation org4 = new WS10_Organisation.Organisation();
        WS10_Organisation.ProprietesOrganisation prop4 = new WS10_Organisation.ProprietesOrganisation();
        prop4.dkCodeOrganisation = '456';
        prop4.libelle = 'test';
        prop4.dkCodeOrganisation = '1234';
        org4.proprietesOrganisation = prop4;
        
        WS10_Organisation.LienParent lienParent10 = new WS10_Organisation.LienParent();
        List<WS10_Organisation.LienParent> listParent6 = new List<WS10_Organisation.LienParent>();
        listParent6.add(lienParent10);
        org4.lienParent = listParent6;
        
        WS10_Organisation.LienResponsable lienResp4 = new WS10_Organisation.LienResponsable();
        List<WS10_Organisation.LienResponsable> lienResp5 = new List<WS10_Organisation.LienResponsable>();
        lienResp5.add(lienResp4);
        org4.lienResponsable = lienResp5;
        
        WS10_Organisation.Metadonnees meta4 = new WS10_Organisation.Metadonnees();
        meta4.creationId = '444';
        meta4.updateId = '555';
        meta4.validationId = '666';
        org4.metadonnees = meta4;
        
        Response resp4 = WS10_Organisation.insertUpdateOrganisation(org4);
        Test.stopTest();
        
    }
}