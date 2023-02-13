/** 
* @author Jacques Akiki
* @date 09/09/2022 
* @Controller of lwc08 
* @Test Class 
*/
public without sharing class lwc08AddNewContratMemberController {
    
    @AuraEnabled
    public static String createContratShare(String contratid, List<String> listUserId, List<String> listAccess) {
        list<OpportunityTeamMember> listOppTeam = [SELECT id,UserId,opportunityId FROM OpportunityTeamMember where (opportunity.Contrat_Genere_lookup__c=:contratid Or opportunity.ContratOrigine__c=:contratid)]; 
        set<String> setUserIdOppId = new set<String>();
        for(OpportunityTeamMember otm:listOppTeam){
            setUserIdOppId.add(otm.UserId+''+otm.OpportunityId);
        }
        list<Contrat__share> listCS = new list<Contrat__Share>();
        List<OpportunityTeamMember>listOTM = new List<OpportunityTeamMember>();
        for(integer i=0;i<listUserId.size();i++){
            /*Create a record of Contrat__Share to share contract with User */
            Contrat__Share cs = new Contrat__Share();
            cs.UserOrGroupId = listUserId[i];
            cs.AccessLevel = listAccess[i];
            cs.ParentId = contratid;
            listCS.add(cs);
            for(string concat:setUserIdOppId){
                OpportunityTeamMember otm = new OpportunityTeamMember();
                otm.OpportunityId = concat.substring(18,36);
                otm.OpportunityAccessLevel = listAccess[i];
                otm.UserId = listUserId[i];
                otm.TeamMemberRole = Label.PV_OTM_Comm;
                if(!setUserIdOppId.contains(otm.UserId+''+otm.OpportunityId)){
                    listOTM.add(otm);
                }
            }
        }
        try{
            if(listOTM.size()>0){
                insert listOTM;
            }
            insert listCS;
        }
        catch(Exception e){
            return e.getMessage();
        }
        return 'OK';
    }
}