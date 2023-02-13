/** 
* @author Jacques Akiki
* @date 26/03/2021
* @description 
* @Test Class 
*/

global class BatchRDDObjectifONE1 implements Database.Batchable<SObject>{
    /** 
* @author Jacques Akiki 
* @date 26/03/2021 
* @chercher tous les utilisateurs ayant le profils commercial first 
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        String query='SELECT id,ContratsActifsDebutAnneeCA__c,ContratsActifsDebutAnneeMB__c from user where  profile.Name in:setProfileNames';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Jacques Akiki  
* @date 23/03/2021
* @pour 
* @param Database.BatchableContext and list of users
* @return void
*/
    global void execute (Database.BatchableContext bc , List<user> listUsers)
    {
        string currentYear = string.valueOf(System.Today().year());
        set<Id> setCommIds = new set<Id>();
        for(user myUser:listUsers)
        {
            setCommIds.add(myUser.Id);
        }
        //prendre les contrats actifs reliés au commerciaux first
        List<Contrat__c> listContrats=[SELECT id,ownerid,TotalCABudgetP1P2P3P4__c,TotalMBBudgetP1P2P3P4__c
                                       FROM contrat__c
                                       WHERE statut__c !=: label.ContratFerme
                                       AND ownerid in: setCommIds];
        
        List<Opportunity> listOpp = [SELECT id,ownerid,ContratOrigine__r.OwnerId, ContratOrigine__r.TotalCABudgetP1P2P3P4__c ,ContratOrigine__r.TotalMBBudgetP1P2P3P4__c
                                     FROM Opportunity
                                     WHERE Type_pers__c =:Label.Opp_type_Renewal 
                                     AND statut__c=:Label.PV_StatutPerdu 
                                     AND Annee_de_signature__c=:currentYear
                                     AND ContratOrigine__c!=NULL
                                     AND ContratOrigine__r.statut__c=:label.ContratFerme
                                     AND ContratOrigine__r.OwnerId in:setCommIds];
        
        system.debug('##listContrats'+listContrats);
        //mapper pour chaque id de commercial la somme des CA des contrats reliés à lui
        Map<id,Decimal> mapUseridToContractsCA = new Map<id,Decimal>();
        //mapper pour chaque id de commercial la somme des MB des contrats reliés à lui
        Map<id,Decimal> mapUseridToContractsMB = new Map<id,Decimal>();
        //mapper pour chaque id de commercial le nombre de contrats perdus reliés à lui
        Map<id,Integer> mapUseridToContratPerdusNb = new Map <id,Integer>();
        //mapper pour chaque id de commercial la somme des CA des contrats perdus reliés à lui
        Map<id,Decimal> mapUseridToContratPerdusCA = new Map <id,Decimal>();
        //mapper pour chaque id de commercial la somme des MB des contrat perdus reliés à lui
        Map<id,Decimal> mapUseridToContratPerdusMB = new Map <id,Decimal>();
        for(contrat__c con:listContrats){
            if(!mapUseridToContractsCA.containsKey(con.ownerid)){
                mapUseridToContractsCA.put(con.ownerid,0);
            }
            if(!mapUseridToContractsMB.containsKey(con.ownerid)){
                mapUseridToContractsMB.put(con.ownerid,0);
            }
            mapUseridToContractsCA.put(con.ownerid,mapUseridToContractsCA.get(con.ownerid)+(con.TotalCABudgetP1P2P3P4__c==NULL?0:con.TotalCABudgetP1P2P3P4__c));
            mapUseridToContractsMB.put(con.ownerid,mapUseridToContractsMB.get(con.ownerid)+(con.TotalMBBudgetP1P2P3P4__c==NULL?0:con.TotalMBBudgetP1P2P3P4__c));
        }
        
        for (Opportunity opp : listOpp)
        {
            if(!mapUseridToContratPerdusNb.containsKey(Opp.ContratOrigine__r.OwnerId))
            {
                mapUseridToContratPerdusNb.put(opp.ContratOrigine__r.OwnerId,0);
            }
            if(!mapUseridToContratPerdusCA.containsKey(opp.ContratOrigine__r.OwnerId))
            {
                mapUseridToContratPerdusCA.put(opp.ContratOrigine__r.OwnerId,0);
            }
            if(!mapUseridToContratPerdusMB.containsKey(opp.ContratOrigine__r.OwnerId))
            {
                mapUseridToContratPerdusMB.put(opp.ContratOrigine__r.OwnerId,0);
            }
            mapUseridToContratPerdusNb.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusNb.get(opp.ContratOrigine__r.OwnerId)+1);
            mapUseridToContratPerdusCA.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusCA.get(opp.ContratOrigine__r.OwnerId)+(opp.ContratOrigine__r.TotalCABudgetP1P2P3P4__c==NULL?0:opp.ContratOrigine__r.TotalCABudgetP1P2P3P4__c));
            mapUseridToContratPerdusMB.put(opp.ContratOrigine__r.OwnerId,mapUseridToContratPerdusMB.get(opp.ContratOrigine__r.OwnerId)+(opp.ContratOrigine__r.TotalMBBudgetP1P2P3P4__c==NULL?0:opp.ContratOrigine__r.TotalMBBudgetP1P2P3P4__c));
        }
        //chercher les objectifs de l'année courante affectés au commerciaux first
        map<id, Objectif__c> mapObjIds = new map<id,Objectif__c>([SELECT id, Commercial__c, Annee__c,
                                                                  ContratsActifsDebutAnnee__c ,ContratsActifsEnCours__c,ContratsPerdusEnCoursUtilisEnNb__c,      
                                                                  ContratsActifsDebutAnneeUtilisCA__c,ContratsActifsEnCoursUtilisCA__c,ContratsPerdusEnCoursUtilisEnCA__c,
                                                                  ContratsActifsDebutAnneeUtilisMB__c,ContratsActifsEnCoursUtilisMB__c,ContratsPerdusEnCoursUtilisEnMB__c
                                                                  FROM Objectif__c
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setCommIds
                                                                 ]);
        map<Id, Id> mapCommerIdToObjId = new map<Id, Id>();
        for(Objectif__c obj: mapObjIds.values()){
            mapCommerIdToObjId.put(obj.Commercial__c, obj.Id);
        }
        
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(user myUser:listUsers){
            if(mapUseridToContractsCA.containskey(myUser.Id)){
                myUser.ContratsActifsDebutAnneeCA__c = mapUseridToContractsCA.get(myUser.Id)==0.0?1.0:mapUseridToContractsCA.get(myUser.Id);
                myUser.ContratsActifsDebutAnneeMB__c = mapUseridToContractsMB.get(myUser.Id)==0.0?1.0:mapUseridToContractsMB.get(myUser.Id);
                
                if(mapCommerIdToObjId.containskey(myUser.Id)){
                    objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(myUser.Id));
                    myObjectif.ContratsPerdusEnCoursUtilisEnNb__c = mapUseridToContratPerdusNb.containskey(myUser.Id)?mapUseridToContratPerdusNb.get(myUser.Id):0;
                    myObjectif.ContratsActifsDebutAnneeUtilisCA__c = mapUseridToContractsCA.get(myUser.Id)==0.0?1.0:mapUseridToContractsCA.get(myUser.Id);
                    myObjectif.ContratsActifsEnCoursUtilisCA__c = mapUseridToContractsCA.get(myUser.Id);
                    myObjectif.ContratsPerdusEnCoursUtilisEnCA__c =mapUseridToContratPerdusCA.containskey(myUser.Id)?mapUseridToContratPerdusCA.get(myUser.Id):0;
                    myObjectif.ContratsActifsDebutAnneeUtilisMB__c = mapUseridToContractsMB.get(myUser.Id)==0.0?1.0:mapUseridToContractsMB.get(myUser.Id);
                    myObjectif.ContratsActifsEnCoursUtilisMB__c = mapUseridToContractsMB.get(myUser.Id);
                    myObjectif.ContratsPerdusEnCoursUtilisEnMB__c = mapUseridToContratPerdusMB.containskey(myUser.Id)?mapUseridToContratPerdusMB.get(myUser.Id):0;
                    listObjToUpdate.add(myObjectif);
                }
            }
            else{
                //mettre 1 au lieu de 0 parce que ca servira comme denominateur dans le calcul de taux de renouvellement
                myUser.ContratsActifsDebutAnneeCA__c = 1;
                myUser.ContratsActifsDebutAnneeMB__c = 1;                
                if(mapCommerIdToObjId.containskey(myUser.Id)){
                    objectif__c myObjectif = mapObjIds.get(mapCommerIdToObjId.get(myUser.Id));
                    myObjectif.ContratsActifsDebutAnneeUtilisCA__c = 1;
                    myObjectif.ContratsActifsEnCoursUtilisCA__c = 0;
                    myObjectif.ContratsActifsDebutAnneeUtilisMB__c = 1;
                    myObjectif.ContratsActifsEnCoursUtilisMB__c = 0;
                    myObjectif.ContratsPerdusEnCoursUtilisEnNb__c =mapUseridToContratPerdusNB.containskey(myUser.Id)?mapUseridToContratPerdusNB.get(myUser.Id):0;
                    myObjectif.ContratsPerdusEnCoursUtilisEnCA__c =mapUseridToContratPerdusCA.containskey(myUser.Id)?mapUseridToContratPerdusCA.get(myUser.Id):0;
                    myObjectif.ContratsPerdusEnCoursUtilisEnMB__c =mapUseridToContratPerdusMB.containskey(myUser.Id)?mapUseridToContratPerdusMB.get(myUser.Id):0;
                    listObjToUpdate.add(myObjectif);
                    
                }
            }
        }
        system.debug('##listObjToUpdate'+listObjToUpdate);
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