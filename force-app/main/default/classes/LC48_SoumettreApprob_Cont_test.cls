/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: Test Class for LC48_SoumettreApprob_Controller
*/
@istest
public class LC48_SoumettreApprob_Cont_test {
    @isTest(SeeAllData=true)
    static void testmeth()
    {
        List<User> ListUs = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user1111@testorg2.com', 'Testing2', p.Id, 'user1rrr@testorg2.com');
        ListUs.add(u1);
        User u2 = testUtils.CreateUser('standt28', 'user2222@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        ListUs.add(u2);
        User u3 = testUtils.CreateUser('standt28', 'user3333@testorg2.com', 'Testing2', p.Id, 'user3rrr@testorg2.com');
        ListUs.add(u3);
        User u4 = testUtils.CreateUser('standt28', 'user4444@testorg2.com', 'Testing2', p.Id, 'user4rrr@testorg2.com');
        ListUs.add(u4);
        User u5 = testUtils.CreateUser('standt27', 'user4444@testorg5.com', 'Testing5', p.Id, 'user4rrr@testorg5.com');
        ListUs.add(u5);
        
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        insert ListUs;
        
        System.runAs(u5) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = 'OUV';
            insert a1;
            
            //create and insert opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.OwnerID=u1.id;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            myOpp.Annee_de_signature__c='2017';
            myOpp.Statut__c = 'En cours';
            insert myOpp;
            
            //create Fiche_de_synthese__c
            /*Fiche_de_synthese__c Fiche1= New Fiche_de_synthese__c();
            Fiche1.Name='testFiche1';
            Fiche1.Opportunit_commerciale__c=myOpp.Id;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            Fiche1.Approbateur1__c = u1.id;
            Fiche1.Approbateur2__c = u2.id;
            Fiche1.Approbateur3__c = u3.id;
            Fiche1.Approbateur4__c = u4.id;
            
            update Fiche1;
            LC48_SoumettreApprob_Controller.LunchApprove(Fiche1.Id,Fiche1,'Test');
        }
    }
}