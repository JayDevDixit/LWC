public with sharing class signInController {
    @AuraEnabled(cacheable = true)
    public static string login(string username,string password){
        try {
            contact con = [select id,FirstName,LastName from contact where 
            username__c=:username and password__c=:password limit 1];
            if(con!=null){
                return 'Welcome'+ con.FirstName +' ' + con.LastName;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            return 'Invalid username or password';

        }
        return 'Invalid username or password';
    }
}