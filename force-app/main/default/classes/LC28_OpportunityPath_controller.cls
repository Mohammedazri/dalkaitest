public without sharing class LC28_OpportunityPath_controller {

    public static Contrat__c mycontrat;// Declaration of the variable that will contain the contract

    @AuraEnabled
    public static String getCurrentStage(Id FicheId){
        Opportunity myFiche = [SELECT id, stagename
                               FROM Opportunity
                               Where id =:FicheId];

        return myFiche.stagename;

    }
    @AuraEnabled
    public static boolean getUserInfo(){
        String userID = userinfo.getProfileId();
        if(userID.contains(Label.VR_AdminID) || (userID.contains(Label.VR_AdvID))) {
            return true;
        } else   {
            return false;
        }
    }
    @AuraEnabled
    public static String setfields(Id OppId, String stat, String stage, Contrat__c contratorigine, String motifPerte){
        boolean contratNotNull = false;

        Opportunity opp = [SELECT id, ZZZ_TECH_RealiseDuChemin__c, Type_pers__c, StageName, Statut__c, TechPriorValueStageName__c, CloseDate, tech_realisation__c, Motif__c, ContratOrigine__c, Tech_ModifiedAPIName__c,
                           natureOffre__c, paiementDesEnergies__c, niveauDeMaintenance__c, engagementEnergetique__c, Contrat_Genere_lookup__c, Contrat_Genere_lookup__r.DKCodeSurContrat__c
                           FROM Opportunity
                           WHERE id =:OppId ];

        List<Document_Contractuel__c> lstDocs = [SELECT id, Id_Scan__c
                                                 FROM Document_Contractuel__c
                                                 WHERE Contrat__c =: opp.ContratOrigine__c
                                                 AND NatureDocument__c =: Label.LC51_LettreResiliation];

        if(stat.equals('Perdue') && lstDocs.size() < 1) {
            return Label.LC28_PerdueSansResiliation;
        }

        if(!stat.equals('Perdue') && lstDocs.size() > 0) {
            return Label.LC28_GagneeAvecResiliation;
        }

        if(lstDocs.size() > 0) {
            List<Document_Contractuel__c> lstDocRes = [SELECT id, Id_Scan__c
                                                       FROM Document_Contractuel__c
                                                       WHERE Contrat__c =: opp.ContratOrigine__c
                                                       AND numeroPiece__c = null
                                                       AND Id_Scan__c = null];
            if(lstDocRes.size() > 0) {
                return Label.LC51_ScanObligatoire;
            }
        }

        opp.Statut__c = stat;
        opp.StageName = stage;
        opp.ZZZ_TECH_RealiseDuChemin__c = !opp.ZZZ_TECH_RealiseDuChemin__c;
        opp.tech_realisation__c = true;
        String modifiedFields = opp.Tech_ModifiedAPIName__c;

        List<Mode_Maintenance__c> lstMM = [select id, En_mode_maintenance__c from Mode_Maintenance__c limit 1];
        if(lstMM.size() > 0 && lstMM[0].En_mode_maintenance__c && stat.equals('Perdue')) {
            return Label.LC28_ModeMaintenance;
        }

        if(stat.equals('Perdue')) {
            opp.Motif__c = motifPerte;
        }

        if(opp.Type_pers__c == Label.Opp_type_Evolution && opp.StageName == Label.PV_Realisation) {
            opp.Tech_ModifiedAPIName__c = null;
        }

        Savepoint sp = Database.setSavepoint();
        try {
            if(contratorigine<> null) {
                // update the contract
                //if()
                system.debug('RENOUVELLEMENT ALAIN');
                if(opp.Statut__c == 'Gagnée') {
                    PAD.PAD_BypassTrigger += 'AP48_ContractCallouts';
                    system.debug('PAS DAPPEL');
                }
                contratorigine.Statut__c = Label.LC35_StatutContrat;
                Schema.DescribeFieldResult fieldResult = Contrat__c.Condition_de_fermeture__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for(Schema.PicklistEntry pickListVal : ple) {
                    system.debug('contratorigine.Condition_de_fermeture__c ' + contratorigine.Condition_de_fermeture__c);
                    system.debug('pickListVal.getvalue()' + pickListVal.getvalue());
                    if(pickListVal.getLabel() == contratorigine.Condition_de_fermeture__c) {
                        contratorigine.Condition_de_fermeture__c = pickListVal.getvalue();
                        system.debug('contratorigine.Condition_de_fermeture__c ' + contratorigine.Condition_de_fermeture__c);
                    }
                }
                if(contratorigine.DateFin__c < contratorigine.DatePriseEffet__c) {
                    return 'La date de fin doit être supérieure à la date d\'effet prévue sur l\'opportunité.';
                }
                contratorigine.ZZZ_Bypass_VR05_DocCont__c = true;
                contratNotNull = true;
                opp.TechPriorValueStageName__c = opp.StageName;

                //Added by Jimmy 10/01/2022 - CVS
                //Pour les renouvellements si pas de valeur sur le contrat d'origine,
                //créer un mécanisme qui renseignera les valeurs du contrat d'origine avec celles de l'opportunité de renouvellement
                //à la réalisation de l'opportunité et avant synchronisation avec Kador
                if(opp.Type_pers__c == Label.Opp_type_Renewal && opp.StageName == Label.PV_Realisation &&
                   String.isEmpty(contratorigine.DKCodeSurContrat__c)) {
                    System.debug('@@@ JK in If');
                    if(String.isEmpty(contratorigine.natureOffre__c)) {
                        contratorigine.natureOffre__c = opp.natureOffre__c;
                    }
                    if(String.isEmpty(contratorigine.engagementEnergetique__c)) {
                        contratorigine.engagementEnergetique__c = opp.engagementEnergetique__c;
                    }
                    if(String.isEmpty(contratorigine.paiementDesEnergies__c)) {
                        contratorigine.paiementDesEnergies__c = opp.paiementDesEnergies__c;
                    }
                    if(String.isEmpty(contratorigine.niveauDeMaintenance__c)) {
                        contratorigine.niveauDeMaintenance__c = opp.niveauDeMaintenance__c;
                    }
                }
                //end CVS

            }

            if(contratNotNull) {
                update opp;
                system.debug('contratorigine.Condition_de_fermeture__c ' + contratorigine.Condition_de_fermeture__c );
                update contratorigine;
            } else  {
                update opp;
            }

            //Added by CKH US C360-885
            //Suite à la réouverture d'une opportunité d'origine sur un contrat synchronisé, à la réalisation de l'opportunité, mettre une alerte
            if((opp.Type_pers__c == Label.LC28_TypeNouveau || opp.Type_pers__c == Label.Opp_type_Renewal) && opp.StageName == Label.PV_Realisation && opp.Contrat_Genere_lookup__c != null && opp.Contrat_Genere_lookup__r.DKCodeSurContrat__c != null) {
                return 'OK_Reouv_Contrat';
            }
            
            //Added By Jimmy Ano C360-475: pour les opp d'evol qui ont des doc syncro,
            //afficher un popup au user pour montrer les champs qui ne redescend pas au contrat apre realisation
            if(opp.Type_pers__c == Label.Opp_type_Evolution && opp.StageName == Label.PV_Realisation) {
                list<Document_Contractuel__c> listDocCont = [SELECT id, NumeroPiece__c, OpportuniteRattachee__c
                                                             FROM Document_Contractuel__c
                                                             WHERE OpportuniteRattachee__c =:opp.id
                                                             AND NumeroPiece__c != NULL
                                                             AND NatureDocument__c = 'DOC05'];

                if(listDocCont != null && listDocCont.size() > 0) {
                    String mylabel = '';
                    if(modifiedFields != null && modifiedFields != '') {
                        String AP25_Fields = Label.AP25_Fields;
                        List<String> lstAPI = modifiedFields.split(' ');
                        String type = 'Opportunity';  // Say,this is my object
                        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                        Set<String> fieldsForMessage = new Set<String>();
                        Schema.SObjectType oppSchema = schemaMap.get(type);
                        Map<String, Schema.SObjectField> fieldMap = oppSchema.getDescribe().fields.getMap();
                        //  System.debug('@@@ JK');
                        //   System.debug(fieldMap);
                        for(String fieldName : lstAPI) {
                            // System.debug(fieldName);
                            //if the field is used in AP25 to be sent to the contrat, we add it to show that it will not be modified
                            if(AP25_Fields.containsIgnoreCase(fieldName)) {
                                //It provides to get the object fields label.
                                fieldsForMessage.add(fieldMap.get(fieldName).getDescribe().getLabel());
                            }

                        }
                        for(String f : fieldsForMessage) {
                            mylabel = mylabel + ',' + f;
                        }
                    }

                    if(mylabel == '') {
                        return 'OK_Evol_Syncro_No_Fields';
                    }

                    return 'OK_Evol_Syncro' + mylabel;
                }
            }

            return 'OK';
        }

        catch(System.DMLException e) {
            Database.rollback(sp);
            system.debug('msg ' + e.getMessage());
            DMLException dmlExc = (DMLException) e;
            List<String> messages = new List<String>();
            for(Integer i = 0; i < dmlExc.getNumDml(); i++) {
                messages.add( dmlExc.getDmlMessage(i) );
            }
            String msg = String.join(messages, ', ');
            if(msg.contains('&quot;')) {
                msg = String.join(msg.split('&quot;'), '\"');
            }

            return msg.remove('</b>').remove('<b>').replaceAll('<br>', '. ');

        }
    }

    @AuraEnabled
    public static List<String> getselectOptions (Id OppId){
        List<String> allOpts = new list<String>();
        for(CS01_CloseOpportunityStage__c listcs : [SELECT Stage__c FROM CS01_CloseOpportunityStage__c]) {
            allOpts.add(listcs.Stage__c);
        }

        return allOpts;
    }

    /**
     * @author Alain Ghoussoub
     * @date 14/07/2020
     * @Chercher les statut possible de l'opportunité selon le type
     */
    @AuraEnabled
    public static List<String> getStatus (Id OppId){
        Opportunity opp = [SELECT id, Type_pers__c, stagename
                           FROM Opportunity
                           Where id =:OppId];
        List<String> allOpts = new list<String>();
        //Custom setting contenant type et statut de l'opportunité
        for(CS01_CloseOpportunityStat__c listcs : [SELECT Statut__c, Type__c
                                                   FROM CS01_CloseOpportunityStat__c
                                                   WHERE Type__c = : opp.Type_pers__c
                                                   AND Stage__c = : Label.PV_Realisation]) {
            String status = listcs.Statut__c;
            allOpts = status.split(';');
        }
        system.debug('allOpts ' + allOpts);

        return allOpts;
    }

    /**
     * @author Charbel Khoury Hanna
     * @date 19/01/2021
     * @Chercher les motif de perte de l'opportunité
     */
    @AuraEnabled
    public static Map<String, String> getMotifPerteValues(){
        Map<String, String> options = new Map<String, String>();

        Schema.DescribeFieldResult fieldResult = Opportunity.Motif__c.getDescribe();

        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : pValues) {

            options.put(p.getValue(), p.getLabel());
        }

        return options;
    }

    /**
     * @author Charbel Khoury Hanna
     * @date 20/01/2021
     * @Chercher le motif de perte existant sur l'opportunité
     */
    @AuraEnabled
    public static String getSelectedMotifPerte(String OppID){

        system.debug('***** id =' + OppID);

        String motif = '';

        List<Opportunity> lstOpp = [SELECT motif__c
                                    FROM Opportunity
                                    WHERE id =: OppID];
        if(lstOpp.size() > 0) {
            motif = lstOpp[0].motif__c;
        }

        return motif;
    }

    @AuraEnabled
    public static Opportunity QueryingOpportunityFields(Id OppID){
        //use the Opportunity ID to query the Opportunity and the StageName
        Opportunity opp = [SELECT id, StageName, TechPriorValueStageName__c
                           FROM Opportunity
                           WHERE id =: OppID];

        return opp;
    }

    @AuraEnabled
    public static Contrat__c getContratdOrigine(Id OppID){
        //use the Opportunity ID to query the Opportunity and the lookup field ContratOrigine__c
        Opportunity opp = [SELECT id, ContratOrigine__c, ContratOrigine__r.Motif_fermeture_contrat__c, ContratOrigine__r.Condition_de_fermeture__c, ContratOrigine__r.Datefin__c, StageName, Type_pers__c
                           FROM Opportunity
                           WHERE id =: OppID LIMIT 1
        ];

        // if the conditions are met query and return  the contract
        if(opp.Type_pers__c == Label.LC35_Renouv && (opp.ContratOrigine__r.Motif_fermeture_contrat__c == NULL ||
                                                     opp.ContratOrigine__r.Condition_de_fermeture__c == NULL ||
                                                     opp.ContratOrigine__r.Datefin__c == NULL)) {
            // use the lookup field of the Opportunity to query the related Contrat
            mycontrat = [SELECT id, name, Condition_de_fermeture__c, Motif_fermeture_contrat__c, DateFin__c, DKCodeSurContrat__c,
                         natureOffre__c, paiementDesEnergies__c, niveauDeMaintenance__c, engagementEnergetique__c
                         FROM Contrat__c
                         Where id =:opp.ContratOrigine__c
                         LIMIT 1];

            List<Document_Contractuel__c> lstDocs = [SELECT id, DatePriseEffet__c
                                                     FROM Document_Contractuel__c
                                                     WHERE Contrat__c =: opp.ContratOrigine__c
                                                     AND NatureDocument__c =: Label.LC51_LettreResiliation];
            if(lstDocs.size() > 0) {
                mycontrat.DateFin__c = lstDocs[0].DatePriseEffet__c;
            }

            // return the related Contrat
            return mycontrat;
        } else   {
            // else return null
            return null;
        }
    }

    @AuraEnabled
    public static list<WRP02_MenuPickList> GetMotifsDeFermeture(String stat){
        List<Statut_Motif__c> listSM = [SELECT MotifDeFermeture__c, APIMotif__c
                                        FROM Statut_Motif__c
                                        WHERE statut__c =:stat];
        set<string> setMF = new set<string>();
        for(Statut_Motif__c sm : listSM) {
            setMF.add(sm.APIMotif__c);
        }
        // declare a list of wrappers that will be returned
        List<WRP02_MenuPickList> motifsList = new List<WRP02_MenuPickList>();
        // get the picklist values as PicklistEntry
        List<Schema.PicklistEntry> ple = Contrat__c.Motif_fermeture_contrat__c.getDescribe().getPicklistValues();
        motifsList.add(new WRP02_MenuPickList('', ''));
        // loop on the List of PicklistEntry to fill the list of wrappers
        for(Schema.PicklistEntry f : ple) {
            if(setMF.contains(f.getValue())) {
                motifsList.add(new WRP02_MenuPickList(f.getLabel(), f.getValue()));
            }
        }

        // return the list of wrappers
        return motifsList;
    }

    @AuraEnabled
    public static list<WRP02_MenuPickList> LoadDependantConditionValues(string MotifFermetureSelected){
        //  Call the function HelperManager.GetDependentOptions and fill the mapresult:
        //  each key in this map is a value of the picklist Motif_fermeture_contrat__c and its corresponding list contains the values of the field Condition_de_fermeture__c
        Map<String, List<String>>  mapresult = HelperManager.GetDependentOptions('Contrat__c', 'Motif_fermeture_contrat__c', 'Condition_de_fermeture__c');
        system.debug('------------------------------------>' + mapresult);
        // Declare a list of strings that will contain the list of values to return
        list<string> listOfConditionsToReturn = new list<string>();
        list<WRP02_MenuPickList> listWrap = new list<WRP02_MenuPickList>();
        listWrap.add(new WRP02_MenuPickList('', ''));
        // use the chosen Value of the field Motif_fermeture_contrat__c passed as argument to fill the list
        Schema.DescribeFieldResult fieldResult = Contrat__c.Motif_fermeture_contrat__c.getDescribe();
        Schema.DescribeFieldResult fieldResult1 = Contrat__c.Condition_de_fermeture__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple) {
            if(pickListVal.getvalue() == MotifFermetureSelected) {
                MotifFermetureSelected = pickListVal.getLabel();
            }

        }
        System.debug('+++++++++++++++++++++++++' + MotifFermetureSelected);
        if(MotifFermetureSelected != null) {
            System.debug('+++++++++++++++++++++++++++++' + mapresult.get(MotifFermetureSelected));
            listOfConditionsToReturn.addAll(mapresult.get(MotifFermetureSelected));
        }

        for(String str : listOfConditionsToReturn) {
            for(Schema.PicklistEntry pickListVal : ple1) {
                if(str == pickListVal.getLabel()) {
                    WRP02_MenuPickList wrp = new WRP02_MenuPickList(pickListVal.getLabel(), pickListVal.getValue());
                    listWrap.add(wrp);
                }
            }
        }
        // retrun the list

        return listWrap;
    }
    /**
     * @author Dona Kfoury
     * @date 18/05/2020
     * @vérification si bloquer la réalisation de l'opp courante
     * @param OppID: id de l'opp courante
     * @return WRP03_TypeErreurRealisation
     */
    @AuraEnabled
    public static WRP03_TypeErreurRealisation checkIfCanRealiseOpp(Id OppID){
        WRP03_TypeErreurRealisation myWRP03 = new WRP03_TypeErreurRealisation();
        myWRP03.canRealise = true;
        List<Opportunity> listOpps = [SELECT id, Type_pers__c, EstOpportuniteMere__c, ContratOrigine__c
                                      FROM Opportunity
                                      WHERE id =:OppID];
        if(listOpps != null && listOpps.size() > 0 && listOpps[0].Type_pers__c == Label.LC35_Renouv) {
            Opportunity CurrentOpp = listOpps[0];

            //chercher les documents contractuels non synchronisés (sans numéro de pièce) ou non validés (statut A traiter) reliés au contrat d'origine de l'opportunité
            List<Document_Contractuel__c> listDocContractuels = [SELECT id, Name,  NumeroPiece__c, StatutDocument__c, NatureDocument__c
                                                                 FROM Document_Contractuel__c
                                                                 WHERE Contrat__c =: currentOpp.ContratOrigine__c
                                                                 AND (NumeroPiece__c = NULL OR StatutDocument__c = 'ATRT')];

            List<Document_Contractuel__c> filtreDoc = new List<Document_Contractuel__c>();
            Boolean docResExists = false;

            for(Document_Contractuel__c docCont : listDocContractuels) {
                if(docCont.NatureDocument__c == Label.LC51_LettreResiliation) {
                    docResExists = true;
                }
            }

            if(docResExists) {
                for(Document_Contractuel__c docCont : listDocContractuels) {
                    if(docCont.NatureDocument__c != Label.LC51_LettreResiliation && docCont.NatureDocument__c != 'DOC07'
                       && docCont.NatureDocument__c != 'DOC13' && docCont.NatureDocument__c != 'DOC20') {
                        filtreDoc.add(docCont);
                    }
                }
            } else   {
                filtreDoc.addAll(listDocContractuels);
            }

            if(filtreDoc != null && filtreDoc.size() > 0) {
                myWRP03.canRealise = false;
                myWRP03.ifDocumentNonSyncNonValidExiste = true;
                myWRP03.numerosDocContNonSyncNonValid = '';
                for(Document_Contractuel__c docCont : filtreDoc) {
                    myWRP03.numerosDocContNonSyncNonValid += docCont.Name + ' - ';
                }
                myWRP03.numerosDocContNonSyncNonValid = myWRP03.numerosDocContNonSyncNonValid.removeEnd('- ');
            }

            if(listOpps[0].EstOpportuniteMere__c == true) {
                //vérifier s'il existe des contrats fils générés non synchronisés (sans DK code)
                List<Contrat__c> listContratsToCheck = [SELECT id, DKCodeSurContrat__c, NumeroContrat__c
                                                        FROM contrat__c
                                                        where ContratCadre__c =: CurrentOpp.ContratOrigine__c
                                                        and DKCodeSurContrat__c = null];
                if(listContratsToCheck != null && listContratsToCheck.size() > 0) {
                    myWRP03.canRealise = false;
                    myWRP03.ifContratNonSynchroniseexiste = true;
                    myWRP03.NumerosContratsNonsynchronises = '';
                    for(Contrat__c con : listContratsToCheck) {
                        myWRP03.NumerosContratsNonsynchronises += con.NumeroContrat__c + ' - ';
                    }
                    myWRP03.NumerosContratsNonsynchronises = myWRP03.NumerosContratsNonsynchronises.removeEnd('- ');
                }
                //vérifier s'il existe des opportunités de renouvellement non réalisées
                List<Opportunity> listOppsToCheck = [SELECT id, ContratOrigine__c, ContratOrigine__r.NumeroContrat__c
                                                     FROM Opportunity
                                                     WHERE ContratOrigine__r.ContratCadre__c =: CurrentOpp.ContratOrigine__c
                                                     AND StageName !=:Label.LC28_Realise AND Tech_renouvellementFils__c = true];
                if(listOppsToCheck != null && listOppsToCheck.size() > 0) {
                    myWRP03.canRealise = false;
                    myWRP03.ifOppNonRealise = true;
                    myWRP03.NumerosContratsOppNonRealise = '';
                    for(Opportunity opp : listOppsToCheck) {
                        myWRP03.NumerosContratsOppNonRealise += opp.ContratOrigine__r.NumeroContrat__c + ' - ';
                    }
                    myWRP03.NumerosContratsOppNonRealise = myWRP03.NumerosContratsOppNonRealise.removeEnd('- ');

                }
            }

        }

        return myWRP03;
    }
    /**
     * @author Dona Kfoury
     * @date 18/05/2020
     * @vérification si nous devons afficher le texte d'aide dans le cas d'une opp de renouvellement avec un contrat origine
     * @param OppID: id de l'opp courante
     * @return boolean ifShowHelpText
     */
    @AuraEnabled
    public static boolean getIfShowHelpText(Id OppID){
        boolean ifShowHelpText = false;
        List<Opportunity> listOpp = [SELECT id, ContratOrigine__c, type_pers__c
                                     FROM Opportunity
                                     WHERE id =: OppID];
        if(listOpp != null && listOpp.size() > 0) {
            if(listOpp[0].ContratOrigine__c != null && listOpp[0].type_pers__c == Label.LC35_Renouv) {
                ifShowHelpText = true;
            }
        }

        return ifShowHelpText;
    }

    public class WRP02_MenuPickList {
        @AuraEnabled
        public String label;// Variable used to store the label of the picklist value
        @AuraEnabled
        public String value;// Variable used to store the picklist value

        // CONSTRUCTOR FUNCTION
        public WRP02_MenuPickList(String label, String value){
            this.label = label;
            this.value = value;
        }
    }

    public class WRP03_TypeErreurRealisation {
        @AuraEnabled
        public boolean canRealise;// Variable utilisé pour vérifier si on peut réaliser l'opp ou non
        @AuraEnabled
        public boolean ifContratNonSynchroniseexiste;// Variable utilisé pour vérifier s'il existe des contrats fils générés non synchronisés (sans DK code)
        @AuraEnabled
        public String NumerosContratsNonsynchronises;// Variable utilisé stoquer les numeros des contrats fils générés non synchronisés
        @AuraEnabled
        public boolean ifOppNonRealise;// Variable utilisé pour vérifier s'il existe des opportunités de renouvellement non réalisées
        @AuraEnabled
        public String NumerosContratsOppNonRealise;// Variable utilisé stoquer les numeros des contrats des opportunités de renouvellement non réalisées
        @AuraEnabled
        public String numerosDocContNonSyncNonValid;// Variable utilisé pour stoquer les numeros des documents contractuels des contrats des opportunités de renouvellement non synchronisés (sans numéro de pièce) ou non validé (statut "A traiter")
        @AuraEnabled
        public boolean ifDocumentNonSyncNonValidExiste;// Variable utilisé pour vérifier s'il existe des documents contractules non synchronisés ou non validés
    }

}