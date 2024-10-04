public with sharing class ScheduleAccountContactCountBatch implements Schedulable {
    public void execute(SchedulableContext sc){
        AccContactCountBatch batchjob = new AccContactCountBatch();
        Database.executeBatch(batchjob, 200);
    }
    
}