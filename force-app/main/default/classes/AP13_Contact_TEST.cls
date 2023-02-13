/*
* AP13_Contact_TEST
* @author: Pierre-Joseph Bascourt
* @date: 23/11/2017
*/
@isTest
public class AP13_Contact_TEST{
    @isTest
    public static void ContactCreationRelation_TEST(){
        account acc = testUtils.createAccount('test Account','Lebanon','Privé');
        acc.StatutPartenaire__c='OUV';
        insert acc;
        //the account will have one team member by default which is the owner
        contact con= testUtils.CreateContact('test Contact',acc.id,null); 
        con.Phone ='45245';
        insert con;
        
        User User1 = testUtils.CreateUser('userTest','test@test.com','test',userInfo.getProfileId(),'userTest@test.test.com');
        insert User1;
        con.OwnerId=User1.Id;
        update con;
        
    }
}