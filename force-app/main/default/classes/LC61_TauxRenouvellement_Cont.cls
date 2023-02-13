/**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description: Controller of LC61_TauxRenouvellement that displays the calculations of Taux de renouvellement 
* @Test Class: LC61_TauxRenouvellement_Cont_Test  
* @Coverage: 81% 
*/
public without sharing class LC61_TauxRenouvellement_Cont {   
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description:  The method returns the picklist values of the Field Segment de marché 
* @inputs: -
* @returns: List<String>
*/   @AuraEnabled
    public static List<String> GetSegementPicklistValues()
    {
        List<string> options = new List<string>();// List used to return the value of the picklist field Segment_client__c 
        Schema.DescribeFieldResult fieldResult = Opportunity.Segment_client__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); // retrieve all the values of the picklist Segment_client__c
        options.add('N/A'); // add the value N/A
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());// add the values to the list 
        }
        
        return options;
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description:  Calculate the Taux de renouvellement global 
* @inputs: String
* @returns: Decimal
*/     
    @AuraEnabled
    public static Decimal calculTauxdeRenouvellementGlobal(String Segment)
    {
        Decimal Taux = 0;
        Integer currentYear = System.Today().year();
        String year = String.valueOf(currentYear);
        
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        if (Segment == 'N/A')
        {  
            listFDS=[SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                     EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                     Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                     Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                     FROM Fiche_de_synthese__c 
                     WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                     AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                     AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation];
        }
        else
        {
            listFDS=[SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                     EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                     Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                     Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                     FROM Fiche_de_synthese__c 
                     WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                     AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                     AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                     AND Opportunit_commerciale__r.Segment_client__c=:Segment];
        }
        if (listFDS <> NULL && listFDS.size()>0)
        {
            Taux = CalcuTaux(listFDS); 
        }
        return (100*Taux).setScale(2);
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description:  Calculate the Taux de renouvellement by Region 
* @inputs: String
* @returns: Decimal
*/    
    @AuraEnabled
    public static Decimal calculTauxdeRenouvellementRegion(String Segment)
    {
        Decimal Taux = 0;
        Integer currentYear = System.Today().year();
        String year = String.valueOf(currentYear);
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        User CurrentUser = [SELECT id ,Nom_region__c 
                            FROM User 
                            WHERE id =:UserInfo.getUserId()];
        
        if (CurrentUser.Nom_region__c<> NULL && Segment =='N/A') // if no segment is precised select all FDS related  to this region
        {
            listFDS = [SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                       EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                       Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                       Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                       FROM Fiche_de_synthese__c 
                       WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                       AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                       AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                       AND Opportunit_commerciale__r.Libelle_Region__c =:CurrentUser.Nom_region__c ];
        }
        else if (CurrentUser.Nom_region__c<> NULL && Segment <>'N/A')// if segment is precised select all FDS related  to this region
        {
            listFDS = [SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                       EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                       Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                       Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                       FROM Fiche_de_synthese__c 
                       WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                       AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                       AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                       AND Opportunit_commerciale__r.Libelle_Region__c =:CurrentUser.Nom_region__c 
                       AND Opportunit_commerciale__r.Segment_client__c=:Segment];  
        }
        
        else
        {
            listFDS = null;
        }
        
        if (listFDS <> NULL && listFDS.size()>0)
        {
            Taux = CalcuTaux(listFDS);
        }
        return (100*Taux).setScale(2);
    }
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description:  Calculate the Taux de renouvellement by Agence 
* @inputs: String
* @returns: Decimal
*/
    @AuraEnabled
    public static Decimal calculTauxdeRenouvellementAgence(String Segment)
    {
        Decimal Taux = 0;
        Integer currentYear = System.Today().year();
        String year = String.valueOf(currentYear);
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        User CurrentUser = [SELECT id ,Nom_agence__c 
                            FROM User 
                            WHERE id =:UserInfo.getUserId()];
        if(CurrentUser.Nom_agence__c<>NULL && Segment =='N/A') // if no segment is precised select all FDS related  to this agence
        {
            listFDS = [SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                       EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                       Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                       Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                       FROM Fiche_de_synthese__c 
                       WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                       AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                       AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                       AND Opportunit_commerciale__r.Libelle_Agence__r.name =:CurrentUser.Nom_agence__c];
        }
        else if(CurrentUser.Nom_agence__c<>NULL && Segment <>'N/A') // if segment is precised select all FDS related  to this agence
        {
            listFDS = [SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                       EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                       Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                       Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                       FROM Fiche_de_synthese__c 
                       WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                       AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                       AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                       AND Opportunit_commerciale__r.Libelle_Agence__r.name =:CurrentUser.Nom_agence__c
                       AND Opportunit_commerciale__r.Segment_client__c=:Segment];
        }
        else
        {
            listFDS = null;  
        }
        
        if (listFDS <> NULL && listFDS.size()>0)
        {
            Taux = CalcuTaux(listFDS);
        }
        return (100*Taux).setScale(2);
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description:  Calculate the Taux de renouvellement by User 
* @inputs: String
* @returns: Decimal
*/
    @AuraEnabled
    public static Decimal calculTauxdeRenouvellementUtilisateur(String Segment)
    {
        Decimal Taux = 0;
        Integer currentYear = System.Today().year(); // get current year
        String OwnrId = UserInfo.getUserId(); // get user id
        String year = String.valueOf(currentYear);
        List<Fiche_de_synthese__c> listFDS = new List<Fiche_de_synthese__c>();
        if(Segment=='N/A') // if no segment is precised select all FDS related  to this user
        {
            listFDS = [SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                       EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                       Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                       Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                       FROM Fiche_de_synthese__c 
                       WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                       AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                       AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                       AND Opportunit_commerciale__r.OwnerId =:OwnrId];
        }
        else // if segment is precised select all FDS related to this segment and this user
        {
            listFDS = [SELECT id , OffreA1P1VentesServices__c , OffreA1P2VentesServices__c , OffreA1P3VentesServices__c, OffreA1P4VentesServices__c,
                       EcartP1VentesServices__c , EcartP2VentesServices__c , EcartP3VentesServices__c , EcartP4VentesServices__c,
                       Opportunit_commerciale__r.Type_pers__c, Opportunit_commerciale__r.Statut__c , 
                       Opportunit_commerciale__r.Annee_de_signature__c, Opportunit_commerciale__r.StageName 
                       FROM Fiche_de_synthese__c 
                       WHERE Opportunit_commerciale__r.Type_pers__c =:Label.Renouvellement 
                       AND Opportunit_commerciale__r.Annee_de_signature__c =:year
                       AND Opportunit_commerciale__r.StageName =:Label.PV_Realisation
                       AND Opportunit_commerciale__r.OwnerId =:OwnrId
                       AND Opportunit_commerciale__r.Segment_client__c=:Segment]; 
        }
        
        
        if (listFDS <> NULL && listFDS.size()>0)
        {
            Taux = CalcuTaux(listFDS);
        }
        return (100*Taux).setScale(2);
    }
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 06/09/2019
* @description:  Make the arithmetic calculations for all the FDS given for the method
* @inputs: List<Fiche_de_Synthese__c>
* @returns: Decimal
*/
    public static Decimal CalcuTaux(List<Fiche_de_Synthese__c> listFDS)
    {
        Decimal Taux = 0;
        Decimal sumOffreG = 0;
        Decimal sumEcartG = 0;
        Decimal sumEcartP = 0;
        for (Fiche_de_synthese__c fds : listFDS)
        {
            if (fds.Opportunit_commerciale__r.Statut__c == Label.OppBeforeUp_gagne)
            {
                if(fds.OffreA1P1VentesServices__c <> null)
                {
                    sumOffreG = sumOffreG + fds.OffreA1P1VentesServices__c;
                }
                
                if(fds.OffreA1P2VentesServices__c <> null)
                {
                    sumOffreG = sumOffreG + fds.OffreA1P2VentesServices__c;
                }
                
                if(fds.OffreA1P3VentesServices__c <> null)
                {
                    sumOffreG = sumOffreG + fds.OffreA1P3VentesServices__c;
                }
                
                if(fds.OffreA1P4VentesServices__c <> null)
                {
                    sumOffreG = sumOffreG + fds.OffreA1P4VentesServices__c;
                }
                
                if(fds.EcartP1VentesServices__c <> null)
                {
                    sumEcartG = sumEcartG + fds.EcartP1VentesServices__c;
                }
                if(fds.EcartP2VentesServices__c <> null)
                {
                    sumEcartG = sumEcartG + fds.EcartP2VentesServices__c;
                }
                if(fds.EcartP3VentesServices__c <> null)
                {
                    sumEcartG = sumEcartG + fds.EcartP3VentesServices__c;
                }
                if(fds.EcartP4VentesServices__c <> null)
                {
                    sumEcartG = sumEcartG + fds.EcartP4VentesServices__c;
                }
            }
            if (fds.Opportunit_commerciale__r.Statut__c == Label.LC35_Statut)
            {
                if(fds.EcartP1VentesServices__c <> null)
                {
                    sumEcartP = sumEcartP + fds.EcartP1VentesServices__c;
                }
                if(fds.EcartP2VentesServices__c <> null)
                {
                    sumEcartP = sumEcartP + fds.EcartP2VentesServices__c;
                }
                if(fds.EcartP3VentesServices__c <> null)
                {
                    sumEcartP = sumEcartP + fds.EcartP3VentesServices__c;
                }
                if(fds.EcartP4VentesServices__c <> null)
                {
                    sumEcartP = sumEcartP + fds.EcartP4VentesServices__c;
                }
            }
        }
        if(sumOffreG-sumEcartG-sumEcartP <> 0)
        {
            Taux = sumOffreG / (sumOffreG-sumEcartG-sumEcartP) ;  
        }
        return Taux;
    }
}