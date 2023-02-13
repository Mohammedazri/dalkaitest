@istest
public class AP20_LeadConversion_Test {
    static testmethod void  updateOpportunityContact_test(){
        Account a1 = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '345345', 'abcdef123');
        Insert a1;
        Contact c1 = testUtilsC360.createContact('Test', a1.Id, null, true);
        Insert c1;
        Opportunity opp1 = testUtilsC360.createOpportunityIndepNouveau('testOpp1', String.valueOf(System.Today().year()), Date.today(), Label.OpportunityStatusEnCours, Label.OpportunityStagePiste, a1.Id, null, UserInfo.getUserId());
        Insert opp1;
        lead leadTest = testUtilsC360.CreateLead('test', 'Lead', 'test Company');
        leadTest.SIRET__c = '123456';
        leadTest.TechValidSiret__c = true;
        insert leadTest;
        
        test.startTest(); 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadTest.id);
        lc.setAccountId(a1.Id);
        lc.setContactId(c1.Id);
        lc.setOpportunityId(opp1.Id);
        lc.setConvertedStatus('Converti');
        Database.LeadConvertResult lcr = Database.convertLead(lc);// get the result of the converted lead 
        //Assert that the connexion was created
        System.assertEquals(1, [SELECT id FROM OpportuniteContact__c WHERE opportunite__c=:opp1.Id AND Contact__c=:c1.Id].size());
        
        Contact c2 = testUtilsC360.createContactBenficiaire('Test');
        Insert c2;
        Database.LeadConvert lc2 = new database.LeadConvert();
        
        lead leadTest2 = testUtilsC360.CreateLead('test', 'Lead', 'test Company');
        leadTest2.SIRET__c = '123456';
        leadTest2.TechValidSiret__c = true;
        insert leadTest2;
        lc2.setLeadId(leadTest2.id);
        lc2.setAccountId(a1.Id);
        lc2.setContactId(c2.Id);
        lc2.setDoNotCreateOpportunity(true);
        lc2.setConvertedStatus('Converti');
        try{
            Database.LeadConvertResult lcr2 = Database.convertLead(lc2);// get the result of the converted lead 
        }
        Catch(Exception e){
            System.assert(e.getMessage().contains(Label.AP20_MessageErreur));
        }
        test.stopTest();
    }
}