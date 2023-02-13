/*
* Description: To get the values of a dependant picklist field based on a controlling 
* picklist field and the object (used in the controller LC35_PopUpOnEvolutionClose_Controller
* of the lightning component LC35_PopUpOnEvolutionClose)
* @author: Tony Tannous
* @date: 20/09/2017
* @Test class: HelperManager_Test
*/
public class HelperManager
{ 
    
    public static Map<String, List<String>> GetDependentOptions(String objectName, String controllingField, String dependentField)
    {
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();
        
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        
        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }
        
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);
            TStringUtils.TPicklistEntry info = (TStringUtils.TPicklistEntry) JSON.deserialize(jsonString, TStringUtils.TPicklistEntry.class);
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
            Integer baseCount = 0;
            
            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;
                
                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }
                if((val & 8) == 8)
                {
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 4) == 4)
                {
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 2) == 2)
                {
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 1) == 1)
                {
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                }
                
                baseCount += 4;
            }            
        } 
        return controllingInfo;
    }
    
    public static Map<String,List<String>> GetDependentOptions2(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(pObjName))
            return objResults; 
        //get the type being dealt with
        Schema.SObjectType pType = Schema.getGlobalDescribe().get(pObjName);
        
        return GetDependentOptionsImpl(pType,pControllingFieldName,pDependentFieldName); 
    }
    public static Map<String,List<String>> GetDependentOptionsImpl(Schema.SObjectType pType, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        if (pType==null)
            return objResults;
        TStringUtils.Bitset BitSetInstance = new TStringUtils.Bitset();
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //verify field names
        if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName))
            return objResults;
        
        //get the control values 
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        
        objFieldMap = null;
        List<Integer> lstControllingIndexes = new List<Integer>();
        //iterate through the values and get the ones valid for the controlling field name
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){ 
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<String>());
            //keep track of the controlling indexes
            lstControllingIndexes.add(pControllingIndex);
        }
        //cater for null and empty
        objResults.put('',new List<String>());
        objResults.put(null,new List<String>());
        //load all dep entries
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<TStringUtils.TPicklistEntry> objDS_Entries = new List<TStringUtils.TPicklistEntry>();
        //add all entries
        
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){ 
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            objEntries.add(dep_entry);
        } 
        objDS_Entries = (List<TStringUtils.TPicklistEntry>)JSON.deserialize(JSON.serialize(objEntries), List<TStringUtils.TPicklistEntry>.class);
        
        List<Integer> validIndexes;
        
        for (TStringUtils.TPicklistEntry objDepPLE : objDS_Entries)
        {
            //if valid for is empty, skip 
            
            if ( objDepPLE.validFor ==null || objDepPLE.validFor==''){
                
                continue;
            }
            //get the test for the controlling indexes
            validIndexes = BitSetInstance.testBits(objDepPLE.validFor,lstControllingIndexes);
            for (Integer validIndex : validIndexes){ 
                //get the label
                String pControllingLabel = ctrl_ple[validIndex].getLabel();
                objResults.get(pControllingLabel).add(objDepPLE.label);
            }
        }
        objEntries = null;
        objDS_Entries = null;
        return objResults;
    }
}