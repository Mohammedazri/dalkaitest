/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Alain Ghoussoub
Company: EI-Technologies
Description: Apex controller for the lightning component LC80_DateEffetDocument
Test Class: LC80_DateEffetDocument_TEST
-------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC80_DateEffetDocument_Controller {
    /** 
* @author Alain Ghoussoub
* @date 27/10/2020 
* @description retoune un string qui specifie si on montre la pop up selon le type de l'opportunite
* @param ID
* @return String
*/
    @AuraEnabled
    public static String getCurrentObject(Id OppId){
        Boolean condition1 = false;
        Boolean condition2 = false;
        List<Opportunity> myOpp=[SELECT id,Type_pers__c,TECH_DateEffetChanged__c
                                 FROM Opportunity
                                 Where id=:OppId
                                 LIMIT 1];
        if(myOpp != null && myOpp.size()>0){
            if(myOpp[0].Type_pers__c == Label.LC78_Evolution && myOpp[0].TECH_DateEffetChanged__c == true){
                condition1 = true;
            }
        }
        
        List<Document_Contractuel__c> docList = [SELECT id
                                                 FROM Document_Contractuel__c
                                                 WHERE OpportuniteRattachee__c = :OppId
                                                   AND NatureDocument__c = 'DOC05'];
        
        if(docList != null && docList.size()>0){
            condition2 = true;
        }
        
        if(condition1 && condition2){
            return 'show';
        }
        else{
            return '';
        }
    }
        /** 
* @author Alain Ghoussoub
* @date 27/10/2020 
* @description retoune un string qui specifie si on montre la pop up selon le type de l'opportunite
* @param ID
* @return String
*/
    @AuraEnabled
    public static void updateOpp(Id OppId){
        List<Opportunity> myOpp=[SELECT id,TECH_DateEffetChanged__c 
                                 FROM Opportunity
                                 Where id=:OppId
                                 LIMIT 1];
        if(myOpp != null && myOpp.size()>0){
            myOpp[0].TECH_DateEffetChanged__c = false;
            try{
                update myOpp[0];
            }
            catch(Exception e){
                system.debug('Error ' + e);
            }
        }
    }
}