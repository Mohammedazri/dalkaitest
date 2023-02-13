/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: this Class updates the field Satisfaction_client__c of the Accounts
Test Class: AP12_Contact_Test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP12_Contact {
/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury 
Company: EI-Technologies
Description: This function uses the value of the field Indicateur_satisfaction__c on contact to update the field Satisfaction_client__c on the account 
Inputs: List of contacts
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/     
    public static void UpdateSatisfactionDuClient(List<Contact> ContactsList)
    {
        /*Set<Id> SetAccountIds=New Set<Id>();
        for(Contact theContact: ContactsList)
        {
            SetAccountIds.add(theContact.AccountId);
        }
        
        List<Account> ListAccount=[SELECT id, Name, Satisfaction_client__c,
                                   (SELECT id,Indicateur_satisfaction__c from Contacts where Indicateur_satisfaction__c!= null)
                                   FROM Account
                                   WHERE id in:SetAccountIds];
        List<Account>ListAccountForUpdate=new List<Account>();
        For(account theAccount:ListAccount)
        {
            List<Contact> ListAccountContacts=theAccount.Contacts;
            if(ListAccountContacts!= null && ListAccountContacts.size()>0)
            {
                Integer LowestSatisfaction=Integer.valueOf((ListAccountContacts[0].Indicateur_satisfaction__c.split('/'))[0]);
                string LowestSatisfactionString=ListAccountContacts[0].Indicateur_satisfaction__c;
                system.debug('LowestSatisfaction '+LowestSatisfaction);
                for(contact theContact: ListAccountContacts)
                {
                    if(Integer.valueOf(theContact.Indicateur_satisfaction__c.split('/')[0])<LowestSatisfaction)
                    {
                        LowestSatisfaction=Integer.valueOf(theContact.Indicateur_satisfaction__c.split('/')[0]);
                        LowestSatisfactionString=theContact.Indicateur_satisfaction__c;
                    }
                }
                if(theAccount.Satisfaction_client__c!=LowestSatisfactionString)
                {
                    theAccount.Satisfaction_client__c=LowestSatisfactionString;
                    ListAccountForUpdate.add(theAccount);
                }
            }
            else if(theAccount.Satisfaction_client__c !=null)
            {
                theAccount.Satisfaction_client__c=null;
                ListAccountForUpdate.add(theAccount);
            }
        }
        if(ListAccountForUpdate!=null && ListAccountForUpdate.size()>0)
        {
            update ListAccountForUpdate;
        }*/
    }

}