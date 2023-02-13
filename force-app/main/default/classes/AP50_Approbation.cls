/**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: This class is used to add the Approver of the FDS to the team of the Opportunity of the FDS 
* @Test Class: AP50_Approbation_test 
* @Coverage: 91% 
*/
public class AP50_Approbation {
    /**
* @author: Jacques Akiki -EI Technologies
* @date: 08/04/2019
* @description: add accordingly the approver to the Opportunity team.   
* @input: List<Approbation__c>
* @returns: - 
*/    
    
    public static void approveFDS(list<Approbation__c> listApp)
    {
        List<OpportunityTeamMember> listOppTeamMember = new List<OpportunityTeamMember>();
        set<Id> setOppId = new set<Id>();
        for(Approbation__c app: listApp){
            setOppId.add(app.tech_Opportunit__c);
        }
        /*Get Opportunity Team Member related to the opportunity of the FDS that is being submitted for approval*/
        List<OpportunityTeamMember> listOTM = [SELECT id,OpportunityId,UserId FROM OpportunityTeamMember WHERE OpportunityId in:setOppId];
        system.debug('--->'+listOTM);
        /*Map containing Opportunity Id with the related list of Users in the Opportunity Team Member*/
        Map<id,list<id>> mapOpportunityUsers = new Map<id,list<id>>();
        /*For loop to fill the map*/
        for (OpportunityTeamMember otm:listOTM){
            if(!mapOpportunityUsers.containskey(otm.OpportunityId)){
                mapOpportunityUsers.put(otm.OpportunityId, new list<id>());
            }
            mapOpportunityUsers.get(otm.OpportunityId).add(otm.UserId);
        }
        for(Approbation__c app: listApp)
        {
            if(mapOpportunityUsers.containskey(app.tech_Opportunit__c)
               && mapOpportunityUsers.get(app.tech_Opportunit__c).contains(app.tech_Attribue__c)){
                   system.debug('No need to add approver to Oppotunity Team since it\'s already in team' );
               }
            else{
                OpportunityTeamMember OppTeamMember =  new OpportunityTeamMember();
                OppTeamMember.OpportunityId = app.tech_Opportunit__c;
                OppTeamMember.UserId = app.tech_Attribue__c;
                OppTeamMember.OpportunityAccessLevel = 'Read';
                listOppTeamMember.add(OppTeamMember);
            }
        }
        if (listOppTeamMember.size()>0){
            try{
                insert listOppTeamMember;
            }
            catch (DmlException e)
            {
                System.debug('Exception ...'+e.getMessage());
            }
        }
    }         
}