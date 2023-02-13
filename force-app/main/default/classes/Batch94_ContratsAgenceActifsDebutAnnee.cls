/** 
* @author Dona kfoury - Ei technologies
* @date 07/09/2020 
* @description Batch qui renseigne le champ "Contrats actifs début d'année agence" sur l'objet agence et objectif par le nombre de contrat actifs affecté à l'agence 1 janvier
* @Test Class Batch94_ContratsAgenceActifsDebutAnnee_test
*/
global class Batch94_ContratsAgenceActifsDebutAnnee implements Database.Batchable<SObject>{
    /** 
* @author Dona Kfoury 
* @date 7/09/2020  
* @chercher tous les agences one 
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        String query='SELECT id, name, dkcode__c,ContratsActifsDebutDAnneeAgence__c,ContratsActifsDebutAnneeCA__c,ContratsActifsDebutAnneeMB__c,'+
            'PossedeDesContratsONEActifs1Janv__c FROM agence__c WHERE dkcode__c in:setAgenceCodes';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Dona Kfoury  
* @date 7/09/2020 
* @pour chaque agence first recherche le nombre de contrat actifs affectés à elle
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
        //prendre les contrats actifs reliés au agences first
        List<aggregateResult> listSumContrats =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode,
                                                SUM(TotalCABudgetP1P2P3P4__c)sumCA , SUM(TotalMBBudgetP1P2P3P4__c)sumMB
                                                FROM contrat__c 
                                                WHERE statut__c !=: label.ContratFerme
                                                AND PiloteDuContrat__r.Organisation__c in: setAgenceCodes
                                                group by PiloteDuContrat__r.Organisation__c];
        // les contrats perdus
        List<aggregateResult> listSumOpp = [SELECT count(ContratOrigine__r.OwnerId) sumNB, ContratOrigine__r.PiloteDuContrat__r.Organisation__c agCode, 
                                            SUM(ContratOrigine__r.TotalCABudgetP1P2P3P4__c) sumCA ,
                                            SUM(ContratOrigine__r.TotalMBBudgetP1P2P3P4__c) sumMB
                                            FROM Opportunity
                                            WHERE Type_pers__c =:Label.Opp_type_Renewal 
                                            AND statut__c=:Label.PV_StatutPerdu 
                                            AND Annee_de_signature__c=:currentYear
                                            AND ContratOrigine__c!=NULL
                                            AND ContratOrigine__r.statut__c=:label.ContratFerme
                                            AND ContratOrigine__r.PiloteDuContrat__r.Organisation__c in: setAgenceCodes
                                            group by ContratOrigine__r.PiloteDuContrat__r.Organisation__c];
        
        //mapper pour chaque agence, le nombre de contrat actifs reliés à lui
        Map<string,Integer> mapAgenceToContratsNumb = new Map<string,Integer>();
        //mapper pour chaque agence, la somme des CA des contrat actifs reliés à lui
        Map<string,Decimal> mapAgenceToContratsCA = new Map<string,Decimal>();
        //mapper pour chaque agence, la somme des MB des contrat actifs reliés à lui
        Map<string,Decimal> mapAgenceToContratsMB = new Map<string,Decimal>();
        //mapper pour chaque agence le nombre de contrats perdus reliés à lui
        Map<string,Integer> mapAgenceToContratPerdusNb = new Map <string,Integer>();
        //mapper pour chaque agence la somme des CA des contrats perdus reliés à lui
        Map<string,Decimal> mapAgenceToContratPerdusCA = new Map <string,Decimal>();
        //mapper pour chaque agence la somme des MB des contrat perdus reliés à lui
        Map<string,Decimal> mapAgenceToContratPerdusMB = new Map <string,Decimal>();
        
        for (AggregateResult arOpps : listSumContrats)  {
            mapAgenceToContratsNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')==NULL?'0':arOpps.get('sum')));
            mapAgenceToContratsCA.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.Valueof(arOpps.get('sumCA')==NULL?'0':arOpps.get('sumCA'))));
            mapAgenceToContratsMB.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.ValueOf(arOpps.get('sumMB')==NULL?'0':arOpps.get('sumMB'))));
        }
        
        for (AggregateResult arOpp : listSumOpp)  {
            mapAgenceToContratPerdusNb.put(String.valueof(arOpp.get('agCode')),Integer.valueof(arOpp.get('sumNB')==NULL?'0':arOpp.get('sumNB')));
            mapAgenceToContratPerdusCA.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.Valueof(arOpp.get('sumCA')==NULL?'0':arOpp.get('sumCA'))));
            mapAgenceToContratPerdusMB.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.ValueOf(arOpp.get('sumMB')==NULL?'0':arOpp.get('sumMB'))));
        }
        
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        List<Objectif__c> listObjs= [SELECT id, Commercial__c, Annee__c,DkCodeAgenceCommercial__c ,ContratsActifsEnCoursDeLAgence__c,ContratsActifsDebutAanneeDeLAgence__c,
                                     ContratsActifsAvecContactECDeLAgence__c, ContratsActifsDebutAnneeAgenceCA__c,ContratsActifsDebutAnneeAgenceMB__c,ContratsPerdusEnCoursAgenceNB__c,
                                     ContratsActifsEnCoursDeAgenceCA__c,ContratsActifsEnCoursDeAgenceMB__c,ContratsPerdusEnCoursAgenceCA__c,ContratsPerdusEnCoursAgenceMB__c
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
        List<agence__c> listAgenceToUpdate = new List<agence__c>();
        for(agence__c myAgence:listAgences)
        {
            if(mapAgenceToContratsNumb.containskey(myAgence.dkcode__c))
            {
                myAgence.PossedeDesContratsONEActifs1Janv__c = true;
                if(myAgence.ContratsActifsDebutDAnneeAgence__c != mapAgenceToContratsNumb.get(myAgence.dkcode__c)){
                    myAgence.ContratsActifsDebutDAnneeAgence__c = mapAgenceToContratsNumb.get(myAgence.dkcode__c);
                }
                if(myAgence.ContratsActifsDebutAnneeCA__c != mapAgenceToContratsCA.get(myAgence.dkcode__c)){
                    myAgence.ContratsActifsDebutAnneeCA__c = mapAgenceToContratsCA.get(myAgence.dkcode__c)==0.0?1.0:mapAgenceToContratsCA.get(myAgence.dkcode__c);
                }
                if(myAgence.ContratsActifsDebutAnneeMB__c != mapAgenceToContratsMB.get(myAgence.dkcode__c)){
                    myAgence.ContratsActifsDebutAnneeMB__c = mapAgenceToContratsMB.get(myAgence.dkcode__c)==0.0?1.0:mapAgenceToContratsMB.get(myAgence.dkcode__c);
                }
                listAgenceToUpdate.add(myAgence);
                
                if(mapAgenceCodeToObjs.containskey(myAgence.dkcode__c))
                {
                    for(Objectif__c myObj:mapAgenceCodeToObjs.get(myAgence.dkcode__c))
                    {
                        myObj.ContratsActifsEnCoursDeLAgence__c = mapAgenceToContratsNumb.get(myAgence.dkcode__c);
                        myObj.ContratsActifsDebutAanneeDeLAgence__c = mapAgenceToContratsNumb.get(myAgence.dkcode__c);
                        myObj.ContratsActifsDebutAnneeAgenceCA__c = mapAgenceToContratsCA.get(myAgence.dkcode__c)==0.0?1.0:mapAgenceToContratsCA.get(myAgence.dkcode__c);
                        myObj.ContratsActifsEnCoursDeAgenceCA__c =mapAgenceToContratsCA.get(myAgence.dkcode__c);
                        myObj.ContratsActifsDebutAnneeAgenceMB__c = mapAgenceToContratsMB.get(myAgence.dkcode__c)==0.0?1.0:mapAgenceToContratsMB.get(myAgence.dkcode__c);
                        myObj.ContratsActifsEnCoursDeAgenceMB__c =mapAgenceToContratsMB.get(myAgence.dkcode__c);
                        myObj.ContratsPerdusEnCoursAgenceNB__c = mapAgenceToContratPerdusNb.containskey(myAgence.dkcode__c)?mapAgenceToContratPerdusNb.get(myAgence.dkcode__c):0;
                        myObj.ContratsPerdusEnCoursAgenceCA__c = mapAgenceToContratPerdusCA.containskey(myAgence.dkcode__c)?mapAgenceToContratPerdusCA.get(myAgence.dkcode__c):0;
                        myObj.ContratsPerdusEnCoursAgenceMB__c = mapAgenceToContratPerdusMb.containskey(myAgence.dkcode__c)?mapAgenceToContratPerdusMb.get(myAgence.dkcode__c):0;                        
                        listObjToUpdate.add(myObj);
                        
                    }
                }
            }
            else
            {
                myAgence.PossedeDesContratsONEActifs1Janv__c = false;
                if(myAgence.ContratsActifsDebutDAnneeAgence__c != 1){
                    myAgence.ContratsActifsDebutDAnneeAgence__c = 1;
                }
                if(myAgence.ContratsActifsDebutAnneeCA__c != 1){
                    myAgence.ContratsActifsDebutAnneeCA__c = 1;
                }
                if(myAgence.ContratsActifsDebutAnneeMB__c != 1){
                    myAgence.ContratsActifsDebutAnneeMB__c = 1;
                }
                listAgenceToUpdate.add(myAgence);
                if(mapAgenceCodeToObjs.containskey(myAgence.dkcode__c))
                {
                    for(Objectif__c myObj:mapAgenceCodeToObjs.get(myAgence.dkcode__c))
                    {
                        myObj.ContratsActifsEnCoursDeLAgence__c = 0;
                        myObj.ContratsActifsDebutAanneeDeLAgence__c = 1;
                        myObj.ContratsActifsDebutAnneeAgenceCA__c = 1;
                        myObj.ContratsActifsEnCoursDeAgenceCA__c =0;
                        myObj.ContratsActifsDebutAnneeAgenceMB__c = 1;
                        myObj.ContratsActifsEnCoursDeAgenceMB__c =0;
                        myObj.ContratsPerdusEnCoursAgenceNB__c = mapAgenceToContratPerdusNb.containskey(myAgence.dkcode__c)?mapAgenceToContratPerdusNb.get(myAgence.dkcode__c):0;
                        myObj.ContratsPerdusEnCoursAgenceCA__c = mapAgenceToContratPerdusCA.containskey(myAgence.dkcode__c)?mapAgenceToContratPerdusCA.get(myAgence.dkcode__c):0;
                        myObj.ContratsPerdusEnCoursAgenceMB__c = mapAgenceToContratPerdusMb.containskey(myAgence.dkcode__c)?mapAgenceToContratPerdusMb.get(myAgence.dkcode__c):0;                        
                        
                        listObjToUpdate.add(myObj);
                    }
                }
            }
            
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
        database.update(listAgenceToUpdate,false);
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        Batch110_UpdateNational myBatch= new Batch110_UpdateNational();
        ID batchprocessid = Database.executeBatch(myBatch);
        
    }
}