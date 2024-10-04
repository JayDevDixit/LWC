public with sharing class insertAccountJS {
    @AuraEnabled
    public static Account insertAccountObject(String name, String industry, String phone, Boolean isChecked, String num) {
        try {
            Account acc = new Account(
                Name = name,
                Industry = industry,
                Phone = phone,
                Active__c = isChecked ? 'Yes' : 'No', // Convert boolean to picklist value
                AccountNumber = num
            );
            insert acc;
            return acc;
        } catch (Exception e) {
            throw new AuraHandledException('Error inserting Account: ' + e.getMessage());
        }
    }
}
