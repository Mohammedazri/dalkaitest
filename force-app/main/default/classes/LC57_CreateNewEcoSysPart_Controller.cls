public without sharing class LC57_CreateNewEcoSysPart_Controller {

    @AuraEnabled
    public static List<String> createEcoSystem(Id AccId, EcosystemePartenaire__c ecoSys, boolean partExistant){
        List<String> strlist = new List<String>();

        // s'assurer que les contacts choisis sont associés au bons partenaires
        if(ecoSys.ContactDuPartenaireLie__c != null && String.isNotBlank(ecoSys.ContactDuPartenaireLie__c)) {
            Contact con = [select name, AccountId from Contact where id = :ecoSys.ContactDuPartenaireLie__c ];
            if(con.AccountId != ecoSys.PartenaireLie__c) {
                strlist.add(Label.LC36_erreur_ContPartLie);

                return strlist;
            }
        }

        try {
            ecoSys.PartenaireLie__r = null;
            //ecoSys.Partenaire__r = null;
            ecoSys.Contrat__r = null;
            ecoSys.Opportunite__r = null;
            ecoSys.ContactDuPartenaireLie__r = null;
            //ecoSys.ContactDuPartenaire__r = null;
            ecoSys.Contrat__r = null;
            ecoSys.tech_OpportuniteSansFiltre__r = null;
            ecoSys.tech_ContratSansFiltre__r = null;

            if(ecoSys.tech_OpportuniteSansFiltre__c != null && String.isNotBlank(ecoSys.tech_OpportuniteSansFiltre__c) ) {
                //ecoSys.Opportunite__c = ecoSys.tech_OpportuniteSansFiltre__c;

                Opportunity opp = [select id, Name, Account.Name, AccountId from Opportunity where id = :ecoSys.tech_OpportuniteSansFiltre__c limit 1];
                if(opp.AccountId == ecoSys.PartenaireLie__c) {
                    ecoSys.Opportunite__c = ecoSys.tech_OpportuniteSansFiltre__c;
                } else {
                    strlist.add(Label.LC57_erreur_OppFiltre);

                    return strlist;
                }

            } else if(ecoSys.tech_ContratSansFiltre__c != null && String.isNotBlank(ecoSys.tech_ContratSansFiltre__c)) {
                //ecoSys.Contrat__c = ecoSys.tech_ContratSansFiltre__c;

                Contrat__c cont = [select id, Name, NomPartenaire__r.id from Contrat__c where id = :ecoSys.tech_ContratSansFiltre__c limit 1];
                if(cont.NomPartenaire__r.id == ecoSys.PartenaireLie__c) {
                    ecoSys.Contrat__c = ecoSys.tech_ContratSansFiltre__c;
                } else {
                    strlist.add(Label.LC57_erreur_ContFiltre);

                    return strlist;
                }

            }

            insert ecoSys;

            list<EcosystemePartenaire__c> nameEcoSys = [SELECT name
                                                        FROM EcosystemePartenaire__c
                                                        WHERE id =: ecoSys.id
                                                        LIMIT 1];
            strlist.add('OK');
            strlist.add(nameEcoSys[0].name);

            return strlist;
        }
        catch(system.DMLException e) {
            String msg = e.getmessage();
            if(msg.contains('duplicate value found: ZZZTechEcosystemeRegleUnicite__c')) {
                strlist.add(Label.LC36_erreur_duplicate);
            } else {
                strlist.add(msg.remove('</b>').remove('<b>').remove(': []').replaceAll('<br>', '. '));
            }

            return strlist;
        }
        //return strlist;
    }

    @AuraEnabled
    public static sObject showCurrentOppOrContract(String ObjectName, String recordId) {

        sObject recordToReturn;
        if(ObjectName == 'Account') {
            String sQuery = 'select id, Name from Account where  id =: recordId limit 1';
            //Added By Jimmy for ApexSOQLInjection
            String sQueryEscaped = String.escapeSingleQuotes(sQuery);
            recordToReturn = Database.query(sQueryEscaped);
        } else if(ObjectName == 'Contact') {
            String sQuery = 'select id, Name, Account.Name,AccountId from Contact where  id =: recordId limit 1';
            //Added By Jimmy for ApexSOQLInjection
            String sQueryEscaped = String.escapeSingleQuotes(sQuery);
            recordToReturn = Database.query(sQueryEscaped);
        }

        System.debug('recordToReturn ' + recordToReturn);

        return recordToReturn;
    }
}