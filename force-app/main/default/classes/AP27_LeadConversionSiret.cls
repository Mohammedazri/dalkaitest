/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: Class responsible checking if the Siret is empty or not valid before converting the lead 
Test Class: AP27_LeadConversionSiret_Test
History
<Date>      <Authors Name>   <Brief Description of Change>
06-07-2018   Johny Kassis        Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP27_LeadConversionSiret 
{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this method check if the field siret__c is modified or if it's a new lead. and calls the function DoCallout
Inputs: list of leads and map of leads
Returns:-
----------------------------------------------------------------------------------------------------------------------------*/
    public static void updateOpportunityContact(list<lead> listLead, Map<Id, Lead> leadIdMap)
    {
        /*List <String> siretList = new List <String>();// list of string that will contains the SIRET of the leads 
        
        for(Lead ld:listLead) //loop over the leads 
        {
            if (leadIdMap==null || Ld.siret__c!=leadIdMap.get(ld.id).siret__c) // check if the field siret__c is modified or if we're creating a new lead
            {
                if(ld.siret__c!=null) //If the field siret__c is difrent than null we add the value to the list
                {
                    siretList.add(ld.siret__c);
                } 
                else //if not we set the field TechValidSiret__c to false 
                {
                    ld.TechValidSiret__c=false;// this field is used to check if the SIRET is valid
                }
            }         
        }
        if(siretList.size()>0)
        {
            DoCallout(siretList);// if the list of "Sirets" is not empty we call the function DoCallout and pass the list as a parameter 
        }*/
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description:  futur method used by the function above to check if the Siret is Valid  
Inputs: list of strings
Returns:-
----------------------------------------------------------------------------------------------------------------------------*/ 
    /*@ future(callout=true)
        public static Void DoCallout(List<string> siretList)
    {
        Map<string,Boolean> siretStat= new Map<string,Boolean>();// map of siret and boolean. the boolean indicates if the Siret is valid 
        
        for(string siret :siretList)// loop over the list of sirets
        {
            WS01_BaseSirene.Fields returnedFields=WS01_BaseSirene.DoCalloutAndRteurnInfos(siret);// call the webservice class and get the response 
            If(returnedFields== null)// if the response is null then the siret is not valid
            {
                siretStat.put(siret, false);// add the siret and the value false to the map to indicate that the siret is not valid
            }
            else 
            {
                siretStat.put(siret, true);// if the response is not null we add the siret and the boolean true to the map to indicate that the siret is valid
            }
        }
        
        // query the leads 
        List<Lead> leads=[SELECT id , TechValidSiret__c,Siret__c
                          FROM Lead
                          WHERE Siret__c In :siretStat.keySet() ];
        
        For( lead ld:leads )
        {
            ld.TechValidSiret__c=siretStat.get(ld.Siret__c);// update the leads based on the value of the boolean in the map 
        }
        
        Update leads;
    }*/
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: Add error to the lead if the Siret id not valid or if the Siret is empty and if the converted Account is a "Socété"
Inputs:  list of leads and map of leads
Returns:-
----------------------------------------------------------------------------------------------------------------------------*/
    public static void checkSIRETandAddError(list<lead> listLead)
    {
        system.debug('enter AP27');
        MAP<ID,Lead> accountIDLead = new MAP<ID,Lead>();// Map that contains the ID of the converted Account and the lead
        
        for(Lead lead1:listLead) // loop over the list of leads 
        {
            if (lead1.IsConverted)// if th lead is being converted 
            {
                system.debug(lead1.ConvertedAccountId + '' + lead1);
                accountIDLead.put(lead1.ConvertedAccountId , lead1);   // add the values to the map
            }
        }
        DateTime currentTime = System.now() - (0.3/1440);
        // query the converted Account
        List<Account> accounts= [SELECT id, ispersonaccount, recordType.DeveloperName, recordType.Name, CreatedDate
                                 FROM Account 
                                 WHERE ID in :accountIDLead.keySet() AND CreatedDate >=: currentTime];
        
        for(Account acc:accounts) // loop over the accounts
        {
            // if the recordtype of the converted Account is "Société" and the field TechValidSiret__c is false
            // (  the field TechValidSiret__c is true only if the Siret is valid   )
            if((acc.recordType.name=='Société'|| acc.recordType.DeveloperName==Label.RT_ACC_Partenaire) && !accountIDLead.get(acc.id).TechValidSiret__c )
            {
                system.debug('error');
                accountIDLead.get(acc.id).addError(Label.AP27_ErrorMsg);// if the conditions are met add the error to the lead to prevent the conversion 
            }
        }
    }
}