public with sharing class fetchMetadata {
    @AuraEnabled(cacheable=true)
    public static list<map<string,object>> fetchMenu(){
        try {
            // Fetch the metadata records of Menu__mdt
            List<Menu__mdt> menuRecords = [SELECT id,MasterLabel, Order__c FROM Menu__mdt ORDER BY Order__c ASC];

            // Prepare the result to return in a structured format
            List<Map<String, Object>> menuList = new List<Map<String, Object>>();

            for (Menu__mdt menu : menuRecords) {
                Map<String, Object> menuData = new Map<String, Object>();
                menuData.put('id', menu.id);
                menuData.put('label', menu.MasterLabel);
                menuData.put('Order', menu.Order__c);

                // Add each record's data to the menu list
                menuList.add(menuData);
            }
            // Return the list of metadata records
            return menuList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static list<map<string,object>> fetchSubSection(){
        try {
             // Fetch the metadata records of subSection__mdt
             List<subSection__mdt> subSectionRecords = [
                SELECT id, MasterLabel, ComponentApiName__c, Order__c, Sections__c 
                FROM subSection__mdt 
                ORDER BY Order__c ASC
            ];

            // Prepare the result to return in a structured format
            List<Map<String, Object>> subSectionList = new List<Map<String, Object>>();

            for (subSection__mdt subSection : subSectionRecords) {
                Map<String, Object> subSectionData = new Map<String, Object>();
                subSectionData.put('id', subSection.id);
                subSectionData.put('label', subSection.MasterLabel);
                subSectionData.put('Menu id', subSection.ComponentApiName__c);
                subSectionData.put('Order', subSection.Order__c);
                subSectionData.put('Sections', subSection.Sections__c);

                // Add each record's data to the subSection list
                subSectionList.add(subSectionData);
            }

            // Return the list of subsection metadata records
            return subSectionList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}