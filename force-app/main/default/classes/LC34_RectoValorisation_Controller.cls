/*--------------------------------------------------------------------------------------------------------------------------
   Author: Johny Kassis
   Company: EI-Technologies
   Description: Apex controller for the lightning component LC34_RectoValorisation
   Used to Display a table on the Fiche de synthèse where the user can modify some fields
   Test Class: LC34_RectoValorisation_Controller_Test 89%
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   03/07/2018   Johny Kassis      Created
   24/07/2018   Johny Kassis      added the sections where the field Budget_Realise__c is Used.
   03/09/2018    Jacques Akiki	   Update in the function UpdateFDS where it is possible to treat visualize null values as empty space instead of zeros.
   06/09/2018   Rita Mattar       Set the values of the SaisieRef that weren't changed with the values of Budget 2019 and color the manually changed values of the SaisieRef in orange
   --------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC34_RectoValorisation_Controller {

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: this function use the custom setting CS02_FDS_ValorisationRecto__c to query the fields of the fiche de synthèse and create a list of Wrapper_RectoValorisation
       Used to display the field values in the lightning component
       Inputs: Id
       Returns: List of Wrapper_RectoValorisation
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<Wrapper_RectoValorisation> CreateWrappers(Id FicheId){
        //query all the records of the custom setting CS02_FDS_ValorisationRecto__c
        List<CS02_FDS_ValorisationRecto__c> allWrap = [SELECT Title1__c, Title__c, Realise__c, Budget__c, Saisie__c, Offre__c, line__c, rowspan__c, editable__c, symbol__c, Ecart__c
                                                       FROM CS02_FDS_ValorisationRecto__c ];

        List<fiche_de_synthese__c> Lfds = [SELECT tech_previous_changes__c
                                           FROM fiche_de_synthese__c
                                           WHERE id =: FicheId LIMIT 1];

        List<String> fieldNames = new List<String>();// List used to store all the fields API names of the Fiche_de_synthese__c
        List<String> fieldNames1 = new List<String>();// List used to store all the fields API names of the budget N
        List<String> fieldNames2 = new List<String>();// List used to store all the fields API names of the budget N-1
        List<String> fieldNames3 = new List<String>();// List used to store all the fields API names Ecart

        // loop on the records to get all the API names of the fields that will be used
        for(CS02_FDS_ValorisationRecto__c cust : allWrap) {
            if(cust.Realise__c != null) {
                fieldNames2.add(cust.Realise__c); // add the API name that is contained in the field Realise__c
            }
            if(cust.Budget__c != null) {
                fieldNames1.add(cust.Budget__c); // add the API name that is contained in the field Budget__c
            }
            if(cust.Saisie__c != null) {
                fieldNames.add(cust.Saisie__c); // add the API name that is contained in the field Saisie__c
            }
            if(cust.Offre__c != null) {
                fieldNames.add(cust.Offre__c); // add the API name that is contained in the field Offre__c
            }
            if(cust.Ecart__c != null) {
                fieldNames3.add(cust.Ecart__c); //add the API name that is contained in the field Ecart__c
            }

        }

        //use the list of API names  in the list fieldNames that was filled and the ID passed in the function's argument to query the Fiche_de_synthese__c and its fields
        Fiche_de_synthese__c ficheDeSynt = Database.query('select ' + string.join(fieldNames, ',') + ' , Budget__c,Budget__r.id,Budget_Realise__c,Budget_Realise__r.id from Fiche_de_synthese__c where  ID= \'' + FicheId + '\'');
        Fiche_de_synthese__c ficheDeSynt1 = Database.query('select ' + string.join(fieldNames3, ',') + ' , Budget__c,Budget__r.id,Budget_Realise__c,Budget_Realise__r.id from Fiche_de_synthese__c where  ID= \'' + FicheId + '\'');

        // if the FDS has a related budget
        Budget__c budg = new Budget__c();
        Budget__c budg2 = new Budget__c();
        if((ficheDeSynt.Budget__c != null) && (ficheDeSynt.Budget__r.Id != null)) {
            //Added By Jimmy for ApexSOQLInjection
            String fdsBudgetId = ficheDeSynt.Budget__r.id;
            String budgQueryEscaped = String.escapeSingleQuotes('select ' + string.join(fieldNames1, ',') + ',AnneeBudget__c  from Budget__c where  ID=:fdsBudgetId');
            //query the budget with its field
            budg = Database.query(budgQueryEscaped);
        }
        if((ficheDeSynt.Budget_Realise__c != null) && (ficheDeSynt.Budget_Realise__r.Id != null)) {
            //Added By Jimmy for ApexSOQLInjection
            String fdsBudgetRealiseId = ficheDeSynt.Budget_Realise__r.id;
            String budg2QueryEscaped = String.escapeSingleQuotes('select ' + string.join(fieldNames2, ',') + ',AnneeBudget__c  from Budget__c where  ID=:fdsBudgetRealiseId');
            //query the budget with its field
            budg2 = Database.query(budg2QueryEscaped);
        }

        //List of wrappers Wrapper_RectoValorisation that is going to be returned
        List<Wrapper_RectoValorisation> wrappers = new List<Wrapper_RectoValorisation>();

        // Loop over the records of the custom setting CS02_FDS_ValorisationRecto__c to fill the list wrappers
        // each record in the custom setting CS02_FDS_ValorisationRecto__c corresponds to a wrapper "Wrapper_RectoValorisation" and each wrapper corresponds to a line in the table
        for(CS02_FDS_ValorisationRecto__c cust : allWrap) {
            Wrapper_RectoValorisation wrp = new Wrapper_RectoValorisation();// wrapper used to fill the list
            if(cust.Title1__c != null) {
                wrp.Title1 = cust.Title1__c;// enter the value of the variable Title1  of the wrapper using the field Title1__c of the custom setting
            }

            if(cust.Title__c != null) {
                wrp.Title = cust.Title__c;// enter the value of the variable Title  of the wrapper using the field Title__c of the custom setting
            }

            if(cust.Realise__c != null) {
                wrp.Realise = (Decimal)budg2.get(cust.Realise__c);// enter the value of the variable Realise  of the wrapper using the field Realise__c of the custom setting and the queried budget
                wrp.ApiNameRealise = cust.Realise__c;// enter the value of the variable ApiNameRealise  of the wrapper using the field Realise__c of the custom setting
            }

            if(cust.Budget__c != null) {
                wrp.Budget = (Decimal)budg.get(cust.Budget__c);// enter the value of the variable Budget  of the wrapper using the field Budget__c of the custom setting and the queried budget
                wrp.ApiNameBudget = cust.Budget__c;// enter the value of the variable ApiNameBudget  of the wrapper using the field Budget__c of the custom setting
            }

            if(cust.Saisie__c != null) {
                wrp.Saisie = (Decimal)ficheDeSynt.get(cust.Saisie__c);// enter the value of the variable Saisie  of the wrapper using the value of the field who's API name is contained in the field Saisie__c of the custom setting and the queried FDS
                wrp.ApiNameSaisie = cust.Saisie__c;  // enter the value of the variable ApiNameSaisie  of the wrapper using the field Saisie__c of the custom setting
            }
            if(cust.Offre__c != null) {
                wrp.Offre = (Decimal)ficheDeSynt.get(cust.Offre__c); // enter the value of the variable Offre  of the wrapper using the value of the field who's API name is contained in the field Offre__c of the custom setting and the queried FDS
                wrp.ApiNameOffre = cust.Offre__c;// enter the value of the variable ApiNameOffre  of the wrapper using the field Offre__c of the custom setting
            }
            if(cust.Ecart__c != null) {
                wrp.Ecart = (Decimal)ficheDeSynt1.get(cust.Ecart__c); // enter the value of the variable Offre  of the wrapper using the value of the field who's API name is contained in the field Ecart__c of the custom setting and the queried FDS
                wrp.ApiNameEcart = cust.Ecart__c;// enter the value of the variable ApiNameEcart  of the wrapper using the field Ecart__c of the custom setting
            }
            if(cust.line__c != null) {
                wrp.lineNumber = cust.line__c.intValue();// enter the value of the variable lineNumber  of the wrapper using the field line__c of the custom setting
            }

            if(cust.rowspan__c != null) {
                wrp.rowspan = cust.rowspan__c.intValue();  // enter the value of the variable rowspan  of the wrapper using the field rowspan__c of the custom setting
            }
            if(cust.editable__c != null) {

                wrp.editable = cust.editable__c; // enter the value of the variable editable  of the wrapper using the field editable__c of the custom setting
            }
            if(cust.symbol__c != null) {
                List<String> symbols = cust.symbol__c.split('/');// enter the value of the variables symbol1, symbol2, symbol3 and symbol4  of the wrapper using the field symbol__c of the custom setting
                wrp.symbol1 = symbols[0];
                wrp.symbol2 = symbols[1];
                wrp.symbol3 = symbols[2];
                wrp.symbol4 = symbols[3];
            }

            wrp.budgetYear = String.valueOf(budg.AnneeBudget__c);// set the year of the budget [N]
            wrp.realiseYear = String.valueOf(budg2.AnneeBudget__c);// set the year of the Réalisé[N-1]

            if(Lfds[0].tech_previous_changes__c != null) {
                wrp.PreviousChanges  = Lfds[0].tech_previous_changes__c;
            } else {
                wrp.PreviousChanges = ',';
            }
            wrappers.add(wrp);// add the created wrapper to the list of wrappers
        }
        //sort the list of wrappers using function implemented in the Wrapper_RectoValorisation class
        wrappers.sort();
        //return the list

        return wrappers;
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: this function is used to Update the FDS
       Inputs: String apiToFieldVal, String FicheId
       Returns: List of Strings
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<String> UpdateFDS(String apiToFieldVal, String FicheId, string ListOFwrapperJSON){
        system.debug('------>' + ListOFwrapperJSON);
        List<Wrapper_RectoValorisation> ListOFwrapper = (List<Wrapper_RectoValorisation>)System.JSON.deserialize(ListOFwrapperJSON, List<Wrapper_RectoValorisation> .class);
        List<fiche_de_synthese__c> Lfds = [SELECT tech_previous_changes__c
                                           FROM fiche_de_synthese__c
                                           WHERE id =: FicheId LIMIT 1];
        String ChangedFields = Lfds[0].tech_previous_changes__c;
        if(ChangedFields == null) {
            ChangedFields = ',';
        }
        // deserialize the string apiToFieldVal to have a list of Wrapper_ApiToValue which contains the API name of the field and it's updated value
        if(apiToFieldVal.contains('"FieldValue":""')) {
            apiToFieldVal = apiToFieldVal.replace('"FieldValue":""', '"FieldValue":"-999999999"' );// we are assuming that the user will never use this value as input
        }
        List<Wrapper_ApiToValue> listofwrp = (List<Wrapper_ApiToValue>) Json.deserialize(apiToFieldVal,  List<Wrapper_ApiToValue> .class);

        List<String> returnArg = new  List<String>();// list that's going to be returned
        List<String> apiNames = new List<String>();// List that's going to contain all the API names of the field and will be used in the query

        List<String> apiNames_Saisie = new List<String>();// list of the api names of the fields that contain the word saisie
        List<string> apiNames_OffreA1 = new List<String>();//// list of the api names of the fields that contain OffreA1
        Map<String, decimal> mapAPIValue = new  Map<String, decimal>();
        //loop on the list of wrappers to add the API names to the List
        For(Wrapper_ApiToValue wrapper1: listofwrp){
            if(wrapper1.ApiName != null) {
                apiNames.add(wrapper1.ApiName);
            }// add the API names to the List

            if(wrapper1.ApiName.contains('Saisie') || wrapper1.ApiName.contains('OffreA1')) {
                if(wrapper1.ApiName.contains('Saisie')) {
                    apiNames_Saisie.add(wrapper1.ApiName);
                    mapAPIValue.put(wrapper1.ApiName, wrapper1.FieldValue);
                }
                if(ChangedFields.contains(wrapper1.ApiName) == false && wrapper1.FieldValue<> -999999999) {
                    ChangedFields = ChangedFields + wrapper1.ApiName + ',';
                }
                if(ChangedFields.contains(wrapper1.ApiName) == true && wrapper1.FieldValue == -999999999) {
                    String RemoveFromChange;
                    RemoveFromChange = wrapper1.ApiName + ',';
                    ChangedFields = ChangedFields.replace(RemoveFromChange, '');
                    apiNames.remove(apiNames.indexOf(wrapper1.ApiName));
                }
            }
        }

        Integer CountS = 0;
        for(Wrapper_RectoValorisation wrapper : ListOFwrapper) {
            if((mapAPIValue.get(wrapper.ApiNameSaisie) == -999999999 || wrapper.Saisie == wrapper.Budget) && wrapper.editable == true) {
                CountS = CountS + 1;
            }
        }
        if(apiNames_Saisie != NULL && apiNames_Saisie.size() > 0) {
            for(Wrapper_RectoValorisation wrapper : ListOFwrapper) {
                if((wrapper.Saisie != wrapper.Budget) && (ChangedFields.contains(wrapper.ApiNameSaisie) == false) && (wrapper.editable == true)) {
                    if(CountS == 42) {
                        wrapper.Saisie = null;
                    } else {
                        wrapper.Saisie = wrapper.Budget;
                    }
                    Wrapper_ApiToValue wrp = new Wrapper_ApiToValue();
                    wrp.ApiName = wrapper.ApiNameSaisie;
                    wrp.FieldValue = wrapper.Saisie;
                    listofwrp.add(wrp);
                    if(!apiNames.contains(wrp.ApiName)) {
                        apiNames.add(wrp.ApiName);
                    }
                }
            }
        }
        list<Wrapper_ApiToValue> tempList = new list<Wrapper_ApiToValue>();
        tempList.addall(listofwrp);
        For(Wrapper_ApiToValue wrapper1: tempList){
            if(wrapper1.ApiName.contains('Saisie') && wrapper1.FieldValue == -999999999 && ChangedFields.contains('Saisie') && apiNames.contains(wrapper1.ApiName)) {
                apiNames.remove(apiNames.indexOf(wrapper1.ApiName));
                listofwrp.remove(listofwrp.indexOf(wrapper1));
            }
        }
        Boolean bool = false;
        for(Wrapper_RectoValorisation wrapper : ListOFwrapper) {
            if((!mapAPIValue.keyset().contains(wrapper.ApiNameSaisie) && Wrapper.Saisie<> null  && wrapper.Budget<> null && (ChangedFields.contains(wrapper.ApiNameSaisie) == false) && (wrapper.editable == true))
               || (mapAPIValue.get(wrapper.ApiNameSaisie) == -999999999 && Wrapper.Saisie == Wrapper.Budget && wrapper.Budget<> null && CountS != 42 && (ChangedFields.contains(wrapper.ApiNameSaisie) == false) && (wrapper.editable == true) )) {
                bool = true;
            }
        }
        if(bool) {
            for(Wrapper_RectoValorisation wrapper : ListOFwrapper) {
                if(wrapper.Budget<> null && (ChangedFields.contains(wrapper.ApiNameSaisie) == false) && (wrapper.editable == true) && apiNames_Saisie != NULL) {
                    wrapper.Saisie = wrapper.Budget;
                    Wrapper_ApiToValue wrp = new Wrapper_ApiToValue();
                    wrp.ApiName = wrapper.ApiNameSaisie;
                    wrp.FieldValue = wrapper.Saisie;
                    listofwrp.add(wrp);
                    if(!apiNames.contains(wrp.ApiName)) {
                        apiNames.add(wrp.ApiName);
                    }
                }
            }
        }

        try // try catch is used to detect the error and transmit the error message to the component so it could be displayed to the user
        {
            //use the list of API names  in the list apiNames and the ID passed in the function's argument to query the Fiche_de_synthese__c and the needed fields
            String quer = '';
            if(string.join(apiNames, ',') != '') {
                quer = string.join(apiNames, ',') + ',';
            }
            system.debug(quer);
            Fiche_de_synthese__c ficheDeSynt = Database.query('select ' + quer + 'tech_previous_changes__c ,Name  from Fiche_de_synthese__c where  ID= \'' + FicheId + '\'');
            For(Wrapper_ApiToValue wrp: listofwrp){
                if(wrp.FieldValue == -999999999) { // this value is used to solve the deserialization problem of null values
                    wrp.FieldValue = null;
                }
                System.Debug('ChangedFields: ' + ChangedFields);
                ficheDeSynt.put(wrp.ApiName, wrp.FieldValue);// update the value of the fields using the list of wrappers that contains the API name and the value
                ficheDeSynt.tech_previous_changes__c = ChangedFields;
            }

            Update ficheDeSynt; // update the record
            returnArg.add('OK');// add to the list of String that is going to be return the String 'OK'
            returnArg.add(ficheDeSynt.Name);// and th name of the record used for the toast message

            return returnArg;// return the list
        }
        Catch(Exception e){
            system.debug('Message()' + e.getMessage());
            //If the error is on the same record, the message is similar to this:
            //error on Update failed. First exception on row 0 with id ;
            //first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Vous ne pouvez pas modifier
            //cette fiche de synthèse car l'opportunité est à l'étape réalisation.: []

            //We only need to get the part between the first , and : []
            string errorString  = e.getMessage().substringAfter(',');
            errorString = errorString.substringBefore(': []');

            //If the error is on the parent record, the message is similar to this:
            //Update failed. First exception on row 0 with id ;
            //first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, FicheDeSyntheseAfterUpdate:
            //execution of AfterUpdate caused by: System.DmlException: Update failed.
            //First exception on row 0 with id 0067Y00000JoV6GQAV; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION,
            //Pour une opportunité mère de type &quot;SPU&quot;, la nature de l'offre doit être égale à &quot;Solution point unique (SPU)&quot;: []
            //Class.AP30_UpdateCAEcartMBrute.UpdateValues: line 100, column 1 Trigger.FicheDeSyntheseAfterUpdate: line 28, column 1: []

            //The string will contain another 'failed', so we retake the part after the first ,
            if(errorString.contains('failed')) {
                errorString  = errorString.substringAfter(',');
            }

            //To replace &quot; with '
            errorString = String.join(errorString.split('&quot;'), '\'');

            system.debug('@@@ JK errorString' + errorString);
            returnArg.add('L\'erreur suivante s\'est produite: ' + errorString);// if an error occured, add the error message to the list

            return returnArg;// return the list
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Jacques Akiki
       Company: EI-Technologies
       Description: this function is used to Update the FDS
       Inputs: String apiToFieldVal, String FicheId
       Returns: List of Strings
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static Boolean checkUserProfile(){
        User usr = [SELECT id, profileId, profile.name FROM USER WHERE id =:userInfo.getUserId()];
        if(!Label.NotEditFDS.contains(',' + usr.profile.name + ',')) {
            return true;
        } else {
            return false;
        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Jacques Akiki
       Company: EI-Technologies
       Description: this function is used to put ecart to 0 on FDS while changing offer values
       Inputs: id of fds
       Returns: String
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static String updateEcarttoZero(Id FicheId){
        System.debug('method entry');
        List<CS02_FDS_ValorisationRecto__c> allWrap = [SELECT Budget__c, Saisie__c
                                                       FROM CS02_FDS_ValorisationRecto__c
                                                       WHERE editable__c = true];
        List<String> fieldNames = new List<String>();// List used to store all the fields API names of the Fiche_de_synthese__c

        // loop on the records to get all the API names of the fields that will be used
        for(CS02_FDS_ValorisationRecto__c cust : allWrap) {
            if(cust.Budget__c != null) {
                fieldNames.add('Budget__r.' + cust.Budget__c); // add the API name that is contained in the field Budget__c

            }
            if(cust.Saisie__c != null) {
                fieldNames.add(cust.Saisie__c); // add the API name that is contained in the field Saisie__c
            }
        }
        fieldNames.add('Budget__r.BudgetNP2MainOeuvreInterne__c');
        fieldNames.add('Budget__r.BudgetNP3MainOeuvreInterne__c');
        fieldNames.add('Budget__r.BudgetNP6MainOeuvreInterne__c');
        System.debug('Field names:  ' + fieldNames);
        List<Fiche_de_synthese__c> listFDS =  Database.query(String.escapeSingleQuotes('select id,' + string.join(fieldNames, ',') + ' from Fiche_de_synthese__c where  id=:FicheId'));
        System.debug('list FDS : ' + listFDS);
        if(listFDS != NULL && listFDS.size() > 0) {
            Fiche_de_synthese__c fds = listFDS[0];
            Boolean budget_Corrige_vide = (fds.SaisieRefP2Fournituresetpetitsmat__c == NULL && fds.SaisieRefP2Electricite__c == NULL && fds.SaisieRefP2EauProduitsTrait__c == NULL && fds.SaisieRefP2STControlesReglem__c == NULL && fds.SaisieRefP2STEntretienCompteurs__c == NULL && fds.SaisieRefP2STGECogeneration__c == NULL && fds.SaisieRefP2EtudesDemarrage__c == NULL && fds.SaisieRefP2Amortissements__c == NULL && fds.SaisieRefP2AutresChargesEtProduits__c == NULL && fds.SaisieRefP3VentesServices__c == NULL && fds.SaisieRefP3AchatsExternes__c == NULL && fds.SaisieRefP3Autreschargesetproduits__c == NULL && fds.SaisieRefP4Investissements__c == NULL && fds.SaisieRefP4VentesServices__c == NULL && fds.SaisieRefP4Amortissements__c == NULL && fds.SaisieRefP4Autreschargesetproduits__c == NULL && fds.SaisieRefP6VentesServices__c == NULL && fds.SaisieRefP6AchatsExternes__c == NULL && fds.SaisieRefP6Autreschargesetproduits__c == NULL && fds.SaisieRefP2STTraitementEau__c == NULL && fds.SaisieRefP2STMultiservices__c == NULL && fds.SaisieRefP2STAutresPrestations__c == NULL && fds.SaisieRefP2SousTraitanceInterne__c == NULL && fds.SaisieRefP2LocationsEntretien__c == NULL && fds.SaisieRefP2Telesurveillance__c == NULL && fds.SaisieRefP1Investissements__c == NULL && fds.SaisieRefP1VentesServices__c == NULL && fds.SaisieRefP1AchatsEnergieGaz__c == NULL && fds.SaisieRefP1AchatsEnergieFuel__c == NULL && fds.SaisieRefP1AchatsEnergieCharbon__c == NULL && fds.SaisieRefP1AchatsEnergieBiomasse__c == NULL && fds.SaisieRefP1AchatsEnergieElectricite__c == NULL && fds.SaisieRefP1AchatsAutresEnergies__c == NULL && fds.SaisieRefP1Amortissements__c == NULL && fds.SaisieRefP1AutresChargesEtProduits__c == NULL && fds.SaisieRefP2Investissements__c == NULL && fds.SaisieRefP2VentesServices__c == NULL && fds.SaisieRefMainOeuvreDontNbHeureP2__c == NULL && fds.SaisieRefMainOeuvreDontNbHeureP3__c == NULL && fds.SaisieRefMainOeuvreDontNbHeureP6__c == NULL && fds.SaisieRefMainOeuvreValorisationTHO__c == NULL && fds.SaisieRefMainOeuvreEffectifDedie__c == NULL);
            if(!budget_Corrige_vide) {
                fds.OffreA1P2Fournituresetpetitsmat__c = (fds.SaisieRefP2Fournituresetpetitsmat__c == NULL?0 : fds.SaisieRefP2Fournituresetpetitsmat__c);
                fds.OffreA1P2Electricite__c = (fds.SaisieRefP2Electricite__c == NULL?0 : fds.SaisieRefP2Electricite__c);
                fds.OffreA1P2EauProduitsTrait__c = (fds.SaisieRefP2EauProduitsTrait__c == NULL?0 : fds.SaisieRefP2EauProduitsTrait__c);
                fds.OffreA1P2STControlesReglem__c = (fds.SaisieRefP2STControlesReglem__c == NULL?0 : fds.SaisieRefP2STControlesReglem__c);
                fds.OffreA1P2STEntretienCompteurs__c = (fds.SaisieRefP2STEntretienCompteurs__c == NULL?0 : fds.SaisieRefP2STEntretienCompteurs__c);
                fds.OffreA1P2STGECogeneration__c = (fds.SaisieRefP2STGECogeneration__c == NULL?0 : fds.SaisieRefP2STGECogeneration__c);
                fds.OffreA1P2EtudesDemarrage__c = (fds.SaisieRefP2EtudesDemarrage__c == NULL?0 : fds.SaisieRefP2EtudesDemarrage__c);
                fds.OffreA1P2Amortissements__c = (fds.SaisieRefP2Amortissements__c == NULL?0 : fds.SaisieRefP2Amortissements__c);
                fds.OffreA1P2AutresChargesEtProduits__c = (fds.SaisieRefP2AutresChargesEtProduits__c == NULL?0 : fds.SaisieRefP2AutresChargesEtProduits__c);
                fds.OffreA1P3VentesServices__c = (fds.SaisieRefP3VentesServices__c == NULL?0 : fds.SaisieRefP3VentesServices__c);
                fds.OffreA1P3AchatsExternes__c = (fds.SaisieRefP3AchatsExternes__c == NULL?0 : fds.SaisieRefP3AchatsExternes__c);
                fds.OffreA1P3Autreschargesetproduits__c = (fds.SaisieRefP3Autreschargesetproduits__c == NULL?0 : fds.SaisieRefP3Autreschargesetproduits__c);
                fds.OffreA1P4Investissements__c = (fds.SaisieRefP4Investissements__c == NULL?0 : fds.SaisieRefP4Investissements__c);
                fds.OffreA1P4VentesServices__c = (fds.SaisieRefP4VentesServices__c == NULL?0 : fds.SaisieRefP4VentesServices__c);
                fds.OffreA1P4Amortissements__c = (fds.SaisieRefP4Amortissements__c == NULL?0 : fds.SaisieRefP4Amortissements__c);
                fds.OffreA1P4Autreschargesetproduits__c = (fds.SaisieRefP4Autreschargesetproduits__c == NULL?0 : fds.SaisieRefP4Autreschargesetproduits__c);
                fds.OffreA1P6VentesServices__c = (fds.SaisieRefP6VentesServices__c == NULL?0 : fds.SaisieRefP6VentesServices__c);
                fds.OffreA1P6AchatsExternes__c = (fds.SaisieRefP6AchatsExternes__c == NULL?0 : fds.SaisieRefP6AchatsExternes__c);
                fds.OffreA1P6Autreschargesetproduits__c = (fds.SaisieRefP6Autreschargesetproduits__c == NULL?0 : fds.SaisieRefP6Autreschargesetproduits__c);
                fds.OffreA1P2STTraitementEau__c = (fds.SaisieRefP2STTraitementEau__c == NULL?0 : fds.SaisieRefP2STTraitementEau__c);
                fds.OffreA1P2STMultiservices__c = (fds.SaisieRefP2STMultiservices__c == NULL?0 : fds.SaisieRefP2STMultiservices__c);
                fds.OffreA1P2STAutresPrestations__c = (fds.SaisieRefP2STAutresPrestations__c == NULL?0 : fds.SaisieRefP2STAutresPrestations__c);
                fds.OffreA1P2SousTraitanceInterne__c = (fds.SaisieRefP2SousTraitanceInterne__c == NULL?0 : fds.SaisieRefP2SousTraitanceInterne__c);
                fds.OffreA1P2LocationsEntretien__c = (fds.SaisieRefP2LocationsEntretien__c == NULL?0 : fds.SaisieRefP2LocationsEntretien__c);
                fds.OffreA1P2Telesurveillance__c = (fds.SaisieRefP2Telesurveillance__c == NULL?0 : fds.SaisieRefP2Telesurveillance__c);
                fds.OffreA1P1Investissements__c = (fds.SaisieRefP1Investissements__c == NULL?0 : fds.SaisieRefP1Investissements__c);
                fds.OffreA1P1VentesServices__c = (fds.SaisieRefP1VentesServices__c == NULL?0 : fds.SaisieRefP1VentesServices__c);
                fds.OffreA1P1AchatsEnergieGaz__c = (fds.SaisieRefP1AchatsEnergieGaz__c == NULL?0 : fds.SaisieRefP1AchatsEnergieGaz__c);
                fds.OffreA1P1AchatsEnergieFuel__c = (fds.SaisieRefP1AchatsEnergieFuel__c == NULL?0 : fds.SaisieRefP1AchatsEnergieFuel__c);
                fds.OffreA1P1AchatsEnergieCharbon__c = (fds.SaisieRefP1AchatsEnergieCharbon__c == NULL?0 : fds.SaisieRefP1AchatsEnergieCharbon__c);
                fds.OffreA1P1AchatsEnergieBiomasse__c = (fds.SaisieRefP1AchatsEnergieBiomasse__c == NULL?0 : fds.SaisieRefP1AchatsEnergieBiomasse__c);
                fds.OffreA1P1AchatsEnergieElectricite__c = (fds.SaisieRefP1AchatsEnergieElectricite__c == NULL?0 : fds.SaisieRefP1AchatsEnergieElectricite__c);
                fds.OffreA1P1AchatsAutresEnergies__c = (fds.SaisieRefP1AchatsAutresEnergies__c == NULL?0 : fds.SaisieRefP1AchatsAutresEnergies__c);
                fds.OffreA1P1Amortissements__c = (fds.SaisieRefP1Amortissements__c == NULL?0 : fds.SaisieRefP1Amortissements__c);
                fds.OffreA1P1AutresChargesEtProduits__c = (fds.SaisieRefP1AutresChargesEtProduits__c == NULL?0 : fds.SaisieRefP1AutresChargesEtProduits__c);
                fds.OffreA1P2Investissements__c = (fds.SaisieRefP2Investissements__c == NULL?0 : fds.SaisieRefP2Investissements__c);
                fds.OffreA1P2VentesServices__c = (fds.SaisieRefP2VentesServices__c == NULL?0 : fds.SaisieRefP2VentesServices__c);
                fds.OffreA1MainOeuvreDontNbHeureP2__c = (fds.SaisieRefMainOeuvreDontNbHeureP2__c == NULL?0 : fds.SaisieRefMainOeuvreDontNbHeureP2__c);
                fds.OffreA1MainOeuvreDontNbHeureP3__c = (fds.SaisieRefMainOeuvreDontNbHeureP3__c == NULL?0 : fds.SaisieRefMainOeuvreDontNbHeureP3__c);
                fds.OffreA1MainOeuvreDontNbHeureP6__c = (fds.SaisieRefMainOeuvreDontNbHeureP6__c == NULL?0 : fds.SaisieRefMainOeuvreDontNbHeureP6__c);
                fds.OffreA1MainOeuvreValorisationTHO__c = (fds.SaisieRefMainOeuvreValorisationTHO__c == NULL?0 : fds.SaisieRefMainOeuvreValorisationTHO__c);
                fds.OffreA1MainOeuvreEffectifDedie__c = (fds.SaisieRefMainOeuvreEffectifDedie__c == NULL?0 : fds.SaisieRefMainOeuvreEffectifDedie__c);

                try {
                    update fds;
                }
                Catch(Exception e){
                    if(e.getMessage().contains('_EXCEPTION,')) {
                        if(e.getMessage().split('_EXCEPTION,')[1].contains(': ')) {
                            return e.getMessage().split('_EXCEPTION,')[1].split(': ')[0];
                        } else {
                            return e.getMessage().split('_EXCEPTION,')[1];
                        }
                    } else {
                        return e.getMessage();
                    }
                }
            } else {
                fds.OffreA1P2Fournituresetpetitsmat__c = (fds.Budget__r.BudgetNP2Fournituresetpetitsmat__c == NULL?0 : fds.Budget__r.BudgetNP2Fournituresetpetitsmat__c);
                fds.OffreA1P2Electricite__c = (fds.Budget__r.BudgetNP2Electricite__c == NULL?0 : fds.Budget__r.BudgetNP2Electricite__c);
                fds.OffreA1P2EauProduitsTrait__c = (fds.Budget__r.BudgetNP2EauProduitsTrait__c == NULL?0 : fds.Budget__r.BudgetNP2EauProduitsTrait__c);
                fds.OffreA1P2STControlesReglem__c = (fds.Budget__r.BudgetNP2STControlesReglem__c == NULL?0 : fds.Budget__r.BudgetNP2STControlesReglem__c);
                fds.OffreA1P2STEntretienCompteurs__c = (fds.Budget__r.BudgetNP2STEntretienCompteurs__c == NULL?0 : fds.Budget__r.BudgetNP2STEntretienCompteurs__c);
                fds.OffreA1P2STGECogeneration__c = (fds.Budget__r.BudgetNP2STGECogeneration__c == NULL?0 : fds.Budget__r.BudgetNP2STGECogeneration__c);
                fds.OffreA1P2EtudesDemarrage__c = (fds.Budget__r.BudgetNP2EtudesDemarrage__c == NULL?0 : fds.Budget__r.BudgetNP2EtudesDemarrage__c);
                fds.OffreA1P2Amortissements__c = (fds.Budget__r.BudgetNP2Amortissements__c == NULL?0 : fds.Budget__r.BudgetNP2Amortissements__c);
                fds.OffreA1P2AutresChargesEtProduits__c = (fds.Budget__r.BudgetNP2AutresChargesEtProduits__c == NULL?0 : fds.Budget__r.BudgetNP2AutresChargesEtProduits__c);
                fds.OffreA1P3VentesServices__c = (fds.Budget__r.BudgetNP3VentesServices__c == NULL?0 : fds.Budget__r.BudgetNP3VentesServices__c);
                fds.OffreA1P3AchatsExternes__c = (fds.Budget__r.BudgetNP3AchatsExternes__c == NULL?0 : fds.Budget__r.BudgetNP3AchatsExternes__c);
                fds.OffreA1P3Autreschargesetproduits__c = (fds.Budget__r.BudgetNP3Autreschargesetproduits__c == NULL?0 : fds.Budget__r.BudgetNP3Autreschargesetproduits__c);
                fds.OffreA1P4Investissements__c = (fds.Budget__r.BudgetNP4Investissements__c == NULL?0 : fds.Budget__r.BudgetNP4Investissements__c);
                fds.OffreA1P4VentesServices__c = (fds.Budget__r.BudgetNP4VentesServices__c == NULL?0 : fds.Budget__r.BudgetNP4VentesServices__c);
                fds.OffreA1P4Amortissements__c = (fds.Budget__r.BudgetNP4Amortissements__c == NULL?0 : fds.Budget__r.BudgetNP4Amortissements__c);
                fds.OffreA1P4Autreschargesetproduits__c = (fds.Budget__r.BudgetNP4Autreschargesetproduits__c == NULL?0 : fds.Budget__r.BudgetNP4Autreschargesetproduits__c);
                fds.OffreA1P6VentesServices__c = (fds.Budget__r.BudgetNP6VentesServices__c == NULL?0 : fds.Budget__r.BudgetNP6VentesServices__c);
                fds.OffreA1P6AchatsExternes__c = (fds.Budget__r.BudgetNP6AchatsExternes__c == NULL?0 : fds.Budget__r.BudgetNP6AchatsExternes__c);
                fds.OffreA1P6Autreschargesetproduits__c = (fds.Budget__r.BudgetNP6Autreschargesetproduits__c == NULL?0 : fds.Budget__r.BudgetNP6Autreschargesetproduits__c);
                fds.OffreA1P2STTraitementEau__c = (fds.Budget__r.BudgetNP2STTraitementEau__c == NULL?0 : fds.Budget__r.BudgetNP2STTraitementEau__c);
                fds.OffreA1P2STMultiservices__c = (fds.Budget__r.BudgetNP2STMultiservices__c == NULL?0 : fds.Budget__r.BudgetNP2STMultiservices__c);
                fds.OffreA1P2STAutresPrestations__c = (fds.Budget__r.BudgetNP2STAutresPrestations__c == NULL?0 : fds.Budget__r.BudgetNP2STAutresPrestations__c);
                fds.OffreA1P2SousTraitanceInterne__c = (fds.Budget__r.BudgetNP2SousTraitanceInterne__c == NULL?0 : fds.Budget__r.BudgetNP2SousTraitanceInterne__c);
                fds.OffreA1P2LocationsEntretien__c = (fds.Budget__r.BudgetNP2LocationsEntretien__c == NULL?0 : fds.Budget__r.BudgetNP2LocationsEntretien__c);
                fds.OffreA1P2Telesurveillance__c = (fds.Budget__r.BudgetNP2Telesurveillance__c == NULL?0 : fds.Budget__r.BudgetNP2Telesurveillance__c);
                fds.OffreA1P1Investissements__c = (fds.Budget__r.BudgetNP1Investissements__c == NULL?0 : fds.Budget__r.BudgetNP1Investissements__c);
                fds.OffreA1P1VentesServices__c = (fds.Budget__r.BudgetNP1VentesServices__c == NULL?0 : fds.Budget__r.BudgetNP1VentesServices__c);
                fds.OffreA1P1AchatsEnergieGaz__c = (fds.Budget__r.BudgetNP1AchatsEnergieGaz__c == NULL?0 : fds.Budget__r.BudgetNP1AchatsEnergieGaz__c);
                fds.OffreA1P1AchatsEnergieFuel__c = (fds.Budget__r.BudgetNP1AchatsEnergieFuel__c == NULL?0 : fds.Budget__r.BudgetNP1AchatsEnergieFuel__c);
                fds.OffreA1P1AchatsEnergieCharbon__c = (fds.Budget__r.BudgetNP1AchatsEnergieCharbon__c == NULL?0 : fds.Budget__r.BudgetNP1AchatsEnergieCharbon__c);
                fds.OffreA1P1AchatsEnergieBiomasse__c = (fds.Budget__r.BudgetNP1AchatsEnergieBiomasse__c == NULL?0 : fds.Budget__r.BudgetNP1AchatsEnergieBiomasse__c);
                fds.OffreA1P1AchatsEnergieElectricite__c = (fds.Budget__r.BudgetNP1AchatsEnergieElectricite__c == NULL?0 : fds.Budget__r.BudgetNP1AchatsEnergieElectricite__c);
                fds.OffreA1P1AchatsAutresEnergies__c = (fds.Budget__r.BudgetNP1AchatsAutresEnergies__c == NULL?0 : fds.Budget__r.BudgetNP1AchatsAutresEnergies__c);
                fds.OffreA1P1Amortissements__c = (fds.Budget__r.BudgetNP1Amortissements__c == NULL?0 : fds.Budget__r.BudgetNP1Amortissements__c);
                fds.OffreA1P1AutresChargesEtProduits__c = (fds.Budget__r.BudgetNP1AutresChargesEtProduits__c == NULL?0 : fds.Budget__r.BudgetNP1AutresChargesEtProduits__c);
                fds.OffreA1P2Investissements__c = (fds.Budget__r.BudgetNP2Investissements__c == NULL?0 : fds.Budget__r.BudgetNP2Investissements__c);
                fds.OffreA1P2VentesServices__c = (fds.Budget__r.BudgetNP2VentesServices__c == NULL?0 : fds.Budget__r.BudgetNP2VentesServices__c);
                fds.OffreA1MainOeuvreEffectifDedie__c = (fds.Budget__r.BudgetNMainOeuvreEffectifDedie__c == NULL?0 : fds.Budget__r.BudgetNMainOeuvreEffectifDedie__c);
                fds.OffreA1MainOeuvreValorisationTHO__c = (fds.Budget__r.BudgetNMainOeuvreValorisationTHO__c == NULL?0 : fds.Budget__r.BudgetNMainOeuvreValorisationTHO__c);
                fds.OffreA1MainOeuvreDontNbHeureP2__c = (fds.Budget__r.BudgetNMainOeuvreDontNbHeureP2__c == NULL?0 : fds.Budget__r.BudgetNMainOeuvreDontNbHeureP2__c);
                fds.OffreA1MainOeuvreDontNbHeureP3__c = (fds.Budget__r.BudgetNMainOeuvreDontNbHeureP3__c == NULL?0 : fds.Budget__r.BudgetNMainOeuvreDontNbHeureP3__c);
                fds.OffreA1MainOeuvreDontNbHeureP6__c = (fds.Budget__r.BudgetNMainOeuvreDontNbHeureP6__c == NULL?0 : fds.Budget__r.BudgetNMainOeuvreDontNbHeureP6__c);
                decimal tho = 0;

                decimal num2 = fds.Budget__r.BudgetNP2MainOeuvreInterne__c;
                decimal den2 = fds.Budget__r.BudgetNMainOeuvreDontNbHeureP2__c;
                decimal num3 = fds.Budget__r.BudgetNP3MainOeuvreInterne__c;
                decimal den3 = fds.Budget__r.BudgetNMainOeuvreDontNbHeureP3__c;
                decimal num6 = fds.Budget__r.BudgetNP6MainOeuvreInterne__c;
                decimal den6 = fds.Budget__r.BudgetNMainOeuvreDontNbHeureP6__c;

                if(num2 != 0 && num2 != NULL && den2 != 0 && den2 != NULL && tho == 0) {
                    tho = (num2 / den2).setScale(4);

                } else if(num3 != 0 && num3 != NULL && den3 != 0 && den3 != NULL && tho == 0) {
                    tho = (num3 / den3).setScale(4);
                } else if(num6 != 0 && num6 != NULL && den6 != 0 && den6 != NULL && tho == 0) {
                    tho = (num6 / den6).setScale(4);
                } else if(fds.OffreA1MainOeuvreValorisationTHO__c != 0) {
                    tho = fds.OffreA1MainOeuvreValorisationTHO__c;
                } else if(tho == 0) {
                    tho = 1;
                }
                fds.OffreA1MainOeuvreValorisationTHO__c = tho;
                fds.OffreA1MainOeuvreDontNbHeureP2__c = (num2 == NULL || tho == 0?0 : (num2 / tho).setScale(4));
                fds.OffreA1MainOeuvreDontNbHeureP3__c = (num3 == NULL || tho == 0?0 : (num3 / tho).setScale(4));
                fds.OffreA1MainOeuvreDontNbHeureP6__c = (num6 == NULL || tho == 0?0 : (num6 / tho).setScale(4));

                try {
                    update fds;
                }
                Catch(Exception e){
                    if(e.getMessage().contains('_EXCEPTION,')) {
                        if(e.getMessage().split('_EXCEPTION,')[1].contains(': ')) {
                            return e.getMessage().split('_EXCEPTION,')[1].split(': ')[0];
                        } else {
                            return e.getMessage().split('_EXCEPTION,')[1];
                        }
                    } else {
                        return e.getMessage();
                    }
                }
            }
        } else {
            return 'KO';
        }

        return 'OK';
    }
}