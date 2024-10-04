public with sharing class scheduleLeadCreatedBatch implements Schedulable {
    public void execute(SchedulableContext sc){
        BatchLeadCreatedYesterday batch = new BatchLeadCreatedYesterday();
        Database.executeBatch(batch);
    }
    
}