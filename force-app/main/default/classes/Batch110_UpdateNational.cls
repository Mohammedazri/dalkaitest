/** 
* @author Jacques Akiki
* @date 25/03/2021 
* @description Batch qui met à jour les Valeurs nationales sur les Objectifs déjà créés 
* @Test Class Batch110_UpdateNational_test
*/

global class Batch110_UpdateNational implements Database.Batchable<SObject>{
    /** 
* @author Jacques Akiki
* @date 25/03/2021  
* @chercher tous les Objectifs one 
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string currentYear = string.valueOf(System.Today().year());
        string profiledToInclude = label.Profils_TauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        String query='SELECT id FROM Objectif__c WHERE Profil_du_responsable__c in:setProfileNames AND Annee__c =: currentYear';
        return Database.getQueryLocator(query); 
    }
    
    /** 
* @author Jacques Akiki 
* @date 25/03/2020 
* @pour Mettre a jour les champs nationaux sur les Objectifs ONE
* @param Database.BatchableContext and list of Objectifs
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Objectif__c> listObjectifs)
    {
        //uniquement prendre en consideration les objectifs de l'année courante
        string currentYear = string.valueOf(System.Today().year());
        //uniquement prendre en consideration les utilisaturs dont le profil est contenu dans la libellé Profils_AgenceTauxContrats
        //qui contient les profils dont on veut calculer le taux de renouvellement et de contact espace client
        string profiledToInclude = label.Profils_AgenceTauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
        
        List<AggregateResult> listAgencesAggr= [Select SUM(ContratsActifsDebutDAnneeAgence__c) sumNB,
                                                SUM(ContratsActifsDebutAnneeCA__c)sumCA,SUM(ContratsActifsDebutAnneeMB__c) sumMB
                                                FROM agence__c
                                                where dkcode__c in:setAgenceCodes and PossedeDesContratsONEActifs1Janv__c = true];
        
        //chercher les contrats reliés
        List<aggregateResult> listSumContrats =[ SELECT count(id) sumNB, SUM(TotalCABudgetP1P2P3P4__c)sumCA , SUM(TotalMBBudgetP1P2P3P4__c)sumMB
                                                FROM contrat__c 
                                                WHERE statut__c !=: label.ContratFerme
                                                AND PiloteDuContrat__r.Organisation__c in: setAgenceCodes];
        
        // les contrats perdus
        List<aggregateResult> listSumOpp = [SELECT count(ContratOrigine__r.OwnerId) sumNB, 
                                            SUM(ContratOrigine__r.TotalCABudgetP1P2P3P4__c) sumCA ,
                                            SUM(ContratOrigine__r.TotalMBBudgetP1P2P3P4__c) sumMB
                                            FROM Opportunity
                                            WHERE Type_pers__c =:Label.Opp_type_Renewal 
                                            AND statut__c=:Label.PV_StatutPerdu 
                                            AND Annee_de_signature__c=:currentYear
                                            AND ContratOrigine__c!=NULL
                                            AND ContratOrigine__r.statut__c=:label.ContratFerme
                                            AND ContratOrigine__r.PiloteDuContrat__r.Organisation__c in: setAgenceCodes];
        
        
        for(Objectif__c myObj: listObjectifs){
            if(listAgencesAggr[0].get('sumNB')!=NULL)
            {
                myObj.ContratsActifsDebutAnneeNationalNb__c = Integer.ValueOf(listAgencesAggr[0].get('sumNB'));
                myObj.ContratsActifsDebutAnneeNationalCA__c = Decimal.valueof(String.Valueof(listAgencesAggr[0].get('sumCA')==NULL?'1':listAgencesAggr[0].get('sumCA')));
                myObj.ContratsActifsDebutAnneeNationalMB__c = Decimal.valueof(String.Valueof(listAgencesAggr[0].get('sumMB')==NULL?'1':listAgencesAggr[0].get('sumMB')));
            }
            else
            {
                myObj.ContratsActifsDebutAnneeNationalNb__c = 1;
                myObj.ContratsActifsDebutAnneeNationalCA__c = 1;
                myObj.ContratsActifsDebutAnneeNationalMB__c = 1;
            }
            if(listSumContrats[0].get('sumNB')!=NULL && Integer.ValueOf(listSumContrats[0].get('sumNB'))!=0)
            {
                myObj.ContratsActifsEnCoursNationalNB__c = Integer.ValueOf(listSumContrats[0].get('sumNB'));
                myObj.ContratsActifsEnCoursNationalCA__c = Decimal.valueof(String.Valueof(listSumContrats[0].get('sumCA')==NULL?'0':listSumContrats[0].get('sumCA')));
                myObj.ContratsActifsEnCoursNationalMB__c = Decimal.valueof(String.Valueof(listSumContrats[0].get('sumMB')==NULL?'0':listSumContrats[0].get('sumMB')));
            }
            else
            {
                myObj.ContratsActifsEnCoursNationalNB__c = 0;
                myObj.ContratsActifsEnCoursNationalCA__c = 0;
                myObj.ContratsActifsEnCoursNationalMB__c = 0;
            }
            if(listSumOpp[0].get('sumNB')!=NULL && Integer.ValueOf(listSumOpp[0].get('sumNB'))!=0)
            {
                myObj.ContratsPerdusEnCoursNationalNb__c = Integer.ValueOf(listSumOpp[0].get('sumNB'));
                myObj.ContratsPerdusEnCoursNationalCA__c = Decimal.valueof(String.Valueof(listSumOpp[0].get('sumCA')==NULL?'0':listSumOpp[0].get('sumCA')));
                myObj.ContratsPerdusEnCoursNationalMb__c = Decimal.valueof(String.Valueof(listSumOpp[0].get('sumMB')==NULL?'0':listSumOpp[0].get('sumMB')));
            }
            else
            {
                myObj.ContratsPerdusEnCoursNationalNb__c = 0;
                myObj.ContratsPerdusEnCoursNationalCA__c = 0;
                myObj.ContratsPerdusEnCoursNationalMb__c = 0;
            }
        }
         PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
         database.update(listObjectifs,false);
    }
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}