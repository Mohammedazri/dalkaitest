/** 
* @author: Alain Ghoussoub
* @date: 27/07/2020 
* @description:Interdire de mettre deux documents contractuels sur une meme opportunité d'evolution
* @Test: Class 
*/
public class AP88_DocUniqueEvolution {
    // static variable to prevent multiple execution of the function 
    public static boolean firstRun = true;
    /** 
* @author: Alain Ghoussoub
* @date: 27/07/2020  
* @description: Interdire de mettre deux documents contractuels sur une meme opportunité d'evolution
* @param listObjectifs: list d'opportunités
* @return: void
*/
    public static void docOppExitant(list<Document_Contractuel__c> listdoc){
        if(firstRun){
            //Id des opportunités rattachées aux documents contractuels
            Set<Id> oppIds = new Set<Id>();
            for(Document_Contractuel__c doc : listdoc){
                if(String.isNotBlank(doc.OpportuniteRattachee__c) && doc.NatureDocument__c == 'DOC05'){
                    oppIds.add(doc.OpportuniteRattachee__c);
                }
            }
            system.debug('oppIds ' + oppIds);
            Set<Id> oppExIds = new Set<Id>();
            //Opportunité d'évolution existantes ayant un document contractuel
            for(Document_Contractuel__c doc : [Select id,OpportuniteRattachee__c 
                                               From Document_Contractuel__c 
                                               where OpportuniteRattachee__c in :oppIds 
                                               and OpportuniteRattachee__r.type_pers__c = :Label.AP16_evolution
                                               and NatureDocument__c = 'DOC05']){
                                                   system.debug('doc' + doc.id);
                                                   oppExIds.add(doc.OpportuniteRattachee__c);
                                               }
            system.debug('oppExIds ' + oppExIds);
            //Ajouter d'erreur pour les opportunités d'évolution ayant déjà un document contarctuel
            for(Document_Contractuel__c doc : listdoc){
                if(oppExIds.contains(doc.OpportuniteRattachee__c)){
                    doc.addError(Label.AP88_ErrorMessage);
                }
            }
        }
        firstRun = false;
    }
}