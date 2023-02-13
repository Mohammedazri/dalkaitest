@isTest
public class LC17_CreationOpp_Controller_Test {
    static testMethod void testCreationOpp() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        list<User> listUS = new List<User>();
        User u1 = testUtils.CreateUser('standt21', 'user21111@testorg1.com', 'Testing1', p.Id, 'user12rrr@testorg1.com');
        listUS.add(u1);
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        listUS.add(u2);
        insert listUS;
        
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Lieu_immatriculation_legale__c = 'test';
        myaccount.Immatriculation_Legale__c = 'test1';
        myaccount.Type_immatriculation__c = 'RCS';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        
        account myaccount2= testUtils.createAccount2('tes2', 'Lebanon', 'Privé');
        myaccount2.Lieu_immatriculation_legale__c = 'test';
        myaccount2.Immatriculation_Legale__c = 'test3';
        myaccount2.Type_immatriculation__c = 'RCS';
        myaccount2.StatutPartenaire__c = Label.WS11_OUV;
        myaccount2.BillingCity='test';
        myaccount2.BillingPostalCode='112';
        myaccount2.Code_NACE__c = '222';
        myaccount2.SIRET__c = '255236';
        myaccount2.Siege_social_partenaire__c = true;
        myaccount2.Categorie_partenaire__c = 'DLK';
        myaccount2.DKCodeSurPartenaire__c = '112233';
        insert new List<Account> {myaccount,myaccount2};
            
            
            
        opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
        myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.PV_Opp_Type_Nouveau;
        myOpp.Probabilite__c=3;
        insert(myOpp);
        ProjetCommercial__c project= new ProjetCommercial__c(name='test',OpportunitCommerciale__c=myOpp.id);
        insert(project);
        myOpp.ProjetCommercial__c=project.id;
        update(myOpp);
        Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id,OwnerID=u1.id);
        mycontrat.ValeurEnEMWh__c = 1;
        mycontrat.RepercussionChargeCEE__c = true;
        mycontrat.TypeReconduction__c = 'RNUL';
        mycontrat.DatePriseEffet__c = System.Today() -2;
        mycontrat.DureeInitialeContrat__c = 1;
        mycontrat.DureeProlongationTotale__c = 1;
        insert(mycontrat);
        
        EcosystemePartenaire__c myEco = new EcosystemePartenaire__c();
        myEco.PartenaireLie__c = myaccount2.Id;
        myEco.TypeRelation__c = 'Concurrents';
        myEco.Contrat__c = mycontrat.Id;
        insert myEco;
        
        Contrat__c mycontrat1= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id,OwnerID=u2.id);
        mycontrat1.ContratCadre__c = mycontrat.id;
        mycontrat1.ValeurEnEMWh__c = 1;
        mycontrat1.RepercussionChargeCEE__c = true;
        mycontrat1.TypeReconduction__c = 'RNUL';
        mycontrat1.DatePriseEffet__c = System.Today() -2;
        mycontrat1.DureeInitialeContrat__c = 1;
        mycontrat1.NombreReconductionsPassees__c = 1;
        mycontrat1.DureeReconduction__c = 1;
        mycontrat1.NombreReconductionsAutorisees__c = 1;
        mycontrat1.DureeProlongationTotale__c = 1;
        insert(mycontrat1);
        
        contact mycontact = testUtils.createContact('test 4', myaccount.Id, null);
        insert mycontact;
        
        ContratContact__c cc = new ContratContact__c(contact__c =mycontact.id,contrat__c =mycontrat.id);
        insert cc;
        
        test.startTest();
        LC17_CreationOppEvolRenouvel_Controller.getContratType(mycontrat1.id);
        mycontrat=LC17_CreationOppEvolRenouvel_Controller.getCurrentObject(mycontrat.id);
        opportunity newopp=new opportunity(Name='test opp',StageName='Piste',CloseDate=date.today(),Moisdesignature__c ='Février',Annee_de_signature__c='2017');
        id newid=LC17_CreationOppEvolRenouvel_Controller.CreateOpportunityEvolution(newopp, mycontrat.id);
        opportunity newopp2=new opportunity(Name='test opp 2',StageName='Piste',CloseDate=date.today(),Moisdesignature__c ='Février',Annee_de_signature__c='2017');
        id newid2=LC17_CreationOppEvolRenouvel_Controller.CreateOpportunityRenouvellement(newopp2, mycontrat.id);
        LC17_CreationOppEvolRenouvel_Controller.CreateOpportunityContratResilie(newopp2, mycontrat.id);
        LC17_CreationOppEvolRenouvel_Controller.GetStagesPicklist();
        LC17_CreationOppEvolRenouvel_Controller.GetMoisPicklist();
        LC17_CreationOppEvolRenouvel_Controller.GetAnneePicklist();
        test.stopTest();
    }
    
}