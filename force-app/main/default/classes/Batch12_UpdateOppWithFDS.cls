/*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar
Company: EI-Technologies
Description: batch used to update the fields on opportunity from the FDS
Test Class: Batch12_UpdateOppWithFDS_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

global class Batch12_UpdateOppWithFDS implements Database.Batchable<sObject> {
    
    user userTest = [select id,BypassValidationRules__c from user where id= :userinfo.getUserId()];
    Set<Id> setIds = new Set<Id>();

    
    global Batch12_UpdateOppWithFDS (){   
    }

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id, Opportunit_commerciale__c, OffreA1SousTotP1234MbOf__c,OffreA1SousTotP1234CaOf__c , Opportunit_commerciale__r.MargeBruteOffre__c,'
        +'Opportunit_commerciale__r.antimodifmanuelleCA_MB__c, Opportunit_commerciale__r.amount ,Opportunit_commerciale__r.Tech_Objectif_Bypass__c FROM Fiche_de_synthese__c';
        //query = query + ' where Opportunit_commerciale__c = \'00625000007YlBgAAK\'';
		//query = query + 'AND budget__r.AnneeBudget__c=\'2018\'';

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> listFDS)
    {
        list<Opportunity> listOpp_toupdate = new list<Opportunity>();
        boolean modif = false;
        for(Fiche_de_synthese__c FDS : listFDS){
            modif = false;
            Opportunity oppComm = FDS.Opportunit_commerciale__r;
            if( FDS.OffreA1SousTotP1234MbOf__c != oppComm.MargeBruteOffre__c )
            { 
                oppComm.MargeBruteOffre__c = FDS.OffreA1SousTotP1234MbOf__c;
                oppComm.antimodifmanuelleCA_MB__c = string.ValueOf(Date.today());
                modif = true;
            }
            if( FDS.OffreA1SousTotP1234CaOf__c != oppComm.amount )
            { 
                oppComm.amount = FDS.OffreA1SousTotP1234CaOf__c;
                oppComm.antimodifmanuelleCA_MB__c = string.ValueOf(Date.today());
                modif = true;
            }  
            if (modif) {
	            listOpp_toupdate.add(oppComm);                
            }
        }
        system.debug('[PJB] listOpp_toupdate '+listOpp_toupdate);
        system.debug('[PJB] listOpp_toupdate '+listOpp_toupdate.size());
        usertest.BypassValidationRules__c =  true;
        //usertest.Bypass_Triggers__c = ('AP16_OpportunityRealisation');
        update usertest;
        update listOpp_toupdate;
        usertest.BypassValidationRules__c =  false;
        //usertest.Bypass_Triggers__c = ('');
        update usertest;       
    }
    global void finish(Database.BatchableContext BC) {
    }
}