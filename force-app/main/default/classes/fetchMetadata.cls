public with sharing class fetchMetadata {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> fetchMenuWithSubSections() {
        try {
            string selectedLanguage = UserInfo.getLanguage();
            // Fetch the metadata records of Menu__mdt and subSection__mdt
            List<Menu__mdt> menuRecords = [SELECT Id, MasterLabel, Order__c,Active__c,Custom_Label__c FROM Menu__mdt where Active__c=TRUE ORDER BY Order__c ASC];
            List<subSection__mdt> subSectionRecords = [
                SELECT Id, MasterLabel, ComponentApiName__c, Order__c, Sections__c,Active__c,Custom_Label__c 
                FROM subSection__mdt  where Active__c=TRUE
                ORDER BY Order__c ASC
            ];
            // Prepare the result list to store menu with subsections
            List<Map<String, Object>> menuList = new List<Map<String, Object>>();
            // Loop through each menu record
            for (Menu__mdt menu : menuRecords) {
                Map<String, Object> menuData = new Map<String, Object>();
                menuData.put('id', menu.Id);
                // menuData.put('label', menu.MasterLabel);
                if(system.label.translationExists('',menu.Custom_Label__c,selectedLanguage))
                    menuData.put('label', system.label.get('',menu.Custom_Label__c,selectedLanguage));
                   
                else 
                    menuData.put('label', menu.MasterLabel);
                
                // menuData.put('Order', menu.Order__c);

                // Prepare subsection data for the current menu
                List<Map<String, Object>> subSectionList = new List<Map<String, Object>>();
                for (subSection__mdt subSection : subSectionRecords) {
                    if (subSection.ComponentApiName__c == menu.id) {
                        Map<String, Object> subSectionData = new Map<String, Object>();
                        subSectionData.put('id', subSection.Id);
                        if(system.label.translationExists('',subSection.Custom_Label__c,selectedLanguage))
                            subSectionData.put('label', system.label.get('',subSection.Custom_Label__c,selectedLanguage));
                        else 
                            subSectionData.put('label', subSection.MasterLabel);

                        subSectionData.put('MenuId', subSection.ComponentApiName__c);
                        // subSectionData.put('Order', subSection.Order__c);
                        // subSectionData.put('Sections', subSection.Sections__c);
                        if(subSection.Sections__c!=null){
                            list<string> subSections = subSection.Sections__c.split(',');
                            for(integer i=0;i<subSections.size();i++){
                                subSectionList.add(new Map<String, Object>{
                                    'label'=>subSections[i],
                                    'isSubSection'=>'Yes'
                                });
                               
                            }
                        }
                        // Add subsection to the list
                        subSectionList.add(subSectionData);
                    }
                }
                // Add the subsection list to the menu data
                menuData.put('subSections', subSectionList);

                // Add the menu data to the menu list
                menuList.add(menuData);
            }
            // Return the list of menus with subsections
            return menuList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
