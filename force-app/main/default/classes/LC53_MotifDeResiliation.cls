/**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description: Apex controller for the lightning component LC53_MotifDeResiliation 
Used to Display a pop up when an Opportunity of type Renouvellement is closed (Lost or Won)
* @Test Class:LC53_MotifDeResiliation_test
* @Coverage: 86%
*/
public without sharing class LC53_MotifDeResiliation {
    
    public static Contrat__c mycontrat;// Declaration of the variable that will contain the contract
    
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description:  this method uses the Opportunity ID and returns the Contrat d'Origine of the Opportunity   
* @inputs: id 
* @returns: Contrat__c 
*/      
    
    @AuraEnabled
    public static Contrat__c getContratdOrigine(Id OppID)
    {
        //use the Opportunity ID to query the Opportunity and the lookup field ContratOrigine__c
        Opportunity opp= [SELECT id, ContratOrigine__c,ContratOrigine__r.Motif_fermeture_contrat__c,ContratOrigine__r.Condition_de_fermeture__c,
                                 ContratOrigine__r.DateFin__c , StageName, Type_pers__c, tech_realisation__c
                          FROM Opportunity 
                          WHERE id =: OppID];
        
        // if the conditions are met query and return  the contract 
        if(opp.StageName==Label.LC28_Realise && opp.Type_pers__c==Label.LC35_Renouv && opp.tech_realisation__c == false 
           &&(opp.ContratOrigine__r.Motif_fermeture_contrat__c==NULL 
              ||opp.ContratOrigine__r.Condition_de_fermeture__c==NULL 
              ||opp.ContratOrigine__r.DateFin__c==NULL))
        { 
            // use the lookup field of the Opportunity to query the related Contrat 
            mycontrat=[SELECT id, name, Condition_de_fermeture__c, Motif_fermeture_contrat__c,DateFin__c
                       FROM Contrat__c
                       WHERE id=:opp.ContratOrigine__c LIMIT 1];
            
            // return the related Contrat
            return mycontrat;  
        }
        else
        {
            // else return null
            return null;
        }
    }
    
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description:  this function gets the values of the picklist field Motif_fermeture_contrat__c
* @inputs: -
* @returns: WRP02_MenuPickList 
*/      
    
    @AuraEnabled
    public static list<WRP02_MenuPickList> GetMotifsDeFermeture(id oppId)
    {
        set<string> setMF = new set<string>();
        List<Opportunity> listOpp =[SELECT id,statut__c FROM Opportunity WHERE id=:oppId limit 1];
        if (listOpp!=NULL && listOpp.size()>0)
        {
            for(Statut_Motif__c sm:[SELECT MotifDeFermeture__c,APIMotif__c 
                                    FROM Statut_Motif__c 
                                    WHERE statut__c =:listOpp[0].statut__c])
            {
                setMF.add(sm.APIMotif__c);
            } 
        }
        // declare a list of wrappers that will be returned
        List<WRP02_MenuPickList> motifsList= new List<WRP02_MenuPickList>();
        // get the picklist values as PicklistEntry
        List<Schema.PicklistEntry> ple = Contrat__c.Motif_fermeture_contrat__c.getDescribe().getPicklistValues();
        motifsList.add(new WRP02_MenuPickList('',''));
        // loop on the List of PicklistEntry to fill the list of wrappers
        for( Schema.PicklistEntry f : ple)
        {
            if (setMF.contains(f.getValue()))
            {
                motifsList.add(new WRP02_MenuPickList(f.getLabel(), f.getValue()));
            }        
        }   
        // return the list of wrappers
        return motifsList;
    }
    
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description: this function takes the contrat as an argument , updates it and return OK (if the Update was successful) or the error message   
* @inputs: Contrat__c
* @returns: String 
*/       
    
    @AuraEnabled
    public static String updateContratdOrigine(Contrat__c contratorigine, ID OppID)
    {
        Opportunity opp= [SELECT id, StageName, TechPriorValueStageName__c,CloseDate,statut__c
                          FROM Opportunity 
                          WHERE id =: OppID];
        try
        {            
            // update the contract
            if(opp.Statut__c == 'Gagnée'){
                PAD.PAD_BypassTrigger += 'AP48_ContractCallouts';
                system.debug('PAS DAPPEL');
            }
            contratorigine.Statut__c=Label.LC35_StatutContrat;
            Schema.DescribeFieldResult fieldResult = Contrat__c.Condition_de_fermeture__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                if (pickListVal.getLabel() == contratorigine.Condition_de_fermeture__c)
                {
                    contratorigine.Condition_de_fermeture__c = pickListVal.getvalue();
                }
            }
            if (contratorigine.DateFin__c<contratorigine.DatePriseEffet__c)
            {
                return 'La date de fin doit être supérieure à la date d\'effet prévue sur l\'opportunité.';
            }
            update contratorigine;
            
            opp.TechPriorValueStageName__c = opp.StageName;
            opp.tech_realisation__c = true;
            update opp;
            return 'OK';
        }
        catch(Exception e)
        {
            // if an error occurred while updating the contract return the error message  
            return e.getMessage();
        }
    } 
    
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description: This method use the Class HelperManager to get the Value of the picklist Condition_de_fermeture__c when a Motif_fermeture_contrat__c is selected because 
the field Condition_de_fermeture__c is dependent of the field Condition_de_fermeture__c   
* @inputs: String
* @returns: list<string> 
*/           
    
    @AuraEnabled
    public static list<string> LoadDependantConditionValues(string MotifFermetureSelected)
    {
        //  Call the function HelperManager.GetDependentOptions and fill the mapresult:
        //  each key in this map is a value of the picklist Motif_fermeture_contrat__c and its corresponding list contains the values of the field Condition_de_fermeture__c
        Map<String,List<String>>  mapresult = HelperManager.GetDependentOptions('Contrat__c','Motif_fermeture_contrat__c','Condition_de_fermeture__c');
        system.debug('------------------------------------>'+mapresult);
        // Declare a list of strings that will contain the list of values to return  
        list<string> listOfConditionsToReturn = new list<string>() ;
        listOfConditionsToReturn.add('');
        // use the chosen Value of the field Motif_fermeture_contrat__c passed as argument to fill the list
        Schema.DescribeFieldResult fieldResult = Contrat__c.Motif_fermeture_contrat__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if (pickListVal.getvalue() == MotifFermetureSelected)
            {
                MotifFermetureSelected = pickListVal.getLabel();
            }
            
        }   
        listOfConditionsToReturn.addAll(mapresult.get(MotifFermetureSelected));
        system.debug('********************'+listOfConditionsToReturn);
        // retrun the list
        return listOfConditionsToReturn;
    }
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description: Inner class used as wrapper in this class to send the list of values for the picklist    
*/   
    public class WRP02_MenuPickList 
    {
        @AuraEnabled
        public String label;// Variable used to store the label of the picklist value 
        @AuraEnabled
        public String value;// Variable used to store the picklist value 
        
        // CONSTRUCTOR FUNCTION 
        public WRP02_MenuPickList(String label, String value)
        {
            this.label = label;
            this.value = value;
        }
    }
    
    
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 31/05/2019
* @description: this method uses the Opportunity ID and returns its fields 
* @inputs: ID
* @returns: Opportunity
*/     
    
    @AuraEnabled
    public static Opportunity QueryingOpportunityFields(Id OppID)
    {
        //use the Opportunity ID to query the Opportunity and the StageName
        Opportunity opp= [SELECT id, StageName, TechPriorValueStageName__c
                          FROM Opportunity 
                          WHERE id =: OppID];
        return opp;
    }
    
}