trigger OpportunityAfterInsert on Opportunity (after insert) {
    PAD.PAD_BypassTrigger+=';AP45_Account;';
    system.debug('OpportunityAfterInsert');
    
    if(PAD.CanTrigger('AP08_Opportunity'))
        AP08_Opportunity.CreateProjetCOmmercial(trigger.new);
    
    if(PAD.canTrigger('AP14_OppRollUpSummaryUtility') ){
        
        list<opportunity> OpportunityList= new list<opportunity>();
        for(opportunity opp:trigger.new){
            if(opp.CAEcartPrincipal__c!=null){
                OpportunityList.add(opp);
            }
        }
        if(OpportunityList.size()>0){
            list<AP14_OppRollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<AP14_OppRollUpSummaryUtility.fieldDefinition>();
            fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'Tech_CalculCApondere__c', 'CA_en_cours_en_K__c'));
            fieldDefinitions.add(new AP14_OppRollUpSummaryUtility.fieldDefinition('SUM', 'Amount', 'CA_realis_en_K__c'));
            
            AP14_OppRollUpSummaryUtility.rollUpTrigger(fieldDefinitions, OpportunityList,'Opportunity', 'ProjetCommercial__c', 'ProjetCommercial__c', '');         
        }
        
    }
    
    //mettre à jour le champ Ventes_Additionnelles__c de l'objectif du propriértaire de l'opportunité 
    if(PAD.CanTrigger('AP87_Objectif'))
    {
       AP87_Objectif.OppsCreeOuDeleteAuCoursAnnee(trigger.new);
    }
    //mettre à jour le champ VentesAdditionnellesDeLAgence__c de l'objectif de l'agence de l'opportunité  
    if(PAD.CanTrigger('AP90_Objectif'))
    {
       AP90_Objectif.OppsCreeOuDeleteAuCoursAnnee(trigger.new);
    }
    
    // 28-01-2021 Added by Jimmy Khalil 
    // Anno C360-213: Deactivating the oppotunity split,Add the new Owner to the team members if he isn't already a member 
    if(PAD.CanTrigger('AP94_Opportunity'))
    {
        AP94_Opportunity.addOwnerToTeamsOnInsert(trigger.new);
    }
    
    // 08-07-2022 Added by Jimmy Khalil
    // US C360-717: automatiquement créer une Fiche de synthèse à la création d'une opportunité sauf pour les opportunités concurrentes
   if(PAD.CanTrigger('AP116_Opportunity'))
    {
        AP116_Opportunity.createFDS(trigger.new);
    }
    
}