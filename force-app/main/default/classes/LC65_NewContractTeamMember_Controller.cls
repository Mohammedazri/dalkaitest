/** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description controller of LC65_NewContractTeamMember
* @Test class: LC65_Controller_Test
*/
public without sharing class LC65_NewContractTeamMember_Controller {
    
    /** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description retourne les infos du membre de l'équipe contrat courant
* @param String contractMemberId id du contrab courant 
* @return IntervenantSurContrat__c instance courante du membre de l'équipe contrat
*/
    @AuraEnabled
    public static IntervenantSurContrat__c getContractMember(String contractMemberId){
        IntervenantSurContrat__c returnedMember = new IntervenantSurContrat__c();
        List<IntervenantSurContrat__c> ListMembers = [SELECT id, Role__c, Nom_de_utilisateur_std__c, Nom_de_utilisateur_std__r.Name,
                                                Contrat__c, Contrat__r.Name
                                                FROM IntervenantSurContrat__c
                                                WHERE id=:contractMemberId];
        if(ListMembers != null && ListMembers.size()>0){
            returnedMember = ListMembers[0];
        }
        return returnedMember;
    }
    
    /** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description modifie un membre de l'équipe du contrant
* @param String user id du user choisi 
* @param String contrat id du contrat choisi 
* @param String role role choisi 
* @param String memberId id du membre courant 
* @return String error msg if any
*/
    @AuraEnabled
    public static string editContractMember(String user,string contrat, string role, string memberId){
        List<IntervenantSurContrat__c> ListMembres = [SELECT id
                                                FROM IntervenantSurContrat__c
                                                WHERE Nom_de_utilisateur_std__c =:user
                                                AND role__c =:role
                                                AND Contrat__c =:contrat];
        if(ListMembres != null && ListMembres.size()>0){
            return 'errorDup';
        }
        else{
            IntervenantSurContrat__c myMembre = new IntervenantSurContrat__c(id = memberId, Role__c = role, Nom_de_utilisateur_std__c= user);
            try{
                update myMembre;
                return 'sucess';
            }catch(exception e){
                return e.getMessage();
            }
        }
    }
    /** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description retourne le nom du contrat courant
* @param String contractId id du contrab courant 
* @return String contractName nom du contrat courant
*/
    @AuraEnabled
    public static string getContractName(String contractId){
        string contractName = '';
        List<Contrat__c> Contracts = [SELECT id, Name
                                      FROM Contrat__c
                                      WHERE id=:contractId];
        if(Contracts != null && Contracts.size()>0){
            contractName = Contracts[0].Name;
        }
        return contractName;
        
    }
    
    /** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description cré un membre dans l'équipe du contrant
* @param String users id du user choisi 
* @param String contrat id du contrat choisi 
* @param String role role choisi 
* @return String myMembre id du membre créé
*/
    @AuraEnabled
    public static string createContractMember(String user,string contrat, string role){
        List<IntervenantSurContrat__c> ListMembres = [SELECT id
                                                FROM IntervenantSurContrat__c
                                                WHERE Nom_de_utilisateur_std__c =:user
                                                AND role__c =:role
                                                AND Contrat__c =:contrat];
        if(ListMembres != null && ListMembres.size()>0){
            return 'errorDup';
        }
        else{
            IntervenantSurContrat__c myMembre = new IntervenantSurContrat__c();
            myMembre.Nom_de_utilisateur_std__c = user;
            myMembre.Contrat__c = contrat ;
            myMembre.role__c = role;
            insert myMembre;
            return myMembre.Id;
        }
    }
    /** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description retoune la liste des utilisateurs vérifiant le filtre
* @param String searchKey les lettres de recherch saisies par l'utilisateur
* @return List<userWrapper> myUserswrp liste des utilisateurs vérifinats le filtre
*/
    @AuraEnabled
    public static List<userWrapper> getUsersWrp(String searchKey){
        
        String keyword = '%'+searchKey+'%' ;
        string staturOuv = Label.LC66_StatutOuv;
        String myAPACondition = 'where DkCode__c!=null and Statut__c =:staturOuv ';
        if(searchKey != null && searchKey != ''){
            myAPACondition = myAPACondition + 'And Name LIKE \''+keyword+'\'';
        }
        List<User> myUsers = Database.query('SELECT id,Name,DkCode__c from user '+ myAPACondition + ' LIMIT 5');
        List<userWrapper> myUserswrp = new List<userWrapper>();
        if(myUsers != null && myUsers.size()>0){
            for(User apa : myUsers){
                userWrapper myuser = new userWrapper();
                myuser.Name = apa.Name;
                myuser.Id = apa.id;
                myuser.DKCode= apa.DkCode__c;
                myUserswrp.add(myuser);
                
            }       
            
        }
        return myUserswrp ;
    }
    
    /** 
* @author Dona Kfoury
* @date 21/1/2020 
* @description wrapper représentant les infos de chaque utilisateurs affiché dans le custom loockup
*/
    public class userWrapper{
        @AuraEnabled
        public string Name{get;set;}
        @AuraEnabled
        public string Id{get;set;}
        @AuraEnabled
        public string DKCode{get;set;}
    }
}