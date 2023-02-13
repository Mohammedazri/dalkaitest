@isTest
private class WS13_Emplacement_TEST {
    
    @testSetup static void setup(){
        
        // Insertion de l'utilisateur de test (en tant que)
        Id testUserProfileId = [SELECT Id FROM Profile WHERE Id = :Label.AdminProfileId LIMIT 1].Id;
        User testUser = testUtils.createUser('testU', 'testU@testorg.com', 'testU', testUserProfileId, 'testU@testorg.com');
        insert testUser;
    }
    
    @isTest static void upsertEmplacementFullDataOK(){
        
        // Préparation et insertion des emplacements (de nature ZONE et SITE)
        List<Emplacement__c> emplacementList = new List<Emplacement__c>();
        
        Emplacement__c zone = new Emplacement__c(DKCode_Emplacement__c = 'DKCODEZONE',
                                                 Nature_Emplacement__c = 'ZON');
        
        Emplacement__c site = new Emplacement__c(DKCode_Emplacement__c = 'DKCODESITE',
                                                 Nature_Emplacement__c = 'SIT');
        
        emplacementList.add(zone);
        emplacementList.add(site);
        insert emplacementList;
        
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
            
            // Attribut header
            emplacement.header = new Header();
            emplacement.header.transactionId = 'DJ5O3NFIG8';
            
            // Attribut proprietesEmplacement
            emplacement.proprietesEmplacement = new WS13_Emplacement.Proprietes_Emplacement();
            emplacement.proprietesEmplacement.dkCodeEmplacement = 'DKCODEBAT';
            emplacement.proprietesEmplacement.libelle = 'Emplacement 01';
            emplacement.proprietesEmplacement.commentaire = 'Haec ubi latius fama vulgasset missaeque relationes adsiduae' +
                'Gallum Caesarem permovissent, quoniam magister equitum longi' +
                'ea tempestate distinebatur, iussus comes orientis Nebridiusf' +
                'contractis undique militaribus copiis ad eximendam periculos' +
                'civitatem amplam et oportunam studio properabat ingenti, quo' +
                'cognito abscessere latrones nulla re amplius memorabili gest' +
                'dispersique ut solent avia montium petiere celsorum.';
            emplacement.proprietesEmplacement.natureEmplacement = 'BAT';
            emplacement.proprietesEmplacement.emplacementSupprime = true;
            emplacement.proprietesEmplacement.idBim = 'IDBIM';
            emplacement.proprietesEmplacement.telephone = '0132434556';
            emplacement.proprietesEmplacement.statutService = 'PS1';
            
            // Attribut listLienSee
            emplacement.listLienSee = new List<WS13_Emplacement.Lien_See>();
            
            // Attribut listLienSee : lien actif
            emplacement.listLienSee.add(new WS13_Emplacement.Lien_See());
            emplacement.listLienSee.get(0).dkCodeSee = 'DKCODESEE1';
            emplacement.listLienSee.get(0).statutLienSee = true;
            emplacement.listLienSee.get(0).dateCreationLienSee = DateTime.newInstanceGMT(2022, 3, 22);
            
            // Attribut listLienSee : lien inactif
            emplacement.listLienSee.add(new WS13_Emplacement.Lien_See());
            emplacement.listLienSee.get(1).dkCodeSee = 'DKCODESEE2';
            emplacement.listLienSee.get(1).statutLienSee = false;
            emplacement.listLienSee.get(1).dateCreationLienSee = DateTime.newInstanceGMT(2022, 1, 22);
            
            // Attribut arborescenceEmplacement
            emplacement.arborescenceEmplacement = new WS13_Emplacement.Arborescence_Emplacement();
            emplacement.arborescenceEmplacement.dkCodeEmplacementParent = 'DKCODEZONE';
            emplacement.arborescenceEmplacement.dkCodeEmplacementSite = 'DKCODESITE';
            
            // Attribut usageEmplacement
            emplacement.usageEmplacement = new WS13_Emplacement.Usage_Emplacement();
            emplacement.usageEmplacement.usage = 'U1201';
            emplacement.usageEmplacement.dimensionUsage = 5;
            
            // Attribut listEmplacementAcces
            emplacement.listEmplacementAcces = new List<WS13_Emplacement.Emplacement_Acces>();
            
            // Attribut listEmplacementAcces : adresse principale (accès général)
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            emplacement.listEmplacementAcces.get(0).dkCodeAdresse = 'DKCODEADR1';
            emplacement.listEmplacementAcces.get(0).numeroVoie = '1';
            emplacement.listEmplacementAcces.get(0).typeVoie = 'rue';
            emplacement.listEmplacementAcces.get(0).libelleVoie = 'de la pomme';
            emplacement.listEmplacementAcces.get(0).complementAdresse = 'immeuble A';
            emplacement.listEmplacementAcces.get(0).codePostal = '75001';
            emplacement.listEmplacementAcces.get(0).ville = 'PARIS';
            emplacement.listEmplacementAcces.get(0).pays = 'FRANCE';
            
            emplacement.listEmplacementAcces.get(0).listNatureAccesDalkia = new List<WS13_Emplacement.Nature_Acces_Dalkia>();
            emplacement.listEmplacementAcces.get(0).listNatureAccesDalkia.add(new WS13_Emplacement.Nature_Acces_Dalkia());
            emplacement.listEmplacementAcces.get(0).listNatureAccesDalkia.get(0).natureAccesDalkia = 'GEN';
            
            // Attribut listEmplacementAcces : adresse secondaire
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            emplacement.listEmplacementAcces.get(1).dkCodeAdresse = 'DKCODEADR2';
            emplacement.listEmplacementAcces.get(1).numeroVoie = '2';
            emplacement.listEmplacementAcces.get(1).typeVoie = 'avenue';
            emplacement.listEmplacementAcces.get(1).libelleVoie = 'des pompiers';
            emplacement.listEmplacementAcces.get(1).complementAdresse = 'accès C';
            emplacement.listEmplacementAcces.get(1).codePostal = '75001';
            emplacement.listEmplacementAcces.get(1).ville = 'PARIS';
            emplacement.listEmplacementAcces.get(1).pays = 'FRANCE';
            
            // Attribut listEmplacementAcces : adresse secondaire : liste des accès
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia = new List<WS13_Emplacement.Nature_Acces_Dalkia>();
            
            // Attribut listEmplacementAcces : adresse secondaire (accès Interventions)
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia.add(new WS13_Emplacement.Nature_Acces_Dalkia());
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia.get(0).natureAccesDalkia = 'INT';
            
            // Attribut listEmplacementAcces : adresse secondaire (accès Livraison combustible)
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia.add(new WS13_Emplacement.Nature_Acces_Dalkia());
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia.get(1).natureAccesDalkia = 'LIV';
            
            // Attribut genieCivil
            emplacement.genieCivil = new WS13_Emplacement.Genie_Civil();
            emplacement.genieCivil.anneeFinConstruction = 2004;
            emplacement.genieCivil.etiquetteEnergie = 'A';
            emplacement.genieCivil.etiquetteClimat = 'B';
            
            // Attribut operation
            emplacement.operation = new WS13_Emplacement.Operation();
            emplacement.operation.systemeSTIRequis = true;
            emplacement.operation.risqueLegionelle = true;
            emplacement.operation.risqueRayonnementsIonisants = true;
            emplacement.operation.risquePoussiereZoneAtex = true;
            emplacement.operation.risqueAmiante = true;
            emplacement.operation.dkCodeEntiteExploitation = 'DKCODEEXPL';
            
            // Attribut service
            emplacement.service = new WS13_Emplacement.Service();
            emplacement.service.identifiantExterne = 'SERVICE01';
            emplacement.service.libelleExterne = 'Service 01';
            emplacement.service.emplacementAlias = 'SERV01';
            
            // Attribut listTranscoCodesDI
            emplacement.listTranscoCodesDI = new List<WS13_Emplacement.Transco_CodesDI>();
            
            emplacement.listTranscoCodesDI.add(new WS13_Emplacement.Transco_CodesDI());
            emplacement.listTranscoCodesDI.get(0).codeDI = 'CODEDI_001';
            
            emplacement.listTranscoCodesDI.add(new WS13_Emplacement.Transco_CodesDI());
            emplacement.listTranscoCodesDI.get(1).codeDI = 'CODEDI_002';
            
            // Attribut metadonnees
            emplacement.metadonnees = new WS13_Emplacement.Metadonnees();
            emplacement.metadonnees.dateCreation = DateTime.newInstanceGMT(2021, 5, 10);
            emplacement.metadonnees.utilisateurCreation = 'JEAN_MARTIN_001';
            emplacement.metadonnees.dateModification = DateTime.newInstanceGMT(2021, 9, 23);
            emplacement.metadonnees.utilisateurModification = 'JEAN_MARTIN_001';
            
            Test.startTest();
            Response responseToAssert = WS13_Emplacement.upsertEmplacement(emplacement);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Emplacement__c
            List<Emplacement__c> emplacementListToAssert = [SELECT Id, DKCode_Emplacement__c, Name, Commentaire__c, Nature_Emplacement__c,
                                                            Emplacement_Supprime__c, Telephone__c, IdBim__c, StatutService__c, DKCode_SEE__c,
                                                            DateCreationLienSee__c, DKCode_Emplacement_Parent__c, EmplacementParent__c,
                                                            DKCode_Emplacement_Site__c, EmplacementSite__c, Usage__c, DimensionUsage__c,
                                                            DKCodeAdresse__c, Numero_Voie__c, Type_Voie__c, Libelle_Voie__c,
                                                            Complement_Adresse__c, Code_Postal__c, Ville__c, Pays__c,
                                                            AdresseSecondaire__c, AnneeFinConstruction__c, EtiquetteEnergie__c,
                                                            EtiquetteClimat__c, SystemeStiRequis__c, RisqueLegionnelle__c,
                                                            RisqueRayonnementsIonisants__c, RisquePoussiereZoneAtex__c, RisqueAmiante__c,
                                                            DKCode_Entite_Exploitation__c, ServiceIdentifiantExterne__c, ServiceLibelleExterne__c,
                                                            ServiceEmplacementAlias__c, CodesDI__c, DateCreation__c, UtilisateurCreation__c,
                                                            DateModification__c, UtilisateurModification__c
                                                            FROM Emplacement__c WHERE DKCode_Emplacement__c = 'DKCODEBAT'];
            
            System.assertEquals(1, emplacementListToAssert.size());
            
            Emplacement__c emplacementToAssert = emplacementListToAssert.get(0);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut proprietesEmplacement
            System.assertEquals('Emplacement 01', emplacementToAssert.Name);
            System.assertEquals('Haec ubi latius fama vulgasset missaeque relationes adsiduae' +
                                'Gallum Caesarem permovissent, quoniam magister equitum longi' +
                                'ea tempestate distinebatur, iussus comes orientis Nebridiusf' +
                                'contractis undique militaribus copiis ad eximendam periculos' +
                                'civitatem amplam et oportunam studio properabat ingenti, quo' +
                                'cognito abscessere latrones nulla re amplius memorabili gest' +
                                'dispersique ut solent avia montium petiere celsorum.', emplacementToAssert.Commentaire__c);
            System.assertEquals('BAT', emplacementToAssert.Nature_Emplacement__c);
            System.assertEquals(true, emplacementToAssert.Emplacement_Supprime__c);
            System.assertEquals('0132434556', emplacementToAssert.Telephone__c);
            System.assertEquals('IDBIM', emplacementToAssert.IdBim__c);
            System.assertEquals('PS1', emplacementToAssert.StatutService__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut listLienSee
            System.assertEquals('DKCODESEE1', emplacementToAssert.DKCode_SEE__c);
            System.assertEquals(DateTime.newInstanceGMT(2022, 3, 22), emplacementToAssert.DateCreationLienSee__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut arborescenceEmplacement
            System.assertEquals('DKCODEZONE', emplacementToAssert.DKCode_Emplacement_Parent__c);
            System.assertEquals(zone.Id, emplacementToAssert.EmplacementParent__c);
            System.assertEquals('DKCODESITE', emplacementToAssert.DKCode_Emplacement_Site__c);
            System.assertEquals(site.Id, emplacementToAssert.EmplacementSite__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut usageEmplacement
            System.assertEquals('U1201', emplacementToAssert.Usage__c);
            System.assertEquals(5, emplacementToAssert.DimensionUsage__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut listEmplacementAcces
            System.assertEquals('DKCODEADR1', emplacementToAssert.DKCodeAdresse__c);
            System.assertEquals('1', emplacementToAssert.Numero_Voie__c);
            System.assertEquals('rue', emplacementToAssert.Type_Voie__c);
            System.assertEquals('de la pomme', emplacementToAssert.Libelle_Voie__c);
            System.assertEquals('immeuble A', emplacementToAssert.Complement_Adresse__c);
            System.assertEquals('75001', emplacementToAssert.Code_Postal__c);
            System.assertEquals('PARIS', emplacementToAssert.Ville__c);
            System.assertEquals('FRANCE', emplacementToAssert.Pays__c);
            System.assertEquals('INTERVENTIONS' + '\n' +
                                'LIVRAISON COMBUSTIBLE' + '\n' +
                                '2 avenue des pompiers' + '\n' +
                                'accès C' + '\n' +
                                '75001 PARIS' + '\n' +
                                'FRANCE', emplacementToAssert.AdresseSecondaire__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut genieCivil
            System.assertEquals('2004', emplacementToAssert.AnneeFinConstruction__c);
            System.assertEquals('A', emplacementToAssert.EtiquetteEnergie__c);
            System.assertEquals('B', emplacementToAssert.EtiquetteClimat__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut operation
            System.assertEquals(true, emplacementToAssert.SystemeStiRequis__c);
            System.assertEquals(true, emplacementToAssert.RisqueLegionnelle__c);
            System.assertEquals(true, emplacementToAssert.RisqueRayonnementsIonisants__c);
            System.assertEquals(true, emplacementToAssert.RisquePoussiereZoneAtex__c);
            System.assertEquals(true, emplacementToAssert.RisqueAmiante__c);
            System.assertEquals('DKCODEEXPL', emplacementToAssert.DKCode_Entite_Exploitation__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut service
            System.assertEquals('SERVICE01', emplacementToAssert.ServiceIdentifiantExterne__c);
            System.assertEquals('Service 01', emplacementToAssert.ServiceLibelleExterne__c);
            System.assertEquals('SERV01', emplacementToAssert.ServiceEmplacementAlias__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut listTranscoCodesDI
            System.assertEquals('CODEDI_001, CODEDI_002', emplacementToAssert.CodesDI__c);
            
            // Assertion de l'enregistrement de l'objet Emplacement__c : Attribut metadonnees
            System.assertEquals(DateTime.newInstanceGMT(2021, 5, 10), emplacementToAssert.DateCreation__c);
            System.assertEquals(teleoperateur.Id, emplacementToAssert.UtilisateurCreation__c);
            System.assertEquals(DateTime.newInstanceGMT(2021, 9, 23), emplacementToAssert.DateModification__c);
            System.assertEquals(teleoperateur.Id, emplacementToAssert.UtilisateurModification__c);
            
            // Assertion de l'enregistrement de l'objet WebserviceLog__c
            List<WebserviceLog__c> webServiceLogListToAssert = [SELECT Id, Flux__c, Type__c, Request__c, TransactionId__c,
                                                                DkCode__c, Statut__c, Response__c, ErrorText__c
                                                                FROM WebserviceLog__c];
            
            System.assertEquals(1, webServiceLogListToAssert.size());
            
            WebserviceLog__c webServiceLogToAssert = webServiceLogListToAssert.get(0);
            
            System.assertEquals(Label.WSTypeFluxEntrant, webServiceLogToAssert.Flux__c);
            System.assertEquals('upsertEmplacement', webServiceLogToAssert.Type__c);
            System.assertEquals(String.valueOf(emplacement), webServiceLogToAssert.Request__c);
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
    
    @isTest static void upsertEmplacementOptionalDataOK(){
        
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
    
    @isTest static void upsertEmplacementRequiredFieldKO(){
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testU@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe (emplacement de nature BATIMENT)
            WS13_Emplacement.Emplacement emplacement = new WS13_Emplacement.Emplacement();
            
            // Attribut proprietesEmplacement
            emplacement.proprietesEmplacement = new WS13_Emplacement.Proprietes_Emplacement();
            
            // Attribut listLienSee
            emplacement.listLienSee = new List<WS13_Emplacement.Lien_See>();
            
            // Attribut listLienSee : lien actif
            emplacement.listLienSee.add(new WS13_Emplacement.Lien_See());
            emplacement.listLienSee.add(new WS13_Emplacement.Lien_See());
            emplacement.listLienSee.get(0).statutLienSee = true;
            
            // Attribut arborescenceEmplacement
            emplacement.arborescenceEmplacement = new WS13_Emplacement.Arborescence_Emplacement();
            
            // Attribut usageEmplacement
            emplacement.usageEmplacement = new WS13_Emplacement.Usage_Emplacement();
            
            // Attribut listEmplacementAcces
            emplacement.listEmplacementAcces = new List<WS13_Emplacement.Emplacement_Acces>();
            
            // Attribut listEmplacementAcces : adresse principale
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            
            emplacement.listEmplacementAcces.get(0).listNatureAccesDalkia = new List<WS13_Emplacement.Nature_Acces_Dalkia>();
            emplacement.listEmplacementAcces.get(0).listNatureAccesDalkia.add(new WS13_Emplacement.Nature_Acces_Dalkia());
            emplacement.listEmplacementAcces.get(0).listNatureAccesDalkia.get(0).natureAccesDalkia = 'GEN';
            
            // Attribut listEmplacementAcces : adresse secondaire
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia = new List<WS13_Emplacement.Nature_Acces_Dalkia>();
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia.add(new WS13_Emplacement.Nature_Acces_Dalkia());
            emplacement.listEmplacementAcces.get(1).listNatureAccesDalkia.get(0).natureAccesDalkia = 'INT';
            
            // Attribut listEmplacementAcces : adresse secondaire
            emplacement.listEmplacementAcces.get(2).listNatureAccesDalkia = new List<WS13_Emplacement.Nature_Acces_Dalkia>();
            emplacement.listEmplacementAcces.get(2).listNatureAccesDalkia.add(new WS13_Emplacement.Nature_Acces_Dalkia());
            
            // Attribut genieCivil
            emplacement.genieCivil = new WS13_Emplacement.Genie_Civil();
            
            // Attribut operation
            emplacement.operation = new WS13_Emplacement.Operation();
            
            // Attribut service
            emplacement.service = new WS13_Emplacement.Service();
            
            // Attribut listTranscoCodesDI
            emplacement.listTranscoCodesDI = new List<WS13_Emplacement.Transco_CodesDI>();
            emplacement.listTranscoCodesDI.add(new WS13_Emplacement.Transco_CodesDI());
            
            // Attribut metadonnees
            emplacement.metadonnees = new WS13_Emplacement.Metadonnees();
            
            Test.startTest();
            Response responseToAssert = WS13_Emplacement.upsertEmplacement(emplacement);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Emplacement__c
            List<Emplacement__c> emplacementListToAssert = [SELECT Id FROM Emplacement__c WHERE DKCode_Emplacement__c = 'DKCODEBAT'];
            System.assertEquals(0, emplacementListToAssert.size());
            
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
            System.assertEquals(null, webServiceLogToAssert.DkCode__c);
            System.assertEquals(Label.WS_Response_KO, webServiceLogToAssert.Statut__c);
            System.assertEquals(String.valueOf(responseToAssert), webServiceLogToAssert.Response__c);
            
            String requiredFieldError = 'Le champ emplacement.proprietesEmplacement.dkCodeEmplacement est obligatoire' + '\n' +
                                'Le champ emplacement.proprietesEmplacement.libelle est obligatoire' + '\n' +
                                'Le champ emplacement.proprietesEmplacement.natureEmplacement est obligatoire' + '\n' +
                                'Le champ emplacement.proprietesEmplacement.emplacementSupprime est obligatoire' + '\n' +
                                'Le champ emplacement.listLienSee[].dkCodeSee est obligatoire' + '\n' +
                                'Le champ emplacement.listLienSee[].dateCreationLienSee est obligatoire' + '\n' +
                                'Le champ emplacement.listLienSee[].statutLienSee est obligatoire' + '\n' +
                                'Le champ emplacement.arborescenceEmplacement[].dkCodeEmplacementParent est obligatoire' + '\n' +
                                'Le champ emplacement.arborescenceEmplacement[].dkCodeEmplacementSite est obligatoire' + '\n' +
                                'Le champ emplacement.usageEmplacement.usage est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].dkCodeAdresse est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].typeVoie est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].libelleVoie est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].codePostal est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].ville est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].pays est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].typeVoie est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].libelleVoie est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].codePostal est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].ville est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].pays est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].listNatureAccesDalkia[].natureAccesDalkia est obligatoire' + '\n' +
                                'Le champ emplacement.emplacementAcces[].listNatureAccesDalkia[] est obligatoire' + '\n' +
                                'Le champ emplacement.listTranscoCodesDI[].codeDI est obligatoire' + '\n' +
                                'Le champ emplacement.metadonnees[].dateCreation est obligatoire' + '\n' +
                                'Le champ emplacement.metadonnees[].utilisateurCreation est obligatoire' + '\n';
            
            System.assertEquals(requiredFieldError.replace('\n', ' ').substring(0, 254), webServiceLogToAssert.ErrorText__c);

            // Assertion de la réponse du service
            System.assertEquals(true, responseToAssert.error);
            System.assertEquals(Label.WS_Response_KO, responseToAssert.responseCode);
            System.assertEquals(requiredFieldError, responseToAssert.errorText);
        }
    }
    
    @isTest static void upsertEmplacementExceptionKO(){
        
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
            emplacement.proprietesEmplacement.natureEmplacement = 'Valeur de picklist non existante';
            emplacement.proprietesEmplacement.emplacementSupprime = true;
            
            // Attribut metadonnees
            emplacement.metadonnees = new WS13_Emplacement.Metadonnees();
            emplacement.metadonnees.dateCreation = DateTime.newInstanceGMT(2021, 5, 10);
            emplacement.metadonnees.utilisateurCreation = 'JEAN_MARTIN_001';
            
            Test.startTest();
            Response responseToAssert = WS13_Emplacement.upsertEmplacement(emplacement);
            Test.stopTest();
            
            // Assertion de l'enregistrement de l'objet Emplacement__c
            List<Emplacement__c> emplacementListToAssert = [SELECT Id FROM Emplacement__c WHERE DKCode_Emplacement__c = 'DKCODEBAT'];
            System.assertEquals(0, emplacementListToAssert.size());
            
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
            System.assertEquals(Label.WS_Response_KO, webServiceLogToAssert.Statut__c);
            System.assertEquals(String.valueOf(responseToAssert), webServiceLogToAssert.Response__c);
            System.assertEquals(true, webServiceLogToAssert.ErrorText__c.contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST'));
            
            // Assertion de la réponse du service
            System.assertEquals(true, responseToAssert.error);
            System.assertEquals(Label.WS_Response_KO, responseToAssert.responseCode);
            System.assertEquals(true, responseToAssert.errorText.contains('INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST'));
        }
    }
    
    @isTest static void upsertEmplacementFieldNotUsed(){
        
        // Récupération de l'utilisateur de test (en tant que)
        User testUser = [SELECT Id FROM User WHERE Username = 'testU@testorg.com'];
        
        System.runAs(testUser){
            
            // Préparation de l'enveloppe
            WS13_Emplacement.Emplacement emplacement = new WS13_Emplacement.Emplacement();
            
            // Attribut proprietesEmplacement
            emplacement.proprietesEmplacement = new WS13_Emplacement.Proprietes_Emplacement();
            emplacement.proprietesEmplacement.statutEmplacement = null;
            emplacement.proprietesEmplacement.statutImputation = null;
            
            // Attribut erpSite
            emplacement.erpSite = new WS13_Emplacement.ERP_Site();
            emplacement.erpSite.siteERP = null;
            emplacement.erpSite.natureERP = null;
            emplacement.erpSite.categorieERP = null;
            
            // Attribut partenaireSite
            emplacement.partenaireSite = new WS13_Emplacement.Partenaire_Site();
            emplacement.partenaireSite.dkCodePartenaire = null;
            
            // Attribut listEmplacementAcces
            emplacement.listEmplacementAcces = new List<WS13_Emplacement.Emplacement_Acces>();
            emplacement.listEmplacementAcces.add(new WS13_Emplacement.Emplacement_Acces());
            emplacement.listEmplacementAcces.get(0).codeCanton = null;
            emplacement.listEmplacementAcces.get(0).codeINSEE = null;
            emplacement.listEmplacementAcces.get(0).geoCodageAdresse = new WS13_Emplacement.GeoCodage_Adresse();
            emplacement.listEmplacementAcces.get(0).geoCodageAdresse.longitude = null;
            emplacement.listEmplacementAcces.get(0).geoCodageAdresse.lattitude = null;
            emplacement.listEmplacementAcces.get(0).geoCodageAdresse.qualiteGeocodage = null;
            emplacement.listEmplacementAcces.get(0).metadonnees = new WS13_Emplacement.Metadonnees();
            
            // Attribut siteMeteo
            emplacement.siteMeteo = new WS13_Emplacement.Site_Meteo();
            emplacement.siteMeteo.zoneClimatique = null;
            emplacement.siteMeteo.stationMeteo = null;
            emplacement.siteMeteo.stationMeteoLocale = null;
            
            
            // Attribut genieCivil
            emplacement.genieCivil = new WS13_Emplacement.Genie_Civil();
            emplacement.genieCivil.surfaceCadastrale = null;
            emplacement.genieCivil.surfaceShob = null;
            emplacement.genieCivil.surfaceShon = null;
            emplacement.genieCivil.surfaceShonRT = null;
            emplacement.genieCivil.hauteurConstruction = null;
            emplacement.genieCivil.igh = null;
            emplacement.genieCivil.classeIGH = null;
            emplacement.genieCivil.anneeRenovationBati = null;
            
            
            // Attribut operation
            emplacement.operation = new WS13_Emplacement.Operation();
            emplacement.operation.environnementSpecifique = null;
            emplacement.operation.datePriseEnChargeExploitation = null;
            emplacement.operation.dateRestitutionExploitation = null;
            emplacement.operation.presenceDalkia = null;
            emplacement.operation.releveEnergetique = null;
            
            // Attribut listImputations
            emplacement.listImputations = new List<WS13_Emplacement.Imputations>();
            emplacement.listImputations.add(new WS13_Emplacement.Imputations());
            emplacement.listImputations.get(0).dkCodeTache = null;
            emplacement.listImputations.get(0).categoriePrestation = null;
            emplacement.listImputations.get(0).statutLienTacheFinance = null;
            emplacement.listImputations.get(0).dateCreationImputation = null;
            emplacement.listImputations.get(0).transcoCodeDI = null;
            
            // Attribut securiteSite
            emplacement.securiteSite = new WS13_Emplacement.SecuriteSite();
            emplacement.securiteSite.environnementUrbain = null;
            emplacement.securiteSite.niveauOccupation = null;
            emplacement.securiteSite.numInscriptionRegistreSP = null;
            emplacement.securiteSite.numRegistreEuropeenCO2 = null;
            emplacement.securiteSite.idUniqueEutlSiteClasse = null;
            emplacement.securiteSite.codeGidicSiteClasse = null;
            emplacement.securiteSite.statutSeveso = null;
        }
    }
}