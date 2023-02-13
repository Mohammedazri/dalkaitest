/** 
* @author Charbel Khoury Hanna - EIT Mena
* @date 08/11/2022
* @description schedular qui va lancer appel ModifierDocument
* @Test Class AP118_ScanRdd_Test
*/
global class SCHD14_ModifierDocument implements Schedulable{
    public List<Document_Contractuel__c> ListDocs;
    
    /** 
* @author Jacques Akiki  
* @date 06/04/2021
* @fonction appelée depuis AP40
* @param Cron expression pour le temps 
* @return void
*/
    global static String scheduleMe(String sched, List<Document_Contractuel__c> listDocuments , String NameSCH) 
    {
        SCHD14_ModifierDocument SC = new  SCHD14_ModifierDocument();
        SC.ListDocs = listDocuments ;
        return System.schedule(NameSCH, sched, SC);
    }
    
    /** 
* @author Jacques Akiki  
* @date 04/04/2022
* @fonction Lancer appels ModifierContrat2 
* @param schedular du type SCHD12_updateContratsFils
* @return void
*/
    global void execute(SchedulableContext sc) 
    {    
        for(Document_Contractuel__c doc :ListDocs)
        {
            String contratSerial = Json.serialize(new list<Document_Contractuel__c>{doc});
            AP102_UpdateCommentaireDocCont.updateCommentaire(contratSerial);
        }
    }
}