/*
 * AddAccountOwnerAsTeamMember_Batch
 * @author: Ahmad Koubeissy
 * @date: 6/10/2017
 Reprise de donnee
*/

global class AddAccountOwnerAsTeamMember_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, ownerid ,(SELECT Id,userid FROM AccountTeamMembers) FROM Account where owner.isActive=true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> Scope){
        List<AccountTeamMember> AccountTeamMembersInsert = new list<AccountTeamMember>();
        map<string,set<AccountTeamMember>> MapAccIdToTeamMembersSet = new map<string,set<AccountTeamMember>>();
        set<ID> ExistingAccountTeamMembersID = new set<ID>();
        
        for(Account acc : SCOPE){
            for(AccountTeamMember ATM:acc.AccountTeamMembers){
                ExistingAccountTeamMembersID.add(ATM.userid);
            }
            if(!ExistingAccountTeamMembersID.contains(Acc.ownerid)){
                 AccountTeamMember atm = new AccountTeamMember();
                 atm.AccountId = acc.ID;
                 atm.TeamMemberRole= 'ROL01';
                 atm.AccountAccessLevel = 'Edit';
                 atm.UserId= Acc.ownerid;
                 AccountTeamMembersInsert.add(atm);
            }
        }
        if(AccountTeamMembersInsert.size()>0){
            insert AccountTeamMembersInsert;
        }
        
    }
    
    global void finish(Database.BatchableContext bc) {
    
    }
    
}