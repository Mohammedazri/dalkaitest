public class AP01_DocumentContractuel {
    public static void setStatusFalse(List<Document_Contractuel__c> listDocs){
        for(Document_Contractuel__c doc : listDocs){
            doc.StatutSynchronisation__c = false;
        }
    }
}