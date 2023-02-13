/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis 
Company: EI-Technologies
Description: this class transmits the value of the field "Pilote du contrat" to the field OwnerID
Test Class: AP28_SetContratOwner_test
History
<Date>      <Authors Name>      <Brief Description of Change>
31/07/2018   Johny Kassis        Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP28_SetContratOwner 
{
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this function modifies the value of the OwnerID  when the field "Pilote du contrat" is modified .
Inputs: list of contracts, MAP of Contracts
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void UpdateOwner(List<Contrat__c> contrats,map<ID, Contrat__c> oldContratMap)
    {
        for(Contrat__c cont: contrats)
        {
            
            // check if the field PiloteDuContrat__c  is modified
            If(cont.PiloteDuContrat__c!= oldContratMap.get(cont.Id).PiloteDuContrat__c && cont.OwnerId!= cont.PiloteDuContrat__c && cont.PiloteDuContrat__c!= null )
            {
                // modify the OwnerID
                cont.OwnerId=cont.PiloteDuContrat__c;
            }
            If(cont.OwnerId!= oldContratMap.get(cont.Id).OwnerId && cont.OwnerId!= cont.PiloteDuContrat__c)
            {
                // modify the OwnerID
                cont.PiloteDuContrat__c=cont.OwnerId;
            }
        }
        
    }
}