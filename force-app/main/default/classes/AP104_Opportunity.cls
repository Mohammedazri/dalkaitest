/*--------------------------------------------------------------------------------------------------------------------------
   Author: Jimmy Khalil
   Company: EI-Technologies
   Description: Class used by opportunity triggers OpportunityBeforeInsert to set the value for the field nature de l'offre (CVS)
   Test Class: AP104_Opportunity_Test
   History
   <Date>      <Authors Name>   <Brief Description of Change>
   03/01/2022	 Jimmy Khalil	  Creation
   --------------------------------------------------------------------------------------------------------------------------*/

public without sharing class AP104_Opportunity {

    public static void setNatureOffre(list<Opportunity> listOpportunities){
        Set<String> setOppMereIDs = new Set<String>();
        Set<String> setContratOrigine = new Set<String>();
        Map<Id, Opportunity> mapOppMere = new Map<Id, Opportunity>();
        Map<Id, Contrat__c> mapIdContratOrigine = new Map<Id, Contrat__c>();

        //Recuperer les opp meres des nouveaux opp filles SPU
        for(Opportunity opp : listOpportunities) {
            if(opp.Qualification__c.contains('Fille') && opp.OpportuniteMere__c != null && opp.NatureOpportunitMere__c == Label.AP104_NatureMereSPU) {
                setOppMereIDs.add(opp.OpportuniteMere__c);
            }
            //If Opp fille Renouv SPU -> complete values for certain types and fille
            if(opp.Qualification__c == 'Renouvellement Fille / PDA' && opp.NatureOpportunitMere__c == Label.AP104_NatureMereSPU) {
                setContratOrigine.add(opp.ContratOrigine__c  );
            }
        }
        if(setOppMereIDs.size() > 0) {
            mapOppMere = new Map<Id, Opportunity>([Select id, natureOffre__c, engagementEnergetique__c, paiementDesEnergies__c, niveauDeMaintenance__c
                                                   From Opportunity
                                                   Where id in: setOppMereIDs
                                                  ]);
        }

        //Query Contrat Origine of Opps to get the fields from Opp Commerciale of Contrat Cadre
        if(setContratOrigine.size() > 0) {
            mapIdContratOrigine = new Map<Id, Contrat__c>([Select id, natureOffre__c, engagementEnergetique__c, paiementDesEnergies__c, niveauDeMaintenance__c
                                                           From Contrat__c
                                                           Where id in: setContratOrigine
                                                          ]);
        }

        //set cvs values
        for(Opportunity opp : listOpportunities) {
            //Pour les opportunités nouvelle filles SPU, les champs de CVS sont copier du mere
            if(opp.Qualification__c == 'Nouvelle Fille / PDA' && opp.NatureOpportunitMere__c == Label.AP104_NatureMereSPU
               && opp.OpportuniteMere__c != null && mapOppMere != null && mapOppMere.size() > 0 && mapOppMere.containsKey(opp.OpportuniteMere__c)) {
                opp.natureOffre__c = mapOppMere.get(opp.OpportuniteMere__c).natureOffre__c;
                opp.engagementEnergetique__c = mapOppMere.get(opp.OpportuniteMere__c).engagementEnergetique__c;
                opp.paiementDesEnergies__c = mapOppMere.get(opp.OpportuniteMere__c).paiementDesEnergies__c;
                opp.niveauDeMaintenance__c = mapOppMere.get(opp.OpportuniteMere__c).niveauDeMaintenance__c;
            }

            if(opp.Qualification__c.contains('Fille') && opp.NatureOpportunitMere__c == Label.AP104_NatureMereReseau) {
                //Pour les opportunités filles "Réseau", nature de l'offre = "police d'abonnement réseau" et Engagement énergetique= "Avec engagement de résultat sans travaux"
                opp.natureOffre__c = Label.AP104_NaturePolice;
                opp.engagementEnergetique__c = Label.AP104_EngagementSansTravaux;
                opp.paiementDesEnergies__c = Label.AP104_PaiementDalkia;
                opp.niveauDeMaintenance__c = Label.AP104_NiveauGER;
            }

            if(opp.Qualification__c == 'Renouvellement Fille / PDA' && opp.NatureOpportunitMere__c == Label.AP104_NatureMereSPU && mapIdContratOrigine != null && mapIdContratOrigine.size() > 0 && mapIdContratOrigine.containsKey(opp.ContratOrigine__c)) {
                //For Opp fille Renouv SPU -> Copie from contrat origine
                Contrat__c contratOrigine = mapIdContratOrigine.get(opp.ContratOrigine__c);

                opp.natureOffre__c = contratOrigine.natureOffre__c;
                opp.engagementEnergetique__c = contratOrigine.engagementEnergetique__c;
                opp.paiementDesEnergies__c = contratOrigine.paiementDesEnergies__c;
                opp.niveauDeMaintenance__c = contratOrigine.niveauDeMaintenance__c;
            }

            if(opp.Qualification__c.contains(Label.AP104_Renouvellement) && opp.EstOpportuniteMere__c == true) {
                //For Opp Mere Renouv SPU ->  nature de l'offre = "Solution point unique (SPU)"
                if(opp.NatureOpportunitMere__c == Label.AP104_NatureMereSPU) {
                    opp.natureOffre__c = Label.AP104_NaturePointUnique;
                }

            }

        }

    }

}