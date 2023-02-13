/**
* @author Dona Kfoury
* @date 19/05/2020
* @description Batch qui renseigne le champ ContratsActifsRattaches__c du partenaire parent en cas ou ce partenaire possède 
* au minima un contrat actif
* @Test Class: Batch73_ContratsActifs_test
*/
global class Batch73_ContratsActifs implements Database.Batchable<SObject>,Database.stateful{
global string limt;
    	    /** 
* @author Dona Kfoury
* @date 19/05/2020
* @constructeur du batch
*/
    global Batch73_ContratsActifs(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
/*
* @author: Dona Kfoury
* @date: 19/05/2020 
* @description: chercher tous les partenaires de l'environnement
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, ContratsActifsRattaches__c,'+
            ' (select id, statut__c from Contrats1__r)'+
            ' FROM account ';
        
        if(limt<>'' && limt<>null)
        {
            query = query + limt; 
        }
        
        return Database.getQueryLocator(query);
    }
    /*
* @author: Dona Kfoury
* @date: 19/05/2020 
* @description: mettre à jour le champ ContratsActifsRattaches__c du partenaire dans le cas ou il possède au minimum un contrat actif
*/
    global void execute (Database.BatchableContext bc , List<account> listAccs)
    {
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
    /*
* @author: Dona Kfoury
* @date: 19/05/2020 
* @description: rien à faire dans Finish
*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}