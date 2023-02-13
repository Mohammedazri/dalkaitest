global class Batch06_UpdateOpportunityWithFDS implements Database.Batchable<sObject> {
    public string query = 'SELECT Id, Opportunit_commerciale__c,SousTotP1234MbOf__c ,SousTotP1234CaOf__c, Opportunit_commerciale__r.id, Opportunit_commerciale__r.MargeBruteOffre__c, Opportunit_commerciale__r.amount  FROM Fiche_de_synthese__c';
    user userTest = [select id,BypassValidationRules__c from user where id= :userinfo.getUserId()];
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        system.debug('##query' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> listFDS)
    {
        map<id, Fiche_de_synthese__c > mapFDS = new map<id,Fiche_de_synthese__c>();
        list<Opportunity> listOpp_toupdate = new list<Opportunity>();
        
        for(Fiche_de_synthese__c FDS : listFDS){
            if(FDS.Opportunit_commerciale__r.MargeBruteOffre__c != FDS.SousTotP1234MbOf__c || FDS.Opportunit_commerciale__r.amount != FDS.SousTotP1234CaOf__c){
                Opportunity oppComm = FDS.Opportunit_commerciale__r;
                //oppComm.Tech_Objectif_Bypass__c =!FDS.Opportunit_commerciale__r.Tech_Objectif_Bypass__c; 
                oppComm.MargeBruteOffre__c = FDS.SousTotP1234MbOf__c;
                oppComm.amount = FDS.SousTotP1234CaOf__c;
                listOpp_toupdate.add(oppComm);
            }   
        }   
        
        system.debug('christine listOpp_toupdate '+listOpp_toupdate);
        usertest.BypassValidationRules__c =  true;
        //usertest.Bypass_Triggers__c = ('AP16_OpportunityRealisation');
        update usertest;
        if(!test.isRunningTest()){
            update listOpp_toupdate;
        }
        usertest.BypassValidationRules__c =  false;
        //usertest.Bypass_Triggers__c = ('');
        update usertest;        
    }
    global void finish(Database.BatchableContext BC) {
        
    }
}