/**
* @author: Rita Bejjani -EI Technologies
* @date: 02/07/2019
* @description: Test Class for "AP61_WebserviceLogs" 
*/
@isTest
public class AP61_WebserviceLogs_test {
    
    static testMethod void handleListTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.Code_d_Appartenance__c='OCECOM2';
        u2.BypassValidationRules__c =true;
        u2.BypassFilters__c = true;
        insert u2;
        System.runAs(u2) 
        { 
            List<Account> listAcc = new List<Account>();
            
            Account acc1 =  new Account(Name= 'test1', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392045',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
            listAcc.add(acc1);
            
            Account acc2 =  new Account(Name= 'test2', BillingCountry ='UAE', Type = 'PUB', Code_NACE__c='111', NaturePartenaire__c='ETAB',SIRET__c='392047',Categorie_partenaire__c='EXT',/*Statut__c='ACTIF',*/EntiteCommercialeDalkia__c='J00001003P', BillingCity='test12', BillingPostalCode='11221', BillingState='a2a', BillingStreet='a2aa', RecordtypeId=Label.PartenaireSociete);
            listAcc.add(acc2);
            
            insert listAcc;
            
            TechBatchRelaunch__c tbr = new TechBatchRelaunch__c();
            tbr.Objectid__c = acc1.id;
            tbr.CreatedDate = Date.today();
            insert tbr;
            
            TechBatchRelaunch__c tbrToUpdate = new TechBatchRelaunch__c();
            tbrToUpdate.Objectid__c = acc1.id;
            tbrToUpdate.Type__c = 'typeTest';
            tbrToUpdate.Status__c = 'KO';
            insert tbrToUpdate;
            system.debug('tbrToUpdate ' + tbrToUpdate);
            
            List<WebserviceLog__c> listWS = new List<webserviceLog__c>();
            
            WebserviceLog__c ws1 = new WebserviceLog__c();
            ws1.Request__c = 'test';
            String accountId = acc1.id;
            ws1.Objectid__c = accountId.Substring(0,15);
            ws1.Type__c = 'typeTest';
            ws1.Flux__c = 'sortant';
            ws1.Response__c = 'testResponse';
            ws1.CodeRetour__c = 'ERROR';
            
            listWS.add(ws1);
            
            WebserviceLog__c ws2 = new WebserviceLog__c();
            ws2.Request__c = 'test2';
            String accountId2 = acc2.id;
            ws2.Objectid__c = accountId2.Substring(0,15);
            ws2.Objectid__c = acc2.id;
            ws2.Type__c = 'typeTest2';
            ws2.Flux__c = 'sortant';
            ws2.Response__c = 'testResponse';
            ws2.CodeRetour__c = 'ERROR';
            
            listWS.add(ws2);
            
            insert listWS;
            
            update listWS;
            
            test.startTest();
            
            AP61_WebserviceLogs.handleList(listWS);
            
            test.stopTest();
        }
        
    }
}