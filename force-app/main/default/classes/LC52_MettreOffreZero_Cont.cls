/**
* @author: Jacques Akiki -EI Technologies
* @date:18/04/2019 
* @description: Controller of lightning component LC52_MettreOffreZero
* @Test Class: LC52_MettreOffreZero_Cont_Test 
* @Coverage: 88%
*/
public without sharing class LC52_MettreOffreZero_Cont 
{
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 18/04/2019
* @description: This method returns  the name of the FDS to show it in the Lightning component   
* @inputs: id
* @returns: String 
*/     
    @AuraEnabled
    public static String loadFDS(Id oppID)
    {
        //use the Opportunity ID to query the Opportunity 
        Fiche_de_synthese__c fds = new Fiche_de_synthese__c(); 
         fds = [SELECT id,name,Opportunit_commerciale__c
                FROM Fiche_de_synthese__c
                WHERE Opportunit_commerciale__c =:oppID LIMIT 1]; // Use Opportunity Id to query related FDS
        return fds.name;
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 24/04/2019
* @description: set Tech_ResilistionFirst__c to true to control LC visibility 
* @inputs: id
* @returns: String 
*/   
    
    @AuraEnabled
    public static String modifyTech(Id oppID)
    {
        Opportunity opp = new Opportunity();
        opp.Id =oppID; 
        opp.Tech_ResilistionFirst__c = true;
        User usr=[SELECT id,Name,BypassValidationRules__c 
                  FROM User 
                  WHERE Id =:UserInfo.getUserId() LIMIT 1]; // query current user
        Boolean state = usr.BypassValidationRules__c; // save bypass VR state
        if (!state)
        {
            usr.BypassValidationRules__c = true; // Bypass Validation rules
            update usr;
        }
        try{
            update opp;
            
            if (usr.BypassValidationRules__c !=state)
            {
                usr.BypassValidationRules__c = state; // return Bypass to initial state
                update usr;
            }
            return 'OK';
        }
        catch(Exception e)
        {
            if (usr.BypassValidationRules__c !=state)
            {
                usr.BypassValidationRules__c = state;
                update usr;
            }
            return e.getMessage();
        }
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 18/04/2019
* @description: This method sets to 0 the values of all editable offre 
* @inputs: id
* @returns: String 
*/   
    
    @AuraEnabled
    public static String annulerOffre(Id oppID)
    {
        Fiche_de_synthese__c fds = [SELECT id,name,Opportunit_commerciale__c
                                    FROM Fiche_de_synthese__c
                                    WHERE Opportunit_commerciale__c =:oppID LIMIT 1];
        
        User usr=[SELECT id,Name,BypassValidationRules__c 
                  FROM User 
                  WHERE Id =:UserInfo.getUserId() LIMIT 1]; // query current user
        Boolean state = usr.BypassValidationRules__c; // save bypass VR state
        if (!state)
        {
            usr.BypassValidationRules__c = true; // Bypass Validation rules
            update usr;
        }
        
        Fiche_de_synthese__c myFDS = new Fiche_de_synthese__c();
        myFDS.Id = fds.Id;
        // mettre a 0 tous les champs offre de la fiche de synthèse
        myFDS.OffreA1P1Investissements__c=0;
        myFDS.OffreA1P1VentesServices__c=0;
        myFDS.OffreA1P1AchatsEnergieGaz__c=0;
        myFDS.OffreA1P1AchatsEnergieFuel__c=0;
        myFDS.OffreA1P1AchatsEnergieCharbon__c=0;
        myFDS.OffreA1P1AchatsEnergieBiomasse__c=0;
        myFDS.OffreA1P1AchatsEnergieElectricite__c=0;
        myFDS.OffreA1P1AchatsAutresEnergies__c=0;
        myFDS.OffreA1P1Amortissements__c=0;
        myFDS.OffreA1P1AutresChargesEtProduits__c=0;
        myFDS.OffreA1P2Investissements__c=0;
        myFDS.OffreA1P2VentesServices__c=0;
        myFDS.OffreA1P2Fournituresetpetitsmat__c=0;
        myFDS.OffreA1P2Electricite__c=0;
        myFDS.OffreA1P2EauProduitsTrait__c=0;
        myFDS.OffreA1P2STControlesReglem__c=0;
        myFDS.OffreA1P2STEntretienCompteurs__c=0;
        myFDS.OffreA1P2STGECogeneration__c=0;
        myFDS.OffreA1P2STTraitementEau__c=0;
        myFDS.OffreA1P2STMultiservices__c=0;
        myFDS.OffreA1P2STAutresPrestations__c=0;
        myFDS.OffreA1P2SousTraitanceInterne__c=0;
        myFDS.OffreA1P2LocationsEntretien__c=0;
        myFDS.OffreA1P2Telesurveillance__c=0;
        myFDS.OffreA1P2EtudesDemarrage__c=0;
        myFDS.OffreA1P2Amortissements__c=0;
        myFDS.OffreA1P2AutresChargesEtProduits__c=0;
        myFDS.OffreA1P3VentesServices__c=0;
        myFDS.OffreA1P3AchatsExternes__c=0;
        myFDS.OffreA1P3Autreschargesetproduits__c=0;
        myFDS.OffreA1P4Investissements__c=0;
        myFDS.OffreA1P4VentesServices__c=0;
        myFDS.OffreA1P4Amortissements__c=0;
        myFDS.OffreA1P4Autreschargesetproduits__c=0;
        myFDS.OffreA1P6VentesServices__c=0;
        myFDS.OffreA1P6AchatsExternes__c=0;
        myFDS.OffreA1P6Autreschargesetproduits__c=0;
        myFDS.OffreA1MainOeuvreDontNbHeureP2__c=0;
        myFDS.OffreA1MainOeuvreDontNbHeureP3__c=0;
        myFDS.OffreA1MainOeuvreDontNbHeureP6__c=0;
        myFDS.OffreA1MainOeuvreValorisationTHO__c=0;
        myFDS.OffreA1MainOeuvreEffectifDedie__c=0; 
        
        try
        {
            update myFDS; // update the values of offre
            if (usr.BypassValidationRules__c !=state)
            {
                usr.BypassValidationRules__c = state; // return Bypass to initial state
                update usr;
            }
            String response = modifyTech(oppID);
            return response;
        }
        catch(exception e)
        {
            if (usr.BypassValidationRules__c !=state)
            {
                usr.BypassValidationRules__c = state;
                update usr;
            }
            return e.getMessage();
        }
    }
}