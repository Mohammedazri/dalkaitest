@isTest
public class WS11_Ressource_TEST {
    @isTest
    public static void insertUpdateResourceTest(){
        Profile p = [SELECT Id FROM Profile WHERE id = :Label.AdminProfileId];
        User user = testUtils.CreateUser('testU', 'testU@testorg.com', 'testU', p.Id, 'testU@testorg.com');
        user.ReferentielId__c = 'K0935246';
        user.DkCode__c = 'K0935246';
        user.firstName = 'Alain';
        user.lastName = 'Ghoussoub';
        insert user;
        
        Profile p1 = [SELECT Id FROM Profile WHERE name = 'Lecture seule Dalkia'];
        User user1 = testUtils.CreateUser('testU1', 'test1U@testorg.com', 'tes1tU', p1.Id, 'testU1@testorg.com');
        user1.ReferentielId__c = 'K0933246';
        user1.DkCode__c = 'K0933246';
        user1.IsActive = false;
        insert user1;
        
        WS11_Ressource.Ressource resourceRecord = new WS11_Ressource.Ressource();
        
        resourceRecord.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord.ProprietesRessource.dkCodeRessource = 'K0935246';
        resourceRecord.ProprietesRessource.statut = 'OUV';
        resourceRecord.ProprietesRessource.login = 'alain';
        
        resourceRecord.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord.etatCivil.nomUsage = 'alain';
        resourceRecord.etatCivil.prenomUsage = 'alain';
        
        resourceRecord.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord.DonneesPersonelles.coordonnees.listEmail = new List<WS11_Ressource.Email>();
        WS11_Ressource.Email mail = new WS11_Ressource.Email();
        mail.email='test@salesforce.com';
        mail.natureEmail = 'PRO';
        resourceRecord.DonneesPersonelles.coordonnees.listEmail.add(mail);
        
        WS11_Ressource.Email mail1 = new WS11_Ressource.Email();
        mail1.email=null;
        resourceRecord.DonneesPersonelles.coordonnees.listEmail.add(mail1);
        
        resourceRecord.DonneesPersonelles.coordonnees.listLigne = new List<WS11_Ressource.ligne>();
        WS11_Ressource.Ligne line = new WS11_Ressource.Ligne();
        line.typeLigne = 'TELEPHONE';
        line.natureLigne = 'PRO';
        resourceRecord.DonneesPersonelles.coordonnees.listLigne.add(line);
        
        resourceRecord.DonneesPersonelles.coordonnees.Adresse = new WS11_Ressource.Adresse();
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.natureAdresse = 'PRO';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.adresse1 = 'test';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.adresse2 = 'test';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.adresse3 = 'test';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.adresse4 = 'test';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.codePostal = 'test';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.ville = 'test';
        resourceRecord.DonneesPersonelles.coordonnees.Adresse.pays = 'test';
        
        resourceRecord.GestionRH = new WS11_Ressource.GestionRH();
        resourceRecord.GestionRH.matriculeRhDk = '123';
        resourceRecord.GestionRH.listReferentHierarchique = new List<WS11_Ressource.ReferentHierarchique>();
        WS11_Ressource.ReferentHierarchique ref = new WS11_Ressource.ReferentHierarchique();
        ref.roleHierarchique = 'HIERA';
        ref.superieurHierarchique = 'K0933246';
        ref.datedebut = System.today()-1;
        resourceRecord.GestionRH.listReferentHierarchique.add(ref);
        WS11_Ressource.ReferentHierarchique ref1 = new WS11_Ressource.ReferentHierarchique();
        ref1.roleHierarchique = 'HIERA';
        ref1.superieurHierarchique = 'K0933246';
        ref1.datedebut = System.today()+1;
        resourceRecord.GestionRH.listReferentHierarchique.add(ref1);
        
        resourceRecord.Emploi = new WS11_Ressource.emploi();
        resourceRecord.Emploi.listFonction = new List<WS11_Ressource.Fonction>();
        WS11_Ressource.Fonction fct = new WS11_Ressource.Fonction();
        fct.dateDebut = System.today()-1;
        fct.dateFin = System.today()+1;
        resourceRecord.Emploi.listFonction.add(fct);
        
        resourceRecord.Affectation = new WS11_Ressource.Affectation();
        resourceRecord.Affectation.listFiliereDK = new List<WS11_Ressource.FiliereDK>();
        WS11_Ressource.FiliereDK fil = new WS11_Ressource.FiliereDK();
        fil.dateDebut = System.today()-1;
        fil.dateFin = System.today()+1;
        fil.sousFiliere = 'test';
        fil.Filiere = 'test';
        resourceRecord.Affectation.listFiliereDK.add(fil);
        WS11_Ressource.FiliereDK fil11 = new WS11_Ressource.FiliereDK();
        fil11.dateDebut = System.today()-1;
        fil11.dateFin = null;
        fil11.sousFiliere = 'test';
        fil11.Filiere = 'test';
        resourceRecord.Affectation.listFiliereDK.add(fil11);
        
        resourceRecord.Affectation.listOrganisation = new List<WS11_Ressource.Organisation>();
        WS11_Ressource.Organisation org = new WS11_Ressource.Organisation();
        org.dateDebut = System.today()-1;
        org.dateFin = System.today()+1;
        org.Organisation = 'test';
        resourceRecord.Affectation.listOrganisation.add(org);
        WS11_Ressource.Organisation org11 = new WS11_Ressource.Organisation();
        org11.dateDebut = System.today()-1;
        org11.dateFin = null;
        org11.Organisation = 'test';
        resourceRecord.Affectation.listOrganisation.add(org11);
        WS11_Ressource.Organisation org12 = new WS11_Ressource.Organisation();
        org12.dateDebut = System.today()+1;
        org12.dateFin = null;
        org12.Organisation = 'test';
        resourceRecord.Affectation.listOrganisation.add(org12);
        
        resourceRecord.Metadonnees = new WS11_Ressource.Metadonnees();
        resourceRecord.Metadonnees.creationDate = System.today()-1;
        resourceRecord.Metadonnees.creationId = '123';
        resourceRecord.Metadonnees.updateDate = System.today()-1;
        resourceRecord.Metadonnees.updateId = '123';
        resourceRecord.Metadonnees.validationDate = System.today()-1;
        resourceRecord.Metadonnees.validationId = '123';
        
        WS11_Ressource.Ressource resourceRecord2 = new WS11_Ressource.Ressource();
        resourceRecord2.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord2.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord2.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord2.GestionRH = new WS11_Ressource.GestionRH();
        resourceRecord2.Emploi = new WS11_Ressource.emploi();
        resourceRecord2.Affectation = new WS11_Ressource.Affectation();
        resourceRecord2.Metadonnees = new WS11_Ressource.Metadonnees();
        
        WS11_Ressource.Ressource resourceRecord3 = new WS11_Ressource.Ressource();
        resourceRecord3.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord3.ProprietesRessource.dkCodeRessource = 'K0933246';
        resourceRecord3.ProprietesRessource.statut = 'OUV';
        resourceRecord3.ProprietesRessource.login = 'alain';
        
        resourceRecord3.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord3.etatCivil.nomUsage = 'alain';
        resourceRecord3.etatCivil.prenomUsage = 'alain';
        
        resourceRecord3.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord3.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord3.DonneesPersonelles.coordonnees.listEmail = new List<WS11_Ressource.Email>();
        mail.email='test@salesforce.com';
        mail.natureEmail = 'PRO';
        resourceRecord3.DonneesPersonelles.coordonnees.listEmail.add(mail);
        
        resourceRecord3.DonneesPersonelles.coordonnees.listLigne = new List<WS11_Ressource.ligne>();
        line.typeLigne = 'TELEPHONE';
        line.natureLigne = 'PRO';
        resourceRecord3.DonneesPersonelles.coordonnees.listLigne.add(line);
        
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse = new WS11_Ressource.Adresse();
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.natureAdresse = 'PRO';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.adresse1 = 'test';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.adresse2 = 'test';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.adresse3 = 'test';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.adresse4 = 'test';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.codePostal = 'test';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.ville = 'test';
        resourceRecord3.DonneesPersonelles.coordonnees.Adresse.pays = 'test';
        
        resourceRecord3.GestionRH = new WS11_Ressource.GestionRH();
        resourceRecord3.GestionRH.matriculeRhDk = '123';
        resourceRecord3.GestionRH.listReferentHierarchique = new List<WS11_Ressource.ReferentHierarchique>();
        ref.roleHierarchique = 'HIERA';
        ref.superieurHierarchique = 'HIERA';
        ref.datedebut = System.today()-1;
        resourceRecord3.GestionRH.listReferentHierarchique.add(ref);
        
        resourceRecord3.Emploi = new WS11_Ressource.emploi();
        resourceRecord3.Emploi.listFonction = new List<WS11_Ressource.Fonction>();
        fct.dateDebut = System.today()-1;
        fct.dateFin = System.today()+1;
        resourceRecord3.Emploi.listFonction.add(fct);
        
        resourceRecord3.Affectation = new WS11_Ressource.Affectation();
        resourceRecord3.Affectation.listFiliereDK = new List<WS11_Ressource.FiliereDK>();
        fil.dateDebut = System.today()-1;
        fil.dateFin = System.today()+1;
        fil.sousFiliere = 'test';
        fil.Filiere = 'test';
        resourceRecord3.Affectation.listFiliereDK.add(fil);
        
        resourceRecord3.Affectation.listOrganisation = new List<WS11_Ressource.Organisation>();
        org.dateDebut = System.today()-1;
        org.dateFin = System.today()+1;
        org.Organisation = 'test';
        resourceRecord3.Affectation.listOrganisation.add(org);
        
        resourceRecord3.Metadonnees = new WS11_Ressource.Metadonnees();
        resourceRecord3.Metadonnees.creationDate = System.today()-1;
        resourceRecord3.Metadonnees.creationId = '123';
        resourceRecord3.Metadonnees.updateDate = System.today()-1;
        resourceRecord3.Metadonnees.updateId = '123';
        resourceRecord3.Metadonnees.validationDate = System.today()-1;
        resourceRecord3.Metadonnees.validationId = '123';
        
        WS11_Ressource.Ressource resourceRecord4 = new WS11_Ressource.Ressource();
        
        resourceRecord4.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord4.ProprietesRessource.dkCodeRessource = 'K09352454545';
        resourceRecord4.ProprietesRessource.statut = 'OUV';
        resourceRecord4.ProprietesRessource.login = 'alain';
        
        resourceRecord4.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord4.etatCivil.nomUsage = 'alain';
        resourceRecord4.etatCivil.prenomUsage = 'alain';
        
        resourceRecord4.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord4.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord4.DonneesPersonelles.coordonnees.listEmail = new List<WS11_Ressource.Email>();
        mail.email='test@salesforce.com';
        mail.natureEmail = 'PRO';
        resourceRecord4.DonneesPersonelles.coordonnees.listEmail.add(mail);
        
        resourceRecord4.DonneesPersonelles.coordonnees.listLigne = new List<WS11_Ressource.ligne>();
        line.typeLigne = 'TELEPHONE';
        line.natureLigne = 'PRO';
        resourceRecord4.DonneesPersonelles.coordonnees.listLigne.add(line);
        
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse = new WS11_Ressource.Adresse();
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.natureAdresse = 'PRO';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.adresse1 = 'test';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.adresse2 = 'test';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.adresse3 = 'test';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.adresse4 = 'test';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.codePostal = 'test';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.ville = 'test';
        resourceRecord4.DonneesPersonelles.coordonnees.Adresse.pays = 'test';
        
        resourceRecord4.GestionRH = new WS11_Ressource.GestionRH();
        resourceRecord4.GestionRH.matriculeRhDk = '123';
        resourceRecord4.GestionRH.listReferentHierarchique = new List<WS11_Ressource.ReferentHierarchique>();
        ref.roleHierarchique = 'HIERA';
        ref.superieurHierarchique = 'HIERA';
        ref.datedebut = System.today()-1;
        resourceRecord4.GestionRH.listReferentHierarchique.add(ref);
        
        resourceRecord4.Emploi = new WS11_Ressource.emploi();
        resourceRecord4.Emploi.listFonction = new List<WS11_Ressource.Fonction>();
        fct.dateDebut = System.today()-1;
        fct.dateFin = System.today()+1;
        resourceRecord4.Emploi.listFonction.add(fct);
        
        resourceRecord4.Affectation = new WS11_Ressource.Affectation();
        resourceRecord4.Affectation.listFiliereDK = new List<WS11_Ressource.FiliereDK>();
        fil.dateDebut = System.today()-1;
        fil.dateFin = System.today()+1;
        fil.sousFiliere = 'test';
        fil.Filiere = 'test';
        resourceRecord4.Affectation.listFiliereDK.add(fil);
        
        resourceRecord4.Affectation.listOrganisation = new List<WS11_Ressource.Organisation>();
        org.dateDebut = System.today()-1;
        org.dateFin = System.today()+1;
        org.Organisation = 'test';
        resourceRecord4.Affectation.listOrganisation.add(org);
        
        resourceRecord4.Metadonnees = new WS11_Ressource.Metadonnees();
        resourceRecord4.Metadonnees.creationDate = System.today()-1;
        resourceRecord4.Metadonnees.creationId = '123';
        resourceRecord4.Metadonnees.updateDate = System.today()-1;
        resourceRecord4.Metadonnees.updateId = '123';
        resourceRecord4.Metadonnees.validationDate = System.today()-1;
        resourceRecord4.Metadonnees.validationId = '123';
        
        
        
        ///////////
        
        
        WS11_Ressource.Ressource resourceRecord5 = new WS11_Ressource.Ressource();
        
        resourceRecord5.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord5.ProprietesRessource.dkCodeRessource = 'K09352454545';
        resourceRecord5.ProprietesRessource.statut = 'OUV';
        resourceRecord5.ProprietesRessource.login = 'alain';
        
        resourceRecord5.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord5.etatCivil.nomUsage = 'alain';
        resourceRecord5.etatCivil.prenomUsage = 'alain';
        
        resourceRecord5.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord5.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord5.DonneesPersonelles.coordonnees.listEmail = new List<WS11_Ressource.Email>();
        mail.email='test@salesforce.com';
        mail.natureEmail = 'PRO';
        resourceRecord5.DonneesPersonelles.coordonnees.listEmail.add(mail);
        
        resourceRecord5.DonneesPersonelles.coordonnees.listLigne = new List<WS11_Ressource.ligne>();
        line.typeLigne = 'TELEPHONE';
        line.natureLigne = 'PRO';
        resourceRecord5.DonneesPersonelles.coordonnees.listLigne.add(line);
        
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse = new WS11_Ressource.Adresse();
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.natureAdresse = 'PRO';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.adresse1 = 'test';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.adresse2 = 'test';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.adresse3 = 'test';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.adresse4 = 'test';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.codePostal = 'test';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.ville = 'test';
        resourceRecord5.DonneesPersonelles.coordonnees.Adresse.pays = 'test';
        
        resourceRecord5.GestionRH = new WS11_Ressource.GestionRH();
        resourceRecord5.GestionRH.matriculeRhDk = '123';
        resourceRecord5.GestionRH.listReferentHierarchique = new List<WS11_Ressource.ReferentHierarchique>();
        ref.roleHierarchique = 'HIERA';
        ref.superieurHierarchique = 'HIERA';
        ref.datedebut = System.today()-1;
        resourceRecord5.GestionRH.listReferentHierarchique.add(ref);
        
        resourceRecord5.Emploi = new WS11_Ressource.emploi();
        resourceRecord5.Emploi.listFonction = new List<WS11_Ressource.Fonction>();
        fct.dateDebut = System.today()-1;
        fct.dateFin = System.today()+1;
        resourceRecord5.Emploi.listFonction.add(fct);
        
        resourceRecord5.Affectation = new WS11_Ressource.Affectation();
        resourceRecord5.Affectation.listFiliereDK = new List<WS11_Ressource.FiliereDK>();
        WS11_Ressource.FiliereDK fil1 = new WS11_Ressource.FiliereDK();
        fil1.dateDebut = System.today()+1;
        fil1.sousFiliere = 'test';
        fil1.Filiere = 'test';
        resourceRecord5.Affectation.listFiliereDK.add(fil1);
        
        resourceRecord5.Affectation.listOrganisation = new List<WS11_Ressource.Organisation>();
        org.dateDebut = System.today()-1;
        org.dateFin = System.today()+1;
        org.Organisation = 'test';
        WS11_Ressource.Organisation org1 = new WS11_Ressource.Organisation();
        org1.dateDebut = System.today()-1;
        org1.Organisation = 'test';
        resourceRecord5.Affectation.listOrganisation.add(org);
        resourceRecord5.Affectation.listOrganisation.add(org1);
        
        resourceRecord5.Metadonnees = new WS11_Ressource.Metadonnees();
        resourceRecord5.Metadonnees.creationDate = System.today()-1;
        resourceRecord5.Metadonnees.creationId = '123';
        resourceRecord5.Metadonnees.updateDate = System.today()-1;
        resourceRecord5.Metadonnees.updateId = '123';
        resourceRecord5.Metadonnees.validationDate = System.today()-1;
        resourceRecord5.Metadonnees.validationId = '123';
        
        
        
        WS11_Ressource.Ressource resourceRecord6 = new WS11_Ressource.Ressource();
        resourceRecord6.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord6.ProprietesRessource.dkCodeRessource = 'K0933246';
        resourceRecord6.ProprietesRessource.statut = 'OUV';
        resourceRecord6.ProprietesRessource.login = 'alain';
        
        resourceRecord6.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord6.etatCivil.nomUsage = 'alain';
        resourceRecord6.etatCivil.prenomUsage = 'alain';
        
        resourceRecord6.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord6.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord6.DonneesPersonelles.coordonnees.listEmail = new List<WS11_Ressource.Email>();
        mail.email='test@salesforce.com';
        mail.natureEmail = 'PRO';
        resourceRecord6.DonneesPersonelles.coordonnees.listEmail.add(mail);
        
        resourceRecord6.DonneesPersonelles.coordonnees.listLigne = new List<WS11_Ressource.ligne>();
        line.typeLigne = 'TELEPHONE';
        line.natureLigne = 'PRO';
        resourceRecord6.DonneesPersonelles.coordonnees.listLigne.add(line);
        
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse = new WS11_Ressource.Adresse();
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.natureAdresse = 'PRO';
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.adresse1 = null;
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.adresse2 = 'test';
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.adresse3 = 'test';
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.adresse4 = 'test';
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.codePostal = null;
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.ville = null;
        resourceRecord6.DonneesPersonelles.coordonnees.Adresse.pays = null;
        
        resourceRecord6.GestionRH = new WS11_Ressource.GestionRH();
        resourceRecord6.GestionRH.matriculeRhDk = '123';
        resourceRecord6.GestionRH.listReferentHierarchique = new List<WS11_Ressource.ReferentHierarchique>();
        ref.roleHierarchique = 'HIERA';
        ref.superieurHierarchique = 'HIERA';
        ref.datedebut = System.today()-1;
        resourceRecord6.GestionRH.listReferentHierarchique.add(ref);
        
        resourceRecord6.Emploi = new WS11_Ressource.emploi();
        resourceRecord6.Emploi.listFonction = new List<WS11_Ressource.Fonction>();
        fct.dateDebut = System.today()-1;
        fct.dateFin = System.today()+1;
        resourceRecord6.Emploi.listFonction.add(fct);
        
        resourceRecord6.Affectation = new WS11_Ressource.Affectation();
        resourceRecord6.Affectation.listFiliereDK = new List<WS11_Ressource.FiliereDK>();
        fil.dateDebut = System.today()-1;
        fil.dateFin = System.today()+1;
        fil.sousFiliere = null;
        fil.Filiere = null;
        resourceRecord6.Affectation.listFiliereDK.add(fil);
        
        resourceRecord6.Affectation.listOrganisation = new List<WS11_Ressource.Organisation>();
        org.dateDebut = System.today()-1;
        org.dateFin = System.today()+1;
        org.Organisation = 'test';
        resourceRecord6.Affectation.listOrganisation.add(org);
        
        resourceRecord6.Metadonnees = new WS11_Ressource.Metadonnees();
        resourceRecord6.Metadonnees.creationDate = System.today()-1;
        resourceRecord6.Metadonnees.creationId = '123';
        resourceRecord6.Metadonnees.updateDate = System.today()-1;
        resourceRecord6.Metadonnees.updateId = '123';
        resourceRecord6.Metadonnees.validationDate = System.today()-1;
        resourceRecord6.Metadonnees.validationId = '123';
        
        WS11_Ressource.Ressource resourceRecord7 = new WS11_Ressource.Ressource();
        
        resourceRecord7.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord7.ProprietesRessource.dkCodeRessource = '123333455';
        resourceRecord7.ProprietesRessource.statut = 'OUV';
        resourceRecord7.ProprietesRessource.login = 'alain';
        
        resourceRecord7.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord7.etatCivil.nomUsage = 'alain';
        resourceRecord7.etatCivil.prenomUsage = 'alain';
        
        resourceRecord7.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord7.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord7.DonneesPersonelles.coordonnees.listEmail = new List<WS11_Ressource.Email>();
        WS11_Ressource.Email mail2 = new WS11_Ressource.Email();
        mail2.email='test@salesforce.com';
        mail2.natureEmail = 'PRO';
        resourceRecord7.DonneesPersonelles.coordonnees.listEmail.add(mail2);
        
        WS11_Ressource.Email mail3 = new WS11_Ressource.Email();
        mail3.email=null;
        resourceRecord7.DonneesPersonelles.coordonnees.listEmail.add(mail3);
        
        WS11_Ressource.Ressource resourceRecord8 = new WS11_Ressource.Ressource();
        
        resourceRecord8.ProprietesRessource = new WS11_Ressource.ProprietesRessource();
        resourceRecord8.ProprietesRessource.dkCodeRessource = '12333455';
        resourceRecord8.ProprietesRessource.statut = 'OUV';
        resourceRecord8.ProprietesRessource.login = 'alain';
        
        resourceRecord8.etatCivil = new WS11_Ressource.EtatCivil();
        resourceRecord8.etatCivil.nomUsage = 'alain';
        resourceRecord8.etatCivil.prenomUsage = 'alain';
        
        resourceRecord8.DonneesPersonelles = new WS11_Ressource.DonneesPersonelles();
        resourceRecord8.DonneesPersonelles.coordonnees = new WS11_Ressource.coordonnees();
        resourceRecord8.DonneesPersonelles.coordonnees.listEmail = null;
        
        test.startTest();
        Response resp = WS11_Ressource.insertUpdateRessource(resourceRecord);
        Response resp2 = WS11_Ressource.insertUpdateRessource(resourceRecord2);
        Response resp3 = WS11_Ressource.insertUpdateRessource(resourceRecord3);
        Response resp4 = WS11_Ressource.insertUpdateRessource(resourceRecord4);
        Response resp5 = WS11_Ressource.insertUpdateRessource(resourceRecord5);
        Response resp6 = WS11_Ressource.insertUpdateRessource(resourceRecord6);
        Response resp7 = WS11_Ressource.insertUpdateRessource(resourceRecord7);
        Response resp8 = WS11_Ressource.insertUpdateRessource(resourceRecord8);
        test.stopTest();
        
    }
}