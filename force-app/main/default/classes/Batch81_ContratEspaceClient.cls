/** 
* @author Dona kfoury - Ei technologies
* @date 08/07/2020 
* @description Batch qui renseigne le champ AuMoinsUnContactEspaceClient__c avec true si le contrat a au moin un contact rataché ayant la case "est espace client" cochée
* @Test Class Batch81_ContratEspaceClient_test
*/
global class Batch81_ContratEspaceClient implements Database.Batchable<SObject>{
/** 
    * @author Dona Kfoury 
    * @date 08/07/2020 
    * @chercher tous les contrats 
    */
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id, AuMoinsUnContactEspaceClient__c from contrat__c';
        return Database.getQueryLocator(query); 
    }
    
    /** 
    * @author Dona Kfoury  
    * @date 08/07/2020 
    * @pour chaque contrat verifier s'il a au moins un contact rattaché esoace client
    * @param Database.BatchableContext and list of contrats
    * @return void
    */
    global void execute (Database.BatchableContext bc , List<contrat__c> listMyContrats)
    {
        set<string> setContratIds = new set<string>();
        for(contrat__c myCont:listMyContrats){
            setContratIds.adD(myCont.Id);
        }
        
        
        //chercher tous les objets de jonctions reliant les contrats affectés à leurs contact liés
        List<ContratContact__c> ListContactContrat = [SELECT id, Contact__c, contrat__c, contrat__r.AuMoinsUnContactEspaceClient__c, contact__r.IsContactEspaceClient__c
                                                      FROM ContratContact__c
                                                      WHERE contrat__c in:setContratIds];
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
                system.debug('in batch '+mapContratIdToIfEspaceClient.get(myCon.Id));
                myCon.AuMoinsUnContactEspaceClient__c = mapContratIdToIfEspaceClient.get(myCon.Id);
                listContratsToUpdate.add(myCon);
            }
            else if(!mapContratIdToIfEspaceClient.containskey(myCon.Id) && myCon.AuMoinsUnContactEspaceClient__c != false){
                system.debug('in batch falseeeee');
                myCon.AuMoinsUnContactEspaceClient__c = false;
                listContratsToUpdate.add(myCon);
            }
        }
        system.debug('listContratsToUpdate' + listContratsToUpdate);
        if(listContratsToUpdate != null && listContratsToUpdate.size()>0){
            update listContratsToUpdate;
        }
        
    }
    
    
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {

    }
}