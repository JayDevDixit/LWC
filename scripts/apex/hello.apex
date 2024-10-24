public with sharing class fetchMetadata{
    
    public static list<Map<String,Object>> fetchMenuWithSubSections(){
   
            list<Menu__mdt> menuRecords = [
                select Id,MasterLabel,Order__c,(select Id,MasterLabel,ComponentApiName__c,Order__c,sections__c from SubSections__r order by order__c ASC)
                from Menu__mdt order by order__c asc
            ];
            list<Map<String,Object>> menuList = new list<Map<String,Object>>();
            for(Menu__mdt menu : menuRecords) {
                Map<String, Object> menuData = new Map<String, Object>();
                menuData.put('id', menu.Id);
                menuData.put('label', menu.MasterLabel);
                menuData.put('Order', menu.Order__c);
                List<Map<String, Object>> subSectionList = new List<Map<String, Object>>();
                for (subSection__mdt subSection : menu.SubSections__r) {
                    Map<String, Object> subSectionData = new Map<String, Object>();
                    subSectionData.put('id', subSection.Id);
                    subSectionData.put('label', subSection.MasterLabel);
                    subSectionData.put('MenuId', subSection.ComponentApiName__c);
                    subSectionData.put('Order', subSection.Order__c);
                    subSectionData.put('Sections', subSection.Sections__c);

                    // Add subsection to the list
                    subSectionList.add(subSectionData);
                }

                // Add the subsection list to the menu data
                menuData.put('subSections', subSectionList);

                // Add the menu data to the menu list
                menuList.add(menuData);
            }

            // Return the list of menus with subsections
            system.debug('MenuList '+menuList);
            return menuList;
            
         
    }
}