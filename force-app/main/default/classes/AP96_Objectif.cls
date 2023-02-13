/** 
* @author: Jacques Akiki
* @date: 23/03/2021 
* @description:MAJ des contrats actifs et perdus en Nombre , CA et MB avec les valeurs en debut d'année au niveau National.
* @Test: Class AP96_Objectif_Test
*/
public class AP96_Objectif {
    /** 
* @author: Jacques Akiki
* @date: 23/03/2021 
* @description: dans le cas de création d'un objectif, initialiser les champs Nationaux en nb, CA et MB
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
        
        list<Objectif__c> listObjs = new List<Objectif__c>();
        for(objectif__c obj:listObjectifs){
            if(obj.Annee__c ==currentYear && setProfileNames.contains(obj.Profil_du_responsable__c)&& setAgenceCodes.contains(obj.DkCodeAgenceCommercial__c)){
                listObjs.add(obj);
            }
        }
        if(listObjs!= null && listObjs.size()>0){
            
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
            
            
            for(Objectif__c myObj: listObjs){
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
        }
    }
    
    /** 
* @author: Jacques Akiki
* @date: 23/03/2021   
* @description: dans le cas de création ou suppression d'un contrat , recalculer les champs nationaux
* @param listOpps: list des contrats créés ou supprimés
* @return: void
*/
    public static void ContratCreeOuDeleteAuCoursAnnee(list<contrat__c> listContrats){
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        Boolean updateNational = false;
        for(contrat__c mycontrat:listContrats){
            if(setAgenceCodes.contains(mycontrat.zzz_TechCodeAgenceDuProprietaire__c)){
                updateNational = true;
            }
        }
        if(updateNational){
            UpdateNationalObjectif();
        }
    }
    
    
    /** 
* @author: Jacques Akiki
* @date: 23/03/2021
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
        List<User> listUSR = [SELECT Organisation__c FROM User WHERE id in:setOppOwner AND Organisation__c in:setAgenceCodes];
        
        if(listUSR != null && listUSR.size()>0)
        {
            UpdateNationalObjectif();
        }
    }
    
    /** 
* @author: Jacques Akiki
* @date: 23/03/2021
* @description: dans le cas de la réalisation d'une opportunité de renouvellement
* @param listContratsString: nouvelle version des Contrats modifiés
* @param mapOldContratsString: ancienne version des Contrats modifiés
* @return: void
*/
    public static void ContratsEditAuCoursAnnee(list<contrat__c> listContrats, map<id, contrat__c>mapOldContrats){
        set<string> setAffectedAgenceCodes = new set<string>();
        string currentYear = string.valueOf(System.Today().year());
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        Boolean updateNational = false;
        
        for(contrat__c mycontrat:listContrats){
            contrat__c oldContrat = mapOldContrats.get(mycontrat.Id);
            //si owner n'a pas changé et owner a comme agence une agence one et 
            //statut a changé à fermé ou depuis fermé 
            if( (mycontrat.ownerid != oldContrat.Ownerid && (!setAgenceCodes.contains(mycontrat.zzz_TechCodeAgenceDuProprietaire__c) ||
                                                             !setAgenceCodes.contains(oldContrat.zzz_TechCodeAgenceDuProprietaire__c)))
               
               || (mycontrat.Statut__c != oldContrat.Statut__c && (mycontrat.Statut__c == label.ContratFerme || oldContrat.Statut__c == label.ContratFerme))
               || mycontrat.TechTotalMBBudgetP1P2P3P4__c!=oldContrat.TechTotalMBBudgetP1P2P3P4__c 
               ||mycontrat.TechTotalCABudgetP1P2P3P4__c!=oldContrat.TechTotalCABudgetP1P2P3P4__c)
            {
                updateNational= true;
            }
            
        }
        if(updateNational){
            UpdateNationalObjectifFuture();
        }
    }
    
    
    
    /** 
* @author: Jacques Akiki
* @date: 23/03/2021    
* @description: dans le cas de modification de l'agence ou le profil d'un utilisateur
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
        Boolean updateNational = false;
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<string> setAgenceCodes = new Set<string>(lisAgences);
        
        for(user myUser:listUsers){
            user oldUser = mapOldUsers.get(myUser.Id);
            // si l'agence de l'utilisateur a changé et devient agence first
            if(myUser.organisation__c != oldUser.organisation__c && ((setAgenceCodes.contains(myUser.organisation__c) && !setAgenceCodes.contains(oldUser.organisation__c))
                                                                     ||(!setAgenceCodes.contains(myUser.organisation__c) && setAgenceCodes.contains(oldUser.organisation__c))))
            {
                updateNational= true;
            }
            
            //si le profil de l'utilisateur  a changé
            //devenu un profil one
            if(myUser.profileid != oldUser.profileid && ((setProfileRenouvNames.contains(myUser.ZZZ_NomDuProfil__c) && !setProfileRenouvNames.contains(oldUser.ZZZ_NomDuProfil__c))
                                                         ||(!setProfileRenouvNames.contains(myUser.ZZZ_NomDuProfil__c) && setProfileRenouvNames.contains(oldUser.ZZZ_NomDuProfil__c))))
            {
                updateNational= true;
            }
        }
        if(updateNational){
            UpdateNationalObjectifFuture();
        }
        
    }
    
    
    
    
    /** 
* @author: Jacques Akiki
* @date: 23/03/2021
* @description: dans le cas de la réalisation d'une opportunité de renouvellement
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
            List<Contrat__c> listcont= [SELECT id
                                        FROM Contrat__c 
                                        WHERE  id in:setContId 
                                        AND zzz_TechCodeAgenceDuProprietaire__c in:setAgenceCodes 
                                        AND TechTotalMBBudgetP1P2P3P4__c = NULL
                                        AND TechTotalCABudgetP1P2P3P4__c = NULL 
                                        AND statut__c !=:Label.ContratFerme];
            
            if(listcont != null && listcont.size()>0)
            {
                UpdateNationalObjectif();
            }
        }    
    }
    
    @future
    public static void UpdateNationalObjectifFuture(){
        UpdateNationalObjectif();
    }
    
    /** 
* @author: Jacques AKiki
* @date:23/03/2021 
* @description: dans le cas des actions qui peuvent influencer sur National des Objectifs
* @param setAffectedAgenceCodes: set des codes des agences concernés
* @return: void
*/
    public static void UpdateNationalObjectif(){
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
        List<Objectif__c> listObjectifsONE = [SELECT id,ContratsActifsEnCoursNationalNB__c,ContratsActifsEnCoursNationalCA__c,ContratsActifsEnCoursNationalMB__c,
                                              ContratsPerdusEnCoursNationalNb__c,ContratsPerdusEnCoursNationalCA__c,ContratsPerdusEnCoursNationalMb__c
                                              FROM Objectif__c
                                              WHERE Profil_du_responsable__c in:setProfileNames AND DkCodeAgenceCommercial__c in: setAgenceCodes AND Annee__c =:currentYear];
        
        if(listObjectifsONE!=NULL && listObjectifsONE.size()>0)
        {   
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
            for(Objectif__c myObj: listObjectifsONE){
                
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
            database.update(listObjectifsONE,false);
        }
    }
}