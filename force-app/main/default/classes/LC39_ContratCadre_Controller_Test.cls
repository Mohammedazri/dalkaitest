/*--------------------------------------------------------------------------------------------------------------------------
Company: EI-Technologies
Description: test class for controller LC39_ContratCadre_Controller.
History
<Date>      <Authors Name>      <Brief Description>
29/10/2018	Jacques Akiki		 Creation
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class LC39_ContratCadre_Controller_Test {
    static testMethod void testCreationOpp() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        list<User> listUS = new List<User>();
        User u1 = testUtils.CreateUser('standt21', 'user21111@testorg1.com', 'Testing1', p.Id, 'user12rrr@testorg1.com');
        listUS.add(u1);
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;
        u2.BypassFilters__c = true;
        listUS.add(u2);
        insert listUS;
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.Immatriculation_Legale__c = 'test1';
        myaccount.Type_immatriculation__c = 'RCS';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        account myaccount2= testUtils.createAccount2('tes2', 'Lebanon', 'Privé');
        myaccount2.Lieu_immatriculation_legale__c = 'tes2';
        myaccount2.Immatriculation_Legale__c = 'test1';
        myaccount2.Type_immatriculation__c = 'RCS';
        myaccount2.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount2;
      
        System.runAs(u2) {
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp.EstOpportuniteMere__c = true;
            myOpp.AccountId = myaccount.id; 
            insert(myOpp);
            ProjetCommercial__c project= new ProjetCommercial__c(name='test',OpportunitCommerciale__c=myOpp.id);
            insert(project);
            myOpp.ProjetCommercial__c=project.id;
            update(myOpp);
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id,OwnerID=u1.id, EstContratCadre__c = true);
            mycontrat.TypeReconduction__c = 'RNUL';
            mycontrat.DatePriseEffet__c = System.Today() -2;
            mycontrat.DureeInitialeContrat__c = 1;
            mycontrat.NombreReconductionsPassees__c = 1;
            mycontrat.DureeReconduction__c = 1;
            mycontrat.NombreReconductionsAutorisees__c = 1;
            mycontrat.DureeProlongationTotale__c = 1;
            insert(mycontrat);
            
            EcosystemePartenaire__c myEco = new EcosystemePartenaire__c();
            myEco.PartenaireLie__c = myaccount2.Id;
            myEco.TypeRelation__c = 'Concurrents';
            myEco.Contrat__c = mycontrat.Id;
            insert myEco;
            
            test.startTest();
            LC39_ContratCadre_Controller.getContratType(mycontrat.id);
            mycontrat=LC39_ContratCadre_Controller.getCurrentObject(mycontrat.id);
            opportunity newopp=new opportunity(Name='test opp 2',StageName='Piste',CloseDate=date.today(),Moisdesignature__c ='Février',Annee_de_signature__c='2017');
            id newid2=LC39_ContratCadre_Controller.CreateOpportunityRenouvellement(newopp, mycontrat.id);
            LC39_ContratCadre_Controller.GetStagesPicklist();
            LC39_ContratCadre_Controller.GetMoisPicklist();
            LC39_ContratCadre_Controller.GetAnneePicklist();
            test.stopTest();
        }
    }
}