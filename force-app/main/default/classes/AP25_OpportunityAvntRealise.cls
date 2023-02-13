/*--------------------------------------------------------------------------------------------------------------------------
   Author: Johny Kassis
   Company: EI-Technologies
   Description: This Class is responsible of updating the contrat d'origine and tech fields used in validation rules concerning the field NumeroAvenantOppEvol__c
   Test Class: AP25_OpportunityAvntRealise_Test
   History
   <Date>       <Authors Name>   <Brief Description of Change>
   31/05/2018    Johny Kassis     Created
   --------------------------------------------------------------------------------------------------------------------------*/
public class AP25_OpportunityAvntRealise {
    // static variable to prevent multiple execution of the function
    public static boolean firstRun = true;

    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: update the Contrat d'origine of the Evolution Opportunity when its status is modified to 'Gagnée'
       and change the field TechNumAvnt__c
       Inputs: list of Opportunities, Map<ID, Opportunity> oldMap
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void ModifyContratOrigine(List<Opportunity> newOpp, Map<ID, Opportunity> oldMap){
        IF(firstRun){
            // variables declaration
            List<Opportunity> opportunitiesToUpdate_Cont = new List<Opportunity>();
            List<Opportunity> opportunitiesToUpdate_Cont2 = new List<Opportunity>();
            Set<ID> contratIDs = new Set<ID>();
            Set<ID> contratIDs2 = new Set<ID>();
            set<id> oppEvolId = new set<id>();
            Map<Id, List<Id>> mapContratIdContactIdFromContrat = new Map<Id, List<Id>>();
            list<Document_Contractuel__c> listDocCont = [SELECT id, NumeroPiece__c, OpportuniteRattachee__c
                                                         FROM Document_Contractuel__c
                                                         WHERE OpportuniteRattachee__c in : oldMap.keySet()
                                                         AND NumeroPiece__c != NULL
                                                         AND NatureDocument__c  = 'DOC05'];

            Map<Opportunity, Contrat__c> mapOppContrat = new Map<Opportunity, Contrat__c>();
            Map<id, double> mapContratSumOpp = new Map<id, double>();
            List<Contrat__c> contractToUpdate = new List<Contrat__c>();
            Set<ID> opportunityIDs = new Set<ID>();
            Map<ID, ID> mapOppIdContratId = new Map<ID, ID>();

            for(Document_Contractuel__c dc : listDocCont) {
                oppEvolId.add(dc.OpportuniteRattachee__c);
            }

            For(Opportunity opp: newOpp){

                if(opp.Type_pers__c == Label.Evolution &&  opp.Statut__c == Label.OppBeforeUp_gagne
                   && opp.Statut__c != oldMap.get(opp.id).Statut__c && opp.ContratOrigine__c != NULL && !oppEvolId.contains(opp.id)) {
                    contratIDs.add(opp.ContratOrigine__c);// and the ID of the contrat d'origine
                    mapContratIdContactIdFromContrat.put(opp.ContratOrigine__c, new List<String>());
                    mapOppIdContratId.put(opp.id, opp.ContratOrigine__c);
                }

                if((opp.Statut__c == Label.OppBeforeUp_gagne || oldMap.get(opp.id).Statut__c == Label.OppBeforeUp_gagne) &&
                   opp.Statut__c != oldMap.get(opp.id).Statut__c && opp.ContratOrigine__c != NULL && opp.Type_pers__c == Label.Evolution && !oppEvolId.contains(opp.id)) {
                    opportunitiesToUpdate_Cont2.add(opp);// if the condition is met we add the Opportunity to the list
                    contratIDs2.add(opp.ContratOrigine__c);// and the ID of the contrat d'origin
                }
            }

            //query the contracts
            map<id, Contrat__c> mapidContrat = new Map<id, Contrat__c>([SELECT id, TechByPassRV_ModifSansImpact__c
                                                                        FROM Contrat__c
                                                                        WHERE id in: contratIDs or id in: contratIDs2]);

            //query Opp d'evolution to summ prolongation
            AggregateResult[] listOppEvAgg = [SELECT SUM(DureeProlongationSupp__c) totProl, ContratOrigine__c
                                              FROM Opportunity
                                              WHERE ContratOrigine__c in : contratIDs2
                                              and Type_pers__c = : Label.Evolution
                                              and Statut__c = : Label.OppBeforeUp_gagne group by ContratOrigine__c];

            for(id contId : contratIDs2) {
                mapContratSumOpp.put(contId, 0);
            }
            for(AggregateResult ar : listOppEvAgg) {
                mapContratSumOpp.put((id)ar.get('ContratOrigine__c'), (Double)ar.get('totProl'));
            }

            for(Opportunity opp : opportunitiesToUpdate_Cont2) {
                if(mapidContrat.containskey(opp.ContratOrigine__c)) {
                    mapOppContrat.put(opp, mapidContrat.get(opp.ContratOrigine__c));// Map Of opportunities and their contrat d'origine
                }
            }

            for(Opportunity opp : mapOppContrat.keySet()) {
                Contrat__c cont =  mapOppContrat.get(opp);
                if(contratIDs.contains(mapOppContrat.get(opp).id)) {
                    //set the fields of the contrat using the Opportunity
                    cont.TechByPassRV_ModifSansImpact__c = !cont.TechByPassRV_ModifSansImpact__c;
                    cont.Avenant__c = 'Oui';
                    cont.PuissanceChaud__c = opp.PuissanceChaud__c;
                    cont.PuissanceFroid__c = opp.PuissanceFroid__c;
                    cont.ConsommationChaud__c = opp.ConsommationChaud__c;
                    cont.ConsommationFroid__c = opp.ConsommationFroid__c;
                    cont.TypeContratFirst__c = opp.TypeContratFirst__c;
                    cont.TypePrestations__c = opp.TypePrestations__c;
                    cont.TypeEnergie__c = opp.TypeEnergie__c;
                    cont.TransparenceP3__c = opp.TransparenceP3__c;
                    cont.RapportActivite__c = opp.RapportActivite__c;
                    //cont.SocieteVenteLookup__c = opp.Societevente__c;//19/07/2022 - Ano C360-777 Commented by Jimmy Khalil
                    cont.NomPartenaire__c = opp.AccountId;
                    /* if (cont.NumeroAvenant__c == null || opp.NumeroAvenantOppEvol__c >cont.NumeroAvenant__c)
                       {
                       cont.NumeroAvenant__c=opp.NumeroAvenantOppEvol__c;
                       }*/
                    //Added by Jimmy 05/01/2022 - CVS
                    cont.natureOffre__c = opp.natureOffre__c;
                    cont.engagementEnergetique__c = opp.engagementEnergetique__c;
                    cont.paiementDesEnergies__c = opp.paiementDesEnergies__c;
                    cont.niveauDeMaintenance__c = opp.niveauDeMaintenance__c;
                    //end CVS
                    //C360-609 CKH - start
                    cont.TypeReconduction__c = opp.TypeReconduction__c;
                    cont.NombreReconductionsAutorisees__c = opp.NombreReconductionsAutorisees__c;
                    cont.DureeReconduction__c = opp.DureeReconduction__c;
                    cont.DureePreavis__c = opp.DureePreavis__c;
                    if(opp.TypeReconduction__c == 'RNUL')
                    {
                        cont.NombreReconductionsPassees__c = null;
                    }
                    //C360-609 CKH - end
                }

                if(mapContratSumOpp.containskey(mapOppContrat.get(opp).id) && contratIDs2.contains(mapOppContrat.get(opp).id) ) {
                    cont.DureeProlongationTotale__c = mapContratSumOpp.get(mapOppContrat.get(opp).id);
                }
                contractToUpdate.add(cont);
            }

            if(contractToUpdate.size() > 0) {
                try {
                    update contractToUpdate;

                    //09-05-2022: Added by Jimmy C360-723

                    //Get all contacts related to Opps
                    List<OpportuniteContact__c> listRelatedContactstoOpp = [Select id, Contact__c, Opportunite__c
                                                                            From OpportuniteContact__c
                                                                            Where Opportunite__c in : mapOppIdContratId.keySet()];

                    //Get all contacts related to Contrats origine
                    List<ContratContact__c> listRelatedContactstoContrat = [Select id, Contact__c, Contrat__c
                                                                            From ContratContact__c
                                                                            Where Contrat__c in : contratIDs];

                    //Map Contrat to Related Contacts
                    if(listRelatedContactstoContrat != null && listRelatedContactstoContrat.size() > 0) {
                        for(ContratContact__c relatedContact : listRelatedContactstoContrat) {
                            mapContratIdContactIdFromContrat.get(relatedContact.Contrat__c).add(relatedContact.Contact__c);
                        }
                    }

                    //Add all contacts that are related to the Opp but no related to the Contrat
                    List<ContratContact__c> listCC = new List<ContratContact__c>();
                    if(listRelatedContactstoOpp != null && listRelatedContactstoOpp.size() > 0) {
                        for(OpportuniteContact__c relatedContactOpp : listRelatedContactstoOpp) {
                            Id contratId = mapOppIdContratId.get(relatedContactOpp.Opportunite__c);
                            if(!mapContratIdContactIdFromContrat.get(contratId).contains(relatedContactOpp.Contact__c)) {
                                ContratContact__c cc = new ContratContact__c();
                                cc.Contact__c = relatedContactOpp.Contact__c;
                                cc.contrat__c = contratId;
                                listCC.add(cc);
                            }
                        }
                    }
                    Insert listCC;
                }
                catch(exception e) {
                    if(e.getMessage().contains('_EXCEPTION,')) {
                        newOpp[0].addError(Label.AP25_Erreur + e.getMessage().split('_EXCEPTION,')[1]);
                    } else {
                        newOpp[0].addError(Label.AP25_Erreur + e.getMessage());
                    }
                }
            }

            firstRun = false;
        }
    }
    /*--------------------------------------------------------------------------------------------------------------------------
       Author: Johny Kassis
       Company: EI-Technologies
       Description: Modify the field TechNumAvnt__c to true when the field NumeroAvenantOppEvol__c is changed
       Modify TechNumAvntNoModif__c to true when the Opportunité is 'Gagnée' so that the user won't be able to change
       the field NumeroAvenantOppEvol__c anymore
       Inputs: list of Opportunities, Map<ID, Opportunity> oldMap
       Returns: -
       ----------------------------------------------------------------------------------------------------------------------------*/
    public static void ModifyOppTechNumAvnt(List<Opportunity> newOpp, Map<ID, Opportunity> oldMap){
        For(Opportunity Opp: newOpp){
            if(Opp.Type_pers__c == Label.Evolution &&  Opp.Statut__c == Label.OppBeforeUp_gagne && Opp.Statut__c != oldMap.get(Opp.id).Statut__c && !Opp.TechNumAvntNoModif__c) {
                Opp.TechNumAvntNoModif__c = true;
            }
        }
    }
}