/**
* @author: Jimmy Khalil
* @date: 21/06/2022
* @description: Test Class for "AP112_Opportunity" 
*/
@isTest
public class AP112_Opportunity_test {
    static testMethod void test()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name=:Label.Profile_DAC];
        
        siege__c siege1= new siege__c();
        siege1.Name='SIEGE GROUPE DALKIA';
        siege1.Code_Siege__c='DKSG';
        insert siege1;
        
        region__c region1= new region__c();
        region1.Name='DALKIA FRANCE REGION CENTRE EST';
        region1.code_region__c='OCES';
        region1.siege__c=siege1.Id;
        insert region1;
        
        agence__c agence1= new agence__c();
        agence1.Name='AGENCE COMMERCIALE MARCHE SANTE ET GRAND PROJETS';
        agence1.code_agence__c='OCESCOM2';
        agence1.region__c=region1.Id;
        agence1.DkCode__c = 'A-1234';
        Insert agence1;
        
        User u1 = testUtils.CreateUser('standt28', 'userAdminAP112@testorg2.com', 'userAdminAP112', Label.AdminProfileId, 'userAdminAP112@testorg2.com');
        u1.isActive = true;
        u1.Nom_agence__c = agence1.Name;
        u1.Code_d_Appartenance__c='OCESCOM2';
        u1.Organisation__c = 'A-1234';
        
        User u2 = testUtils.CreateUser('standt29', 'userDACAP112@testorg2.com', 'userDACAP112', p.Id, 'userDACAP112@testorg2.com');
        u2.isActive = true;
        u2.Nom_agence__c = agence1.Name;
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.Organisation__c = 'A-1234';
        
        insert new List<User> {u1,u2}; 
            
            system.runAs(u1){
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
                cont1.Email = 'test1.test@test.test';
                cont1.Phone = '1231';
                cont1.Statut__c = 'Actif';
                insert new List<Contact> {cont,cont1};
                    
                    list<Account> listAcc = new List<Account>();
                account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
                a1.StatutPartenaire__c='OUV';
                listAcc.add(a1);
                account a2=testUtils.createAccount('testAccoun22', 'Lebanon', 'Privé');
                a2.StatutPartenaire__c='OUV';
                a2.Code_NACE__c = '123';
                a2.SIRET__c = '112233';
                a2.Categorie_partenaire__c = 'DLK';
                a2.Siege_social_partenaire__c = true;
                listAcc.add(a2);
                insert listAcc;
                opportunity myOpp1 = testUtils.createOpportunity ('testOpp1', date.today(),Label.Opp_StatutEnCours, Label.Piste_PicklistValue);
                myOpp1.accountId=a1.Id;
                myOpp1.Segment_client__c = Label.SegmentOpp_Collectivites;
                myOpp1.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
                myOpp1.OwnerId = u1.Id;
                insert myOpp1;
                
                //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
                // Only one fds can be added to a opp
                Fiche_de_synthese__c Fiche1= [Select id From Fiche_de_synthese__c Where Opportunit_commerciale__c =:myOpp1.Id Limit 1] ;
                Fiche1.OffreA1P2VentesServices__c = 100;
                update Fiche1;
                
                /*Fiche_de_synthese__c myFDS1 = testUtils.createFDS();
                myFDS1.name = 'test1';
                myFDS1.Opportunit_commerciale__c = myOpp1.id;
                insert myFDS1;*/
                myOpp1.Duree_minimale_estimee__c = 2;
                myOpp1.Societevente__c = a2.id;
                
                OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c = myOpp1.id, Contact__c= cont.id);
                insert oc;
                Test.startTest();
                myOpp1.StageName = Label.PV_Realisation;
                myOpp1.ZZZ_TECH_RealiseDuChemin__c = true; 
                myOpp1.Statut__c=Label.OppBeforeUp_gagne;
                update myOpp1;
                Test.stopTest();
            }
    }
}