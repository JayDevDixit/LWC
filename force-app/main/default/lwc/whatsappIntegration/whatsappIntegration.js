import { LightningElement, wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendMessage from '@salesforce/apex/whatsappMessageService.sendMessage';
import getMessages from '@salesforce/apex/whatsappMessageService.getMessages';
import {refreshApex} from '@salesforce/apex';
import { subscribe,unsubscribe,onError } from 'lightning/empApi';
export default class WhatsappIntegration extends LightningElement {
    
    msg = '';
    eventName = '/event/WA_Message_Event__e';
    subscription;
    @track wireServiceResult;
    @track sentMessages = [];
    showToast(title,message,variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(evt);
    }
    @wire(getMessages)
    wiredMessages(result){
        this.wireServiceResult = result;
        const { data, error } = result;
        if(data){
            // this.sentMessages = data;
            this.sentMessages = data.map(message => {
                return {
                    ...message,
                    isSent: message.isSent__c === 'true', // Convert the text field to a boolean
                    formattedTime: this.formatDateTime(message.MessageSentTime__c)
                };
            });
            console.log('Messages fetched successfully', data);
        }
        else if(error){
            console.error('Error in fetching messages', error);
            this.showToast('Error','Error fetching saved messages','Error');

        }
    }
    formatDateTime(datetimeString) {
        const date = new Date(datetimeString);
        return date.toLocaleString(); // You can customize this for different locales
    }

    connectedCallback(){
        this.handleErrorRegister();
        this.handleSubscribe();
    }
    handleSubscribe(){
        subscribe(this.eventName,-1,this.handleSubscribeResponse.bind(this)).then((response)=>{
            this.subscription = response;
            console.log('Subscribed to channel',JSON.stringify(response));
        })
    }
    handleSubscribeResponse(response){
        console.log('Response from webhook ',JSON.stringify(response));
        refreshApex(this.wireServiceResult);
    }
    handleErrorRegister(){
        onError((error)=>{
            console.error('Received error from server',JSON.stringify(error));
        });
    }


    handleClick(event){
        console.log(this.i);
        sendMessage({message:this.msg}).then(response=>{
                if(response=='Success'){
                    console.log(response);
                    this.showToast('Success','Message Sent','Success')
                    return refreshApex(this.wireServiceResult);
                }
                else{
                    console.log('Error ',response);
                    this.showToast('Error',response,'Error')

                }
        }).catch(response=>{
            console.log('Error ',response);
            this.showToast('Error',response,'Error')
        })

        
        console.log('Send message');
        this.msg = '';
    }
    handleChange(event){
        this.msg = event.target.value;
    }

 
    disconnectedCallback(){
        this.handleUnSubscribe();
    }
    handleUnSubscribe(){
        // unsubscribe(this.subscription,)
    }
}