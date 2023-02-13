/*
 * ScheduledContactUserRelationsBatch
 * @author: Ahmad Koubeissy
 * @date: 6/10/2017
 * @Test: ScheduledContactUserRelationsBatch_TEST
*/

global class ScheduledContactUserRelationsBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      UpdateContactUsersRelations_Batch batch = new UpdateContactUsersRelations_Batch ();
      database.executebatch(batch);
   }
}