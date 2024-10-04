public with sharing class scheduleMail implements Schedulable{
    public void execute(SchedulableContext sc){
        Boolean status = scheduleMailHandler.sendMail();
        if(status)
            System.debug('Mail sent successfully');
        else
            System.debug('Failed to send mail');
    }
    
}