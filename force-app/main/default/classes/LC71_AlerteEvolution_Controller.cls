/**
* @author: Jacques Akiki -EI Technologies
* @date: 13/7/2020 
* @description: Controller of LC71_AlerteEvolution that shows alert on opp 
* @Test Class:   LC71_AlerteEvolution_Controller_test
* @Coverage: 100%
*/
public without sharing class LC71_AlerteEvolution_Controller {
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 13/07/2020
* @description:  Makes sure if opportunity is renouvellement and has evolution en cours
* @inputs: id
* @returns: Boolean
*/
    @AuraEnabled
    public static Boolean getOppEvol(Id OppId)
    {
        //Select current Opportunity
        List<Opportunity> currentOpp = [SELECT id,Type_pers__c,ContratOrigine__c FROM Opportunity WHERE id=:OppId];
        
        if(currentOpp!=NULL && currentOpp.size()>0 && currentOpp[0].Type_pers__c==Label.PV_Renouvellement){
            //select opportunities d'evolution reliées au contrat d'origine de  l'opportunité de renouvellement 
            List<Opportunity> listOpp = [SELECT id,Type_pers__c
                                         FROM Opportunity 
                                         WHERE (Type_pers__c =:Label.Evolution AND (StageName !=:Label.PV_Realisation AND Statut__c!=:label.PV_Statut_SansSuite) 
                                                AND ContratOrigine__c=:currentOpp[0].ContratOrigine__c)];
            //s'il existe des opp d'evolution non réalisées.
            if(listOpp!=NULL && listOpp.size()>0){
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }
}