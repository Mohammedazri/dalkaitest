/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: Change  record type of contrats related to opportunities if opportunity was not opp mere & became mère or if
             Opportunity was mere and became not mere.
Test Class: AP37_Opportunity_test
Coverage: 84%
-------------------------------------------------------------------------------------------------------------------------------------*/

public class AP37_Opportunity {
/**
* @author: Jacques Akiki -EI Technologies
* @description: change RT of contract when checkbox on Opp mere changes 
* @inputs: List<Opportunity> , map<id,opportunity> 
* @returns: - 
*/  
    public static void ChangeContratRT(List<Opportunity> opportunityList , map<id,opportunity> OldOpp)
    {
        Set<id> SetOppId = new Set<id>();
        for (Opportunity opp : opportunityList)
        {
            if(opp.EstOpportuniteMere__c ==True && OldOpp.get(opp.id).EstOpportuniteMere__c == False
              ||opp.EstOpportuniteMere__c ==False && OldOpp.get(opp.id).EstOpportuniteMere__c == True ) // if opportunity is changed
            {
                SetOppId.add(opp.id); // add opp id to set
            }
        }
        if (SetOppId!=NULL && SetOppId.size()>0)
        {
            /*Query all contracts related to the Opportunities that have the field EstOpportuniteMere__c changed*/
            List<Contrat__c> listContrat = [SELECT id,name,recordTypeId,OpportuniteCommerciale__c, OpportuniteCommerciale__r.EstOpportuniteMere__c , 
                                                   EstContratcadre__c,OpportuniteCommerciale__r.NatureOpportunitMere__c,ContratCadre__c 
                                            FROM Contrat__c 
                                            WHERE OpportuniteCommerciale__c in: SetOppId];
            
            list<Contrat__c> ListContUpdate = new List<Contrat__c> ();
            /*RecordType Id of contrat Cadre*/
            Id recrdTypeCC = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get(Label.RTContrat_ContratCadre).getRecordTypeId();
            /*RecordType Id of Avenant*/
            Id recrdTypeAv = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get(Label.RTContrat_Avenant).getRecordTypeId();
            /*RecordType Id of Fermé*/
            Id recrdTypeFerme = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get(Label.RTContrat_Ferme).getRecordTypeId();
            
            for (Contrat__c cont :listContrat)
            {
                if(cont.OpportuniteCommerciale__r.EstOpportuniteMere__c)
                {
                    if(cont.recordTypeId != recrdTypeFerme){
                        cont.recordTypeId = recrdTypeCC; // if Opportunity was not mère and became mère set RT of related contract to Cadre.
                    }
                    cont.EstContratcadre__c = true;
                    cont.NatureContratCadre__c = cont.OpportuniteCommerciale__r.NatureOpportunitMere__c;
                }
                else
                {
                    if(cont.recordTypeId != recrdTypeFerme){
                        cont.recordTypeId = recrdTypeAv;// if Opportunity was mère and became not mère set RT of related contract to Avenant. 
                    }
                    cont.EstContratcadre__c = false;
                    cont.NatureContratCadre__c = null;
                }
                
                ListContUpdate.add(cont); // add to list of contracts to Update
            }
            
            if (ListContUpdate!=NULL && ListContUpdate.size()>0)
            {
                AP68_UpdateTypeContrat.UpdateContrats(ListContUpdate);
                //try
                //{
                    update ListContUpdate;
                /*}
                catch(exception e)
                {
                    String error = e.getMessage();
                    system.debug('Error in changing Contrat Record Type ------------->' + error);
                }*/
            }
        }
    }
}