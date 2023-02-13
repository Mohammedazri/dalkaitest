/** 
* @author Alain Ghoussoub - Ei technologies
* @date 09/07/2020 
* @description Batch qui renseigne la valeur pas de reconduction pour le type de reconduciton sur les opportunités à l'étape réalisation
* @Test Class 
*/
global class Batch82_OppRealisationReconduction implements Database.Batchable<SObject> {
    /** 
* @author Alain Ghoussoub 
* @date 09/07/2020 
* @chercher toutes les opportunités à l'étape réalisation
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='select id,ContratOrigine__c,Contrat_Genere_lookup__c,Type_pers__c,'
            +' ContratOrigine__r.TypeReconduction__c,'
            +' ContratOrigine__r.NombreReconductionsAutorisees__c,'
            +' ContratOrigine__r.DureeReconduction__c,'
            +' ContratOrigine__r.DureePreavis__c,'
            +' ContratOrigine__r.ReconductionFaitAutorisee__c,'
            +' Contrat_Genere_lookup__r.TypeReconduction__c,'
            +' Contrat_Genere_lookup__r.NombreReconductionsAutorisees__c,'
            +' Contrat_Genere_lookup__r.DureeReconduction__c,'
            +' Contrat_Genere_lookup__r.DureePreavis__c,'
            +' Contrat_Genere_lookup__r.ReconductionFaitAutorisee__c,'
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
            +' from opportunity';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Alain Ghoussoub  
* @date 09/07/2020 
* @renseigne la valeur pas de reconduction pour le type de reconduction sur les opportunités à l'étape réalisation
* @param Database.BatchableContext and list of opportunities
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        for(Opportunity opp : listOpp){
            if(opp.ContratOrigine__c == null && opp.Contrat_Genere_lookup__c == null){
                opp.TypeReconduction__c = null;
                opp.NombreReconductionsAutorisees__c = null;
                opp.DureeReconduction__c = null;
                opp.DureePreavis__c = null;
                opp.ReconductionFaitAutorisee__c = false;
            }
            else if(opp.Contrat_Genere_lookup__c == null && opp.Type_pers__c == Label.Renouvellement){
                opp.TypeReconduction__c = null;
                opp.NombreReconductionsAutorisees__c = null;
                opp.DureeReconduction__c = null;
                opp.DureePreavis__c = null;
                opp.ReconductionFaitAutorisee__c = false;
            }
            else if(opp.ContratOrigine__c != null && opp.Type_pers__c == Label.Evolution){
                opp.TypeReconduction__c = opp.ContratOrigine__r.TypeReconduction__c;
                opp.NombreReconductionsAutorisees__c = opp.ContratOrigine__r.NombreReconductionsAutorisees__c;
                opp.DureeReconduction__c = opp.ContratOrigine__r.DureeReconduction__c;
                opp.DureePreavis__c = opp.ContratOrigine__r.DureePreavis__c;
                opp.ReconductionFaitAutorisee__c = opp.ContratOrigine__r.ReconductionFaitAutorisee__c;
            }
            else if(opp.Contrat_Genere_lookup__c != null){
                opp.TypeReconduction__c = opp.Contrat_Genere_lookup__r.TypeReconduction__c;
                opp.NombreReconductionsAutorisees__c = opp.Contrat_Genere_lookup__r.NombreReconductionsAutorisees__c;
                opp.DureeReconduction__c = opp.Contrat_Genere_lookup__r.DureeReconduction__c;
                opp.DureePreavis__c = opp.Contrat_Genere_lookup__r.DureePreavis__c;
                opp.ReconductionFaitAutorisee__c = opp.Contrat_Genere_lookup__r.ReconductionFaitAutorisee__c;
            }
            
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