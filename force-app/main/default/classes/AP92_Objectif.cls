/** 
* @author: Dona Kfoury
* @date: 08/09/2020 
* @description:MAJ des contrats actifs et perdus en Nombre , CA et MB avec les valeurs en debut d'année au niveau de l'agence.
* @Test: Class AP92_Objectif_Test
*/
public class AP92_Objectif {
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020  
* @description: dans le cas de création d'un objectif, initialiser le champ ContratsActifsDebutAanneeDeLAgence__c par le champ ContratsActifsDebutAanneeDeLAgence__c de l'agence concerné
* @param listObjectifs: list des objectifs créés
* @return: void
*/
    public static void ObjectifCree(list<Objectif__c> listObjectifs){
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
        
        set<string> setAffectedAgenceCodes = new set<string>();
        list<Objectif__c> listObjs = new List<Objectif__c>();
        for(objectif__c obj:listObjectifs){
            if(obj.Annee__c ==currentYear && setProfileNames.contains(obj.Profil_du_responsable__c)&& setAgenceCodes.contains(obj.DkCodeAgenceCommercial__c)){
                setAffectedAgenceCodes.add(obj.DkCodeAgenceCommercial__c);
                listObjs.add(obj);
            }
        }
        if(listObjs!= null && listObjs.size()>0){
            //chercher les agences des objectifs créés
            map<string, decimal> maCodepAgenceNbre = new map<string, decimal> ();
            map<string, decimal> maCodepAgenceCA = new map<string, decimal> ();
            map<string, decimal> maCodepAgenceMB = new map<string, decimal> ();
            List<Agence__c> listAgences= [Select id, dkcode__c, ContratsActifsDebutDAnneeAgence__c,ContratsActifsDebutAnneeCA__c,ContratsActifsDebutAnneeMB__c
                                          FROM agence__c
                                          where dkcode__c in:setAffectedAgenceCodes];
            for(agence__c myAgence: listAgences)
            {
                maCodepAgenceNbre.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutDAnneeAgence__c);
                maCodepAgenceCA.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutAnneeCA__c);
                maCodepAgenceMB.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutAnneeMB__c);
            }
            //chercher les contrats reliés
            List<aggregateResult> listSumContrats =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode,
                                                    SUM(TotalCABudgetP1P2P3P4__c)sumCA , SUM(TotalMBBudgetP1P2P3P4__c)sumMB
                                                    FROM contrat__c 
                                                    WHERE statut__c !=: label.ContratFerme
                                                    AND PiloteDuContrat__r.Organisation__c in: setAffectedAgenceCodes
                                                    group by PiloteDuContrat__r.Organisation__c];
            //chercher les contrats EC reliés
            List<aggregateResult> listSumContratsEC =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode
                                                      FROM contrat__c 
                                                      WHERE statut__c !=: label.ContratFerme
                                                      AND PiloteDuContrat__r.Organisation__c in: setAffectedAgenceCodes
                                                      AND AuMoinsUnContactEspaceClient__c=true
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
                                                AND ContratOrigine__r.PiloteDuContrat__r.Organisation__c in: setAffectedAgenceCodes
                                                group by ContratOrigine__r.PiloteDuContrat__r.Organisation__c];
            //mapper pour chaque agence, le nombre de contrat actifs reliés à lui
            Map<string,Integer> mapAgenceToContractsNumb = new Map<string,Integer>();
            //mapper pour chaque agence, la somme des CA des contrat actifs reliés à lui
            Map<string,Decimal> mapAgenceToContractsCA = new Map<string,Decimal>();
            //mapper pour chaque agence, la somme des MB des contrat actifs reliés à lui
            Map<string,Decimal> mapAgenceToContractsMB = new Map<string,Decimal>();
            //mapper pour chaque Agence le nombre de contrats perdus reliés à lui
            Map<string,Integer> mapAgenceToContratPerdusNb = new Map <string,Integer>();
            //mapper pour chaque Agence la somme des CA des contrats perdus reliés à lui
            Map<string,Decimal> mapAgenceToContratPerdusCA = new Map <string,Decimal>();
            //mapper pour chaque Agence la somme des MB des contrat perdus reliés à lui
            Map<string,Decimal> mapAgenceToContratPerdusMB = new Map <string,Decimal>();
            //mapper pour chaque agence, le nombre de contrat actifs ayant au moins un contact espace cliants, reliés à lui
            Map<string,Integer> mapAgenceToContractsECNumb = new Map<string,Integer>();
            for (AggregateResult arOpps : listSumContrats)  {
            mapAgenceToContractsNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')==NULL?'0':arOpps.get('sum')));
            mapAgenceToContractsCA.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.Valueof(arOpps.get('sumCA')==NULL?'0':arOpps.get('sumCA'))));
            mapAgenceToContractsMB.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.ValueOf(arOpps.get('sumMB')==NULL?'0':arOpps.get('sumMB'))));
        }
        
        for (AggregateResult arOpp : listSumOpp)  {
            mapAgenceToContratPerdusNb.put(String.valueof(arOpp.get('agCode')),Integer.valueof(arOpp.get('sumNB')==NULL?'0':arOpp.get('sumNB')));
            mapAgenceToContratPerdusCA.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.Valueof(arOpp.get('sumCA')==NULL?'0':arOpp.get('sumCA'))));
            mapAgenceToContratPerdusMB.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.ValueOf(arOpp.get('sumMB')==NULL?'0':arOpp.get('sumMB'))));
        }
        for (AggregateResult arOpps : listSumContratsEC)  {
            mapAgenceToContractsECNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')==NULL?'0':arOpps.get('sum')));
        }
            
            for(Objectif__c myObj: listObjs){
                //initialiser ContratsActifsDebutAanneeDeLAgence__c
                if(maCodepAgenceNbre.containsKey(myObj.DkCodeAgenceCommercial__c)){
                    myObj.ContratsActifsDebutAanneeDeLAgence__c = maCodepAgenceNbre.get(myObj.DkCodeAgenceCommercial__c);
                    myObj.ContratsActifsDebutAnneeAgenceCA__c = maCodepAgenceCA.get(myObj.DkCodeAgenceCommercial__c);
                    myObj.ContratsActifsDebutAnneeAgenceMB__c = maCodepAgenceMB.get(myObj.DkCodeAgenceCommercial__c);
                }
                else{
                    //mettre 1 au lieu de 0 parce que ca servira comme denominateur dans le calcul de taux de renouvellement
                    myObj.ContratsActifsDebutAanneeDeLAgence__c = 1;
                    myObj.ContratsActifsDebutAnneeAgenceCA__c = 1;
                    myObj.ContratsActifsDebutAnneeAgenceMB__c = 1;
                }
                //initialiser ContratsActifsEnCoursDeLAgence__c
                if(mapAgenceToContractsNumb.containskey(myObj.DkCodeAgenceCommercial__c)){
                    myObj.ContratsActifsEnCoursDeLAgence__c = mapAgenceToContractsNumb.get(myObj.DkCodeAgenceCommercial__c); 
                    myObj.ContratsActifsEnCoursDeAgenceCA__c = mapAgenceToContractsCA.get(myObj.DkCodeAgenceCommercial__c);
                    myObj.ContratsActifsEnCoursDeAgenceMB__c = mapAgenceToContractsMB.get(myObj.DkCodeAgenceCommercial__c);
                }
                else
                {
                    myObj.ContratsActifsEnCoursDeLAgence__c = 0;
                    myObj.ContratsActifsEnCoursDeAgenceCA__c = 0;
                    myObj.ContratsActifsEnCoursDeAgenceMB__c = 0;
                }
                if(mapAgenceToContractsNumb.containskey(myObj.DkCodeAgenceCommercial__c)){
                    myObj.ContratsActifsEnCoursDeLAgence__c = mapAgenceToContractsNumb.get(myObj.DkCodeAgenceCommercial__c); 
                    myObj.ContratsActifsEnCoursDeAgenceCA__c = mapAgenceToContractsCA.get(myObj.DkCodeAgenceCommercial__c);
                    myObj.ContratsActifsEnCoursDeAgenceMB__c = mapAgenceToContractsMB.get(myObj.DkCodeAgenceCommercial__c);
                }
                else
                {
                    myObj.ContratsActifsEnCoursDeLAgence__c = 0;
                    myObj.ContratsActifsEnCoursDeAgenceCA__c = 0;
                    myObj.ContratsActifsEnCoursDeAgenceMB__c = 0;
                }
                
                if(mapAgenceToContratPerdusNb.containskey(myObj.DkCodeAgenceCommercial__c)){
                    myObj.ContratsPerdusEnCoursAgenceNB__c = mapAgenceToContratPerdusNb.get(myObj.DkCodeAgenceCommercial__c); 
                    myObj.ContratsPerdusEnCoursAgenceCA__c = mapAgenceToContratPerdusCA.get(myObj.DkCodeAgenceCommercial__c);
                    myObj.ContratsPerdusEnCoursAgenceMB__c = mapAgenceToContratPerdusMB.get(myObj.DkCodeAgenceCommercial__c);
                }
                else
                {
                    myObj.ContratsPerdusEnCoursAgenceNB__c = 0;
                    myObj.ContratsPerdusEnCoursAgenceCA__c = 0;
                    myObj.ContratsPerdusEnCoursAgenceMB__c = 0;
                }
                
                //initialiser ContratsActifsAvecContactECDeLAgence__c
                if(mapAgenceToContractsECNumb.containskey(myObj.DkCodeAgenceCommercial__c)){
                    myObj.ContratsActifsAvecContactECDeLAgence__c = mapAgenceToContractsECNumb.get(myObj.DkCodeAgenceCommercial__c); 
                }
                else
                {
                    myObj.ContratsActifsAvecContactECDeLAgence__c = 0;
                }
            }
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020   
* @description: dans le cas de création ou suppression d'un contrat, recalculer le champ ContratsActifsEnCoursDeLAgence__c pour les utilisateurs de l'agence concerné
* @param listOpps: list des contrats créés ou supprimés
* @return: void
*/
    public static void ContratCreeOuDeleteAuCoursAnnee(list<contrat__c> listContrats){
        
        set<string> setAffectedAgenceCodes = new set<string>();
        string currentYear = string.valueOf(System.Today().year());
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
        for(contrat__c mycontrat:listContrats){
            if(mycontrat.statut__c != label.ContratFerme &&
               setAgenceCodes.contains(mycontrat.zzz_TechCodeAgenceDuProprietaire__c)){
                   setAffectedAgenceCodes.add(mycontrat.zzz_TechCodeAgenceDuProprietaire__c);
               }
        }
        if(setAffectedAgenceCodes != null && setAffectedAgenceCodes.size()>0){
            TauxContratsAgenceAuCoursAnnee(setAffectedAgenceCodes);
        }
    }
    
  /** 
* @author: Jacques Akiki
* @date: 22/03/2021
* @description: dans le cas de la réalisation d'une opportunité de renouvellement
* @param listOpportunites: nouvelle version des Opportunités modifiées
* @param mapOldOpportunite: ancienne version des Opportunités modifiées
* @return: void
*/
    public static void OppPerdueAuCoursAnnee(list<Opportunity> listOpportunites, map<id, Opportunity>mapOldOpportunite)
    {
        string currentYear = string.valueOf(System.Today().year());
       string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        set<id> setOppOwner = new set<id>();
        set<String> setAffectedAgence = new set<String>();
        for (Opportunity opp:listOpportunites)
        {
            if((opp.statut__c !=mapOldOpportunite.get(opp.id).statut__c)
               && (opp.statut__c == Label.PV_StatutPerdu || mapOldOpportunite.get(opp.id).statut__c == Label.PV_StatutPerdu)               
               && opp.ContratOrigine__c !=NULL
               && opp.Annee_de_signature__c == currentYear
               && opp.Type_pers__c == Label.Opp_type_Renewal)
            {
                setOppOwner.add(opp.TechPiloteContratOrigine__c);
                setOppOwner.add(mapOldOpportunite.get(opp.id).TechPiloteContratOrigine__c);
            }
        }
         for (User usr :[SELECT Organisation__c FROM User WHERE id in:setOppOwner AND Organisation__c in:setAgenceCodes])
        {
            setAffectedAgence.add(usr.Organisation__c);
        }
        if(setAffectedAgence != null && setAffectedAgence.size()>0)
        {
            TauxContratsAgenceAuCoursAnnee(setAffectedAgence);
        }
    }
    
    /** 
* @author: Jacques Akiki
* @date: 22/03/2021
* @description: dans le cas de modification d'une Opportunité, recalculer les CA en cours et MB en cours l'utilisateur commercial first concerné
* @param listOpportunites: nouvelle version des Opportunités modifiées
* @param mapOldOpportunite: ancienne version des Opportunités modifiées
* @return: void
*/
    public static void OppEditAuCoursAnnee(list<Opportunity> listOpportunites, map<id, Opportunity>mapOldOpportunite)
    {
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        set<id> setContId = new set<id>();
        for (Opportunity opp:listOpportunites)
        {
            if((opp.Amount !=mapOldOpportunite.get(opp.id).Amount || opp.MargeBruteOffre__c!=mapOldOpportunite.get(opp.id).MargeBruteOffre__c)
               && opp.Contrat_Genere_lookup__c!=NULL)
            {
                setContId.add(opp.Contrat_Genere_lookup__c);
            }
        }
        if(setContId!=NULL && setContId.size()!=0){
            set<String> setAffectedAgences = new set<String>();
            for(Contrat__c cont:[SELECT id, zzz_TechCodeAgenceDuProprietaire__c 
                                 FROM Contrat__c 
                                 WHERE  id in:setContId 
                                 AND zzz_TechCodeAgenceDuProprietaire__c in:setAgenceCodes 
                                 AND TechTotalMBBudgetP1P2P3P4__c = NULL
                                 AND TechTotalCABudgetP1P2P3P4__c = NULL 
                                 AND statut__c !=:Label.ContratFerme])
            {
                setAffectedAgences.add(cont.zzz_TechCodeAgenceDuProprietaire__c); 
            }
            if(setAffectedAgences != null && setAffectedAgences.size()>0)
            {
                TauxContratsAgenceAuCoursAnnee(setAffectedAgences);
            }
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020     
* @description: dans le cas de modification d'un contrat, recalculer le champ ContratsActifsEnCoursDeLAgence__c pour les utilisateurs de l'agence concerné
* @param listContratsString: nouvelle version des contrats modifiés
* @param mapOldContratsString: ancienne version des contrats modifiés
* @return: void
*/
    public static void ContratsEditAuCoursAnnee(list<contrat__c> listContrats, map<id, contrat__c>mapOldContrats){
        set<string> setAffectedAgenceCodes = new set<string>();
        string currentYear = string.valueOf(System.Today().year());
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
        for(contrat__c mycontrat:listContrats){
            contrat__c oldContrat = mapOldContrats.get(mycontrat.Id);
            //si owner n'a pas changé et owner a comme agence une agence one et 
            //statut a changé à fermé ou depuis fermé 
            if( mycontrat.ownerid == oldContrat.Ownerid &&
               setAgenceCodes.contains(mycontrat.zzz_TechCodeAgenceDuProprietaire__c) &&(
                   (mycontrat.Statut__c != oldContrat.Statut__c && (mycontrat.Statut__c == label.ContratFerme || oldContrat.Statut__c == label.ContratFerme))
                   ||(mycontrat.AuMoinsUnContactEspaceClient__c != oldContrat.AuMoinsUnContactEspaceClient__c)
                   || mycontrat.TechTotalMBBudgetP1P2P3P4__c!=oldContrat.TechTotalMBBudgetP1P2P3P4__c 
                   ||mycontrat.TechTotalCABudgetP1P2P3P4__c!=oldContrat.TechTotalCABudgetP1P2P3P4__c)){
                       setAffectedAgenceCodes.add(mycontrat.zzz_TechCodeAgenceDuProprietaire__c);
                   }
            //si owner a changé et il était ou devenu dans une agence one
            if(mycontrat.ownerid != oldContrat.Ownerid
               && (setAgenceCodes.contains(mycontrat.zzz_TechCodeAgenceDuProprietaire__c) || 
                   setAgenceCodes.contains(oldContrat.zzz_TechCodeAgenceDuProprietaire__c))){
                       if(setAgenceCodes.contains(mycontrat.zzz_TechCodeAgenceDuProprietaire__c)){
                           setAffectedAgenceCodes.add(mycontrat.zzz_TechCodeAgenceDuProprietaire__c);
                       }
                       if(setAgenceCodes.contains(oldContrat.zzz_TechCodeAgenceDuProprietaire__c)){
                           setAffectedAgenceCodes.add(oldContrat.zzz_TechCodeAgenceDuProprietaire__c);
                       }
                   }
        }
        if(setAffectedAgenceCodes != null && setAffectedAgenceCodes.size()>0){
            TauxContratsAgenceAuCoursAnneeFuture(setAffectedAgenceCodes);
        }
    }
    
    @future
    public static void TauxContratsAgenceAuCoursAnneeFuture(set<string> setAffectedAgenceCodes){
        TauxContratsAgenceAuCoursAnnee(setAffectedAgenceCodes);
    }
    
    
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020    
* @description: dans le cas de modification de l'agence d'un utilisateur lui calculer le taux de renouvellement de son agence
* @param listUsers: nouvelle version des utilisateurs modifiés
* @param mapOldUsers: ancienne version des utilisateurs modifiés
* @return: void
*/
    
    public static void EditAgenceOuProfil(list<user> listUsers, map<id, user>mapOldUsers){
        //profiles du taux de renouvellement
        string profiledRenouvToInclude = label.Profils_AgenceTauxContrats;
        list<string> listProfileRenouvNames = profiledRenouvToInclude.split('-');
        Set<string> setProfileRenouvNames = new Set<string>(listProfileRenouvNames);
        set<string> setAffectedAgenceCodes = new set<string>();
        set<Id> setNewFirstIds = new set<Id>();
        set<Id> setOldFirstIds = new set<Id>();
        set<string> setNewFirstAgences = new set<string>();
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<string> setAgenceCodes = new Set<string>(lisAgences);
        
        for(user myUser:listUsers){
            user oldUser = mapOldUsers.get(myUser.Id);
            // si l'agence de l'utilisateur a changé et devient agence first
            if(myUser.organisation__c != oldUser.organisation__c){
                if(setAgenceCodes.contains(myUser.organisation__c)){
                    setAffectedAgenceCodes.add(myUser.organisation__c);
                }
                if(setAgenceCodes.contains(oldUser.organisation__c)){
                    setAffectedAgenceCodes.add(oldUser.organisation__c);
                }
                
                if(setAgenceCodes.contains(oldUser.organisation__c) && !setAgenceCodes.contains(myUser.organisation__c))
                {
                    setOldFirstIds.add(myUser.Id);
                }
                if(!setAgenceCodes.contains(oldUser.organisation__c) && setAgenceCodes.contains(myUser.organisation__c))
                {
                    setNewFirstIds.add(myUser.Id);
                    setNewFirstAgences.add(myUser.organisation__c);
                }
            }
            //si le profil de l'utilisateur  a changé
            //devenu un profil one
            if(myUser.profileid != oldUser.profileid && 
               setProfileRenouvNames.contains(myUser.ZZZ_NomDuProfil__c) && !setProfileRenouvNames.contains(oldUser.ZZZ_NomDuProfil__c) && setAgenceCodes.contains(myUser.organisation__c) ){     
                   setNewFirstIds.add(myUser.Id);
                   setNewFirstAgences.add(myUser.organisation__c);
               }
            //n'est plus un profil one
            if(myUser.profileid != oldUser.profileid && 
               setProfileRenouvNames.contains(oldUser.ZZZ_NomDuProfil__c) && !setProfileRenouvNames.contains(myUser.ZZZ_NomDuProfil__c) ){
                   setOldFirstIds.add(myUser.Id);
               }
        }
        if(setAffectedAgenceCodes != null && setAffectedAgenceCodes.size()>0){
            CallCalculRenouvInFuture(setAffectedAgenceCodes);
        }
        if(setNewFirstIds!= null && setNewFirstIds.size()>0){
            CalculerLeTaux(setNewFirstIds, setNewFirstAgences);
        }
        if(setOldFirstIds!= null && setOldFirstIds.size()>0){
            ReinitialiserTauxAgences(setOldFirstIds);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020    
* @description: call update taux renouvellement de l'agence dans un future call parce qu'on est dans le context d'un user trigger
* @param setAffectedAgenceCodes: code des agences affectés
* @return: void
*/
    @future
    public static void CallCalculRenouvInFuture(set<string> setAffectedAgenceCodes){
        TauxContratsAgenceAuCoursAnnee(setAffectedAgenceCodes);
    }
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020    
* @description: dans le cas de modification du profil de l'utilisateur à  first, calculer le taux de vente de son agence  
* @param setNewFirstIds: ids des utilusateurs à calculer
* @param setNewFirstAgences: codes des agences des utilusateurs à calculer
* @return: void
*/
    @future
    public static void CalculerLeTaux(set<id>setNewFirstIds, set<string> setNewFirstAgences){
        string profiledToInclude = label.Profils_AgenceTauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        string currentYear = string.valueOf(System.Today().year());
        //chercher les agences des objectifs
        map<string, decimal> maCodepAgenceNbre = new map<string, decimal> ();
        map<string, decimal> maCodepAgenceCA = new map<string, decimal> ();
        map<string, decimal> maCodepAgenceMB = new map<string, decimal> ();
        List<Agence__c> listAgences= [Select id, dkcode__c, ContratsActifsDebutDAnneeAgence__c,ContratsActifsDebutAnneeCA__c,ContratsActifsDebutAnneeMB__c
                                      FROM agence__c
                                      where dkcode__c in:setNewFirstAgences];
        for(agence__c myAgence: listAgences)
        {
            maCodepAgenceNbre.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutDAnneeAgence__c);
            maCodepAgenceCA.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutAnneeCA__c);
            maCodepAgenceMB.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutAnneeMB__c);
        }
        //prendre les contrats reliés aux agences
        
        List<aggregateResult> listSumContrats =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode,
                                                SUM(TotalCABudgetP1P2P3P4__c)sumCA , SUM(TotalMBBudgetP1P2P3P4__c)sumMB
                                                FROM contrat__c 
                                                WHERE statut__c !=: label.ContratFerme
                                                AND PiloteDuContrat__r.Organisation__c in: setNewFirstAgences
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
                                            AND ContratOrigine__r.PiloteDuContrat__r.Organisation__c in: setNewFirstAgences
                                            group by ContratOrigine__r.PiloteDuContrat__r.Organisation__c];
        
        //chercher les contrats EC reliés
        List<aggregateResult> listSumContratsEC =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode
                                                  FROM contrat__c 
                                                  WHERE statut__c !=: label.ContratFerme
                                                  AND PiloteDuContrat__r.Organisation__c in: setNewFirstAgences
                                                  AND AuMoinsUnContactEspaceClient__c=true
                                                  group by PiloteDuContrat__r.Organisation__c];
        //mapper pour chaque agence, le nombre de contrats EC gagnés reliés
        Map<string,Integer> mapAgenceToContractsECNumb = new Map<string,Integer>();
        for (AggregateResult arOpps : listSumContratsEC)  {
            mapAgenceToContractsECNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')));
        }
        //mapper pour chaque agence, le nombre de contrat actifs reliés à lui
        Map<string,Integer> mapAgenceToContractsNumb = new Map<string,Integer>();
        //mapper pour chaque agence, la somme des CA des contrat actifs reliés à lui
        Map<string,Decimal> mapAgenceToContractsCA = new Map<string,Decimal>();
        //mapper pour chaque agence, la somme des MB des contrat actifs reliés à lui
        Map<string,Decimal> mapAgenceToContractsMB = new Map<string,Decimal>();
        //mapper pour chaque agence le nombre de contrats perdus reliés à lui
        Map<string,Integer> mapAgenceToContratPerdusNb = new Map <string,Integer>();
        //mapper pour chaque agence la somme des CA des contrats perdus reliés à lui
        Map<string,Decimal> mapAgenceToContratPerdusCA = new Map <string,Decimal>();
        //mapper pour chaque agence la somme des MB des contrat perdus reliés à lui
        Map<string,Decimal> mapAgenceToContratPerdusMB = new Map <string,Decimal>();        
        //mapper pour chaque agence, le nombre de contrats gagnés reliés , CA et MB
      for (AggregateResult arOpps : listSumContrats)  {
            mapAgenceToContractsNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')==NULL?'0':arOpps.get('sum')));
            mapAgenceToContractsCA.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.Valueof(arOpps.get('sumCA')==NULL?'0':arOpps.get('sumCA'))));
            mapAgenceToContractsMB.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.ValueOf(arOpps.get('sumMB')==NULL?'0':arOpps.get('sumMB'))));
        }
        
        for (AggregateResult arOpp : listSumOpp)  {
            mapAgenceToContratPerdusNb.put(String.valueof(arOpp.get('agCode')),Integer.valueof(arOpp.get('sumNB')==NULL?'0':arOpp.get('sumNB')));
            mapAgenceToContratPerdusCA.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.Valueof(arOpp.get('sumCA')==NULL?'0':arOpp.get('sumCA'))));
            mapAgenceToContratPerdusMB.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.ValueOf(arOpp.get('sumMB')==NULL?'0':arOpp.get('sumMB'))));
        }
       
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        List<Objectif__c> listAffectedObjectifs= [SELECT id, Commercial__c, Annee__c,DkCodeAgenceCommercial__c ,ContratsActifsEnCoursDeLAgence__c,ContratsActifsDebutAanneeDeLAgence__c,
                                                  ContratsActifsAvecContactECDeLAgence__c, ContratsActifsDebutAnneeAgenceCA__c,ContratsActifsDebutAnneeAgenceMB__c,ContratsPerdusEnCoursAgenceNB__c,
                                                  ContratsActifsEnCoursDeAgenceCA__c,ContratsActifsEnCoursDeAgenceMB__c,ContratsPerdusEnCoursAgenceCA__c,ContratsPerdusEnCoursAgenceMB__c
                                                  FROM Objectif__c
                                                  WHERE Annee__c =: currentYear and Commercial__c in: setNewFirstIds and DkCodeAgenceCommercial__c  in:setNewFirstAgences and Profil_du_responsable__c in:setProfileNames
                                                 ];
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(objectif__c myObjectif:listAffectedObjectifs){
            //initialiser ContratsActifsDebutAanneeDeLAgence__c
            if(maCodepAgenceNbre.containsKey(myObjectif.DkCodeAgenceCommercial__c)){
                myObjectif.ContratsActifsDebutAanneeDeLAgence__c = maCodepAgenceNbre.get(myObjectif.DkCodeAgenceCommercial__c);
                myObjectif.ContratsActifsDebutAnneeAgenceCA__c = maCodepAgenceCA.get(myObjectif.DkCodeAgenceCommercial__c);
                myObjectif.ContratsActifsDebutAnneeAgenceMB__c = maCodepAgenceMB.get(myObjectif.DkCodeAgenceCommercial__c);
            }
            else{
                //mettre 1 au lieu de 0 parce que ca servira comme denominateur dans le calcul de taux de renouvellement
                myObjectif.ContratsActifsDebutAanneeDeLAgence__c = 1;
                myObjectif.ContratsActifsDebutAnneeAgenceCA__c = 1;
                myObjectif.ContratsActifsDebutAnneeAgenceMB__c = 1;
            }
            //ContratsActifsEnCoursDeLAgence__c
            if(mapAgenceToContractsNumb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.ContratsActifsEnCoursDeLAgence__c != mapAgenceToContractsNumb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsEnCoursDeLAgence__c = mapAgenceToContractsNumb.get(myObjectif.DkCodeAgenceCommercial__c);
                }
                if(myObjectif.ContratsActifsEnCoursDeAgenceCA__c != mapAgenceToContractsCA.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsEnCoursDeAgenceCA__c = mapAgenceToContractsCA.get(myObjectif.DkCodeAgenceCommercial__c);
                }
                if(myObjectif.ContratsActifsEnCoursDeAgenceMB__c != mapAgenceToContractsMB.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsEnCoursDeAgenceMB__c = mapAgenceToContractsMB.get(myObjectif.DkCodeAgenceCommercial__c) ;
                } 
            }
            else{
                //il faut reinitilaiser la valaeur à 0
                if(myObjectif.ContratsActifsEnCoursDeLAgence__c != 0){
                    myObjectif.ContratsActifsEnCoursDeLAgence__c = 0;
                }
                if(myObjectif.ContratsActifsEnCoursDeAgenceCA__c != 0){
                    myObjectif.ContratsActifsEnCoursDeAgenceCA__c = 0;
                }
                if(myObjectif.ContratsActifsEnCoursDeAgenceMB__c != 0){
                    myObjectif.ContratsActifsEnCoursDeAgenceMB__c = 0;
                }
            } 
            if(mapAgenceToContratPerdusNb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.ContratsPerdusEnCoursAgenceNB__c != mapAgenceToContratPerdusNb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsPerdusEnCoursAgenceNB__c = mapAgenceToContratPerdusNb.get(myObjectif.DkCodeAgenceCommercial__c);
                }
                if(myObjectif.ContratsPerdusEnCoursAgenceCA__c != mapAgenceToContratPerdusCA.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsPerdusEnCoursAgenceCA__c = mapAgenceToContratPerdusCA.get(myObjectif.DkCodeAgenceCommercial__c);
                }
                if(myObjectif.ContratsPerdusEnCoursAgenceMB__c != mapAgenceToContratPerdusMB.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsPerdusEnCoursAgenceMB__c = mapAgenceToContratPerdusMB.get(myObjectif.DkCodeAgenceCommercial__c) ;
                } 
            }
            else
            {
                if(myObjectif.ContratsPerdusEnCoursAgenceNB__c != 0){
                    myObjectif.ContratsPerdusEnCoursAgenceNB__c = 0;
                }
                if(myObjectif.ContratsPerdusEnCoursAgenceCA__c != 0){
                    myObjectif.ContratsPerdusEnCoursAgenceCA__c = 0;
                }
                if(myObjectif.ContratsPerdusEnCoursAgenceMB__c != 0){
                    myObjectif.ContratsPerdusEnCoursAgenceMB__c = 0;
                }
                
            }
            //ContratsActifsAvecContactECDeLAgence__c
            if(mapAgenceToContractsECNumb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.ContratsActifsAvecContactECDeLAgence__c != mapAgenceToContractsECNumb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsAvecContactECDeLAgence__c = mapAgenceToContractsECNumb.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
            }
            else{
                //il faut reinitilaiser la valaeur à 0
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
    
    /** 
* @author: Dona Kfoury
* @date: 08/09/2020    
* @description: dans le cas de modification du profil de l'utilisateur à non first, reinitialiser le taux de renouvellement de son agence à 0 
* @param setOldFirstIds: ids des utilusateurs à reinitialiser
* @return: void
*/
    @future
    public static void ReinitialiserTauxAgences(set<id>setOldFirstIds){
        string currentYear = string.valueOf(System.Today().year());
        list<Objectif__c> listObjToUpdate = [SELECT id, ContratsActifsDebutAanneeDeLAgence__c, Commercial__c, Annee__c,DkCodeAgenceCommercial__c ,ContratsActifsEnCoursDeLAgence__c,
                                             ContratsActifsAvecContactECDeLAgence__c
                                             FROM Objectif__c
                                             WHERE Annee__c =: currentYear and Commercial__c in:setOldFirstIds
                                            ];
        for(objectif__c myObjectif:listObjToUpdate){
            myObjectif.ContratsActifsEnCoursDeLAgence__c = 0;
            myObjectif.ContratsActifsEnCoursDeAgenceCA__c = 0;
            myObjectif.ContratsActifsEnCoursDeAgenceMB__c = 0;
            myObjectif.ContratsPerdusEnCoursAgenceCA__c = 0;
            myObjectif.ContratsPerdusEnCoursAgenceMB__c = 0;
            myObjectif.ContratsPerdusEnCoursAgenceNB__c = 0;
            myObjectif.ContratsActifsAvecContactECDeLAgence__c = 0;
            myObjectif.ContratsActifsDebutAanneeDeLAgence__c = 1;
            myObjectif.ContratsActifsDebutAnneeAgenceCA__c = 1;
            myObjectif.ContratsActifsDebutAnneeAgenceMB__c = 1;
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date:08/09/2020  
* @description: dans le cas de actions qui affectent le champ ContratsActifsEnCoursDeLAgence__c d'une agence, recalculer ce champ pour les utilisateurs de l'agence concerné
* @param setAffectedAgenceCodes: set des codes des agences concernés
* @return: void
*/
    public static void TauxContratsAgenceAuCoursAnnee(set<string> setAffectedAgenceCodes){
        string profiledToInclude = label.Profils_AgenceTauxContrats;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        string currentYear = string.valueOf(System.Today().year());
        //chercher les agences des objectifs
        map<string, decimal> maCodepAgenceNbre = new map<string, decimal> ();
        map<string, decimal> maCodepAgenceCA = new map<string, decimal> ();
        map<string, decimal> maCodepAgenceMB = new map<string, decimal> ();
        List<Agence__c> listAgences= [Select id, dkcode__c, ContratsActifsDebutDAnneeAgence__c,ContratsActifsDebutAnneeCA__c,ContratsActifsDebutAnneeMB__c
                                      FROM agence__c
                                      where dkcode__c in:setAffectedAgenceCodes];
        for(agence__c myAgence: listAgences)
        {
            maCodepAgenceNbre.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutDAnneeAgence__c);
            maCodepAgenceCA.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutAnneeCA__c);
            maCodepAgenceMB.put(myAgence.dkcode__c, myAgence.ContratsActifsDebutAnneeMB__c);
        }
        //chercher les contrats reliés aux agences
        List<aggregateResult> listSumContrats =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode,
                                                SUM(TotalCABudgetP1P2P3P4__c)sumCA , SUM(TotalMBBudgetP1P2P3P4__c)sumMB
                                                FROM contrat__c 
                                                WHERE statut__c !=: label.ContratFerme
                                                AND PiloteDuContrat__r.Organisation__c in: setAffectedAgenceCodes
                                                group by PiloteDuContrat__r.Organisation__c];
        //chercher les contrats EC reliés
        List<aggregateResult> listSumContratsEC =[ SELECT count(id) sum, PiloteDuContrat__r.Organisation__c agCode
                                                  FROM contrat__c 
                                                  WHERE statut__c !=: label.ContratFerme
                                                  AND PiloteDuContrat__r.Organisation__c in: setAffectedAgenceCodes
                                                  AND AuMoinsUnContactEspaceClient__c=true
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
                                            AND ContratOrigine__r.PiloteDuContrat__r.Organisation__c in: setAffectedAgenceCodes
                                            group by ContratOrigine__r.PiloteDuContrat__r.Organisation__c];
        
        
        //mapper pour chaque agence, le nombre de contrat actifs reliés à lui
        Map<string,Integer> mapAgenceToContractsNumb = new Map<string,Integer>();
        //mapper pour chaque agence, la somme des CA des contrat actifs reliés à lui
        Map<string,Decimal> mapAgenceToContractsCA = new Map<string,Decimal>();
        //mapper pour chaque agence, la somme des MB des contrat actifs reliés à lui
        Map<string,Decimal> mapAgenceToContractsMB = new Map<string,Decimal>();
        //mapper pour chaque Agence le nombre de contrats perdus reliés à lui
        Map<string,Integer> mapAgenceToContratPerdusNb = new Map <string,Integer>();
        //mapper pour chaque Agence la somme des CA des contrats perdus reliés à lui
        Map<string,Decimal> mapAgenceToContratPerdusCA = new Map <string,Decimal>();
        //mapper pour chaque Agence la somme des MB des contrat perdus reliés à lui
        Map<string,Decimal> mapAgenceToContratPerdusMB = new Map <string,Decimal>();
        //mapper pour chaque agence, le nombre de contrat actifs ayant au moin un contact espace cliants, reliés à lui
        Map<string,Integer> mapAgenceToContractsECNumb = new Map<string,Integer>();
        
        for (AggregateResult arOpps : listSumContrats)  {
            mapAgenceToContractsNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')==NULL?'0':arOpps.get('sum')));
            mapAgenceToContractsCA.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.Valueof(arOpps.get('sumCA')==NULL?'0':arOpps.get('sumCA'))));
            mapAgenceToContractsMB.put(String.valueof(arOpps.get('agCode')),Decimal.valueof(String.ValueOf(arOpps.get('sumMB')==NULL?'0':arOpps.get('sumMB'))));
        }
        
        for (AggregateResult arOpp : listSumOpp)  {
            mapAgenceToContratPerdusNb.put(String.valueof(arOpp.get('agCode')),Integer.valueof(arOpp.get('sumNB')==NULL?'0':arOpp.get('sumNB')));
            mapAgenceToContratPerdusCA.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.Valueof(arOpp.get('sumCA')==NULL?'0':arOpp.get('sumCA'))));
            mapAgenceToContratPerdusMB.put(String.valueof(arOpp.get('agCode')),Decimal.valueof(String.ValueOf(arOpp.get('sumMB')==NULL?'0':arOpp.get('sumMB'))));
        }
        for (AggregateResult arOpps : listSumContratsEC)  {
            mapAgenceToContractsECNumb.put(String.valueof(arOpps.get('agCode')),Integer.valueof(arOpps.get('sum')==NULL?'0':arOpps.get('sum')));
        }
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        List<Objectif__c> listAffectedObjectifs= [SELECT id, Commercial__c, Annee__c,DkCodeAgenceCommercial__c ,ContratsActifsEnCoursDeLAgence__c,ContratsActifsDebutAanneeDeLAgence__c,
                                                  ContratsActifsAvecContactECDeLAgence__c, ContratsActifsDebutAnneeAgenceCA__c,ContratsActifsDebutAnneeAgenceMB__c,ContratsPerdusEnCoursAgenceNB__c,
                                                  ContratsActifsEnCoursDeAgenceCA__c,ContratsActifsEnCoursDeAgenceMB__c,ContratsPerdusEnCoursAgenceCA__c,ContratsPerdusEnCoursAgenceMB__c
                                                  FROM Objectif__c
                                                  WHERE Annee__c =: currentYear and DkCodeAgenceCommercial__c  in:setAffectedAgenceCodes and Profil_du_responsable__c in:setProfileNames
                                                 ];
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(objectif__c myObjectif:listAffectedObjectifs){
            //taux de renouvelelemnt
            if(mapAgenceToContractsNumb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.ContratsActifsEnCoursDeLAgence__c != mapAgenceToContractsNumb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsEnCoursDeLAgence__c = mapAgenceToContractsNumb.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
                if(myObjectif.ContratsActifsEnCoursDeAgenceCA__c != mapAgenceToContractsCA.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsEnCoursDeAgenceCA__c = mapAgenceToContractsCA.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
                if(myObjectif.ContratsActifsEnCoursDeAgenceMB__c != mapAgenceToContractsMB.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsActifsEnCoursDeAgenceMB__c = mapAgenceToContractsMB.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
            }
            else{
                //il faut reinitilaiser la valeur à 0
                if(myObjectif.ContratsActifsEnCoursDeLAgence__c != 0){
                    myObjectif.ContratsActifsEnCoursDeLAgence__c = 0;
                }
                if(myObjectif.ContratsActifsEnCoursDeAgenceCA__c != 0){
                    myObjectif.ContratsActifsEnCoursDeAgenceCA__c = 0;
                }
                if(myObjectif.ContratsActifsEnCoursDeAgenceMB__c != 0){
                    myObjectif.ContratsActifsEnCoursDeAgenceMB__c = 0;
                }
            }
            
            if(mapAgenceToContratPerdusNb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.ContratsPerdusEnCoursAgenceNB__c != mapAgenceToContratPerdusNb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsPerdusEnCoursAgenceNB__c = mapAgenceToContratPerdusNb.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
                if(myObjectif.ContratsPerdusEnCoursAgenceCA__c != mapAgenceToContratPerdusCA.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsPerdusEnCoursAgenceCA__c = mapAgenceToContratPerdusCA.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
                if(myObjectif.ContratsPerdusEnCoursAgenceMB__c != mapAgenceToContratPerdusMB.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.ContratsPerdusEnCoursAgenceMB__c = mapAgenceToContratPerdusMB.get(myObjectif.DkCodeAgenceCommercial__c);
                } 
            }
            else{
                //il faut reinitilaiser la valeur à 0
                if(myObjectif.ContratsPerdusEnCoursAgenceNB__c != 0){
                    myObjectif.ContratsPerdusEnCoursAgenceNB__c = 0;
                }
                if(myObjectif.ContratsPerdusEnCoursAgenceCA__c != 0){
                    myObjectif.ContratsPerdusEnCoursAgenceCA__c = 0;
                }
                if(myObjectif.ContratsPerdusEnCoursAgenceMB__c != 0){
                    myObjectif.ContratsPerdusEnCoursAgenceMB__c = 0;
                }
            }
            
            if(maCodepAgenceNbre.containsKey(myObjectif.DkCodeAgenceCommercial__c) && myObjectif.ContratsActifsDebutAanneeDeLAgence__c != maCodepAgenceNbre.get(myObjectif.DkCodeAgenceCommercial__c)){
                myObjectif.ContratsActifsDebutAanneeDeLAgence__c = maCodepAgenceNbre.get(myObjectif.DkCodeAgenceCommercial__c);
                myObjectif.ContratsActifsDebutAnneeAgenceCA__c = maCodepAgenceCA.get(myObjectif.DkCodeAgenceCommercial__c);
                myObjectif.ContratsActifsDebutAnneeAgenceMB__c = maCodepAgenceMB.get(myObjectif.DkCodeAgenceCommercial__c);
            }
            
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
    
}