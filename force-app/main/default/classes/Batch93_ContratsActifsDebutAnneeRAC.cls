/** 
* @author Dona kfoury - Ei technologies
* @date 04/09/2020 
* @description Batch qui renseigne le champ Contrats actifs début d'année sur l'utilistaur RAC first par le nombre de contrat actifs affecté à lui chaque 1 janvier
* @Test Class Batch93_ContratsActifsDebutAnneeRAC_test
*/
global class Batch93_ContratsActifsDebutAnneeRAC implements Database.Batchable<SObject>{

    /** 
    * @author Dona Kfoury 
    * @date 04/09/2020 
    * @chercher tous les utilisateurs ayant le profils RAC first 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profile_DACFirst;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        String query='SELECT id, ContratsActifsDebutAnnee__c from user where  profile.Name in:setProfileNames';
        return Database.getQueryLocator(query); 
    }
    /** 
    * @author Dona Kfoury  
    * @date 04/09/2020 
    * @pour chaque RAC first recherche le nombre de contrat actufs affectés à lui
    * @param Database.BatchableContext and list of users
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
            if(mapUseridToContractsNumb.containskey(myUser.Id)){
                myUser.ContratsActifsDebutAnnee__c = mapUseridToContractsNumb.get(myUser.Id);
                
                if(mapCommerIdToObjId.containskey(myUser.Id)){
                    objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(myUser.Id));
                    myObjectif.ContratsActifsDebutAnnee__c = mapUseridToContractsNumb.get(myUser.Id);
                    myObjectif.ContratsActifsEnCours__c = mapUseridToContractsNumb.get(myUser.Id);
                    listObjToUpdate.add(myObjectif);
                }
            }
            else{
                //mettre 1 au lieu de 0 parce que ca servira comme denominateur dans le calcul de taux de renouvellement
                myUser.ContratsActifsDebutAnnee__c = 1;
                if(mapCommerIdToObjId.containskey(myUser.Id)){
                    objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(myUser.Id));
                    myObjectif.ContratsActifsDebutAnnee__c = 1;
                    myObjectif.ContratsActifsEnCours__c = 0;
                    listObjToUpdate.add(myObjectif);
                }
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