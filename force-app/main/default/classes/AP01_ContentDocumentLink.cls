/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: The aim of this class is to modify the value of revueOffre__c on opprtunity when a document is added, deleted or modified 
              and modifying the compte Rendu when a new file/note has been added to the event
Test Class: AP01_ContentDocumentLink_test
--------------------------------------------------------------------------------------------------------------------------*/

public class AP01_ContentDocumentLink {
    
    public static string revueOffre = label.Revue_Offre;
    
    public static void verificationRevueOffre(list<ContentDocumentLink> listContentDocumentLink){       
        list<id> listOpportunityId = new list<id>();
        set<id> setContentDocument = new set<id>();
        
        //Getting the documents inserted in order to get the ones that begin with Revue d'offre
        for(ContentDocumentLink content : listContentDocumentLink){
            setContentDocument.add(content.contentDocumentId);}
        
        map<id,ContentDocument> mapContentDocument = new map<id,ContentDocument>([select id,title 
                                                                                  from ContentDocument
                                                                                  where id in :setContentDocument]);
        //Getting the opportunities that should be updated
        for(ContentDocumentLink content : listContentDocumentLink){
            if(mapContentDocument.get(content.ContentDocumentId).title.length()>=revueOffre.length()){
                if(content.ShareType == 'V' && mapContentDocument.get(content.ContentDocumentId).title.substring(0,revueOffre.length())  == revueOffre){
                    listOpportunityId.add(content.LinkedEntityId);}}}
        
        //Updating the revue d'offre of the opportunities to true
        if(listOpportunityId.size()>0){
            list<Opportunity> listOpportunity = [select id, name ,revueOffre__c from opportunity where id in :listOpportunityId];
            
            for(Opportunity opp :listOpportunity){
                opp.revueOffre__c = true;}
            try{
                  update listOpportunity;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
               }  
       
        }         
    }
    
    public static void verificationRevueOffreDelete(list<ContentDocument> listOldContentDocument){        
        set<id> setContentDocumentId = new set<id>();
        set<id> setOpportunityId = new set<id>();
        set<id> setOpportunityIdwithRevue = new set<id>();
        list<ContentDocumentLink> listContentDocumentLinkOpp = new list<ContentDocumentLink>();
        
        //Getting the deleted documents that begin with revue d'offre
        for(ContentDocument content : listOldContentDocument){            
            if(content.title.length() >= revueOffre.length() && content.title.substring(0,revueOffre.length())  == revueOffre) {
                setContentDocumentId.add(content.id);}}
        
        //Getting the documentLinks related to the deleted documents
        if(setContentDocumentId.size()>0){
            map<id,ContentDocumentLink> mapContentDocumentLink = new map<id,ContentDocumentLink>([select id,LinkedEntityId,ShareType ,ContentDocument.title
                                                                                                  from ContentDocumentLink 
                                                                                                  where ContentDocumentId in :setContentDocumentId]);
            
            for(ContentDocumentLink content : mapContentDocumentLink.values()){
                setOpportunityId.add(content.LinkedEntityId);}
            
            //Getting all the document links related to the entities
            listContentDocumentLinkOpp = [select id,LinkedEntityId,ShareType ,ContentDocument.title
                                          from ContentDocumentLink 
                                          where LinkedEntityId in :setOpportunityId];            
            
            //Checking the opportunities that shouldn't be updated to false
            for(ContentDocumentLink content : listContentDocumentLinkOpp){
                if(content.contentdocument.title.length()>=revueOffre.length()){
                    if(!mapContentDocumentLink.containsKey(content.Id) && content.contentdocument.title.substring(0,revueOffre.length())  == revueOffre && content.sharetype == 'V'){
                        setOpportunityIdwithRevue.add(content.LinkedEntityId);}}}   
            
            //Updating the revue d'offre of the opportunities to false
            list<Opportunity> listOpportunitywithoutRevue=[select id, name ,revueOffre__c 
                                                           from opportunity 
                                                           where id not in :setOpportunityIdwithRevue
                                                           and id in :setOpportunityId];
            
            for(Opportunity opp : listOpportunitywithoutRevue){
                opp.revueOffre__c = false;}
            try{
                 update listOpportunitywithoutRevue;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
               }             
           }  
    } 
    
    public static void verificationRevueOffreUpdate(list<ContentDocument> listContentDocument,map<id,ContentDocument> mapOldContentDocument){        
        set<id> setContentDocumentId = new set<id>();
        set<id> setOpportunityId = new set<id>();
        set<id> setOpportunityIdwithRevue = new set<id>();
        list<ContentDocumentLink> listContentDocumentLinkOpp = new list<ContentDocumentLink>();
        
        //Getting the changed documents from or to revue d'offre
        for(ContentDocument content : listContentDocument){            
            if(mapOldContentDocument.get(content.id).title != content.title
               && ((mapOldContentDocument.get(content.id).title.length()>=revueOffre.length() && mapOldContentDocument.get(content.id).title.substring(0,revueOffre.length())  == revueOffre) 
                   || (content.title.length()>=revueOffre.length() && content.title.substring(0,revueOffre.length())  == revueOffre))) {
                       setContentDocumentId.add(content.id);}}
        
        //Getting the documentLinks related to the updated documents
        if(setContentDocumentId.size()>0){
            map<id,ContentDocumentLink> mapContentDocumentLink = new map<id,ContentDocumentLink>([select id,LinkedEntityId,ShareType ,ContentDocument.title
                                                                                                  from ContentDocumentLink 
                                                                                                  where ContentDocumentId in :setContentDocumentId]);
            
            for(ContentDocumentLink content : mapContentDocumentLink.values()){
                setOpportunityId.add(content.LinkedEntityId);}
            
            //Getting all the document links related to the entities
            listContentDocumentLinkOpp = [select id,LinkedEntityId,ShareType ,ContentDocument.title
                                          from ContentDocumentLink 
                                          where LinkedEntityId in :setOpportunityId];            
            
            //Getting the opportunities that should be updated to true
            for(ContentDocumentLink content : listContentDocumentLinkOpp){
                if(content.contentdocument.title.length()>=revueOffre.length()){
                    if(content.contentdocument.title.substring(0,revueOffre.length())  == revueOffre && content.sharetype == 'V'){
                        setOpportunityIdwithRevue.add(content.LinkedEntityId);}}}   
            
            //Getting the opportunities that should be updated to false
            list<Opportunity> listOpportunitywithoutRevue=[select id, name ,revueOffre__c 
                                                           from opportunity 
                                                           where id not in :setOpportunityIdwithRevue
                                                           and id in :setOpportunityId];
            
            //Getting the opportunities that should be updated to true
            list<Opportunity> listOpportunitywithRevue=[select id, name ,revueOffre__c 
                                                        from opportunity 
                                                        where id in :setOpportunityIdwithRevue];
            
            list<Opportunity> listOpportunityToUpdate = new list<Opportunity>();
            
            for(Opportunity opp : listOpportunitywithoutRevue){
                opp.revueOffre__c = false;
                listOpportunityToUpdate.add(opp);}
            
            for(Opportunity opp : listOpportunitywithRevue){
                opp.revueOffre__c = true;
                listOpportunityToUpdate.add(opp);}
             try{
                 update listOpportunityToUpdate;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
               }            
           }  
    } 
    
    public static void modificationCompteRendu(list<ContentDocumentLink> listContentDocumentLink){       
        set<id> setEventId = new set<id>();
        list<event> listEvents = new list<event>();
        
        //Getting the events that should be updated
        for(ContentDocumentLink content : listContentDocumentLink){ 
            setEventId.add(content.LinkedEntityId);}
        
        if(setEventId.size()>0){
            listEvents = [select id, subject ,compterendu__c from event where id in :setEventId and ischild=false]; 
        }
        
        //Updating the compte rendu of the events
        if(listEvents.size()>0){            
            for(Event eve :listEvents){
                if(eve.compterendu__c == null || eve.compterendu__c==''){
                    eve.compterendu__c = label.compteRenduMessage;} }  
       
            try{
                update listEvents;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
               }
        }
    }
    
    public static void modificationCompteRenduDelete(list<ContentDocument> listOldContentDocument){        
        set<id> setContentDocumentId = new set<id>();
        set<id> setEventId = new set<id>();
        list<ContentDocumentLink> listContentDocumentLinkEvent = new list<ContentDocumentLink>();
        
        //Getting the deleted documents
        for(ContentDocument content : listOldContentDocument){            
            setContentDocumentId.add(content.id);}
        
        //Getting the documentLinks related to the deleted documents
        if(setContentDocumentId.size()>0){
            map<id,ContentDocumentLink> mapContentDocumentLink = new map<id,ContentDocumentLink>([select id,LinkedEntityId,ShareType ,ContentDocument.title
                                                                                                  from ContentDocumentLink 
                                                                                                  where ContentDocumentId in :setContentDocumentId]);
            for(ContentDocumentLink content : mapContentDocumentLink.values()){
                if(mapContentDocumentLink.get(content.Id).ShareType == 'V'){
                    setEventId.add(content.LinkedEntityId);}}
            
            //Getting all the document links related to the entities
            listContentDocumentLinkEvent = [select id,LinkedEntityId,ShareType ,ContentDocument.title
                                            from ContentDocumentLink 
                                            where LinkedEntityId in :setEventId];
            
            map<id,list<ContentDocumentLink>> mapEventContentDocumentLink = new map<id,list<ContentDocumentLink>>();
            
            //Checking if the events have linked documents
            for(ContentDocumentLink content : listContentDocumentLinkEvent){
                if(!mapEventContentDocumentLink.containsKey(content.LinkedEntityId)){
                    mapEventContentDocumentLink.put(content.LinkedEntityId, new list<ContentDocumentLink>());}
                
                if(!mapContentDocumentLink.containsKey(content.Id)){
                    mapEventContentDocumentLink.get(content.LinkedEntityId).add(content);  
                }}   
            
            set<id> setEventIds = new set<id>();
            for(id id : mapEventContentDocumentLink.keySet()){
                list<ContentDocumentLink> listContentDocumentLink = mapEventContentDocumentLink.get(id);
                if(listContentDocumentLink.size()==0){
                    seteventIds.add(id);  
                }}
            
            list<event> listeventToUpdate = [select id,compterendu__c from event where id in :seteventIds and ischild=false];
            for(event event : listeventToUpdate){
                event.compterendu__c = '';
            }
             try{
                update listeventToUpdate;}
            catch(exception e){
                System.debug('#### exception  ' + e );  
               }
            }    
    } 
}