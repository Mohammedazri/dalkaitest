/*-------------------------------------------------------------------------------------------------------------------------------------
Author: Alain Ghoussoub
Company: EI-Technologies
Description: Apex controller for the lightning component LC78_RattacherOpportunitte responsible of attaching opportunities
Test Class: LC78_RattacherOpportunite_TEST
-------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC78_RattacherOpportunite_Controller {
            /** 
* @author Alain Ghoussoub
* @date 6/10/2020 
* @description retoune un string qui specifie si un utilisateur peut rattacher l'ooportunite ou non
* @param ID
* @return String
*/
    @AuraEnabled
    public static String getCurrentObject(Id OppId){
        List<Opportunity> myOpp=[SELECT id,EstOpportuniteMere__c,OpportuniteMere__c,NatureOpportunitMere__c,Contrat_Genere_lookup__c,Type_pers__c,ContratOrigine__c
                           FROM Opportunity
                           Where id=:OppId
                           LIMIT 1];
        
        List<User> usr = [SELECT id,Profile.Name,profileid
                          FROM User 
                          WHERE id =: userInfo.getUserId()];
        
        String profiles = Label.Profiles_rattachement;
        Set<String> profileNames = new Set<String>();
        for(String prof : profiles.split(',')){
            profileNames.add(prof);
        }
        
        if(!profileNames.contains(usr[0].Profile.Name)){
            return 'profile';
        }
        if(myOpp[0].Type_pers__c == Label.LC78_Evolution && myOpp[0].ContratOrigine__c != null){
            return 'opp';
        }
        else if ((myOpp[0].EstOpportuniteMere__c == false && MyOpp[0].OpportuniteMere__c == null && MyOpp[0].Contrat_Genere_lookup__c == null) 
            || (MyOpp[0].NatureOpportunitMere__c == Label.LC78_National && MyOpp[0].OpportuniteMere__c != null && MyOpp[0].Contrat_Genere_lookup__c == null))
        {
            return 'ok';  
        }
        else
        {
            return 'opp';    
        }
    }
    
                /** 
* @author Alain Ghoussoub
* @date 6/10/2020 
* @description retoune l'opportunite mere courante
* @param ID
* @return String
*/
    @AuraEnabled
    public static oppWrapper getCurrentOppMere(Id OppId){
        List<Opportunity> myOpp=[SELECT id,NatureOpportunitMere__c,OpportuniteMere__r.name,OpportuniteMere__r.NumeroOpportunite__c,OpportuniteMere__c,OpportuniteMere__r.NatureOpportunitMere__c
                                 FROM Opportunity
                                 Where id=:OppId
                                 LIMIT 1];
        oppWrapper opp = new oppWrapper();
        
        Map<String,String> NatureMap= new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.NatureOpportunitMere__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            NatureMap.put(f.getValue(), f.getLabel());
        }   
        if(myOpp[0].OpportuniteMere__c != null){
            opp.Name = myOpp[0].OpportuniteMere__r.name;
            if(myOpp[0].OpportuniteMere__r.NatureOpportunitMere__c != null && NatureMap.containsKey(myOpp[0].OpportuniteMere__r.NatureOpportunitMere__c)){
                opp.Nature = NatureMap.get(myOpp[0].OpportuniteMere__r.NatureOpportunitMere__c);
            }
            opp.Numero = myOpp[0].OpportuniteMere__r.NumeroOpportunite__c;
            opp.id = myOpp[0].OpportuniteMere__c;
        }
        return opp;
    }
    /** 
* @author Alain Ghoussoub
* @date 6/10/2020 
* @description retoune la liste des opportunités vérifiant le filtre
* @param String searchKey les lettres de recherch saisies par l'utilisateur
* @return List<oppWrapper> myOppswrp liste des opportunités vérifiants le filtre
*/
    @AuraEnabled
    public static List<oppWrapper> getOppssWrp(String searchKey){
        
        String keyword = '%'+searchKey+'%' ;
        String myAPACondition = 'where EstOpportuniteMere__c = true and NatureOpportunitMere__c = \'National\' ';
        if(searchKey != null && searchKey != ''){
            myAPACondition = myAPACondition + 'And Name LIKE \''+keyword+'\'';
        }
        List<Opportunity> myOpps = Database.query('SELECT id,Name,NumeroOpportunite__c,NatureOpportunitMere__c from Opportunity '+ myAPACondition + ' LIMIT 5');
        List<oppWrapper> myOppswrp = new List<oppWrapper>();
        if(myOpps != null && myOpps.size()>0){
            for(Opportunity apa : myOpps){
                oppWrapper myopp = new oppWrapper();
                myopp.Name = apa.Name;
                myopp.Id = apa.id;
                myopp.Numero= apa.NumeroOpportunite__c;
                myopp.Nature = apa.NatureOpportunitMere__c;
                myOppswrp.add(myopp);
                
            }       
            
        }
        return myOppswrp ;
    }
        /** 
* @author Alain Ghoussoub
* @date 7/10/2020 
* @description rattache l'opportunite
* @param String opportunity id
* @param String ipportunity mere id
* @return String si Update ok ou non
*/
    @AuraEnabled
    public static string updateOppMere(Id oppId,String oppMereId,String Nature){
        List<Opportunity> oldOppList = [SELECT id,type_pers__c,RecordTypeId,OpportuniteMere__c
                                     FROM Opportunity
                                     WHERE id = :oppId];

        Map<String,String> NatureMap= new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.NatureOpportunitMere__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            NatureMap.put(f.getLabel(), f.getValue());
        }   
        
        Opportunity opp = new Opportunity();
        opp.id = oppid;
        if(oldOppList[0].OpportuniteMere__c == null && oldOppList[0].type_pers__c == Label.LC78_Nouveau && oppMereId != ''){
            opp.type_pers__c = Label.LC78_Nouveau; // CKH US290 - 06/10/2021
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        }
        if(oldOppList[0].OpportuniteMere__c != null && oldOppList[0].type_pers__c == Label.LC78_Evolution && oppMereId == ''){
            opp.type_pers__c = Label.LC78_Nouveau;
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        }
        if(Nature != null && NatureMap.containsKey(Nature)){
            opp.NatureOpportunitMere__c = NatureMap.get(Nature);
        }
        else{
            opp.NatureOpportunitMere__c = null;
        }
        if(oppMereId != ''){
            opp.OpportuniteMere__c = oppMereId;
        }
        else{
            opp.OpportuniteMere__c = null;
        }
        try {
            Database.SaveResult result = Database.update(opp, false);
            if(!result.isSuccess()) {
                return result.getErrors()[0].getMessage();
            }
            else{
                return 'success';
            }
        } catch(Exception e) {
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static list<String> GetNaturePicklist()
    {
        List<String> NatureList= new List<String>();
        NatureList.add(Label.National_Regional);
        return NatureList;
    }
        /** 
* @author Alain Ghoussoub
* @date 5/10/2020 
* @description wrapper représentant les infos de chaque opportunité affichée dans le custom loockup
*/
    public class oppWrapper{
        @AuraEnabled
        public string Name{get;set;}
        @AuraEnabled
        public string Id{get;set;}
        @AuraEnabled
        public string Numero{get;set;}
        @AuraEnabled
        public string Nature{get;set;}
    }
    
            /** 
* @author Alain Ghoussoub
* @date 7/10/2020 
* @description wrapper représentant les picklist values
*/
    public class WRP01_MenuPickList {
        
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        
        public WRP01_MenuPickList(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}