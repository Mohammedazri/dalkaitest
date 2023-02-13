/**
* @author Jacques Akiki -EI Technologies
* @date 31/01/2018
* @description Test class 
* @Coverage:  100%
*/

@istest
public class Batch32_UpdateAvenant_test 
{
    @isTest
    static void  TestBatch() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        insert u2;
        
        System.runAs(u2) 
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c='OUV';
            myaccount.Code_NACE__c = '123';
            myaccount.SIRET__c = '112233';
            myaccount.Categorie_partenaire__c = 'DLK';
            myaccount.Siege_social_partenaire__c = true;
            insert myaccount;
            Contrat__c c1= new Contrat__c();
            c1.NomPartenaire__c=myaccount.Id;
            c1.avenant__c = 'Non';
            insert c1;
            Opportunity myOpp =testUtils.createOpportunity('test', Date.today() , null, 'Piste');
            myOpp.AccountId = myaccount.Id;
            myOpp.Statut__c = 'En cours';
            myOpp.Type_pers__c = Label.PV_Evolution;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Duree_minimale_estimee__c = 1;
            myOpp.Segment_client__c = 'Santé';
            myOpp.CreerNouveauProjetCommercial__c = true;
            myOpp.ContratOrigine__c = c1.id ;
            myOpp.Societevente__c = myaccount.id;
            insert myOpp;
            /*Fiche_de_synthese__c myFDS = testUtils.CreateFDS();
myFDS.Opportunit_commerciale__c = myOpp.id;
insert myFDS;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.OffreA1P1VentesServices__c = 0;
            }
            Update listFDS;
            
            Contact cont = new Contact();
            cont.LastName = 'TEST';
            cont.FirstName = 'TEST';
            cont.Title = 'M';
            cont.Email = 'test.test@test.test';
            cont.Phone = '123';
            cont.Statut__c = 'Actif';
            
            Contact cont1 = new Contact();
            cont1.LastName = 'TEST1';
            cont1.FirstName = 'TEST1';
            cont1.Title = 'M';
            cont1.Email = 'test.test1@test.test';
            cont1.Phone = '1231';
            cont1.Statut__c = 'Actif';
            
            insert new List<Contact> {cont,cont1};
                
                OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= cont.id);
            OpportuniteContact__c oc1 = new OpportuniteContact__c(Opportunite__c = myOpp.id, Contact__c= cont1.id);
            insert new List<OpportuniteContact__c> {oc,oc1};
                
                Test.startTest();
            myOpp.Statut__c = Label.OppBeforeUp_gagne;
            myOpp.StageName = Label.PV_Realisation;
            myOpp.ZZZ_TECH_RealiseDuChemin__c = true;
            Update myOpp;
            Batch32_UpdateAvenant testBatch = new Batch32_UpdateAvenant();
            DataBase.executeBatch(testBatch);
            Test.stopTest();
            contrat__c c = [select id,Avenant__c from contrat__c where id=:c1.id limit 1];
            system.assertEquals('Oui', c.Avenant__c);
        }
    }
}