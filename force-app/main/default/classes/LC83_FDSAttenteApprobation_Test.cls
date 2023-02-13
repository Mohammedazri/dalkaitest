/**
* @author: Jimmy Khalil
* @date: 08/04/2021
* @description: Test Class for "LC83_FDSAttenteApprobationController" 
*/
@istest
public class LC83_FDSAttenteApprobation_Test {
    
    @isTest
    static void getApprobationProfilePiloteOpp()
    {
        //Les FdS où il est pilote de l'opportunité -> Profil Commercial,Commercial multi-agence,DAC/RAC, DAC/RAC One, DCR
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AgenceCommercialProfileId]; //Directeur et responsable d'agence commerciale(DAC) profile
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        insert u1; // user to perform tests
        
        System.runAs(u1)
        {   
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Lieu_immatriculation_legale__c = 'test';
            a1.Immatriculation_Legale__c = 'test1';
            a1.Type_immatriculation__c = 'RCS';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            Insert a1;
            
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.Name='testtingg ';
            c1.DureeInitialeContrat__c = 1;
            insert c1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.id;
            myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Duree_minimale_estimee__c = 2;  
            myOpp.Type_pers__c =Label.Evolution;
            insert myOpp;
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c myfds= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            /*Fiche_de_synthese__c myfds= new Fiche_de_synthese__c(Name='testfds'); 
            myfds.Opportunit_commerciale__c=myOpp.Id;
            insert myfds;*/// insert new fiche de synthèse
            
            
            
            Approbation__c app = new Approbation__c();
            app.Name = 'test';
            app.tech_Attribue__c = UserInfo.getUserId();
            app.statut__c =Label.LC54_sansRep;
            app.Date_de_soumission__c = DATE.today();
            app.tech_FicheDeSynthese__c = myfds.Id;
            insert app;
            test.startTest();
            LC83_FDSAttenteApprobationController.getApprobation();
            test.stopTest();
        }
    }
    @isTest
    static void getApprobationProfileAgencePiloteOpp()
    {
        //Les FdS où le pilote de l'opportunité est dans l'agence -> Profil Commercial One
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.CommercialFirstProfileId]; // Profil Commercial One
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); // user to perform tests
        insert new List<User>{u1,u2}; 
            
        u1.Nom_agence__c = 'Test1';
        u2.Nom_agence__c = 'Test1';
        update new List<User>{u1,u2}; 
            
        account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        a1.BillingCity='test';
        a1.BillingPostalCode='111';
        a1.Lieu_immatriculation_legale__c = 'test';
        a1.Immatriculation_Legale__c = 'test1';
        a1.Type_immatriculation__c = 'RCS';
        a1.StatutPartenaire__c = Label.WS11_OUV;
        Insert a1;
        
        Contrat__c c1= new Contrat__c();
        c1.NomPartenaire__c=a1.Id;
        c1.Name='testtingg ';
        c1.DureeInitialeContrat__c = 1;
        insert c1;
        
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
        myOpp.accountId=a1.Id;
        myOpp.ContratOrigine__c=c1.id;
        myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
        myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
        myOpp.Duree_minimale_estimee__c = 2;  
        myOpp.Type_pers__c =Label.Evolution;
        myOpp.OwnerId = u1.Id;
        insert myOpp;
        
        //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
        // Only one fds can be added to a opp
        Fiche_de_synthese__c myfds= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
        /*Fiche_de_synthese__c myfds= new Fiche_de_synthese__c(Name='testfds'); 
        myfds.Opportunit_commerciale__c=myOpp.Id;
        insert myfds;*/// insert new fiche de synthèse
        
        
        
        Approbation__c app = new Approbation__c();
        app.Name = 'test';
        app.tech_Attribue__c = UserInfo.getUserId();
        app.statut__c =Label.LC54_sansRep;
        app.Date_de_soumission__c = DATE.today();
        app.tech_FicheDeSynthese__c = myfds.Id;
        insert app;
        
        System.runAs(u2)
        { 
            test.startTest();
            LC83_FDSAttenteApprobationController.getApprobation();
            test.stopTest();
        }
    }
    @isTest
    static void getApprobationProfileAgenceSoumis()
    {
        //Les FdS que les utilisateurs de l'agence ont soumis -> Profil AC,AC multi Agence
        Profile p = [SELECT Id FROM Profile WHERE Name =:Label.ProfileAC]; // AC profile
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com'); // new user
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); // user to perform tests
        insert new List<User>{u1,u2}; 
            
        u1.Nom_agence__c = 'Test1';
        u2.Nom_agence__c = 'Test1';
        update new List<User>{u1,u2}; 
            
            System.runAs(u1)
        { 
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Lieu_immatriculation_legale__c = 'test';
            a1.Immatriculation_Legale__c = 'test1';
            a1.Type_immatriculation__c = 'RCS';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            Insert a1;
            
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.Name='testtingg ';
            c1.DureeInitialeContrat__c = 1;
            insert c1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
            myOpp.accountId=a1.Id;
            myOpp.ContratOrigine__c=c1.id;
            myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Duree_minimale_estimee__c = 2;  
            myOpp.Type_pers__c =Label.Evolution;
            insert myOpp;
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c myfds= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            /*Fiche_de_synthese__c myfds= new Fiche_de_synthese__c(Name='testfds'); 
            myfds.Opportunit_commerciale__c=myOpp.Id;
            insert myfds;*/// insert new fiche de synthèse
            
            
            
            Approbation__c app = new Approbation__c();
            app.Name = 'test';
            app.tech_Attribue__c = UserInfo.getUserId();
            app.statut__c =Label.LC54_sansRep;
            app.Date_de_soumission__c = DATE.today();
            app.tech_FicheDeSynthese__c = myfds.Id;
            insert app;
        }
        System.runAs(u2)
        { 
            test.startTest();
            LC83_FDSAttenteApprobationController.getApprobation();
            test.stopTest();
        }
    }
}