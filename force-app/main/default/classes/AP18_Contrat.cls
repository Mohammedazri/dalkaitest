/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this class creates and update events and tasks when a contract is updated 
Test Class: AP18_Contrat_test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP18_Contrat {
/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this function creates , updates or delete a task based on the "date d'échance" fields 
Inputs: list of contracts 
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/ 
    public static void TaskOnEcheanceChange(List<Contrat__c> contratList)
    {
        List<Task> tasksTo =[SELECT Id, WhatId,TechContratEcheance__c
                             FROM Task
                             WHERE TechContratEcheance__c in :contratList];
           Map<id,List<Task>> mapContratIDtoTask = new Map<id,List<Task>> ();
        if(tasksTo.size()>0)
        {
            for(Task tsk:tasksTo )
            {
                if(!mapContratIDtoTask.keyset().contains(tsk.TechContratEcheance__c))
                    mapContratIDtoTask.put(tsk.TechContratEcheance__c, new List<Task>());
                mapContratIDtoTask.get(tsk.TechContratEcheance__c).add(tsk);
            }
        }
        List<Task> tasksToCreate= new List<Task>();
        List<Task> tasksToUpdate= new List<Task>();
        List<Task> tasksToDelete= new List<Task>();
        
        for(Contrat__c cont:contratList)
        {
            if(mapContratIDtoTask.keyset().contains(cont.id))
            {
                if(cont.alert6mois__c == false 
                   || ((cont.AvenantDateProchaineEcheance__c !=null)&&(cont.AvenantDateProchaineEcheance__c <Date.today() ))
                   ||( (cont.DateProchaineEcheance__c !=null)&&cont.DateProchaineEcheance__c <Date.today()))
                {
                    for(Task tsk: mapContratIDtoTask.get(cont.id))
                    {
                        tasksToDelete.add(tsk);
                    }
                }
                else
                {
                    List<Task> tskList =mapContratIDtoTask.get(cont.id);
                    For(Task tsk:tskList)
                    {
                        IF((cont.AvenantDateProchaineEcheance__c !=null))
                        {
                            if(cont.AvenantDateProchaineEcheance__c -180<Date.today())
                            {
                                tsk.ActivityDate = date.today();
                            } 
                            else
                            {
                                tsk.ActivityDate=cont.AvenantDateProchaineEcheance__c -180;
                            }
                            
                        }
                        else 
                        {
                            if(cont.DateProchaineEcheance__c -180 < Date.today())
                            {
                                tsk.ActivityDate=date.today();
                            } 
                            else
                            {
                                tsk.ActivityDate=cont.DateProchaineEcheance__c - 180;
                            }
                        }
                        tsk.WhatId=cont.id; 
                        tsk.OwnerId=cont.OwnerID;                
                        tasksToUpdate.add(tsk); 
                    }
                }
                
            }
            else if(cont.alert6mois__c == true
                    && ((cont.AvenantDateProchaineEcheance__c !=null)&&(cont.AvenantDateProchaineEcheance__c >Date.today() )
                        || ((cont.DateProchaineEcheance__c !=null)&&cont.DateProchaineEcheance__c >Date.today())))
            {
                Task tsk= new Task ();
                tsk.Action_strategie_compte__c=true;
                
                IF((cont.AvenantDateProchaineEcheance__c !=null))
                {
                    if(cont.AvenantDateProchaineEcheance__c -180<Date.today())
                    {
                        tsk.ActivityDate = date.today();
                    } 
                    else
                    {
                        tsk.ActivityDate=cont.AvenantDateProchaineEcheance__c -180;
                    }
                    
                }
                else 
                {
                    if(cont.DateProchaineEcheance__c -180 < Date.today())
                    {
                        tsk.ActivityDate=date.today();
                    } 
                    else
                    {
                        tsk.ActivityDate=cont.DateProchaineEcheance__c - 180;
                    }
                }
                
                
                tsk.OwnerId=cont.OwnerID;
                tsk.Priority=Label.AP18_TaskMoyenne;
                tsk.Status=Label.AP18_TaskOuvert;
                tsk.Subject=Label.AP18_EventTaskSubj+' '+cont.Name +' '+ Label.AP18_TaskSubjEnd;
                tsk.TechContratEcheance__c=cont.id;
                tsk.WhatId=cont.id;
                tsk.genre_comite__c=Label.AP18_genereComite;
                tasksToCreate.add(tsk);
            }
        }
        if(tasksToCreate.size()>0)
        {
            insert tasksToCreate;
        }
        if(tasksToUpdate.size()>0)
        {
            update tasksToUpdate;
        }
        if(tasksToDelete.size()>0)
        {
            delete tasksToDelete;
        }
        
    }
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this function creates , updates or deletes an event based on the "date d'échance" fields 
Inputs: list of contracts 
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/ 

    public static void EventOnEcheanceChange(List<Contrat__c> contratList)
    {
        List<Event> eventsTo =[SELECT Id, WhatId,TechContratEcheance__c
                               FROM Event
                               WHERE TechContratEcheance__c in :contratList and isChild=false];
        Map<id,List<Event>> mapContratIDtoEvent = new Map<id,List<Event>> ();
        if(eventsTo.size()>0)
        {
            for(Event evt:eventsTo )
            {
                if(!mapContratIDtoEvent.keyset().contains(evt.TechContratEcheance__c))
                    mapContratIDtoEvent.put(evt.TechContratEcheance__c, new List<Event>());
                mapContratIDtoEvent.get(evt.TechContratEcheance__c).add(evt);
            }
        }
        List<Event> eventsToCreate= new List<Event>();
        List<Event> eventsToUpdate= new List<Event>();
        for(Contrat__c cont:contratList)
        {
            if(mapContratIDtoEvent.keyset().contains(cont.id))
            {   
                List<Event> evtList =mapContratIDtoEvent.get(cont.id);
                For(Event evt:evtList)
                {
                    IF (cont.AvenantDateProchaineEcheance__c != null)
                    {
                        Date dToday = cont.AvenantDateProchaineEcheance__c;
                        evt.StartDateTime=Datetime.newInstance(dToday.year(),dToday.month(), dToday.day(), 10,0,0);

                    }
                    
                    else 
                    {
                        Date dToday = cont.DateProchaineEcheance__c;
                        evt.StartDateTime=Datetime.newInstance(dToday.year(),dToday.month(), dToday.day(), 10,0,0);
                    }
                    evt.WhatId=cont.id;
                    eventsToUpdate.add(evt); 
                }
                
            }
            else 
            {
                Event evt= new Event ();
                evt.Action_strategie_compte__c=true;
                evt.DurationInMinutes=60;  
                evt.OwnerId=cont.OwnerID;
                
                IF (cont.AvenantDateProchaineEcheance__c != null)
                {
                    Date dToday = cont.AvenantDateProchaineEcheance__c;
                    evt.StartDateTime=Datetime.newInstance(dToday.year(),dToday.month(), dToday.day(), 10,0,0); 
                }
                
                else 
                {
                    Date dToday = cont.DateProchaineEcheance__c;
                    evt.StartDateTime=Datetime.newInstance(dToday.year(),dToday.month(), dToday.day(), 10,0,0); 
                }
                evt.Subject=Label.AP18_EventTaskSubj+' '+cont.Name ;
                evt.TechContratEcheance__c=cont.id;
                evt.WhatId=cont.id;
                evt.genre_comite__c=Label.AP18_genereComite;
                eventsToCreate.add(evt);
            }
        }
        
        if(eventsToCreate.size()>0)
        {
           insert eventsToCreate;
        }
        if(eventsToUpdate.size()>0)
        {
           update eventsToUpdate;
        }
    }
}