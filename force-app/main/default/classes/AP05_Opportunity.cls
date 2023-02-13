/*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: Class responsible of sending a chatter notification if the new owner of the opportunity is neither a member of the account team nor the owner of the account 
and it removes the old owner from the opportunity team
Test Class: AP05_Opportunity_Test 98%
History
<Date>      <Authors Name>   <Brief Description of Change>
10/04/2018   Johny Kassis     added the function RemoveFromOpportunityTeam
30/04/2018   Johny Kassis     modified the function RemoveFromOpportunityTeam to delete the Opportunity split of the old owner
--------------------------------------------------------------------------------------------------------------------------*/
public class AP05_Opportunity {
    /*--------------------------------------------------------------------------------------------------------------------------
Author: Dona Kfoury
Company: EI-Technologies
Description: this function sets the manager lookup fields(TECH_DAC__c,TECH_DC__c,TECH_DR__c,TECH_DG__c ) on the fiche de Synthèse in the before insert trigger
Inputs: list of Fiche_de_synthese__c
Returns: -
----------------------------------------------------------------------------------------------------------------------------*/
    public static void SendEmail(List<Opportunity> OpportunityList)
    {
        Set<Id> accountId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        Map<ID,List<AccountTeamMember>> MapaTeams = New Map<ID,List<AccountTeamMember>>();
        Map<ID,set<Id>> MapaTeamsId = New Map<ID,set<Id>>();
        for (Opportunity opp: OpportunityList)
        {
            accountId.add(opp.AccountId);
            OppId.add(opp.Id);
        }
        OpportunityList=[SELECT id,Name,Type_pers__c, Owner.FirstName,Owner.LastName,Owner.Name, AccountId, CreatedById 
                         FROM Opportunity 
                         WHERE id in:OppId];
        List<Account> AccountList = [SELECT Id, Name, OwnerId, (SELECT UserId, User.Name,User.Email 
                                                                FROM AccountTeamMembers) 
                                     FROM Account 
                                     WHERE id IN :accountId];
        for (Account acc :AccountList)
        {
            MapaTeams.put(acc.id,New List<AccountTeamMember>());
            MapaTeamsId.put(acc.id,New set<Id>());
            for(AccountTeamMember team : acc.AccountTeamMembers)
            {
                MapaTeams.get(acc.id).add(team);
                MapaTeamsId.get(acc.id).add(team.UserId);
            }
        }
        List<FeedItem> feedItemList = new List<FeedItem> ();
        string OppTemplateId=Label.EmailTemplate_ProprietaireOpportunteDifferentCompte; 
        EmailTemplate templateId = [Select Id, Subject, HtmlValue, Body from EmailTemplate where id=:OppTemplateId];
        for(Opportunity opp: OpportunityList)
        {
            for (Account acc : AccountList)
            {
                if(opp.AccountId==acc.Id && !MapaTeamsId.get(acc.id).contains(opp.OwnerId) && acc.OwnerId!=opp.OwnerId )
                {
                    for(AccountTeamMember myMember: MapaTeams.get(acc.id))
                    {
                        
                        
                        String subject = templateId.Subject;
                        subject = subject.replace('{!Opportunity.Type}', opp.Type_pers__c);
                        subject = subject.replace('{!Opportunity.Account}', acc.Name);
                        system.debug('subject  ' + subject);
                        
                        String plainBody = templateId.Body;
                        plainBody = plainBody.replace('{!Opportunity.OwnerFullName}',' '+  opp.Owner.Name);                       
                        plainBody = plainBody.replace('{!Opportunity.Account}', acc.Name);
                        plainBody = plainBody.replace('{!Opportunity.AccountId}', acc.id);
                        plainBody = plainBody.replace('{!Opportunity.Type}', opp.Type_pers__c);
                        plainBody = plainBody.replace('{!Opportunity.Id}', opp.id);
                        plainBody = plainBody.replace('{!Opportunity.Name}', opp.Name);
                        
                        FeedItem feedItemToInsert = new FeedItem();
                        feedItemToInsert.ParentId=myMember.UserId;
                        feedItemToInsert.Body=plainBody;
                        feedItemToInsert.Title=subject;
                        
                        feedItemList.add(feedItemToInsert);
                    }
                    if(!MapaTeamsId.get(acc.id).contains(acc.OwnerId))
                    {
                        String subject = templateId.Subject;
                        subject = subject.replace('{!Opportunity.Type}', opp.Type_pers__c);  
                        subject = subject.replace('{!Opportunity.Account}', acc.Name);
                        String plainBody = templateId.Body;
                        
                        plainBody = plainBody.replace('{!Opportunity.OwnerFullName}',' '+  opp.Owner.Name);  
                        plainBody = plainBody.replace('{!Opportunity.Account}', acc.Name);
                        plainBody = plainBody.replace('{!Opportunity.Type}', opp.Type_pers__c);
                        plainBody = plainBody.replace('{!Opportunity.Id}', opp.id);
                        plainBody = plainBody.replace('{!Opportunity.Name}', opp.Name); 
                        
                        FeedItem feedItemToInsert = new FeedItem();
                        feedItemToInsert.ParentId=acc.OwnerId;
                        feedItemToInsert.Body=plainBody;
                        feedItemToInsert.Title=subject;
                        
                        feedItemList.add(feedItemToInsert);
                    }
                }
            }
        }
        if(! Test.isRunningTest()){
            insert feedItemList;
        }
    }
    
}