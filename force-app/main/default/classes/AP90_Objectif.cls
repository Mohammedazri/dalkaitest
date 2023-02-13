/** 
* @author: Dona Kfoury
* @date: 01/09/2020  
* @description:MAJ le champ VentesAdditionnellesDeLAgence__c par le taux de vente additionelle de l'agence
* @Test: Class AP90_Objectif_Test
*/

public class AP90_Objectif {
    
    /** 
* @author: Dona Kfoury
* @date: 01/09/2020  
* @description: dans le cas de création d'un objectif, initialiser le champ VentesAdditionnellesDeLAgence__c par le nombre des opportunités gagnés de l'agence ayant action commerciale correspondantes
* @param listObjectifs: list des objectifs créés
* @return: void
*/
    public static void ObjectifCree(list<Objectif__c> listObjectifs){
        //uniquement prendre en consideration les objectifs de l'année courante
        string currentYear = string.valueOf(System.Today().year());
        //uniquement prendre en consideration les utilisaturs dont le profil est contenu dans la libellé Profils_AgenceTauxVenteAdd      
        string profiledToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        set<string> setAffectedAgenceCodes = new set<string>();
        list<Objectif__c> listObjs = new List<Objectif__c>();
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
        for(objectif__c obj:listObjectifs){
            if(obj.Annee__c ==currentYear && setProfileNames.contains(obj.Profil_du_responsable__c) && setAgenceCodes.contains(obj.DkCodeAgenceCommercial__c)){
                setAffectedAgenceCodes.add(obj.DkCodeAgenceCommercial__c);
                listObjs.add(obj);
            }
        }
        if(listObjs!= null && listObjs.size()>0){
            //chercher les opportunités reliés
            List<aggregateResult> listSumOpps =[ SELECT count(id) sum,owner.Organisation__c orgCode 
                                                FROM opportunity 
                                                WHERE statut__c =: label.OppBeforeUp_gagne
                                                AND Action_commerciale_principale__c != null
                                                AND Annee_de_signature__c =: currentYear
                                                AND owner.Organisation__c in: setAffectedAgenceCodes
                                                group by owner.Organisation__c];
            Map<string,Integer> mapAgenceToOppsNumb = new Map<string,Integer>();
            //mapper pour chaque agence, le nombre de opps gagnés reliés
            for (AggregateResult arOpps : listSumOpps)  {
                mapAgenceToOppsNumb.put(String.valueof(arOpps.get('orgCode')),Integer.valueof(arOpps.get('sum')));
            }
            for(Objectif__c myObj: listObjs){
                //initialiser VentesAdditionnellesDeLAgence__c
                if(mapAgenceToOppsNumb.containskey(myObj.DkCodeAgenceCommercial__c)){
                    myObj.VentesAdditionnellesDeLAgence__c = mapAgenceToOppsNumb.get(myObj.DkCodeAgenceCommercial__c); 
                }
                else
                {
                    myObj.VentesAdditionnellesDeLAgence__c = 0;
                }
            }
        }
    }    
    
    /** 
* @author: Dona Kfoury
* @date: 01/09/2020   
* @description: dans le cas de création ou suppression d'une opportunité, recalculer le champ VentesAdditionnellesDeLAgence__c pour les utilisateurs de l'agence concerné
* @param listOpps: list des opportunités créés ou supprimés
* @return: void
*/
    public static void OppsCreeOuDeleteAuCoursAnnee(list<Opportunity> listOpps){

        set<string> setAffectedAgenceCodes = new set<string>();
        string currentYear = string.valueOf(System.Today().year());
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
             
        for(Opportunity myOpp:listOpps){
            if(myOpp.statut__c == label.OppBeforeUp_gagne &&
               myOpp.Action_commerciale_principale__c != null &&
               myOpp.Annee_de_signature__c == currentYear &&
               setAgenceCodes.contains(myOpp.zzz_TechCodeAgenceDuProprietaire__c)){
                setAffectedAgenceCodes.add(myOpp.zzz_TechCodeAgenceDuProprietaire__c);
            }
        }
        if(setAffectedAgenceCodes != null && setAffectedAgenceCodes.size()>0){
            VentesAddAgenceAuCoursAnnee(setAffectedAgenceCodes);
        }
    }

/** 
* @author: Dona Kfoury
* @date: 01/09/2020    
* @description: dans le cas de modification d'une opportunité, recalculer le champ VentesAdditionnellesDeLAgence__c pour les utilisateurs de l'agence concerné
* @param listOpps: nouvelle version des opportunités modifiés
* @param mapOldOpps: ancienne version des opportunités modifiés
* @return: void
*/
    public static void OppsEditAuCoursAnnee(list<Opportunity> listOpps, map<id, Opportunity>mapOldOpps){

        set<string> setAffectedAgenceCodes = new set<string>();
        string currentYear = string.valueOf(System.Today().year());
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
        for(Opportunity myOpp:listOpps){
            Opportunity oldOpp = mapOldOpps.get(myOpp.Id);
            //si owner n'a pas changé et owner a comme agence une agence one et 
            //statut a changé à gagné ou depuis gagné ou 
            //Action_commerciale_principale__c a changé à vide ou depuis vide ou
            //annee de signature a changé à l'année courante ou depuis l'année courante 
            if( myOpp.ownerid == oldOpp.Ownerid &&
               setAgenceCodes.contains(myOpp.zzz_TechCodeAgenceDuProprietaire__c) &&(
              (myOpp.Statut__c != oldOpp.Statut__c && (myOpp.Statut__c == label.OppBeforeUp_gagne || oldOpp.Statut__c == label.OppBeforeUp_gagne))
               ||(myOpp.Action_commerciale_principale__c != oldOpp.Action_commerciale_principale__c&& (myOpp.Action_commerciale_principale__c == null || oldOpp.Action_commerciale_principale__c == null))
               || (myOpp.Annee_de_signature__c != oldOpp.Annee_de_signature__c && (myOpp.Annee_de_signature__c == currentYear || oldOpp.Annee_de_signature__c == currentYear)))){
                   setAffectedAgenceCodes.add(myOpp.zzz_TechCodeAgenceDuProprietaire__c);
               }
            //si owner a changé et il était ou devenu dans une agence one
            if(myOpp.ownerid != oldOpp.Ownerid
               && (setAgenceCodes.contains(myOpp.zzz_TechCodeAgenceDuProprietaire__c) || 
                   setAgenceCodes.contains(oldOpp.zzz_TechCodeAgenceDuProprietaire__c))){
                       if(setAgenceCodes.contains(myOpp.zzz_TechCodeAgenceDuProprietaire__c)){
                           setAffectedAgenceCodes.add(myOpp.zzz_TechCodeAgenceDuProprietaire__c);
                       }
                       if(setAgenceCodes.contains(oldOpp.zzz_TechCodeAgenceDuProprietaire__c)){
                           setAffectedAgenceCodes.add(oldOpp.zzz_TechCodeAgenceDuProprietaire__c);
                       }
                   }
        }
        if(setAffectedAgenceCodes != null && setAffectedAgenceCodes.size()>0){
            VentesAddAgenceAuCoursAnnee(setAffectedAgenceCodes);
        }
    }
/** 
* @author: Dona Kfoury
* @date: 01/09/2020    
* @description: dans le cas de modification de l'agence d'un utilisateur lui calculer le taux de renouvellement de son agence
* @param listUsers: nouvelle version des utilisateurs modifiés
* @param mapOldUsers: ancienne version des utilisateurs modifiés
* @return: void
*/

    public static void EditAgenceOuProfil(list<user> listUsers, map<id, user>mapOldUsers){
        //profiles du taux de la vente additionelle
        string profiledVenteToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileVenteNames = profiledVenteToInclude.split('-');
        Set<String> setProfileVenteNames = new Set<String>(listProfileVenteNames);
        //profiles du taux de la vente additionelle
        set<string> setAffectedAgenceCodes = new set<string>();
        set<Id> setNewVenteFirstIds = new set<Id>();
        set<Id> setOldVenteFirstIds = new set<Id>();
        set<string> setNewVenteFirstAgences = new set<string>();
        
        //chercher les agences ones pour lesquelles il faut calculer le taux
        string AgencesToInclude = label.AgencesOne_DKcode;
        list<string> lisAgences = AgencesToInclude.split('-');
        Set<String> setAgenceCodes = new Set<String>(lisAgences);
        
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
                    setOldVenteFirstIds.add(myUser.Id);
                }
            }
            //si le profil de l'utilisateur  a changé
            //devenu un profil one
            if(myUser.profileid != oldUser.profileid && 
               setProfileVenteNames.contains(myUser.ZZZ_NomDuProfil__c) && !setProfileVenteNames.contains(oldUser.ZZZ_NomDuProfil__c)  && setAgenceCodes.contains(myUser.organisation__c)){     
                   setNewVenteFirstIds.add(myUser.Id);
                   setNewVenteFirstAgences.add(myUser.organisation__c);
               }
            //n'est plus un profil one
            if(myUser.profileid != oldUser.profileid && 
               setProfileVenteNames.contains(oldUser.ZZZ_NomDuProfil__c) && !setProfileVenteNames.contains(myUser.ZZZ_NomDuProfil__c) ){
                   setOldVenteFirstIds.add(myUser.Id);
               }
        }
        
        if(setAffectedAgenceCodes != null && setAffectedAgenceCodes.size()>0){
            CallCalculVenteUnFurure(setAffectedAgenceCodes);
        }
        if(setNewVenteFirstIds!= null && setNewVenteFirstIds.size()>0){
            CalculerLeTaux(setNewVenteFirstIds, setNewVenteFirstAgences);
        }
        if(setOldVenteFirstIds!= null && setOldVenteFirstIds.size()>0){
            ReinitialiserTauxAgences(setOldVenteFirstIds);
        }
    }
           
            /** 
* @author: Dona Kfoury
* @date: 01/09/2020    
* @description: call update taux vente de l'agence dans un future call parce qu'on est dans le context d'un user trigger
* @param setAffectedAgenceCodes: code des agences affectés
* @return: void
*/
    @future
    public static void CallCalculVenteUnFurure(set<string> setAffectedAgenceCodes){
        VentesAddAgenceAuCoursAnnee(setAffectedAgenceCodes);
    }
            /** 
* @author: Dona Kfoury
* @date: 01/09/2020    
* @description: dans le cas de modification du profil de l'utilisateur à  first, calculer le taux de vente de son agence  
* @param setNewVenteFirstIds: ids des utilusateurs à calculer
* @param setNewVenteFirstAgences: codes des agences des utilusateurs à calculer
* @return: void
*/
    @future
    public static void CalculerLeTaux(set<id>setNewVenteFirstIds, set<string> setNewVenteFirstAgences){
        string profiledToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        string currentYear = string.valueOf(System.Today().year());
        //prendre les opportunités reliés aux agences
        List<aggregateResult> listSumOpps =[ SELECT count(id) sum,owner.Organisation__c orgCode 
                                            FROM opportunity 
                                            WHERE statut__c =: label.OppBeforeUp_gagne
                                            AND Action_commerciale_principale__c != null
                                            AND Annee_de_signature__c =: currentYear
                                            AND owner.Organisation__c in: setNewVenteFirstAgences
                                            group by owner.Organisation__c];
        Map<string,Integer> mapAgenceToOppsNumb = new Map<string,Integer>();
        //mapper pour chaque agence, le nombre de opps gagnés reliés
        for (AggregateResult arOpps : listSumOpps)  {
            mapAgenceToOppsNumb.put(String.valueof(arOpps.get('orgCode')),Integer.valueof(arOpps.get('sum')));
        }
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        List<Objectif__c> listAffectedObjectifs= [SELECT id, VentesAdditionnellesDeLAgence__c, Commercial__c, Annee__c,DkCodeAgenceCommercial__c 
                                                  FROM Objectif__c
                                                  WHERE Annee__c =: currentYear and Commercial__c in: setNewVenteFirstIds and DkCodeAgenceCommercial__c  in:setNewVenteFirstAgences and Profil_du_responsable__c in:setProfileNames
                                                 ];
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(objectif__c myObjectif:listAffectedObjectifs){
            if(mapAgenceToOppsNumb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.VentesAdditionnellesDeLAgence__c != mapAgenceToOppsNumb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.VentesAdditionnellesDeLAgence__c = mapAgenceToOppsNumb.get(myObjectif.DkCodeAgenceCommercial__c);
                    listObjToUpdate.add(myObjectif);
                } 
            }
            else{
                //il faut reinitilaiser la valaeur à 0
                if(myObjectif.VentesAdditionnellesDeLAgence__c != 0){
                    myObjectif.VentesAdditionnellesDeLAgence__c = 0;
                    listObjToUpdate.add(myObjectif);
                }
            }  
        }
        //maj des objectifs
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
    }
           
 /** 
* @author: Dona Kfoury
* @date: 01/09/2020    
* @description: dans le cas de modification du profil de l'utilisateur à non first, reinitialiser le taux de vente de son agence à 0 
* @param setOldVenteFirstIds: ids des utilusateurs à reinitialiser
* @return: void
*/
    @future
    public static void ReinitialiserTauxAgences(set<id>setOldVenteFirstIds){
        string currentYear = string.valueOf(System.Today().year());
        list<Objectif__c> listObjs = [SELECT id,  Commercial__c, Annee__c, VentesAdditionnellesDeLAgence__c
                                                                  FROM Objectif__c
                                                                  WHERE Annee__c =: currentYear and Commercial__c in:setOldVenteFirstIds
                                                                 ];
        list<objectif__c> listObjToUpdate= new list<objectif__c>();
        for(objectif__c myObjectif:listObjs){
            if( myObjectif.VentesAdditionnellesDeLAgence__c != 0){
                myObjectif.VentesAdditionnellesDeLAgence__c = 0;
                listObjToUpdate.add(myObjectif);
            }
        }
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
    }

    
    /** 
* @author: Dona Kfoury
* @date: 01/09/2020  
* @description: dans le cas de actions qui affectent le champ Ventes_Additionnelles__c d'une agence, recalculer ce champ pour les utilisateurs de l'agence concerné
* @param setAffectedAgenceCodes: set des codes des agences concernés
* @return: void
*/
    public static void VentesAddAgenceAuCoursAnnee(set<string> setAffectedAgenceCodes){
        string profiledToInclude = label.Profils_AgenceTauxVenteAdd;
        list<string> listProfileNames = profiledToInclude.split('-');
        Set<String> setProfileNames = new Set<String>(listProfileNames);
        
        string currentYear = string.valueOf(System.Today().year());
        //prendre les opportunités reliés aux agences
        List<aggregateResult> listSumOpps =[ SELECT count(id) sum,owner.Organisation__c orgCode
                                            FROM opportunity 
                                            WHERE statut__c =: label.OppBeforeUp_gagne
                                            AND Action_commerciale_principale__c != null
                                            AND Annee_de_signature__c =: currentYear
                                            AND owner.Organisation__c in: setAffectedAgenceCodes
                                            group by owner.Organisation__c];
        Map<string,Integer> mapAgenceToOppsNumb = new Map<string,Integer>();
        //mapper pour chaque agence, le nombre de opps gagnés reliés
        for (AggregateResult arOpps : listSumOpps)  {
            mapAgenceToOppsNumb.put(String.valueof(arOpps.get('orgCode')),Integer.valueof(arOpps.get('sum')));
        }
        
        //chercher les objectifs de l'année courante affectés aux utilisateurs de l'agance
        List<Objectif__c> listAffectedObjectifs= [SELECT id, VentesAdditionnellesDeLAgence__c, Commercial__c, Annee__c,DkCodeAgenceCommercial__c 
                                                  FROM Objectif__c
                                                  WHERE Annee__c =: currentYear and DkCodeAgenceCommercial__c  in:setAffectedAgenceCodes and Profil_du_responsable__c in:setProfileNames
                                                 ];
        List<Objectif__c> listObjToUpdate = new List<Objectif__c>();
        for(objectif__c myObjectif:listAffectedObjectifs){
            if(mapAgenceToOppsNumb.containsKey(myObjectif.DkCodeAgenceCommercial__c))
            {
                if(myObjectif.VentesAdditionnellesDeLAgence__c != mapAgenceToOppsNumb.get(myObjectif.DkCodeAgenceCommercial__c)){
                    myObjectif.VentesAdditionnellesDeLAgence__c = mapAgenceToOppsNumb.get(myObjectif.DkCodeAgenceCommercial__c);
                    listObjToUpdate.add(myObjectif);
                } 
            }
            else{
                //il faut reinitilaiser la valaeur à 0
                if(myObjectif.VentesAdditionnellesDeLAgence__c != 0){
                    myObjectif.VentesAdditionnellesDeLAgence__c = 0;
                    listObjToUpdate.add(myObjectif);
                }
            }  
        }
        //maj des objectifs
        if(listObjToUpdate != null && listObjToUpdate.size()>0){
            PAD.PAD_BypassTrigger += ';AP55_ObjectifAgence;';
            database.update(listObjToUpdate,false);
        }
        
    }
}