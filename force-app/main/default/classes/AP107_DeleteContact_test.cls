/** 
* @author Jacques Akiki - Ei technologies
* @date 22/03/2022 
* @description test class of AP107_DeleteContact
*/
@istest
public with sharing class AP107_DeleteContact_test {
    @istest
    static void deleteContactTest() {

        list<Profile> listP = [SELECT Id,name FROM Profile WHERE name like'%syst%' or name ='Commercial'];
        list<user> listus = new list<User>();
        User u1 = testUtils.CreateUser('user1', 'user1@test-Dalkia.fr', 'user1',null , 'user1@test-Dalkia.fr'); 
        User u2 = testUtils.CreateUser('user2', 'user2@test-Dalkia.fr', 'user2',null , 'user2@test-Dalkia.fr'); 
        
        for(profile p : listP){
            if(p.name == 'Commercial'){
                u1.profileId = p.id;
                listus.add(u1);
            }
            else{
                u2.profileId = p.id;
                listus.add(u2);
            }

        }
        insert listus;
        Contact cont = new Contact();
        cont.LastName = 'TEST';
        cont.FirstName = 'TEST';
        cont.Title = 'M';
        cont.Email = 'test.test@test.test';
        cont.Phone = '123';
        insert cont;

        System.runAs(u1) { 
            try{
                delete cont;
            } 
            catch(Exception e) {
                system.debug('error message ...' + e.getMessage());
                System.assert(e.getMessage().contains(Label.AP107_Error));
            }
        }
        System.runAs(u2) { 
            delete cont;
        }

    }
}