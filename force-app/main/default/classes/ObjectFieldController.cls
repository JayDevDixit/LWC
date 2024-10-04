public with sharing class ObjectFieldController {
    @AuraEnabled(cacheable = true)
    public static list<string> getAllObjectsName(){
        List<string> objectName = new List<string>();
        for(schema.SObjectType objType:Schema.getGlobalDescribe().values()){
            DescribeSObjectResult objResult = objType.getDescribe();
            if(objResult.isQueryable())
                objectName.add(objResult.getName());            
        }
        return objectName;
    }

    @AuraEnabled(cacheable = true)
    public static list<map<string,object>> getFieldsbyObjectName(string objectName){
        map<string,Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        list<map<string,object>> fieldList = new List<map<string,object>>();
        for (String fieldName : fieldsMap.keySet()) {
            Map<String, Object> fieldDetails = new Map<String, Object>();
            DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
            
            fieldDetails.put('label', fieldDescribe.getLabel());
            fieldDetails.put('apiName', fieldDescribe.getName());
            fieldDetails.put('type', fieldDescribe.getType().name());
            
            fieldList.add(fieldDetails);
        }
        return fieldList;
    }
}
