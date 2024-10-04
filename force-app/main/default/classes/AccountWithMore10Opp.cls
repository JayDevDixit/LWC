public with sharing class AccountWithMore10Opp {
    public static void fetchAccountS(){
        List<AggregateResult>arg = [select AccountId from opportunity where 
        closeDate < :Date.Today().addDays(30) and stageName='Closed Won' group by AccountId having count(id)>10];
        list<id>accids = new list<id>();
        for(AggregateResult ar:arg)
        accids.add((id)ar.get('AccountId'));
        
        if(!accids.isEmpty())
            list<account>accList = [select id,name from account where id in :accids];
        else
        System.debug('No accounts found');
    }
    
}