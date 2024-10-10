public class AccountDataController {
 
    @AuraEnabled (cacheable=true)
    public static List<Contact> fetchContact(){
        return [SELECT Id, Name, Account.Name, AccountId, Email 
                FROM Contact LIMIT 1000];       
    }
}