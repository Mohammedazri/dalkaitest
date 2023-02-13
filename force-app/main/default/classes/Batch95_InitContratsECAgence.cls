/** 
* @author Dona kfoury - Ei technologies
* @date 15/09/2020 
* @description Batch lancé manuellement qui renseigne le champ "Contrats actifs avec Cont EC de l'agence" sur l'objet objectif par le nombre de contrat actifs ayant au moin 1 contact espace client
* @Test Class Batch95_InitContratsECAgence_test
*/
global class Batch95_InitContratsECAgence implements Database.Batchable<SObject>,Database.stateful{

    /** 
    * @author Dona Kfoury 
    * @date 15/09/2020  
    * @chercher tous les agences one  
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        String query='SELECT id, name, dkcode__c,ContratsActifsDebutDAnneeAgence__c FROM agence__c WHERE dkcode__c in:setAgenceCodes';
        return Database.getQueryLocator(query);
    }

    /** 
* @author Dona Kfoury  
* @date 15/09/2020
* @pour chaque agence first recherche le nombre de contrat actifs EC affectés à elle
* @param Database.BatchableContext and list of agences
* @return void
*/
    global void execute (Database.BatchableContext bc , List<agence__c> listAgences)
    {
        string profiledToInclude = label.Profils_AgenceTauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        set<string> setAgenceCodes = new set<string>();
        for(agence__c myAgence:listAgences)
        {
            setAgenceCodes.add(myAgence.dkcode__c);
        }
        string currentYear = string.valueOf(System.Today().year());
        //prendre les contrats actifs EC reliés au agences first
        List<aggregateResult> listSumContratsEC =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode
                                                  FROM contrat__c 
                                                  WHERE statut__c !=: label.ContratFerme
                                                  AND PiloteDuContrat__r.Organisation__c in: setAgenceCodes
                                                  AND AuMoinsUnContactEspaceClient__c=true
                                                  group by PiloteDuContrat__r.Organisation__c];
        
        Map<string,Integer> mapAgenceToContractsECNumb = new Map<string,Integer>();
        //mapper pour chaque agence, le nombre de contrats EC actifs reliés
        for (AggregateResult arContrast : listSumContratsEC)  {
            mapAgenceToContractsECNumb.put(String.valueof(arContrast.get('agCode')),Integer.valueof(arContrast.get('sum')));
        }
        
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        List<Objectif__c> listObjs= [SELECT id, ContratsActifsAvecContactECDeLAgence__c, Commercial__c, Annee__c,DkCodeAgenceCommercial__c 
                                     FROM Objectif__c
                                     WHERE Annee__c =: currentYear and DkCodeAgenceCommercial__c  in:setAgenceCodes and Profil_du_responsable__c in:setProfileNames
                                    ];
        map<string, List<Objectif__c>> mapAgenceCodeToObjs = new map<string, List<Objectif__c>>();
        for(Objectif__c obj: listObjs){
            if(!mapAgenceCodeToObjs.containsKey(obj.DkCodeAgenceCommercial__c)){
                mapAgenceCodeToObjs.put(obj.DkCodeAgenceCommercial__c, new list<Objectif__c>());
            }
            mapAgenceCodeToObjs.get(obj.DkCodeAgenceCommercial__c).add(obj);
        }
        
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(objectif__c myObjectif:listObjs){
            //taux contact espace client
            if(mapAgenceToContractsECNumb.containskey(myObjectif.DkCodeAgenceCommercial__c)){
                if(myObjectif.ContratsActifsAvecContactECDeLAgence__c != mapAgenceToContractsECNumb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsAvecContactECDeLAgence__c = mapAgenceToContractsECNumb.get(myObjectif.DkCodeAgenceCommercial__c);
                }
            }
            else
            {
                if(myObjectif.ContratsActifsAvecContactECDeLAgence__c != 0){
                    myObjectif.ContratsActifsAvecContactECDeLAgence__c = 0;
                }
            }
            listObjToUpdate.add(myObjectif);
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