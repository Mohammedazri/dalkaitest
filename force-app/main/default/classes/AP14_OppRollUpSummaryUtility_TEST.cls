/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Test Class fro AP14_OppRollUpSummaryUtility
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class AP14_OppRollUpSummaryUtility_TEST{
    @isTest
    static void TestClass()
    {    
        Contact cont = new Contact();
        cont.LastName = 'TEST';
        cont.FirstName = 'TEST';
        cont.Title = 'M';
        cont.Email = 'test.test@test.test';
        cont.Phone = '123';
        cont.Statut__c = 'Actif';
        insert cont;
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        insert u2;
        System.runAs(u2) 
        {
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.StatutPartenaire__c = Label.WS11_OUV;
            insert myaccount;
            
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.Amount=30;
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c= Label.PV_Evolution;            
            myOpp.statut__c ='En cours';
            
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp2.AccountId=myaccount.Id;
            myOpp2.Amount=30;
            myOpp2.statut__c ='En cours';
            myOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp2.Type_pers__c= Label.PV_Evolution;            
            insert new list<opportunity>{myOpp, myOpp2};
                
                
                ProjetCommercial__c projetCom = new ProjetCommercial__c(name='test',OpportunitCommerciale__c=myopp.id);
            insert projetCom;
            
            myOpp.ProjetCommercial__c=projetcom.id;
            myOpp.Probabilite__c=50;
            myOpp2.ProjetCommercial__c=projetcom.id;
            myOpp2.Probabilite__c=50;
            update new list<opportunity>{myOpp, myOpp2};
                
                //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
                List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.P1CaOf__c =20;
                fds.P1MbOf__c =20;
            }
            Update listFDS;
            test.startTest();  
            
            OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp2.id, Contact__c= cont.id);
            insert oc;
            myOpp2.statut__c ='Gagnée';
            myOpp2.Segment_client__c ='Habitat';
            myOpp2.Duree_minimale_estimee__c  =2;
            myOpp2.Stagename ='Réalisation';
            myOpp2.CreerNouveauProjetCommercial__c =true;
            update myOpp2;
            
            
            delete myOpp2;
            test.stopTest();
        }
    }
}