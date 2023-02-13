/** 
* @author Dona kfoury - Ei technologies
* @date 22/06/2020 
* @description Batch lancé manuellement qui renseigne le champ Contrats actifs début d'année sur l'utilistaur commercial first 
* par le nombre de contrat actifs affecté à lui ajourd'hui, après qu'il a passé à commercial first au cours de l'année
* @Test Class Batch79_InitContratActifsRef_test
*/
global class Batch79_InitContratActifsRef implements Database.Batchable<SObject>,Database.stateful{
    global set<string> setUserIds; // id des utilisateurs à initier
    
    
    global Batch79_InitContratActifsRef(set<string> setALLUserIds) 
    {
        if(setALLUserIds != null && setALLUserIds.size()>0)
        {
            setUserIds = setALLUserIds;
        }
    }
    
    /** 
    * @author Dona Kfoury 
    * @date 22/06/2020  
    * @chercher tous les utilisateurs dont les ids ont été fourni 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        string query='SELECT id, ContratsActifsDebutAnnee__c from user where id in:setUserIds and profile.Name in:setProfileNames';
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
        List<Contrat__c> listContrats=[SELECT id,ownerid
                                       FROM contrat__c
                                       WHERE statut__c !=: label.ContratFerme
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
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id, ContratsActifsDebutAnnee__c, Commercial__c, Annee__c,ContratsActifsEnCours__c
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
                    myObjectif.ContratsActifsDebutAnnee__c = mapUseridToContractsNumb.get(myUser.Id);
                    //myObjectif.ContratsActifsEnCours__c = mapUseridToContractsNumb.get(myUser.Id);
                }
                else{
                    //mettre 1 au lieu de 0 parce que ca servira comme denominateur dans le calcul de taux de renouvellement
                    myObjectif.ContratsActifsDebutAnnee__c = 1;
                    //myObjectif.ContratsActifsEnCours__c = 0;
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