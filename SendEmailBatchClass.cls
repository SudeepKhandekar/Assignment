/*   Sr.No. User    Modified Date  Description
       1.   Sudeep  31/8/2015      Initilization
*/
       
global class SendEmailBatchClass implements Database.Batchable<sObject>, Database.Stateful{
	
	global static string query; 
	
	global static list<Messaging.SingleEmailMessage> mails;	
	
	//start method
	global Database.QueryLocator start(Database.BatchableContext BC){		
		
		
		
		SendEmailBatchClass.query = 'Select id, Subject__c, Search__c, Contact__c, Error__c'                   
					                  +' From   Email__c'
					                  +' Where Sent__c=false';
		
		//return list of account where primary contact is not null and opportunities are closed won 	
		return 	Database.getQueryLocator(SendEmailBatchClass.query);			
	}
	
	//execute method
	global void execute(Database.BatchableContext BC, list<Email__c> listEmail){  //templateid 00X28000000veI1
		
		mails = new list<Messaging.SingleEmailMessage>();
		
		if(!listEmail.isEmpty()){
			
			for(Email__c emailInstance:listEmail){
				
				/*Contact contact = [Select FirstName, 
		                                  Email,
		                                  Id 
		                           From   Contact
		                           Where  id =:emailInstance.Contact__c];
		
		        SendEmailController sendEmailControllerInstance = new SendEmailController();
		        sendEmailControllerInstance.sendEmailControllerMethod(emailInstance,contact);*/
		        
		        //Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
		       // singleEmailMessage = createEmail(contact.Email, contact.id);
		       Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			
			//message.setToAddresses(new list<string>{emailInstance.Contact__r.Email});			
			//message.setSenderDisplayName('Salesforce Search Engine');
			//message.setReplyTo('sudeepkhandekar1@gmail.com');			
			message.setTemplateId('00X28000000veI1');
			message.setTargetObjectId(emailInstance.Contact__c);system.debug('$$$$$$$$$$$$$emailInstance.Contact__c$$$$$$$$$$$'+emailInstance.Contact__c);			
			message.setWhatId(emailInstance.id);
			
			message.setSaveAsActivity(false);system.debug('$$$$$$$$$$$$$message$$$$$$$$$$$'+message);
		    mails.add(message);			        
			}				
		}		
		system.debug('$$$$$$$$$$$$$mails$$$$$$$$$$$'+mails);
		//send emails to all who are in the list
		if(!mails.isEmpty())		
		     Messaging.sendEmail(mails);		
		
	}
	
	//finish method
	global void finish(Database.BatchableContext BC){}
	
	/*global Messaging.SingleEmailMessage createEmail(string toEmailAddress, Id targetObjectId){
		
		    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			
			message.setToAddresses(new list<string>{toEmailAddress});			
			message.setSenderDisplayName('Salesforce Search Engine');
			message.setReplyTo('sudeepkhandekar1@gmail.com');			
			message.setTemplateId('00X28000000veI1');
			message.setTargetObjectId(targetObjectId);
			
			return message;
	} */
}