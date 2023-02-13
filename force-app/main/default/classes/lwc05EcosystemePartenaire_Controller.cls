/*
 * @Description: tlwc05EcosystemePartenaire Controller
 * @Author: Jimmy Khalil
 * @Date: 09/09/2022
 * @Test Class: lwc05EcosystemePartenaire_Test
 */
public with sharing class lwc05EcosystemePartenaire_Controller {

    @AuraEnabled(cacheable = true)
    public static Integer getTotalEcosysteme(String recordId){
        string stat = 'INACT';
        string rel = 'SIGN';
        //Get Total number of related EcosystemePartenaire__c
        AggregateResult[] groupedResults = [select count(id) recordCount from EcosystemePartenaire__c where PartenaireLie__c =:recordId AND statut__c!=:stat and TypeRelation__c!=:rel];
        if(groupedResults != null && groupedResults.size() > 0) {
            return Integer.valueOf(groupedResults[0].get('recordCount'));
        }

        return 0;
    }

    @AuraEnabled(cacheable = true)
    public static List<lwc05EcosystemePartenaire_Wrapper> getRelatedEcosysteme(String recordId, String sortedBy, String sortedDirection, Integer pageSize, Integer page) {
        List<lwc05EcosystemePartenaire_Wrapper> retrunedList = new List<lwc05EcosystemePartenaire_Wrapper>();

        //Map fields from the wrapper and the corresponding field
        Map<String, String> mapSortByField = new Map<String, String>();
        mapSortByField.put('PartenaireURL', 'PartenaireLie__c');
        mapSortByField.put('ContratURL', 'Contrat__r.Name');
        mapSortByField.put('ContratCAEnCours', 'Contrat__r.TotalCABudgetP1P2P3P4__c');
        mapSortByField.put('OpportunityURL', 'Opportunite__r.Name');
        mapSortByField.put('OpportuniteCAOffre', 'Opportunite__r.Amount');
        mapSortByField.put('TypeRelation', 'TypeRelation__c');
        mapSortByField.put('Statut', 'Statut__c');
		string stat = 'INACT';
        string rel = 'SIGN';
        //Dynamic Query to get all EcosystemePartenaire__c Actif realted to the PartenaireLie__c
        String query = 'Select id, PartenaireLie__c,Statut__c, PartenaireLie__r.Id, PartenaireLie__r.Name, toLabel(TypeRelation__c),' +
        'Contrat__c, Contrat__r.Name, Contrat__r.Id, Contrat__r.TotalCABudgetP1P2P3P4__c,' +
        'Opportunite__c, Opportunite__r.Name, Opportunite__r.Id, Opportunite__r.Amount ' +
        'From EcosystemePartenaire__c ' +
        'Where PartenaireLie__c =:recordId AND statut__c!=:stat and TypeRelation__c!=:rel';

        if(sortedBy != null && sortedDirection != null) {
            query += ' ORDER BY ' + mapSortByField.get(sortedBy) + ' ' + sortedDirection;
        }

        //offset and limit depending on the page size and number
        query += ' LIMIT ' + pageSize + ' OFFSET ' + ((page - 1) * pageSize);

        String queryEscaped = String.escapeSingleQuotes(query);

        system.debug('@@@ JK queryEscaped ' + queryEscaped);

        List<EcosystemePartenaire__c> relatedEcosysteme = Database.query( queryEscaped );

        //Set Wrapper
        if(relatedEcosysteme != null && relatedEcosysteme.size() > 0) {
            for(EcosystemePartenaire__c eco : relatedEcosysteme) {
                lwc05EcosystemePartenaire_Wrapper ecoWrapper = new lwc05EcosystemePartenaire_Wrapper();

                /*if(eco.PartenaireLie__c != null) {
                    ecoWrapper.PartenaireLieName = eco.PartenaireLie__r.Name;
                    ecoWrapper.PartenaireURL = '/lightning/r/Account/' + eco.PartenaireLie__r.Id + '/view';
                   }*/

                ecoWrapper.TypeRelation = eco.TypeRelation__c;
                if(eco.Contrat__c != null) {
                    ecoWrapper.ContratName = eco.Contrat__r.Name;
                    ecoWrapper.ContratURL = '/lightning/r/Contrat__c/' + eco.Contrat__r.Id + '/view';
                    ecoWrapper.ContratCAEnCours = eco.Contrat__r.TotalCABudgetP1P2P3P4__c;
                }

                if(eco.Opportunite__c != null) {
                    ecoWrapper.OppName = eco.Opportunite__r.Name;
                    ecoWrapper.OpportunityURL = '/lightning/r/Opportunity/' + eco.Opportunite__r.Id + '/view';
                    ecoWrapper.OpportuniteCAOffre = eco.Opportunite__r.Amount;
                }

                ecoWrapper.Statut = eco.Statut__c;

                system.debug('@@@ JK ecoWrapper ' + ecoWrapper);

                retrunedList.add(ecoWrapper);
            }

        }

        return retrunedList;
    }

}