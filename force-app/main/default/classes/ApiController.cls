public class ApiController{
    @AuraEnabled(cacheable = true)
    public static string fetchData(string topic){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        try{
        request.setMethod('GET');
        string url = 'https://newsapi.org/v2/everything?q='+topic+'&apiKey=718ba39c3d4f4da8babca2f02fc9c3ee';
        system.debug(topic);
        request.setEndpoint(url);
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            return response.getBody();
        } else {
            return 'Error fetching data';
        }
    }catch(Exception e){
        return 'An Error occured while fetching data from apex '+e.getMessage();
    }
    }
    @AuraEnabled(cacheable=true)
    public static string fetchDataUsingCustomSetting(string topic){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        try{
            API_Settings__c apiSettings = API_Settings__c.getInstance();
            string apiKey = apiSettings.API_Key__c;
            string endpoint = apiSettings.API_Endpoint__c;
            string url = endpoint + '?q=' +topic+ apiKey;
            request.setMethod('GET');
            request.setEndpoint(url);
            request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            return response.getBody();
        } else {
            return 'Error fetching data';
        }
        }catch(Exception e){
            return 'An Error occured while fetching data from apex '+e.getMessage();
        }
    }

    @AuraEnabled(cacheable = true)
    public static string fetchDataUsingCustomMetadata(String topic){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        try{
            API_Metadata__mdt	apiMetadata = [
                select API_Key__c,API_Endpoint__c
                from API_Metadata__mdt
                Limit 1
            ];
            string apiKey = apiMetadata.API_Key__c;
            string endpoint = apiMetadata.API_Endpoint__c;
            string url = endpoint + '?q=' +topic+'&apiKey='+ apiKey;
            request.setMethod('GET');
            request.setEndpoint(url);
            request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            return response.getBody();
        } else {
            return 'Error fetching data';
        }
        }catch(Exception e){
            return 'An Error occured while fetching data from apex '+e.getMessage();
        }
    }

    @AuraEnabled(cacheable=true)
    public static string fetchDataFromDrive(){
        final string ENDPOINT = 'callout:drive';
        HttpRequest req = new HttpRequest();
        try{
        // req.setEndpoint(ENDPOINT+'/drive/v3/files?fields=files(name,mimeType)&pageSize=1000');
        req.setEndpoint(ENDPOINT + '/drive/v3/files?fields=files(id,name,mimeType,createdTime,owners,webViewLink,webContentLink,iconLink,size)&pageSize=1000');
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        if(res.getStatusCode() == 200){
            return res.getBody();
        } else {
            return 'Error fetching data';
        }
    }catch(Exception e){
        return 'An Error occured while fetching data from apex '+e.getMessage();
    }
    }

    @AuraEnabled
    public static String uploadFileToDrive(String fileName, String fileBody) {
    final String ENDPOINT = 'callout:drive';
    HttpRequest req = new HttpRequest();
    try {
        // Metadata for the file (name and mimeType)
        String boundary = '-------314159265358979323846';
        String mimeType = 'application/octet-stream'; // Default mimeType

        // Set the correct MIME type based on the file extension
        if (fileName.endsWith('.docx')) {
            mimeType = 'application/vnd.google-apps.document';
        } else if (fileName.endsWith('.png')) {
            mimeType = 'image/png';
        } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
            mimeType = 'image/jpeg';
        }

        String metadata = '{"name":"' + fileName + '","mimeType":"' + mimeType + '"}';

        // Set endpoint for file upload
        req.setEndpoint(ENDPOINT + '/upload/drive/v3/files?uploadType=multipart');
        req.setMethod('POST');
        // req.setHeader('Authorization', 'Bearer ' + accessToken); // Ensure to add your access token
        req.setHeader('Content-Type', 'multipart/related; boundary="' + boundary + '"');

        // Decode base64 file content to Blob
        Blob decodedFileBody = EncodingUtil.base64Decode(fileBody);

        // Construct the request body
        String body = '--' + boundary + '\r\n' +
                      'Content-Type: application/json; charset=UTF-8\r\n\r\n' +
                      metadata + '\r\n' +
                      '--' + boundary + '\r\n' +
                      'Content-Type: ' + mimeType + '\r\n\r\n';

        // Append the binary file data directly as a Blob
        body += '\r\n' + decodedFileBody.toString() + '\r\n' + '--' + boundary + '--';

        // Create a final body Blob
        Blob finalBody = Blob.valueOf(body);
        // Append the binary content to the final body
        finalBody = Blob.valueOf(finalBody.toString() + decodedFileBody.toString());

        // Set the body as a Blob
        req.setBodyAsBlob(finalBody);

        // Send the request
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            return res.getBody();  // Success response
        } else {
            return 'Error uploading file: ' + res.getStatus() + ' - ' + res.getBody();
        }
    } catch (Exception e) {
        return 'An error occurred: ' + e.getMessage();
    }
}

    
}