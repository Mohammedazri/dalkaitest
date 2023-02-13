/** 
* @author Dona Kfoury
* @date 15/1/2020 
* @description class containing methods called when deleting contacts
* @Test Class AP72_Contact_Test
*/
public class AP72_Contact {
    /** 
    * @author Dona Kfoury 
    * @date 15/1/2020 
    * @check if the contact being deleted is the technical contact necessary for SDocs, if so, do not authorize the deletion
    * @param contactList: list of contacts being deleted 
    * @return void
    */
    public static void checkIfCanDeleteContact(List<Contact> contactList){
        for(Contact myContact:contactList){
            if(myContact.email == Label.AP72_EmailContactTechnique && myContact.LastName == label.AP72_LastNameContactTechnique)
            {
                //do not authorize the deletion
                myContact.adderror(Label.AP72_ErrorContactTechnique);
            }
        }
    }
    
    /** 
    * @author Dona Kfoury 
    * @date 15/1/2020 
    * @check if the account being deleted is the parent account of the technical contact necessary for SDocs, if so, do not authorize the deletion
    * @param contactList: list of accounts being deleted 
    * @return void
    */
    public static void checkIfCanDeleteAccount(List<Account> accountList){
        for(Account myAccount:accountList){
            if(myAccount.Name == Label.AP72_NameAccountTechnique)
            {
                //do not authorize the deletion
                myAccount.adderror(Label.AP72_ErrorAccountTechnique);
            }
        }
    }
}