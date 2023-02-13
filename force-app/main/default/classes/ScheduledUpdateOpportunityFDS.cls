global class ScheduledUpdateOpportunityFDS implements Schedulable {
        
        global void execute(SchedulableContext sc) {
            
              Batch06_UpdateOpportunityWithFDS d = new Batch06_UpdateOpportunityWithFDS(); 
              database.executebatch(d, 10);
        }
        
        /* Public static void SchedulerMethod(){
             ScheduledUpdateOpportunityFDS s = new ScheduledUpdateOpportunityFDS();
             string con_exp= '0 0 * * * ?';
             System.schedule('ScheduledUpdateOpportunityFDS', con_exp, s);
         }*/
               
 }