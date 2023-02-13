/** 
* @author: Dona Kfoury
* @date: 19/05/2020 
* @description: mettre à jour le champ sur le partenaire parent, qui indique si ce partenaire possède un contrat actif
* @Test: Class AP82_Contrat_Test
*/
public class AP82_Contrat {
    /** 
* @autho:r Dona Kfoury
* @date: 19/05/2020 
* @description: dans le cas de création ou suppression d'un contrat cette méthode prépare les partenaires concernés
* @param contList: listdes contrat créés ou supprimés
* @return: void
*/
    public static void ContratInsertDelete(List<Contrat__c> contList){
        Set<Id> setAccountIds = new Set<Id>();
        for(contrat__c con:contList){
            setAccountIds.add(con.NomPartenaire__c);
        }
        if(setAccountIds != null && setAccountIds.size()>0)
        {
            CheckIfContratActifSurOartenaire(setAccountIds);
        }
    }
    
    /** 
* @author: Dona Kfoury
* @date: 19/05/2020 
* @description: dans le cas de modification d'un contrat cette méthode prépare les partenaires concernés
* @param contList: listdes contrat modifiés
* @return: void
*/
    public static void ContratUpdate(List<Contrat__c> contList, map<id,Contrat__c> mapOldCont){
        system.debug('ContratUpdate ');
        Set<Id> setAccountIds = new Set<Id>();
        for(contrat__c con:contList){
            if(mapOldCont.containskey(con.Id) && (con.statut__c != mapOldCont.get(con.Id).statut__c
                                                  || con.NomPartenaire__c != mapOldCont.get(con.Id).NomPartenaire__c))
                setAccountIds.add(con.NomPartenaire__c);
            setAccountIds.add(mapOldCont.get(con.Id).NomPartenaire__c);
        }
        if(setAccountIds != null && setAccountIds.size()>0)
        {
            CheckIfContratActifSurOartenaire(setAccountIds);
        }
    }
    /** 
* @author: Dona Kfoury
* @date: 19/05/2020 
* @description: cette méthode maj le champ ContratsActifsRattaches__c du partenaire par true si ce dernier est le parent d'un
* contrat actif et false si non
* @param: setAccountIds: id ses partenaires concernés
* @return: void
*/
    public static void CheckIfContratActifSurOartenaire(Set<Id> setAccountIds){
        system.debug('setAccountIds '+setAccountIds);
        List<Account> listAccs =[SELECT id, ContratsActifsRattaches__c,
                                 (select id, statut__c from Contrats1__r)
                                 FROM account
                                 WHERE id in:setAccountIds];
        system.debug('listAccs '+listAccs);
        List<Account> listAccountsToUpdate= new List<Account>();
        for(account myAcc:listAccs){
            boolean activeContratFound = false;
            for(contrat__c mycon:myAcc.Contrats1__r){
                if(mycon.statut__c != label.ContratFerme){
                    if(myAcc.ContratsActifsRattaches__c == false){
                        myAcc.ContratsActifsRattaches__c = true;
                        listAccountsToUpdate.add(myAcc);
                    }
                    activeContratFound =true;
                    //on a déjà trouvé un partenaire actif pour le partenaire, pas besoin de parcourir les autres contrats
                    break;
                }
            }
            if(!activeContratFound && myAcc.ContratsActifsRattaches__c == true){
                myAcc.ContratsActifsRattaches__c = false;
                listAccountsToUpdate.add(myAcc);
            }
        }        
        
        if(listAccountsToUpdate!= null && listAccountsToUpdate.size()>0){
            update listAccountsToUpdate;
        }
    }
}