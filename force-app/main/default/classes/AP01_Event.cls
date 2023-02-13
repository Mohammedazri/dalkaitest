/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: The aim of this class is to send a chatter notification to the partner's followers when adding the compte Rendu
Test Class: AP01_Event_test
History
<Date>      <Authors Name>   <Brief Description of Change>
05-07-2018    Johny Kassis      added the condition on line 77
--------------------------------------------------------------------------------------------------------------------------*/

public class AP01_Event {
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-technologies
Description: Check if the compte rendu is added to send a notification to the partner's followers
Inputs: list of the new events and map of the old event data
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    
    public static void partnerFollowersMembersNotification(list<event> listEvent, map<id,event> mapOldevent){
        list<id> listAccountIds = new list<id>(); 
        list<event> listEvents = new list<event>(); 
        list<id> listEventIds = new list<id>(); 
        for(event event : listEvent){     
            if(mapOldevent.get(event.id).compterendu__c != event.compteRendu__c && event.AccountId != null){
                listAccountIds.add(event.accountid);
                listEventIds.add(event.id);
            }}   
        
        listEvents = [select id, account.name,accountID,subject from event where id in :listEventIds];
        map<id,list<accountEventWrapper>> mapAccountEvent = new map<id, list<accountEventWrapper>>();
        for(event event :listEvents){
            accountEventWrapper accountEventWrapper = new accountEventWrapper();
            accountEventWrapper.accountName = event.account.name;
            accountEventWrapper.eventSubject = event.subject;
            accountEventWrapper.eventId = event.id;
            if(!mapAccountEvent.containsKey(event.AccountId)){
                mapAccountEvent.put(event.accountid, new list<accountEventWrapper>());}
            mapAccountEvent.get(event.accountid).add(accountEventWrapper);}   
        
        list<EntitySubscription> listpEntitySubscription = [SELECT Id,SubscriberId,ParentId FROM EntitySubscription where ParentId in :listAccountIds];
        
        for(EntitySubscription Entity: listpEntitySubscription){          
            if(mapAccountEvent.containsKey(Entity.ParentId)){
                list<accountEventWrapper> listAccountEventWrapper= mapAccountEvent.get(Entity.ParentId);
                for(accountEventWrapper accountEventWrapper :listAccountEventWrapper){
                    if(accountEventWrapper.listUserId==null){
                        accountEventWrapper.listUserId  = new list<id>();}
                    accountEventWrapper.listUserId.add(entity.SubscriberId);} 
                
                mapAccountEvent.put(Entity.ParentId,listAccountEventWrapper);}}
        AP01_Event.doPostChatterUsers(mapAccountEvent);
        
        
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-technologies
Description: Send chatter notification to the partner's followers
Inputs: map of each partner and the related followers
Returns: -
--------------------------------------------------------------------------------------------------------------------------*/
    public static void doPostChatterUsers(map<id,list<accountEventWrapper>> mapAccountEvent){
        list<FeedItem> listFeedItem = new  list<FeedItem> ();
        for(Id accountId : mapAccountEvent.keyset()){
            list<accountEventWrapper> listAccountEventWrapper = mapAccountEvent.get(accountId); 
            for(accountEventWrapper accountEventWrapper : listAccountEventWrapper){
                string messageBody = label.EventChatterMessage1+' '
                    +accountEventWrapper.eventSubject +' '+label.EventChatterMessage2 +' '+accountEventWrapper.accountName 
                    +' '+label.EventChatterMessage3+' '+'\n'+label.EventChatterMessage4
                    +'\n'+label.Event_Url+accountEventWrapper.eventId
                    +'\n'+label.EventChatterMessage5
                    +'\n'+label.Event_Url+accountId; 
                If(accountEventWrapper.listUserId!=null){
                    for(id user: accountEventWrapper.listUserId){
                        FeedItem post = new FeedItem();
                        post.ParentId =user;
                        post.Body = messageBody; 
                        listFeedItem.add(post);}}}}
        insert listFeedItem;}
    
    public class accountEventWrapper{
        public string accountName{get;set;}
        public string eventSubject{get;set;}
        public string eventId{get;set;}
        public list<id> listUserId{get;set;}}    
}