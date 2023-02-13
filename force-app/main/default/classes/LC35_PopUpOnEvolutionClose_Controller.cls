/**
 * @author: Jacques Akiki -EI Technologies
 * @date:18/04/2019
 * @description: Controller of lightning component LC35_popUpOnEvolutionClose
 * @Test Class: LC35_PopUpOnEvolutionClose_Test
 * @Coverage: 79%
 */
public without sharing class LC35_PopUpOnEvolutionClose_Controller {
    /**
     * @author: Jacques Akiki -EI Technologies
     * @date: 18/04/2019
     * @description: This method checks if all the conditions are met for the pop up of resiliation to show.
     * @inputs: id
     * @returns: Boolean
     */
    @AuraEnabled
    public static Integer getMessage(Id oppID){
        //use the Opportunity ID to query the Opportunity
        Opportunity opp = [SELECT id, Statut__c, Type_pers__c, OpportuniteMere__c, EstOpportuniteMere__c, Nb_de_fiches_synthese__c,
                           Tech_ResilistionFirst__c, ContratOrigine__r.Condition_de_fermeture__c, tech_realisation__c, Tech_OpenConcurrente__c
                           FROM Opportunity
                           WHERE id =: oppID ];

        system.debug('OppId ' + OppId);
        List<Opportunity> oppConc = new list<Opportunity>();
        oppConc = [SELECT Id
                   FROM Opportunity
                   WHERE OpportuniteDorigine__c = :OppId];
        system.debug('oppConc ' + oppConc);
        String oppConcExiste = '';
        if(oppConc != null && oppConc.size() > 0) {
            oppConcExiste = oppConc[0].id;
        }
        system.debug('oppConcExiste ' + oppConcExiste);

        if(opp.Nb_de_fiches_synthese__c == 0) {
            return 2; // if no fds is related no pop up should appear
        }
        // if the conditions are met query and return  the contract
        if(((opp.Statut__c == Label.LC35_Statut && opp.Type_pers__c == Label.LC35_Renouv && opp.tech_realisation__c) || (opp.Statut__c == 'Sans suite' && opp.Type_pers__c == 'Nouveau'))
           && !opp.Tech_ResilistionFirst__c && oppConcExiste == '') {
            system.debug('test1');
            if(opp.OpportuniteMere__c == null) {//&& !opp.EstOpportuniteMere__c)

                return 1;  //condition to open 1 pop up is met
            } else {
                return 3;  // condition to only open 2nd pop up is met
            }
        } else if(((opp.Statut__c == Label.LC35_Statut && opp.Type_pers__c == Label.LC35_Renouv && opp.tech_realisation__c) || ((opp.Statut__c == 'Sans suite' && opp.Type_pers__c == 'Nouveau') || !opp.Tech_OpenConcurrente__c))
                  && !opp.Tech_ResilistionFirst__c && oppConcExiste != '' && opp.Statut__c != 'En cours') {
            if(opp.Statut__c == 'Gagnée') {
                return 5;
            } else {
                return 4;
            }
        } else {
            return 2; // will not open either pop ups.
        }
    }

    /**
     * @author: Alain Ghoussoub -EI Technologies
     * @date: 14/05/2020
     * @description: This method gets the opportunite concurrente details
     * @inputs: id
     * @returns: Opportunity
     */
    @AuraEnabled
    public static Opportunity getOppConcurente(Id oppID){
        system.debug('OppId ' + OppId);
        List<Opportunity> oppConc = new list<Opportunity>();
        oppConc = [SELECT Id, NumeroOpportunite__c
                   FROM Opportunity
                   WHERE OpportuniteDorigine__c = :OppId];
        system.debug('oppConc ' + oppConc);

        return oppConc[0];
    }

    /**
     * @author: Alain Ghoussoub -EI Technologies
     * @date: 14/05/2020
     * @description: This method gets the opportunite concurrente details
     * @inputs: id
     * @returns: Opportunity
     */
    @AuraEnabled
    public static Opportunity getOppNow(Id oppID){
        system.debug('OppId ' + OppId);
        List<Opportunity> oppNow = new list<Opportunity>();
        //09-08-2022 Added Qualification__c to check if opp is Nouvea + Sans suite in the component US C360-218 Sprint 32
        oppNow = [SELECT Id, statut__c,Qualification__c
                  FROM Opportunity
                  WHERE id = :OppId];
        system.debug('oppNow ' + oppNow);

        return oppNow[0];
    }

    /**
     * @author: Jacques Akiki -EI Technologies
     * @date: 18/04/2019
     * @description: This method Creates the new Opportunity of type concurrente && the new fiche de synthese related to this Opp.
     * @inputs: id
     * @returns: String
     */
    @AuraEnabled
    public static String duplicate(Id oppID){
        Opportunity opp = [SELECT id, Duree_minimale_estimee__c, closeDate, Nb_de_fiches_synthese__c, Tech_ResilistionFirst__c
                           FROM Opportunity
                           WHERE id =: OppID]; // Use Opportunity Id to querry Opportunity record

        Fiche_de_synthese__c myFDS = new Fiche_de_synthese__c(); // create new FDS

        if(opp.Nb_de_fiches_synthese__c > 0) { // there is an associated FDS to the Opportunity
            Fiche_de_synthese__c fds = [SELECT id, name, Opportunit_commerciale__c
                                        FROM Fiche_de_synthese__c
                                        WHERE Opportunit_commerciale__c =:oppID LIMIT 1]; // Use Opportunity Id to query related FDS
            SObject sObj2  = returnObject(fds.id); // call the method returnObject to querry all Fiche_de_synthese__c Fields
            myFDS = (Fiche_de_synthese__c)sObj2.clone();// cast to Fiche_de_synthese__c and clone the record to get all fields.
        }

        SObject sObj1  = returnObject(oppID); // call the method returnObject to querry all Opportunity Fields
        Opportunity myOpp = new Opportunity(); // create new Opportunity
        myOpp = (Opportunity)sObj1.clone();// cast to Opportunity and clone the record to get all fields.
        myOpp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
        myOpp.Type_pers__c = Label.PV_Opp_Type_Nouveau; // set the cloned Opportunity type to nouveau
        myOpp.Statut__c = Label.Opp_StatutEnCours;// Statut of new Opp concurente En cours
        myOpp.Motif__c = null;// Empty Motif of new Opp concurente En cours
        myOpp.StageName = Label.Piste_PicklistValue; // Stage Name of the new Opp Piste
        myOpp.IdMigration__c = null;
        myopp.tech_Budget__c = null;
        myOpp.Action_commerciale_principale__c = null;
        myOpp.Duree_minimale_estimee__c = null;
        myOpp.Numero_Affaire_SIC__c = null;
        myOpp.ContratOrigine__c = null;
        myOpp.Contrat_Genere_lookup__c = null;
        if(opp.Duree_minimale_estimee__c != null) {
            myOpp.CloseDate = opp.closeDate.addMonths(Integer.valueOf(opp.Duree_minimale_estimee__c));
            myOpp.Annee_de_signature__c = String.ValueOf(myOpp.CloseDate.year());
            Integer monthNumber = myOpp.CloseDate.month();
            List<Mois__c> Mois = [Select id, Mois__c, Number__c from Mois__c where number__c =:monthNumber];
            if(Mois != null && Mois.size() > 0) {
                myOpp.Moisdesignature__c = Mois[0].Mois__c;
            }
        } else {
            myOpp.CloseDate = opp.closeDate;
            myOpp.Annee_de_signature__c = String.ValueOf(myOpp.CloseDate.year());
            Integer monthNumber = myOpp.CloseDate.month();
            List<Mois__c> Mois = [Select id, Mois__c, Number__c from Mois__c where number__c =:monthNumber];
            if(Mois != null && Mois.size() > 0) {
                myOpp.Moisdesignature__c = Mois[0].Mois__c;
            }
        }
        myOpp.OpportuniteDorigine__c = opp.id;

        //18-1-2022 Added By Jimmy: US C360-588
        //avoir les conditions de référence à "Budget"
        myOpp.Tech_CdtRefSelectionnee__c = Label.LC12_Budget;
        //End US C360-588

        //13-07-2022 Added by Charbel KH: US C360-729
        //myOpp.ContratObligeantCEE__c = true;
        //End US C360-729
        myOpp.ContratObligeantCEEPck__c = 'Oui';

        try {
            insert myOpp; // insert new cloned opportunity
            List<OpportuniteContact__c> listOppContact = [SELECT id, Opportunite__c, Contact__c
                                                          FROM OpportuniteContact__c
                                                          WHERE Opportunite__c  =:oppID];

            if(listOppContact != NULL && listOppContact.size() > 0) {
                for(OpportuniteContact__c oc : listOppContact) {
                    oc.id = null;
                    oc.tech_Unique__c = null;
                    oc.Opportunite__c = myOpp.id;
                }

                insert listOppContact;
            }
            if(myFDS.name<> null) {
                myFDS.Opportunit_commerciale__c = myOpp.Id; // link the new cloned fds to the opportunity
                myFDS.IdMigration__c = null;
                myFDS.IdMigration_v1__c = null;
                myFDS.Date_derniere_soumission__c = null;

                //18-1-2022 Added By Jimmy: US C360-588
                //Vider la colonne "budget corrigé" sur le verso
                //query all the records of the custom setting CS02_FDS_ValorisationRecto__c that contains the Saisie__c fields and are editable
                List<CS02_FDS_ValorisationRecto__c> allWrap = [SELECT Saisie__c, editable__c
                                                               FROM CS02_FDS_ValorisationRecto__c
                                                               WHERE Saisie__c != null AND editable__c = true];

                //la colonne "budget corrigé" sur le verso est base sur le champ Saisie__c du custom setting CS02_FDS_ValorisationRecto__c (LC34_RectoValorisation_Controller)
                for(CS02_FDS_ValorisationRecto__c cust : allWrap) {
                    if(cust.Saisie__c != null && cust.editable__c) {
                        myFDS.put(cust.Saisie__c, null);
                    }
                }

                //avoir les conditions de référence à "Budget"
                myFDS.ConditionsDeReference__c = Label.LC12_Budget;

                //ne plus avoir de budget de référence
                myFDS.Budget__c = null;
                myFDS.Budget_Realise__c = null;
                //End US C360-588

                insert myFDS; // insert the new cloned Fiche_de_synthese__c
            }

        }
        catch(Exception e) {
            return e.getMessage();
        }

        try {

            opp.Tech_ResilistionFirst__c = true; // to not show pop up each time i open the opportunity
            update opp;

            return myOpp.id;
        }
        catch(Exception e) {
            return e.getMessage();
        }
    }

    /**
     * @author: Alain Ghoussoub -EI Technologies
     * @date: 19/05/2020
     * @description: This method is used to not show pop up again if the user clicks on OK for opportunite concurrente
     * @inputs: id
     * @returns: --
     */
    @AuraEnabled
    public static void cancelConcurrente(ID oppID){
        User usr = [SELECT id, Name, BypassValidationRules__c
                    FROM User
                    WHERE Id =:UserInfo.getUserId() LIMIT 1]; // query current user
        Boolean state = usr.BypassValidationRules__c; // save bypass VR state

        try {

            Opportunity opp = [SELECT id, Tech_ResilistionFirst__c, Tech_OpenConcurrente__c
                               FROM Opportunity
                               WHERE id =: oppID];
            if(!state) {
                usr.BypassValidationRules__c = true; // Bypass Validation rules
                update usr;
            }
            opp.Tech_OpenConcurrente__c = true;
            opp.Tech_ResilistionFirst__c = true;
            update opp;
            if(usr.BypassValidationRules__c != state) {
                usr.BypassValidationRules__c = state; // return Bypass to initial state
                update usr;
            }
        }
        catch(Exception e) {
            if(usr.BypassValidationRules__c != state) {
                usr.BypassValidationRules__c = state; // return Bypass to initial state
                update usr;
            }
            system.debug(e.getMessage());
        }
    }

    /**
     * @author: Jacques Akiki -EI Technologies
     * @date: 18/04/2019
     * @description: This method is used to not show pop up again if the user clicks cancel
     * @inputs: id
     * @returns: String
     */
    @AuraEnabled
    public static String cancel(ID oppID){
        User usr = [SELECT id, Name, BypassValidationRules__c
                    FROM User
                    WHERE Id =:UserInfo.getUserId() LIMIT 1]; // query current user
        Boolean state = usr.BypassValidationRules__c; // save bypass VR state

        try {

            Opportunity opp = [SELECT id, Tech_ResilistionFirst__c
                               FROM Opportunity
                               WHERE id =: oppID];
            if(!state) {
                usr.BypassValidationRules__c = true; // Bypass Validation rules
                update usr;
            }
            opp.Tech_ResilistionFirst__c = true;
            update opp;
            if(usr.BypassValidationRules__c != state) {
                usr.BypassValidationRules__c = state; // return Bypass to initial state
                update usr;
            }

            return 'OK';
        }
        catch(Exception e) {
            if(usr.BypassValidationRules__c != state) {
                usr.BypassValidationRules__c = state; // return Bypass to initial state
                update usr;
            }

            return e.getMessage();
        }
    }

    /**
     * @author: Jacques Akiki -EI Technologies
     * @date: 18/04/2019
     * @description: This method is used to query all fields to perform clone
     * @inputs: id
     * @returns: SObject
     */
    public static SObject returnObject (Id sObjId){
        DescribeSObjectResult describeResult = sObjId.getSObjectType().getDescribe();  // get Describe of the type from the id
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap(); // Map API name to Fields
        Map<String, Schema.SObjectField> fieldMapnonF = new Map<String, Schema.SObjectField>(); // Map with no formula fields

        for(String fieldNm : fieldMap.keySet()) {
            if(!fieldMap.get(fieldNm).getDescribe().isCalculated()) { // check if field is not formula to added to the map for querying
                fieldMapnonF.put(fieldNm, fieldMap.get(fieldNm)); // add to non formula map
            }

        }
        Set<String> fieldName = fieldMapnonF.keySet();// API names of all non formulas fields
        List<String> fieldNames = new List<String>(fieldName);

        // Build a Dynamic Query String.
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE Id =: sObjId LIMIT 1';

        //Added By Jimmy for ApexSOQLInjection
        String soqlQueryEscaped = String.escapeSingleQuotes(soqlQuery);

        List<sObject> record = Database.query(soqlQueryEscaped); // Query the list of sObject

        return record[0]; // return SObject Type
    }

}