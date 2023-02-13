/*--------------------------------------------------------------------------------------------------------------------------
Author: Charbel Khoury Hanna
Company: EIT Mena
Description: RDD des scans pour Kador
Test Class: AP118_ScanRdd_Test
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class AP118_ScanRdd {
    
    public static void ModifierDocumentContractuel(Set<String> docIds)
    {
        List<Document_Contractuel__c> listDocs = [SELECT id
                                                  FROM Document_Contractuel__c 
                                                  WHERE id in :docIds];
        
        integer filsSize = listDocs.size();
        integer MaxSize = integer.valueof(Label.AP118_Batchsize);
        integer Times = 0;
        if(math.mod(filsSize, MaxSize)!=0)
        {
            Times = (filsSize/MaxSize) + 1;
        }
        else 
        {
            Times = (filsSize/MaxSize);
        }
        for(integer i=0;i<Times; i++){
            dateTime dt = DateTime.now();
            list<Document_Contractuel__c> listDocToUpdate= new list<Document_Contractuel__c>();
            if(math.mod(filsSize, MaxSize)==0){
                for(integer j=MaxSize*i;j<MaxSize*(i+1);j++){
                    listDocToUpdate.add(listDocs[j]);
                }
            }
            else{
                if(i!=Times-1){
                    for(integer j=MaxSize*i;j<MaxSize*(i+1);j++){
                        listDocToUpdate.add(listDocs[j]);
                    }
                }
                else{
                    for(integer j=(MaxSize*i);j<((MaxSize*i)+math.mod(filsSize, MaxSize));j++){
                        listDocToUpdate.add(listDocs[j]);
                    }
                }
                
            }
            SCHD14_ModifierDocument.scheduleMe(GenerateCronExpression(dt,i+1),listDocToUpdate,'MAJ-Documents_Contractuels'+i+dt);                
        }
    }
    
    
    /*Method to generate 1 minute seperated Cron Expressions to schedule by batches of 3 callouts*/ 
    public static String GenerateCronExpression(DateTime dt , integer min) {
        dt = dt.addMinutes(min);
        String CrExp ;
        CrExp = '0 '+(dt.minute())+' '+(dt.hour())+' '+(dt.day())+' '+(dt.month())+' '+' ? '+(dt.year()); 
        
        return CrExp;
    }
}