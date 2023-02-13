/**
 * @description       : 
 * @author            : Othmane Choulli
 * @group             : 
 * @last modified on  : 21-09-2022
 * @last modified by  : Othmane Choulli
**/
@isTest
public class testUtils {
    
    public static Agence__c createAgence(string AgenceName, string Code, string DKcode){ 
        return new Agence__c(Name = AgenceName, Code_Agence__c = Code, dkcode__c= DKcode);
    }
    public static Account createAccountParticulier(string AccountName, string BillingCountry, string Type){ 
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(Label.RT_ACC_Particulier).getRecordTypeId();
        if(Type == 'Public'){
            Type = 'PUB';
        }else if(Type == 'Privé'){
            Type = 'PRV';
        }
        return new Account(firstname = 'karma',Salutation = 'M', lastname= AccountName, Type_immatriculation__c  = 'RCS' , BillingCountry =BillingCountry, Type= Type, Code_NACE__c='22', NaturePartenaire__c='ETAB',SIRET__c='345345',Segment_client__c='SCL02'/*,Sous_segment_client__c='SCL04B'*/,Categorie_partenaire__c='EDF',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test', BillingPostalCode='333', BillingState='434', BillingStreet='234342', RecordtypeId=recordTypeId,Lieu_immatriculation_legale__c='test');
    }
    public static Account createAccount(string AccountName, string BillingCountry, string Type){ 
        if(Type == 'Public'){
            Type = 'PUB';
        }else if(Type == 'Privé'){
            Type = 'PRV';
        }
        return new Account(Name= AccountName, Type_immatriculation__c  = 'RCS' , BillingCountry =BillingCountry, Type= Type, Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392043',Segment_client__c='SCL04'/*,Sous_segment_client__c='SCL04B'*/,Categorie_partenaire__c='EDF',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test', BillingPostalCode='111', BillingState='aa', BillingStreet='aaa', RecordtypeId=Label.PartenaireSociete,Lieu_immatriculation_legale__c='test');
    }
    
    public static Account createAccount2(string AccountName, string BillingCountry, string Type){       
        if(Type == 'Public'){
            Type = 'PUB';
        }else if(Type == 'Privé'){
            Type = 'PRV';            
        }
        return new Account(Name= AccountName, BillingCountry =BillingCountry, Type= Type, Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Segment_client__c='SCL04'/*,Sous_segment_client__c='SCL04B'*/,Categorie_partenaire__c='EDF',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
    }
    
    public static Account createAccountShipping(string AccountName, string ShippingCountry, string Type){       
        return new Account(Name= AccountName, ShippingCountry =ShippingCountry, Type= Type, Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392043',Segment_client__c='SCL04'/*,Sous_segment_client__c='Etablissement de soins'*/,Categorie_partenaire__c='EDF',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test', BillingPostalCode='111', BillingState='aa', BillingStreet='aaa', RecordtypeId=Label.PartenaireSociete);
    }
    
     public static Contact createContact(string LastName, Id AccountId, Id ReportsToId){
        return new Contact(Phone='1234567890', MobilePhone ='1234567890',LastName = LastName, FirstName='test', AccountId = AccountId, ReportsToId = ReportsToId, Date_debut__c=Date.today(), Salutation = 'M', Email = LastName.replace(' ', '_')+'@dalkia.fr', Statut__c ='Actif');
    }    
    
    public static Task createTask(Id whatId,Id whoId, Date ActivityDate, string genredecomite, string Priority, string Status){
        return new Task(WhatId=whatId, whoId=whoId, ActivityDate=ActivityDate,genre_comite__c=genredecomite,Priority=Priority,Status= Status);
    } 
    
    public static Event createEvent(Id whatId,Id whoId, Date ActivityDateTime,string genredecomite, Integer DurationInMinutes){
        return new Event(WhatId=whatId, whoId=whoId, ActivityDateTime=ActivityDateTime,genre_comite__c=genredecomite, DurationInMinutes=DurationInMinutes);
    }
    
    public static Document createDocument(string Name, string DeveloperName,Id FolderId ){
        return new Document(Body=Blob.valueOf('Some Text'), ContentType = 'application/pdf', Name=Name,DeveloperName=DeveloperName,IsPublic = true, FolderId=FolderId  );
    }
    
    public static Opportunity createOpportunity(String Name, Date closeDate,string status, string StageName){
        return new Opportunity(Name=Name, CloseDate=closeDate, Statut__c=status, Annee_de_signature__c='2017',StageName=Label.OpportunityStagePiste, Segment_client__c =Label.SegmentOpp_Sante, SousSegmentMarche__c=Label.SousSegmentOpp_Autres, Moisdesignature__c ='Février', TypeReconduction__c=Label.PV_Reconduction_Tacite);
    }
    
    public static Opportunity createOpportunityAP14(String Name, Date closeDate,string status, string StageName2){
        return new Opportunity(Name=Name, CloseDate=closeDate, Statut__c=status,  Annee_de_signature__c='2017',StageName=StageName2, Segment_client__c =Label.SegmentOpp_Sante, SousSegmentMarche__c=Label.SousSegmentOpp_Autres,Moisdesignature__c ='Février',TypeReconduction__c=Label.PV_Reconduction_Tacite);
    }
    
    public static User createUser(string Alias, string Email, string LastName, Id ProfileId, string UserName){
        return new User(Alias = Alias, Email=Email, EmailEncodingKey='UTF-8', LastName=LastName, LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, TimeZoneSidKey='America/Los_Angeles', UserName=UserName,Phone='000',Title='Mr',Department='test'  );
    }
    
    public static Objectif__c createObjectif(string Name, string recordtype, string annee){
        return new Objectif__c(Name=Name, Annee__c=annee, RecordtypeId=recordtype);
    }
    public static Budget__c createBudget(string Name, string year, id contractId){
        return new Budget__c(Name=Name, AnneeBudget__c=year, NomContrat__c=contractId);
    }
    
    public static AccountTeamMember createAccountTeamMember(string accid, string userid){
        AccountTeamMember atm = new AccountTeamMember(AccountId = accID, TeamMemberRole= 'ROL01', AccountAccessLevel = 'Edit', UserId= UserID) ;
        return atm;
    }
    public static Lead createLead(string firstName, string lastName, string Company){
        Lead lead=new Lead(LastName=lastName,FirstName=firstName,Company=Company);
        return lead;
    }
    public static fiche_de_synthese__c createFDS(){
        fiche_de_synthese__c myFiche=new fiche_de_synthese__c(P1MbOf__c=1,P1CaOf__c=2,P1CaRef__c=3,P1MbRef__c=4,P2MbOf__c=5,P2CaOf__c=6,P2CaRef__c=7,P2MbRef__c=8,P3MbOf__c=9,P3CaOf__c=10,P3CaRef__c=11,P3MbRef__c=12,P4MbOf__c=13,P4CaOf__c=14,P4CaRef__c=15,P4MbRef__c=16,P6MbOf__c=17,P6CaOf__c=18,P6CaRef__c=19,P6MbRef__c=20);
        return myFiche;
    }
    public static ContratContact__c createContactContrat(string ContratId, string ContactId){
        ContratContact__c myConCOnt=new ContratContact__c(contact__c =ContactId,contrat__c =ContratId);
        return myConCOnt;
    }
     public static LienContratTacheFinance__c createLCT(id contId , id TFid , id pfId){
        LienContratTacheFinance__c lct = new LienContratTacheFinance__c(contrat__c=contid , ProjetFinance__c = pfId , TacheFinance__c = TFid); 
         return lct;
    }
     public static ProjetFinance__c createPF(String libelle , String DKCode){
         ProjetFinance__c myPF = new ProjetFinance__c(Name=libelle, DkCode__c =DKCode );
         return myPF;
    }
     public static TacheFinance__c createTF(String libelle , String DKCode){
         TacheFinance__c myTF = new TacheFinance__c(Name=libelle, DkCode__c =DKCode,Libelle__c=libelle);
         return myTF;
    }
    
    public static Contact insertContact(String firstName, String lastName, String phone, String email) {
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Phone = phone;
        contact.Email = email;

        insert contact;
        return contact;
    }

    public static Emplacement__c insertEmplacement(String name, Boolean estSupprime, String DKCode) {
        Emplacement__c emplacement = new Emplacement__c();
        emplacement.Name = name;
        emplacement.Emplacement_Supprime__c = estSupprime;
        emplacement.DKCode_Emplacement__c = DKCode;

        insert emplacement;
        return emplacement;
    }
    
    public static Case insertDemandeDureeGlobal(String subject, String recordTypeId, Contact contact, Emplacement__c emplacement, String status) {
        //Id RT_STI = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_STI').getRecordTypeId();
        Id profileId = [SELECT Id FROM Profile WHERE Name='Téléopérateur' LIMIT 1].Id;
        Case demande = new Case();
        //demande.recordTypeId = RT_STI;
        demande.recordTypeId =  recordTypeId;
        demande.Subject = subject;
        demande.Description = 'Description';
        
        if( recordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_STI').getRecordTypeId()) {
            demande.Reason = 'STI libre';
            //demande.Origin = 'Appel entrant';
            demande.Technicien__c = testUtils.insertUser('Alias 2', 'technicien1@dalkiadacrc.com', 'technicien', profileId, 'technicien1@dalkiadacrc.com', 'DKCode 2').id;
            
        }else {
            demande.Reason = 'Support - assistance technique';
        }
        
        demande.ContactId = contact.Id;
        if (recordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_depannage').getRecordTypeId()) {
        demande.Contact_sollicitant__c = contact.Id;
        }
        demande.Status = status;
        demande.Duree_globale__c = '00:45';
        demande.Emplacement__c = emplacement.Id;

        

        insert demande;
        return demande;
    }
    
    public static Case insertDemande(String subject, String recordTypeId, Contact contact, Emplacement__c emplacement, String status) {
        //Id RT_STI = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_STI').getRecordTypeId();
        Id profileId = [SELECT Id FROM Profile WHERE Name='Téléopérateur' LIMIT 1].Id;
        Case demande = new Case();
        //demande.recordTypeId = RT_STI;
        demande.recordTypeId =  recordTypeId;
        demande.Subject = subject;
        demande.Description = 'Description';
        
        if( recordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_STI').getRecordTypeId()) {
            demande.Reason = 'STI libre';
            //demande.Origin = 'Appel entrant';
            demande.Technicien__c = testUtils.insertUser('Alias 1', 'technicien@dalkiadacrc.com', 'technicien', profileId, 'technicien@dalkiadacrc.com', 'DKCode 1').id;
            
        }else {
            demande.Reason = 'Support - assistance technique';
        }
        
        demande.ContactId = contact.Id;
        if (recordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_de_depannage').getRecordTypeId()) {
        demande.Contact_sollicitant__c = contact.Id;
        }
        demande.Status = status;
        demande.Duree_trajet_aller__c = '30';
        demande.Duree_intervention__c = '50';
        demande.duree_trajet_retour__c = '40';
        demande.Emplacement__c = emplacement.Id;

        

        insert demande;
        return demande;
    }

    
    public static Case getDemandeBySubject(String subject) {
        return [SELECT Id, Subject, Status FROM Case WHERE Subject = :subject LIMIT 1];
    }

    public static Consigne__c getConsigneByMatricule(String matricule) {
        return [SELECT Id, Matricule__c, Reponse__c, Demande__c FROM Consigne__c WHERE Matricule__c = :matricule LIMIT 1];
    }

    public static Consigne__c insertConsigne(Case demande, String recordTypeId, String matricule, String nomTechnicien, String numeroTelephone, Integer ordre, String reponse, Boolean estHistorique) {
        Consigne__c consigne = new Consigne__c();
        consigne.Demande__c = demande.Id;
        consigne.RecordTypeId = recordTypeId;
        consigne.Matricule__c = matricule;
        consigne.Nom_du_technicien__c = nomTechnicien;
        consigne.Numero_de_telephone__c = numeroTelephone;
        consigne.N_ordre__c = ordre;
        consigne.Reponse__c = reponse;
        consigne.Fonction__c = 'Technicien';
        consigne.estHistorique__c = estHistorique;

        insert consigne;
        return consigne;
    }

    public static User insertUser(string Alias, string Email, string LastName, Id ProfileId, string UserName, string DkCode){
        User user = new User(Alias = Alias, Email=Email, EmailEncodingKey='UTF-8', LastName=LastName, LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, TimeZoneSidKey='America/Los_Angeles', UserName=UserName,Phone='000',Title='Mr',Department='test', DkCode__c = DkCode);
        insert user;
        return user;
    }

    public static List<Case> getAllDemande() {
        return [SELECT Id, Status FROM Case];
    }

    public static List<User> getUserByEmail(String email) {
        return [SELECT Id, Email, DkCode__c FROM User WHERE Email = :email];
    }

    public static List<Consigne__c> getAllConsignes() {
        return [SELECT Id, Matricule__c, Reponse__c, Demande__c, Nom_du_technicien__c, User__c, estHistorique__c FROM Consigne__c];
    }
    
}