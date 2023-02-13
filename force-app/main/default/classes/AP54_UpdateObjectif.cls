/**
* @author: Rita Bejjani -EI Technologies
* @date: 24/04/2019
* @description: Update the lookup field ObjectifAgenceId__c on Objectif__c 
* @Test Class: AP54_UpdateObjectif_Test 
* @Coverage: 89%
*/
public class AP54_UpdateObjectif {
    
    /**
* @author: Rita Bejjani -EI Technologies
* @date: 24/04/2019
* @description:  The method updates the lookup field ObjectifAgenceId__c on Objectif__c and create new ObjectifAgence__c for records that dont have one.
* @inputs: List<Objectif__c>
* @returns: - 
*/   
    public static void AddObjAgcID(List<Objectif__c> listNewObj , Map<id,Objectif__c> mapOld){
        List<Objectif__c> listObjUpdted = new List<Objectif__c>();
        /*insert case*/
        if(mapOld==null)
        {
            listObjUpdted = listNewObj;
        }
        /*update case*/
        else
        {
            for (Objectif__c obj:listNewObj)
            {
                if(obj.annee__c !=mapOld.get(obj.id).annee__c
                   || obj.tech_UpdateCommercial__c !=mapOld.get(obj.id).tech_UpdateCommercial__c
                   || obj.commercial__c !=mapOld.get(obj.id).commercial__c)
                {
                    listObjUpdted.add(obj);
                }
            } 
        }
        
        if(listObjUpdted!=NULL && listObjUpdted.size()>0)
        {
            List<Agence__c> listAgc = [select id,name,DkCode__c from Agence__c];
            List<ObjectifAgence__c> listObjAgc = [select id,tech_AgenceAnnee__c,AgenceId__r.name,AgenceId__r.DkCode__c,Annee__c from ObjectifAgence__c];
            list<Objectif__c> listObj = new list<Objectif__c>();
            list<ObjectifAgence__c> listObjAgcToInsert = new list<ObjectifAgence__c>();
            
            map<id,List<Objectif__c>> mapObjToObjAgc = new map<id,List<Objectif__c>>(); // to add for each ObjectifAgence__c id the corresponding list of Objectif__c
            
            for(Objectif__c obj :listObjUpdted)
            {
                boolean found = false; // to evaluate if the objectif record has an objectifAgence or not in order to add it to a list to create objectifAgence later 
                if(listObjAgc.size() != 0){
                    for(ObjectifAgence__c objAgc: listObjAgc)
                    {
                        if(obj.DkCodeAgenceCommercial__c == objAgc.AgenceId__r.DkCode__c && obj.Annee__c == objAgc.Annee__c)// checking the agence__c dkcode and the year
                        {
                            if (mapObjToObjAgc.containsKey(objAgc.id))
                            {  
                                mapObjToObjAgc.get(objAgc.id).add(obj); // add the objectif__c to the list alraedy created for that objectifAgence objAgc
                                
                            }
                            else
                            {
                                List<Objectif__c> listObjectif = new List<Objectif__c>(); // create a new list of object to add it to the map
                                listObjectif.add(obj);
                                mapObjToObjAgc.put(objAgc.id,listObjectif);  
                            }
                            found = true;
                        }
                    }
                    if(!found)
                    {
                        listObj.add(obj);// add the objectif__c to the list of objectif that dont have an objectifAgence record
                    }
                }else
                {
                    listObj = listObjUpdted;// if the list of objectifAgence__c is empty, all objectif__c are added to the list
                    break;
                }
            }
            
            
            for(Objectif__c obj : listObj)
            {
                for(Agence__c agc :listAgc)
                {
                    if(obj.DkCodeAgenceCommercial__c == agc.DkCode__c) //searching for the agence that have the same dkcode of the objectif to create objectifAgence
                    {
                        ObjectifAgence__c objAgc = new ObjectifAgence__c();
                        objAgc.AgenceId__c = agc.id;
                        objAgc.name = obj.Annee__c;
                        objAgc.Annee__c = obj.Annee__c;
                        objAgc.tech_AgenceAnnee__c = agc.id+obj.Annee__c;
                        listObjAgcToInsert.add(objAgc);
                    }
                }
            }
            
            try{
                insert listObjAgcToInsert;
            }
            catch(exception e){
                System.debug('#### exception  ' + e );  
            } 
            
            for(Integer i=0;i<listObjAgcToInsert.size();i++)
            {
                //add the new inserted objectifAgence with the related objectif to the map
                if (mapObjToObjAgc.containsKey(listObjAgcToInsert[i].id))
                {  
                    mapObjToObjAgc.get(listObjAgcToInsert[i].id).add(listObj[i]);
                    
                }
                else
                {
                    List<Objectif__c> listObjectif = new List<Objectif__c>();
                    listObjectif.add(listObj[i]);
                    mapObjToObjAgc.put(listObjAgcToInsert[i].id,listObjectif);  
                }
            }
            
            for(Id objAgId :mapObjToObjAgc.keyset())
            {
                for(Objectif__c obj:mapObjToObjAgc.get(objAgId))
                {
                    obj.ObjectifAgenceId__c = objAgId; // update the the lookup field on objectif with the corresponding objectifAgence id
                }
            }
        }
    }
}