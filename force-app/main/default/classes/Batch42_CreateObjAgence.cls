/**
* @author: Rita Bejjani -EI Technologies
* @date: 23/04/2019
* @description: Creation of ObjectifAgence__c 
* @Test Class: Batch42_CreateObjAgence_test 
* @Coverage: 92%
*/
global class Batch42_CreateObjAgence implements Database.Batchable<SObject>,Database.stateful {
    
    private String anneeToInsert;
    
    global set<id> setObjAgcID = new set<id>();
    
    public Batch42_CreateObjAgence(String annee) {
        anneeToInsert = annee; // the year of the ObjectifAgence__c to be created
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, Name ,Dkcode__c FROM Agence__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<Agence__c> listAgc)
    {
        List<ObjectifAgence__c> listNewObjAgc = new List<ObjectifAgence__c>();
        for(Agence__c agc : listAgc)
        {
            ObjectifAgence__c objAgc = new ObjectifAgence__c();
            objAgc.AgenceId__c = agc.id;
            objAgc.name = anneeToInsert;
            objAgc.Annee__c = anneeToInsert;
            objAgc.tech_AgenceAnnee__c = agc.id+anneeToInsert; //unique identifier used for upsert: id of Agence__c and the year
            listNewObjAgc.add(objAgc); //add ObjectifAgence__c to list to upsert
        }
        Database.UpsertResult[] results = Database.upsert(listNewObjAgc,ObjectifAgence__c.Fields.tech_AgenceAnnee__c, false); //upsert the list of ObjectifAgence__c based on the field tech_AgenceAnnee__c 
        
        for(Integer i=0;i<results.size();i++){
            if (!results.get(i).isSuccess()){
                for(integer j = 0; j<results.get(i).getErrors().size();j++){
                    Database.Error err = results.get(i).getErrors().get(j);
                    System.debug('Error - '+err.getMessage() + '\nStatus Code : '+err.getStatusCode()+'\n Fields : '+err.getFields());
                }
            }
        }
        
        List<Objectif__c> listNewObj = [SELECT id,Nom_de_l_agence_du_commercial__c,Annee__c,ObjectifAgenceId__c,DkCodeAgenceCommercial__c
                                        FROM objectif__c WHERE Annee__c = :anneeToInsert ];
        List<ObjectifAgence__c> listObjAgc = [SELECT id,tech_AgenceAnnee__c,AgenceId__r.name,Annee__c,AgenceId__r.dkcode__c
                                              FROM ObjectifAgence__c WHERE Annee__c = :anneeToInsert];
        list<Objectif__c> listObj = new list<Objectif__c>();
        list<ObjectifAgence__c> listObjAgcToInsert = new list<ObjectifAgence__c>();
        
        map<id,List<Objectif__c>> mapObjToObjAgc = new map<id,List<Objectif__c>>(); // to add for each ObjectifAgence__c id the corresponding list of Objectif__c
        
        for(Objectif__c obj :listNewObj)
        {
            if(listObjAgc.size() != 0){
                for(ObjectifAgence__c objAgc: listObjAgc)
                {
                    if(obj.DkCodeAgenceCommercial__c == objAgc.AgenceId__r.dkcode__c && obj.Annee__c == objAgc.Annee__c)// checking the agence__c name and the year
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
                    }
                }
            }
        }
        
        for(Id objAgId :mapObjToObjAgc.keyset())
        {
            for(Objectif__c obj:mapObjToObjAgc.get(objAgId))
            {
                obj.ObjectifAgenceId__c = objAgId;// update the the lookup field on objectif with the corresponding objectifAgence id
                setObjAgcID.add(objAgId);
            }
        }
        
         try{
            update listNewObj;}
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }  
    }
    
    global void finish(Database.BatchableContext bc)
    {
        Id batchJobId  = Database.executeBatch(new Batch43_UpdateObjAgc(setObjAgcID));
    }
    
}