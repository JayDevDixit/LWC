public with sharing class getOppbyAccountID {
    @AuraEnabled(cacheable = true)
    public static list<opportunity> getOpportunities(id accountId){
        try {
            return [select id,name,amount from opportunity where accountid=:accountId];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}