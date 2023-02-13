/** 
* @author Jimmy Khalil - Ei technologies
* @date 24/05/2021 
* @description  Batch That Update the field ContratAyantActiviteSurLAnnee__c on Contrat
* @Test Class Batch112_UpdateActiviteContrat_TEST 100%
*/
global class Batch112_UpdateActiviteContrat implements Database.Batchable<SObject>
{
    User userMigration = [select id from User where name = 'User migration'];
    String currYear = String.valueOf(System.Today().year());
    String contratFerme = Label.ContratFerme;
    String oppTypeRenouv = Label.Opp_type_Renewal;
    String oppGagne = Label.OppBeforeUp_gagne;
    
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
                
        //query:
        //contrat active or (inactive + ContratActifOuRenouveleSurAnnee__c = true to set to false)
        //contrat genere par un renouv gagne sur l'anne courante (contrat.opp = renouv) et le contrat qui a genere (contrat.opp.contratOrginie)
        
        String agOne = '%'+Label.AgenceOne+'%';
        
        //String query='SELECT id,ContratAyantActiviteSurLAnnee__c,ContratActifOuRenouveleSurAnnee__c FROM Contrat__c WHERE Statut__c!=:ContratFerme  AND Agence_du_Pilote__c like:agOne';
        
        String query='SELECT id,Statut__c,ContratAyantActiviteSurLAnnee__c,ContratActifOuRenouveleSurAnnee__c,OpportuniteCommerciale__r.ContratOrigine__c,OpportuniteCommerciale__c,'+
        'OpportuniteCommerciale__r.ContratOrigine__r.Statut__c,OpportuniteCommerciale__r.Type_pers__c,OpportuniteCommerciale__r.Annee_de_signature__c,OpportuniteCommerciale__r.Statut__c '+
            'FROM Contrat__c WHERE ((Statut__c!=:contratFerme OR (Statut__c=:contratFerme AND ContratActifOuRenouveleSurAnnee__c = true)) '+
            ' OR (OpportuniteCommerciale__r.Type_pers__c =:oppTypeRenouv AND OpportuniteCommerciale__r.Annee_de_signature__c =:currYear and OpportuniteCommerciale__r.Statut__c =:oppGagne))'+
            ' AND Agence_du_Pilote__c like:agOne';
        
        return Database.getQueryLocator(query); 
    }
    global void execute (Database.BatchableContext bc , List<Contrat__c> listContrats)
    {
        //Update Bypasses on User Migration
        userMigration.BypassValidationRules__c =  true;
        userMigration.BypassFilters__c = true;
        update userMigration;
        //call updateContrat
        Date dateYear = Date.newInstance(System.Today().year(), 1, 1);
        String agOne = '%'+Label.AgenceOne+'%';
        set<Id> setContratsIds = new set<Id>(); 
        //Map<id,Boolean> mapContrat =new Map<id,Boolean>();
        //map<id,Boolean> mapContratActivite = new  map<id,Boolean>();
        Map<String,Contrat__c> mapIdContratToUpdate = new Map<String,Contrat__c>();
        
        set<Id> setContratsIdsForContratActifOuRenouveleSurAnneeTrue = new set<Id>(); 
        set<Id> setContratsIdsContratAyantActiviteSurLAnneeTrue = new set<Id>(); 
        
        for(Contrat__c con:listContrats)
        {
            
            setContratsIds.add(con.Id);
            if(con.Statut__c!=contratFerme){
                //contrat active -> verifier s'il a une activite termine dans l'anne pour mettre ContratAyantActiviteSurLAnnee__c = vrai
                setContratsIds.add(con.Id);
                
                //contrat active -> ContratActifOuRenouveleSurAnnee__c = true
                setContratsIdsForContratActifOuRenouveleSurAnneeTrue.add(con.Id);
            }
            if(con.OpportuniteCommerciale__c != null &&
                     con.OpportuniteCommerciale__r.Type_pers__c == oppTypeRenouv &&
                     con.OpportuniteCommerciale__r.Annee_de_signature__c ==currYear &&
                     con.OpportuniteCommerciale__r.Statut__c == oppGagne){
                         //le contrat est genere d'un renouvellement gagne sur l'anne courante -> verifier s'il a une activite termine dans l'anne pour mettre ContratAyantActiviteSurLAnnee__c = vrai
                         setContratsIds.add(con.Id);
                         
                         if(con.OpportuniteCommerciale__r.ContratOrigine__c != null &&
                            con.OpportuniteCommerciale__r.ContratOrigine__r.Statut__c == contratFerme){
                             //contrat ferme qui a genere a partir d'un renouvellement gagne sur l'anne courante un nouveau contrat -> ContratActifOuRenouveleSurAnnee__c = true
                             setContratsIdsForContratActifOuRenouveleSurAnneeTrue.add(con.OpportuniteCommerciale__r.ContratOrigine__c); 
                         }
                         
                     }
            
            //mapContrat.put(con.Id,con.ContratAyantActiviteSurLAnnee__c);
        }
        
        /*for (Contrat__c cont :listContrats)
{
mapContratActivite.put(cont.id,false);
}*/
        if (setContratsIds!=NULL && setContratsIds.size()>0)
        {
            //verifier les activites pour les contrats actif ou genere d'un renouvellement gagne sur l'anne courante
            List<Event> listEvent = [SELECT id, WhatId , Rdvralise__c , EndDate 
                                     FROM Event 
                                     WHERE WhatId in:setContratsIds AND TechContratEcheance__c =NULL AND EndDate >=:dateYear AND EndDate < TODAY ];
            List<Task> listTask = [SELECT id,WhatId, RDV_realise__c , ActivityDate
                                   FROM Task
                                   WHERE TaskSubtype ='Call' AND WhatId in :setContratsIds AND ActivityDate>=:dateYear AND ActivityDate < TODAY]; 
            for(Event evnt : listEvent)
            {
                setContratsIdsContratAyantActiviteSurLAnneeTrue.add(evnt.WhatId);
            }
            for(Task tsk : listTask)
            {
                setContratsIdsContratAyantActiviteSurLAnneeTrue.add(tsk.WhatId);
            }
        }
        for(Contrat__c con:listContrats)
        {
            
            Contrat__c contratToUpdate = new Contrat__c(id=con.Id);
            
            if(setContratsIdsContratAyantActiviteSurLAnneeTrue.contains(con.Id)){
                contratToUpdate.ContratAyantActiviteSurLAnnee__c = True;
            }else{
                contratToUpdate.ContratAyantActiviteSurLAnnee__c = False;
            }
            
            if(setContratsIdsForContratActifOuRenouveleSurAnneeTrue.contains(con.Id)){
                contratToUpdate.ContratActifOuRenouveleSurAnnee__c = True;
            }else{
                contratToUpdate.ContratActifOuRenouveleSurAnnee__c = False;
            }
            mapIdContratToUpdate.put(con.Id,contratToUpdate);
            
        }
        //pour ajouter les contrats qui ont genere (contrat.opp.contratOrginie)
        for(String conId:setContratsIdsForContratActifOuRenouveleSurAnneeTrue){
            if(mapIdContratToUpdate.containsKey(conId)){
                mapIdContratToUpdate.get(conId).ContratActifOuRenouveleSurAnnee__c = true;
            }else{
                mapIdContratToUpdate.put(conId,new Contrat__c(id=conId,ContratActifOuRenouveleSurAnnee__c = true));
            }
        }
        
        if (mapIdContratToUpdate!=NULL && mapIdContratToUpdate.size()>0)
        {
            update mapIdContratToUpdate.values();
        }
    }
    
    
    global void finish(Database.BatchableContext bc)
    {
        userMigration.BypassValidationRules__c =  false;
        userMigration.BypassFilters__c = false;
        update userMigration;
    }
}