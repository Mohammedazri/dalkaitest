/*
 * AP02_Account_TEST
 * @author: Ahmad Koubeissy
 * @date: 5/10/2017
*/

@isTest
public class AP02_Account_TEST {
    public TestMethod static void  ProprietaireEquipePartenaire_Test(){
        account acc = testUtils.createAccount('test Account','test','Public');
        acc.Lieu_immatriculation_legale__c = 'test';
        insert acc;
        //system.assertEquals(1, [Select id from accountTeamMember where accountid=:acc.id].size());
        
        User User2 = testUtils.CreateUser('userTest','test@test.com','test',userInfo.getProfileId(),'userTest@test.test.com');
        insert User2;
        
        system.runas(User2){
            acc.ownerid=user2.id;
            TriggerUtility.RunOnce = false;
            update acc;
            //system.assertEquals(1, [Select id from accountTeamMember where accountid=:acc.id].size());
        }
    }
}