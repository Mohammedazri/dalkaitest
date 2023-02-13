/**
* @author Jacques Akiki -EI Technologies
* @date 17/05/2019
* @description Test Class for Batch47_DateSoumissionApp 
*/
@istest
public class Batch47_DateSoumission_test {
@istest 
    static void testSoumission()
    {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c=Label.LC30_TEST_CodeRegion;
        u2.BypassValidationRules__c =true;
        u2.Bypass_Workflow__c=true;
        u2.BypassProcessBuilder__c=true;
        insert u2;
        System.runAs(u2) 
        {
            account a1=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            a1.BillingCity='test';
            a1.BillingPostalCode='111';
            a1.StatutPartenaire__c = Label.WS11_OUV;
            insert a1;
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.OwnerId=u2.id;
            myOpp.accountId=a1.Id;
            myOpp.Annee_de_signature__c=Label.LC30_TEST_Anne;
            myOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Evolution).getRecordTypeId();
            myOpp.Type_pers__c=Label.PV_Evolution;
            insert myOpp;
            
            Test.startTest();
            
            /*fiche_de_synthese__c myFiche=new fiche_de_synthese__c();
            myFiche.Opportunit_commerciale__c=myOpp.Id;
            myFiche.Name='test1';
            myFiche.P6MbOf__c=12;
            myFiche.P6CaOf__c=11;
            insert myFiche;*/
            //Sprint 31: Modified by Jimmy US C360-717: FDS is now automatically create with opp
            List<Fiche_de_synthese__c> listFDS= [Select id From Fiche_de_synthese__c] ;
            
            for(Fiche_de_synthese__c fds:listFDS){
                fds.P6MbOf__c=12;
                fds.P6CaOf__c=11;
            }
            Update listFDS;
            
            Approbation__c app =new Approbation__c(Name='test',Date_de_soumission__c=DateTime.now(),tech_FicheDeSynthese__c=listFDS[0].id);
            insert app;
            Id BatchId = Database.executeBatch(new Batch47_DateSoumissionApp(''));
            Test.stopTest();
        }
    }
}