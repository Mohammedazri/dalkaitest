/**
* @author: Jacques Akiki -EI Technologies
* @date: 13/08/2019
* @description: This class is used to add add the new owner of contrat to the OpportunityTeam of the Opportunite d'origine and the opportunites générées 
* @Test Class: AP67_OpportunityTeamMember_test 
* @Coverage: 92% 
*/
public class AP67_OpportunityTeamMember 
{
    public static void addOppTeamMember(List<Contrat__c> listCont)
    {
        set<OpportunityTeamMember> setOppTeamMember = new set<OpportunityTeamMember>();
        set<OpportunityTeamMember> setOppTeamMemberUpdate = new set<OpportunityTeamMember>();
        set<id> setContId = new set<id>();
        /*Pour donner Accès à l'opportunité d'origine du contrat*/
        for (Contrat__C cont : listCont) // list of contract that the owner changed
        {
            if (cont.OpportuniteCommerciale__c <> null && cont.ZZZtechActiveOwner__c)
            {
                OpportunityTeamMember otm = new OpportunityTeamMember(); // new Opportunity Team Member
                otm.OpportunityId = cont.OpportuniteCommerciale__c; // connevt the Opportunity that generated the contract
                otm.UserId = cont.OwnerId; // add the new owner to the opportunity Team
                otm.OpportunityAccessLevel = Label.Label_Edit; // Give read/Write access
                otm.TeamMemberRole = Label.PV_OTM_Comm; // role commercial
                setOppTeamMember.add(otm);
                setContId.add(cont.id);
            }
        }
        /*Pour donner ou modifier les accès des membres de l'equipe de l'opportunité*/
        if (setContId!=NULL && setContId.size()>0)
        {
            List<OpportunityTeamMember> listOTMGeneree = [SELECT id,OpportunityId,Opportunity.ContratOrigine__r.OwnerId , 
                                                          Opportunity.ownerId ,UserId,TeamMemberRole,OpportunityAccessLevel  
                                                          FROM OpportunityTeamMember 
                                                          WHERE Opportunity.ContratOrigine__c in:setContId];
            set<String> setOTMG = new set<String>();
            set<String> setOTMalreadyExists = new set<String>();
            for (OpportunityTeamMember otm:listOTMGeneree)
            {
                setOTMG.add(otm.OpportunityId+'-'+otm.UserId+'-'+otm.TeamMemberRole+'-'+otm.OpportunityAccessLevel);
                setOTMalreadyExists.add(otm.OpportunityId+'-'+otm.UserId);
            }
            for (OpportunityTeamMember otm:listOTMGeneree)
            {
                if(!setOTMG.contains(otm.OpportunityId+'-'+otm.Opportunity.ContratOrigine__r.OwnerId+'-'+Label.PV_OTM_Comm+'-'+Label.Label_Edit))
                {
                    if(setOTMalreadyExists.contains(otm.OpportunityId+'-'+otm.Opportunity.ContratOrigine__r.OwnerId))
                    {
                        if (otm.OpportunityAccessLevel!='All')
                        {
                            otm.OpportunityAccessLevel = Label.Label_Edit;
                            otm.TeamMemberRole = Label.PV_OTM_Comm;
                            setOppTeamMemberUpdate.add(otm);
                        }
                    }
                    else
                    {
                        OpportunityTeamMember otmNew = new OpportunityTeamMember(); // new Opportunity Team Member
                        otmNew.OpportunityId = otm.opportunityId; 
                        otmNew.UserId = otm.Opportunity.ContratOrigine__r.OwnerId; 
                        otmNew.OpportunityAccessLevel = Label.Label_Edit; // Give read/Write access
                        otmNew.TeamMemberRole = Label.PV_OTM_Comm; // role commercial
                        setOppTeamMember.add(otmNew);
                    }
                }
            }
        }
        list<OpportunityTeamMember> listOTM = new list<OpportunityTeamMember>(setOppTeamMember);
        list<OpportunityTeamMember> listotmUpdate = new list<OpportunityTeamMember>(setOppTeamMemberUpdate);
        /*Insert Opportunity Team Members*/
        if(listOTM!=NULL && listOTM.size()>0)
        {
            try
            {
                system.debug('List OTM to insert: ....'+listOTM);
                Database.insert (listOTM,false);
            }
            catch (DmlException e)
            {
                System.debug('Exception in insert OTM...'+e.getMessage());
            } 
        }
        /*update Opportunity Team Members */
        if(listotmUpdate!=NULL && listotmUpdate.size()>0)
        {
            try
            {
                 Database.update (listotmUpdate,false);
            }
            catch (DmlException e)
            {
                System.debug('Exception in update OTM...'+e.getMessage());
            } 
        }
        
    }
    
    /**
* @author: Alain Ghoussoub -EI Technologies
* @date: 28/04/2020
* @description: Checks if old owner of contrat in opportunity team, if yes check if he has access to contrat if no, create contrat__share record
*/
    public static void checkTeamMemberContratShare(List<Contrat__c> listCont, Set<Id> listOldOwner){
        //Opportunity of contrats ids
        Set<Id> oppIds = new Set<Id>();
        //contrat ids
        Set<Id> contIds = new Set<Id>();
        //Map of contrat and opportunity
        Map<Id,Id> mapContOpp = new Map<Id,Id>();
        for(Contrat__c cont : listCont){
            if(cont.OpportuniteCommerciale__c != null){
                oppIds.add(cont.OpportuniteCommerciale__c);
                mapContOpp.put(cont.id,cont.OpportuniteCommerciale__c);
            }
            contIds.add(cont.id);
        }
        
        //Opportunity team members of old owners and opportunities of contrats
        List<OpportunityTeamMember> oppTeamMembers = new List<OpportunityTeamMember>();
        if(oppIds != null && oppIds.size() >0){
            oppTeamMembers = [SELECT id,OpportunityId,UserId
                              FROM OpportunityTeamMember
                              WHERE OpportunityId IN: oppIds
                              AND UserId in: listOldOwner];
        }
        List<Contrat__share> contShare = new List<Contrat__share>();
        //contrat__share of contrats and old owner (if exists)
        contShare = [SELECT id,UserOrGroupId,ParentId
                     FROM Contrat__share
                     WHERE parentid IN: contIds
                     AND UserOrGroupId in: listOldOwner];
        Map<Id,Set<Id>> oppListMem = new Map<Id,Set<Id>>();
        
        //fill map of opportunity and opportunity team members
        for(OpportunityTeamMember oppMem : oppTeamMembers){
             if(!oppListMem.containsKey(oppMem.OpportunityId)){
                oppListMem.put(oppMem.OpportunityId, new Set<Id>());
            }
            oppListMem.get(oppMem.OpportunityId).add(oppMem.UserId);
        }
        Map<Id,Set<Id>> contContShare = new Map<Id,Set<Id>>();
        //Map of contrat and contrat share
        for(Contrat__share contShareLoop : contShare){
            if(!contContShare.containsKey(contShareLoop.parentid)){
                contContShare.put(contShareLoop.parentid, new Set<Id>());
            }
            contContShare.get(contShareLoop.parentid).add(contShareLoop.UserOrGroupId);
        }
        system.debug('contContShare ' + contContShare);
        List<Contrat__Share> listCS = new List<Contrat__Share>();
        Set<Id> ownerCSIDToInsert = new Set<Id>();
        //Loop that creates Contrat__Share records for old owner of contrat that is in opportunity team member but does not have access to contrat
        for(Id contId : mapContOpp.keySet()){
            Set<Id> ownerShare = new Set<Id>();
            if(contContShare.keyset().contains(contId) && contContShare.get(contId) != null){
                ownerShare = contContShare.get(contId);
            }
            Set<Id> oppMembers = new Set<Id>();
            if(mapContOpp.keyset().contains(contId) && mapContOpp.get(contId) != null 
               && oppListMem.keySet().contains(mapContOpp.get(contId)) && oppListMem.get(mapContOpp.get(contId)) != null){
                   oppMembers = oppListMem.get(mapContOpp.get(contId));
               }
            for(Id oppMemUserId : oppMembers){
                if(!ownerShare.contains(oppMemUserId)){
                    Contrat__share cs = new Contrat__share(); // new share
                    cs.UserOrGroupId = oppMemUserId;
                    cs.ParentId = contId;
                    cs.AccessLevel = Label.Label_Edit;
                    listCS.add(cs);
                }
            }
        }
        try
        {
            insert listCS;   // share the contrats with members
        }
        Catch (Exception exp)
        {
            System.debug('Error in sharing.........'+exp.getMessage());   
        }
        
    }
}