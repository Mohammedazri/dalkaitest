/*--------------------------------------------------------------------------------------------------------------------------
Author: Ahmad Koubeissy
Company: EI-Technologies
Description: Reprise de donnee
Date: 6/10/2017
Test Class: UpdateContactUsersRelations_Batch_TEST
History
<Date>      <Authors Name>   <Brief Description of Change>
--------------------------------------------------------------------------------------------------------------------------*/
global class UpdateContactUsersRelations_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
        
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,'+
                       '(SELECT Id,userid FROM AccountTeamMembers),'+
                       '(SELECT Id FROM Contacts) '+
                       'FROM Account ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> Scope){
        system.debug('<<< Start Batch >>>');
        List<Contact_User__c> ListContactUsersInsert = new list<Contact_User__c>();
        List<Contact_User__c> ListContactUsersDelete = new list<Contact_User__c>();
        map<string,Contact_User__c> MapKeyToContactUser = new map<string,Contact_User__c>();
        set<ID> ExistingContactUsersID = new set<ID>();
        
        for(Contact_User__c ConUser: [SELECT Id, Contact_Interne__c , Contact_Client__c FROM Contact_User__c WHERE Contact_Client__r.AccountId IN :Scope]){
            string key = ConUser.Contact_Interne__c +'_'+ ConUser.Contact_Client__c ;
            MapKeyToContactUser.put(key,conUser);
        }
        
        for(Account acc : SCOPE){
            for(Contact con : acc.Contacts){
                for(AccountTeamMember ATM : acc.AccountTeamMembers){
                    string key = ATM.UserId + '_' + Con.Id;
                    if(!MapKeyToContactUser.containskey(key)){
                        Contact_User__c ContactUser = new Contact_User__c();
                        ContactUser.Contact_Interne__c = ATM.UserId;
                        ContactUser.Contact_Client__c = con.id ;
                        ListContactUsersInsert.add(ContactUser );
                    }else{
                        ExistingContactUsersID.add(MapKeyToContactUser.get(key).Id);
                    }
                }
            }
        }
        ListContactUsersDelete = [SELECT Id FROM Contact_User__c WHERE Contact_Client__r.AccountId IN :Scope AND Id NOT IN :ExistingContactUsersID ];
        If(ListContactUsersInsert.size()>0){
            insert ListContactUsersInsert;
        }
        If(ListContactUsersDelete.size()>0){
            //delete ListContactUsersDelete;
        }
        system.debug('<<< End Batch >>>');
    }
    
    global void finish(Database.BatchableContext bc) {
    
    }
    
}