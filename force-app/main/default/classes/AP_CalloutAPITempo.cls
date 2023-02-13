public class AP_CalloutAPITempo {
    public static void handleList(List<Case> cases)
     {
        List<Id> codeEmplacement = new List<Id>();

 

     
       for(Case c : cases)
        {    
          codeEmplacement.add(c.Id);
        }

        String dateDemande = String.ValueOf(System.Now().format('yyyy-MM-dd\'T\'HH:mm:ss'));
        String typeDemande = 'incidentAlarme';
        List <Case> lstdemandes = [Select id, Status , Emplacement__r.DKCode_Emplacement__c from Case where Id in : codeEmplacement];
        //String site = demande.Emplacement__c != null ? demande.Emplacement__r.DKCode_Emplacement__c : null;
        //Id idDemande = demande.Id;

       system.debug('codeEmplacement :'+codeEmplacement);
       for (Case demande : lstdemandes) {
           if( System.isFuture() || System.isBatch() ){
             if (demande.Status == 'A traiter' || demande.Status == 'Partiellement réalisée') {  
               AP_TempoV2.sendCase_trigger(demande.Id, dateDemande, demande.Emplacement__r.DKCode_Emplacement__c, typeDemande);
              }
           }else{

             if (demande.Status == 'A traiter' || demande.Status== 'Partiellement réalisée' ) {  
               AP_TempoV2.sendCase_trigger(demande.Id, dateDemande, demande.Emplacement__r.DKCode_Emplacement__c, typeDemande);
             }  

         }      
       } 
     }
}