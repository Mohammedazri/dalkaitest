/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis 
Company: EI-Technologies
Description: Apex controller for the lightning component LC29_CreationOpportuniteSiResiliation 
Test Class: LC29_CreationOpportunite_Controller_Test
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC29_CreationOpportunite_Controller {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this function returns the value of the field TechIsSave__c which is set true by the workflow WF02_MAJTechIsSave.
             when this field is true a popup message will appear
Inputs: Opportunity ID
Returns: boolean
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static Boolean isSave(id recID){
        
        Opportunity opp= [SELECT  id, name ,TechIsSave__c
                          FROM Opportunity
                          WHERE id=:recID ];
        return opp.TechIsSave__c;
    }    
    
        /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this function creates a new opportunity if the user accepted to create a new Opportunity.
              if not it will only update the field TechIsSave__c to false. 
Inputs:  ID, boolean
Returns: String
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static String handler(id recID, boolean IsCancel ){
        
        Opportunity opp= [SELECT  id ,TechIsSave__c, Annee_de_signature__c,CloseDate,Name,StageName,AccountId,ContratOrigine__c,
                          OwnerId,Probabilite__c,ProjetCommercial__c,Statut__c,Moisdesignature__c
                          FROM Opportunity
                          WHERE id=:recID ]; 
        opp.TechIsSave__c=false;
       // opp.Tech_Objectif_Bypass__c=!opp.Tech_Objectif_Bypass__c;
        try
        {
            if(IsCancel)
            {
                update opp;  
                return 'OK';
            }
            else
            {             
                update opp;
                Opportunity oppToInsert = new Opportunity();
                
                oppToInsert.Annee_de_signature__c=opp.Annee_de_signature__c;
                oppToInsert.CloseDate=opp.CloseDate;
                oppToInsert.Name=opp.Name;
                oppToInsert.StageName=Label.LC29_NewStage;
                oppToInsert.AccountId=opp.AccountId;
                oppToInsert.ContratOrigine__c=opp.ContratOrigine__c;
                oppToInsert.OwnerId=opp.OwnerId;
                oppToInsert.Probabilite__c=0;
                oppToInsert.ProjetCommercial__c=opp.ProjetCommercial__c;
                oppToInsert.Statut__c=Label.LC29_newStat;
                oppToInsert.Moisdesignature__c =opp.Moisdesignature__c ;
                
                insert oppToInsert;
                
                return oppToInsert.id;
            }
        }
        catch(System.DMLException e)
        { 
            return e.getDmlMessage(0);
            
        }
        
    }
    
}