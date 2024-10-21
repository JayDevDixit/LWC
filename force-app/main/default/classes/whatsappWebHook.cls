@RestResource(urlMapping='/whatsapp/webhooks/v1/*')
global without sharing class whatsappWebHook {
    
    private static Final String SIGNATURE_VALID_MESSAGE     = 'Signature Verified';
    private static Final String SIGNATURE_NOT_VALID_MESSAGE = 'Signature could not be verified';
    
    @HttpGet // GET
    global static void doGet() {
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        if(request.params.get('hub.verify_token') == 'WHATSAPPTOKEN'){
            response.responseBody = Blob.valueOf( request.params.get('hub.challenge') );
        }
    }
    @HttpPost // POST
    global static void doPost() {
        system.debug('doPost--------------------------------');
        RestResponse response = RestContext.response;
        response.addHeader('Content-type','application/json');
        String responseString = RestContext.request.requestBody.toString();
        Map<String, String> headers = RestContext.request.headers;
        String responseValid = validateWhatsAppSignature(RestContext.request, responseString);
        if(responseValid == SIGNATURE_VALID_MESSAGE){
            system.debug('Header -> '+JSON.serialize(headers));
            system.debug('Response -> '+responseString);
            string finalResponseString = responseString.replace('type','typex');
            WhatsAppMessage parentMessage = (WhatsAppMessage)JSON.deserialize(finalResponseString,WhatsAppMessage.class);
            list<WhatsAppMessage.entry> messageEntries = parentMessage.entry;
            if(messageEntries!=null && messageEntries.size()>0){
                WhatsAppMessage.entry entryMessage = messageEntries.get(0);
                list<WhatsAppMessage.changes> changeMessages = entryMessage.changes;
                if(changeMessages!=null && changeMessages.size()>0){
                    WhatsAppMessage.changes changeMessage = changeMessages.get(0);
                    list<WhatsAppMessage.contacts> contactList = changeMessage.value.contacts;
                    list<WhatsAppMessage.messages> messageList = changeMessage.value.messages;
                    WhatsAppMessage.metadata metadata = changeMessage.value.metadata;
                    // Create a record
                    whatsapp_Message__c salesforceMessage = new whatsapp_Message__c();
                    salesforceMessage.PhoneNumber__c = metadata!=null ? metadata.display_phone_number:null;
                    if(contactList!=null && contactList.size()>0){
                        WhatsAppMessage.contacts contact = contactList.get(0);
                        salesforceMessage.Customer_Phone__c = contact.wa_id;
                        salesforceMessage.Name = contact.profile.name;
                    }
                    if(messageList!=null && messageList.size()>0){
                        WhatsAppMessage.messages message = messageList.get(0);
                        salesforceMessage.MessageID__c = message.id;
                        salesforceMessage.MessageType__c = message.typex;
                        system.debug('Type-> '+message.typex);
                        salesforceMessage.MessageSentTime__c = System.now();
                        salesforceMessage.Message_Content__c = message.text != null ? message.text.body : null;
                        // salesforceMessage.Reaction__c = message.reaction!=null ? message.reaction.emoji : null;
                    }
                    // salesforceMessage.Name = 'Custooomer';
                    system.debug('upsarting message'+salesforceMessage.Name);
                    salesforceMessage.isSent__c = 'false';
                    upsert salesforceMessage MessageID__c;

                    // Platform event
                    WA_Message_Event__e platformEvent = new WA_Message_Event__e();
                    platformEvent.Message_Id__c = salesforceMessage.id;
                    platformEvent.Customer_Phone__c = salesforceMessage.Customer_Phone__c;
                    platformEvent.Message_Content__c = salesforceMessage.Message_Content__c;
                    platformEvent.MessageSentTime__c = salesforceMessage.MessageSentTime__c;
                    Eventbus.publish(platformEvent);
                }
            }
            WA_Message_Event__e platformEvent = new WA_Message_Event__e();
        }
       
        
        response.statusCode = 200;
        response.responseBody = Blob.valueOf('{success:true, event:"success"}');
    }
    
    private static String validateWhatsAppSignature(RestRequest request, String responseString) {
        // Validate Stripe signature Start 
        Map<String, String> headers = request.headers;
        system.debug('validateWhatsAppSignature');
        
        String whatsAppSignature = headers.get('X-Hub-Signature-256');
        
        String whatsAppPayload = RestContext.request.requestBody.toString();
        
        // Verify the signature using 'hmacSHA256'. I have the Webhook key stored in a Custom Label
        String whatsAppSecret = System.Label.FBAppSecret; // Facebook Application Secret Key
        Blob signedPayload = Crypto.generateMac('hmacSHA256', Blob.valueOf(whatsAppPayload), Blob.valueOf( whatsAppSecret ));
        
        String encodedPayload = 'sha256='+EncodingUtil.convertToHex(signedPayload);
        // Return status code based on whether signed payload matches or not
        
        String response = (encodedPayload == whatsAppSignature)? SIGNATURE_VALID_MESSAGE : SIGNATURE_NOT_VALID_MESSAGE;
        return response;
        // Validate Stripe signature End 
    }
}