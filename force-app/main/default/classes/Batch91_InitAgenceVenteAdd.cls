/** 
* @author Dona kfoury - Ei technologies
* @date 01/09/2020 
* @description Batch lancé manuellement qui renseigne le champ "VentesAdditionnellesDeLAgence__c" sur l'objectif par le nombre d'opportunités gagnées ayant Action_commerciale_principale__c affectés à l'agence
* @Test Class Batch91_InitAgenceVenteAdd_test
*/
global class Batch91_InitAgenceVenteAdd implements Database.Batchable<SObject>,Database.stateful{
/** 
    * @author Dona Kfoury 
    * @date 01/09/2020    
    * @chercher tous les utilisateurs first 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
        string query='SELECT id, Organisation__c from user where  profile.Name in:setProfileNames and Organisation__c in:setAgenceCodes ';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Dona Kfoury  
    * @date 01/09/2020   
    * @pour chaque utilisateur first recherche le nombre d'opps gagnées ayant Action_commerciale_principale__c non vides et affectés à son agence
    * @param Database.BatchableContext and list of utilisateurs
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<user> listUsers)
    {
        string profiledToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        Set<Id> setUserIds = new Set<Id>();

        
        set<string> setAffectedAgenceCodes = new set<string>();
        for(user myUser:listUsers)
        {
            setAffectedAgenceCodes.add(myUser.organisation__c);
            setUserIds.add(myUser.Id);
        }
        string currentYear = string.valueOf(System.Today().year());
        //prendre les opportunités reliés aux agences
        List<aggregateResult> listSumOpps =[ SELECT count(id) sum,owner.Organisation__c orgCode
                                            FROM opportunity 
                                            WHERE statut__c =: label.OppBeforeUp_gagne
                                            AND Action_commerciale_principale__c != null
                                            AND Annee_de_signature__c =: currentYear
                                            AND owner.Organisation__c in: setAffectedAgenceCodes
                                            group by owner.Organisation__c];
        Map<string,Integer> mapAgenceToOppsNumb = new Map<string,Integer>();
        //mapper pour chaque agence, le nombre de opps gagnés reliés
        for (AggregateResult arOpps : listSumOpps)  {
            mapAgenceToOppsNumb.put(String.valueof(arOpps.get('orgCode')),Integer.valueof(arOpps.get('sum')));
        }
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id, VentesAdditionnellesDeLAgence__c, Commercial__c, Annee__c,DkCodeAgenceCommercial__c 
                                                  FROM Objectif__c
                                                  WHERE Annee__c =: currentYear and DkCodeAgenceCommercial__c  in:setAffectedAgenceCodes and Profil_du_responsable__c in:setProfileNames and Commercial__c in:setUserIds
                                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(user myUser:listUsers){
            if(mapCommerIdToObjId.containskey(myUser.Id)){
                objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(myUser.Id));
                //Ventes Additionnelles
                if(mapAgenceToOppsNumb.containskey(myUser.organisation__c)){
                    if(myObjectif.VentesAdditionnellesDeLAgence__c != mapAgenceToOppsNumb.get(myUser.Organisation__c )){
                        myObjectif.VentesAdditionnellesDeLAgence__c = mapAgenceToOppsNumb.get(myUser.Organisation__c );
                        listObjToUpdate.add(myObjectif);
                    }
                }
                else
                {
                    if(myObjectif.VentesAdditionnellesDeLAgence__c != 0){
                        myObjectif.VentesAdditionnellesDeLAgence__c = 0;
                        listObjToUpdate.add(myObjectif);
                    }
                }
            }
        }
        
        //maj des objectifs
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}