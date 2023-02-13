/**
* @author: Jimmy Khalil
* @date: 08/04/2021
* @description: Controller of LC83_FDSAttenteApprobation.cmp that displays pending approvals for FDS depending on conditions 
* @Test Class:LC83_FDSAttenteApprobation_Test  
* @Coverage: 100% 
*/
public without sharing class LC83_FDSAttenteApprobationController {
    @AuraEnabled
    /**
* @author: Jimmy Khalil
* @date: 08/04/2021
* @description:  The method returns pending approvals for FDS depending on conditions 
* @inputs: -
* @returns: List<Approbation__c>
*/  
    public static List <Approbation__c> getApprobation() {
        String userProfileID = UserInfo.getProfileId();
        String approbStatus = Label.LC54_sansRep;
        Boolean getQuery = False;
        List<Approbation__c> listApp = new List<Approbation__c>();
        
        String listAppQuery = 'SELECT Id, tech_FicheDeSynthese__c, tech_FicheDeSynthese__r.name , '+
            'Date_de_soumission__c,tech_FicheDeSynthese__r.Opportunit_commerciale__r.Owner.Name,'+
            'tech_FicheDeSynthese__r.Id '+
            'FROM Approbation__c Where statut__c =:approbStatus';
        
        if(Label.LC83_profilePiloteOpp.contains(userProfileID)){
            //Les FdS où il est pilote de l'opportunité -> Profil Commercial,Commercial multi-agence,DAC/RAC, DAC/RAC One, DCR
            String currUserID = UserInfo.getUserId();
            listAppQuery = listAppQuery +
                ' And tech_FicheDeSynthese__r.Opportunit_commerciale__r.OwnerId = :currUserID ' ;
            getQuery = True;
            
        }else if(Label.LC83_profileAgencePiloteOpp.contains(userProfileID)){
            //Les FdS où le pilote de l'opportunité est dans l'agence -> Profil Commercial One
            listAppQuery = listAppQuery +
                ' And tech_FicheDeSynthese__r.Opportunit_commerciale__r.ZZZ_IfOwnerSameAgenceAsCurrentUser__c = True ';
            getQuery = True;
            
        }else if(Label.LC83_profileAgenceSoumis.contains(userProfileID)){
            //Les FdS que les utilisateurs de l'agence ont soumis -> Profil AC,AC multi Agence
            
            //Get Agence of current User
            User currUser = [SELECT Id,Nom_agence__c
                             FROM User
                             WHERE Id = :UserInfo.getUserId()];
            if(currUser.Nom_agence__c != null && currUser.Nom_agence__c != ''){
                List<User> listAgenceUser = [SELECT Id,Nom_agence__c
                                             FROM User
                                             WHERE Nom_agence__c = :currUser.Nom_agence__c];
                
                if(listAgenceUser != null && listAgenceUser.size()>0){
                    Set<String> userAgenceID = new Set<String>();
                    for(User usr:listAgenceUser){
                        userAgenceID.add(usr.Id);
                    }
                    
                    listAppQuery = listAppQuery + ' And Approbateur_actuel__c in :userAgenceID ' ;
                    getQuery = True;
                }
            }
            
        }
        if(getQuery){
            listAppQuery = listAppQuery + ' order by Date_de_soumission__c desc';
            
            System.debug('@@@ JK listAppQuery ' + String.escapeSingleQuotes(listAppQuery));
            listApp = DataBase.query(String.escapeSingleQuotes(listAppQuery));
        }
        
        return listApp;
    }
}