public with sharing class BatchLeadCreatedYesterday implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([select id,lastname,industry,company,status,phone,Email
        from lead where phone=null and createdDate = :Date.today().addDays(-1)]);
    }
    public void execute(Database.BatchableContext bc,list<lead>leadList){
        string emailBody = 'Leads Created Yesterday without phone number\n\n';
        for(lead ld:leadList){
            emailBody += 'Id: '+ld.Id+'\n';
            emailBody += 'Last Name: '+ld.LastName+'\n';
            emailBody += 'Industry: '+ld.Industry+'\n';
            emailBody += 'Company: '+ld.Company+'\n';
            emailBody += 'Status: '+ld.Status+'\n\n\n\n';
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { 'jay.dixit@cloudanalogy.com' }); // Replace with actual admin email
        mail.setSubject('Daily Report: Leads Without Phone Numbers');
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    public void finish(Database.BatchableContext bc){
        System.debug('lead Batch finished');
    }
    
}