/*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar
Company: EI-Technologies
Description: Classe test utilisé pour couvrir la classe TStringUtils
Code Coverage: 94%
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class TStringUtils_Test 
{
    public static testMethod void GetDependentValues()
    {
        TStringUtils.Bitset TSBitset = new TStringUtils.Bitset();
        TStringUtils.TPicklistEntry TSTPicklistEntry = new TStringUtils.TPicklistEntry();
        
        List<Integer> intList = new List<Integer>{1,2,3,4};
        
        Test.startTest();
        HelperManager.GetDependentOptions('Contrat__c','Motif_fermeture_contrat__c','Condition_de_fermeture__c');
        List<Integer> lstTestBits = TSBitset.testBits('four',intList);
        
        string active = TSTPicklistEntry.active;
        string defaultValue =TSTPicklistEntry.defaultValue;
        string label =TSTPicklistEntry.label;
        string value =TSTPicklistEntry.value;
        string validFor =TSTPicklistEntry.validFor;
        
        Test.stopTest();
    } 
}