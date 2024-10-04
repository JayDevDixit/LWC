public class OpportunityProductHandler {
    public static void handleProduct(list<opportunityLineItem> OppLineItemList){
        set<id>idOfProduct = new set<id>();
        for(opportunityLineItem oli : OppLineItemList)
            idOfProduct.add(oli.product2id);
        list<aggregateResult> agrResultList = [select product2id,sum(quantity) sumquantity from opportunityLineItem
                                              where product2id in :idOfProduct group by product2id];
        map<id,decimal> mp = new map<id,decimal>();
        
    }
    
    
    public static void stopAddingOLI(list<OpportunityLineItem>oliList){
     map<id, Integer> mp = new Map<Id, Integer>(); //map for storing id of Opportunities related to oli with count of oli in them already + new oli

     for (OpportunityLineItem oli : oliList) 
     if (mp.containsKey(oli.Opportunityid)) 
    	mp.put(oli.opportunityid, mp.get(oli.opportunityid) + 1);
     else 
    	mp.put(oli.opportunityid, 1);
    List<Opportunity> oppList = [
    SELECT id, (select id from OpportunityLineItems)
    FROM Opportunity
    WHERE id IN :mp.keySet()
    ];
    for (Opportunity opp : oppList) 
    mp.put(opp.id,mp.get(opp.id)+opp.OpportunityLineItems.size());
    for (OpportunityLineItem oli : oliList) 
    	if (mp.get(oli.opportunityid) > 2) 
    		oli.addError('cannot be inserted ');
    
    }
    public static void createAsset(list<OpportunityLineItem>oliList){
        set<id>oppids = new set<id>();
        list<asset>assetList = new list<asset>();
        for(OpportunityLineItem oli : oliList)
            oppids.add(oli.opportunityid);
        list<opportunity>oppList = [select id,accountid from opportunity where id in :oppids];
        map<id,id>oppidVSaccid = new map<id,id>();        
        for(Opportunity opp : oppList)
            oppidVSaccid.put(opp.id,opp.accountid);
        map<id,id>accidVSconid = new map<id,id>();
        list<contact>conList = [select id,accountid from contact where accountid in :oppidVSaccid.values()];
        for(contact con:conList)
            accidVSconid.put(con.accountid,con.id);
        
        for(OpportunityLineItem oli :oliList){
            assetList.add(new asset(
                Name = oli.name,
                AccountId = oppidVSaccid.get(oli.OpportunityId),
                Product2Id = oli.Product2Id,
                Quantity = oli.Quantity,
                ContactId = accidVSconid.get(oppidVSaccid.get(oli.OpportunityId))
            ));
        }
        insert assetList;
    }

    public static void sendEmail(list<OpportunityLineItem>oliList){
        set<id>oppids = new set<id>();
        for(OpportunityLineItem oli : oliList)
            oppids.add(oli.opportunityid);
        List<Opportunity>oppList = [select accountid from opportunity where id in :oppids];
        set<id>accids = new set<id>();
        for(Opportunity opp : oppList)
            accids.add(opp.accountid);
        list<account>accList = [select client_contact_lookup__c from account where id in:accids];
        set<id>conids = new set<id>();
        for(account acc:accList) 
            conids.add(acc.client_contact_lookup__c);
        list<contact>conList = [select Email from contact where id in :conids];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(contact con : conList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{con.Email});
            email.setSubject('New Product Opportunity Line Items is Created');
        
            emails.add(email);
        }
        if(!emails.isEmpty())
            Messaging.sendEmail(emails);
    


    }
}