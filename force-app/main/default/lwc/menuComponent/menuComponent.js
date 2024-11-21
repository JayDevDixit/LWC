import { LightningElement, track,wire,api } from 'lwc';
import fetchMenuWithSubSections from '@salesforce/apex/fetchMetadata.fetchMenuWithSubSections';
// import { NavigationMixin } from 'lightning/navigation';
import { subscribe,MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/ComponentCommunicationChannel__c';

export default class ModalComponent extends LightningElement {
  @api recordId;
  @wire(MessageContext)
  messageContext;
    @track isModalOpen = false;
    isClicked = false;
    @track componentConstructor;
  
    @track MenuComponents = [
        // { id: 1, label: 'About Response', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 2, label: 'On Behalf Of', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 3, label: 'Red Cross Responders', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
    ];
    @track showPrimaryClient = false;
    @track childProps = {
      focus:'',
      menuIndex : undefined,
      subSectionIndex : undefined,
    }
    @track showComponent = {
      'showPrimaryClient':false,
    }
    subscription = null;
    receivedMessage = 'No message received'
    connectedCallback(){
  console.log('childprops=',JSON.stringify(this.childProps))

      console.log('Record id = ',this.recordId)
      if(!this.subscription){
        this.subscription = subscribe(
          this.messageContext,
          COMPONENT_COMMUNICATION_CHANNEL,
          (payload) => {
            this.handlePayload(payload);
          }
        );
      }
    }
    handlePayload(payload){
      console.log('Received message',payload);
      this.receivedMessage = payload.message;
      this.MenuComponents[payload.menuIndex].subSections[payload.subSectionIndex].progress = payload.progress;
      let increment = 0;
      for(let i of this.MenuComponents[payload.menuIndex].subSections){
        increment = increment + i.progress;
      }
      this.MenuComponents[payload.menuIndex].progress = increment/this.MenuComponents[payload.menuIndex].subSections.length;
    }

    navigateToOtherComponent(event){
      // console.log(event.target);
      let buttonLabel = event.target.innerText;
      buttonLabel = 'show'+buttonLabel.replace(/\s+/g, '');
      // console.log('buttonLabel',buttonLabel)
      this.showComponent[buttonLabel] = true;
      this.isModalOpen = false;
    }
    handleLanguageChange(event){
        this.selectedLanguage = event.detail.value;
        // console.log('selected lang= ',this.selectedLanguage);
    }

    handleOpenModal() {
        this.isModalOpen = true;
        if(!this.isClicked){
          this.isClicked = true;
          fetchMenuWithSubSections().then(result=>{
            // console.log('before - ',result)
            this.MenuComponents = result.map((record,index)=>{
              let i = 0;
              let subSections = [];
              for(let subSection of record.subSections){
                subSections.push({...subSection,index:i, progress:0});
                i+=1;
              }
              // console.log('Subsections = ',record.subSections,Array.isArray(record.subSections));
                return {...record,progress:0, isExpanded: false, icon: 'utility:chevronright',index,subSections}
            })
            // console.log('menu = ',result); 
        });
        }
    }


    handleCloseModal() {
        this.isModalOpen = false;
        // console.log(JSON.stringify(this.MenuComponents));
    }

    toggleExpand(event) {
      // console.log('toggle expand called')
        const sectionId = event.target.dataset.id;
        // console.log('sectionId',sectionId);
        this.MenuComponents = this.MenuComponents.map((MenuComponent) => {
            if (MenuComponent.id == sectionId && MenuComponent.subSections.length>0) {
                MenuComponent.isExpanded = !MenuComponent.isExpanded;
                MenuComponent.icon = MenuComponent.isExpanded ? 'utility:chevronup' : 'utility:chevronright';
            }
            return MenuComponent;
        });
    }
    navigateToComponent(event) {
      this.childProps['menuIndex'] = undefined;
      this.childProps['subSectionIndex'] = undefined;
      // console.log(event.target);
      let buttonLabel = event.target.innerText;
      buttonLabel = buttonLabel.replace(/\s+/g, '');
      // console.log('buttonLabel',buttonLabel)
      // this.showComponent[buttonLabel] = true;
      this.isModalOpen = false;
      // console.log('before load comp')
      let targetComponent;
      for(let component of this.MenuComponents){
          for(let section of component.subSections)
            if(section.label.replace(/\s+/g, '') == buttonLabel){
              if(section.isSubSection == 'Yes'){
                targetComponent = component.label.replace(/\s+/g, '');
                // console.log('--------')
                this.childProps['focus'] = buttonLabel;
                this.childProps['menuIndex'] = component.index;
                this.childProps['subSectionIndex'] = section.index;
                break;
              }else{
                targetComponent = section.label.replace(/\s+/g, '');
                // console.log('+++++++++++++')
                this.childProps['menuIndex'] = component.index;
                this.childProps['subSectionIndex'] = section.index;
                break;
              }
            }
      }
      // console.log('targetComponent',targetComponent);
      this.targetComponent = targetComponent.charAt(0).toLowerCase() + targetComponent.slice(1)
      // console.log('targetComponent',targetComponent);
      // console.log('focus',this.childProps['focus']);
      this.loadComponent(this.targetComponent);

    //   let cmpDef = {
    //     componentDef: `c:${buttonLabel}`
    //   };
  
    //   let encodedDef = btoa(JSON.stringify(cmpDef));
    //   console.log('encodedDef',encodedDef);
    //   this[NavigationMixin.Navigate]({
    //     type: "standard__webPage",
    //     attributes: {
    //       url: "/one/one.app#" + encodedDef
    //     }
    //   });
    // }
    
}
// connectedCallback() {
//   import("c/primaryClient")
//     .then(({ default: ctor }) => (this.componentConstructor = ctor))
//     .catch((err) => console.log("Error importing component"));
// }

// renderedCallback() {
//   // this.refs.myCmp will be available on the next rendering cycle after the constructor is set
//   if (this.refs.myCmp) {
//     // this.refs.myCmp will contain a reference to the DOM node
//     console.log(this.refs.myCmp);
//   }
// }

click(event){
  // console.log('click called');
  this.isClicked = true;
   this.MenuComponents[0] = {...this.MenuComponents[0],progress:100};
  // console.log('progress=',JSON.stringify(this.MenuComponents[0]));
}


async loadComponent(componentName){
  // console.log('loadcomp called')
  // console.log('menuindex = ',this.childProps['menuIndex'])
  // console.log('submenuindex = ',this.childProps['subSectionIndex'])
  this.childProps['recordId'] = this.recordId;
  // console.log('childprops=',JSON.stringify(this.childProps))
  import(`c/${componentName}`)
  .then(({ default: ctor }) => (this.componentConstructor = ctor))
  .catch((err) => console.error("Error importing component"));
 }



  // Code for navigation
    // navigateToPrimaryClient() {
    //     console.log('Aura')
    //     this[NavigationMixin.Navigate]({
    //       type: "standard__component",
    //       attributes: {
    //         componentName: "c__MyAuraComponent"
    //       }
    //     });
    //   }
    // // New method to handle navigation to primaryClient
    // navigateToPrimaryClient1() {
    //     console.log('navi')
    //     let cmpDef = {
    //         componentDef: "c:primaryClient"
    //       };
      
    //       let encodedDef = btoa(JSON.stringify(cmpDef));
    //       this[NavigationMixin.Navigate]({
    //         type: "standard__webPage",
    //         attributes: {
    //           url: "/one/one.app#" + encodedDef
    //         }
    //       });
        }
