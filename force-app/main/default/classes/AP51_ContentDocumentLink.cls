/**
 * @author: Rita Bejjani -EI Technologies
 * @date: 11/04/2019
 * @description: Class that checks for more than one ContentDocumentLink for the same Document_Contractuel__c custom object
 * @Test Class: AP51_ContentDocumentLink_Test
 * @Coverage: 100%
 */
public class AP51_ContentDocumentLink {

    /**
     * @author: Rita Bejjani -EI Technologies
     * @date: 11/04/2019
     * @description: The method displays an error when inserting a second ContentDocumentLink on a Document_Contractuel__c custom object.
     * @inputs: List<ContentDocumentLink>
     * @returns: -
     */
    public static void checkPreviousCDL (List<ContentDocumentLink> newCDL){
        Set<id> entityId = new Set<id>();

        for(ContentDocumentLink cdl : newCDL) {
            if(String.valueOf(cdl.LinkedEntityId.getsobjecttype()) == Label.AP51_DC) {
                entityId.add(cdl.LinkedEntityId);
            }
        }
        if(entityId<> null && entityId.size() > 0) {
            List<ContentDocumentLink> listCDL = [SELECT LinkedEntityId
                                                 FROM ContentDocumentLink
                                                 WHERE LinkedEntityId in :entityId];

            map<id, integer> mapEntityCDL =  new map<id, integer>();

            for(Id entID : entityId) {
                integer nbrCDL = 0;
                for(ContentDocumentLink cdl : listCDL) {
                    if(entID == cdl.LinkedEntityId) {
                        nbrCDL++;
                    }
                }
                mapEntityCDL.put(entID, nbrCDL);
            }

            for(ContentDocumentLink cdl : newCDL) {
                if(mapEntityCDL.containsKey(cdl.LinkedEntityId)) {
                    if(mapEntityCDL.get(cdl.LinkedEntityId) > 0) {
                        cdl.addError(Label.AP51_Error);
                    } else {

                        integer totalCDL = mapEntityCDL.get(cdl.LinkedEntityId) + 1;
                        mapEntityCDL.put(cdl.LinkedEntityId, totalCDL);
                    }
                }
            }

        }
    }

    /**
     * @author: Charbel Khoury Hanna -EIT Mena
     * @date: 21/01/2022
     * @description: Prevent uploading files on document contractuel bigger than 100MB or that contains a special character in the title
     * @inputs: List<ContentDocumentLink>
     * @returns: -
     */
    public static void checkFileConditions (List<ContentDocumentLink> newCDL){
        //US 754
        //US 864 Ajouter par Jimmy ne plus accepter les deux caractères spéciaux tiret cadratin et demi-cadratin
        List<String> specialChar = new List<String> {'#', '%', '&', '{', '}', '\\', '<', '>', '*', '?', '/', '$', '!', '\'', '"', ':', '@', '+', '|', '=', '`', ',', ';', '°', '–', '—'};
        //US 754

        Set<id> entityIds = new Set<id>();

        Map<id, ContentDocumentLink> mapCDL = new Map<id, ContentDocumentLink>();

        for(ContentDocumentLink cdl : newCDL) {
            if(String.valueOf(cdl.LinkedEntityId.getsobjecttype()) == Label.AP51_DC) {
                entityIds.add(cdl.LinkedEntityId);
                mapCDL.put(cdl.LinkedEntityId, cdl);
            }
        }

        if(entityIds.size() > 0) {
            List<ContentDocumentLink> listCDL = [SELECT LinkedEntityId, ContentDocument.ContentSize, ContentDocument.Title
                                                 FROM ContentDocumentLink
                                                 WHERE LinkedEntityId in :entityIds];

            for(ContentDocumentLink cdl : listCDL) {
                //convert file size from MB to Bytes *1048576
                if(Integer.valueOf(Label.AP51_FileSize) > 0 && cdl.ContentDocument.ContentSize > (Integer.valueOf(Label.AP51_FileSize) * 1048576) && mapCDL.containsKey(cdl.LinkedEntityId)) {
                    mapCDL.get(cdl.LinkedEntityId).addError('File too big');
                }

                //check if file contains special characters
                for(String str : specialChar) {
                    if(cdl.ContentDocument.Title.contains(str)) {
                        mapCDL.get(cdl.LinkedEntityId).addError(Label.AP51_SpecialChar);
                    }
                }
            }
        }
    }
}