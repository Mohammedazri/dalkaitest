/** 
* @author: Dona Kfoury
* @date: 07/07/2020 
* @description:MAJ du champ AuMoinsUnContactEspaceClient__c sur contrat par true si le contrat possède au moins un contact relié ayant le champ "Contact Espace Client" est vrai
* @Test: Class AP86_ContratContact_Test
*/
public without sharing class AP86_ContratContact {
     /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas de création ou suppression de l'objet de jonction ContratContact__c, recalculer le champ ContratContact__c du contrat parent 
* @param listContactContrats: list des ContratContact__c créés ou supprimés
* @return: void
*/
    public static void contactContratInsertDelete(list<ContratContact__c> listContactContrats){
        set<string> setContratsAffectesIds = new set<string>();
        for(ContratContact__c conCont: listContactContrats)
        {
            setContratsAffectesIds.add(conCont.contrat__c);
        }
        if(setContratsAffectesIds != null && setContratsAffectesIds.size()>0){
            contratsAyantContactEspaceClient(setContratsAffectesIds, null);
        }
        
    }

     /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas de modification du champ IsContactEspaceClient__c modifié le champ AuMoinsUnContactEspaceClient__c des contrats concernés
* @param listContacts: list des contacts modifiés
* @param mapOldContact: map ancienne version des contacts modifiés
* @return: void
*/
    public static void contactUpdate(list<Contact> listContacts, map<id, Contact>mapOldContact){
        set<string> setContratsAffectesIds = new set<string>();
        set<string> setContactIds = new set<string>();
        for(Contact Cont: listContacts)
        {
            if(Cont.IsContactEspaceClient__c != mapOldContact.get(Cont.Id).IsContactEspaceClient__c){
                setContactIds.add(Cont.Id);
            }
        }
        
        if(setContactIds != null && setContactIds.size()>0){
           //chercher les objets jonctions reliés à ces contacts pour trouver les contrats à mettre à jour
            List<ContratContact__c> ListConContr =[SELECT id, contact__c, Contrat__c
                                                  FROM ContratContact__c
                                                  WHERE contact__c in:setContactIds];
            for(ContratContact__c concont: ListConContr){
                setContratsAffectesIds.add(concont.Contrat__c);
            }
            if(setContratsAffectesIds != null && setContratsAffectesIds.size()>0){
                contratsAyantContactEspaceClient(setContratsAffectesIds, null);
            }
        }
        
    }
    
    /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas de suppression d'un contact modifié le champ AuMoinsUnContactEspaceClient__c des contrats concernés
* @param listContacts: list des contacts modifiés
* @param mapOldContact: map ancienne version des contacts modifiés
* @return: void
*/
    public static void contactDelete(list<Contact> listContacts){
        set<string> setContratsAffectesIds = new set<string>();
        set<string> setContactIds = new set<string>();
        for(Contact Cont: listContacts)
        {
            setContactIds.add(Cont.Id);
        }
        if(setContactIds != null && setContactIds.size()>0){
           //chercher les objets jonctions reliés à ces contacts pour trouver les contrats à mettre à jour
            List<ContratContact__c> ListConContr =[SELECT id, contact__c, Contrat__c
                                                  FROM ContratContact__c
                                                  WHERE contact__c in:setContactIds];
            
            for(ContratContact__c concont: ListConContr){
                setContratsAffectesIds.add(concont.Contrat__c);
            }
            if(setContratsAffectesIds != null && setContratsAffectesIds.size()>0){
                contratsAyantContactEspaceClient(setContratsAffectesIds, setContactIds);
            }
        }
        
    }
    
        /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas supprimé les contacts des personaccount modifié le champ AuMoinsUnContactEspaceClient__c des contrats concernés
* @param listContacts: list des contacts modifiés
* @param mapOldContact: map ancienne version des contacts modifiés
* @return: void
*/
    public static void accountDelete(list<account> listPAs){
        set<string> setContratsAffectesIds = new set<string>();
        set<string> setContactIds = new set<string>();
        for(account myPA: listPAs)
        {
            if(myPA.isPersonAccount == true){
                setContactIds.add(myPA.PersonContactId);
            }
        }
        
        if(setContactIds != null && setContactIds.size()>0){
           //chercher les objets jonctions reliés à ces contacts pour trouver les contrats à mettre à jour
            List<ContratContact__c> ListConContr =[SELECT id, contact__c, Contrat__c
                                                  FROM ContratContact__c
                                                  WHERE contact__c in:setContactIds];
            for(ContratContact__c concont: ListConContr){
                setContratsAffectesIds.add(concont.Contrat__c);
            }
            if(setContratsAffectesIds != null && setContratsAffectesIds.size()>0){
                contratsAyantContactEspaceClient(setContratsAffectesIds, setContactIds);
            }
        }
        
    }
    
    /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas de modification du champ IsContactEspaceClient__c modifié le champ AuMoinsUnContactEspaceClient__c des contrats concernés
* @param listContacts: list des contacts modifiés
* @param mapOldContact: map ancienne version des contacts modifiés
* @return: void
*/
    public static void PersonAccountUpdate(list<account> listPAs, map<id, account>mapOldPA){
        set<string> setContratsAffectesIds = new set<string>();
        set<string> setContactIds = new set<string>();
        for(account myPA: listPAs)
        {
            if(myPA.isPersonAccount == true && myPA.IsContactEspaceClient__pc != mapOldPA.get(myPA.Id).IsContactEspaceClient__pc){
                setContactIds.add(myPA.PersonContactId);
            }
        }
        
        if(setContactIds != null && setContactIds.size()>0){
           //chercher les objets jonctions reliés à ces contacts pour trouver les contrats à mettre à jour
            List<ContratContact__c> ListConContr =[SELECT id, contact__c, Contrat__c
                                                  FROM ContratContact__c
                                                  WHERE contact__c in:setContactIds];
            for(ContratContact__c concont: ListConContr){
                setContratsAffectesIds.add(concont.Contrat__c);
            }
            if(setContratsAffectesIds != null && setContratsAffectesIds.size()>0){
                contratsAyantContactEspaceClient(setContratsAffectesIds, null);
            }
        }
        
    }
    
    /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas de modification de l'objet de jonction ContratContact__c, recalculer le champ ContratContact__c du contrat parent 
* @param listContactContrats: list des ContratContact__c modifiés
* @param mapOldConContr: map des anciennes versions des ContratContact__c modifiés
* @return: void
*/
    public static void contactContratEdit(list<ContratContact__c> listContactContrats, map<id, ContratContact__c>mapOldConContr){
        set<string> setContratsAffectesIds = new set<string>();
        for(ContratContact__c conCont: listContactContrats)
        {
            if(conCont.contrat__c != mapOldConContr.get(conCont.Id).contrat__c ){
                setContratsAffectesIds.add(conCont.contrat__c);
                setContratsAffectesIds.add(mapOldConContr.get(conCont.Id).contrat__c );
            }
            if(conCont.contact__c != mapOldConContr.get(conCont.Id).contact__c){
                setContratsAffectesIds.add(conCont.contrat__c);
            }
        }
        if(setContratsAffectesIds != null && setContratsAffectesIds.size()>0){
            contratsAyantContactEspaceClient(setContratsAffectesIds, null);
        }
        
    }
        /** 
* @author: Dona Kfoury
* @date: 07/07/2020   
* @description: dans le cas ou une action affectant le champ AuMoinsUnContactEspaceClient__c du contrat a eu lieu, cette méthode recalcule ce champ pour le contrat affecté
* @param setContratIds: set des ids des contrats affectés
* @return: void
*/
    public static void contratsAyantContactEspaceClient(set<string> setContratIds, set<string>setContactsANePasInclur){
        //chercher tous les objets de jonctions reliant les contrats affectés à leurs contact liés
        List<ContratContact__c> ListContactContrat = [SELECT id, Contact__c, contrat__c, contrat__r.AuMoinsUnContactEspaceClient__c, contact__r.IsContactEspaceClient__c
                                                      FROM ContratContact__c
                                                      WHERE contrat__c in:setContratIds and contact__c not in:setContactsANePasInclur];
        map<string, boolean> mapContratIdToIfEspaceClient = new map<string, boolean>();
        for(ContratContact__c contcontr:ListContactContrat) {
            if(!mapContratIdToIfEspaceClient.containsKey(contcontr.contrat__c)){
                mapContratIdToIfEspaceClient.put(contcontr.contrat__c, false);
            }
            if(contcontr.contact__r.IsContactEspaceClient__c == true){
                mapContratIdToIfEspaceClient.put(contcontr.contrat__c, true);
            }
        }
        system.debug('mapContratIdToIfEspaceClient '+mapContratIdToIfEspaceClient);
        //chercher l'ancienne valeur du champ AuMoinsUnContactEspaceClient__c du contrat pour voir si la valeur va changer
        list<contrat__c> listContrats = [SELECT id, AuMoinsUnContactEspaceClient__c 
                                        FROM Contrat__c
                                        WHERE id in:setContratIds];
        list<Contrat__c> listContratsToUpdate = new List<Contrat__c>();
        
        for(Contrat__c myCon:listContrats){
            //si la valeurs du champ à changer, mettre à jour le contrat
            if(mapContratIdToIfEspaceClient.containskey(myCon.Id) && mapContratIdToIfEspaceClient.get(myCon.Id) != myCon.AuMoinsUnContactEspaceClient__c){
                myCon.AuMoinsUnContactEspaceClient__c = mapContratIdToIfEspaceClient.get(myCon.Id);
                listContratsToUpdate.add(myCon);
            }
            else if(!mapContratIdToIfEspaceClient.containskey(myCon.Id) && myCon.AuMoinsUnContactEspaceClient__c != false){
                myCon.AuMoinsUnContactEspaceClient__c = false;
                listContratsToUpdate.add(myCon);
            }
        }
        system.debug('listContratsToUpdate' + listContratsToUpdate);
        if(listContratsToUpdate != null && listContratsToUpdate.size()>0){
            update listContratsToUpdate;
        }
        
    }

}