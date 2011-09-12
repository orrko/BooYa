package com.onoapps.BooYa;

import java.util.ArrayList;

import com.onoapps.BooYa.R;

import android.R.integer;
import android.R.string;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.provider.Contacts;
import android.provider.Contacts.People;

public class RootActivity extends Activity {

	private ArrayList<ContactData> contactsArr;
	private ContactData newContact;
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
         
        // Get the app's shared preferences
        SharedPreferences app_preferences = 
        	PreferenceManager.getDefaultSharedPreferences(this);
        
        // Get the value for the run counter
        Boolean isLoggedIn = app_preferences.getBoolean("LOG_IN_FLAG", false);
		
        if(!isLoggedIn){      	
        	//
        	Intent i = new Intent(this,RegisterActivity.class);
        	
        	startActivity(i);
        }
        
		ContentResolver cr = getContentResolver();
		
		Cursor cur = cr.query(People.CONTENT_URI, 
				null, null, null, null);
		
	        if (cur.getCount() > 0) {
	        
	        contactsArr = new ArrayList<ContactData>();	
	        
		     while (cur.moveToNext()) {
		         String id = cur.getString(cur.getColumnIndex(People._ID));
		         String name = cur.getString(cur.getColumnIndex(People.DISPLAY_NAME));
		         System.out.println(id + name);
		         
		        String primaryPhoneId = cur.getString(
		                cur.getColumnIndex(People.PRIMARY_PHONE_ID));
		        
		        if(primaryPhoneId != null){
			     	if (Integer.parseInt(cur.getString(
			                cur.getColumnIndex(People.PRIMARY_PHONE_ID))) > 0) {
			    		Cursor pCur = cr.query(
			    				Contacts.Phones.CONTENT_URI, 
			    				null, 
			    				Contacts.Phones.PERSON_ID +" = ?", 
			    				new String[]{id}, null);
			    		int i=0;
			    		int pCount = pCur.getCount();
			    		String[] phoneNum = new String[pCount];
			    		String[] phoneType = new String[pCount];
			    		while (pCur.moveToNext()) {
			    			//TODO: needs to get only cell phone numbers
			    			phoneNum[i] = pCur.getString(
			                                   pCur.getColumnIndex(Contacts.Phones.NUMBER));
			    			phoneType[i] = pCur.getString(
			                                   pCur.getColumnIndex(Contacts.Phones.TYPE));
			    			
			    			i++;
			    		} 
			    		
			  			// Create contcat
			    		//TODO: for now the first phone number is taken
		    			newContact = new ContactData(phoneNum[i],name);
		    			
		    			// Adding new contact to contactsArr
		    			contactsArr.add(newContact);
			    	}
		        }

		     }
	        }
		     System.out.println("dudu");
        
    }
    
    // Create contact data
    public ContactData initContactData(String name, String phoneNumber){
    	
       ContactData contact = new ContactData(name,phoneNumber);
    	
       return contact;
 	
    }
}