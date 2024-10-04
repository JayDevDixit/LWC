public with sharing class scheduleAccConCount implements Schedulable {
    public void execute(SchedulableContext sc){
        AccContactCount batch = new AccContactCount();
        Database.executeBatch(batch);
    }
   
}