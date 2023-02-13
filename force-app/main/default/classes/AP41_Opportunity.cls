/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Chadi Geara
Company: EI-Technologies
Description: Responsable for trimming a new opportunity name size up to 80 character, only opp that have a type of Nouveau
Test Class: AP41_Opportunity_test
-------------------------------------------------------------------------------------------------------------------------------------*/

public class AP41_Opportunity {
    
    
    public static void trimNameOpp( List<Opportunity> lstOpp,  Map<Id,Opportunity> MapOppOld ){     
        
        for ( Opportunity opp : lstOpp ){
            if( opp.Type_pers__c == 'Nouveau'){
                
                // beforeInsert
                if(MapOppOld==null){
                    if(opp.name.length() > 80){
                        opp.name = opp.name.substring(0,80);
                    }
                    // beforeUpdate
                } else {  
                    if(opp.name.length() > 80 && opp.name != MapOppOld.get(opp.Id).name){
                        opp.name = opp.name.substring(0,80);
                    }                              
                } 
                
                
            }       
        }     
    }
    

}