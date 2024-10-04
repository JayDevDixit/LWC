public class insertRecordsPIP{
    public static boolean insertInterviewRecords(){
        // Creating and inserting interview records
        list<Interviewer__c> interList = new List<Interviewer__c>();
        for(Integer i=0;i<4;i++){
            Interviewer__c interviewer = new Interviewer__c();
            interviewer.Name = 'interviewer '+i;
            interviewer.CompaneyID__c = '10001' +i;
            if(i<2)
            interviewer.profile__c = 'QA';
            else
                interviewer.profile__c = 'Developer';
            interList.add(interviewer);

    }
    Database.SaveResult[] srList = Database.insert(interList);
    // checking each record insert sucessfully or not
    for (Database.SaveResult sr : srList)
        // checking successful insertion of a record 
        if (!sr.isSuccess())
            return false;
    return true;
}
    public static Boolean insertCandidateRecords(){
    // inserting candidate and their certifications records
    list <candidate__c> candiList = new List<candidate__c>();
    list<certification__c> certifiList = new List<certification__c>();
    for(integer i=0;i<20;i++){
        string profile = Math.mod(i,2)==0 ? 'QA' : 'Developer';
        Interviewer__c interviewer = [select id from Interviewer__c where profile__c = :profile limit 1];
        candiList.add(new candidate__c(
            Name='Candidate '+i,
            Position_Applied_for__c = profile,
            interviewer__c = interviewer.id
        ));

        // Adding minimum 2 certifications for each candidate
        for(Integer j=0;j<2;j++)
            certifiList.add(new certification__c(
                course_Name__c = 'Course '+j,
                passing_year__c = '2020'+j,
                candidate__c = candiList[i].id
            ));
        
    }
    Database.SaveResult[] srCandiList = Database.insert(candiList);
    // checking each record insert sucessfully or not
    for (Database.SaveResult sr : srCandiList)
        // checking successful insertion of a record 
        if (!sr.isSuccess())
            return false;
    Database.SaveResult[] srCertiList = Database.insert(certifiList);
    // checking each record insert sucessfully or not
    for (Database.SaveResult sr : srCertiList)
        // checking successful insertion of a record 
        if (!sr.isSuccess())
            return false;
    return true;

}
}