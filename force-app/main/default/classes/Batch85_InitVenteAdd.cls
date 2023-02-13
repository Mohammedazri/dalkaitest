/** 
* @author Dona kfoury - Ei technologies
* @date 14/07/2020 
* @description Batch lancé manuellement qui renseigne le champ "Ventes_Additionnelles__c" sur l'objectif par le nombre d'opportunités gagnées ayant Action_commerciale_principale__c affectés au commercial
* @Test Class Batch85_InitVenteAdd_test
*/

global class Batch85_InitVenteAdd implements Database.Batchable<SObject>,Database.stateful{
/** 
    * @author Dona Kfoury 
    * @date 14/07/2020   
    * @chercher tous les utilisateurs commerciaux first 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profile_DACFirst;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        string query='SELECT id, ContratsActifsDebutAnnee__c from user where  profile.Name in:setProfileNames';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Dona Kfoury  
    * @date 14/07/2020  
    * @pour chaque commercial first recherche le nombre d'opps gagnées ayant Action_commerciale_principale__c non vides et affectés à lui
    * @param Database.BatchableContext and list of utilisateurs
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<user> listUsers)
    {
        
        set<Id> setAffectedUserIds = new set<Id>();
        for(user myUser:listUsers)
        {
            setAffectedUserIds.add(myUser.Id);
        }
        string currentYear = string.valueOf(System.Today().year());
        //prendre les opportunités reliés au commerciaux first
        List<Opportunity> listOpps=[SELECT id,ownerid 
                                       FROM Opportunity
                                       WHERE statut__c =: label.OppBeforeUp_gagne
                                       AND Action_commerciale_principale__c != null
                                       AND Annee_de_signature__c =: currentYear
                                       AND ownerid in: setAffectedUserIds];
        //mapper pour chaque id de commercial, le nombre de opps gagnés reliés à lui
        Map<id,Integer> mapUseridToOppsNumb = new Map<id,Integer>();

        for(Opportunity opp:listOpps){
            if(!mapUseridToOppsNumb.containsKey(opp.ownerid)){
                mapUseridToOppsNumb.put(opp.ownerid,0);
            }
            mapUseridToOppsNumb.put(opp.ownerid,mapUseridToOppsNumb.get(opp.ownerid)+1);
        }

        
        //chercher les objectifs de l'année courante affectés au commerciaux first
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id, Ventes_Additionnelles__c, Commercial__c, Annee__c
                                                                  FROM Objectif__c
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setAffectedUserIds 
                                                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(string userId:setAffectedUserIds){
            if(mapCommerIdToObjId.containskey(userId)){
                objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(userId));
                //Ventes Additionnelles
                if(mapUseridToOppsNumb.containskey(userId)){
                    if(myObjectif.Ventes_Additionnelles__c != mapUseridToOppsNumb.get(userId)){
                        myObjectif.Ventes_Additionnelles__c = mapUseridToOppsNumb.get(userId);
                    }
                }
                else
                {
                    if(myObjectif.Ventes_Additionnelles__c != 0){
                        myObjectif.Ventes_Additionnelles__c = 0;
                    }
                }
                
                listObjToUpdate.add(myObjectif);
            }
        }
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