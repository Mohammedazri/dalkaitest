/** 
* @author Jacques Akiki 
* @date 04/08/2020 
* @description Batch qui decoche la case à coche Grand compte dalkia sur tous les comptes
* @Test Class Batch87_updateGrandCompte_Test 100%
*/
global class Batch87_updateGrandCompte implements Database.Batchable<SObject>,Database.stateful {
/** 
* @author Jacques Akiki
* @date 04/08/2020   
* @chercher les comptes concernés où la case Grand compte dalkia esrt cochée
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        string query='SELECT id,GrandCompteDalkia__c FROM Account WHERE GrandCompteDalkia__c=true';
        return Database.getQueryLocator(query); 
    }
    
/** 
* @author Jacques Akiki
* @date 04/08/2020  
* @Set the checkBox GrandCompteDalkia to false
* @param Database.BatchableContext and list of Account
* @return void
*/
    global void execute (Database.BatchableContext bc , List<Account> listAcc)
    {
        for(Account acc : listAcc)
        {
            acc.GrandCompteDalkia__c=false;
        }
        update listAcc;
    }
    
/*no action needed in finish*/
    global void finish(Database.BatchableContext bc)
    {
    }
}