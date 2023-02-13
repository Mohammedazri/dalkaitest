/*--------------------------------------------------------------------------------------------------------------------------
   Author: Hussein Farran
   Company: EI-Technologies
   Description: Apex controller for the lightning component LC39_ContratCadreRenouvellement
   responsible of creating opportunities of type "Renouvellement" for the contrat cadre
   Test Class: LC39_ContratCadre_Controller_Test
   --------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC39_ContratCadre_Controller {

    @AuraEnabled
    public static Contrat__c getCurrentObject(Id ContratId){
        Contrat__c mycontrat = [SELECT id, name, DKCodeSurContrat__c, Statut__c
                                FROM Contrat__c
                                Where id =:ContratId
                                LIMIT 1];

        return mycontrat;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Hussein Farran
       Company: EI-Technologies
       Description: this function returns the status of this contrat cadre(closed,open etc..)
       Inputs: contract ID
       Returns: String
       ----------------------------------------------------------------------------------------------------------------------------*/

    @AuraEnabled
    public static String getContratType(Id ContratId){
        Contrat__c mycontrat = [SELECT id, name, Statut__c, Resilie__c
                                FROM Contrat__c
                                Where id =:ContratId
                                LIMIT 1];
        List<Opportunity> lstOpp = [Select id, name
                                    From Opportunity
                                    Where ContratOrigine__c =:mycontrat.Id AND type_pers__c =:Label.Renouvellement];
        if(mycontrat.Resilie__c == label.Contrat_Resilie || mycontrat.statut__c == label.Opp_StatutFermeture) {
            return 'ContratFerme'; // contart cadre normal
        } else if(lstOpp != Null && lstOpp.size() > 0) {
            return 'ContratDejaRenouv'; // renouvellement existe déjà
        } else {
            return 'ContratNormal';
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Hussein Farran
       Company: EI-Technologies
       Description: this function is responsible of creating an opportunity of type "Renouvellement" for the contrat of recordType contratCadre
       Inputs: Opportunity and contract ID
       Returns: Opportunity ID or an error message
       ----------------------------------------------------------------------------------------------------------------------------*/

    @AuraEnabled
    public static String CreateOpportunityRenouvellement(Opportunity opp, Id ContratId){
        contrat__c contrat = [SELECT id, OpportuniteCommerciale__c, NomPartenaire__c, OwnerID, SocieteVenteLookup__c, Resilie__c, statut__c,
                              DureeInitialeContrat__c, NatureContratCadre__c, ContratObligeantCEEContratPck__c
                              FROM contrat__C
                              WHERE id =: ContratId];

        List<opportunity> OldOpp1 = [SELECT id, AccountId, ContactPartenaireConversionPotentiel__c, ProjetCommercial__c, ContratOrigine__c, Lien_Explore__c, Reference_Explore__c, Type_davis__c, Type_de_marche__c,
                                     PrestationsAssociees__c, Forme_du_marche__c, Renouvellement__c, echeance_du_marche__c, Surface_m2__c, Effectif__c, Statut__c, Type,
                                     ContratOrigine__r.Resilie__c, Type_pers__c, Segment_client__c, SousSegmentMarche__c
                                     FROM opportunity
                                     WHERE id =:contrat.OpportuniteCommerciale__c ];

        for(opportunity opportunity : OldOpp1) {
            if(opportunity.Type_pers__c == label.Opp_type_Renewal && opportunity.Statut__c == label.Opp_StatutEnCours) {
                return Label.LC17_errorMsg;
            }
        }

        if(OldOpp1.size() > 0) {
            opportunity OldOpp = OldOpp1[0];
            opp.ProjetCommercial__c = OldOpp.ProjetCommercial__c;
            opp.Lien_Explore__c = OldOpp.Lien_Explore__c;
            opp.Reference_Explore__c = OldOpp.Reference_Explore__c;
            opp.Type_davis__c = OldOpp.Type_davis__c;
            opp.Type_de_marche__c = OldOpp.Type_de_marche__c;
            opp.PrestationsAssociees__c = OldOpp.PrestationsAssociees__c;
            opp.Forme_du_marche__c = OldOpp.Forme_du_marche__c;
            opp.Renouvellement__c = OldOpp.Renouvellement__c;
            opp.echeance_du_marche__c = OldOpp.echeance_du_marche__c;
            opp.Surface_m2__c = OldOpp.Surface_m2__c;
            opp.Effectif__c = OldOpp.Effectif__c;
            System.debug('Contract cadre dorigine ' + OldOpp.ContratOrigine__c);
            opp.ContactPartenaireConversionPotentiel__c = OldOpp.ContactPartenaireConversionPotentiel__c;
            opp.Segment_client__c = OldOpp.Segment_client__c;
            opp.SousSegmentMarche__c = OldOpp.SousSegmentMarche__c;
        }
        opp.OwnerId = contrat.OwnerID;
        opp.AccountId = contrat.NomPartenaire__c;
        opp.Type_pers__c = label.Opp_type_Renewal;
        opp.Statut__c = 'En cours';
        opp.ContratOrigine__c = ContratId;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Mere).getRecordTypeId();
        opp.Societevente__c = contrat.SocieteVenteLookup__c;
        opp.NatureOpportunitMere__c = contrat.NatureContratCadre__c;
        //added by Hussein Farran Ticket 549

        //opp.Duree_minimale_estimee__c = contrat.DureeInitialeContrat__c;
        opp.EstOpportuniteMere__c = true; //because contrat is contrat cadre

        //13-07-2022 Added by Charbel KH: US C360-729
        //opp.ContratObligeantCEE__c = contrat.ContratObligeantCEEContrat__c;
        //End US C360-729
        opp.ContratObligeantCEEPck__c = contrat.ContratObligeantCEEContratPck__c;

        try {
            insert(opp);
            List<ContratContact__c> listContContact = [SELECT id, Contact__c
                                                       FROM ContratContact__c
                                                       WHERE Contrat__c  =: contrat.id];

            List<OpportuniteContact__c> listOC = new List<OpportuniteContact__c>();

            if(listContContact != NULL && listContContact.size() > 0) {
                for(ContratContact__c cc : listContContact) {
                    OpportuniteContact__c oc = new OpportuniteContact__c();
                    oc.Contact__c = cc.contact__c;
                    oc.Opportunite__c = opp.id;
                    listOC.add(oc);
                }
                if(listOC != null && listOC.size() > 0) {
                    insert listOC;
                }
            }
            List<EcosystemePartenaire__c> ecoSysList = returnObject(ContratId);
            List<EcosystemePartenaire__c> ecotoInsert = new List<EcosystemePartenaire__c>();

            if(ecoSysList != null && ecoSysList.size() > 0) {
                for(EcosystemePartenaire__c eco : ecoSysList) {
                    EcosystemePartenaire__c myEco = new EcosystemePartenaire__c();
                    myEco = (EcosystemePartenaire__c)eco.clone();// cast to EcosystemePartenaire__c and clone the record to get all fields.
                    myEco.Opportunite__c = opp.id;
                    myEco.Contrat__c = null;
                    myEco.IdMigration__c = null;
                    myEco.ZZZTechEcosystemeRegleUnicite__c = myEco.PartenaireLie__c + ',' +  myEco.TypeRelation__c + ',' + myEco.Opportunite__c + '';
                    ecotoInsert.add(myEco);
                }
            }
            if(ecotoInsert != null && ecotoInsert.size() > 0) {
                insert ecotoInsert;
            }
            //03-10-2022 Modifier par jimmy tous les contrat share users (inclus le owner) seront ajouter au membres de l'opp
            /*if(opp.ownerId != contrat.OwnerId) {
                OpportunityTeamMember otm = new OpportunityTeamMember();
                otm.OpportunityId = opp.id;
                otm.OpportunityAccessLevel = label.Label_Edit;
                otm.TeamMemberRole = label.PV_OTM_Comm;
                otm.UserId = contrat.OwnerId;
                insert otm;
               }*/
            AP38_OpportunityContratCadre.addContratMembersToOppMembers(new List<Opportunity> {opp}, new List<Contrat__c> {contrat});

            return opp.id;
        }
        catch(System.DMLException e) {
            DMLException dmlExc = (DMLException) e;
            List<String> messages = new List<String>();
            for(Integer i = 0; i < dmlExc.getNumDml(); i++) {
                messages.add( dmlExc.getDmlMessage(i) );
            }
            String msg = String.join(messages, ', ');

            return msg.remove('</b>').remove('<b>').replaceAll('<br>', '. ');

        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Hussein Farran
       Company: EI-Technologies
       Description: this function is responsible of getting the values of the picklist field "Stagename" of the opportunity
       Inputs: -
       Returns: list of WRP01_MenuPickList
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static list<WRP01_MenuPickList> GetStagesPicklist(){
        system.debug('test stages');
        List<WRP01_MenuPickList> StagesList = new List<WRP01_MenuPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ple) {
            StagesList.add(new WRP01_MenuPickList(f.getLabel(), f.getValue()));
        }
        system.debug(StagesList);

        return StagesList;
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Hussein Farran
       Company: EI-Technologies
       Description: this function is responsible of getting the values of the picklist field "Trimestres" of the opportunity
       Inputs: -
       Returns: list of WRP01_MenuPickList
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static list<WRP01_MenuPickList> GetMoisPicklist(){
        system.debug('test trimestre');
        List<WRP01_MenuPickList> MoisList = new List<WRP01_MenuPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Moisdesignature__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ple) {
            MoisList.add(new WRP01_MenuPickList(f.getLabel(), f.getValue()));
        }
        system.debug(MoisList);

        return MoisList;
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Hussein Farran
       Company: EI-Technologies
       Description: this function is responsible of getting the values of the picklist field "Annee de signature" of the opportunity
       Inputs: -
       Returns: list of WRP01_MenuPickList
       ----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static list<WRP01_MenuPickList> GetAnneePicklist(){
        List<WRP01_MenuPickList> TrimestresList = new List<WRP01_MenuPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Annee_de_signature__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ple) {
            TrimestresList.add(new WRP01_MenuPickList(f.getLabel(), f.getValue()));
        }
        system.debug(TrimestresList);

        return TrimestresList;
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Hussein Farran
       Company: EI-Technologies
       Description: Class used in the functions above to import the picklist field values with there labels to the lightning controller
       --------------------------------------------------------------------------------------------------------------------------*/
    public class WRP01_MenuPickList {

        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;

        public WRP01_MenuPickList(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Rita Bejjani
       Company: EI-Technologies
       Description: this function is responsible of getting all fields of ecosysteme to clone it on contrat and create them on opp
       Inputs: Id
       Returns: List<SObject>
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static List<SObject> returnObject (id ObjId){
        DescribeSObjectResult describeResult = EcosystemePartenaire__c.sObjectType.getDescribe();  // Object Ecosysteme
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
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE Contrat__c =:ObjId';
        //Added By Jimmy for ApexSOQLInjection
        String soqlQueryEscaped = String.escapeSingleQuotes(soqlQuery);
        List<sObject> record = Database.query(soqlQueryEscaped); // Query the list of sObject

        return record; // return SObject Type
    }

}