/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: Test Class for LC49_RefuserApprouver
*/
@istest(SeeAllData=true)
public class LC49_RefuserApprouver_test {
@istest
    static void testLC()
    {
         	 List<User> ListUs = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u1 = testUtils.CreateUser('standt28', 'user1111@testorg2.com', 'Testing2', p.Id, 'user1rrr@testorg2.com');
        u1.Bypass_Workflow__c = true;
        u1.BypassProcessBuilder__c = true;
        u1.BypassFilters__c = true;
        insert u1;
        
        System.runAs(u1) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
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
            update Fiche1;
            
       	    Approbation__c App = new Approbation__c();
            App.Name = 'Test';
            App.tech_FicheDeSynthese__c = Fiche1.Id;
            App.Statut__c= Label.LC48_Soumis;
            App.Approbateur_actuel__c = u1.id;
            App.tech_Attribue__c = u1.id;
            insert App;
            
        	LC49_RefuserApprouver.Load(App.id);
       		LC49_RefuserApprouver.Approuver(App.id, 'comm');
       	    LC49_RefuserApprouver.Refuser(App.id, 'comm');
        }
    }
}