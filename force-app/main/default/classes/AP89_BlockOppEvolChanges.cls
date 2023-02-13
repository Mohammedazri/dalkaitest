/** 
* @author:Jacques Akiki
* @date:28/07/2020
* @description:Class Apex qui bloque le changement d'une opportunité d'evolution reliée à un doc contractuel synchronisé
* @Test: AP89_BlockOppEvolChanges_test 100%
*/
public class AP89_BlockOppEvolChanges {
    /** 
* @author: Jacques Akiki
* @date:26/11/2020
* @description: Methode qui ajoute une erreur sur une opportunité d'evolution si on fait un retour en arrière 
* @param oldMapOpp (map of old Opportunities) , newMapOpp (map of new Opportunities)
* @return: void 
*/
    public static void addErrorOppEvol(map<id,Opportunity> oldMapOpp , map<id,Opportunity> newMapOpp)
    {
        set<id> setOppId = new set<id>();
        for(Opportunity opp:newMapOpp.values())
        {
            if(opp.Type_pers__c==Label.Evolution && opp.DureeProlongationSupp__c!=oldMapOpp.get(opp.id).DureeProlongationSupp__c)
            {
                setOppId.add(opp.id);
            }
        }
        if(setOppId!=NULL && setOppId.size()>0)
        {
            // SELECT documents contractuels synchronisés related to opportunities of the previous set
            list<Document_Contractuel__c> listDocCont = [SELECT id,NumeroPiece__c,OpportuniteRattachee__c 
                                                         FROM Document_Contractuel__c
                                                         WHERE OpportuniteRattachee__c in :setOppId and NumeroPiece__c!=NULL
                                                           AND NatureDocument__c = 'DOC05'];
            for(Document_Contractuel__c dc :listDocCont)
            {
                if(newMapOpp.containskey(dc.OpportuniteRattachee__c))
                {
                    newMapOpp.get(dc.OpportuniteRattachee__c).addError(Label.AP89_ErrorMessage);
                }
            }
        }
    }
}