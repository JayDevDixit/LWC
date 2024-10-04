public with sharing class batchClassDelAccCreate10DayBefore implements Database.Batchable<sObject>,Database.stateful {
    Integer succDeleted = 0;
    integer failDeleted = 0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([
            select id,name from account WHERE createdDate = last_N_days:10
        ]);
    }
    public void execute(Database.BatchableContext bc,list<account>accList){
        list<Database.DeleteResult> delRes = Database.delete(accList,false);
        for(Database.DeleteResult del : delRes)
        {
            if(del.isSuccess())
            {
                succDeleted++;
            }
            else {
                failDeleted++;
                system.debug('Fail delete'+del.getErrors());
            }
        }
        System.debug('Successful delete = '+succDeleted+' failed = '+failDeleted);
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Successful delete = '+succDeleted+' failed = '+failDeleted);
    }
    
}