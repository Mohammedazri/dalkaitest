global class CustomIterable 
   implements Iterator<ContentDocumentLink>{ 

   List<ContentDocumentLink> cdls {get; set;} 
   Integer i {get; set;} 

   public CustomIterable(){ 
       cdls =  [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM Document_Contractuel__c)]; 
       i = 0; 
   }   

   global boolean hasNext(){ 
       if(i >= cdls.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global ContentDocumentLink next(){ 
       // 8 is an arbitrary 
       // constant in this example
       // that represents the 
       // maximum size of the list.
       if(i == cdls.size()){return null;} 
       i++; 
       return cdls[i-1]; 
   } 
}