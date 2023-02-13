/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EIT Mena
Description: S’assurer qu’il n'est pas possible de rattacher plusieurs documents de nature Avenant, Resiliation ou FDS à la même opportunité rattachée
Test Class: AP111_DocumentContractuelUnicity_Test
History
05/25/2022 Charbel Khoury Hanna  Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP111_DocumentContractuelUnicity {
    
    public static void checkNatureOpportunityCombination (List<Document_Contractuel__c> listNewDocs)
    {
        
        Schema.DescribeFieldResult fieldResult = Document_Contractuel__c.NatureDocument__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        
        Map<String,String> MapValueLabel = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            MapValueLabel.put(v.getValue(),v.getLabel());        
        }
        
        Map<Document_Contractuel__c, String> mapNewCombinations = new Map<Document_Contractuel__c, String>();
        Set<Id> contratsIds = new Set<Id>();
        
        for(Document_Contractuel__c doc : listNewDocs)
        {
            if(doc.NatureDocument__c == 'DOC05' || doc.NatureDocument__c == 'DOC11' || doc.NatureDocument__c == 'DOC20')
            {
                mapNewCombinations.put(doc, doc.Contrat__c + '-' + doc.NatureDocument__c + '-' + doc.OpportuniteRattachee__c);
                contratsIds.add(doc.Contrat__c);
            }
        }
        
        List<Document_Contractuel__c> lstOldDocs = new List<Document_Contractuel__c>();
        
        if(Trigger.isInsert)
        {
            lstOldDocs = [SELECT id, Contrat__c, NatureDocument__c, OpportuniteRattachee__c
                          FROM Document_Contractuel__c
                          WHERE Contrat__c in :contratsIds];    
        }
        
        if(Trigger.isUpdate)
        {
            Set<Id> docIds = new Set<Id>();
            
            for(Document_Contractuel__c doc : listNewDocs)
            {
                docIds.add(doc.Id);
            }
            
            lstOldDocs = [SELECT id, Contrat__c, NatureDocument__c, OpportuniteRattachee__c
                          FROM Document_Contractuel__c
                          WHERE Contrat__c in :contratsIds
                          AND id not in :docIds];    
        }
        
        List<String> lstAllCombinations = new List<String>();
        
        for(Document_Contractuel__c doc : lstOldDocs)
        {
            lstAllCombinations.add(doc.Contrat__c + '-' + doc.NatureDocument__c + '-' + doc.OpportuniteRattachee__c);
        }
        
        for(Document_Contractuel__c doc : mapNewCombinations.keySet())
        {
            if(lstAllCombinations.contains(mapNewCombinations.get(doc)))
            {
                doc.addError(Label.AP111_ErrorMsg + ' ' + MapValueLabel.get(doc.NatureDocument__c));
            }
        }
    }
    
}