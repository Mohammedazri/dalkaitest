/*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran 
Company: EI-Technologies
Description: Apex controller for the lightning component LC38_OpportuniteFille
responsible of showing a list of the opportunités filles and the possibility to edit their stage.
Test Class: LC38_OpportuniteFille_Controller_Test
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC38_OpportuniteFille_Controller {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran
Company: EI-Technologies
Description: This function is responsible of retrieving the opportunitties fille related to the OpportuniteCommerciale__c of this contract
Inputs: contract ID
Returns: List<WrapperClass> which contains the opp + select + errorMsg(empty by default) 
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<WrapperClass> getOpportunitiesFilles(Id contractId){
        System.debug('contractId ' + contractId);
        List<Opportunity> oppFilles = null;
        
        
        List<WrapperClass> lstWrap = new List<WrapperClass>();
        Contrat__c contrat = [Select id,name,OpportuniteCommerciale__c,NumeroContratC360__c  
                              From Contrat__c 
                              Where id =:contractId];
        if(contrat!=null && String.isNotBlank(contrat.OpportuniteCommerciale__c)){
            oppFilles = [select id,name,StageName,NumeroOpportunite__c   from Opportunity where OpportuniteMere__c =:contrat.OpportuniteCommerciale__c];
        }
        for(Opportunity opp : oppFilles){
            WrapperClass wrapper = new WrapperClass(opp);
            wrapper.numeroContrat = opp.NumeroOpportunite__c;
            lstWrap.add(wrapper);
        }
        
        return lstWrap;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran
Company: EI-Technologies
Description: This function is responsible of retrieving the different stages of the opportunity object
Inputs: 
Returns: List<String> which contains the stages
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<WrapperPickList> getStages(){
       // List<String> lstStages = new List<String>();
        /*List<AggregateResult> lstResult = [SELECT toLabel(StageName) FROM Opportunity group by StageName];
        for(AggregateResult result : lstResult){
            lstStages.add(result.get('StageName')+'');
        }*/
        List<WrapperPickList> lstStages = new List<WrapperPickList>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple)
        {
			lstStages.add(new WrapperPickList(pickListVal.getLabel(),pickListVal.getValue()));
		} 
        system.debug('list--->'+lstStages);
        return lstStages;
        
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran
Company: EI-Technologies
Description: This function is responsible of saving the modified stage of the opportunity
Inputs: Json object as String (Containing the List<Wrapper> object with the selected opp with their new stage)
Returns: List<WrapperClass> which contains the opp + select + errorMsg(success/failure) 
----------------------------------------------------------------------------------------------------------------------------*/
    @AuraEnabled
    public static List<WrapperClass> saveOppFille(String jsonParams){
        List<Opportunity> lstOpp = new List<Opportunity>();
        Map<Id,String> mapOpp = new Map<Id,String>();
        List<WrapperClass> lstWrap = (List<WrapperClass>)JSON.deserialize(jsonParams, List<WrapperClass>.class);
        for(WrapperClass wrapper : lstWrap){
            if(wrapper.isSelected){
                mapOpp.put(wrapper.opp.Id,wrapper.opp.StageName);
            }
        }
        lstOpp = [Select id,name,StageName from Opportunity where id in:mapOpp.keySet()];
        for(Opportunity opp : lstOpp){
            opp.StageName = mapOpp.get(opp.Id);
            if(mapOpp.get(opp.Id).equals('Réalisation')){
                opp.Statut__c = 'Gagnée';
            }
        }
        System.debug('test lstOpp ' + lstOpp);
        Map<Id,String> mapError = new Map<Id,String>();
        List <Database.SaveResult> saveResults = Database.update(lstOpp, false);
        // Go through each result
        for (Integer i = 0; i < lstOpp.size(); i++) {
            Database.SaveResult s = saveResults[i];
            Opportunity opp = lstOpp[i];
            if (!s.isSuccess()) {
                String errorMsg = 'Erreur';
                if(s.getErrors()!=null && s.getErrors().size()>0 && s.getErrors().get(0).getMessage()!=null){
                    errorMsg = s.getErrors().get(0).getMessage();
                }
                mapError.put(opp.Id, errorMsg);
            }
            else{
                mapError.put(opp.Id, 'Success');
            }
        }
        for(WrapperClass wrapper : lstWrap){
            if(wrapper.isSelected){
                wrapper.errorMsg = mapError.get(wrapper.opp.Id);
            }
        }
        return lstWrap;
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Hussein Farran
Company: EI-Technologies
Description: This class is responsible of wrapping the opportunity object with a isSelected boolean (Select checkbox) with the errorMsg
----------------------------------------------------------------------------------------------------------------------------*/
    public class WrapperClass{
        @AuraEnabled public Opportunity opp{get;set;}
        @AuraEnabled public Boolean isSelected{get;set;}
        @AuraEnabled public String errorMsg{get;set;}
        @AuraEnabled public String numeroContrat{get;set;}
        public WrapperClass(Opportunity fille){
            isSelected = false;
            opp = fille;
        }
    }
    
     /*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki
Company: EI-Technologies
Description: To return picklist values and label to to componenent
----------------------------------------------------------------------------------------------------------------------------*/
    public class WrapperPickList{
        @AuraEnabled public String PLValue{get;set;}
        @AuraEnabled public String PLLabel{get;set;}
        public WrapperPickList(String PL_Label ,String PL_Value)
        {
            PLValue = PL_Value;
            PLLabel = PL_Label;
        }
    }
}