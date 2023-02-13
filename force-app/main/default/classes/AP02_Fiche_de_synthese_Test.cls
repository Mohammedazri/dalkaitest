@isTest
public class AP02_Fiche_de_synthese_Test {
    static testMethod void UpdateResponsableFieldsTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE id=: Label.AdminProfileId ]; 
        //List<User> NewUsersList= New List<User>();
        User u1 = testUtils.CreateUser('standt18', 'standardusereee@testorg1.com', 'Testing', p.Id, 'standarduser1rrr@testorg.com');
        u1.BypassFilters__c = true;
        insert u1;
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.ManagerId=u1.Id;
        Insert u2;
        
        system.runAs(u1)
        {
            Test.startTest();
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Lieu_immatriculation_legale__c = 'test';
            insert a1;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.accountId=a1.Id;
            myOpp.OwnerId=u2.Id;
            myOpp.Statut__c = 'En cours';
            insert myOpp;
            //Sprint 31: Commented by Jimmy US C360-717
            /*Fiche_de_synthese__c Fiche1= New Fiche_de_synthese__c();
            Fiche1.Name='testFiche1';
            Fiche1.Opportunit_commerciale__c=myOpp.Id;
            Fiche1.P6MbOf__c=12;
            Fiche1.P6CaOf__c=11;
            insert Fiche1;*/
            myOpp.OwnerId=u1.Id;
            update myOpp;
            Test.stopTest();
        }
    }
    
    static testMethod void ManagerChangedTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE id=: Label.AdminProfileId]; 
        List<User> NewUsersList= New List<User>();
        User u1 = testUtils.CreateUser('standt19', 'standarduser000@testorg10.com', 'Testing0000', p.Id, 'standarduser100000@testorg.com');
        u1.BypassFilters__c = true;
        insert u1;
        User u2 = testUtils.CreateUser('standt29', 'user000@testorg20.com', 'Testing20000', p.Id, 'user20@testorg200000.com');
        u2.ManagerId=u1.Id;
        NewUsersList.add(u2);
        User u3 = testUtils.CreateUser('standt39', 'user3@testorg3.com', 'Testing3000', p.Id, 'user3000@testorg3.com');
        NewUsersList.add(u3);
        User u4 = testUtils.CreateUser('standt49', 'user4@testorg4.com', 'Testing4000', p.Id, 'user4000@testorg4.com');
        NewUsersList.add(u4);
        User u5 = testUtils.CreateUser('standt59', 'user5@testorg5.com', 'Testing5000', p.Id, 'user5000@testorg5.com');
        NewUsersList.add(u5);
        Insert NewUsersList;
        
        system.runAs(u1){
            Test.startTest();
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.Lieu_immatriculation_legale__c = 'test';
            insert a1;
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.OwnerId=u2.Id;
            myOpp.accountId=a1.Id;
            myOpp.Statut__c = 'En cours';
            insert myOpp;
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            // Only one fds can be added to a opp
            Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp.Id Limit 1] ;
            Fiche1.Name='testFiche1';
            Fiche1.P6MbOf__c=12;
            Fiche1.P6CaOf__c=11;
            update Fiche1;
            u1.ManagerId=u5.Id;
            u2.ManagerId=u3.Id;
            u3.ManagerId=u5.Id;
            u5.ManagerId=u4.Id;
            NewUsersList.add(u1);
            update NewUsersList;
            Test.stopTest();
        }
    }
    
}