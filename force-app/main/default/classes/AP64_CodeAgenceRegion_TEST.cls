/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 17/07/2019
* @description: Test Class for "AP64_CodeAgenceRegion" 
*/
@isTest
public class AP64_CodeAgenceRegion_TEST {
    static testMethod void testCodeAgence() {
        CodeAgence_Region__c code1 = new CodeAgence_Region__c();
        code1.name = 'CO';
        code1.dkcode__c = 'J00001004R';
        code1.Code__c='CO';
        insert code1;
        CodeAgence_Region__c code2 = new CodeAgence_Region__c();
        code2.name = 'DK';
        code2.dkcode__c = 'J00001002N';
        code2.Code__c='DK';
        insert code2;
        region__c r1= new region__c();
        r1.Code_Region__c='OCES';
        insert r1;
        List<Agence__c> agenceList= new List<Agence__c>();
        Agence__c a1= new agence__c();
        a1.Code_Agence__c='OCOSCOM1';
        a1.DKCode__c='code1';
        agenceList.add(a1);
        Agence__c a2= new agence__c();
        a2.Code_Agence__c='DK';
        a2.DKCode__c='code2';
        agenceList.add(a2);
        insert agenceList;
    }
}