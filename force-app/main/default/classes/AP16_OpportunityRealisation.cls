/*--------------------------------------------------------------------------------------------------------------------------
   Author: Johny Kassis
   Company: EI-Technologies
   Description: Class responsible of creating and modifying the contract when an opportunity is realised
   Test Class: AP16_OpportunityRealisation_test 77%
   History
   <Date>      <Authors Name>      <Brief Description of Change>
   11/04/2018   Johny Kassis       ticket 101 remove the section that create a "Avenant" and added the condition to the contract query ticket 103
   13/04/2017   Johny Kassis       remove the condition from the contract query and add the if else in the for loop function in the UpdateContrat function
   16/04/2017   Johny Kassis       added the condition IdMigration__c=null to the contract query
   20/04/2018   Johny Kassis       added conditions to see if the field values chnaged in the Opportunity and set the field Tech_updatedFields__c
   20/04/2018   Johny Kassis       added the function checkModifiedFields to check update the field Tech_ModifiedAPIName__c that is used to check if the fields were  updated
   24/05/2018   Johny Kassis       added the bypass for the validation rule ModificationAvecBoutonModifSansImpact	on the contract   updated
   31/07/2018   Johny Kassis       added the sections that sets the field PiloteDuContrat__c
   2/10/2018	 Jacques Akiki      added modifications to creatContrat function to take into account the contrat cadre.
   24/10/2018	 Jacques Akiki		added modifications to include the record type of contrat cadre
   26/02/2020	 Dona Kfoury		added Type de PdA to the list of fields copied to the contrat__c
   --------------------------------------------------------------------------------------------------------------------------*/
public class AP16_OpportunityRealisation {
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: this function update the contracts of the opportunities if they are already created
       Inputs: list of opportunities
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateContrat(List<Opportunity> opportunityList, map<ID, Opportunity> oldOpportunityMap){
        //ystem.debug('in UpdateContrat');
        Map<ID, Opportunity> mapContratToOpp = new  Map<ID, Opportunity>();
        For(Opportunity opp: opportunityList){
            mapContratToOpp.put(opp.Contrat_Genere_lookup__c, opp);
            //System.debug('12388');
        }

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Contrat__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        map<id, Date> mapContratIdDate = new map<id, Date>();
        Map<Contrat__c, Opportunity> contratOppIDMap = new Map<Contrat__c, Opportunity>();

        List<Contrat__c> contList = [SELECT ID, Name, DureeInitialeContrat__c, TypeOpportunite__c, DKCodeSurContrat__c, ContratObligeantCEEContratPck__c,
                                     OwnerID, NomPartenaire__c, DateProchaineEcheance__c, NatureContrat__c, OpportuniteCommerciale__c, Libelle_Agence__c, Type_de_PdA_reseaux__c,
                                     DatePriseEffet__c, SocieteVenteLookup__c, Statut__c, TechByPassRV_ModifSansImpact__c, PiloteDuContrat__c, ContratCadre__c, ZZZ_Tech_Bypass_VR08__c
                                     FROM Contrat__c
                                     WHERE id IN: mapContratToOpp.keySet()];// And IdMigration__c=null ];//and Statut__c IN :contratStatusToUpdate  ];
        //System.debug('contList '+contList);
        For(Contrat__c contr: contList){
            contratOppIDMap.put( contr, mapContratToOpp.get(contr.id));
        }
        List<Contrat__c> contratToUpdate = new List<Contrat__c>();
        For(Contrat__c contrat: contratOppIDMap.keySet()){
            Opportunity opp = contratOppIDMap.get(contrat);

            if(contrat.Statut__c != label.AP16_ContratStatus) {
                if(opp.Tech_ModifiedAPIName__c != null && opp.Tech_ModifiedAPIName__c.contains('name')) {
                    contrat.Name = opp.name;
                    opp.Tech_updatedFields__c = fieldMap.get('Name').getDescribe().getLabel();
                    opp.Tech_updatedFields__c += ';';
                }

            } else {
                // System.debug('opp.Tech_ModifiedAPIName__c '+opp.Tech_ModifiedAPIName__c);
                //System.debug('123888');
                if(opp.Tech_ModifiedAPIName__c != null) {
                    String updatedFields = ' ';
                    if(opp.Tech_ModifiedAPIName__c.contains('name') || opp.name != oldOpportunityMap.get(opp.id).name) {
                        contrat.Name = opp.name;
                        updatedFields += fieldMap.get('Name').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('CloseDate') || opp.CloseDate != oldOpportunityMap.get(opp.id).CloseDate) {
                        contrat.DatePriseEffet__c = opp.CloseDate;
                        updatedFields += fieldMap.get('DatePriseEffet__c').getDescribe().getLabel();
                        updatedFields += ';';
                        mapContratIdDate.put(contrat.id, opp.CloseDate);
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('Offres__c') || opp.Offres__c != oldOpportunityMap.get(opp.id).Offres__c) {
                        contrat.Offres__c = opp.Offres__c;
                        updatedFields += fieldMap.get('Offres__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    //22-01-2021 - US-173 Added by Jimmy Khalil
                    if(opp.Tech_ModifiedAPIName__c.contains('Composante_d_offre__c') || opp.Composante_d_offre__c != oldOpportunityMap.get(opp.id).Composante_d_offre__c) {
                        contrat.Composante_d_offre__c = opp.Composante_d_offre__c;
                        updatedFields += fieldMap.get('Composante_d_offre__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    //25-06-2021 - Ano-463 Added by Jimmy Khalil
                    if(opp.Tech_ModifiedAPIName__c.contains('NatureOpportunitMere__c') || opp.NatureOpportunitMere__c != oldOpportunityMap.get(opp.id).NatureOpportunitMere__c) {
                        contrat.NatureContratCadre__c = opp.NatureOpportunitMere__c;
                        updatedFields += fieldMap.get('NatureContratCadre__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('TypeContratFirst__c') || opp.TypeContratFirst__c != oldOpportunityMap.get(opp.id).TypeContratFirst__c) {
                        contrat.TypeContratFirst__c = opp.TypeContratFirst__c;
                        updatedFields += fieldMap.get('TypeContratFirst__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('TypePrestations__c') || opp.TypePrestations__c != oldOpportunityMap.get(opp.id).TypePrestations__c) {
                        contrat.TypePrestations__c = opp.TypePrestations__c;
                        updatedFields += fieldMap.get('TypePrestations__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('TypeEnergie__c') || opp.TypeEnergie__c != oldOpportunityMap.get(opp.id).TypeEnergie__c) {
                        contrat.TypeEnergie__c = opp.TypeEnergie__c;
                        updatedFields += fieldMap.get('TypeEnergie__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('TransparenceP3__c') || opp.TransparenceP3__c != oldOpportunityMap.get(opp.id).TransparenceP3__c) {
                        contrat.TransparenceP3__c = opp.TransparenceP3__c;
                        updatedFields += fieldMap.get('TransparenceP3__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('RapportActivite__c') || opp.RapportActivite__c != oldOpportunityMap.get(opp.id).RapportActivite__c) {
                        contrat.RapportActivite__c = opp.RapportActivite__c;
                        updatedFields += fieldMap.get('RapportActivite__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('ConsommationChaud__c') || opp.ConsommationChaud__c != oldOpportunityMap.get(opp.id).ConsommationChaud__c) {
                        contrat.ConsommationChaud__c = opp.ConsommationChaud__c;
                        updatedFields += fieldMap.get('ConsommationChaud__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('ConsommationFroid__c') || opp.ConsommationFroid__c != oldOpportunityMap.get(opp.id).ConsommationFroid__c) {
                        contrat.ConsommationFroid__c = opp.ConsommationFroid__c;
                        updatedFields += fieldMap.get('ConsommationFroid__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('PuissanceChaud__c') || opp.PuissanceChaud__c != oldOpportunityMap.get(opp.id).PuissanceChaud__c) {
                        contrat.PuissanceChaud__c = opp.PuissanceChaud__c;
                        updatedFields += fieldMap.get('PuissanceChaud__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('PuissanceFroid__c') || opp.PuissanceFroid__c != oldOpportunityMap.get(opp.id).PuissanceFroid__c) {
                        contrat.PuissanceFroid__c = opp.PuissanceFroid__c;
                        updatedFields += fieldMap.get('PuissanceFroid__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('Duree_minimale_estimee__c') || opp.Duree_minimale_estimee__c != oldOpportunityMap.get(opp.id).Duree_minimale_estimee__c) {
                        contrat.DureeInitialeContrat__c = opp.Duree_minimale_estimee__c;
                        updatedFields += fieldMap.get('DureeInitialeContrat__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
					
                    /* Champ "DureeMaximaleCumulee_del__c" supprimé suite à l'US 872 - CKH - 01/05/2023
                    if(opp.Tech_ModifiedAPIName__c.contains('Duree_maximale_estimee__c') || opp.Duree_maximale_estimee__c != oldOpportunityMap.get(opp.id).Duree_maximale_estimee__c) {
                        contrat.DureeMaximaleCumulee_del__c = opp.Duree_maximale_estimee__c;
                        updatedFields += fieldMap.get('DureeMaximaleCumulee_del__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
					*/

                    if(opp.Tech_ModifiedAPIName__c.contains('Type_de_contrat__c') || opp.Type_de_contrat__c != oldOpportunityMap.get(opp.id).Type_de_contrat__c) {
                        contrat.NatureContrat__c = opp.Type_de_contrat__c;
                        updatedFields += fieldMap.get('NatureContrat__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if((opp.Tech_ModifiedAPIName__c.contains('AccountId') || opp.AccountId != oldOpportunityMap.get(opp.id).AccountId)
                       && (contrat.DKCodeSurContrat__c == null || contrat.DKCodeSurContrat__c == '')) {
                        contrat.NomPartenaire__c = opp.AccountId;
                        updatedFields += fieldMap.get('NomPartenaire__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('OwnerID') || opp.OwnerID != oldOpportunityMap.get(opp.id).OwnerID) {
                        contrat.OwnerID = opp.OwnerID;
                        contrat.PiloteDuContrat__c = opp.OwnerID;
                        updatedFields += fieldMap.get('OwnerID').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('Type_pers__c') || opp.Type_pers__c != oldOpportunityMap.get(opp.id).Type_pers__c) {
                        contrat.TypeOpportunite__c = opp.Type_pers__c;
                        updatedFields += fieldMap.get('TypeOpportunite__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if((opp.Tech_ModifiedAPIName__c.contains('Societevente__c') || opp.Societevente__c != oldOpportunityMap.get(opp.id).Societevente__c)
                       && (contrat.DKCodeSurContrat__c == null || contrat.DKCodeSurContrat__c == '')) {
                        contrat.SocieteVenteLookup__c = opp.Societevente__c;
                        updatedFields += fieldMap.get('SocieteVenteLookup__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('DureeReconduction__c') || opp.DureeReconduction__c != oldOpportunityMap.get(opp.id).DureeReconduction__c) {
                        contrat.DureeReconduction__c = opp.DureeReconduction__c;
                        updatedFields += fieldMap.get('DureeReconduction__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('NombreReconductionsAutorisees__c') || opp.NombreReconductionsAutorisees__c != oldOpportunityMap.get(opp.id).NombreReconductionsAutorisees__c) {
                        contrat.NombreReconductionsAutorisees__c = opp.NombreReconductionsAutorisees__c;
                        updatedFields += fieldMap.get('NombreReconductionsAutorisees__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('ReconductionFaitAutorisee__c') || opp.ReconductionFaitAutorisee__c != oldOpportunityMap.get(opp.id).ReconductionFaitAutorisee__c) {
                        contrat.ReconductionFaitAutorisee__c = opp.ReconductionFaitAutorisee__c;
                        updatedFields += fieldMap.get('ReconductionFaitAutorisee__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('TypeReconduction__c') || opp.TypeReconduction__c != oldOpportunityMap.get(opp.id).TypeReconduction__c) {
                        contrat.TypeReconduction__c = opp.TypeReconduction__c;
                        updatedFields += fieldMap.get('TypeReconduction__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    if(opp.Tech_ModifiedAPIName__c.contains('DureePreavis__c') || opp.DureePreavis__c != oldOpportunityMap.get(opp.id).DureePreavis__c) {
                        contrat.DureePreavis__c = opp.DureePreavis__c;
                        updatedFields += fieldMap.get('DureePreavis__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    system.debug('opp.Libelle_Agence__c...' + opp.Libelle_Agence__c + 'oldOpportunityMap.get(opp.id).Libelle_Agence__c...' + oldOpportunityMap.get(opp.id).Libelle_Agence__c);
                    if(opp.Tech_ModifiedAPIName__c.contains('Libelle_Agence__c') || opp.Libelle_Agence__c != oldOpportunityMap.get(opp.id).Libelle_Agence__c) {
                        contrat.Libelle_Agence__c = opp.Libelle_Agence__c;
                        updatedFields += fieldMap.get('Libelle_Agence__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }

                    //added by DKF 26/3/2020 - Task C360-10
                    if(opp.Tech_ModifiedAPIName__c.contains('Type_de_PdA_reseaux__c') || opp.Type_de_PdA_reseaux__c != oldOpportunityMap.get(opp.id).Type_de_PdA_reseaux__c) {
                        contrat.Type_de_PdA_reseaux__c = opp.Type_de_PdA_reseaux__c;
                        updatedFields += fieldMap.get('Type_de_PdA_reseaux__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    //end modif

                    
                    //added by Charbel Khoury Hanna 18/07/2022 - US C360-729
                    if(opp.Tech_ModifiedAPIName__c.contains('ContratObligeantCEEPck__c') || opp.ContratObligeantCEEPck__c != oldOpportunityMap.get(opp.id).ContratObligeantCEEPck__c) {
                        contrat.ContratObligeantCEEContratPck__c = opp.ContratObligeantCEEPck__c;
                        updatedFields += fieldMap.get('ContratObligeantCEEContratPck__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    //end modif
					
                    //Added by Jimmy 05/01/2022 - CVS
                    if(opp.Tech_ModifiedAPIName__c.contains('natureOffre__c') || opp.natureOffre__c != oldOpportunityMap.get(opp.id).natureOffre__c) {
                        contrat.natureOffre__c = opp.natureOffre__c;
                        updatedFields += fieldMap.get('natureOffre__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('engagementEnergetique__c') || opp.engagementEnergetique__c != oldOpportunityMap.get(opp.id).engagementEnergetique__c) {
                        contrat.engagementEnergetique__c = opp.engagementEnergetique__c;
                        updatedFields += fieldMap.get('engagementEnergetique__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('paiementDesEnergies__c') || opp.paiementDesEnergies__c != oldOpportunityMap.get(opp.id).paiementDesEnergies__c) {
                        contrat.paiementDesEnergies__c = opp.paiementDesEnergies__c;
                        updatedFields += fieldMap.get('paiementDesEnergies__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    if(opp.Tech_ModifiedAPIName__c.contains('niveauDeMaintenance__c') || opp.niveauDeMaintenance__c != oldOpportunityMap.get(opp.id).niveauDeMaintenance__c) {
                        contrat.niveauDeMaintenance__c = opp.niveauDeMaintenance__c;
                        updatedFields += fieldMap.get('niveauDeMaintenance__c').getDescribe().getLabel();
                        updatedFields += ';';
                    }
                    //end CVS

                    if(updatedFields != null && updatedFields != ' ') {
                        opp.Tech_updatedFields__c = updatedFields;
                    }

                    contrat.OpportuniteCommerciale__c = opp.id;
                }
            }

            contrat.TechByPassRV_ModifSansImpact__c = !contrat.TechByPassRV_ModifSansImpact__c;//added by Johny Kassis 24/05/2018
            contrat.ZZZ_Tech_Bypass_VR08__c = !contrat.ZZZ_Tech_Bypass_VR08__c;
            contratToUpdate.add(contrat);
            opp.Tech_ModifiedAPIName__c = null;
        }
        if(contratToUpdate.size() > 0) {
            try {
                PAD.PAD_BypassTrigger += ';AP45_Account;';
                update contratToUpdate;
                if(mapContratIdDate != NULL && mapContratIdDate.keyset() != NULL && mapContratIdDate.keyset().size() > 0) {
                    List<Document_Contractuel__c> listDocCont = [SELECT id, DatePriseEffet__c, contrat__c
                                                                 FROM Document_Contractuel__c
                                                                 WHERE contrat__c in:mapContratIdDate.keyset() AND NatureDocument__c =:Label.AP52_DOC01];
                    if(listDocCont != NULL && listDocCont.size() > 0) {
                        for(Document_Contractuel__c dc : listDocCont) {
                            dc.DatePriseEffet__c = mapContratIdDate.get(dc.contrat__c);
                        }
                        update listDocCont;
                    }
                }
            }
            catch(DMLException e) {
                String msg =  e.getmessage();
                if(msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, ')) {
                    opportunityList[0].adderror(Label.AP16_error + ' ' + msg.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION, ').substringBefore(': []'));
                } else {
                    opportunityList[0].adderror(msg);
                }
            }
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: this function creates the contracts and update the field Contrat_Genere_lookup__c of the opportunity with the contrac ID
       Inputs: list of opportunities
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void CreateContrat(List<Opportunity> opportunityList){
        /*Added 02/10/2018 by jacques Akiki*/
        set<id> setId = new set<id>();
        set<id> setIds = new set<id>();
        for(Opportunity opp : opportunityList) {
            setIds.add(opp.id);
            if(opp.OpportuniteMere__c != Null) {
                setId.add(opp.OpportuniteMere__c);
            }
        }

        map<string, Contrat__c> mapOppMereContrat = new map<string, Contrat__c>();
        Map<id, Contrat__c> mapIdContrat = new Map<id, Contrat__c>();

        List<Contrat__c> listParentContrat = [SELECT id, name, EstContratcadre__c, OpportuniteCommerciale__c, recordType.name
                                              From Contrat__c
                                              where EstContratcadre__c = TRUE AND OpportuniteCommerciale__c in:setId ];

        if(listParentContrat != NULL && listParentContrat.size() > 0) {
            for(Contrat__c ContP : listParentContrat) {
                mapOppMereContrat.put(ContP.OpportuniteCommerciale__c, ContP);
            }
            for(Opportunity opp : opportunityList) {
                if(opp.OpportuniteMere__c == mapOppMereContrat.get(opp.OpportuniteMere__c).OpportuniteCommerciale__c) {
                    mapIdContrat.put(opp.id, mapOppMereContrat.get(opp.OpportuniteMere__c));
                }

            }
        }
        /*End Modif by Jacques AKiki*/

        List<Contrat__c> contratToInsert = new List<Contrat__c>();
        Map<Opportunity, Contrat__c> contratOppIDMap = new Map<Opportunity, Contrat__c>();

        For(Opportunity opp: opportunityList){
            Contrat__c contrat = new Contrat__c();
            contrat.DureeReconduction__c = opp.DureeReconduction__c;
            contrat.NombreReconductionsAutorisees__c = opp.NombreReconductionsAutorisees__c;
            contrat.ReconductionFaitAutorisee__c = opp.ReconductionFaitAutorisee__c;
            contrat.TypeReconduction__c = opp.TypeReconduction__c;
            contrat.DureePreavis__c = opp.DureePreavis__c;
            contrat.DatePriseEffet__c = opp.CloseDate;
            contrat.DureeInitialeContrat__c = opp.Duree_minimale_estimee__c;
            //Champ "DureeMaximaleCumulee_del__c" supprimé suite à l'US 872 - CKH - 01/05/2023
            //contrat.DureeMaximaleCumulee_del__c = opp.Duree_maximale_estimee__c;
            contrat.Name = opp.name;
            contrat.statut__c = label.AP16_ContratStatus; // added by Jacques Akiki 15/04/2019
            contrat.NatureContrat__c = opp.Type_de_contrat__c;
            contrat.NomPartenaire__c = opp.AccountId;
            contrat.Offres__c = opp.Offres__c;
            contrat.Composante_d_offre__c = opp.Composante_d_offre__c;
            contrat.TypeContratFirst__c = opp.TypeContratFirst__c;
            contrat.TypePrestations__c = opp.TypePrestations__c;
            contrat.TypeEnergie__c = opp.TypeEnergie__c;
            contrat.TransparenceP3__c = opp.TransparenceP3__c;
            contrat.RapportActivite__c = opp.RapportActivite__c;
            contrat.ConsommationChaud__c = opp.ConsommationChaud__c;
            contrat.ConsommationFroid__c = opp.ConsommationFroid__c;
            contrat.PuissanceChaud__c = opp.PuissanceChaud__c;
            contrat.PuissanceFroid__c = opp.PuissanceFroid__c;
            contrat.OwnerID = opp.OwnerID;
            contrat.PiloteDuContrat__c = opp.OwnerID;
            contrat.TypeOpportunite__c = opp.Type_pers__c;
            contrat.OpportuniteCommerciale__c = opp.id;
            contrat.CategorieContrat__c = 'VTE'; //check for fix later added by jack 21/03/2019 --> dependent picklist avec nature contrat
            contrat.SocieteVenteLookup__c = opp.Societevente__c;
            contrat.TechByPassRV_ModifSansImpact__c = !contrat.TechByPassRV_ModifSansImpact__c;//added by Johny Kassis 24/05/2018
            contrat.recordTypeId = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get(Label.RTContrat_Avenant).getRecordTypeId();//ajouté le 14/08/2019 par Jacques Akiki
            contrat.Libelle_Agence__c = opp.Libelle_Agence__c;// added by chady geara 28/2/2019
            //added by DKF 26/3/2020 - Task C360-10
            contrat.Type_de_PdA_reseaux__c = opp.Type_de_PdA_reseaux__c;
            //end modif
            contrat.OrigineContrat__c = opp.OrigineOpportunite__c;//added by rita bejjani 23/5/2019
            //contrat.TypeReconduction__c = opp.TypeReconduction__c; // added by rita bejjani 24/5/2019

            //Added by Jimmy 05/01/2022 - CVS
            contrat.natureOffre__c = opp.natureOffre__c;
            contrat.engagementEnergetique__c = opp.engagementEnergetique__c;
            contrat.paiementDesEnergies__c = opp.paiementDesEnergies__c;
            contrat.niveauDeMaintenance__c = opp.niveauDeMaintenance__c;
            //end CVS

            if(opp.EstOpportuniteMere__c == TRUE) { //ajouté le 2/10/2018 par Jacques Akiki
                contrat.EstContratcadre__c = TRUE;
                contrat.recordTypeId = Schema.SObjectType.Contrat__c.getRecordTypeInfosByName().get(Label.RTContrat_ContratCadre).getRecordTypeId();//ajouté le 14/08/2019 par Jacques Akiki
            }
            if(opp.EstOpportuniteMere__c == TRUE || opp.OpportuniteMere__c<> NULL) {
                contrat.NatureContratCadre__c = opp.NatureOpportunitMere__c;
            }
            if(opp.OpportuniteMere__c != NULL) { // ajouté le 2/10/2018 par Jacques Akiki
                if(mapIdContrat.containsKey(opp.id) && mapIdContrat.get(opp.id) != NULL) {
                    contrat.ContratCadre__c = mapIdContrat.get(opp.id).id;
                }
            }

            //18-07-2022 Added by Charbel KH: US C360-729
            //contrat.ContratObligeantCEEContrat__c = opp.ContratObligeantCEE__c;
            //End US C360-729
            contrat.ContratObligeantCEEContratPck__c = opp.ContratObligeantCEEPck__c;

            contratOppIDMap.put(opp, contrat);
            contratToInsert.add(contrat);

        }
        try {
            PAD.PAD_BypassTrigger += ';AP45_Account;';
            insert contratToInsert;
        }
        catch(DMLException e) {
            String msg =  e.getmessage();
            if(msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, ')) {
                opportunityList[0].adderror(Label.AP16_error + ' ' + msg.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION, ').substringBefore(': []'));
            } else {
                opportunityList[0].adderror(msg);
            }
        }

        //added by Alain Ghoussoub
        system.debug('################### ' + contratOppIDMap);
        Map<Id, Id> oppContratGenere = new Map<Id, Id>();
        for(Opportunity opp : opportunityList) {
            if(opp.NatureOpportunitMere__c == Label.AP16_National && opp.EstOpportuniteMere__c == true) {
                String contratId = contratOppIDMap.get(opp).id;
                oppContratGenere.put(opp.id, contratId);
            }
        }
        system.debug('################### ' + oppContratGenere);
        if(oppContratGenere.keySet() != null) {
            List<Opportunity> oppList = [SELECT id, Contrat_Genere_lookup__c, OpportuniteMere__c
                                         FROM Opportunity
                                         WHERE OpportuniteMere__c in :oppContratGenere.keySet()
                                         AND Contrat_Genere_lookup__c != null
                                         AND Stagename = :Label.AP16_Realisation];

            List<Contrat__c> contList = new List<Contrat__c>();
            for(Opportunity opp : oppList) {
                Contrat__c cont = new contrat__c();
                cont.id = opp.Contrat_Genere_lookup__c;
                system.debug('################### opp.OpportuniteMere__c ' + opp.OpportuniteMere__c);
                if(oppContratGenere.containsKey(opp.OpportuniteMere__c) && oppContratGenere.get(opp.OpportuniteMere__c) != null) {
                    system.debug('################### in');
                    cont.ContratCadre__c = oppContratGenere.get(opp.OpportuniteMere__c);
                }
                contList.add(cont);
            }
            if(contList != null && contList.size() > 0) {
                try {
                    update contList;
                }
                catch(Exception e) {
                    system.debug('Error in updating contracts: ' + e);
                }
            }
        }

        //added by rita Bejjani
        set<id> setOppId = new set<id>();
        for(Opportunity opp : opportunityList) {
            setOppId.add(opp.id);
        }
        List<EcosystemePartenaire__c> ecoSysList = returnObject(setOppId);

        id contratId;
        List<EcosystemePartenaire__c> ecotoInsert = new List<EcosystemePartenaire__c>();
        List<ContratContact__c> listCC = new List<ContratContact__c>();
        List<OpportuniteContact__c> listOppContact = [SELECT id, Contact__c
                                                      FROM OpportuniteContact__c
                                                      WHERE Opportunite__c in: setOppId];
        For(Opportunity opp: contratOppIDMap.keySet()){
            contratId = contratOppIDMap.get(opp).id;
            opp.Contrat_Genere_lookup__c = contratId;
            opp.Tech_ModifiedAPIName__c = null;//added 20/04/2018 by Johny kassis

            if(listOppContact != NULL && listOppContact.size() > 0) {
                for(OpportuniteContact__c oc : listOppContact) {
                    ContratContact__c cc = new ContratContact__c();
                    cc.Contact__c = oc.contact__c;
                    cc.contrat__c = contratId;
                    listCC.add(cc);
                }
            }
            // added by rita bejjani
            if(ecoSysList != null && ecoSysList.size() > 0) {
                for(EcosystemePartenaire__c eco : ecoSysList) {
                    if(eco.Opportunite__c == opp.id) {
                        //eco.Contrat__c = contratId;
                        EcosystemePartenaire__c myEco = new EcosystemePartenaire__c();
                        myEco = (EcosystemePartenaire__c)eco.clone();// cast to EcosystemePartenaire__c and clone the record to get all fields.
                        myEco.Opportunite__c = null;
                        myEco.IdMigration__c = null;
                        myEco.Contrat__c = contratId;
                        myEco.ZZZTechEcosystemeRegleUnicite__c = myEco.PartenaireLie__c + ',' +  myEco.TypeRelation__c + ',' + myEco.Contrat__c + '';
                        ecotoInsert.add(myEco);
                    }
                }
            }
        }
        if(listCC != null && listCC.size() > 0) {
            insert listCC;
        }
        if(ecotoInsert != null && ecotoInsert.size() > 0) {
            try {
                insert ecotoInsert;
            }
            catch(DMLException e) {
                String msg =  e.getmessage();
                System.debug('Catch Exception: ' + msg);
            }
        }
    }

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: function used to update the field Tech_ModifiedAPIName__c
       Inputs: list of opportunities, Map of old opportunities
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkModifiedFields(List<Opportunity> opportunityList, map<ID, Opportunity> oldOpportunityMap){
        System.debug('Count TIMES 1 !');
        For(Opportunity opp: opportunityList){ //System.debug('OPP.Libelle_Agence__c ' +opp.Libelle_Agence__c);

            String str = ' ';
            if(opp.name != oldOpportunityMap.get(opp.id).name && !str.contains('name')) {
                str += 'name ';
            }

            if(opp.CloseDate != oldOpportunityMap.get(opp.id).CloseDate && !str.contains('CloseDate') ) {
                str += 'CloseDate ';
            }
            if(opp.Offres__c != oldOpportunityMap.get(opp.id).Offres__c && !str.contains('Offres__c') ) {
                str += 'Offres__c ';
            }
            
            if(opp.ContratObligeantCEEPck__c != oldOpportunityMap.get(opp.id).ContratObligeantCEEPck__c && !str.contains('ContratObligeantCEEPck__c') ) {
                str += 'ContratObligeantCEEPck__c ';
            }
            if(opp.Composante_d_offre__c != oldOpportunityMap.get(opp.id).Composante_d_offre__c && !str.contains('Composante_d_offre__c') ) {
                str += 'Composante_d_offre__c ';
            }

            //25-06-2021 - Ano-463 Added by Jimmy Khalil
            if(opp.NatureOpportunitMere__c != oldOpportunityMap.get(opp.id).NatureOpportunitMere__c && !str.contains('NatureOpportunitMere__c') ) {
                str += 'NatureOpportunitMere__c ';
            }
            if(opp.TypeContratFirst__c != oldOpportunityMap.get(opp.id).TypeContratFirst__c && !str.contains('TypeContratFirst__c') ) {
                str += 'TypeContratFirst__c ';
            }
            if(opp.TypePrestations__c != oldOpportunityMap.get(opp.id).TypePrestations__c && !str.contains('TypePrestations__c') ) {
                str += 'TypePrestations__c ';
            }
            if(opp.TypeEnergie__c != oldOpportunityMap.get(opp.id).TypeEnergie__c && !str.contains('TypeEnergie__c') ) {
                str += 'TypeEnergie__c ';
            }
            if(opp.TransparenceP3__c != oldOpportunityMap.get(opp.id).TransparenceP3__c && !str.contains('TransparenceP3__c') ) {
                str += 'TransparenceP3__c ';
            }
            if(opp.RapportActivite__c != oldOpportunityMap.get(opp.id).RapportActivite__c && !str.contains('RapportActivite__c') ) {
                str += 'RapportActivite__c ';
            }

            if(opp.ConsommationChaud__c != oldOpportunityMap.get(opp.id).ConsommationChaud__c && !str.contains('ConsommationChaud__c') ) {
                str += 'ConsommationChaud__c ';
            }
            if(opp.ConsommationFroid__c != oldOpportunityMap.get(opp.id).ConsommationFroid__c && !str.contains('ConsommationFroid__c') ) {
                str += 'ConsommationFroid__c ';
            }
            if(opp.PuissanceChaud__c != oldOpportunityMap.get(opp.id).PuissanceChaud__c && !str.contains('PuissanceChaud__c') ) {
                str += 'PuissanceChaud__c ';
            }
            if(opp.PuissanceFroid__c != oldOpportunityMap.get(opp.id).PuissanceFroid__c && !str.contains('PuissanceFroid__c') ) {
                str += 'PuissanceFroid__c ';
            }

            if(opp.Duree_minimale_estimee__c != oldOpportunityMap.get(opp.id).Duree_minimale_estimee__c && !str.contains('Duree_minimale_estimee__c')) {
                str += 'Duree_minimale_estimee__c ';
            }

            if(opp.Duree_maximale_estimee__c != oldOpportunityMap.get(opp.id).Duree_maximale_estimee__c && !str.contains('Duree_maximale_estimee__c')) {
                str += 'Duree_maximale_estimee__c ';
            }

            if(opp.Type_de_contrat__c != oldOpportunityMap.get(opp.id).Type_de_contrat__c && !str.contains('Type_de_contrat__c')) {
                str += 'Type_de_contrat__c ';
            }

            if(opp.AccountId != oldOpportunityMap.get(opp.id).AccountId && !str.contains('AccountId')) {
                str += 'AccountId ';
            }

            if(opp.OwnerID != oldOpportunityMap.get(opp.id).OwnerID && !str.contains('OwnerID')) {
                str += 'OwnerID ';
            }

            if(opp.Type_pers__c != oldOpportunityMap.get(opp.id).Type_pers__c && !str.contains('Type_pers__c')) {
                str += 'Type_pers__c ';
            }

            if(opp.Societevente__c != oldOpportunityMap.get(opp.id).Societevente__c && !str.contains('Societevente__c')) {
                str += 'Societevente__c ';
            }

            if(opp.Libelle_Agence__c != oldOpportunityMap.get(opp.id).Libelle_Agence__c && !str.contains('Libelle_Agence__c')) {
                str += 'Libelle_Agence__c ';
            }

            if(opp.DureeReconduction__c != oldOpportunityMap.get(opp.id).DureeReconduction__c && !str.contains('DureeReconduction__c')) {
                str += 'DureeReconduction__c ';
            }

            if(opp.TypeReconduction__c != oldOpportunityMap.get(opp.id).TypeReconduction__c && !str.contains('TypeReconduction__c')) {
                str += 'TypeReconduction__c ';
            }

            if(opp.NombreReconductionsAutorisees__c != oldOpportunityMap.get(opp.id).NombreReconductionsAutorisees__c && !str.contains('NombreReconductionsAutorisees__c')) {
                str += 'NombreReconductionsAutorisees__c ';
            }

            if(opp.ReconductionFaitAutorisee__c != oldOpportunityMap.get(opp.id).ReconductionFaitAutorisee__c && !str.contains('ReconductionFaitAutorisee__c')) {
                str += 'ReconductionFaitAutorisee__c ';
            }

            if(opp.DureePreavis__c != oldOpportunityMap.get(opp.id).DureePreavis__c && !str.contains('DureePreavis__c')) {
                str += 'DureePreavis__c ';
            }

            //added by DKF 26/3/2020 - Task C360-10
            if(opp.Type_de_PdA_reseaux__c != oldOpportunityMap.get(opp.id).Type_de_PdA_reseaux__c && !str.contains('Type_de_PdA_reseaux__c')) {
                str += 'Type_de_PdA_reseaux__c';
            }
            // end modif

            //Added by Jimmy 05/01/2022 - CVS
            if(opp.natureOffre__c != oldOpportunityMap.get(opp.id).natureOffre__c  && !str.contains('natureOffre__c')) {
                str += 'natureOffre__c';
            }
            if(opp.engagementEnergetique__c != oldOpportunityMap.get(opp.id).engagementEnergetique__c  && !str.contains('engagementEnergetique__c')) {
                str += 'engagementEnergetique__c';
            }
            if(opp.paiementDesEnergies__c != oldOpportunityMap.get(opp.id).paiementDesEnergies__c  && !str.contains('paiementDesEnergies__c')) {
                str += 'paiementDesEnergies__c';
            }
            if(opp.niveauDeMaintenance__c != oldOpportunityMap.get(opp.id).niveauDeMaintenance__c && !str.contains('niveauDeMaintenance__c')) {
                str += 'niveauDeMaintenance__c';
            }
            //end CVS

            if(str != ' ' && str != null) {
                if(opp.Tech_ModifiedAPIName__c == null) {
                    opp.Tech_ModifiedAPIName__c = str;
                } else {
                    opp.Tech_ModifiedAPIName__c += str;
                }
            }
        }

    }
    // corrected by JAK 06/01/2020
    public static List<SObject> returnObject (set<id> setOppId){
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
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' WHERE Opportunite__c in: setOppId';

        //Added By Jimmy for ApexSOQLInjection
        String soqlQueryEscaped = String.escapeSingleQuotes(soqlQuery);

        List<sObject> record = Database.query(soqlQueryEscaped);  // Query the list of sObject

        return record; // return SObject Type
    }
}