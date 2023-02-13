/** 
* @author: Alain Ghoussoub
* @date: 27/10/2020 
* @description:MAJ Date prise effet du document contractuel ayant une opportunite d'avenant
* @Test: Class 
*/
public class AP93_DocumentDateEffet {
    /** 
* @author: Alain Ghoussoub
* @date: 27/10/2020  
* @description: MAJ Date prise effet du document contractuel ayant une opportunite d'avenant
* @param listObjectifs: list opp
* @return: void
*/
    //10/06/2022: Commented by Jimmy, Moved to Flow Flow_01_MAJ_Doc_Date_Prise_Effet
    /*
    public static void MAJDoc(list<Opportunity> listOpps){
        Set<Id> oppIds = new Set<Id>();
        for(opportunity opp : listOpps){
            oppIds.add(opp.id);
        }
        List<Document_Contractuel__c> listDoc = [SELECT id,OpportuniteRattachee__c,OpportuniteRattachee__r.closedate
                                                 FROM Document_Contractuel__c 
                                                 WHERE OpportuniteRattachee__c in :oppIds
                                                   AND NatureDocument__c = 'DOC05'];
        
        for(Document_Contractuel__c doc : listDoc){
            doc.DatePriseEffet__c = doc.OpportuniteRattachee__r.closedate;
        }
        if(listDoc != null && listDoc.size()>0){
            update listDoc;
        }
    }
    */
        /** 
* @author: Alain Ghoussoub
* @date: 27/10/2020  
* @description: MAJ tech field date prise effet
* @param listObjectifs: list opp
* @return: void
*/
    public static void MAJTechField(list<Opportunity> listOpps){
        for(Opportunity opp : listOpps){
            opp.TECH_DateEffetChanged__c = true;
        }
    }
}