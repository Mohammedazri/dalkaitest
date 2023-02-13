/** 
* @author Jimmy Khalil
* @date 08/07/2022
* @description créer une Fiche de synthèse à la création d'une opportunité sauf pour les opportunités concurrentes (US C360-717)
* @Test Class AP116_Opportunity_Test (100%)
*/

public without sharing class AP116_Opportunity {
    public static void createFDS(List<Opportunity> listOppNew){
        List<Fiche_de_synthese__c> listFDSToCreate = new List<Fiche_de_synthese__c>();
        for(Opportunity opp:listOppNew){
            //créer une Fiche de synthèse à la création d'une opportunité sauf pour les opportunités concurrentes
            if(opp.OpportuniteDorigine__c == null){
                Fiche_de_synthese__c newFDS = new Fiche_de_synthese__c();
                newFDS.Name =  Label.AP116_FDSName + ' ' + opp.Name;
                newFDS.Opportunit_commerciale__c = opp.Id;
                newFDS.ConditionsDeReference__c = Label.AP16_ConditionsDeReference;
                listFDSToCreate.add(newFDS);
            }
        }
        
        Insert listFDSToCreate;
    }
}