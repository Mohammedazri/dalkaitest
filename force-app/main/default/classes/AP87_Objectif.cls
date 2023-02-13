/** 
* @author: Dona Kfoury
* @date: 14/07/2020 
* @description:MAJ le champ Ventes_Additionnelles__cpar le nombre des opportunités gagnés  ayant action commerciale correspondantes
* @Test: Class AP87_Objectif_Test
*/

public class AP87_Objectif {
     /** 
* @author: Dona Kfoury
* @date: 14/07/2020  
* @description: dans le cas de création d'un objectif, initialiser le champ Ventes_Additionnelles__c par le nombre des opportunités gagnés  ayant action commerciale correspondantes
* @param listObjectifs: list des objectifs créés
* @return: void
*/
    public static void OppGagneeDebutAnnee(list<Objectif__c> listObjectifs){
        //uniquement prendre en consideration les objectifs de l'année courante
        string currentYear = string.valueOf(System.Today().year());
         //uniquement prendre en consideration les utilisaturs dont le profil est contenu dans la libellé Profils_TauxVenteAdd
         //qui contient les profils dont on veut calculer le taux de renouvellement et de contact espace client
        string profiledToInclude = label.Profils_TauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<Id> setUserIds = new set<Id>();
        list<Objectif__c> listObjs = new List<Objectif__c>();
        for(objectif__c obj:listObjectifs){
            if(obj.Annee__c ==currentYear && setProfileNames.contains(obj.Profil_du_responsable__c)){
                setUserIds.add(obj.Commercial__c);
                listObjs.add(obj);
            }
        }
        //chercher les opportunités reliés
         List<Opportunity> listOpps=[SELECT id,ownerid 
                                       FROM Opportunity
                                       WHERE statut__c =: label.OppBeforeUp_gagne
                                       AND Action_commerciale_principale__c != null
                                       AND Annee_de_signature__c =: currentYear
                                       AND ownerid in: setUserIds];
        //mapper pour chaque id de commercial, le nombre de opps gagnés reliés à lui
        Map<id,Integer> mapUseridToOppsNumb = new Map<id,Integer>();
        for(Opportunity opp:listOpps){
            if(!mapUseridToOppsNumb.containsKey(opp.ownerid)){
                mapUseridToOppsNumb.put(opp.ownerid,0);
            }
            mapUseridToOppsNumb.put(opp.ownerid,mapUseridToOppsNumb.get(opp.ownerid)+1);
        }
        for(Objectif__c myObj: listObjs){
            //initialiser Ventes_Additionnelles__c
            if(mapUseridToOppsNumb.containskey(myObj.commercial__c)){
               myObj.Ventes_Additionnelles__c = mapUseridToOppsNumb.get(myObj.commercial__c); 
            }
            else
            {
                myObj.Ventes_Additionnelles__c = 0;
            }
        }
    }    
    
    /** 
* @author: Dona Kfoury
* @date: 14/07/2020   
* @description: dans le cas de création ou suppression d'une opportunité, recalculer le champ Ventes_Additionnelles__c pour l'utilisateur commercial first concerné
* @param listOpps: list des opportunités créés ou supprimés
* @return: void
*/
    public static void OppsCreeOuDeleteAuCoursAnnee(list<Opportunity> listOpps){
        string profiledToInclude = label.Profils_TauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<Id> setAffectedUserIds = new set<Id>();
        string currentYear = string.valueOf(System.Today().year());
        for(Opportunity myOpp:listOpps){
            if(myOpp.statut__c == label.OppBeforeUp_gagne &&
               myOpp.Action_commerciale_principale__c != null &&
               myOpp.Annee_de_signature__c == currentYear &&
               setProfileNames.contains(myOpp.zzz_TechProfilDuProprietaire__c)){
                setAffectedUserIds.add(myOpp.ownerid);
            }
        }
        if(setAffectedUserIds != null && setAffectedUserIds.size()>0){
            VentesAddAuCoursAnnee(setAffectedUserIds);
        }
    }

/** 
* @author: Dona Kfoury
* @date: 14/07/2020 
* @description: dans le cas de modification d'une opportunité, recalculer le champ Ventes_Additionnelles__c pour l'utilisateur commercial first concerné
* @param listOpps: nouvelle version des opportunités modifiés
* @param mapOldOpps: ancienne version des opportunités modifiés
* @return: void
*/
    public static void OppsEditAuCoursAnnee(list<Opportunity> listOpps, map<id, Opportunity>mapOldOpps){
        string profiledToInclude = label.Profils_TauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<Id> setAffectedUserIds = new set<Id>();
        string currentYear = string.valueOf(System.Today().year());
        for(Opportunity myOpp:listOpps){
            Opportunity oldOpp = mapOldOpps.get(myOpp.Id);
            //si owner n'a pas changé et owner est commercial first et 
            //statut a changé à gagné ou depuis gagné ou 
            //Action_commerciale_principale__c a changé à vide ou depuis vide ou
            //annee de signature a changé à l'année courante ou depuis l'année courante 
            if( myOpp.ownerid == oldOpp.Ownerid &&
               setProfileNames.contains(myOpp.zzz_TechProfilDuProprietaire__c) &&(
              (myOpp.Statut__c != oldOpp.Statut__c && (myOpp.Statut__c == label.OppBeforeUp_gagne || oldOpp.Statut__c == label.OppBeforeUp_gagne))
               ||(myOpp.Action_commerciale_principale__c != oldOpp.Action_commerciale_principale__c&& (myOpp.Action_commerciale_principale__c == null || oldOpp.Action_commerciale_principale__c == null))
               || (myOpp.Annee_de_signature__c != oldOpp.Annee_de_signature__c && (myOpp.Annee_de_signature__c == currentYear || oldOpp.Annee_de_signature__c == currentYear)))){
                   setAffectedUserIds.add(myOpp.ownerid);
               }
            //si owner a changé et il était ou devenu first
            if(myOpp.ownerid != oldOpp.Ownerid
               && (setProfileNames.contains(myOpp.zzz_TechProfilDuProprietaire__c) || 
                   setProfileNames.contains(oldOpp.zzz_TechProfilDuProprietaire__c))){
                       setAffectedUserIds.add(myOpp.ownerid);
                       setAffectedUserIds.add(oldOpp.ownerid);
                   }
        }
        if(setAffectedUserIds != null && setAffectedUserIds.size()>0){
            VentesAddAuCoursAnnee(setAffectedUserIds);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 14/07/2020  
* @description: dans le cas de actions qui affectent le champ Ventes_Additionnelles__c, recalculer ce champ pour l'utilisateur concerné
* @param setAffectedUserIds: set des ids des utilisateurs concernés
* @return: void
*/
    public static void VentesAddAuCoursAnnee(set<Id> setAffectedUserIds){
        string profiledToInclude = label.Profils_TauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
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
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setAffectedUserIds and Profil_du_responsable__c in:setProfileNames
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
}