public with sharing class accountPicklistJS {
    @AuraEnabled(cacheable=true)
    public static list<account> getAccounts(){
       return [select id,name from account order by name limit 100];
    }
    @AuraEnabled(cacheable=true)
    public static list<contact> getContactByAccountID(id accountID){
        return [select id,FirstName,LastName,Email from contact where AccountId = :accountID order by LastName];
    }

    @AuraEnabled(cacheable=true)
    public static list<opportunity> getOpportunityByAccountID(id accountID){
        return [select id,Name,StageName,Amount from opportunity where AccountId = :accountID order by Name];
    }

    @AuraEnabled(cacheable=true)
    public static list<account> getAccountbySearch(String searchKey){
        string searchPattern = '%'+searchKey+'%';
        return [select id,name,Industry,phone,annualrevenue from account where name like :searchPattern order by name limit 100];
    }
}