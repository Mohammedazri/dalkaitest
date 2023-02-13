/** 
* @author Alain Ghoussoub - Ei technologies
* @date 26/09/2020 
* @description Batch qui recopie les champs de prestation du contrat sur l'opp. d'origine, les opp. d'évolution, et les opportunités de renouvellement non réalisées
* @Test Class Batch88_OpportunitePrestation_Test
*/
global class Batch88_OpportunitePrestation implements Database.Batchable<SObject>{
    /** 
* @author Alain Ghoussoub
* @date 26/08/2020   
* @chercher les contrats
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id,ContratOrigine__c,Contrat_Genere_lookup__c,Type_pers__c,'
            +' ContratOrigine__r.TypeContratFirst__c,'
            +' ContratOrigine__r.TypePrestations__c,'
            +' ContratOrigine__r.TypeEnergie__c,'
            +' ContratOrigine__r.TransparenceP3__c,'
            +' ContratOrigine__r.RapportActivite__c,'
            +' Contrat_Genere_lookup__r.TypeContratFirst__c,'
            +' Contrat_Genere_lookup__r.TypePrestations__c,'
            +' Contrat_Genere_lookup__r.TypeEnergie__c,'
            +' Contrat_Genere_lookup__r.TransparenceP3__c,'
            +' Contrat_Genere_lookup__r.RapportActivite__c'
            +' from opportunity where (ContratOrigine__c = null and Contrat_Genere_lookup__c != null) OR (ContratOrigine__c != null and Contrat_Genere_lookup__c = null) OR (ContratOrigine__c != null and Contrat_Genere_lookup__c != null)';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Alain Ghoussoub
* @date 28/08/2020  
* @recopie les champs de prestation du contrat sur l'opp. d'origine, les opp. d'évolution, et les opportunités de renouvellement non réalisées
* @param Database.BatchableContext and list of Contrat__c
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        for(Opportunity opp : listOpp){
            if(opp.ContratOrigine__c == null && opp.Contrat_Genere_lookup__c != null){
                opp.TypeContratFirst__c = opp.Contrat_Genere_lookup__r.TypeContratFirst__c;
                opp.TypePrestations__c = opp.Contrat_Genere_lookup__r.TypePrestations__c;
                opp.TypeEnergie__c = opp.Contrat_Genere_lookup__r.TypeEnergie__c;
                opp.TransparenceP3__c = opp.Contrat_Genere_lookup__r.TransparenceP3__c;
                opp.RapportActivite__c = opp.Contrat_Genere_lookup__r.RapportActivite__c;
            }
            else if(opp.ContratOrigine__c != null && opp.Type_pers__c == Label.Evolution){
                opp.TypeContratFirst__c = opp.ContratOrigine__r.TypeContratFirst__c;
                opp.TypePrestations__c = opp.ContratOrigine__r.TypePrestations__c;
                opp.TypeEnergie__c = opp.ContratOrigine__r.TypeEnergie__c;
                opp.TransparenceP3__c = opp.ContratOrigine__r.TransparenceP3__c;
                opp.RapportActivite__c = opp.ContratOrigine__r.RapportActivite__c;
            }
            else if(opp.Contrat_Genere_lookup__c != null && opp.Type_pers__c == Label.Renouvellement){
                opp.TypeContratFirst__c = opp.Contrat_Genere_lookup__r.TypeContratFirst__c;
                opp.TypePrestations__c = opp.Contrat_Genere_lookup__r.TypePrestations__c;
                opp.TypeEnergie__c = opp.Contrat_Genere_lookup__r.TypeEnergie__c;
                opp.TransparenceP3__c = opp.Contrat_Genere_lookup__r.TransparenceP3__c;
                opp.RapportActivite__c = opp.Contrat_Genere_lookup__r.RapportActivite__c;
            }
            else if(opp.Contrat_Genere_lookup__c == null && opp.Type_pers__c == Label.Renouvellement){
                opp.TypeContratFirst__c = opp.ContratOrigine__r.TypeContratFirst__c;
                opp.TypePrestations__c = opp.ContratOrigine__r.TypePrestations__c;
                opp.TypeEnergie__c = opp.ContratOrigine__r.TypeEnergie__c;
                opp.TransparenceP3__c = opp.ContratOrigine__r.TransparenceP3__c;
                opp.RapportActivite__c = opp.ContratOrigine__r.RapportActivite__c;
            }
        }
        if(listOpp != null && listOpp.size()>0){
            update listOpp;
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}