/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: This class is used to push notifications to the user when he is asked for approval.
* @Test Class: LC48_SoumettreApprob_Cont_test  
* @Coverage: 100%
*/
public class ChatterNotification {
/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: Posts Approval request on chatter and sends notification to the approver.   
* @inputs: id, String , String, list<id>
* @returns: ConnectApi.FeedItemInput 
*/  
    public static ConnectApi.FeedItemInput createChatterFeedItem(id subjectobjectID , String linkobject , String MessageBody, list<id> listUsers)
    {          
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        
        //To add a link preview to the feed
        if(linkobject != null){
            ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
            linkInput.url = linkobject;
            feedElementCapabilitiesInput.link = linkInput;
        }
        
        input.capabilities = feedElementCapabilitiesInput;
        textSegment.text = MessageBody;
        
        //The users to be mentioned
        if (listUsers != null && listUsers.size()>0){
            for (id user : listUsers){
                ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
                mentionSegment.id = user;                
                body.messageSegments.add(mentionSegment);
            }
        }
        body.messageSegments.add(textSegment);
        input.body = body;         
        input.subjectId = subjectobjectID; //The related object
        return input;    
    }
    
}