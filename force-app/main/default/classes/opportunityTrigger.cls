public class opportunityTrigger {
    
    public static void setCloseDate(list<opportunity> oppList){
        for(opportunity opp : oppList)
            if(opp.StageName == 'Closed Won'){
                	opp.CloseDate = Date.Today();
                	opp.Type = 'New Customer';
            }
    } 
   public static void limitAccountOpportunity(list<opportunity> oppList){
       set<id>idsOfAccount = new set<id>();
       for(opportunity opp : oppList)
           if(opp.AccountId != null)
           	idsOfAccount.add(opp.AccountId);
       List<AggregateResult> aggregateResultList = [
                                                       SELECT AccountId
                                                       FROM Opportunity
                                                       WHERE
                                                       AccountId IN :idsOfAccount
                                                       AND StageName = 'Closed Won'
                                                       AND Account.Working__c INCLUDES ('Asia')
                                                       GROUP BY AccountId
                                                       HAVING count(id) >= 2
                                                   ];
       idsOfAccount.clear();
       for(AggregateResult ar : aggregateResultList)
           idsOfAccount.add((Id)ar.get('AccountId'));
       for(opportunity opp : oppList)
           if(opp.AccountId != null && idsOfAccount.contains(opp.AccountId))
           		opp.AccountId.addError('Cannot assign to this account limit exceed');
    }
    public static void handleOLI(list<opportunity>oppList){
        for(opportunity opp : oppList)
            if(!opp.HasOpportunityLineItem && (opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won'))
            	opp.addError('opportunity must have a opportunity line item before closed');
    }
    public static void addCase(list<opportunity>oppList){
        list<case>caseList = new list<case>();
        for(opportunity opp : oppList)
        if(opp.StageName=='Closed Lost')
            caseList.add(new case(
                status='New',
                origin='Phone'
            ));
        insert caseList;
    }
    public static void validateCloseDate(list<opportunity>oppList){
        Date todayDate = Date.today();
        for(opportunity opp:oppList)
            if(opp.CloseDate < todayDate)
                opp.closeDate.addError('Please enter a future close date');
     
    }

    public static void addContactRoles(list<opportunity>oppList){
        map<id,Account>mp = new Map<Id,Account>([
            select id,(select id from contacts) from Account
            where id in (select AccountId from opportunity where id in :oppList)
        ]);
        list<OpportunityContactRole>ocrList = new List<OpportunityContactRole>();
        for(opportunity opp:oppList){
            if(opp.AccountId == null)
                continue;
            for(contact con:mp.get(opp.AccountId).Contacts)
                ocrList.add(new OpportunityContactRole(opportunityId=opp.id,contactId=con.id));
            
        }
        insert ocrList;
    

    }
    public static void clientContact(map<id,opportunity> oldmap, map<id,opportunity> newmap){
        set<id>accids = new set<id>();
        for(id oppid : newmap.keySet()){
            if(oldmap.get(oppid).client_contact__c==newmap.get(oppid).client_contact__c)
                continue;
            accids.add(newmap.get(oppid).AccountId);

        }
        list<account>accList = [select id,client_contact__c from account where id in :accids];
        list<account>accToUpdate = new list<account>();
        for(id oppid : newmap.keySet())
            for(account account : accList){
                if(account.id==newmap.get(oppid).AccountId){
                    account.client_contact__c = newmap.get(oppid).client_contact__c;
                    accToUpdate.add(account);
                    
                }

            }
        
        update accToUpdate;
    }

}