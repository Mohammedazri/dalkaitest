/**
 *@author Jacques Akiki
 *@date 16/11/2022
 *@description Test Class pour AP119_Task
 */
@isTest
public class AP119_Task_test {
    static testMethod void testNotif(){

        User testUser = [Select id from User where ID =:Label.AP101_MCConnectId];

        system.runAs(testUser){

            Account myaccount = testUtilsC360.createAccount('testAccount', 'Lebanon', 'Privé', Label.WS11_OUV, false, 'EDF', '50896193500022', 'abcdef123');
            insert myaccount;

            contact mycontact1 = testUtilsC360.createContact('Test 1', myaccount.Id, null, true);
            contact mycontact2 = testUtilsC360.createContact('Test 2', myaccount.Id, null, true);
            insert new List<Contact> {mycontact1, mycontact2};

            List<Task> listTSK = new list<Task>();
            for(Integer i = 0; i < 5; i++) {
                listTSK.add(new Task(ActivityDate = Date.today(), WhoId = mycontact1.id, Subject = Label.AP119_NotifyBody, Description = 'test'));
            }
            for(Integer i = 0; i < 5; i++) {
                listTSK.add(new Task(ActivityDate = Date.today(), WhoId = mycontact2.id, Subject = Label.AP119_NotifyBody, Description = 'test'));
            }
            Test.startTest();
            insert listTSK;
            Test.stopTest();
            delete listTSK[0];
        }
    }
}