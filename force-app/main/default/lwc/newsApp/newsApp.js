import { LightningElement, track } from 'lwc';
import fetchData from '@salesforce/apex/ApiController.fetchData';
// import fetchDataUsingCustomSetting from '@salesforce/apex/ApiController.fetchDataUsingCustomSetting';
// import fetchDataUsingCustomMetadata from '@salesforce/apex/ApiController.fetchDataUsingCustomMetadata';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class NewsApp extends LightningElement {
    @track data;
    @track response;
    @track info = [];
    @track topic = 'sun';

    showToast(title,message,variant) {
        console.log('Show toast');
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }

    handleClick(event) {
        this.info = [];
        this.topic = this.topic.replace(/\s+/g, '');
        console.log(this.topic);
        fetchData({'topic':this.topic})
            .then(result => {
                this.data = result;
                console.log('API Response:', typeof(this.data));
                this.response = JSON.parse(this.data);
                // this.info.image = this.response['articles'][0]['urlToImage'];
                let array = this.response['articles'];
                if(array.length > 0) {
                this.showToast('Success','Data is fetched by API successfully','Success');
                let i = 0
                for(let obj of array){
                    console.log(obj['urlToImage']);
                    this.info.push({image:obj['urlToImage'],
                        id:i,title:obj['title'],
                        description:obj['description'],
                        content:obj['content'],
                        publishedAt:obj['publishedAt'],
                        urlToNews:obj['url']});
                    i+=1
                }}
                else{
                    console.log('No data is returned by API');
                    this.showToast('Warning','No data is returned by API','Warning');
                }
            })
            .catch(error => {
                this.error = error;
                console.error('Error fetching data:', error);
                this.showToast('Error','Error occured during fetching data from API','Error')
            });
    }
    handleTopicChange(event){
        this.topic = event.target.value;
        console.log(this.topic);
    }
    redirect(event){
        const cardIndex = event.currentTarget.dataset.index; // Use data attribute for card index
        const selectedCard = this.info[cardIndex];
        window.open(selectedCard.urlToNews, '_blank'); // Opens in a new tab
    }
    
}