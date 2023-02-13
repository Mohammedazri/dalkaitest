global class CustomIterableExample implements iterable<ContentDocumentLink>{
   global Iterator<ContentDocumentLink> Iterator(){
      return new CustomIterable();
   }
}