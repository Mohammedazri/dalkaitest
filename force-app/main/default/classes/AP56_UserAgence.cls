/**
* @author: Rita Bejjani -EI Technologies
* @date: 25/04/2019
* @description: Update Objectif when the 'agence' of 'commercial' change 
* @Test Class: AP56_UserAgence_Test
* @Coverage: 95%
*/
public class AP56_UserAgence {
    
    /**
    * @author: Rita Bejjani -EI Technologies
    * @date: 25/04/2019
    * @description:  The method updates a list of objectifs when the agence dkcode change for a user that is a 'commercial'
    * @inputs: List<User> - map<id,User>
    * @returns: - 
    */  
    public static void CheckUserAgence(List<User> listNewUsers, map<id,User> mapOldUsers)
    {
        system.debug('AP56_UserAgence: CheckUserAgence');
        set<ID> setUsersID = new set<ID>();
        set<String> setAgenceDkCode = new set<String>();  
        List<Objectif__c> listObj = [SELECT id 
                                     FROM objectif__c 
                                     WHERE Commercial__r.id in :mapOldUsers.keyset()];//les objectifs ayant comme commercial l'un des utilisateurs modifiés
        
        if (listObj != null && listObj.size() != 0) //cet utilisateur est un commercial pour des objectifs
        {
            for(User usr:listNewUsers)
            {
                if(usr.Organisation__c != mapOldUsers.get(usr.id).Organisation__c )
                {
                    setUsersID.add(usr.Id);
                    setAgenceDkCode.add(usr.Organisation__c);
                    setAgenceDkCode.add(mapOldUsers.get(usr.id).Organisation__c);
                }
            }
            
            List<Objectif__c> listObjToUpdate = [SELECT id,tech_UpdateCommercial__c 
                                                 FROM objectif__c 
                                                 WHERE DkCodeAgenceCommercial__c in :setAgenceDkCode or Commercial__r.id in :setUsersID];
            system.debug('listObjToUpdate ' + listObjToUpdate);            
            if(listObjToUpdate != null && listObjToUpdate.size() != 0)
            {
                for(Objectif__c obj : listObjToUpdate)
                {
                    obj.tech_UpdateCommercial__c = !obj.tech_UpdateCommercial__c;//changer la valeur pour activer les triggers update sur les objectifs
                }
                try{
                    update listObjToUpdate;}
                catch(exception e){
                    System.debug('#### exception  ' + e );  
                }
                
            }
        }
    }
}