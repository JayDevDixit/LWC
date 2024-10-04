/*"Create a batch Class which should run every day 00:00 and fetch all the Leads created yesteday not having a Phone number. Send an Email to the system Admin with the list of those Leads with details"*/
public with sharing class LeadNotification implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        DateTime yesterday = system.now().addDays(-1).date();
        DateTime today = System.now().date();
        return Database.getQueryLocator([
            select id,name,email,createdDate
            from Lead where createdDate>=:yesterday and createdDate<:today
            and Phone=null
        ]);

    }
    public void execute(Database.BatchableContext bc,list<lead>leadList){
        String emailBody = 'Leads created yesterday without a phone number:\n\n';
        for (Lead lead : leadList) {
            emailBody += 'ID: ' + lead.Id + ', Name: ' + lead.Name + ', Email: ' + lead.Email + ', Created Date: ' + lead.CreatedDate + '\n';
        }

        // Send email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { 'admin@example.com' }); // Replace with actual admin email
        mail.setSubject('Daily Report: Leads Without Phone Numbers');
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    public void finish(Database.BatchableContext bc){
        system.debug('Batch finished');
    }
}
// public class scheduleLeadNotification implements Schedulable{
//     public void execute(SchedulableContext sc){
//         LeadNotification batch = new LeadNotification();
//         Database.executeBatch(batch, 200);
//     }
// }
// string cronExp = '0 0 0 * * ?';
// system.schedule('DailyLeadNotificationBatch', cronExp,new scheduleLeadNotification());