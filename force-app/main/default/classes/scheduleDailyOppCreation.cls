public with sharing class scheduleDailyOppCreation implements Schedulable{
    public void execute(SchedulableContext sc){
        batchcreate5opp batch = new batchcreate5opp();
        Database.executeBatch(batch, 200); // Batch size can be adjusted based on

    }
    
}