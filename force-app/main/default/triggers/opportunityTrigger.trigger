trigger opportunityTrigger on Opportunity (before update,before insert,after update,after insert) {
   // if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    //   opportunityTrigger.setCloseDate(Trigger.new);
    // if(Trigger.isBefore &&(Trigger.isInsert || Trigger.isUpdate))
    //     opportunityTrigger.limitAccountOpportunity(Trigger.new);
    //  if(Trigger.isBefore && Trigger.isUpdate)
    //      opportunityTrigger.handleOLI(Trigger.new);
    //if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
      //opportunityTrigger.addCase(Trigger.new);
    // if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
    // opportunityTrigger.validateCloseDate(Trigger.new);
    //if(Trigger.isAfter && Trigger.isInsert)
   // opportunityTrigger.addContactRoles(Trigger.new);
   if(Trigger.isAfter && Trigger.isUpdate){
   opportunityTrigger.clientContact(trigger.oldMap,trigger.newMap);
   }
}