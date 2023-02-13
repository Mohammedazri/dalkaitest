/*--------------------------------------------------------------------------------------------------------------------------
   Author: Rita Mattar
   Company: EI-Technologies
   Description: Apex controller for the lightning component LC36_CreateNewEcoSys
   used instead of the related list so that some field would be prefilled when clicking on the button new
   Test Class: LC36_CreateNewEcoSys_Controller_Test
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   16/08/2018   Rita Mattar      Created
   --------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC36_CreateNewEcoSys_Controller {
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Rita Mattar
       Company: EI-Technologies
       Description: Create the EcosystemePartenaire__c
       Inputs: ID, EcosystemePartenaire__c
       Returns: List of String
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<String> createEcoSystem(Id OppId, EcosystemePartenaire__c ecoSys){
        List<String> strlist = new List<String>();
        /*
           // ajouté par Rita Bejjani 06/06/2019 pour s'assurer que les contacts choisis sont associés au bons partenaires
           if(ecoSys.ContactDuPartenaire__c != null && String.isNotBlank(ecoSys.ContactDuPartenaire__c))
           {
            Contact con = [select name, AccountId from Contact where id = :ecoSys.ContactDuPartenaire__c ];
            if(con.AccountId != ecoSys.Partenaire__c )
            {
                strlist.add(Label.LC36_erreur_ContPart);
                return strlist;
            }
           }
           else*/if(ecoSys.ContactDuPartenaireLie__c != null && String.isNotBlank(ecoSys.ContactDuPartenaireLie__c)) {
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
                if(msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                    strlist.add(msg.split('FIELD_CUSTOM_VALIDATION_EXCEPTION,')[1]);
                } else if(msg.contains('FIELD_FILTER_VALIDATION_EXCEPTION')) {
                    strlist.add(msg.split('FIELD_FILTER_VALIDATION_EXCEPTION,')[1]);
                } else {
                    strlist.add(msg.remove('</b>').remove('<b>').remove(': []').replaceAll('<br>', '. '));
                }

            }
            system.debug('test...' + strlist);

            return strlist;
        }
        //return strlist;
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Rita Mattar
       Company: EI-Technologies
       Description: Preset the current opportunity, contract and partenaire on the create form of the EcoSystem partenaire
       Inputs: ID, sObject (Opportunity or Contrat__c)
       Returns: List of sObject
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static sObject showCurrentOppOrContract(String ObjectName, String recordId) {
        sObject recordToReturn;
        if(ObjectName == 'Opportunity') {
            //Added By Jimmy for ApexSOQLInjection
            String sQuery = 'select id, Name, AccountId, Account.Name from ' + ObjectName + ' where  id =: recordId  limit 1';
            String sQueryEscaped = String.escapeSingleQuotes(sQuery);
            recordToReturn = Database.query(sQueryEscaped);

        } else if(ObjectName == 'Contrat__c') {
            //Added By Jimmy for ApexSOQLInjection
            String sQuery = 'select id, Name, NomPartenaire__c, NomPartenaire__r.Name from ' + ObjectName + ' where  id =: recordId limit 1';
            String sQueryEscaped = String.escapeSingleQuotes(sQuery);
            recordToReturn = Database.query(sQueryEscaped);
        }

        return recordToReturn;
    }
}