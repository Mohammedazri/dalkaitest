/**
 * @author Jacques Akiki - Ei technologies
 * @date 15/03/2022
 * @description  Batch pour la MAJ du Budget de reference
 * @Test Class Batch122_UpdateBudgetContrat_test
 */
global class Batch122_UpdateBudgetContrat implements Database.Batchable<SObject>, Database.Stateful {
    global Boolean passOppFDS;
    global Batch122_UpdateBudgetContrat(boolean passBatch123){
        User usr = new User(id = userInfo.getUserId());
        usr.BypassValidationRules__c = true;
        usr.BypassDuplicateRules__c = true;
        usr.BypassFilters__c = true;
        usr.Bypass_Workflow__c = true;
        usr.Bypass_Triggers__c = 'AP09_Opportunity;AP45_Account;AP48_ContractCallouts;AP77_ContratFerme;AP85_Objectif;AP87_Objectif;AP90_Objectif;AP92_Objectif;AP96_Objectif';
        update usr;
        passOppFDS = passBatch123;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){

        BudgetCourant__c BudgetCourant = BudgetCourant__c.getValues('BudgetCourant');
        String AnneeBudget = BudgetCourant.Annee__c;
        String statutFER = Label.ContratFerme;
        String query = 'SELECT id FROM Contrat__c WHERE AnneeBudget__c !=:AnneeBudget and Statut__c!=:statutFER';

        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext bc, List<Contrat__c> listContrat){
        BudgetCourant__c BudgetCourant = BudgetCourant__c.getValues('BudgetCourant');
        String AnneeBudget = BudgetCourant.Annee__c;
        list<Contrat__c> listContUpdate = new list<Contrat__c>();
        Map<id, Budget__c> mapContBudget = new Map<id, Budget__c>();
        for(Contrat__c cont : listContrat) {
            mapContBudget.put(cont.Id, new Budget__c());
        }
        List<Budget__c> listBudgets = [SELECT Id, name, AnneeBudget__c, TotalCABudgetP1P2P3P4__c, TotalMBBudgetP1P2P3P4__c, NomContrat__c
                                       FROM Budget__c
                                       WHERE NomContrat__c IN :mapContBudget.keyset() and AnneeBudget__c =:AnneeBudget];

        for(Budget__c bdg : listBudgets) {
            mapContBudget.put(bdg.NomContrat__c, bdg);
        }

        for(id contId : mapContBudget.keyset()) {
            Contrat__c cont = new Contrat__c();
            cont.Id = contId;
            cont.BudgetReference__c = mapContBudget.get(contId).name;
            cont.TechTotalCABudgetP1P2P3P4__c = mapContBudget.get(contId).TotalCABudgetP1P2P3P4__c;
            cont.TechTotalMBBudgetP1P2P3P4__c = mapContBudget.get(contId).TotalMBBudgetP1P2P3P4__c;
            listContUpdate.add(cont);
        }
        if(listContUpdate != NULL && listContUpdate.size() > 0) {
            update listContUpdate;
        }

    }

    global void finish(Database.BatchableContext bc){
        if(passOppFDS) {
            id BatchId = Database.executeBatch(new Batch123_UpdateBudgetOppFDS());
        }
    }
}