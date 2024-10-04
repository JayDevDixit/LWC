public with sharing class SendEmailUser100Acc30Con {
    public static void sendEmail(){
        list<user> userWithAccounts = [select Id,Email from user where Id IN (select OwnerId from account where phone!=null GROUPBY(OwnerId)  HAVING COUNT(id)>100)];
    }
}