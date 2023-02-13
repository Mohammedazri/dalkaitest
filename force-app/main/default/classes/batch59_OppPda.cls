/**
* @author Dona Kfoury
* @date 27/03/2020
* @description Batch qui renseigne le champ Type Pda réseau pour les opp filles réseau dont date signature<2020
* @Test Class: batch59_OppPda_test
* @Coverage: 83%
*/
global class batch59_OppPda implements Database.Batchable<SObject>,Database.stateful{
global string limt; // to add filtering condition on query
    /** 
* @author Dona Kfoury
* @date 27/03/2020
* @description Constructor
*/
    global batch59_OppPda(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    
    /** 
* @author Dona Kfoury
* @date 27/03/2020
* @description query les opp filles réseau dont date signature<2020
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        set<string> setOldYears = new set<string>();
        for(integer year=1900; year<2020; year++){
            setOldYears.add(string.valueOf(year));
        }
        system.debug(setOldYears);
        system.debug('size' + setOldYears.size());
        string reseauType = Label.batch59_Reseau;
        string realisationStatus= Label.batch59_Realisation;

        String query = 'SELECT id , Type_de_PdA_reseaux__c ,Contrat_Genere_lookup__c, Contrat_Genere_lookup__r.Type_de_PdA_reseaux__c '+
            'FROM Opportunity '+ 
            'WHERE Type_de_PdA_reseaux__c = Null and OpportuniteMere__c != NULL  and OpportuniteMere__r.NatureOpportunitMere__c  =:reseauType'
            +' and StageName=:realisationStatus and Annee_de_signature__c in:setOldYears';
        
        if(limt<>'' && limt<>null)
        {
            query = query + limt; // add condition to query
        }
        
        system.debug(query);
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Dona Kfoury
* @date 27/03/2020
* @description mettre à jour le champ  Type_de_PdA_reseaux__c = avant 2020
*/
    global void execute (Database.BatchableContext bc , List<Opportunity> listOpp)
    {
        system.debug('listOpp '+listOpp);
        system.debug('size '+listOpp.size());
        List<Contrat__c> listContratsToUpdate = new List<Contrat__c>();
        string defaultvalue=Label.batch59_Avant2020;
        for(Opportunity Opp:listOpp){
            Opp.Type_de_PdA_reseaux__c = defaultvalue;
            if(Opp.Contrat_Genere_lookup__c !=null)
            {
                Contrat__c oppCon = new Contrat__c(id=Opp.Contrat_Genere_lookup__c,Type_de_PdA_reseaux__c=defaultvalue);
                listContratsToUpdate.add(oppCon);
            }
        }
        
        update listOpp;
        update listContratsToUpdate;
    }
    /*
* @author Dona Kfoury
* @date 27/03/2020
@description
*/ 
     global void finish(Database.BatchableContext bc)
    {
        
    }
}