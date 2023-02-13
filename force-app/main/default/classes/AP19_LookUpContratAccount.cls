/*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-Technologies
Description: After changing the relation between Contract and Account from master detail to lookup,
we used this class to maintain the functionality of the master detail relation 
Test Class: AP19_LookUpContratAccount_Test
--------------------------------------------------------------------------------------------------------------------------*/
public class AP19_LookUpContratAccount 
{
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this function is used to maintain the rollup summary fields on account 
Inputs: list of contracts and a boolean that indicates if the function is beeing used by the delete trigger 
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static void UpdateRollupFields(List<Contrat__c> ContratsList,boolean isDelete)
    {
        Set<ID> accountIDs= new Set<ID>();
        Set<ID> contratIDs= new Set<ID>();
        List<Account>ListAccountForUpdate=new List<Account>();
        
        For(Contrat__c cont:ContratsList)
        {
            accountIDs.add(cont.NomPartenaire__c);
            contratIDs.add(cont.id);
        }
        List<Account> listAccount= [SELECT id,TechRollupVolumedactCAOffres__c,TechRollupVolumedactEcartCA__c,TechRollupVolumeAnnuel__c,
                                    //(SELECT id,WFRelaiCAOffre__c,WFRelaiCAEcart__c,CA_EcartAnnuelContratsActifsRelai__c,NomPartenaire__c,Statut__c
                                    (SELECT id,CA_EcartAnnuelContratsActifsRelai__c,NomPartenaire__c,Statut__c
                                     FROM Contrats1__r)
                                    FROM Account
                                    WHERE id in :accountIDs];
        system.debug('listAccount...'+listAccount);
        for(Account theAccount:listAccount)
        {
            List<Contrat__c> listContrat=theAccount.Contrats1__r;
            if(listContrat.size()>0 && !listContrat.isEmpty())
            {
                Decimal activiteOffreCA=0;
                Decimal activiteEcartCA=0;
                Decimal annuel=0;
                Set<String> statutSet=new Set<String>{'ENOUV', 'OUV', 'PREP', 'ENFER'};
                    
                    for(Contrat__c cont:listContrat)
                {
                    
                    if(statutSet.contains(cont.Statut__c)
                       && !(isDelete && contratIDs.contains(cont.id)))
                    {
                        /* if(cont.WFRelaiCAOffre__c!=null)
							{
								activiteOffreCA=activiteOffreCA+cont.WFRelaiCAOffre__c;
							}*/
                        /*if(cont.WFRelaiCAEcart__c!=null)
							{ 
								activiteEcartCA=activiteEcartCA+cont.WFRelaiCAEcart__c;
							}	*/
                        if(cont.CA_EcartAnnuelContratsActifsRelai__c!=null)
                        {
                            annuel= annuel +cont.CA_EcartAnnuelContratsActifsRelai__c;
                        }
                    }
                    
                }
                theAccount.TechRollupVolumedactCAOffres__c=activiteOffreCA;
                theAccount.TechRollupVolumedactEcartCA__c=activiteEcartCA;
                theAccount.TechRollupVolumeAnnuel__c=annuel;
                
                ListAccountForUpdate.add(theAccount);
            }
            
        }
        
        if(ListAccountForUpdate!=null && ListAccountForUpdate.size()>0)
        {
            update ListAccountForUpdate;
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Johny Kassis
Company: EI-technologies
Description: this function delete the contracts of an account when the account is deleted like the standard functionality of a master detail relationship
Inputs: list of accounts
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void DeleteContrats(List<Account> accountsList)
    {
        Set<ID> accountIDs= new Set<ID>();
        For(Account acc:accountsList)
        {
            accountIDs.add(acc.id);
        }
        List<Contrat__c> listContrat= [SELECT id,CA_EcartAnnuelContratsActifsRelai__c,NomPartenaire__c,Statut__c
                                       FROM Contrat__c
                                       WHERE NomPartenaire__c in :accountIDs];
        //[SELECT id,WFRelaiCAOffre__c,WFRelaiCAEcart__c,CA_EcartAnnuelContratsActifsRelai__c,NomPartenaire__c,Statut__c
        Delete listContrat;
    }
}