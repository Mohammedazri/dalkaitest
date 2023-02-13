/*--------------------------------------------------------------------------------------------------------------------------
Company: EI-Technologies
Description: trigger on Objectif Before insert
Test Class: AP36_UperCase_test
History
<Date>      <Authors Name>   <Brief Description of Change>
11/10/2018	Jacques Akiki	Creation
24/04/2018  Rita Bejjani    Add AP54_UpdateObjectif
--------------------------------------------------------------------------------------------------------------------------*/
trigger ObjectifBeforeInsert on Objectif__c (before insert) {
    
    /*if(PAD.CanTrigger('AP36_UperCase')) 
    {
        AP36_UperCase.ModifyToUpper('Objectif__c',trigger.new);
    }*/
    if(PAD.CanTrigger('AP54_UpdateObjectif')) 
    {
        List<Objectif__c> lstAP54 = new List<Objectif__c>();
        String objRegionalRTId = Schema.getGlobalDescribe().get('Objectif__c').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.Objectif_regional).getRecordTypeId();
        for(Objectif__c obj : trigger.new)
        {
            if(obj.RecordTypeId != objRegionalRTId)
            {
                lstAP54.add(obj);
            }
        }
		if(lstAP54.size() > 0)
        {
        	AP54_UpdateObjectif.AddObjAgcID(lstAP54,null);
        }
    }
    //initialiser le champ ContratsActifsDebutAnnee__c par le nombre de contrats actifs le 1 janvier pour le commercial
    //de l'objectif
    if(PAD.CanTrigger('AP85_Objectif')) 
    {
        AP85_Objectif.ContratsActifsDebutAnnee(trigger.new);
    }
    //initialiser le champ Ventes_Additionnelles__c par le nombre d'opportunités gangnés ayant action commerciale
    //de l'objectif
    if(PAD.CanTrigger('AP87_Objectif')) 
    {
        AP87_Objectif.OppGagneeDebutAnnee(trigger.new);
    }
     //initialiser le champ VentesAdditionnellesDeLAgence__c par le taux de vente additionnelle de l'agence
    //de l'objectif
    if(PAD.CanTrigger('AP90_Objectif')) 
    {
        AP90_Objectif.ObjectifCree(trigger.new);
    }
    //initialiser le champ ContratsActifsDebutAanneeDeLAgence__c par le taux de renouvellement de l'agence
    //de l'objectif
    if(PAD.CanTrigger('AP92_Objectif')) 
    {
        AP92_Objectif.ObjectifCree(trigger.new);
    }
     if(PAD.CanTrigger('AP96_Objectif')) 
    {
        AP96_Objectif.ObjectifCree(trigger.new);
    }
}