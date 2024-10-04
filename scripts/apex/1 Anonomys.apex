// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//string cronExp = '0 0 12 * * ?';
//System.schedule('Daily account deletion job',cronExp,new delete10dayAccScheduler());

// cronTrigger scheduledJob = [select id from cronTrigger where cronJobDetail.Name = 'Daily account deletion job' limit 1];
// System.abortJob(scheduledJob.id);

// batchcreate5opp batch = new batchcreate5opp();
// Database.executeBatch(batch);
// string cronExp;
// cronExp = '0 0 0 * * ?';
// system.schedule('Daily opportunity creation Job - 12 AM',cronExp,new scheduleDailyOppCreation());
// cronExp = '0 0 6 * * ?';
// system.schedule('Daily opportunity creation Job - 6 AM',cronExp,new scheduleDailyOppCreation());
// cronExp = '0 0 12 * * ?';
// system.schedule('Daily opportunity creation Job - 12 PM',cronExp,new scheduleDailyOppCreation());
// cronExp = '0 0 18 * * ?';
// system.schedule('Daily opportunity creation Job - 6 PM',cronExp,new scheduleDailyOppCreation());

// list<cronTrigger>scheduledJobs = [select id from cronTrigger
// where cronJobDetail.name like '%Daily opportunity creation Job%'];
// if(!scheduledJobs.isEmpty()) {
//     try{
//         for(cronTrigger job : scheduledJobs) 
//             System.abortJob(job.id);
//         System.debug('Scheduled jobs deleted');
//     }catch(Exception e){
//         system.debug('Fail to delete scheduled jobs '+e.getMessage());
//     }
// }
// else {
//     System.debug('No scheduled jobs found to delete');
// }

// AccContactCount ac = new AccContactCount();
// Database.executeBatch(ac);



// schedule every 5 minute
// string cronExp;
// for(integer i=0;i<60;i+=5){
//     cronExp = '0 '+i+' * * * ?';
//     System.schedule('Update Account Contact Count '+i, cronExp, new scheduleAccConCount());
// }

// string cronExp;
// cronExp = '0 56 15 * * ?';
// system.schedule('Lead created yesterday without phone number',cronExp,new scheduleLeadCreatedBatch());