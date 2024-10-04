import { LightningElement, track } from 'lwc';
import login from '@salesforce/apex/signInController.login';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SignInByContact extends LightningElement {
    @track username='';
    @track password='';

    handleChangeUsername(event){
        this.username = event.target.value;
    }
    handleChangePassword(event){
        this.password = event.target.value;
    }
    handleLogin(event){
        login({username:this.username, password:this.password}).then(result=>{
            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message:result,
                variant:'success'
            }));
        }).catch(error=>{
            this.dispatchEvent(new ShowToastEvent({
                title:'Error Invalid Username or password',
                message:'Invalid username or password',
                variant:'error'
            }));
        })
    }
}