@isTest
public class LC37_CreationOppFille_test {
    static testMethod void testCreationOpp() {
        Profile p = [SELECT Id FROM Profile WHERE id=:Label.AdminProfileId];
        
        User u2 = testUtils.CreateUser('standt28', 'user21111@testorg2.com', 'Testing2', p.Id, 'user2rrr@testorg2.com');
        u2.BypassValidationRules__c=true;
        u2.BypassFilters__c = true;
        insert u2;
        account myaccount=testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
        myaccount.BillingCity='test';
        myaccount.BillingPostalCode='111';
        myaccount.StatutPartenaire__c = Label.WS11_OUV;
        insert myaccount;
        
        System.runAs(u2) {
            
            
            opportunity myOpp = testUtils.createOpportunity ('testOpp', date.today(),null, 'Piste');
            myOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
            myOpp.EstOpportuniteMere__c = true;
            myOpp.AccountId = myaccount.Id;
            insert(myOpp);
            ProjetCommercial__c project= new ProjetCommercial__c(name='test',OpportunitCommerciale__c=myOpp.id);
            insert(project);
            myOpp.ProjetCommercial__c=project.id;
            update(myOpp);
            
            Contrat__c mycontrat= new Contrat__c(Name='test',NomPartenaire__c=myaccount.id,OpportuniteCommerciale__c=myOpp.id,OwnerID=u2.id , EstContratCadre__c = true);
            insert(mycontrat);
            
            myOpp.Contrat_Genere_lookup__c = mycontrat.id;
            update(myOpp);
            test.startTest();
            LC37_CreationOppFille.getCurrentObject(myOpp.id);
            opportunity newopp=new opportunity(Name='test opp',StageName='Piste',CloseDate=date.today(),Moisdesignature__c ='Février',Annee_de_signature__c='2017');
            id newid=LC37_CreationOppFille.CreateOpportunity(newopp, myOpp.id);
            Opportunity Opp = LC37_CreationOppFille.getOpp(myOpp.id);
            LC37_CreationOppFille.GetStagesPicklist();
            LC37_CreationOppFille.GetMoisPicklist();
            LC37_CreationOppFille.GetAnneePicklist();
            test.stopTest();
        }
    }
    
}