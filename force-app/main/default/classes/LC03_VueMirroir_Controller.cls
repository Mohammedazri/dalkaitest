/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: Apex controller for the lightning component LC03_VueMirroir used on the account layout
which is responsible of the section => Relation Client >> Vue Mirroir
Test Class: 
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
public without sharing class LC03_VueMirroir_Controller {
    public static map<Id, list<Contact>> mapContactId_Children;
    public static map<Id, list<ContentDocumentLink >> mapEventId_AttachedFiles;
    public static set<Id> SetContactId;
    public static List<document> Satisfactiondocuments;
    public static string unUrl;
    public static string deuxUrl;
    public static string troisUrl;
    public static string quatreUrl;
    public static string cinqUrl;
    public static string sixUrl;
    public static string septUrl;
    public static string huitUrl;
    public static string neufUrl;
    public static string dixUrl;
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this function returns a list of contacts and their information using the wrapper class wrapperVueMirroirRow.
these contacts are related to the accountID and are filterd using the string searchItem
Inputs: string AccountId, string searchItem
Returns:list of wrapperVueMirroirRow
----------------------------------------------------------------------------------------------------------------------------*/   
    @AuraEnabled
    public static list<wrapperVueMirroirRow> getAccountContacts(string AccountId, string searchItem){
       
        list<Contact> listContacts = [SELECT Id, Name, ReportsToId,Influence__c,Supporteur__c,Type_de_fonction__c,Indicateur_de_satisfaction__c,
                                      (
                                          SELECT Id, Contact_Client__c, Contact_Client__r.Name, Contact_Interne__c, Contact_Interne__r.Name,Contact_Interne__r.CodeValeurFiliere__c, 
                                          Contact_Interne__r.TypeInterlocuteurDALKIA__c,Contact_Interne__r.Title 
                                          FROM Relation_Clients_et_Internes__r
                                      ),
                                      (
                                          SELECT Id, WhoId, EndDateTime, Subject, DurationInMinutes, Description, Statut_Evenement__c, ActivityDate ,Rdvralise__c
                                          FROM Events
                                      )
                                      FROM Contact 
                                      WHERE AccountId =:AccountId
                                      and statut__c !=:Label.PV_Contact_Inactif];
        system.debug('listContacts ' + listContacts);
        
        Satisfactiondocuments=[SELECT Name
                               FROM document
                               WHERE Name='Un sur dix' or Name='Trois sur dix' or Name='Six sur dix' or Name='Sept sur dix' or Name='Quatre sur dix' or Name='Neuf sur dix' or Name='Huit sur dix' or Name='Dix sur dix'or Name='Deux sur dix' or Name='Cinq sur dix'];
        
        
        for (document thisDocument:Satisfactiondocuments)
        {
            if(thisDocument.Name=='Un sur dix')
            {
                unUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Deux sur dix')
            {
                deuxUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Trois sur dix')
            {
                troisUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Quatre sur dix')
            {
                quatreUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Cinq sur dix')
            {
                cinqUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Six sur dix')
            {
                sixUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Sept sur dix')
            {
                septUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Huit sur dix')
            {
                huitUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Neuf sur dix')
            {
                neufUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            else if(thisDocument.Name=='Dix sur dix')
            {
                dixUrl='/servlet/servlet.FileDownload?file=' + thisDocument.Id;
            }
            
        }
        
        SetContactId= new set<Id>();
        mapContactId_Children = new map<Id, list<Contact>>();
        Set<Id> SetofEventsId= new Set<Id>();
        for(Contact theContact : listContacts){
            for(Event theEvent : theContact.Events)
            {
                SetofEventsId.add(theEvent.Id);
            }
            
            if(!mapContactId_Children.containsKey(theContact.ReportsToId)){
                mapContactId_Children.put(theContact.ReportsToId, new list<Contact>());
            }
            mapContactId_Children.get(theContact.ReportsToId).add(theContact);
            if(theContact.Name.containsIgnoreCase(searchItem))
            {
                SetContactId.add(theContact.Id);
            }
        }
        
        List<ContentDocumentLink > ListAttachedFiles= new List<ContentDocumentLink >();
        if(SetofEventsId!= null && SetofEventsId.size()>0)
            ListAttachedFiles=[SELECT ContentDocumentId,ContentDocument.Title, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN:SetofEventsId];
        mapEventId_AttachedFiles= new map<Id, list<ContentDocumentLink >>();
        for(ContentDocumentLink  theContent:ListAttachedFiles)
        {
            if(!mapEventId_AttachedFiles.containsKey(theContent.LinkedEntityId)){
                mapEventId_AttachedFiles.put(theContent.LinkedEntityId, new list<ContentDocumentLink>());
            }
            mapEventId_AttachedFiles.get(theContent.LinkedEntityId).add(theContent);
        }
        list<wrapperVueMirroirRow> returnValue = getCreateWrapperVueMirror(null, searchItem);
        
        return returnValue;
    }   
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this function  is used in the function above and is a recursive function that gets all the information of the children 
contacts and their information using the wrapper class wrapperVueMirroirRow
Inputs:Id ContactId, string searchItem
Returns:list of wrapperVueMirroirRow
----------------------------------------------------------------------------------------------------------------------------*/ 
    @AuraEnabled
    public static list<wrapperVueMirroirRow> getCreateWrapperVueMirror(Id ContactId, string searchItem){
        
        list<wrapperVueMirroirRow> returnValue = new list<wrapperVueMirroirRow>();
        if(mapContactId_Children.containsKey(ContactId)){
            for(Contact theContact : mapContactId_Children.get(ContactId)){
                integer NombreEventsRealise=0;
                wrapperVueMirroirRow newwrapperVueMirroirRow = new wrapperVueMirroirRow();
                newwrapperVueMirroirRow.theContact = theContact;
                if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('1/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=unUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('2/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=deuxUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('3/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=troisUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('4/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=quatreUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('5/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=cinqUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('6/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=sixUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('7/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=septUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('8/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=huitUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('9/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=neufUrl;
                }
                else if(theContact.Indicateur_de_satisfaction__c!=NULL && theContact.Indicateur_de_satisfaction__c.contains('10/'))
                {
                    newwrapperVueMirroirRow.SatisfactionyUrl=dixUrl;
                }
                system.debug('newwrapperVueMirroirRow.SatisfactionyUrl ' + newwrapperVueMirroirRow.SatisfactionyUrl);
                newwrapperVueMirroirRow.listInternes = theContact.Relation_Clients_et_Internes__r;
                List<wrapperVueMirroirRow.wrapperEvent> thisContactEvents=new List<wrapperVueMirroirRow.wrapperEvent>();
                for(Event theEvent:theContact.Events)
                {
                    wrapperVueMirroirRow.wrapperEvent theWrapperEvent = new wrapperVueMirroirRow.wrapperEvent();
                    theWrapperEvent.theEventObj=theEvent;
                    theWrapperEvent.theEventID=theEvent.Id;
                    if(mapEventId_AttachedFiles != null && mapEventId_AttachedFiles.containsKey(theEvent.Id))
                        theWrapperEvent.AttachedFiles=mapEventId_AttachedFiles.get(theEvent.Id);
                    thisContactEvents.add(theWrapperEvent);
                }
                newwrapperVueMirroirRow.listEvents=thisContactEvents;
                newwrapperVueMirroirRow.isParentOfSearched=false;
                newwrapperVueMirroirRow.isRoot=false;
                if(theContact.ReportsToId == null)
                {
                    newwrapperVueMirroirRow.isRoot=true;
                }
                newwrapperVueMirroirRow.isSearched=false;
                if(SetContactId.contains(theContact.Id) && searchItem!='')
                {
                    newwrapperVueMirroirRow.isSearched=true;
                } 
                newwrapperVueMirroirRow.listChildren = new list<wrapperVueMirroirRow>();
                newwrapperVueMirroirRow.listChildren.addAll(getCreateWrapperVueMirror(theContact.Id, searchItem));
                for(wrapperVueMirroirRow thisChildRow:newwrapperVueMirroirRow.listChildren)
                {
                    if((thisChildRow.isParentOfSearched==true || thisChildRow.isSearched==true)&& searchItem!='')
                        newwrapperVueMirroirRow.isParentOfSearched=true;
                }
                for(Event thisEvent: theContact.Events)
                {
                    if(thisEvent.Rdvralise__c){
                        NombreEventsRealise++;  
                    }
                }
                dateTime myDerniereRencontre=DateTime.newInstance(2000, 7, 09, 3, 3, 3);
                for (event thisEvent: theContact.Events)
                {
                    if(thisEvent.EndDateTime> myDerniereRencontre && thisEvent.EndDateTime<date.today())
                    {
                        myDerniereRencontre=thisEvent.EndDateTime;
                    }
                }
                
                if(myDerniereRencontre==DateTime.newInstance(2000, 7, 09, 3, 3, 3))
                {
                    newwrapperVueMirroirRow.DerniereRencontre='';
                }
                else
                {
                    newwrapperVueMirroirRow.DerniereRencontre=myDerniereRencontre.format();
                }
                newwrapperVueMirroirRow.NbreEventRealise=NombreEventsRealise;
                returnValue.add(newwrapperVueMirroirRow);
            }
        }
        return returnValue;
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this function updates the field Rdvralise__c of the events from the Vue Miroire on the account  
Inputs:Map<String, Boolean>
Returns:-
----------------------------------------------------------------------------------------------------------------------------*/     
    @AuraEnabled
    public static void setEvent(Map<String, Boolean> mapEventIDRvt)
    {
        List<Event> eventListToUpdate= new List<Event> () ;
        for(Event evt:[SELECT Id,Rdvralise__c  FROM Event WHERE id IN :mapEventIDRvt.keySet()])
        {
            evt.Rdvralise__c=mapEventIDRvt.get(evt.id);
            eventListToUpdate.add(evt);
        }
        update eventListToUpdate;
    }
    
}