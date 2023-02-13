/** 
* @author Jacques Akiki - Ei technologies
* @date 21/04/2020 
* @description Batch that updates opportunitities according to the new conditions and new dependencies of the fields segment and sous segment
* @Test Class Batch70_UpdateSegmentSousSegment_test
*/
global class Batch70_UpdateSegmentSousSegment implements Database.Batchable<SObject>
{
    
    /** 
* @author Jacques AKiki 
* @date 21/04/2020 
* @ Select all opportunities that should be updated
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        Set <String> setSousSeg = new set<String>{'Bâtiments de l’Etat',Label.SousSegmentOpp_Universite,Label.SousSegmentOpp_Hebergement,Label.SousSegmentOpp_SAC,Label.SousSegmentOpp_MDR,Label.SousSegmentOpp_Autres};
        String query='SELECT id,StageName,SousSegmentMarche__c,Segment_client__c FROM Opportunity WHERE Segment_client__c=\''+Label.SegmentOpp_Collectivites+'\' AND SousSegmentMarche__c in :setSousSeg';
        return Database.getQueryLocator(query ); 
    }
    /** 
* @author Jacques AKiki 
* @date 21/04/2020 
* @ Update the opportunities according to the new mapping
* @param Database.BatchableContext and list of Opportunities
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        /*Pass on all selected Opportunities*/
        for(Opportunity opp : listOpp)
        {
            if(opp.SousSegmentMarche__c==Label.SousSegmentOpp_Universite||opp.SousSegmentMarche__c==Label.SousSegmentOpp_Hebergement
               ||opp.SousSegmentMarche__c==Label.SousSegmentOpp_SAC || opp.SousSegmentMarche__c=='Bâtiments de l’Etat')
            {
                opp.Segment_client__c = Label.SegmentOpp_Tertaire;
            }
            else if(opp.SousSegmentMarche__c == Label.SousSegmentOpp_MDR)
            {
                opp.Segment_client__c = Label.SegmentOpp_Sante;
            }
            else if (opp.SousSegmentMarche__c == Label.SousSegmentOpp_Autres)
            {
                if( opp.StageName ==Label.PV_Realisation)
                {
                    opp.SousSegmentMarche__c = Label.SousSegmentOpp_BatCom;
                }
                else if(opp.StageName == Label.LC28_Proposition)
                {
                    opp.SousSegmentMarche__c = null;
                    opp.StageName = Label.OppStage_Etude;
                }
                else 
                {
                    opp.SousSegmentMarche__c = null;
                }
            }
            
        }
        if (listOpp<>null && listOpp.size()>0)
        {
            update listOpp; 
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}