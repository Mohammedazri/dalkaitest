/*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: 
Test Class: AP98_DocumentContractuel_Test(100%)
History
06/08/2021 Jimmy Khalil  Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP98_DocumentContractuel {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: Increment the field NumeroIncrementeDocumentGenere
Inputs: list of Document Contractuel on Before Insert
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void setNumeroIncrementeDocumentGenere (List<Document_Contractuel__c> listNewDocs){
        set<String> setContratIds = new set<String>();
        list<Document_Contractuel__c> listDocContRelated = new list<Document_Contractuel__c>();
        Map<String,Decimal> mapContratIdMaxNumber = new Map<String,Decimal>();
        
        //C360-80: do not include the doc contrat of nature "Contrat", "Acte d'engagement/ DPGF", "Lettre de résiliation"
        List<String> listNatureNotIncluded = Label.AP98_NaturesNonInclus.split(',');
        
        //get contrats Id
        for(Document_Contractuel__c doc : listNewDocs){
            if(doc.Contrat__c != null && !listNatureNotIncluded.contains(doc.NatureDocument__c) ){
                setContratIds.add(doc.Contrat__c);
            }
        }
        
        if(setContratIds.size()>0){
            //get doc contr related to same contrats
            //C360-80: do not include the doc contrat of nature "Contrat", "Acte d'engagement/ DPGF", "Lettre de résiliation"
            listDocContRelated = [Select Id,Contrat__c,NumeroIncrementeDocumentGenere__c 
                                  From Document_Contractuel__c
                                  Where Contrat__c in :setContratIds
                                  And NatureDocument__c not in :listNatureNotIncluded];
            if(listDocContRelated != null && listDocContRelated.size()>0){
                //map contrat with maximum number from related doc cont
                for(Document_Contractuel__c doc:listDocContRelated){
                    if(!mapContratIdMaxNumber.containsKey(doc.Contrat__c)){
                        mapContratIdMaxNumber.put(doc.Contrat__c,0);
                    }
                    if(doc.NumeroIncrementeDocumentGenere__c != null && mapContratIdMaxNumber.get(doc.Contrat__c) < doc.NumeroIncrementeDocumentGenere__c){
                        mapContratIdMaxNumber.put(doc.Contrat__c,doc.NumeroIncrementeDocumentGenere__c);
                    }
                }
            }
            for(Document_Contractuel__c doc : listNewDocs){
                if(!listNatureNotIncluded.contains(doc.NatureDocument__c)){
                    //check if this is the first doc on the contrat
                    if(!mapContratIdMaxNumber.containsKey(doc.Contrat__c)){
                        doc.NumeroIncrementeDocumentGenere__c = 1;
                    }else{
                        doc.NumeroIncrementeDocumentGenere__c = mapContratIdMaxNumber.get(doc.Contrat__c) + 1;
                    }
                    mapContratIdMaxNumber.put(doc.Contrat__c,doc.NumeroIncrementeDocumentGenere__c);
                }
             }
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EI-Technologies
Description: 
Inputs: list of Document Contractuel on Before Insert
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void interdireLettreResiliation (List<Document_Contractuel__c> listNewDocs){
        
        Set<id> contratIds = new Set<id>();
        
        for(Document_Contractuel__c doc : listNewDocs)
        {
            if(doc.NatureDocument__c == Label.LC51_LettreResiliation)
            {
                contratIds.add(doc.Contrat__c);   
            }
        }
        
        if(contratIds.size() > 0)
        {
            List<Document_Contractuel__c> lstDocs = [SELECT id
                                                       FROM Document_Contractuel__c
                                                      WHERE Contrat__c in :contratIds
                                                       AND NumeroPiece__c = '' 
                                                       AND NatureDocument__c NOT IN ('DOC07', 'DOC13', 'DOC20')];
            
            if(lstDocs.size() > 0)
            {
                listNewDocs[0].addError(Label.AP98_InterdireLettreResiliation);
            }
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EI-Technologies
Description: 
Inputs: list of Document Contractuel on Before Insert
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void interdireCreationDoc (List<Document_Contractuel__c> listNewDocs){
        
        Set<id> contratIds = new Set<id>();
        
        for(Document_Contractuel__c doc : listNewDocs)
        {
            contratIds.add(doc.Contrat__c);   
        }
        
        List<Document_Contractuel__c> lstDocs = [SELECT id
                                                   FROM Document_Contractuel__c
                                                  WHERE Contrat__c in :contratIds
                                                   AND NatureDocument__c =: Label.LC51_LettreResiliation];

        if(lstDocs.size() > 0 && (listNewDocs[0].NatureDocument__c != 'DOC07' && listNewDocs[0].NatureDocument__c != 'DOC13' && listNewDocs[0].NatureDocument__c != 'DOC20'))
        {
            listNewDocs[0].addError(Label.AP98_InterdireCreationDoc);
        }
        
    }
}