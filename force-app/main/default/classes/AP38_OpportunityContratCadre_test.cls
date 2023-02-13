/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Test class for the Apex class AP38_OpportunityContratCadre
History
<Date>      <Authors Name>      <Brief Description of Change>
28/11/2018   Chadi Geara      added additional contrat to cover complete the coverage 

-------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP38_OpportunityContratCadre_test {
    @isTest
    static void AP38_TestMethod() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Bypass_Workflow__c = true;
        u2.BypassProcessBuilder__c = true;
        u2.BypassValidationRules__c = true;
        u2.BypassFilters__c = true;
        u2.Bypass_Triggers__c ='AP48_ContractCallouts';
        insert u2;
        
        System.runAs(u2) 
        {
            PAD.PAD_BypassTrigger += 'AP48_ContractCallouts';
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Lieu_immatriculation_legale__c = 'test';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            List<contrat__c> listCont = new List<contrat__c>();
            List<contrat__c> listContP = new List<contrat__c>();
            
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=a1.Id;
            c1.EstContratcadre__c = true;
            c1.ReconductionFaitAutorisee__c = true;
            c1.OwnerID=u2.id;
            c1.Name='testtingg';
            c1.DatePriseEffet__c = Date.Today();
            c1.TypeReconduction__c = 'RNUL';
            listContP.add(c1);
            
            Contrat__c c11= new Contrat__c();
            c11.NomPartenaire__c=a1.Id;
            c11.EstContratcadre__c = true;
            c11.ReconductionFaitAutorisee__c = true;
            c11.OwnerID=u2.id;
            c11.Name='testtinggMAÎTRE11';
            c11.DatePriseEffet__c = Date.Today();
            c11.TypeReconduction__c = 'RNUL';
            listContP.add(c11);
            
            insert listContP; 
            
            Contrat__c c2= new Contrat__c();
            c2.NomPartenaire__c=a1.Id;
            c2.ReconductionFaitAutorisee__c = true;
            c2.OwnerID=u2.id;
            c2.DatePriseEffet__c = Date.Today();
            c2.TypeReconduction__c = 'RNUL';
            c2.Name='test MAITRE (DSP) 1223123';
            c2.ContratCadre__c = c1.id;
            listCont.add(c2);
            
            Contrat__c c3= new Contrat__c();
            c3.NomPartenaire__c=a1.Id;
            c3.ReconductionFaitAutorisee__c = true;
            c3.OwnerID=u2.id;
            c3.Name='test Fils DSP MAÎTRE (DSP)prive test';
            c3.ContratCadre__c = c1.id;
            c3.DatePriseEffet__c = Date.Today();
            c3.TypeReconduction__c = 'RNUL';
            listCont.add(c3);
            
            Contrat__c c5= new Contrat__c();
            c5.NomPartenaire__c=a1.Id;
            c5.ReconductionFaitAutorisee__c = true;
            c5.OwnerID=u2.id;
            c5.Name='test Fils DSP MAÎTRE DSP MAÎTRE (DSP)prive test';
            c5.ContratCadre__c = c1.id;
            c5.DatePriseEffet__c = Date.Today();
            c5.TypeReconduction__c = 'RNUL';
            listCont.add(c5);
            
            Contrat__c c6= new Contrat__c();
            c6.NomPartenaire__c=a1.Id;
            c6.ReconductionFaitAutorisee__c = true;
            c6.OwnerID=u2.id;
            c6.Name='test Fils DSP MAÎTRE (DSP) MAÎTRE (DSP)prive test';
            c6.ContratCadre__c = c1.id;
            c6.DatePriseEffet__c = Date.Today();
            c6.TypeReconduction__c = 'RNUL';
            listCont.add(c6);
            
            Contrat__c c7= new Contrat__c();
            c7.NomPartenaire__c=a1.Id;
            c7.ReconductionFaitAutorisee__c = true;
            c7.OwnerID=u2.id;
            c7.Name='test Fils DSP MAÎTRE (DSP) MAÎTRE (DSP) MAÎTRE (DSP)prive test';
            c7.ContratCadre__c = c1.id;
            c7.DatePriseEffet__c = Date.Today();
            c7.TypeReconduction__c = 'RNUL';
            listCont.add(c7);
			
            Contrat__c c8= new Contrat__c();
            c8.NomPartenaire__c=a1.Id;
            c8.ReconductionFaitAutorisee__c = true;
            c8.OwnerID=u2.id;
            c8.Name='test Fils DSP MAITRE (DSP) MAITRE (DSP) MAITRE (DSP)prive test';
            c8.ContratCadre__c = c1.id;
            c8.DatePriseEffet__c = Date.Today();
            c8.TypeReconduction__c = 'RNUL';
            listCont.add(c8);
            
            Contrat__c c9= new Contrat__c();
            c9.NomPartenaire__c=a1.Id;
            c9.ReconductionFaitAutorisee__c = true;
            c9.OwnerID=u2.id;
            c9.Name='test Fils DSP MAITRE 123123';
            c9.ContratCadre__c = c1.id;
            c9.DatePriseEffet__c = Date.Today();
            c9.TypeReconduction__c = 'RNUL';
            listCont.add(c9);
            
            Contrat__c c10= new Contrat__c();
            c10.NomPartenaire__c=a1.Id;
            c10.ReconductionFaitAutorisee__c = true;
            c10.OwnerID=u2.id;
            c10.Name='test Fils DSP MAITRE 123 MAITRE 123123';
            c10.ContratCadre__c = c1.id;
            c10.DatePriseEffet__c = Date.Today();
            c10.TypeReconduction__c = 'RNUL';
            listCont.add(c10);
            
            Contrat__c c13= new Contrat__c();
            c13.NomPartenaire__c=a1.Id;
            c13.ReconductionFaitAutorisee__c = true;
            c13.OwnerID=u2.id;
            c13.Name='test Fils DSP MAÎTRE 123123';
            c13.ContratCadre__c = c1.id;
            c13.DatePriseEffet__c = Date.Today();
            c13.TypeReconduction__c = 'RNUL';
            listCont.add(c13);
            
            Contrat__c c12= new Contrat__c();
            c12.NomPartenaire__c=a1.Id;
            c12.ReconductionFaitAutorisee__c = true;
            c12.OwnerID=u2.id;
            c12.Name='test Fils DSP MAÎTRE 123 MAÎTRE 123123';
            c12.ContratCadre__c = c1.id;
            c12.DatePriseEffet__c = Date.Today();
            c12.TypeReconduction__c = 'RNUL';
            listCont.add(c12);
            
            Contrat__c c14= new Contrat__c();
            c14.NomPartenaire__c=a1.Id;
            c14.ReconductionFaitAutorisee__c = true;
            c14.OwnerID=u2.id;
            c14.Name='test Fils DSP  123 123123';
            c14.ContratCadre__c = c1.id;
            c14.DatePriseEffet__c = Date.Today();
            c14.TypeReconduction__c = 'RNUL';
            listCont.add(c14);
            
            Contrat__c c15= new Contrat__c();
            c15.NomPartenaire__c=a1.Id;
            c15.ReconductionFaitAutorisee__c = true;
            c15.OwnerID=u2.id;
            c15.Name='test Fils DSP 12 DSP 123 123123';
            c15.ContratCadre__c = c1.id;
            c15.DatePriseEffet__c = Date.Today();
            c15.TypeReconduction__c = 'RNUL';
            listCont.add(c15);
            
            Contrat__c c16= new Contrat__c();
            c16.NomPartenaire__c=a1.Id;
            c16.ReconductionFaitAutorisee__c = true;
            c16.OwnerID=u2.id;
            c16.Name='test Fils 1234  123 123123';
            c16.ContratCadre__c = c1.id;
            c16.DatePriseEffet__c = Date.Today();
            c16.TypeReconduction__c = 'RNUL';
            listCont.add(c16);
            
            Contrat__c c4= new Contrat__c();
            c4.NomPartenaire__c=a1.Id;
            c4.ReconductionFaitAutorisee__c = true;
            c4.OwnerID=u2.id;
            c4.Name='test Fils';
            c4.ContratCadre__c = c11.id;
            c4.DatePriseEffet__c = Date.Today();
            c4.TypeReconduction__c = 'RNUL';
            listCont.add(c4);
            insert listCont;
            
            contact mycontact = testUtils.createContact('test 4', a1.Id, null);
            insert mycontact;
            
            ContratContact__c cc = new ContratContact__c(contact__c =mycontact.id,contrat__c =c16.id);
            insert cc;
            
            List<Opportunity> listOpp = new List<Opportunity>();
            opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),null, Label.LC29_NewStage);
            myOpp1.AccountId=a1.Id;
            myOpp1.closeDate=Date.today();
            myOpp1.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp1.Type_pers__c=Label.Renouvellement;
            myOpp1.EstOpportuniteMere__c = true;
            myOpp1.Statut__c=Label.OpportunityStatusEnCours;
            myOpp1.CreerNouveauProjetCommercial__c = true;
            myOpp1.ContratOrigine__c = c1.Id;
            listOpp.add(myOpp1);
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp1', date.today(),null, Label.LC29_NewStage);
            myOpp2.AccountId=a1.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp2.Type_pers__c=Label.Renouvellement;
            myOpp2.EstOpportuniteMere__c = true;
            myOpp2.Statut__c=Label.OpportunityStatusEnCours;
            myOpp2.CreerNouveauProjetCommercial__c = true;
            myOpp2.ContratOrigine__c = c11.Id;
            listOpp.add(myOpp2);            
            insert listOpp;
            
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.SaisieRefP1VentesServices__c=12;
                fds.OffreA1P1VentesServices__c=13;
                fds.tech_previous_changes__c = null;
            }
            Update listFDS;
            
            OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c=myOpp1.id,Contact__c=myContact.id);
            insert oc1;
            
            OpportuniteContact__c oc2 = new OpportuniteContact__c(Opportunite__c=myOpp2.id,Contact__c=myContact.id);
            insert oc2;
            
            test.startTest();
            myOpp1.StageName = Label.PV_Realisation;
            myOpp1.Statut__c =Label.OppBeforeUp_gagne;
            myOpp1.Segment_client__c = Label.SegmentOpp_Collectivites;
            myOpp1.SousSegmentMarche__c = Label.SousSegmentOpp_BatCom;
            myOpp1.Duree_minimale_estimee__c = 2;
            update myOpp1;
            
            c4.Statut__c = Label.LC66_StatutOuv;
            update c4;
            
            Validation_Opportunity.blnAlreadyDone = false;
            myOpp2.StageName = Label.PV_Realisation;
            myOpp2.Statut__c =Label.LC35_Statut;
            myOpp2.Segment_client__c = Label.SegmentOpp_Collectivites;
            myOpp2.SousSegmentMarche__c = Label.SousSegmentOpp_BatCom;
            myOpp2.Duree_minimale_estimee__c = 2;
            update myOpp2;
            test.stopTest();
  
        }
    }
}