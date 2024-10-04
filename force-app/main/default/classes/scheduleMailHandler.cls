public with sharing class scheduleMailHandler {
    public static Boolean sendMail(){
        try{
            List<Opportunity>oppList = [select id,name,stagename,owner.name,owner.email from Opportunity where closeDate<:Date.Today() and stagename not in ('Closed Lost','Closed Won') limit 2];
            list<Messaging.SingleEmailMessage> mailList = new list<Messaging.SingleEmailMessage>();
            for(opportunity opp:oppList) {
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                list<string>sendTo = new List<string>();
                sendTo.add('jay.dixit@cloudanalogy.com'); // put opp.owner.email
                msg.setToAddresses(sendTo);
                msg.setSubject('opportunity '+opp.name+' is not closed yet');
                string body = 'Dear '+opp.owner.name+' please close opportunity '+opp.name+' because close date is passed';
                msg.setPlainTextBody(body);
                mailList.add(msg);
            }
            Messaging.sendEmail(mailList);
            return true;

        }catch(Exception e){
            system.debug('fail to send mail');
            return false;
        }
    }
}