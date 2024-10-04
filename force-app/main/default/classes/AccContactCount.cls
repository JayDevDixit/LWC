public with sharing class AccContactCount implements Database.Batchable<SObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select id from Account]);
    }
    public void execute(Database.BatchableContext bc,list<account>accList){
        try{
        list<account>accToUpdate = new list<account>();
        map<id,integer>accVSconCount = new map<id,integer>();
        for(Account acc : accList)
        accVSconCount.put(acc.id,0);
        
        AggregateResult[] aggregate = [select accountid,count(id) contactCount
        from contact where accountid in :accVSconCount.keySet() group by accountid];
        for(AggregateResult ar : aggregate){
            id id = (id) ar.get('accountid');
            integer count = (integer) ar.get('contactCount');
            if(accVSconCount.containsKey(id))
             accVSconCount.put(id,count);
        }
        for(id accountid : accVSconCount.keySet())
            for(account acc:accList)
                if(acc.id == accountid){
                    acc.Contact_Count__c = accVSconCount.get(accountid);
                    accToUpdate.add(acc);
                    break;
                }
                update accToUpdate;
            }catch(Exception e){
                system.debug('Exception occcur'+e.getMessage());
            }
    }
    public void finish(Database.BatchableContext bc){
        system.debug('Batch of count contact finished');
    }
    
}