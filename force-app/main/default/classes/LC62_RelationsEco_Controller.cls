/**
 * @author: Rita Bejjani -EI Technologies
 * @date: 30/09/2019
 * @description: Class that gets all the ecosystemes related to an account or to a contact
 * @Test Class: LC62_RelationsEco_Controller_test
 * @Coverage: 100%
 */
public without sharing class LC62_RelationsEco_Controller {

/**
 * @author: Rita Bejjani -EI Technologies
 * @date: 30/9/2019
 * @description: gets all the ecosystemes related to the account having the relation 'Représantant de'
 * @inputs: Id
 * @returns: List<EcoSysListWrapper>
 */
    @AuraEnabled
    public static List<EcosystemePartenaire__c> getAccountEcoSys(Id accountId){

        //List<EcoSysListWrapper> accWrapperList = new List<EcoSysListWrapper>();
        List<EcosystemePartenaire__c> ecoList = [SELECT Id, Name, Statut__c, PartenaireLie__r.Name, PartenaireLie__c, toLabel(TypeRelation__c), Contrat__c, Contrat__r.Name, Opportunite__c, Opportunite__r.Name, Opportunite__r.Amount, Contrat__r.TotalCABudgetP1P2P3P4__c
                                                 FROM EcosystemePartenaire__c
                                                 WHERE (Opportunite__r.AccountId =: accountId OR Contrat__r.NomPartenaire__c =: accountId ) AND TypeRelation__c = :Label.LC62_TypeRelEco AND Statut__c!=:Label.WS04_INACT ];

        return ecoList;

    }

/**
 * @author: Rita Bejjani -EI Technologies
 * @date: 01/10/2019
 * @description: gets all the ecosystemes related to the contact
 * @inputs: Id
 * @returns: List<EcoSysListWrapper>
 */
    @AuraEnabled
    public static List<EcosystemePartenaire__c> getContactEcoSys (Id contactId){

        //List<EcoSysListWrapper> conWrapperList = new List<EcoSysListWrapper>();
        set<id> setOppId = new set<id>();
        set<id> setContId = new set<id>();
        for(OpportuniteContact__c oc : [SELECT id, Opportunite__c, Contact__c
                                        FROM OpportuniteContact__c
                                        WHERE contact__c = : contactId]) {
            setOppId.add(oc.Opportunite__c);
        }
        for(ContratContact__c cc : [SELECT id, Contrat__c, Contact__c
                                    FROM ContratContact__c
                                    WHERE contact__c = : contactId]) {
            setContId.add(cc.Contrat__c);
        }

        List<EcosystemePartenaire__c> ecoList = new List<EcosystemePartenaire__c>();
        if(setOppId != NULL || setContId != NULL) {
            ecoList = [SELECT Id, Name, ContactDuPartenaireLie__c, ContactDuPartenaireLie__r.Name, PartenaireLie__r.Name, PartenaireLie__c,
                       toLabel(TypeRelation__c), Contrat__c, Contrat__r.Name, Opportunite__c, Opportunite__r.Name, toLabel(Statut__c)
                       FROM EcosystemePartenaire__c
                       WHERE ((Contrat__c in:setContId AND Contrat__c != NULL) OR (Opportunite__c in: setOppId AND Opportunite__c != NULL)) AND (Statut__c!=:Label.WS04_INACT) AND TypeRelation__c!='SIGN'];
        }

        return ecoList;

    }
}