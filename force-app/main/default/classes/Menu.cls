public with sharing class Menu {
    @AuraEnabled(cacheable = true)
    public static Journey__c getAnimalsandNeeds(id recordId){
        Journey__c animalsData = [select First_Name__c,Last_Name__c,Age__c,Gender__c,Name from Journey__c where id=:recordId];
        return animalsData;
    }
    @AuraEnabled(cacheable = true)
    public static list<map<>>
}