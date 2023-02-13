/** 
* @author Dona kfoury - Ei technologies
* @date 10/07/2020 
* @description Batch lancé manuellement qui renseigne le champ "Contrats actifs avec Contact EC" sur l'objectif par le nombre de contarts actifs affectés au commercial
* ayant au moin un contact espace client rattaché
* @Test Class Batch84_InitTauxEC_test
*/

global class Batch84_InitTauxEC implements Database.Batchable<SObject>,Database.stateful{

    /** 
    * @author Dona Kfoury 
    * @date 22/06/2020  
    * @chercher tous les utilisateurs dont les ids ont été fourni 
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
    * @date 22/06/2020
    * @pour chaque commercial first recherche le nombre de contrat actifs affectés à lui
    * @param Database.BatchableContext and list of utilisateurs
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<user> listUsers)
    {
        set<Id> setCommIds = new set<Id>();
        for(user myUser:listUsers)
        {
            setCommIds.add(myUser.Id);
        }
        //prendre les contrats actifs reliés au commerciaux first
        List<Contrat__c> listContrats=[SELECT id,ownerid,AuMoinsUnContactEspaceClient__c
                                       FROM contrat__c
                                       WHERE statut__c !=: label.ContratFerme
                                       AND AuMoinsUnContactEspaceClient__c = true
                                       AND ownerid in: setCommIds];
        //mapper pour chaque id de commercial le nombre de contrat actifs reliés à lui
        Map<id,Integer> mapUseridToContractsNumb = new Map<id,Integer>();
        for(contrat__c con:listContrats){
            if(!mapUseridToContractsNumb.containsKey(con.ownerid)){
                mapUseridToContractsNumb.put(con.ownerid,0);
            }
            mapUseridToContractsNumb.put(con.ownerid,mapUseridToContractsNumb.get(con.ownerid)+1);
        }
        string currentYear = string.valueOf(System.Today().year());
        //chercher les objectifs de l'année courante affectés au commerciaux first
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id, ContratsActifsAvecContactEC__c, Commercial__c, Annee__c
                                 FROM Objectif__c
                                 WHERE Annee__c =: currentYear and Commercial__c in:setCommIds
                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(user myUser:listUsers){     
            if(mapCommerIdToObjId.containskey(myUser.Id)){
                objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(myUser.Id));
                if(mapUseridToContractsNumb.containskey(myUser.Id)){
                    myObjectif.ContratsActifsAvecContactEC__c = mapUseridToContractsNumb.get(myUser.Id);
                }
                else{
                    myObjectif.ContratsActifsAvecContactEC__c = 0;
                }
                listObjToUpdate.add(myObjectif);
            }  
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
        database.update(listUsers,false);
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {

    }
}