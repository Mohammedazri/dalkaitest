/**
* @author: Alain Ghoussoub -EI Technologies
* @date: 25/03/2020
* @description: Classe qui interdit la suppression des contrats sauf pour les admin
*/
public class AP78_CannotDeleteContrat {
    /** 
* @author Alain Ghoussoub
* @date 25/03/2020 
* @description On selectionne le profile id de l'utilisateur et on compare a l'id du profile system admin. Si ils sont égaux, on permet la suppression des contrats, sinon on met un message d'erreur.
* @param List<Contrat__c>
* @return -
*/
    
    public static void noDeleteContrat (List<Contrat__c> contrats){
        system.debug('before delete trigger');
        String userId = UserInfo.getUserId();
        List<User> userList = [SELECT id,Profile.Name ,profileId
                               FROM user 
                               WHERE id=:userId];
        if(userList != null && userList.size()>0 && userList[0].profileId != Label.AdminProfileId){
            for (Contrat__c cont: contrats){
                cont.addError(Label.ErrorDeleteContrat);
            }
        }
    }
}