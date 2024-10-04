public with sharing class MilestoneTriggerHandler {
    public static void checkMilestonesUpdateProjects(Set<Id> projectIds){
        if(projectIds.isEmpty()){
            system.debug('Project list empty, returning');
            return;
        }
        
        List<Project__c> projectsToUpdate = new List<Project__c>();
        List<Project__c> projects = [SELECT Id, Status__c, 
                                     (SELECT Id, Status__c FROM Milestones__r)
                                     FROM Project__c WHERE Id IN :projectIds];

        for(Project__c project : projects) {
            Boolean allMilestonesComplete = true;

            // Check if all milestones related to this project are complete
            for(Milestone__c milestone : project.Milestones__r) {
                if(milestone.Status__c != 'Complete') {
                    allMilestonesComplete = false;
                    system.debug('Incomplete Milestone found');
                    break;
                }
            }

            if(allMilestonesComplete && project.Status__c != 'Complete') {
                project.Status__c = 'Complete';
                projectsToUpdate.add(project);
            }
            else if(!allMilestonesComplete && project.Status__c != 'Incomplete'){
                project.Status__c = 'Incomplete';
                projectsToUpdate.add(project);
            }
        }

        if(!projectsToUpdate.isEmpty()) {
            update projectsToUpdate;
        }
    }

    public static void handleIncompleteMilestoneInsert(Set<Id> projectIds){
        if(projectIds.isEmpty())
            return;

        List<Project__c> projectsToUpdate = new List<Project__c>();
        List<Project__c> projects = [SELECT Id, Status__c FROM Project__c WHERE Id IN :projectIds];

        for(Project__c project : projects) {
            if(project.Status__c != 'Incomplete') {
                project.Status__c = 'Incomplete';
                projectsToUpdate.add(project);
            }
        }

        if(!projectsToUpdate.isEmpty()) {
            update projectsToUpdate;
        }
    }

    public static void handleCompleteMilestoneInsert(Set<Id> projectIds){
        if(projectIds.isEmpty())
            return;

        system.debug('Complete milestone inserted');
        List<Project__c> projects = [SELECT Id, Status__c, 
                                     (SELECT Id, Status__c FROM Milestones__r)
                                     FROM Project__c WHERE Id IN :projectIds];
        for(Project__c project : projects) {
            if(project.Milestones__r.size() == 1){
                system.debug('Project has only 1 milestone');
                project.Status__c = 'Complete';
            }
        }
        update projects;
    }

    public static void handleMilestoneUpdate(Map<Id, Milestone__c> milestoneOldMap, Map<Id, Milestone__c> milestoneNewMap){
        Set<Id> projectIds = new Set<Id>();
        for(Milestone__c milestone : milestoneNewMap.values()) {
            if(milestoneOldMap.get(milestone.Id).Status__c != milestone.Status__c && milestone.Project__c != null) {
                projectIds.add(milestone.Project__c);
            }
        }
        checkMilestonesUpdateProjects(projectIds);
    }

    public static void handleMilestoneDelete(List<Milestone__c> milestoneList){
        Set<Id> projectIds = new Set<Id>();
        for(Milestone__c milestone : milestoneList) {
            if(milestone.Status__c != 'Complete' && milestone.Project__c != null) {
                projectIds.add(milestone.Project__c);
            }
        }
        checkMilestonesUpdateProjects(projectIds);
    }

    public static void handleMilestoneInsert(List<Milestone__c> milestoneList){
        Set<Id> incompleteProjectIds = new Set<Id>();
        Set<Id> completeProjectIds = new Set<Id>();

        for(Milestone__c milestone : milestoneList) {
            if(milestone.Status__c != 'Complete' && milestone.Project__c != null) {
                incompleteProjectIds.add(milestone.Project__c);
            }
            else if(milestone.Status__c == 'Complete' && milestone.Project__c != null) {
                completeProjectIds.add(milestone.Project__c);
            }
        }

        handleIncompleteMilestoneInsert(incompleteProjectIds);
        handleCompleteMilestoneInsert(completeProjectIds);
    }
}
