/**
 * @author Jimmy Khalil - EIT Mena
 * @date 01/12/2022
 * @description Test Utils C360
 */@isTest
public class testUtilsC360 {

    //Create User
    //Input: Alias,Email,LastName,ProfileId,Username
    //Example 'standt18', 'batch133User@testorg1.com', 'Testing', Label.AdminProfileId, 'batch133User@testorg1.com'
    public static User createUser(string Alias, string Email, string LastName, Id ProfileId, string UserName){
        return new User(Alias = Alias,
                        Email = Email,
                        EmailEncodingKey = 'UTF-8',
                        LastName = LastName,
                        LanguageLocaleKey = 'en_US',
                        LocaleSidKey = 'en_US',
                        ProfileId = ProfileId,
                        TimeZoneSidKey = 'America/Los_Angeles',
                        UserName = UserName,
                        Phone = '000',
                        Title = 'Mr',
                        Department = 'test'  );
    }

    //Add all bypasses to user
    //Input: User
    //Example: creating the user that will run a batch for RDD
    //put this method right before system.runAs because it will update the PAD.PAD_BypassTrigger
    public static User bypassUser(User currUser){
        Schema.DescribeSObjectResult objSchema = User.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        List<Schema.Picklistentry> fld = fieldmap.get('Bypass_Triggers__c').getDescribe().getpicklistValues();
        //System.debug('fld'+fld);
        List<String> pickList = new List<String>();

        for(Schema.Picklistentry pl : fld) {
            pickList.add(pl.getValue());
        }

        currUser.Bypass_Triggers__c = String.join(pickList, ';');
        currUser.Bypass_Workflow__c = true;
        currUser.BypassDuplicateRules__c = true;
        currUser.BypassFilters__c = true;
        currUser.BypassProcessBuilder__c = true;
        currUser.BypassValidationRules__c = true;
        currUser.BypassFlow__c = true;

        return currUser;
    }

    //Create Agence
    //Input: Name, Code, DKCode
    public static Agence__c createAgence(string AgenceName, string Code, string DKcode){
        return new Agence__c(Name = AgenceName,
                             Code_Agence__c = Code,
                             dkcode__c = DKcode);
    }

    //Create Account
    //Input: Name, BillingCountry, Type, Statut, Siegesocialpartenaire(=true for societe de vente),Categoriepartenaire(=DLK for societe de vente and =EDF for others)
    //Example Partenaire: 'testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345'
    //Example societe vente: 'testAccountSociete', 'Lebanon', 'Privé', Label.WS11_OUV, true, 'DLK', '112233'
    public static Account createAccount(string AccountName, string BillingCountry, string Type, String Statut, Boolean Siegesocialpartenaire, String Categoriepartenaire, String siret, String dkcode){

        if(Type == 'Public') {
            Type = 'PUB';
        } else if(Type == 'Privé') {
            Type = 'PRV';
        }

        return new Account(Name = AccountName,
                           Type_immatriculation__c  = 'RCS',
                           BillingCountry = BillingCountry,
                           Type = Type,
                           Code_NACE__c = '22',
                           NaturePartenaire__c = 'ETAB',
                           SIRET__c = siret,
                           Segment_client__c = 'SCL02' /*,Sous_segment_client__c='SCL04B'*/,
                           Categorie_partenaire__c = Categoriepartenaire, /*Statut__c='ACTIF',*/
                           EntiteCommercialeDalkia__c = 'J00001003P',
                           BillingCity = 'test',
                           BillingPostalCode = '333',
                           BillingState = '434',
                           BillingStreet = '234342',
                           RecordtypeId = Label.PartenaireSociete,
                           Lieu_immatriculation_legale__c = 'test',
                           StatutPartenaire__c = Statut,
                           Siege_social_partenaire__c = Siegesocialpartenaire,
                           DKCodeSurPartenaire__c = dkcode );

    }

    //Create Account
    //Input: Name, BillingCountry, Type, Statut
    public static Account createPersonAccount(string AccountName, string BillingCountry, string Type, String Statut){

        if(Type == 'Public') {
            Type = 'PUB';
        } else if(Type == 'Privé') {
            Type = 'PRV';
        }

        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(Label.RT_ACC_Particulier).getRecordTypeId();

        return new Account(firstname = 'karma',
                           Salutation = 'M',
                           lastname = AccountName,
                           Type_immatriculation__c  = 'RCS',
                           BillingCountry = BillingCountry,
                           Type = Type,
                           Code_NACE__c = '22',
                           NaturePartenaire__c = 'ETAB',
                           SIRET__c = '345345',
                           Segment_client__c = 'SCL02' /*,Sous_segment_client__c='SCL04B'*/,
                           Categorie_partenaire__c = 'EDF', /*Statut__c='ACTIF',*/
                           EntiteCommercialeDalkia__c = 'J00001003P',
                           BillingCity = 'test',
                           BillingPostalCode = '333',
                           BillingState = '434',
                           BillingStreet = '234342',
                           RecordtypeId = recordTypeId,
                           Lieu_immatriculation_legale__c = 'test',
                           StatutPartenaire__c = Statut);
    }

    //Create Contact
    //Input: Last Name, AccountId, ReportsToId(Type contact, if needed), IsContactEspaceClient
    //Example: 'Test', a1.Id, null, true
    public static Contact createContact(string LastName, Id AccountId, Id ReportsToId, Boolean IsContactEspaceClient){
        return new Contact(Phone = '1234567890',
                           MobilePhone = '1234567890',
                           LastName = LastName,
                           FirstName = 'test',
                           AccountId = AccountId,
                           ReportsToId = ReportsToId,
                           Date_debut__c = Date.today(),
                           Salutation = 'M',
                           Email = LastName.replace(' ', '_') + '@dalkia.fr',
                           Statut__c = 'Actif',
                           IsContactEspaceClient__c = IsContactEspaceClient,
                           RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_pro').getRecordTypeId());
    }

    //Create Contact Benificiaire
    public static Contact createContactBenficiaire(string LastName){
        return new Contact(Phone = '1234567890',
                           MobilePhone = '1234567890',
                           LastName = LastName,
                           FirstName = 'test',
                           Salutation = 'M',
                           Email = LastName.replace(' ', '_') + '@dalkia.fr',
                           Statut__c = 'Actif',
                           TypeInterlocuteur__c = 'Locataire',
                           LieuIntervevention__c = 'C360',
                           MailingStreet = 'test',
                           MailingPostalCode = 'test',
                           MailingCity = 'test',
                           RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Beneficiaire').getRecordTypeId());
    }

    //A la creation d'une Opp, une fds sera cree automatiquement, mais il faut la completer pour realiser l'opp
    //Input: set OppIds qu'on souhaite realiser
    public static void completeeFDS(set<Id> setOppId){
        List<Fiche_de_synthese__c> listFDS = [Select id
                                              From Fiche_de_synthese__c
                                              Where Opportunit_commerciale__c in:setOppId];

        for(Fiche_de_synthese__c fds : listFDS) {
            fds.SaisieRefP1VentesServices__c = 12;
            fds.OffreA1P1VentesServices__c = 13;
        }
        Update listFDS;
    }

    //Cree OpportuniteContact avec un contrat actif pour realiser une opp
    public static OpportuniteContact__c createOpportunityContrat(String oppId, String contactId){
        return new OpportuniteContact__c(Opportunite__c = oppId, Contact__c = contactId);
    }

    //Apres la realisation d'une opp, un contrat sera genere
    public static List<Contrat__c> getContratGeneree(set<Id> setOppId){
        List<Contrat__c> contratGeneree = [Select id, OpportuniteCommerciale__c
                                           From Contrat__c
                                           Where OpportuniteCommerciale__c in :setOppId];

        return contratGeneree;
    }

    //Create Budget
    public static Budget__c createBudget(string Name, string year, id contractId, Integer BudgetNP1VentesServices, Integer BudgetNP2VentesServices){
        return new Budget__c(Name = Name,
                             AnneeBudget__c = year,
                             NomContrat__c = contractId,
                             BudgetNP1VentesServices__c = BudgetNP1VentesServices,
                             BudgetNP2VentesServices__c = BudgetNP2VentesServices);
    }

    //Create ContentVersion
    //Example testUtilsC360.createContentVersion('Test1', 'Test1.jpg', 'Test1 Content Data', true)
    public static ContentVersion createContentVersion(string Title, string PathOnClient, string VersionData, Boolean IsMajorVersion){
        return new ContentVersion(Title = Title,
                                  PathOnClient = PathOnClient,
                                  VersionData = Blob.valueOf(VersionData),
                                  IsMajorVersion = IsMajorVersion);
    }

    //Create ContentDocumentLink
    //Example testUtilsC360.createContentDocumentLink(DC.id,documents[0].Id,'AllUsers','I')
    public static ContentDocumentLink createContentDocumentLink(Id LinkedEntityId, Id ContentDocumentId, string Visibility, string ShareType){
        return new ContentDocumentLink(LinkedEntityId = LinkedEntityId,
                                       ContentDocumentId = ContentDocumentId,
                                       Visibility = Visibility,
                                       ShareType = ShareType);
    }

    //Create ContentVersion
    //Example testUtilsC360.createDocumentContractuel('test','123','DOC01','ACT',contrat.id,date.today(),date.today(),'DOC_C02');
    public static Document_Contractuel__c createDocumentContractuel(string TitreDocument, string NumeroPiece, string NatureDocument, string StatutDocument, Id contratId, Date DatePriseEffet, Date DateSignature, String NiveauDeConfidentialite){
        return new Document_Contractuel__c(TitreDocument__c = TitreDocument,
                                           NumeroPiece__c = NumeroPiece,
                                           NatureDocument__c = NatureDocument,
                                           StatutDocument__c = StatutDocument,
                                           Contrat__c = contratId,
                                           DatePriseEffet__c = DatePriseEffet,
                                           DateSignature__c = DateSignature,
                                           NiveauDeConfidentialite__c = NiveauDeConfidentialite);
    }

    //Une opp ne peut etre realise que depuis le chemin à travers la modif de ces champs
    public static Opportunity realiseOpportunity(Opportunity opp){
        opp.Statut__c = Label.OppBeforeUp_gagne;
        opp.DureeProlongationSupp__c = 5;
        opp.stageName = Label.PV_Realisation;
        opp.ZZZ_TECH_RealiseDuChemin__c = true;
        opp.Duree_minimale_estimee__c = 2;
        opp.ContratObligeantCEEpck__c = 'Non';

        return opp;
    }

    //Opp Independant
    //Create Opp Independant Nouveau
    //Example: 'testOpp1', '2022', Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, a2.Id, UserInfo.getUserId()
    public static Opportunity createOpportunityIndepNouveau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Independant Evol
    public static Opportunity createOpportunityIndepEvol(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution
        );
    }

    //Create Opp Independant Renouv
    public static Opportunity createOpportunityIndepRenouv(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Opp Mere
    //Opp Mere Reseau
    //Create Opp Mere Nouveau Reseau
    public static Opportunity createOpportunityMereNouveauReseau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereReseau,
                               natureOffre__c = Label.AP104_NatureReseauDSP,
                               engagementEnergetique__c = Label.AP104_EngagementDelegation,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Mere Evol Reseau
    public static Opportunity createOpportunityMereEvolReseau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereReseau,
                               natureOffre__c = Label.AP104_NatureReseauDSP,
                               engagementEnergetique__c = Label.AP104_EngagementDelegation,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Mere Renouv Reseau
    public static Opportunity createOpportunityMereRenouvReseau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereReseau,
                               natureOffre__c = Label.AP104_NatureReseauDSP,
                               engagementEnergetique__c = Label.AP104_EngagementDelegation,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Opp Mere SPU
    //Create Opp Mere Nouveau SPU
    public static Opportunity createOpportunityMereNouveauSPU(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereSPU,
                               natureOffre__c = Label.AP104_NaturePointUnique,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Mere Evol SPU
    public static Opportunity createOpportunityMereEvolSPU(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereSPU,
                               natureOffre__c = Label.AP104_NaturePointUnique,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Mere Renouv SPU
    public static Opportunity createOpportunityMereRenouvSPU(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereSPU,
                               natureOffre__c = Label.AP104_NaturePointUnique,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Opp Mere National
    //Create Opp Mere Nouveau National
    public static Opportunity createOpportunityMereNouveauNational(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereNational,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Mere Evol SPU
    public static Opportunity createOpportunityMereEvolNational(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereNational,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Opp Mere Renouv SPU
    public static Opportunity createOpportunityMereRenouvNational(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               EstOpportuniteMere__c = true,
                               NatureOpportunitMere__c = Label.AP104_NatureMereNational,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Opp Fille
//Opp Fille Reseau
//Create Opp Fille Nouveau Reseau
    public static Opportunity createOpportunityFilleNouveauReseau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               EstOpportuniteMere__c = false,
                               Type_de_PdA_reseaux__c = 'Densification',
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereReseau
        );
    }

//Create Opp Fille Evol Reseau
    public static Opportunity createOpportunityFilleEvolReseau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution,
                               EstOpportuniteMere__c = false,
                               Type_de_PdA_reseaux__c = 'Densification',
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereReseau
        );
    }

//Create Opp Fille Renouv Reseau
    public static Opportunity createOpportunityFilleRenouvReseau(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               EstOpportuniteMere__c = false,
                               Type_de_PdA_reseaux__c = 'Densification',
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereReseau
        );
    }

//Opp Fille SPU
//Create Opp Fille Nouveau SPU
    public static Opportunity createOpportunityFilleNouveauSPU(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c =  AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               EstOpportuniteMere__c = false,
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereSPU
        );
    }

//Create Opp Fille Evol SPU
    public static Opportunity createOpportunityFilleEvolSPU(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution,
                               EstOpportuniteMere__c = false,
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereSPU
        );
    }

//Create Opp Fille Renouv SPU
    public static Opportunity createOpportunityFilleRenouvSPU(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               EstOpportuniteMere__c = false,
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereSPU
        );
    }

//Opp Fille National
//Create Opp Fille Nouveau National
    public static Opportunity createOpportunityFilleNouveauNational(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId(),
                               Type_pers__c = Label.PV_Opp_Type_Nouveau,
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               EstOpportuniteMere__c = false,
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereNational,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

//Create Opp Fille Evol SPU
    public static Opportunity createOpportunityFilleEvolNational(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               ContratOrigine__c = contratOrigineId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId(),
                               Duree_minimale_estimee__c = 2,
                               Type_pers__c = Label.Evolution,
                               EstOpportuniteMere__c = false,
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereNational,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

//Create Opp Fille Renouv SPU
    public static Opportunity createOpportunityFilleRenouvNational(String Name, String AnneeSignature, Date closeDate, string status, string StageName, String AccountId, String SocieteventeId, String OwnerId, String contratOrigineId, String OpportuniteMereId){
        return new Opportunity(Name = Name,
                               CloseDate = closeDate,
                               Statut__c = status,
                               Annee_de_signature__c = AnneeSignature,
                               StageName = Label.OpportunityStagePiste,
                               Segment_client__c = Label.SegmentOpp_Sante,
                               SousSegmentMarche__c = Label.SousSegmentOpp_Autres,
                               Moisdesignature__c = 'Février',
                               TypeReconduction__c = Label.PV_Reconduction_Tacite,
                               AccountId = AccountId,
                               Societevente__c = SocieteventeId,
                               OwnerId = OwnerId,
                               RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId(),
                               Type_pers__c = Label.Renouvellement,
                               CreerNouveauProjetCommercial__c = false,
                               ContratOrigine__c = contratOrigineId,
                               EstOpportuniteMere__c = false,
                               OpportuniteMere__c = OpportuniteMereId,
                               NatureOpportunitMere__c = Label.AP104_NatureMereNational,
                               natureOffre__c = Label.AP104_NatureCVC,
                               engagementEnergetique__c = Label.AP104_EngagementSansTravaux,
                               paiementDesEnergies__c = Label.AP104_PaiementDalkia,
                               niveauDeMaintenance__c = Label.AP104_NiveauGER
        );
    }

    //Create Lead
    public static Lead createLead(string firstName, string lastName, string Company){
        Lead lead = new Lead(LastName = lastName, FirstName = firstName, Company = Company);

        return lead;
    }
}