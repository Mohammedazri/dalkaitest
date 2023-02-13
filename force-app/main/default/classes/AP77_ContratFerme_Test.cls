@istest
public class AP77_ContratFerme_Test {
    @testSetup static void setup() {
        account myaccount= testUtils.createAccount('TEST1', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.StatutPartenaire__c = 'OUV';
        insert myaccount;
        opportunity myOpp = testUtils.createOpportunity ('testContrat', date.today(),Label.OpportunityStatusEnCours, 'Piste');
        myOpp.accountId=myaccount.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c=Label.PV_Evolution;
        myOpp.Annee_de_signature__c='2017';
        insert myOpp;
        Contrat__c contrat = new Contrat__c();
        contrat.Name = 'TESTCONTRAT';
        PAD.PAD_BypassTrigger+=';AP48_ContractCallouts;';
        contrat.TypeContrat__c = 'IND';
        contrat.OpportuniteCommerciale__c = myOpp.id;
        contrat.NomPartenaire__c = myaccount.id;
        insert contrat;   
    }
    
    static testMethod void deleteEquipeContrat()
    {
        Contrat__c Contrat = [SELECT id , statut__c From Contrat__c limit 1];
        IntervenantSurContrat__c EC = new IntervenantSurContrat__c();
        EC.Contrat__c = contrat.id;
        EC.role__c = 'Responsable technique';
        EC.Nom_de_utilisateur_std__c = userInfo.getUserId();
        insert EC;
        TEST.startTest();
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        try{
            delete EC;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
    static testMethod void deleteDocumentContractuel()
    {
        Contrat__c Contrat = [SELECT id , statut__c FROM Contrat__c limit 1];
        Document_Contractuel__c doc = new Document_Contractuel__c();
        doc.Contrat__c = contrat.id;
        doc.TitreDocument__c = 'Test';
        doc.NatureDocument__c = 'DOC02';
        doc.StatutDocument__c = 'ATRT';
        doc.DateSignature__c = Date.Today();
        doc.DatePriseEffet__c = Date.Today();
        doc.NiveauDeConfidentialite__c = 'DOC_C02';
        insert doc;
        TEST.startTest();
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        try{
            delete doc;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
    static testMethod void deleteEcosysteme()
    {
        account myaccount1= testUtils.createAccount('TEST2', 'Lebanon', 'Privé');
        myaccount1.Lieu_immatriculation_legale__c = 'test';
        myaccount1.StatutPartenaire__c = 'OUV';
        myaccount1.DKCodeSurPartenaire__c = '112233';
        myaccount1.Code_NACE__c = '112';
        myaccount1.SIRET__c = '392042';
        insert myaccount1; 
        Contrat__c Contrat = [SELECT id , statut__c FROM Contrat__c limit 1];
        EcosystemePartenaire__c Ecosys = new EcosystemePartenaire__c();
        Ecosys.PartenaireLie__c = myaccount1.id;
        Ecosys.Contrat__c = contrat.id;
        Ecosys.TypeRelation__c = 'DEST';
        insert Ecosys;
        TEST.startTest();
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        try{
            delete Ecosys;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
    static testMethod void deleteBudget()
    {
        Contrat__c Contrat = [SELECT id , statut__c FROM Contrat__c limit 1];
        Budget__c Budg = testUtils.createBudget('TEST','2020',Contrat.id);
        insert Budg;
        TEST.startTest();
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        try{
            delete Budg;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
    static testMethod void deleteLienContratTache()
    {
        ProjetFinance__c PF = new ProjetFinance__c();
        PF.Name = 'TestPF';
        insert PF;
        Contrat__c Contrat = [SELECT id , statut__c FROM Contrat__c limit 1];
        TacheFinance__c TF = new TacheFinance__c();
        TF.name = 'TFTest';
        TF.ProjetFinance__c = PF.id;
        insert TF;
        LienContratTacheFinance__c lctf = new LienContratTacheFinance__c();
        lctf.Contrat__c = contrat.id;
        lctf.TacheFinance__c = TF.id;
        lctf.ProjetFinance__c = PF.id;
        insert lctf;
        TEST.startTest();
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        try{
            delete lctf;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
    static testMethod void deleteOpportunite()
    {
        Account myaccount = [SELECT id FROM Account limit 1];
        Contrat__c contrat = [SELECT id FROM Contrat__c limit 1];
        opportunity myOpp = testUtils.createOpportunity ('testContrat', date.today(),Label.OpportunityStatusEnCours, 'Piste');
        myOpp.accountId=myaccount.Id;
        myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Type_pers__c=Label.PV_Evolution;
        myOpp.Annee_de_signature__c='2017';
        myOpp.ContratOrigine__c = contrat.id;
        insert myOpp;
        TEST.startTest();
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        try{
            delete myOpp;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        TEST.stopTest();
    }
    
    static testMethod void deleteDocument()
    {
        Contrat__c contrat = [SELECT id FROM Contrat__c limit 1];  
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body'); 
        ContentVersion cv1 = new ContentVersion();
        cv1.title =  'test';      
        cv1.PathOnClient ='test';           
        cv1.VersionData =beforeblob;
        insert cv1;
        ContentDocumentLink contentlink1=new ContentDocumentLink();
        contentlink1.ShareType= 'V';
        contentlink1.LinkedEntityId = contrat.Id;            
        contentlink1.Visibility = 'AllUsers';
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id =:cv1.Id limit 1];
        contentlink1.ContentDocumentId = testContent.ContentDocumentId;
        insert contentlink1;
        contrat.statut__c = Label.ContratFerme;
        update contrat;
        
        TEST.startTest();
        try{
            delete contentlink1;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        try{
            ContentDocument cd = [SELECT id FROM ContentDocument where id =:testContent.ContentDocumentId ];
            delete cd;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        try{
            
            update contentlink1;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        try{
            ContentDocument cd = [SELECT id FROM ContentDocument where id =:testContent.ContentDocumentId ];
            update cd;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP77_ContratFerme));
        }
        
        TEST.stopTest();
    }
    
    static testMethod void deleteContactContrat()
    {
        Account myaccount = [SELECT id FROM Account limit 1];
        Contrat__c contrat = [SELECT id FROM Contrat__c limit 1];
        contact mycontact = testUtils.createContact('test 4', myaccount.Id, null);
        insert mycontact;
        ContratContact__c cc = new ContratContact__c(contact__c =mycontact.id,contrat__c =contrat.id);
        insert cc;
        TEST.startTest();
        try{
            delete cc;
        }
        Catch(Exception e)
        {
            system.assert( e.getMessage().contains(Label.AP113_ErrorMsg));
        }
        TEST.stopTest();
    }
}