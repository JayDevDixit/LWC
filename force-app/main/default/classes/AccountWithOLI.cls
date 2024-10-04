public with sharing class AccountWithOLI {
    public static void fetchAccountwithmoreThan2OLI(){
        list<AggregateResult> oppWithMoreThan2Oli = [select opportunityid from opportunityLineItem group by opportunityid having count(id)>2];
        list<id>oppids = new list<id>();
        for(AggregateResult opp : oppWithMoreThan2Oli)
            oppids.add((id)opp.get('id'));
        list<account>accList = [select id,name from account where id in (
            select accountid from opportunity where id in :oppids
        )];
        for(account acc:accList)
            system.debug('---'+acc.name);
        system.debug('Total accounts are : '+accList.size());
    }
}