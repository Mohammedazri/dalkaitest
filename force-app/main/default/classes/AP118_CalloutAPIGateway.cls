public class AP118_CalloutAPIGateway{
    
     public static void handleList(List<Case> cases)
     {
        List<Id> codeEmplacement = new List<Id>();

     
       for(Case c : cases)
        {    
          codeEmplacement.add(c.Id);
        }

        List <Case> lstdemandes = [Select id, Status , Emplacement__r.DKCode_Emplacement__c from Case where Id in : codeEmplacement];

       system.debug('codeEmplacement :'+codeEmplacement);
       for (Case demande : lstdemandes) {
           /*if( System.isFuture() || System.isBatch() ){
             if (demande.Status == 'A traiter' || demande.Status == 'En cours de traitement' || demande.Status == 'Attribuée' || demande.Status == 'Partiellement réalisée') {  
               AP118_ConnecteurDACRC.sendCase(demande.id, demande.Emplacement__r.DKCode_Emplacement__c);
               AP118_ConnecteurDACRC.sendOrdreTravail(demande.id);
              }

             else if (demande.Status == 'Clôturée') {
               AP118_ConnecteurDACRC.sendCase(demande.id, demande.Emplacement__r.DKCode_Emplacement__c);
              }     
           }
           */
          // else{
          // Mode Trigger Si probleme decommenter ligne 17 a ligne 28
             if (demande.Status == 'A traiter' || demande.Status == 'En cours de traitement' || demande.Status == 'Attribuée' || demande.Status == 'Partiellement réalisée') {  
               AP118_ConnecteurDACRC.sendCase_trigger(demande.id, demande.Emplacement__r.DKCode_Emplacement__c);
               AP118_ConnecteurDACRC.sendOrdreTravail_trigger(demande.id);
             }  

             else if (demande.Status == 'Clôturée') {
               AP118_ConnecteurDACRC.sendCase_trigger(demande.id, demande.Emplacement__r.DKCode_Emplacement__c);
              }     
         //}      
       } 
     }
  }