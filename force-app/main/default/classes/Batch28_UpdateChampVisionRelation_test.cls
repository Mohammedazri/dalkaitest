/*--------------------------------------------------------------------------------------------------------------------------
Author: Jacques Akiki  
Company: EI-Technologies
Description: Test Class for Class Batch28_UpdateChampVisionRelationAccount  
History
<Date>      <Authors Name>   <Brief Description of Change>
14/12/2018   Jacques AKiki      Creation
--------------------------------------------------------------------------------------------------------------------------*/
@isTest
public class Batch28_UpdateChampVisionRelation_test 
{
    @isTest
    static void  Batch28_UpdateChampVisionRelation_test() 
    {
        
       
        list<User> listUsers = [SELECT id, Bypass_triggers__c
                          		FROM User
                          		WHERE id=:UserInfo.getUserId()];
        if (listUsers.size()==1)
        {
            User currentUser = listUsers[0];
            String oldBypass = currentUser.Bypass_triggers__c;
            if ( oldBypass<>NULL && !oldBypass.contains('AP42_Account') )
            {
               currentUser.Bypass_triggers__c = oldBypass +';AP42_Account'; 
            }
            else if (oldBypass==NULL)
            {
                currentUser.Bypass_triggers__c = 'AP42_Account';
            }
            update currentUser;
            
            //create Account
            account a1= testUtils.createAccount('testAccount', 'Lebanon', 'Privé');
            //a1.QualitePartenaire__c = 'Optimum';
            a1.Qualification__c = 'N/A';
            insert a1;
            Batch28_UpdateChampVisionRelationAccount testBatch = new Batch28_UpdateChampVisionRelationAccount();
            DataBase.executeBatch(testBatch);
            currentUser.Bypass_triggers__c = oldBypass;
            update currentUser;
        
        }
    }
}