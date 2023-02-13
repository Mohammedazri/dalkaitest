/** 
* @author Jacques Akiki - Ei technologies
* @date 23/12/2020 
* @description Batch qui met a jour les champs d'enquetes sur contact
* @Test Class Batch102_NoteSatisfaction_TEST
*/
global class Batch102_NoteSatisfaction implements Database.Batchable<SObject>,Database.Stateful {
    global final set<id> setAccId = new set<id>();
    /** 
* @author Jacques Akiki
* @date 23/12/2020  
* @chercher les Contacts
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query='SELECT id from Contact';
        return Database.getQueryLocator(query);
    }
    
    /** 
* @author Jacques Akiki  
* @date 23/12/2020
* @selectionne le numero de la derniere enquete, met à jour le contact avec les champs de l'enquete.
* @param Database.BatchableContext and list of contact
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Contact> listCont)
    {
        map<Id,contact> mapIdContact = new map<Id,contact>();
        for(Contact cont: listCont){
            cont.Indicateur_de_satisfaction__c = null; //Vider le champ satisfaction client de tout les comptes
            cont.Supporteur__c = null;
            mapIdContact.put(cont.id,cont); //Mettre tout les id des comptes dans ce set
        }
        
        List<Contact_Satisfaction__c> maxEnquete = [SELECT id,NumeroEnquete__c
                                                    FROM Contact_Satisfaction__c
                                                    WHERE NumeroEnquete__c  != null
                                                    ORDER BY NumeroEnquete__c DESC
                                                    LIMIT 1]; //Le numero de la derniere enquete injectée
        Decimal numeroEnquete = 0;
        if(maxEnquete != null && maxEnquete.size()>0 && maxEnquete[0].NumeroEnquete__c != null){
            numeroEnquete = maxEnquete[0].NumeroEnquete__c;//Le numero de la derniere enquete injectée
        }
        //Les contact satisfaction dont le contact a le partenaire dans le set rempli en dessus et qui appartiennent a l'enquete la plus recente
        List<Contact_Satisfaction__c> satisfactionList = [SELECT id,IndicateurSatisfaction__c,contact__c,NumeroEnquete__c,Recommandation__c , contact__r.AccountId
                                                          FROM Contact_Satisfaction__c
                                                          WHERE NumeroEnquete__c = :numeroEnquete
                                                          AND (IndicateurSatisfaction__c != null OR Recommandation__c!=NULL)
                                                          AND contact__c in :mapIdContact.keyset()];
        Map<Id,String> mapContactSatisfaction = new Map<Id,String>();//Map du compte avec la plus basse note de satisfaction de ces partenaires
        
        for(Contact_Satisfaction__c satisfaction : satisfactionList)
        {
            mapIdContact.get(satisfaction.contact__c).Indicateur_de_satisfaction__c = satisfaction.IndicateurSatisfaction__c;
            mapIdContact.get(satisfaction.contact__c).Supporteur__c = satisfaction.Recommandation__c;
            setAccId.add(satisfaction.contact__r.AccountId);
        }
        
        update mapIdContact.values();
    }
    /*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
        System.debug('........'+setAccId);
        Id batchId = Database.executeBatch(new Batch107_UpdateSatisfactionPartenaire(setAccId));
    }
}