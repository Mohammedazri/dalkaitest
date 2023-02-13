/**
* This class contains unit tests for validating the behavior of Apex classes AP08_Opportunity
*/
@isTest
public class AP26_DeleteEcosystem_Test 
{
    @isTest
    static void myUnitTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        //create first Account
        account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.Lieu_immatriculation_legale__c ='TEST';
        insert myaccount;
        
        //create second Account
        account myaccount2= testUtils.createAccount2('testAccount', 'Lebanon', 'Privé');
        myaccount2.Lieu_immatriculation_legale__c ='TEST';
        insert myaccount2;
        
        //create user
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com'); 
        u2.Code_d_Appartenance__c='OCESCOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            //create opportunity
            Opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            myOpp.Type_pers__c= Label.PV_Evolution;
            myOpp.RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.CreerNouveauProjetCommercial__c = true;
            insert myOpp;
            Test.startTest();// start test 
            
            //create EcosystemePartenaire__c
            EcosystemePartenaire__c ecosystem = new EcosystemePartenaire__c(Opportunite__c =myOpp.id, /*Partenaire__c=myaccount.ID,*/TypeRelation__c='Représenté par',PartenaireLie__c=myaccount2.Id);
            insert ecosystem;
            
            //query all the EcosystemePartenaire__c
            List<EcosystemePartenaire__c> ecosystem1=[SELECT id,TypeRelation__c
                                               FROM EcosystemePartenaire__c ];
            
            System.debug('ecosystem1 size' + ecosystem1.size());
            
            //system.assert(ecosystem1.size()==1);// assert to check that the antagonist EcosystemePartenaire__c is created 
			AP26_DeleteEcosystem.DeleteRepresenteDe(ecosystem1);
            // delete the main EcosystemePartenaire__c
            delete ecosystem;
            
            //query all the EcosystemePartenaire__c
            List<EcosystemePartenaire__c> ecosystem2=[SELECT id,TypeRelation__c
                                               FROM EcosystemePartenaire__c ];
            System.debug('ecosystem2 size' + ecosystem2.size());
            
            //system.assert(ecosystem2.size()==0);// assert to check that the antagonist EcosystemePartenaire__c is deleted 
            
            Test.stopTest();// end test 
        }
    }
    
}