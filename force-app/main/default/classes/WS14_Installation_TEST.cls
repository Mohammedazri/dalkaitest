@isTest
private class WS14_Installation_TEST {
    
    @testSetup static void setup(){
        
        // Insertion de l'utilisateur de test (en tant que)
        Id testUserProfileId = [SELECT Id FROM Profile WHERE Id = :Label.AdminProfileId LIMIT 1].Id;
        User testUser = testUtils.createUser('testUIns', 'testUForInstallation@testorg.com', 'testUForInstallation', testUserProfileId, 'testUForInstallation@testorg.com');
        insert testUser;
    }
    
    @isTest static void upsertInstallationFullDataOK(){
        
        // Préparation et insertion des installations (de nature ZONE et SITE)
        List<Installation__c> installationList = new List<Installation__c>();
        
        Installation__c zone = new Installation__c(DKCodeInstallation__c = 'DKCODEZONE',
                                                 Name = 'ZON');
        
        Installation__c site = new Installation__c(DKCodeInstallation__c = 'DKCODESITE',
                                                 Name = 'SIT');
        
        installationList.add(zone);
        installationList.add(site);
        insert installationList;
        
        // Préparation et insertion d'un utilisateur téléopérateur
        Id teleoperateurId = [SELECT Id FROM Profile WHERE Name = 'Téléopérateur' LIMIT 1].Id;
        User teleoperateur = testUtils.createUser('jeanmins', 'jeaninst@testorg.com', 'jeanmartininst', teleoperateurId, 'jeanmartininst@testorg.com');
        teleoperateur.ReferentielId__c = 'JEAN_MARTIN_001';
        insert teleoperateur;
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testUForInstallation@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe (emplacement de nature BATIMENT)
            WS14_Installation.Installation installation = new WS14_Installation.Installation();
            
            // Attribut header
            installation.header = new Header();
            installation.header.transactionId = 'DJ5O3NFIG8';
            
            // Attribut proprietesInstallation
            installation.proprietesInstallation = new WS14_Installation.ProprietesInstallation();
            installation.proprietesInstallation.dkCodeInstallation = 'DKCODEBAT';
            installation.proprietesInstallation.codeInstallationDalkia = 'CODEInstall';
            installation.proprietesInstallation.codeInstallationDalkiaComplement = 'CODEInstallComp';
            installation.proprietesInstallation.libelleInstallation = 'Installation 01';
            installation.proprietesInstallation.installationSupprime = true;
            
            // Attribut listLienSite
            installation.listLienSite = new List<WS14_Installation.LienSite>();
            
            // Attribut listLienSite : lien actif
            installation.listLienSite.add(new WS14_Installation.LienSite());
            installation.listLienSite.get(0).dkCodeSite = 'DKCODESEE1';
            installation.listLienSite.get(0).statutLienSite = true;
            installation.listLienSite.get(0).dateCreationLienSite = DateTime.newInstanceGMT(2022, 09, 22);
            
            // Attribut listLienSite : lien inactif
            installation.listLienSite.add(new WS14_Installation.LienSite());
            installation.listLienSite.get(1).dkCodeSite = 'DKCODESEE2';
            installation.listLienSite.get(1).statutLienSite = false;
            installation.listLienSite.get(1).dateCreationLienSite = DateTime.newInstanceGMT(2022, 09, 18);
            
            // Attribut SystemeInstallation
            installation.listSystemeInstallation = new List<WS14_Installation.SystemeInstallation>();
            installation.listSystemeInstallation.add(new WS14_Installation.SystemeInstallation());
            installation.listSystemeInstallation.get(0).codeSystemeRDSPP = 'F01';
            installation.listSystemeInstallation.get(0).libelleSysteme = 'F01';
            installation.listSystemeInstallation.get(0).codeSystemeRDSPPParent = 'codeSystemeRDSPPParent';
            
            // Attribut operation
            installation.operation = new WS14_installation.Operation();
            installation.operation.criticiteInstallation = 'S';
            installation.operation.etatOperationnel = 'EXP';
            installation.operation.dureeAnnuelleFonctionnement = 'IFC2';
            installation.operation.modeGestionEnergetique = 'XCP';
            installation.operation.modeGestionTravauxInterne = 'XNA';
                      
            // Attribut service
            installation.service = new WS14_Installation.Service();
            installation.service.identifiantExterne = 'identifiantExterne';
            installation.service.libelleExterne = 'libelleExterne';
            installation.service.dkCodeSiteAlias = 'dkCodeSiteAlias';
            
            // Attribut listLienImputation
            installation.listLienImputation = new List<WS14_Installation.LienImputation>();
            installation.listLienImputation.add(new WS14_Installation.LienImputation());
            installation.listLienImputation.get(0).dkCodeTache = 'dkCodeTache';
            installation.listLienImputation.get(0).codeCategoriePrestation = 'codeCategoriePrestation';
            installation.listLienImputation.get(0).statutLienTacheFinance = true;
            installation.listLienImputation.get(0).dateModificationImputation = DateTime.newInstanceGMT(2022, 09, 22);
            
            // Attribut listTranscoCodesDI
            installation.listTranscoCodeDI = new List<WS14_Installation.TranscoCodeDI>();
            
            installation.listTranscoCodeDI.add(new WS14_Installation.TranscoCodeDI());
            installation.listTranscoCodeDI.get(0).codeDI = 'CODEDI_001';
            
            installation.listTranscoCodeDI.add(new WS14_Installation.TranscoCodeDI());
            installation.listTranscoCodeDI.get(1).codeDI = 'CODEDI_002';
            
            // Attribut metadonnees
            installation.metadonnees = new WS14_Installation.Metadonnees();
            installation.metadonnees.dateCreation = DateTime.newInstanceGMT(2021, 5, 10);
            installation.metadonnees.utilisateurCreation = 'JEAN_MARTIN_001';
            installation.metadonnees.dateModification = DateTime.newInstanceGMT(2021, 9, 23);
            installation.metadonnees.utilisateurModification = 'JEAN_MARTIN_001';
            
            Test.startTest();
            Response responseToAssert = WS14_Installation.upsertInstallation(installation);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Installation
            List<Installation__c> installationListToAssert = [SELECT Id, DKCodeInstallation__c, Name, LongName__c, 
                                                             InstallationSupprime__c, DKCodeSite__c,
                                                             DateCreationLienSite__c, CodeSystemeRDSPP__c, LibelleSysteme__c, CriticiteInstallation__c,
                                                             EtatOperationnel__c, DureeAnnuelleFonctionnement__c, ModeGestionEnergetique__c,
                                                             ModeGestionTravauxInterne__c,
                                                             CodesDI__c, DateCreation__c, UtilisateurCreation__c,
                                                             DateModification__c, UtilisateurModification__c
                                                            FROM Installation__c WHERE DKCodeInstallation__c = 'DKCODEBAT'];
            
            System.assertEquals(1, installationListToAssert.size());
            
            Installation__c installationToAssert = installationListToAssert.get(0);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut proprietesEmplacement
            System.assertEquals('Installation 01', installationToAssert.Name);
            System.assertEquals('Installation 01', installationToAssert.LongName__c);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut listLienSite
            System.assertEquals('DKCODESEE1', installationToAssert.DKCodeSite__c);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut systemeInstallation
            System.assertEquals('F01', installationToAssert.CodeSystemeRDSPP__c);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut operation
            System.assertEquals('S', installationToAssert.CriticiteInstallation__c);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut service
            //System.assertEquals('identifiantExterne', installationToAssert.IdentifiantExterne__c);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut listTranscoCodesDI
            System.assertEquals('CODEDI_001, CODEDI_002', installationToAssert.CodesDI__c);
            
            // Assertion de l'enregistrement de l'objet Installation__c : Attribut metadonnees
            System.assertEquals(DateTime.newInstanceGMT(2021, 5, 10), installationToAssert.DateCreation__c);
            System.assertEquals(teleoperateur.Id, installationToAssert.UtilisateurCreation__c);
            System.assertEquals(DateTime.newInstanceGMT(2021, 9, 23), installationToAssert.DateModification__c);
            System.assertEquals(teleoperateur.Id, installationToAssert.UtilisateurModification__c);
            
            // Assertion de l'enregistrement de l'objet WebserviceLog__c
            List<WebserviceLog__c> webServiceLogListToAssert = [SELECT Id, Flux__c, Type__c, Request__c, TransactionId__c,
                                                                DkCode__c, Statut__c, Response__c, ErrorText__c
                                                                FROM WebserviceLog__c];
            
            System.assertEquals(1, webServiceLogListToAssert.size());
            
            WebserviceLog__c webServiceLogToAssert = webServiceLogListToAssert.get(0);
            
            System.assertEquals(Label.WSTypeFluxEntrant, webServiceLogToAssert.Flux__c);
            System.assertEquals('upsertInstallation', webServiceLogToAssert.Type__c);
            System.assertEquals(String.valueOf(installation), webServiceLogToAssert.Request__c);
            System.assertEquals('DJ5O3NFIG8', webServiceLogToAssert.TransactionId__c);
            System.assertEquals('DKCODEBAT', webServiceLogToAssert.DkCode__c);
            System.assertEquals(Label.WS_Response_OK, webServiceLogToAssert.Statut__c);
            System.assertEquals(String.valueOf(responseToAssert), webServiceLogToAssert.Response__c);
            System.assertEquals(null, webServiceLogToAssert.ErrorText__c);
            
            // Assertion de la réponse du service
            System.assertEquals(false, responseToAssert.error);
            System.assertEquals(Label.WS_Response_OK, responseToAssert.responseCode);
            System.assertEquals('', responseToAssert.errorText);
        }
    }
  /*  
    @isTest static void upsertInstallationOptionalDataOK(){
        
        // Préparation et insertion d'un utilisateur téléopérateur
        Id teleoperateurId = [SELECT Id FROM Profile WHERE Name = 'Téléopérateur' LIMIT 1].Id;
        User teleoperateur = testUtils.createUser('jeanm', 'jean@testorg.com', 'jeanmartin', teleoperateurId, 'jeanmartin@testorg.com');
        teleoperateur.ReferentielId__c = 'JEAN_MARTIN_001';
        insert teleoperateur;
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testU@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe (emplacement de nature BATIMENT)
            WS13_Emplacement.Emplacement emplacement = new WS13_Emplacement.Emplacement();
            
            // Attribut proprietesEmplacement
            emplacement.proprietesEmplacement = new WS13_Emplacement.Proprietes_Emplacement();
            emplacement.proprietesEmplacement.dkCodeEmplacement = 'DKCODEBAT';
            emplacement.proprietesEmplacement.libelle = 'Emplacement 01';
            emplacement.proprietesEmplacement.natureEmplacement = 'BAT';
            emplacement.proprietesEmplacement.emplacementSupprime = true;
            
            // Attribut metadonnees
            emplacement.metadonnees = new WS13_Emplacement.Metadonnees();
            emplacement.metadonnees.dateCreation = DateTime.newInstanceGMT(2021, 5, 10);
            emplacement.metadonnees.utilisateurCreation = 'JEAN_MARTIN_001';
            
            Test.startTest();
            Response responseToAssert = WS13_Emplacement.upsertEmplacement(emplacement);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Emplacement__c
            List<Emplacement__c> emplacementListToAssert = [SELECT Id, DKCode_Emplacement__c, Name, Commentaire__c, Nature_Emplacement__c,
                                                            Emplacement_Supprime__c, DateCreation__c, UtilisateurCreation__c,
                                                            DateModification__c, UtilisateurModification__c
                                                            FROM Emplacement__c WHERE DKCode_Emplacement__c = 'DKCODEBAT'];
            
            System.assertEquals(1, emplacementListToAssert.size());
            
            Emplacement__c emplacementToAssert = emplacementListToAssert.get(0);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut proprietesEmplacement
            System.assertEquals('Emplacement 01', emplacementToAssert.Name);
            System.assertEquals('BAT', emplacementToAssert.Nature_Emplacement__c);
            System.assertEquals(true, emplacementToAssert.Emplacement_Supprime__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut metadonnees
            System.assertEquals(DateTime.newInstanceGMT(2021, 5, 10), emplacementToAssert.DateCreation__c);
            System.assertEquals(teleoperateur.Id, emplacementToAssert.UtilisateurCreation__c);
            
            // Assertion de l'enregistrement de l'objet WebserviceLog__c
            List<WebserviceLog__c> webServiceLogListToAssert = [SELECT Id, Flux__c, Type__c, Request__c, TransactionId__c,
                                                                DkCode__c, Statut__c, Response__c, ErrorText__c
                                                                FROM WebserviceLog__c];
            
            System.assertEquals(1, webServiceLogListToAssert.size());
            
            WebserviceLog__c webServiceLogToAssert = webServiceLogListToAssert.get(0);
            
            System.assertEquals(Label.WSTypeFluxEntrant, webServiceLogToAssert.Flux__c);
            System.assertEquals('upsertEmplacement', webServiceLogToAssert.Type__c);
            System.assertEquals(String.valueOf(emplacement), webServiceLogToAssert.Request__c);
            System.assertEquals(null, webServiceLogToAssert.TransactionId__c);
            System.assertEquals('DKCODEBAT', webServiceLogToAssert.DkCode__c);
            System.assertEquals(Label.WS_Response_OK, webServiceLogToAssert.Statut__c);
            System.assertEquals(String.valueOf(responseToAssert), webServiceLogToAssert.Response__c);
            System.assertEquals(null, webServiceLogToAssert.ErrorText__c);
            
            // Assertion de la réponse du service
            System.assertEquals(false, responseToAssert.error);
            System.assertEquals(Label.WS_Response_OK, responseToAssert.responseCode);
            System.assertEquals('', responseToAssert.errorText);
        }
    }
   */
    
    @isTest static void upsertEmplacementRequiredFieldKO(){
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testUForInstallation@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe (emplacement de nature BATIMENT)
            WS14_Installation.Installation installation = new WS14_Installation.Installation();
            
            // Attribut proprietesInstallation
            installation.proprietesInstallation = new WS14_Installation.ProprietesInstallation();
            
            // Attribut listLienSite
            installation.listLienSite = new List<WS14_Installation.LienSite>();            
            // Attribut listLienSite : lien actif
            installation.listLienSite.add(new WS14_Installation.LienSite());
            installation.listLienSite.add(new WS14_Installation.LienSite());
            installation.listLienSite.get(0).statutLienSite = true;
           
            // Attribut systemeinstallation
            installation.listSystemeInstallation = new List<WS14_Installation.SystemeInstallation>();
            installation.listSystemeInstallation.add(new WS14_Installation.SystemeInstallation());
                                   
            // Attribut operation
            installation.operation = new WS14_Installation.Operation();
           
            // Attribut listTranscoCodesDI
            installation.listTranscoCodeDI = new List<WS14_Installation.TranscoCodeDI>();
            installation.listTranscoCodeDI.add(new WS14_Installation.TranscoCodeDI());

            // Attribut metadonnees
            installation.metadonnees = new WS14_Installation.Metadonnees();
           
            
            Test.startTest();
            Response responseToAssert = WS14_Installation.upsertInstallation(installation);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Installation__c
            List<Installation__c> installationListToAssert = [SELECT Id FROM Installation__c WHERE DKCodeInstallation__c = 'DKCODEBAT'];
            System.assertEquals(0, installationListToAssert.size());
            
            // Assertion de l'enregistrement de l'objet WebserviceLog__c
            List<WebserviceLog__c> webServiceLogListToAssert = [SELECT Id, Flux__c, Type__c, Request__c, TransactionId__c,
                                                                DkCode__c, Statut__c, Response__c, ErrorText__c
                                                                FROM WebserviceLog__c];
            
            System.assertEquals(1, webServiceLogListToAssert.size());
            
            WebserviceLog__c webServiceLogToAssert = webServiceLogListToAssert.get(0);
            
            System.assertEquals(Label.WSTypeFluxEntrant, webServiceLogToAssert.Flux__c);
            System.assertEquals('upsertInstallation', webServiceLogToAssert.Type__c);
            System.assertEquals(String.valueOf(installation), webServiceLogToAssert.Request__c);
            System.assertEquals(null, webServiceLogToAssert.TransactionId__c);
            System.assertEquals(null, webServiceLogToAssert.DkCode__c);
            System.assertEquals(Label.WS_Response_KO, webServiceLogToAssert.Statut__c);
            System.assertEquals(String.valueOf(responseToAssert), webServiceLogToAssert.Response__c);
            
            String requiredFieldError = 'Le champ installation.proprietesInstallation.dkCodeInstallation est obligatoire' + '\n' +
                                'Le champ installation.proprietesInstallation.libelleInstallation est obligatoire' + '\n' +
                                'Le champ installation.listLienSite[].dkCodeSite est obligatoire' + '\n' +
                                'Le champ installation.listLienSite[].dateCreationLienSite est obligatoire' + '\n' +
                                'Le champ installation.listLienSite[].statutLienSite est obligatoire' + '\n' +
                                'Le champ installation.listSystemeInstallation[].codeSystemeRDSPP est obligatoire' + '\n' +
                                'Le champ installation.operation.criticiteInstallation est obligatoire' + '\n' +
                                'Le champ installation.operation.etatOperationnel est obligatoire' + '\n' +
                                'Le champ installation.operation.dureeAnnuelleFonctionnement est obligatoire' + '\n' +
                                'Le champ installation.operation.modeGestionEnergetique est obligatoire' + '\n' +
                                'Le champ installation.operation.modeGestionTravauxInterne est obligatoire' + '\n' +
                                //'Le champ installation.listTranscoCodeDI[].codeDI est obligatoire' + '\n' +
                                'Le champ installation.metadonnees[].dateCreation est obligatoire' + '\n' +
                                'Le champ installation.metadonnees[].utilisateurCreation est obligatoire' + '\n' ;                                
            
            //System.assertEquals(requiredFieldError.replace('\n', ' ').substring(0, 254), webServiceLogToAssert.ErrorText__c);

            // Assertion de la réponse du service
            System.assertEquals(true, responseToAssert.error);
            System.assertEquals(Label.WS_Response_KO, responseToAssert.responseCode);
            System.assertEquals(requiredFieldError, responseToAssert.errorText);
        }
    }
   
    
    @isTest static void upsertInstallationExceptionKO(){
        
        // Préparation et insertion d'un utilisateur téléopérateur
        Id teleoperateurId = [SELECT Id FROM Profile WHERE Name = 'Téléopérateur' LIMIT 1].Id;
        User teleoperateur = testUtils.createUser('jeanmin', 'jeanin@testorg.com', 'jeanmartinins', teleoperateurId, 'jeanmartinins@testorg.com');
        teleoperateur.ReferentielId__c = 'JEAN_MARTIN_001';
        insert teleoperateur;
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testUForInstallation@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe (emplacement de nature BATIMENT)
            WS14_Installation.Installation installation = new WS14_Installation.Installation();
            
            // Attribut proprietesEmplacement
            installation.proprietesInstallation = new WS14_Installation.ProprietesInstallation();
            installation.proprietesInstallation.dkCodeInstallation = 'DKCODEBAT';
            installation.proprietesInstallation.libelleInstallation = 'Emplacement 01';
            
            // Attribut metadonnees
            installation.metadonnees = new WS14_Installation.Metadonnees();
            installation.metadonnees.dateCreation = DateTime.newInstanceGMT(2021, 5, 10);
            installation.metadonnees.utilisateurCreation = 'JEAN_MARTIN_001';
            
            Test.startTest();
            Response responseToAssert = WS14_Installation.upsertInstallation(installation);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Installation
            List<Installation__c> installationListToAssert = [SELECT Id FROM Installation__c WHERE DKCodeInstallation__c = 'DKCODEBAT'];
            System.assertEquals(0, installationListToAssert.size());
            
            // Assertion de l'enregistrement de l'objet WebserviceLog__c
            List<WebserviceLog__c> webServiceLogListToAssert = [SELECT Id, Flux__c, Type__c, Request__c, TransactionId__c,
                                                                DkCode__c, Statut__c, Response__c, ErrorText__c
                                                                FROM WebserviceLog__c];
            
            System.assertEquals(1, webServiceLogListToAssert.size());
            
            WebserviceLog__c webServiceLogToAssert = webServiceLogListToAssert.get(0);
            
            System.assertEquals(Label.WSTypeFluxEntrant, webServiceLogToAssert.Flux__c);
            System.assertEquals('upsertInstallation', webServiceLogToAssert.Type__c);
            System.assertEquals(String.valueOf(installation), webServiceLogToAssert.Request__c);
            System.assertEquals(null, webServiceLogToAssert.TransactionId__c);
            System.assertEquals('DKCODEBAT', webServiceLogToAssert.DkCode__c);
            System.assertEquals(Label.WS_Response_KO, webServiceLogToAssert.Statut__c);
            System.assertEquals(String.valueOf(responseToAssert), webServiceLogToAssert.Response__c);
            System.assertEquals(false, webServiceLogToAssert.ErrorText__c.contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST'));
            
            // Assertion de la réponse du service
            System.assertEquals(true, responseToAssert.error);
            System.assertEquals(Label.WS_Response_KO, responseToAssert.responseCode);
            //System.assertEquals(true, responseToAssert.errorText.contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST'));
        }
    }
    
    @isTest static void upsertInstallationFieldNotUsed(){
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testUForInstallation@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe
            WS14_Installation.Installation installation = new WS14_Installation.Installation();
            
            // Attribut proprietesInstallation
            installation.proprietesInstallation = new WS14_Installation.ProprietesInstallation();
            installation.proprietesInstallation.determinationGrandeurTechnique = null;
            installation.proprietesInstallation.statutImputation = null;
            installation.proprietesInstallation.ficheTechnique = null;
            
            // Attribut service
            installation.service = new WS14_Installation.Service();
            installation.service.identifiantExterne = null;
            
            // Attribut lienImputation
            installation.listLienImputation = new List<WS14_Installation.LienImputation>();
            installation.listLienImputation.add(new WS14_Installation.LienImputation());
            installation.listLienImputation.get(0).dkCodeTache = null;
            
            // Attribut metadonnees
            installation.metadonnees = new WS14_Installation.Metadonnees();
            installation.metadonnees.dateValidation = null;
            installation.metadonnees.utilisateurValidation = null;
        }
    }
}