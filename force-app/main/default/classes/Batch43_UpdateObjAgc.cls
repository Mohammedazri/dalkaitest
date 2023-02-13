/**
* @author: Rita Bejjani -EI Technologies
* @date: 23/04/2019
* @description: Calculate the sum of MB and CA and update ObjectifAgence__c fields
* @Test Class: Batch43_UpdateObjAgc_test 
* @Coverage: 95%
*/
global class Batch43_UpdateObjAgc implements Database.Batchable<SObject> {
    
    private Set<id> setObjAgcID;
    
    public Batch43_UpdateObjAgc(Set<id> setObjAgc) {
        setObjAgcID = setObjAgc;// set of the ObjectifAgence__c ids related to the objectif__c to be insert
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT id, Name,Total_objectifs_en_CA__c, Total_objectifs_en_MB__c, tech_AgenceAnnee__c,SignaturesAgenceCA__c,SignaturesAgenceMB__c,P6AgenceCA__c,P6AgenceMB__c FROM ObjectifAgence__c '+
            'WHERE id in :setObjAgcID';
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<ObjectifAgence__c> listObjAgc)
    {
        Map<id, List<Double>> mapObjAgcToSum =  new Map<id, List<Double>>();
        AggregateResult[]  listAgr = [select SUM(ObjectifsenCA__c) totalCA ,SUM(ObjectifsenMB__c) totalMB, 
                                      SUM(SignaturesenCA__c) totalSignCA, SUM(SignaturesenMB__c) totalSignMB,
                                      SUM(P6enCA__c) totalTravCA, SUM(P6enMB__c) totalTravMB,
                                      ObjectifAgenceId__c
                                      from Objectif__c
                                      where ObjectifAgenceId__c in :setObjAgcID
                                      group by ObjectifAgenceId__c]; // calculate the sum of CA and MB for the ObjectifAgence__c in the set
        
        for(AggregateResult ar : listAgr)
        {
            List<Double> listSum = new List<Double>();
            listSum.add((Double)ar.get('totalCA'));// add total to list to add to the map
            listSum.add((Double)ar.get('totalMB'));
            listSum.add((Double)ar.get('totalSignCA'));
            listSum.add((Double)ar.get('totalSignMB'));
            listSum.add((Double)ar.get('totalTravCA'));
            listSum.add((Double)ar.get('totalTravMB'));
            mapObjAgcToSum.put((id)ar.get('ObjectifAgenceId__c'), listSum);// adding the id and the list from AggregateResult
        }
        
        for(ObjectifAgence__c objAgc : listObjAgc)
        {
            if(mapObjAgcToSum.containsKey(objAgc.id))
            {
                //system.debug('totals: '+ mapObjAgcToSum.get(objAgc.id)[0]+' '+mapObjAgcToSum.get(objAgc.id)[1]);
                objAgc.Total_objectifs_en_CA__c = mapObjAgcToSum.get(objAgc.id)[0]; // update totals CA for the list of objectifAgence__c
                objAgc.Total_objectifs_en_MB__c = mapObjAgcToSum.get(objAgc.id)[1]; // update totals MB for the list of objectifAgence__c
                objAgc.SignaturesAgenceCA__c = mapObjAgcToSum.get(objAgc.id)[2]; // update totals CA for the list of objectifAgence__c
                objAgc.SignaturesAgenceMB__c = mapObjAgcToSum.get(objAgc.id)[3]; // update totals MB for the list of objectifAgence__c
                objAgc.P6AgenceCA__c = mapObjAgcToSum.get(objAgc.id)[4]; // update totals CA for the list of objectifAgence__c
                objAgc.P6AgenceMB__c = mapObjAgcToSum.get(objAgc.id)[5]; // update totals MB for the list of objectifAgence__c
            }
        }
        
        try{
            update listObjAgc;
        }
        catch(exception e){
            System.debug('#### exception  ' + e );  
        }  
    }
    
    global void finish(Database.BatchableContext bc)
    {}
}