/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: the Aim of this class is to add the Account Owner to the account team members when an account is created or when the owner is changed
Test Class: AP02_Account_TEST
--------------------------------------------------------------------------------------------------------------------------*/

public class AP02_Account {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function add the owner to the account team members 
Inputs: list of Accounts
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    
    public static void updateAccount(List<Account> listacc){
        wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete req = new wwwDalkiaFrReferentielPartenaire.creerPartenaireIdExterneRequete ();
        req = partenaire_mapper.fillCreerPartenaireIdExterneRequete(listacc[0]);
        dalkiaManager.doCallOutCreerPartenaireIdExterne(req);
    }
    public static void AjoutProprietaireEquipeCompte(list<Account> ListAccounts){
        map<string,string> MapAccountAuProprietaire = new map<string,string>();
        List<AccountTeamMember> ListATMToInsert = new List<AccountTeamMember>();
        
        for(Account acc: ListAccounts){
            if(Trigger.isInsert){
                //If account is create, add the owner to the account team
                accountTeamMember MembreEquipe = CreationATM(acc.id,acc.ownerid);
                ListATMToInsert.add(MembreEquipe);
            }else if(Trigger.isUpdate){
                //If account is updated and the owner is changed, add the new owner to the account team
                //and remove the old owner from the account team
                if(Trigger.OldMap.get(acc.id).get('OwnerId')!=acc.Ownerid){
                    MapAccountAuProprietaire.put(acc.id,String.valueOf(Trigger.OldMap.get(acc.id).get('OwnerId')));
                    accountTeamMember MembreEquipe = CreationATM(acc.id,acc.ownerid);
                    ListATMToInsert.add(MembreEquipe);
                }
            }
        }
        
        If(ListATMToInsert.size()>0){
            Insert ListATMToInsert;
        }
    }
    
    public static AccountTeamMember CreationATM(id accID, id userID){
         AccountTeamMember atm = new AccountTeamMember();
         atm.AccountId = accID;
         atm.TeamMemberRole= 'ROL01';
         atm.AccountAccessLevel = 'Edit';
         atm.UserId= UserID ;
         return atm;
    }
}