/**
* @author Jacques Akiki -EI Technologies
* @date 16/05/2019
* @description To fill the field Date_derniere_soumission__c on fiche_de_synthese__c
* @Test Class: Batch47_DateSoumissionApp_test
* @Coverage: 90%
*/
global class Batch47_DateSoumissionApp implements Database.Batchable<SObject>,Database.stateful
{
    global Map<Id,DateTime> mapIdfdsDate = new Map<id,DateTime>();
    global String limt = '';
    global Batch47_DateSoumissionApp (String lim)
    {
      if (lim<>null && lim<>'')// parameter used to avoid CPU limits
      {
          limt = lim;
      }
    }

 global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id,CreatedDate,Date_de_soumission__c,tech_FicheDeSynthese__c FROM Approbation__c' +
                       ' WHERE tech_FicheDeSynthese__r.Date_derniere_soumission__c = NULL AND tech_FicheDeSynthese__c<> NULL ' ;
        if (limt<>'')
        {
          query = query + limt; 
        }
           
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Approbation__c> listApprobation)
    {
        for(Approbation__c app :listApprobation)
        {
            if(mapIdfdsDate.containsKey(app.tech_FicheDeSynthese__c) && app.Date_de_soumission__c<>NULL)
            {
              if(mapIdfdsDate.get(app.tech_FicheDeSynthese__c)<app.Date_de_soumission__c) // compare to the latest date 
              {
                mapIdfdsDate.put(app.tech_FicheDeSynthese__c,app.Date_de_soumission__c);  
              }
            }
            else
            {
               mapIdfdsDate.put(app.tech_FicheDeSynthese__c,app.Date_de_soumission__c); // add to map
            }
        }
    }
     global void finish(Database.BatchableContext bc)
     {
         List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>(); // new list of fiche de synthese 
         
         for(Id fdsId : mapIdfdsDate.keyset())
         {
             Fiche_de_synthese__c fds = new Fiche_de_synthese__c();
             fds.id = fdsId; // set fds id to the related fiche de synthese
             fds.Date_derniere_soumission__c =mapIdfdsDate.get(fdsId); // change the field Date_derniere_soumission__c to the latest
             listFDS.add(fds); // add fds to list
         }
         if(listFDS<>null && listFDS.size()>0)
         {
             update listFDS; // update list
         }
     }
}