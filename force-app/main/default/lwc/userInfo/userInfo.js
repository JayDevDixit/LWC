import { LightningElement } from 'lwc';

export default class UserInfo extends LightningElement {
    firstname;
    lastname;
    email;
    phone;
    title;
    Details = []
    k;
    handleFirstName(event){
        this.firstname = event.target.value; 
    }
    handleLastName(event){
        this.lastname = event.target.value; 
    }
    handleEmail(event){
        this.email = event.target.value; 
    }
    handlePhone(event){
        this.phone = event.target.value; 
    }
    handleTitle(event){
        this.title = event.target.value; 
    }
    submit(event){
        console.log(this.firstname,this.lastname,this.email,this.phone,this.title);
        
        this.k = `${this.firstname} ${this.lastname} ${this.email} ${this.title}`
    }
}