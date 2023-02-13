/*--------------------------------------------------------------------------------------------------------------------------
   Author: Johny Kassis
   Company: EI-Technologies
   Description: Apex controller for the lightning component LC33_RelatedListEchoOnOpp
             used instead of the related list so that some field would be prefilled when clicking on the button new and we added
             some filtering to the displayed record in the where clause of the query
   Test Class: LC33_RltListEchoOnOpp_Controller_Test
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   07/06/2018   Johny Kassis      Created
   --------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC33_RelatedListEchoOnOpp_Controller {

    public Static Integer numb = 0;// variable used to store the number of EcosystemePartenaire__c
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: this function returns the List of Ecosystemes related to the Opportunity or the contract
       Inputs: Opportunity or contract  ID
       Returns: List of EcosystemePartenaire__c
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<EcosystemePartenaire__c> getEcoSystems(Id OppId){
        Map<String, Schema.SObjectField> fieldMap = EcosystemePartenaire__c.sObjectType.getDescribe().fields.getMap();// map that contains all the fields of the EcosystemePartenaire__c
        List<String> fieldNames = new List<String>();// list used to store the API name of all the fields of the EcosystemePartenaire__c
        fieldNames.addall(fieldMap.keySet());// use the key set of the map to fill the list
        List<String> listTypeRelationToExclude = new List<String> {'DEST', 'FACT_1'};
        // query all the EcosystemePartenaire__c related to the Opportunity or the contract
        //List<EcosystemePartenaire__c> ecoSystems = Database.query('select ' + string.join(fieldNames, ',') + ',Partenaire__r.name ,PartenaireLie__r.name,ContactDuPartenaire__r.Name,ContactDuPartenaireLie__r.Name  from EcosystemePartenaire__c where ( Opportunite__c = \''+OppId+'\' or Contrat__c = \''+OppId+'\')');

        String query = 'select ContactDuPartenaireLie__c,PartenaireLie__c,toLabel(TypeRelation__c) ,PartenaireLie__r.name,ContactDuPartenaireLie__r.Name,toLabel(Statut__c) from EcosystemePartenaire__c where ( Opportunite__c = \'' + OppId + '\' or Contrat__c = \'' + OppId + '\') and (statut__c!=\'INACT\') and TypeRelation__c!=\'SIGN\'';

        //ne plus afficher les ecosystèmes de type de relation destinataire ou facturé US C360-642
        if(OppId.getSObjectType().getDescribe().getName() == 'Opportunity') {
            query = query + ' and TypeRelation__c not in :listTypeRelationToExclude';
        }
        //and TypeRelation__c not in :listTypeRelationToExclude
        List<EcosystemePartenaire__c> ecoSystems = Database.query(query);

        numb = ecoSystems.size();// set the variable numb

        return ecoSystems;// return the list

    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: returns the AccountID of the Opportunity or the Contract
       Inputs: Id
       Returns: ID
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static String getAccountID(String OppId){
        If(OppId.left(3) == '006'){
            // query the AccountID of the Opportunity
            Opportunity opp = [SELECT AccountId, ID
                               FROM Opportunity
                               WHERE id =:OppId];
            Return opp.AccountID;// return the accountID
        } else {
            // query the Account ID of the Contrat__c
            Contrat__c cont = [SELECT NomPartenaire__c, ID
                               FROM Contrat__c
                               WHERE id =:OppId];
            Return cont.NomPartenaire__c;// return the accountID
        }
    }

/*
 *@Author: Jacques Akiki
 *@Date: 19/02/2020
 *@Description: returns true if the the contrat or the contrat généré of the opportunity has a status <> fermé or user of a profilenot allowed and false otherwise
 *@Inputs: Id
 *@Returns: boolean
 */
    @AuraEnabled
    public static Boolean getStatut(String OppId){
        List<profile> listprof = [SELECT id, Name FROM Profile WHERE id =:Userinfo.getProfileId()];
        if(OppId<> null) {
            if(OppId.left(3) == '006') {
                // query the Opportunity
                List<Opportunity> listOpp = [SELECT id, Contrat_Genere_lookup__r.statut__c FROM Opportunity WHERE id =:OppId];
                if(listOpp<> null && listOpp.size() > 0) {
                    if(listOpp[0].Contrat_Genere_lookup__r.statut__c == Label.ContratFerme || Label.LC33_ProfCreSupEcosys.contains(',' + listprof[0].Name + ',')) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return null;
                }
            } else {
                List<Contrat__c> listCont = [SELECT id, statut__c FROM contrat__c WHERE id =:OppId];

                if(listCont<> null && listCont.size() > 0) {
                    if(listCont[0].statut__c == Label.ContratFerme || Label.LC33_ProfCreSupEcosys.contains(',' + listprof[0].Name + ',')) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return null;
                }
            }
        } else {
            return null;
        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: Delete the EcosystemePartenaire__c
       Inputs: ID
       Returns: List of String
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<String> deleteEco(Id ecoID){ // query the EcosystemePartenaire__c that will be deleted
        EcosystemePartenaire__c eco = [SELECT ID, name
                                       FROM EcosystemePartenaire__c
                                       WHERE id =:ecoID Limit 1];
        List<String> strlist = new List<String>();// list of strings that contains the Name of the EcosystemePartenaire__c and OK if the deletion was succecful or the error
        strlist.add(eco.Name );// add the EcosystemePartenaire__c name to the List
        try {
            delete eco;// delete the EcosystemePartenaire__c
            strlist.add('OK');// Add 'OK' to the List if the EcosystemePartenaire__c is deleted

            return strlist;// return the list
        }
        catch(system.DMLException e) {
            String msg =  e.getmessage();// if the EcosystemePartenaire__c was not deleted: get the message of the error and store it in this variable
            strlist.add( msg.remove('</b>').remove('<b>').remove(': []').replaceAll('<br>', '. '));// add the error message to the list

            return strlist; //return the list
        }
    }

}