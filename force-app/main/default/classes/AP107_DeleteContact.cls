/** 
* @author: Jacques Akiki
* @date: 21/03/2022 
* @description:Ne pas permettre aux utilisateurs dont le profil n'est pas dans l'etiquette ProfilsCanDeleteContact de supprimer des contacts 
* @Test: Class AP107_DeleteContact_test
*/
public without sharing class AP107_DeleteContact {
    public static void canDeleteContact(list<Contact> listCont) { 
        List<Profile> listProfile = [SELECT id, Name 
                            FROM Profile 
                            WHERE Id =:UserInfo.getProfileId()];
        if (listProfile!=NULL && Label.ProfilsCanDeleteContact.contains(','+listProfile[0].name+',')){
            system.debug('User can delete Contact');
        }
        else{
            system.debug('User cannot delete Contact');
            for (Contact cont:ListCont){
             cont.addError(Label.AP107_Error);
            }
        }

    }
}