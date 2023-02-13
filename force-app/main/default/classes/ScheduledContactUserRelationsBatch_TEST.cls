/** test class for the class ScheduledContactUserRelationsBatch **/
@isTest
private class ScheduledContactUserRelationsBatch_TEST{
   
    @isTest
    static void myUnitTest() {
        account acc = testUtils.createAccount('test Account','test','Public');
        insert acc;
        
        system.assertEquals(1, [Select id from accountTeamMember where accountid=:acc.id].size());
        
        //the account will have one team member by default which is the owner
        contact con= testUtils.CreateContact('test Contact',acc.id,null);
        con.Phone ='45245';
        insert con;
        
        User User2 = testUtils.CreateUser('userTest','test@test.com','test',userInfo.getProfileId(),'userTest@test.test.com');
        insert User2;
        
        AccountTeamMember atm = testUtils.CreateAccountTeamMember(acc.id,user2.id);
        insert atm;
        
        system.assertEquals(2, [Select id from accountTeamMember where accountid=:acc.id].size());
        //Create event
        test.startTest();
        
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute());
        String ss = String.valueOf(Datetime.now().second());
    
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
    
        ScheduledContactUserRelationsBatch Scheduler = new ScheduledContactUserRelationsBatch();
        String jobId = System.schedule('Second Job  ' + String.valueOf(Datetime.now()), nextFireTime, Scheduler );
        CronTrigger ct = fetchCronTrigger(jobId);
        System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');
        
        
        test.stopTest();
          //finish(jobId);
              
    }
    
    public static CronTrigger fetchCronTrigger(String jobId) {
        return [
            select CronExpression,
                TimesTriggered,
                NextFireTime
            from CronTrigger
            where Id = :jobId
        ];
    }
    
}