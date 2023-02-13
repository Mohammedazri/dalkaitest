/*-------------------------------------------------------------------------------------------------------------------------------------
   Author: Jacques Akiki
   Company: EI-Technologies
   Description: Class responsible of creating new opportunités de renouv when a Opp Mère is réalisée and gagnée. If réalisée and Perdue set
   all contrats fils to fermé.
   Test Class: AP38_OpportunityContratCadre_test
   History
   <Date>      <Authors Name>      <Brief Description of Change>
   28/11/2018   Chadi Geara      Changed the If statements logic to If-else...
   28/11/2018   Chadi Geara      Fixed the bug when the contrat name have specific format
   26/3/2020    Dona Kfoury      added Type de PdA to the list of fields copied to the opps de renouvellement
   01/07/2022	 Jimmy Khalil	  Substring Contrat Name and check if contrats fils already have generated opp renouv
   -------------------------------------------------------------------------------------------------------------------------------------*/

public without sharing class AP38_OpportunityContratCadre {
    public static void createContratFils(List<Opportunity> opportunityList){
        Set<id> SetContPG = new Set<Id>();
        Set<id> SetContPP = new Set<Id>();

        for(Opportunity Opp : opportunityList) {
            if(Opp.Statut__c == Label.OppBeforeUp_gagne) {
                SetContPG.add(Opp.ContratOrigine__c); // id des contrats parents si opp gagnée
            } else {
                SetContPP.add(Opp.ContratOrigine__c); // id des contrats parents si opp perdue
            }
        }

        String SetPG;
        String SetPP;
        if(SetContPG != NULL) {
            SetPG = JSON.serialize(SetContPG);
        }
        if(SetContPP != NULL) {
            SetPP = JSON.serialize(SetContPP);
        }

        createContratFilsFuture(SetPG, SetPP, JSON.serialize(opportunityList));
    }

    @Future
    public static void createContratFilsFuture(String SetPG, String SetPP, String OppList){
        Set<id> SetContPG = new Set<Id>();
        Set<id> SetContPP = new Set<Id>();
        List<Contrat__c> ListContFils = new List<Contrat__c>();
        List<Contrat__c> ListContFilsP = new List<Contrat__c>();
        List<Opportunity> ListOpp = new List<Opportunity>();
        List<Opportunity> opportunityList = (list<Opportunity>)JSON.deserialize(OppList, List<Opportunity> .class);

        if(SetPG != NULL) {
            SetContPG = (set<id>)JSON.deserialize(SetPG, set<id> .class);
        }
        if(SetPP != NULL) {
            SetContPP = (set<id>)JSON.deserialize(SetPP, set<id> .class);
        }

        if(SetContPP != NULL && SetContPP.size() > 0) {
            ListContFilsP = [SELECT id, name, Statut__c, ContratCadre__c
                             FROM Contrat__c
                             WHERE ContratCadre__c in: SetContPP]; //list of all child contracts of perdue
        }

        if(SetContPG != NULL && SetContPG.size() > 0) {
            ListContFils = [SELECT id, name, Statut__c, ContratCadre__c, DureeInitialeContrat__c, Type_de_PdA_reseaux__c, SocieteVenteLookup__c, NomPartenaire__c, OwnerID,
                            OpportuniteCommerciale__r.Reference_Explore__c, OpportuniteCommerciale__r.Type_davis__c, OpportuniteCommerciale__r.Type_de_marche__c,
                            OpportuniteCommerciale__r.PrestationsAssociees__c, OpportuniteCommerciale__r.Forme_du_marche__c, OpportuniteCommerciale__r.Renouvellement__c, OpportuniteCommerciale__r.echeance_du_marche__c,
                            OpportuniteCommerciale__r.Surface_m2__c, OpportuniteCommerciale__r.Effectif__c, OpportuniteCommerciale__r.ContactPartenaireConversionPotentiel__c, OpportuniteCommerciale__r.Segment_client__c,
                            OpportuniteCommerciale__r.Moisdesignature__c, OpportuniteCommerciale__r.Annee_de_signature__c, NatureContratCadre__c, OpportuniteCommerciale__r.SousSegmentMarche__c
                            ,ContratObligeantCEEContratPck__c
                            FROM Contrat__c
                            WHERE ContratCadre__c in: SetContPG AND Statut__c !=:Label.ContratFerme]; //list of all child contracts.
        }

        if(ListContFils != NULL && ListContFils.size() > 0) {
            map<contrat__c, id> mapContId = new map<contrat__c, id>();
            set<id> setContFilsId = new set<id>();
            for(contrat__c cont : ListContFils) {
                setContFilsId.add(cont.id);
                for(Opportunity Opp : opportunityList) {
                    if(cont.ContratCadre__c == Opp.ContratOrigine__c) {
                        mapContId.put(Cont, Opp.Id);
                    }
                }
            }
            /*query all contacts related to contrat fils*/
            List<ContratContact__c> listContContact = [SELECT id, Contact__c, contrat__c
                                                       FROM ContratContact__c
                                                       WHERE Contrat__c in:setContFilsId];

            // 01/07/2022: added by Jimmy Ano C360-771
            //Vérifier si les contrats fils n'ont pas déjà une opportunité de renouvellement avant d'en générer une
            Set<Id> setContFilsWithExistingOppFille = new Set<Id>();
            for(Opportunity existingOppFille : [Select id, ContratOrigine__c
                                                From Opportunity
                                                Where ContratOrigine__c in : setContFilsId
                                                And Type_pers__c = : label.Renouvellement]) {
                setContFilsWithExistingOppFille.add(existingOppFille.ContratOrigine__c);
            }

            for(Contrat__c Cont : ListContFils) {
                //create opp fille renouv for contrat fil wihtout existing opp renouv
                if(!setContFilsWithExistingOppFille.contains(Cont.Id)) {

                    Opportunity opp = new Opportunity();
                    opp.CloseDate = System.today();// to see and handle later
                    String name = '';
                    if(cont.Name.contains('MAITRE (DSP)')) {
                        List<String> listSplit = cont.Name.split('MAITRE \\(DSP\\)');
                        if(listSplit.size() == 2) {
                            name = listSplit.get(0) + 'SST';
                        } else if(listSplit.size() > 2) {
                            for(Integer i = 0; i < listSplit.size() - 2; i++) {
                                name = name + listSplit.get(i) + 'MAITRE (DSP)';
                            }
                            name = name + listSplit.get(listSplit.size() - 2) + 'SST';
                        }
                    } else if(cont.Name.contains('MAÎTRE (DSP)') ) {
                        List<String> listSplit = cont.Name.split('MAÎTRE \\(DSP\\)');
                        if(listSplit.size() == 2) {
                            name = listSplit.get(0) + 'SST';
                        } else if(listSplit.size() > 2) {
                            for(Integer i = 0; i < listSplit.size() - 2; i++) {
                                name = name + listSplit.get(i) + 'MAÎTRE (DSP)';
                            }
                            name = name + listSplit.get(listSplit.size() - 2) + 'SST';
                        }

                    } else if(cont.Name.contains('MAITRE')) {
                        List<String> listSplit = cont.Name.split('MAITRE');
                        if(listSplit.size() == 2) {
                            name = listSplit.get(0) + 'SST';
                        } else if(listSplit.size() > 2) {
                            for(Integer i = 0; i < listSplit.size() - 2; i++) {
                                name = name + listSplit.get(i) + 'MAITRE';
                            }
                            name = name + listSplit.get(listSplit.size() - 2) + 'SST';
                        }
                    } else if(cont.Name.contains('MAÎTRE')) {
                        List<String> listSplit = cont.Name.split('MAÎTRE');
                        if(listSplit.size() == 2) {
                            name = listSplit.get(0) + 'SST';
                        } else if(listSplit.size() > 2) {
                            for(Integer i = 0; i < listSplit.size() - 2; i++) {
                                name = name + listSplit.get(i) + 'MAÎTRE';
                            }
                            name = name + listSplit.get(listSplit.size() - 2) + 'SST';
                        }
                    } else if(cont.Name.contains('DSP')) {
                        List<String> listSplit = cont.Name.split('DSP');
                        if(listSplit.size() == 2) {
                            name = listSplit.get(0) + 'SST';
                        } else if(listSplit.size() > 2) {
                            for(Integer i = 0; i < listSplit.size() - 2; i++) {
                                name = name + listSplit.get(i) + 'DSP';
                            }
                            name = name + listSplit.get(listSplit.size() - 2) + 'SST';
                        }
                    } else {
                        name = Cont.Name;
                    }
                    // 01/07/2022: modified by Jimmy Ano C360-770
                    // Tronquer à 74 caractères les libellés des opportunités de renouvellement générés (ne se produit que si le contrat d'origine a été renommé)
                    if(name.length() > 74) {
                        name = name.substring(0, 74);
                    }
                    opp.Name = name;
                    opp.StageName = Label.LC29_NewStage;
                    opp.Moisdesignature__c = Cont.OpportuniteCommerciale__r.Moisdesignature__c;
                    opp.Annee_de_signature__c = Cont.OpportuniteCommerciale__r.Annee_de_signature__c;
                    if(mapContId.containskey(Cont)) {
                        opp.OpportuniteMere__c = mapContId.get(Cont);
                    }
                    opp.Reference_Explore__c = Cont.OpportuniteCommerciale__r.Reference_Explore__c;
                    opp.Type_davis__c = Cont.OpportuniteCommerciale__r.Type_davis__c;
                    opp.Type_de_marche__c = Cont.OpportuniteCommerciale__r.Type_de_marche__c;
                    opp.PrestationsAssociees__c = Cont.OpportuniteCommerciale__r.PrestationsAssociees__c;
                    opp.Forme_du_marche__c = Cont.OpportuniteCommerciale__r.Forme_du_marche__c;
                    opp.Renouvellement__c = Cont.OpportuniteCommerciale__r.Renouvellement__c;
                    opp.echeance_du_marche__c = Cont.OpportuniteCommerciale__r.echeance_du_marche__c;
                    opp.Surface_m2__c = Cont.OpportuniteCommerciale__r.Surface_m2__c;
                    opp.Effectif__c = Cont.OpportuniteCommerciale__r.Effectif__c;
                    opp.ContactPartenaireConversionPotentiel__c = Cont.OpportuniteCommerciale__r.ContactPartenaireConversionPotentiel__c;
                    opp.Segment_client__c = Cont.OpportuniteCommerciale__r.Segment_client__c;
                    opp.SousSegmentMarche__c = Cont.OpportuniteCommerciale__r.SousSegmentMarche__c;
                    opp.OwnerId = Cont.OwnerID;
                    opp.AccountId = Cont.NomPartenaire__c;
                    opp.Statut__c = Label.OpportunityStatusEnCours;
                    opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Label.RT_Opp_Creation).getRecordTypeId();
                    opp.Type_pers__c = label.Renouvellement;
                    opp.ContratOrigine__c = Cont.id;
                    opp.Societevente__c = Cont.SocieteVenteLookup__c;
                    //opp.Duree_minimale_estimee__c = Cont.DureeInitialeContrat__c;
                    opp.NatureOpportunitMere__c = Cont.NatureContratCadre__c;
                    //added by DKF 26/3/2020 - Task C360-10
                    if(Cont.NatureContratCadre__c == 'Réseau') {
                        opp.Type_de_PdA_reseaux__c =  'Renouvellement PDA';
                    } else {
                        opp.Type_de_PdA_reseaux__c =  Cont.Type_de_PdA_reseaux__c;
                    }
                    //end modif

                    //13-07-2022 Added by Charbel KH: US C360-729
                    //opp.ContratObligeantCEE__c = Cont.ContratObligeantCEEContrat__c;
                    //End US C360-729
                    opp.ContratObligeantCEEPck__c = Cont.ContratObligeantCEEContratPck__c;

                    ListOpp.add(opp);
                }
            }

            if(ListOpp != NULL && ListOpp.size() > 0) {
                try {
                    insert ListOpp;
                    /*Copy contacts from fontrat to opportunites filles*/
                    map<id, id> mapContOpp = new map<id, id>();
                    for(Opportunity opp : ListOpp) {
                        mapContOpp.put(opp.ContratOrigine__c, opp.id);
                    }
                    List<OpportuniteContact__c> listOC = new List<OpportuniteContact__c>();

                    if(listContContact != NULL && listContContact.size() > 0) {
                        for(ContratContact__c cc : listContContact) {
                            if(mapContOpp.containskey(cc.contrat__c)) {
                                OpportuniteContact__c oc = new OpportuniteContact__c();
                                oc.Contact__c = cc.contact__c;
                                oc.Opportunite__c = mapContOpp.get(cc.contrat__c);
                                listOC.add(oc);
                            }
                        }
                        if(listOC != null && listOC.size() > 0) {
                            insert listOC;
                        }
                    }
                    /*end of contact copying*/

                    //03-10-2022 Ajouter par jimmy
                    addContratMembersToOppMembers(ListOpp, ListContFils);
                }
                catch(Exception e) {
                    System.debug('The error in insert of opportunity is :' + e.getMessage());
                }
            }
        }

        if(ListContFilsP != NULL && ListContFilsP.size() > 0) {
            for(Contrat__c Cont : ListContFilsP) {
                Cont.Statut__c = Label.ContratFerme;
            }

            try {
                SCHD13_updateContratsFilsPerdus.scheduleMe(AP40_Contrat.GenerateCronExpression(DateTime.now(), 1), ListContFilsP, 'MAJ-CFilsPerdusAP38' + DateTime.now());
            }
            catch(Exception e) {
                System.debug('The error in updating the contart is :' + e.getMessage());
            }

        }
    }

    //03-10-2022 Ajouter par jimmy A la création d'une opportunité d'évolution ou renouvellement, recopier l'équipe du contrat sur cette opportunité (US C360-815)
    public static void addContratMembersToOppMembers(List<Opportunity> listOpps, List<Contrat__c> listContrats){
        Set<String> setContId = new Set<String>();
        Map<String, List<Contrat__share>> mapContactContactShare = new Map<String, List<Contrat__share>>();
        List<OpportunityTeamMember> listOTM = new List<OpportunityTeamMember>();

        for(Contrat__c con : listContrats) {
            setContId.add(con.Id);
        }

        List<Contrat__share> listRelatedContrat = [Select id, ParentId, UserOrGroupId, AccessLevel
                                                   From Contrat__share
                                                   Where ParentId in:setContId and (RowCause='Manual' or RowCause='Owner')];

        for(Contrat__share contShare : listRelatedContrat) {
            if(!mapContactContactShare.containskey(contShare.ParentId)) {
                mapContactContactShare.put(contShare.ParentId, new List<Contrat__share>());
            }
            mapContactContactShare.get(contShare.ParentId).add(contShare);
        }

        for(Opportunity opp : listOpps) {
            if(mapContactContactShare.containskey(opp.ContratOrigine__c)) {
                for(Contrat__share contShare : mapContactContactShare.get(opp.ContratOrigine__c)) {
                    //owner will be added from AP94_Opportunity
                    if(opp.OwnerId != contShare.UserOrGroupId) {
                        OpportunityTeamMember otm = new OpportunityTeamMember();
                        otm.OpportunityId = opp.Id;
                        otm.OpportunityAccessLevel = contShare.AccessLevel;
                        otm.UserId = contShare.UserOrGroupId;
                        otm.TeamMemberRole = Label.PV_OTM_Comm;
                        listOTM.add(otm);
                    }
                }
            }
        }
        insert listOTM;
    }
}