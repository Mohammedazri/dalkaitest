/*--------------------------------------------------------------------------------------------------------------------------
Author: Christine Bayssary
Company: EI-Technologies
Description: The aim of this class is to prevent the user from duplicating Renewal opportunities for the same original contract.
             In addition, it prevents the user from adding Renewal or Evolution type opportunities if the original contract is 
             terminated.
Test Class: AP09_Opportunity_test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP09_Opportunity {
    public static boolean firstRun = true;
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
	 Company: EI-technologies
	 Description: Prevent the user from updating an opportunity of type Renewal if the original contract is already linked 
                  to an opportunity of this type.
     Inputs: list of the modified opportunities & map of the old value
	 Returns: -
	----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkExistanceRenewalOppUpd(list<opportunity> listOpportunity,map<id,opportunity> OldMap){
        if (firstRun) {
            map<id,list<opportunity>> mapContractOpps = new map<id,list<opportunity>>();
            for(Opportunity opp :listOpportunity){
                if(opp.Type_pers__c != OldMap.get(opp.id).Type_pers__c &&  opp.Type_pers__c==label.Opp_type_Renewal && opp.ContratOrigine__c != null){
                    if(!mapContractOpps.containsKey(opp.ContratOrigine__c)){
                        mapContractOpps.put(opp.ContratOrigine__c,new list<opportunity>());}
                    mapContractOpps.get(opp.ContratOrigine__c).add(opp);}}
            if(mapContractOpps.keyset().size()>0){
                checkExistanceRenewalOpp(mapContractOpps);
                firstRun = false;
            }}}
     /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
	 Company: EI-technologies
	 Description: Prevent the user from adding an opportunity of type Renewal if the original contract is already linked 
                  to an opportunity of this type.
     Inputs: list of the added opportunities
	 Returns: -
	----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkExistanceRenewalOppIns(list<opportunity> listOpportunity){    
        map<id,list<opportunity>> mapContractOpps = new map<id,list<opportunity>>();
        for(Opportunity opp :listOpportunity){
            if(opp.Type_pers__c==label.Opp_type_Renewal && opp.ContratOrigine__c != null){
                if(!mapContractOpps.containsKey(opp.ContratOrigine__c)){
                    mapContractOpps.put(opp.ContratOrigine__c,new list<opportunity>());}
                mapContractOpps.get(opp.ContratOrigine__c).add(opp);}}
        if(mapContractOpps.keyset().size()>0){
            checkExistanceRenewalOpp(mapContractOpps);
        }}
   
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
	 Company: EI-technologies
	 Description: This method will add a blocking message if the original contract is already linked to a Renewal opportunity.
     Inputs: map of the original contract and its related opportunities of type Renewal
	 Returns: -
	----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkExistanceRenewalOpp(map<id,list<opportunity>> mapContractOpps){
        List<opportunity> listOpportunities=[select id,ProjetCommercial__c,ContratOrigine__c,Lien_Explore__c,Reference_Explore__c, Type_davis__c, Type_de_marche__c, 
                                             PrestationsAssociees__c, Forme_du_marche__c, Renouvellement__c, echeance_du_marche__c, Surface_m2__c, Effectif__c,Type_pers__c  
                                             from opportunity
                                             where contratorigine__c in :mapContractOpps.keyset()
                                             and Type_pers__c =:label.Opp_type_Renewal
                                             and statut__c =:label.Opp_StatutEnCours];
                
        for(Opportunity opp : listOpportunities){
            list<opportunity> listOpp= mapContractOpps.get(opp.contratorigine__c);
            for(Opportunity opp1 : listOpp){
                if(opp.contratorigine__c == opp1.contratorigine__c) {
                    ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, LAbel.LC17_errorMsg);
                    opp1.adderror(msg.getDetail());}}
        }}
    
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
	 Company: EI-technologies
	 Description: This method adds a blocking message if the opportunity is changed to the Renewal type and linked to a terminated original contract.
     Inputs: list of the modified opportunities & map of the old value
	 Returns: -
	----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkContractResilieUpd(list<opportunity> listOpportunity,map<id,opportunity> OldMap){
        list<Opportunity> listOpportunities = new list<Opportunity>();
        list<id> listContratUpdIds = new list<id>();
        for(Opportunity opp :listOpportunity){
            if(opp.Type_pers__c != OldMap.get(opp.id).Type_pers__c &&  (opp.Type_pers__c==label.Opp_type_Renewal || opp.Type_pers__c==label.Opp_type_Evolution) && opp.ContratOrigine__c != null ){
                listOpportunities.add(opp);
                listContratUpdIds.add(opp.ContratOrigine__c);
            }}
        map<id,contrat__c> mapContrats = new map<id,contrat__c>([select id,Resilie__c,statut__c  from contrat__c where id in : listContratUpdIds]);
        for(opportunity opp :listOpportunities){
            if(opp.ContratOrigine__c == mapContrats.get(opp.ContratOrigine__c).id && (mapContrats.get(opp.ContratOrigine__c).Resilie__c== label.Contrat_Resilie || mapContrats.get(opp.ContratOrigine__c).statut__c ==label.Opp_StatutFermeture)){
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, label.LC17_ContratResili);
                opp.adderror(msg.getDetail()); 
            }
        }        
        
    }
    /*--------------------------------------------------------------------------------------------------------------------------
     Author: Christine Bayssary
	 Company: EI-technologies
	 Description: This method adds a blocking message if the added opportunity is of type Renewal and linked to a terminated original contract.
     Inputs: list of the added opportunities
	 Returns: -
	----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkContractResilieIns(list<opportunity> listOpportunity){
        list<Opportunity> listOpportunities = new list<Opportunity>();
        list<id> listContratInsIds = new list<id>();
        for(Opportunity opp :listOpportunity){
            if((opp.Type_pers__c==label.Opp_type_Renewal || opp.Type_pers__c==label.Opp_type_Evolution) && opp.ContratOrigine__c != null){
                listOpportunities.add(opp);
                listContratInsIds.add(opp.ContratOrigine__c);
            }}
        map<id,contrat__c> mapContrats = new map<id,contrat__c>([select id,Resilie__c,statut__c  from contrat__c where id in : listContratInsIds]);
        for(opportunity opp :listOpportunities){
            if(opp.ContratOrigine__c == mapContrats.get(opp.ContratOrigine__c).id && (mapContrats.get(opp.ContratOrigine__c).Resilie__c== label.Contrat_Resilie || mapContrats.get(opp.ContratOrigine__c).statut__c ==label.Opp_StatutFermeture)){
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, label.LC17_ContratResili);
                opp.adderror(msg.getDetail()); 
            }
        }        
    }
    
}