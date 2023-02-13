/** 
* @author Jacques Akiki - Ei technologies
* @date 21/12/2020 
* @description MAJ du champ commentaire par les valeur du champ NPS avant de le vider 
* @Test Class Batch106_ContactNPS_test 100%
*/
global class Batch106_ContactNPS implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext bc)
    {
		String query = 'SELECT id, Description ,Supporteur__c FROM Contact where Supporteur__c!=NULL ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> listCont)
    {
      for (Contact cont : listCont)
      {
          cont.Description = (cont.Description==NULL?'':cont.Description+'\r\n')+Label.MAJ_commentaire_contact+ cont.Supporteur__c;
      }
        update listCont;
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}