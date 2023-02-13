/**
* @author Jacques Akiki -EI Technologies
* @date 05/02/2019
* @description Batch that Creates Approbation__c records to map the old model 
* @Test Class: Batch45_ApprovalCustom_test
* @Coverage: 86%
*/
global class Batch45_ApprovalCustom implements Database.Batchable<SObject>,Database.stateful
{
    global string limt;
    global set<id> setTarget = new set<id>();

    global Batch45_ApprovalCustom(string lim) 
    {
        if(lim<>'' && lim<>null)
        {
            limt = lim;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id,ProcessInstance.TargetObjectId, StepStatus, OriginalActorId,' 
            +'ActorId, Comments, ElapsedTimeInHours,CreatedDate, CreatedById,ElapsedTimeInDays,ElapsedTimeInMinutes '
            +' FROM ProcessInstanceStep  WHERE ProcessInstance.TargetObjectId <> null AND StepStatus<>\'Reassigned\''; 
        if(limt<>'' && limt<>null)
        {
            query = query+ limt; 
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext bc , List<ProcessInstanceStep> listPIS)
    {
        List<Approbation__c> listApprb = new List<Approbation__c>(); // Approbation__c to be inserted
        Id recrdApres = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_ap).getRecordTypeId(); // recordType before response
        Id recrdAvnt = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_av).getRecordTypeId(); // recordType After response
        for(ProcessInstanceStep pis : listPIS)
        {
            if(pis.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName() =='Fiche_de_synthese__c' && pis.StepStatus<>'Reassigned')
            {
                setTarget.add(pis.ProcessInstance.TargetObjectId);
                Approbation__c app = new Approbation__c(); // new instance of Approbation__c object
                if (pis.StepStatus =='Started')
                {
                    app.CommentaireS__c = pis.Comments; // comments while submitting
                    app.Name=Label.LC48_Nom_Demande;
                    app.Statut__c= Label.LC48_Soumis;
                    app.OwnerId = pis.ActorId;
                    app.RecordTypeId = recrdApres;
               	    app.Date_de_soumission__c = pis.CreatedDate;
                }
                else
                {
                    app.CommentaireA__c = pis.Comments; // comments while approving
                    app.name= Label.LC48_Nom_Validation;
                    if(pis.StepStatus =='Approved')
                    {
                        app.Statut__c= Label.AP50_Approuvee;
                        app.RecordTypeId = recrdApres;
                        app.Date_d_approbation__c = pis.CreatedDate; // date when approved
                        app.Date_de_soumission__c = pis.CreatedDate.addMinutes(Integer.valueOf(-1*pis.ElapsedTimeInMinutes));
                    }
                    if(pis.StepStatus =='Rejected')
                    {
                        app.Statut__c= Label.Statut_refusee;
                        app.RecordTypeId = recrdApres;
                        app.Date_d_approbation__c = pis.CreatedDate; // date when approved 
                        app.Date_de_soumission__c = pis.CreatedDate.addMinutes(Integer.valueOf(-1*pis.ElapsedTimeInMinutes));
                    }
                    
                    if(pis.StepStatus =='NoResponse')
                    {
                        app.Statut__c= Label.LC48_SansReponse;
                        app.RecordTypeId = recrdAvnt;
                    }
                    
                    app.Approbateur_actuel__c = pis.ActorId;  
                    app.OwnerId = pis.CreatedById; 
                }
                
                app.tech_FicheDeSynthese__c =pis.ProcessInstance.TargetObjectId;
                app.tech_Attribue__c = pis.CreatedById;
                app.TechCreeBatch__c = true; // created from Batch
                listApprb.add(app); // add approbation to list
            }
        }
        List<ProcessInstanceWorkitem> listPIW = new List<ProcessInstanceWorkitem>();
       
        try{
            insert listApprb;  
        }
        catch (exception e)
        {
            System.debug('Error occured while trying to insert approbation ...........'+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext bc)
    {
          Id recrdAvnt = Schema.SObjectType.Approbation__c.getRecordTypeInfosByName().get(Label.LC48_RTName_av).getRecordTypeId(); // recordType After response
        List<Approbation__c> listApprb = new List<Approbation__c>(); 
         if(setTarget<>null && setTarget.size()>0)
        {
            List<ProcessInstanceWorkitem> listPIW = new List<ProcessInstanceWorkitem>(); 
            listPIW =[SELECT Id,ProcessInstance.TargetObjectId, OriginalActorId,ActorId, ElapsedTimeInHours,CreatedDate, CreatedById,ElapsedTimeInDays 
                      FROM ProcessInstanceWorkitem 
                      WHERE ProcessInstance.TargetObjectId in:setTarget];
            for(ProcessInstanceWorkitem piw :listPIW)
            {
                Approbation__c app = new Approbation__c(); // new instance of Approbation__c object
                app.name= Label.LC48_Nom_Validation;
                app.Statut__c= Label.LC48_SansReponse;
                app.RecordTypeId = recrdAvnt;
                app.Approbateur_actuel__c = piw.ActorId;  
                app.OwnerId = piw.CreatedById;
                app.Date_de_soumission__c = piw.CreatedDate;
                app.tech_FicheDeSynthese__c =piw.ProcessInstance.TargetObjectId;
                app.tech_Attribue__c = piw.CreatedById;
                app.TechCreeBatch__c = true; // created from Batch
                listApprb.add(app);
            }
        }
        insert listApprb;
    }
}