/**
*@author Charbel Khoury Hanna
*@date 07/07/2021
*@description MAJ du IdScan__c sur le document contractuel avec la valeur de l'id du scan
*@test class: AP100_IdScan_Test
*/
public class AP100_IdScan {

    public static void updateIdScan(list<ContentDocumentLink> listContentDocumentLink){
        
        Map<id,ContentDocumentLink> mapScanDocCont = new Map<id,ContentDocumentLink>();
        Map<id,ContentDocumentLink> mapScanInfo = new Map<id,ContentDocumentLink>();
        
        for(ContentDocumentLink cdl : listContentDocumentLink)
        {
            mapScanDocCont.put(cdl.LinkedEntityId, cdl);
        }
        
        List<ContentDocumentLink> lstDocLink = [SELECT id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension, LinkedEntityId
                                               	  FROM ContentDocumentLink
                                                 WHERE LinkedEntityId in :mapScanDocCont.keySet()];
        
		List<Document_Contractuel__c> lstDoc = [SELECT id, Id_Scan__c, TitreScan__c
                                               	  FROM Document_Contractuel__c
                                                 WHERE id in :mapScanDocCont.keySet()];
        
        for(ContentDocumentLink cdl : lstDocLink)
        {
            mapScanInfo.put(cdl.LinkedEntityId, cdl);
        }
        
        for(Document_Contractuel__c doc : lstDoc)
        {
            if(mapScanInfo.containsKey(doc.Id))
            {
             	doc.Id_Scan__c = mapScanInfo.get(doc.Id).ContentDocumentId;
                if(mapScanInfo.get(doc.Id).ContentDocument.FileExtension != null)
                {
                 	doc.TitreScan__c = mapScanInfo.get(doc.Id).ContentDocument.Title + '.' + mapScanInfo.get(doc.Id).ContentDocument.FileExtension;   
                }
            }
        }

        update lstDoc;
    }
    
    public static void deleteContentDocument(map<id,ContentDocument> mapOldContentDocument){
        
        set<id> setContentDocIds =  mapOldContentDocument.keyset();
        
        List<ContentDocumentLink> lstContentDocLink = [SELECT id, LinkedEntityId, ContentDocumentId
                                               	         FROM ContentDocumentLink
                                                        WHERE ContentDocumentId in :setContentDocIds];
        
        Map<id,ContentDocument> mapScanDocCont = new Map<id,ContentDocument>();
        
        for(ContentDocumentLink link : lstContentDocLink)
        {
            mapScanDocCont.put(link.LinkedEntityId, mapOldContentDocument.get(link.ContentDocumentId));
        }
        
        List<Document_Contractuel__c> lstDoc = [SELECT id, Id_Scan__c, NumeroPiece__c, TitreScan__c
                                               	  FROM Document_Contractuel__c
                                                 WHERE id in :mapScanDocCont.keySet()];
        
        for(Document_Contractuel__c doc : lstDoc)
        {
            if(doc.NumeroPiece__c != null && mapScanDocCont.containsKey(doc.Id))
            {
                mapScanDocCont.get(doc.Id).addError(Label.AP100_DeleteScan);
            }
            else
            {
                doc.Id_Scan__c = '';
                doc.TitreScan__c = '';
            }
        }
        system.debug('*** lstDoc = '+lstDoc);
        if(lstDoc.size() > 0)
        {
         	update lstDoc;   
        }
    }
}