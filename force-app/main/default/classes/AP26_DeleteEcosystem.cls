/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: This Class is used when an EcosystemePartenaire__c is deleted, it deletes the antagonist EcosystemePartenaire__c
Test Class: AP26_DeleteEcosystem_Test
History
<Date>       <Authors Name>   <Brief Description of Change>
21/06/2018    Johny Kassis     Created
--------------------------------------------------------------------------------------------------------------------------*/
public class AP26_DeleteEcosystem 
{
    public static boolean firstRun = true;
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: this function takes the list of the deleted EcosystemePartenaire__c and deletes the related antagonist EcosystemePartenaire__c
Inputs: List<EcosystemePartenaire__c>
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void DeleteRepresenteDe(List<EcosystemePartenaire__c> ecoSystemes)
    {
        //if( firstRun )
        //{
            List<String> ecosystemsPrinc = new List<String> ();//List of Strings that is used to store the antagonist EcosystemePartenaire__c ID's
            List<String> ecosystemIDs = new List<String> ();//List of Strings that is used to store the EcosystemePartenaire__c ID's
            
            /*For(EcosystemePartenaire__c eco :ecoSystemes)// loop on the deleted EcosystemePartenaire__c
            {
                if(eco.EcosystmePrincipal__c==null)
                {
                    ecosystemsPrinc.add(eco.ID);// if the main EcosystemePartenaire__c is being deleted we use it's ID to get the antagonist EcosystemePartenaire__c
                }
                else 
                {
                    ecosystemIDs.add(eco.EcosystmePrincipal__c);// if the antagonist EcosystemePartenaire__c is being deleted we use the field EcosystmePrincipal__c to get the main EcosystemePartenaire__c
                }
            }*/
            // query all the EcosystemePartenaire__c 
            List<EcosystemePartenaire__c> ecoSystemesToDelete =[SELECT id ,CreatedDate, TypeRelation__c , Name
                                                                FROM EcosystemePartenaire__c
                                                                WHERE id in :ecosystemIDs ]; // EcosystmePrincipal__c in :ecosystemsPrinc or
            
            firstRun = false;
            If(ecoSystemesToDelete.size()>0)
            {
                delete ecoSystemesToDelete;// delete the related EcosystemePartenaire__c
            }
       // }
    }
}