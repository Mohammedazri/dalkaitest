/*--------------------------------------------------------------------------------------------------------------------------
Author: Jimmy Khalil
Company: EI-Technologies
Description: Class used to call the scheduler to link opportunities to objectif regional
Test Class:  
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public class AP102_Objectif {
    public static void callSchedulerRegional(List<Objectif__c> ObjectifList)
    {
        Map<String,String> mapRegionAnneIdObj = new Map<String,String>();
        Set<String> setRegion = new Set<String>();
        Set<String> setAnnee = new Set<String>();
        
        for(Objectif__c obj:ObjectifList){
            if(obj.ZZZ_Tech_Libelle_Region__c !=null){
                setRegion.add(obj.ZZZ_Tech_Libelle_Region__c);
            }
            if(obj.Annee__c !=null){
                setAnnee.add(obj.Annee__c);
            }
            if(obj.ZZZ_Tech_Libelle_Region__c !=null && obj.Annee__c !=null){
                mapRegionAnneIdObj.put(obj.ZZZ_Tech_Libelle_Region__c + '_' + obj.Annee__c,obj.Id);
            }
        }
        
        
        if(mapRegionAnneIdObj.size()>0){
            SCHD10_ObjectifRegional schd10 = new SCHD10_ObjectifRegional();
            schd10.mapRegionAnneIdObj = mapRegionAnneIdObj;
            schd10.setRegion = setRegion;
            schd10.setAnnee = setAnnee;
            
            String day = String.valueOf(Datetime.now().day());
            String month = String.valueOf(Datetime.now().month());
            String year = String.valueOf(Datetime.now().year()); 
            //run tonight at 11:30 pm
            String cron ='0 30 23 '+ day + ' ' + month + ' ? ' + year;
            String schdName = 'Set_Opp_Objectif_Regional_' + Datetime.now();
            
            System.schedule(schdName, cron, schd10);
            
        }
        
        
    }
}