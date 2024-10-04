trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert,after update,before insert) {
   // if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    //    OpportunityProductHandler.handleProduct(Trigger.new);
   // if(Trigger.isInsert && Trigger.isBefore)
   //    OpportunityProductHandler.stopAddingOLI(Trigger.new);
   // if(Trigger.isAfter && Trigger.isInsert)
   // OpportunityProductHandler.createAsset(Trigger.new);
   if(Trigger.isAfter && Trigger.isInsert)
      OpportunityProductHandler.sendEmail(Trigger.new);
}