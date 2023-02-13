/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EI-Technologies
Description: batch used to update the field Heures P2 (écart) on opportunity from the FDS
Test Class: Batch103_OppHeureP2Ecart_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/

global class Batch103_OppHeureP2Ecart implements Database.Batchable<sObject> {

    global Batch103_OppHeureP2Ecart (){   
    }

    /** 
    * @author Charbel Khoury Hanna
    * @date 26/11/2020
    * @chercher les fiche de syntheses
    */    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        system.debug('*** start Batch103_OppHeureP2Ecart ***');
        
        String query = 'SELECT id, Opportunit_commerciale__c, EcartMainOeuvreDontNbHeureP2__c, OffreA1MainOeuvreDontNbHeureP2__c ' 
                        +' FROM Fiche_de_synthese__c ';
        
        return Database.getQueryLocator(query);
    }
    
    /** 
    * @author Charbel Khoury Hanna
    * @date 26/11/2020
    * @mettre à jour le champ Heures P2 (écart) au niveau de l'opportunité
    */
    global void execute(Database.BatchableContext BC, List<Fiche_de_synthese__c> listFDS)
    {
        List<Opportunity> listOpp = new List<Opportunity>();
        
        for(Fiche_de_synthese__c FDS : listFDS)
        {
            if(FDS.Opportunit_commerciale__c != null)
            {
                Opportunity opp = new Opportunity();
                opp.id = FDS.Opportunit_commerciale__c;
                opp.ZZZ_Tech_Heures_P2_Ecart__c = FDS.EcartMainOeuvreDontNbHeureP2__c;
                opp.Heures_P2_Offre__c = FDS.OffreA1MainOeuvreDontNbHeureP2__c;
                listOpp.add(opp);   
            }
        }
        
        if(listOpp.size() > 0)
        {
            update listOpp;
        }
    }
    global void finish(Database.BatchableContext BC) 
    {
        system.debug('*** finish Batch103_OppHeureP2Ecart ***');
    }
}