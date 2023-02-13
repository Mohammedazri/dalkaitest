public with sharing class LC13_CreationPartenaire_Controller {
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    
    @AuraEnabled 
    public static map<String,List<String>> getMapSSCodeNAF(String codeNAF){
        map<String,List<String>> mapSegmentSousSegment = new map<String,List<String>>();
        List<CodeActiviteLocalSegment__c > listCALS = [SELECT CodeActiviteLocal__c, Segment__c, SousSegment__c 
                                                       FROM CodeActiviteLocalSegment__c 
                                                       WHERE CodeActiviteLocal__c =:codeNAF AND (segment__c like '%,%' OR SousSegment__c like '%-%') ];
        Map<String,String> segmentLabelValue = new Map<String,String>();
        Map<String,String> ssegmentLabelValue = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Account.Segment_client__c.getDescribe();
        Schema.DescribeFieldResult ssfieldResult = Account.Sous_segment_client__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        List<Schema.PicklistEntry> ssvalues = ssfieldResult.getPicklistValues();
        for( Schema.PicklistEntry v : values) {
            segmentLabelValue.put(v.getValue(),v.getLabel());        
        }
         for( Schema.PicklistEntry v : ssvalues) {
            ssegmentLabelValue.put(v.getValue(),v.getLabel());        
        }
        if (listCALS!=NULL && listCALS.size()>0){
            integer i = 0;
            for(String segment:listCALS[0].segment__c.split(',')){
                list<String> listss = listCALS[0].SousSegment__c.split(',')[i].split('-');
                list<String> sousSegment = new list<String>();
                for(String s:listss){
                    sousSegment.add(ssegmentLabelValue.get(s));
                }
                mapSegmentSousSegment.put(segmentLabelValue.get(segment), sousSegment);
                i++;
            }
        }
        else{
            mapSegmentSousSegment = getMapSS('Segment_client__c','Sous_segment_client__c' ,'Account');
        }
        return mapSegmentSousSegment;
    }
    
    
    @AuraEnabled 
    public static map<String,List<String>> getMapSS(String parentPicklist, String childPicklist, string objectAPIName){
        map<String,List<String>> mapSegmentSousSegment = new Map<String,List<String>>();
        Map<String,String> segmentValueLabel = new Map<String,String>();
        List<String> segmentValues = new List<String>();
        Map<String,String> segmentLabelValue = new Map<String,String>();
        Schema.DescribeFieldResult fieldResultSeg = Account.Segment_client__c.getDescribe();
        List<Schema.PicklistEntry> valuesSeg = fieldResultSeg.getPicklistValues();
        for( Schema.PicklistEntry v : valuesSeg) { 
            segmentLabelValue.put(v.getLabel(),v.getValue());
            segmentValueLabel.put(v.getValue(),v.getLabel());    
            segmentValues.add(v.getLabel());
        }
        for(String str : segmentValues){
            List<String> SSList = new List<String>();
            SSList = getDependentFieldValues('Segment_client__c','Sous_segment_client__c',str,'Account');
            system.debug('SSList ' + SSList);
            mapSegmentSousSegment.put(str,SSList);
        }
        system.debug('mapSegmentSousSegment ' + mapSegmentSousSegment);
        return mapSegmentSousSegment;
    }
    
    @AuraEnabled 
    public static List<string> getDependentFieldValues(String parentPicklist, String childPicklist, String ctrlVal, string objectAPIName){
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
        string dependentVal = '';
        Schema.DescribeFieldResult parentFieldDesc = fieldMap.get(parentPicklist).getDescribe();
        Schema.DescribeFieldResult childFieldDesc = fieldMap.get(childPicklist).getDescribe();
        Schema.sObjectField parentField = parentFieldDesc.getSObjectField();
        system.debug('parentField ' + parentField);
        Schema.sObjectField childField = childFieldDesc.getSObjectField();
        Map<String, List<String>> mapDepCont = getDependentOptionsImpl(childField, parentField);
        if(mapDepCont.containsKey(ctrlVal)){
            list<string> listValues = mapDepCont.get(ctrlVal);
            for(string str : listValues){
                dependentVal += str + ';';
            }
            dependentVal = dependentVal.removeEnd(';');
        }
        Map<String,String> sousSegmentLabelValue = new Map<String,String>();
        Schema.DescribeFieldResult fieldResultSousSeg = Account.Sous_segment_client__c.getDescribe();
        List<Schema.PicklistEntry> valuesSousSeg = fieldResultSousSeg.getPicklistValues();
        for( Schema.PicklistEntry v : valuesSousSeg) {
            sousSegmentLabelValue.put(v.getLabel(),v.getValue());        
        }
        List<String> listSS = dependentVal.split(';');
        List<String> ListSSValues = new List<String>();
        for(String str : listSS){
            ListSSValues.add(str);
        }
        
        return ListSSValues;
    }
    
    public static Map<String, List<String>> getDependentOptionsImpl(Schema.SObjectField theField, Schema.SObjectField ctrlField) {
        // validFor property cannot be accessed via a method or a property,
        // so we need to serialize the PicklistEntry object and then deserialize into a wrapper.
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        // Set up the return container - Map<ControllingValue, List<DependentValues>>
        Map<String, List<String>> objResults = new Map<String, List<String>>();
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                // For each bit, in order: if it's a 1, add this label to the dependent list for the corresponding controlling value
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        
        return objResults;
    }
    
    public class PicklistEntryWrapper {
        @AuraEnabled 
        public String active {get; set;}
        @AuraEnabled 
        public String defaultValue {get; set;}
        @AuraEnabled 
        public String label {get; set;}
        @AuraEnabled 
        public String value {get; set;}
        @AuraEnabled 
        public String validFor {get; set;}
    }
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>) JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    @AuraEnabled 
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    @AuraEnabled 
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    //method to call creerPartenaireIdExterne WS
    @AuraEnabled 
    public static String insertAccounts(String acc){
        
        system.debug('acc '+ acc);
        Account accToInsert = (Account)JSON.deserialize(acc, Account.class);
        system.debug(accToInsert.Segment_client__c);
        system.debug(accToInsert.Sous_segment_client__c);
        Map<String,String> segmentLabelValue = new Map<String,String>();
        Schema.DescribeFieldResult fieldResultSeg = Account.Segment_client__c.getDescribe();
        List<Schema.PicklistEntry> valuesSeg = fieldResultSeg.getPicklistValues();
        for( Schema.PicklistEntry v : valuesSeg) {
            segmentLabelValue.put(v.getLabel(),v.getValue());        
        }
        Map<String,String> sousSegmentLabelValue = new Map<String,String>();
        Schema.DescribeFieldResult fieldResultSousSeg = Account.Sous_segment_client__c.getDescribe();
        List<Schema.PicklistEntry> valuesSousSeg = fieldResultSousSeg.getPicklistValues();
        for( Schema.PicklistEntry v : valuesSousSeg) {
            sousSegmentLabelValue.put(v.getLabel(),v.getValue());        
        }
        accToInsert.Segment_client__c=segmentLabelValue.get(accToInsert.Segment_client__c);
        accToInsert.Sous_segment_client__c=sousSegmentLabelValue.get(accToInsert.Sous_segment_client__c);
        system.debug(accToInsert.Segment_client__c);
        system.debug(accToInsert.Sous_segment_client__c);
        String billingCountry = accToInsert.BillingCountry;
        if(billingCountry != null && billingCountry.length()>0){
            billingCountry = Accents_Utils.removeDiacritics(billingCountry);
            List<Pays__c> Pays = [SELECT id,Abreviation__c,Nom__c  from Pays__c where nom__c = :billingCountry];
            if(Pays != null && Pays.size()>0){
                accToInsert.BillingCountry = Pays[0].Abreviation__c;
            }
        }
        system.debug('accToInsert.Identification_externe__c ' + accToInsert.Identification_externe__c);
        String jsonAcc = '[' + JSON.serialize(accToInsert) + ']';
        system.debug('jsonAcc ' + jsonAcc);
        String res = AP45_AccountCallouts.CreerPartenaireIdExterne(jsonAcc);
        return res;
    }
    //method to get segment picklist value
    @AuraEnabled 
    public static List<String> getSegmentValues(){
        List<String> segmentLabelValue = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Segment_client__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry v : values) {
            segmentLabelValue.add(v.getLabel());        
        }
        return segmentLabelValue;
    }
    //method to get sous segment picklist value
    @AuraEnabled 
    public static List<String> getSousSegmentValues(){
        List<String> sousSegmentLabelValue = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Sous_segment_client__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry v : values) {
            sousSegmentLabelValue.add(v.getLabel());        
        }
        return sousSegmentLabelValue;
    }
       //method to get effectif picklist value
    @AuraEnabled 
    public static Map<String,String> getEffectifValues(){
        Map<String,String> effectifLabelValue = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Account.Effectif__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry v : values) {
            effectifLabelValue.put(v.getValue(),v.getLabel());        
        }
        return effectifLabelValue;
    }
    //method that checks if an existing account has the same siret entered
    @AuraEnabled
    public static boolean getIfSiretExists(string SiretEntered){
        boolean ifSiretExists=false;
        List<Account> ListAccountsWithSiret=[SELECT id, SIRET__c
                                             FROM account
                                             WHERE SIRET__c=:SiretEntered];
        if(ListAccountsWithSiret != null && ListAccountsWithSiret.size()>0)
            ifSiretExists=true;
        return ifSiretExists;
    }
    
    //method that takes the siret number entered and returns infos of the account searched based on the siret number
    @AuraEnabled
    public static String getAccountInfos(string SiretEntered){
        String returnedFields=WS01_BaseSirene.DoCalloutAndRteurnInfos(SiretEntered);
        //system.debug('returnedFields  ' + returnedFields);
        //system.debug('returnedFields.codpos  ' + returnedFields.codpos);
        system.debug('returnedFields ' + returnedFields);
        //system.debug(returnedFields.etablissement);
        return returnedFields;
    }
    
    //method that checks whether profile can create opp or not, if can -> show button on lightning page
    @AuraEnabled
    public static boolean canCreateAcc(){
        Schema.DescribeSObjectResult objectDescribe  = Account.SObjectType.getDescribe();
        boolean retVal = false;
        if(objectDescribe.isCreateable()){
            retVal = true;
        }
        return retVal;
    }
    
    //method that returns the list of record types for the connected user 
    @AuraEnabled
    public static list<RecordTypeObj> getRecordTypes(){
        
        //get record type info based on connected user
        list<RecordTypeInfo> infos = Account.SObjectType.getDescribe().getRecordTypeInfos();
        //return list declaration and initialization
        list<RecordTypeObj> retVal = new list<RecordTypeObj>();
        
        for(RecordTypeInfo rtInf :infos){
            //if the record type is available for this user (use isavailable method) and is not the master Record Type (principal)
            if(rtInf.isAvailable() && !rtInf.IsMaster()){               
                retVal.add(new RecordTypeObj (rtInf.getRecordTypeId(), rtInf.getName()));                
            }
        }
        return retVal;
    }
    
    //return object record type
    public class RecordTypeObj{
        @AuraEnabled
        public string RTId;
        @AuraEnabled
        public string RTName;
        public RecordTypeObj(string RTId, string RTName){
            this.RTId = RTId;
            this.RTName = RTName;
        }
    }
    
    //method that verifies if we are in maintenance mode or not
    @AuraEnabled
    public static Boolean checkIfModeMaintenance(){
        
        List<Mode_Maintenance__c> lstMM = [select id, En_mode_maintenance__c from Mode_Maintenance__c limit 1];
        if(lstMM.size() > 0)
        {
        	return lstMM[0].En_mode_maintenance__c;
        }
        else
        {
            return false;
        }
    }
}