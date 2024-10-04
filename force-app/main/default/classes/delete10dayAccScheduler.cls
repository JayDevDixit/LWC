public with sharing class delete10dayAccScheduler implements Schedulable {
    public static void execute(SchedulableContext sc){
        batchClassDelAccCreate10DayBefore batch = new batchClassDelAccCreate10DayBefore();
        Database.executeBatch(batch);
    }
}