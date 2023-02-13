/** 
* @author Dona Kfoury
* @date 21/04/2020 
* @description class contenant des méthodes qui vérifient si nous pouvons supprimer le compte
* @Test Class AP79_Account_Test
*/
public class AP79_Account {
    /** 
* @author Dona Kfoury 
* @date 21/04/2020
* @vérification si nous pouvons supprimer le compte ou pas
* @param listAccounts: list des comptes que l'utilisateur essaie de supprimer
* @return boolean, pour vérifier si continuer avec les uatres méthodes ou pas
*/
    public static void checkIfCanDeleteAccount (List<Account> listAccounts){
        string strADV = label.AP79_ADVProfiles;
        set<string> setADV = new Set<String>(strADV.split(';'));
        List<Profile> listPfs = [Select id, name
                                 FROM profile
                                 WHERE Name in: setADV];
        set<id> setAdvsIds = new set<Id>();
        for(Profile pf: listPfs){
            setAdvsIds.add(pf.Id);
        }
        // si profile != admin ou adv -->cas 4: vous n'avez pas le droit de supprimer les partenaires 
        if(userinfo.getProfileId() != label.AdminProfileId &&
           !(setAdvsIds.contains(userinfo.getProfileId()))){
               for(account acc: listAccounts)    {
                   acc.addError(label.AP79_Cas4);
               }           
           }
        //else si profiles admin ou adv: 
        else{
            map<id, Account> mapAcss = new Map<ID, Account>([Select id, recordtypeId,recordtype.developerName,ispersonaccount,
                                      (Select id FROM opportunities limit 1),
                                      (Select id FROM Contacts limit 1),
                                      (Select id FROM partenairelie__r limit 1),
                                      (Select id FROM Contrats1__r limit 1),
                                      (Select id FROM OpportunitesCommSocieteVente__r limit 1)
                                      FROM Account where id in:listAccounts]);
            
            
            for(Account acc: listAccounts){
                if(mapAcss.containskey(acc.id)){
                     //account non temporaire
                        //si rpofile adv: 
                        if(setAdvsIds.contains(userinfo.getProfileId())){
                        //cas 3: vous n'avez pas le droit de supprimer les partenaires synchronisés
                             acc.addError(label.AP79_Cas3);
                        }
                        // else --> si profil admin
                        else{
                            //si avec objets relié
                             if(mapAcss.get(acc.id).opportunities.size()>0 || mapAcss.get(acc.id).OpportunitesCommSocieteVente__r.size()>0 ||
                                (mapAcss.get(acc.id).ispersonaccount ==false && mapAcss.get(acc.id).Contacts.size()>0 )
                                || mapAcss.get(acc.id).partenairelie__r.size()>0 || mapAcss.get(acc.id).Contrats1__r.size()>0){
                                //> cas 2 vous n'avez pas le droit de supprimer un partenaire lié à une opp, contact ou ecosystème
                                acc.addError(label.AP79_Cas2); 
                             }
                            //else: si account sans objet reliés: rien faire
                        }
                }
            }
        } 
    }
}