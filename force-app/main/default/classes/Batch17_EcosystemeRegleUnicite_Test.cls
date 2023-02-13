/**
* This class contains unit tests for validating the behavior of the batch Batch17_EcosystemeRegleUnicite
* Coverage 100%
*/
@isTest
public class Batch17_EcosystemeRegleUnicite_Test 
{
    @isTest
    static void  Batch17_EcosystemeRegleUnicite_Test() 
    {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        //u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        
        System.runAs(u2) 
        {
            //create first Account
            account myaccount= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            myaccount.Lieu_immatriculation_legale__c ='TEST';
            insert myaccount;
            
            //create second Account
            account myaccount2= testUtils.createAccount2('testAccount', 'Lebanon', 'Privé');
            myaccount2.Lieu_immatriculation_legale__c ='TEST';
            insert myaccount2;
            
            //create opportunity
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Etude');
            myOpp.AccountId=myaccount.Id;
            myOpp.closeDate=Date.today();
            //myOpp.Record_type__c=LAbel.OppType_EvRen;
            myOpp.CreerNouveauProjetCommercial__c = true;
            myOpp.Statut__c = 'En cours';
            insert myOpp;
            
            //create EcosystemePartenaire__c
            EcosystemePartenaire__c ecosystem = new EcosystemePartenaire__c();
            ecosystem.Opportunite__c =myOpp.id;
            //ecosystem.Partenaire__c=myaccount.ID;
            ecosystem.TypeRelation__c='Représenté par';
            ecosystem.PartenaireLie__c=myaccount2.Id;
            insert ecosystem;
            
            Test.startTest(); 
            // Starting the tests
            Set<Id> setIds= new Set<Id>();
            System.debug('ecosystemid ' + ecosystem.id);
            EcosystemePartenaire__c esp = [Select id,ChampsConcateneRegleUnicite__c,ZZZTechEcosystemeRegleUnicite__c from EcosystemePartenaire__c where id=:ecosystem.id];
            System.debug('ChampsConcateneRegleUnicite__c ' + esp.ChampsConcateneRegleUnicite__c);
            esp.ZZZTechEcosystemeRegleUnicite__c = '';
            update esp;
            System.debug('ZZZTechEcosystemeRegleUnicite__c ' + esp.ZZZTechEcosystemeRegleUnicite__c);
            setIds.add(ecosystem.id);
            //Initialiazing and calling the batch
            Batch17_EcosystemeRegleUnicite testBatch=new Batch17_EcosystemeRegleUnicite(setIds);
            DataBase.executeBatch(testBatch);
            
            Test.stopTest();
        }
    }
    
    
}