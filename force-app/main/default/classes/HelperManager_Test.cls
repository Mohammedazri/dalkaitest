/*--------------------------------------------------------------------------------------------------------------------------
Author: Rita Mattar
Company: EI-Technologies
Description: Classe test utilisé pour couvrir la classe HelperManager
Code Coverage: 93%
--------------------------------------------------------------------------------------------------------------------------*/

@isTest
public class HelperManager_Test {
    public static testMethod void GetDependentValues()
    {
        Schema.SObjectType pType = Schema.getGlobalDescribe().get('Contrat__c');
        HelperManager.GetDependentOptionsImpl(pType ,'Motif_fermeture_contrat__c','Condition_de_fermeture__c');
        HelperManager.GetDependentOptions('Contrat__c','Motif_fermeture_contrat__c','Condition_de_fermeture__c');
        HelperManager.GetDependentOptions2('Contrat__c','Motif_fermeture_contrat__c','Condition_de_fermeture__c');
    }
}