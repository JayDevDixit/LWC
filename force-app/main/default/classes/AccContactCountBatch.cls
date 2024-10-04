public class AccContactCountBatch implements Database.Batchable<SObject>,Database.stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            select id,name from account
        ]);
    }
    public void execute(Database.BatchableContext bc,List<account> accList){
        list<account>accToUpdate = new list<account>();
        for(account acc:accList) {
            integer conCount = [select count() from contact where accountid=:acc.id];
            acc.Contact_Count__c = conCount;
            accToUpdate.add(acc);
    
    }


    if(!accToUpdate.isEmpty())
        update accToUpdate;

}
public void finish(Database.BatchableContext bc){
        System.debug('Batch finished');
}
}


/*
// run anonom window
// Run at minute 0, 5, 10, ..., 55
String[] cronExpressions = new String[] {
    '0 0 * * * ?',   // 0 minutes past the hour
    '0 5 * * * ?',   // 5 minutes past the hour
    '0 10 * * * ?',  // 10 minutes past the hour
    '0 15 * * * ?',  // 15 minutes past the hour
    '0 20 * * * ?',  // 20 minutes past the hour
    '0 25 * * * ?',  // 25 minutes past the hour
    '0 30 * * * ?',  // 30 minutes past the hour
    '0 35 * * * ?',  // 35 minutes past the hour
    '0 40 * * * ?',  // 40 minutes past the hour
    '0 45 * * * ?',  // 45 minutes past the hour
    '0 50 * * * ?',  // 50 minutes past the hour
    '0 55 * * * ?'   // 55 minutes past the hour
};

// Loop through each cron expression and schedule the job
for (Integer i = 0; i < cronExpressions.size(); i++) {
    System.schedule('AccountContactCountBatchEvery5Minutes_' + i, cronExpressions[i], new ScheduleAccountContactCountBatch());
}
    */

// // Create a list to hold the CRON expressions
// List<String> cronExpressions = new List<String>();

// // Populate the list with CRON expressions for every 5 minutes
// for (Integer i = 0; i < 60; i += 5) {
//     cronExpressions.add('0 ' + i + ' * * * ?');
// }

// // Schedule the batch job with each CRON expression
// for (Integer j = 0; j < cronExpressions.size(); j++) {
//     System.schedule('AccountContactCountBatchEvery5Minutes_' + j, cronExpressions[j], new ScheduleAccountContactCountBatch());
// }
