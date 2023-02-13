/**
* @author Jimmy Khalil - EIT Mena
* @date 26/07/2022
* @description Test Class Batch129_RenseigneFDS
*/

@isTest
public class Batch129_RenseigneFDS_Test {
    
    @isTest
    static void  testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c = true;
        insert u2;
        
        
        String myOpp2Id;
        
        
        System.runAs(u2) 
        {
            
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
            
            Contact contct = new Contact();
            contct.LastName = 'TEST';
            contct.FirstName = 'TEST';
            contct.Title = 'M';
            contct.Email = 'test.test@test.test';
            contct.Phone = '123';
            contct.Statut__c = 'Actif';
            insert contct;
            
            //Opps at Proposition FDS non renseignée -> Bypass on Validation Rules
            opportunity myOpp2 = testUtils.createOpportunity ('testOpp2', date.today(),Label.OpportunityStatusEnCours, Label.OpportunityStagePiste);
            myOpp2.AccountId=a1.Id;
            myOpp2.closeDate=Date.today();
            myOpp2.Amount=3;
            myOpp2.Type_pers__c = Label.PV_Opp_Type_Nouveau;
            insert myOpp2;
            
            OpportuniteContact__c oc = new OpportuniteContact__c(Opportunite__c=myOpp2.id,Contact__c=contct.id);
            insert oc;
            
            myOpp2.Segment_client__c = Label.SegmentOpp_Collectivites;
            myOpp2.SousSegmentMarche__c =Label.SousSegmentOpp_BatCom;
            myOpp2.Duree_minimale_estimee__c = 2;
            myOpp2.Societevente__c = a2.id;
            myOpp2.StageName = Label.LC28_Proposition;
            update myOpp2;
            
            
            myOpp2Id = myOpp2.Id;
            
        }
        
        List<Fiche_de_synthese__c> relatedFDS= [Select id,ZZZ_FdS_completee__c From Fiche_de_synthese__c Where Opportunit_commerciale__r.Id =: myOpp2Id];
        System.assertEquals(0, relatedFDS[0].ZZZ_FdS_completee__c);
        
        Test.startTest();
        Id BatchId = Database.executeBatch(new Batch129_RenseigneFDS());
        Test.stopTest();
        
        relatedFDS= [Select id,ZZZ_FdS_completee__c From Fiche_de_synthese__c Where Opportunit_commerciale__r.Id =: myOpp2Id];
        System.assertEquals(1, relatedFDS[0].ZZZ_FdS_completee__c);
        
        
    }
    
}