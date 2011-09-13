package com.onoapps.BooYa;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.onoapps.BooYa.R;

import android.R.integer;
import android.R.string;
import android.app.Activity;
import android.app.ListActivity;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.provider.Contacts;
import android.provider.Contacts.People;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

public class RootActivity extends Activity {

	private ArrayList<ContactData> contactsArr;
	private ContactData newContact;
	private StringBuilder strBuilder;
	private ArrayList<String> phoneNumbersArr; 
	
	private Activity activity;
	
	private Button booYaListBtn;
	private Button booYaBoardBtn;
	private Button stuffBtn;
	private Button statsBtn;
	
	ContactsList myContacts;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
         
        activity = this;
        myContacts = (ContactsList)getApplication();
        
        //
        booYaListBtn = (Button)findViewById(R.id.button1);
        booYaBoardBtn = (Button)findViewById(R.id.booYaBoardBtn);
        stuffBtn = (Button)findViewById(R.id.stuffBtn);
        statsBtn = (Button)findViewById(R.id.statsBtn);
        
        booYaListBtn.setOnClickListener(myClickListener);
        booYaBoardBtn.setOnClickListener(myClickListener);
        stuffBtn.setOnClickListener(myClickListener);
        statsBtn.setOnClickListener(myClickListener);
               
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
	        strBuilder = new StringBuilder();
	        phoneNumbersArr = new ArrayList<String>();
	              
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
			    	    if(phoneNum[0] != null){
			    	    	// Adding new contact to contactsArr
			    			newContact = new ContactData(name,phoneNum[0]);
			    			contactsArr.add(newContact);
			    			
			    			//create the string to send to the server inorder to recieve BY status
			    			// Build an phone numbers array to post to the server
			    			phoneNumbersArr.add(phoneNum[0]);
			    			
			    	    }
			    	}
		        }
		     }
		     
		     // Build Json array of phone numbers to post the web server.
		     JSONArray jSonArr = new JSONArray(phoneNumbersArr);
     
				// Post to WebServer
				HttpClient client = new DefaultHttpClient();
				HttpPost post = new HttpPost(
						"http://booya.r4r.co.il/ajax.php");

					
				try {

					List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
					nameValuePairs.add(new BasicNameValuePair("funcName","checkEnrolled"));
					nameValuePairs.add(new BasicNameValuePair("list",jSonArr.toString()));
					
					post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
					
					HttpResponse response = client.execute(post);
					BufferedReader rd = new BufferedReader(new InputStreamReader(
							response.getEntity().getContent(),"UTF-8"));
								
					StringBuilder builder = new StringBuilder();
					for (String line = null; (line = rd.readLine()) != null;) {
					    builder.append(line).append("\n");
					}
																       
					JSONObject jObject = new JSONObject(builder.toString());
					JSONArray jArray = jObject.getJSONArray("data");
					
					JSONObject jObjContactData;
					
					for(int i = 0; i<jArray.length(); i++){
						
						jObjContactData = jArray.getJSONObject(i);										
						
						if(contactsArr.get(i).getPhone().equalsIgnoreCase(jObjContactData.get("phoneNum").toString())){
							// Set true or False if the user register to booya application.
							contactsArr.get(i).setUserName(jObjContactData.get("userName").toString());
							contactsArr.get(i).setIsBooYa((Boolean)jObjContactData.get("enrolled"));
						}
						else{
							
							Toast.makeText(this,"Web Server Error", Toast.LENGTH_LONG);
						}
					}
					
					// Set the global ContactList
					myContacts.setContacts(contactsArr);
					
//			        // Get the app's shared preferences
//			        SharedPreferences app_preferences = 
//			        	PreferenceManager.getDefaultSharedPreferences(activity);
					
			        // Set the "LOG_IN_FLAG" according to registration results
//			        SharedPreferences.Editor editor = app_preferences.edit();
//			        if((Boolean)jObject.get("success") == true){
//			        	editor.putBoolean("LOG_IN_FLAG", true);
//			        }else{
//			        	editor.putBoolean("LOG_IN_FLAG", false);
//			        }
//			        
//			        editor.commit(); // Very important
											
				} catch (IOException e) {
					e.printStackTrace();
				} catch (JSONException e1){
					e1.printStackTrace();
				}		     
	        }
	                    
    }
    
    // Create contact data
    public ContactData initContactData(String name, String phoneNumber){
    	
       ContactData contact = new ContactData(name,phoneNumber);
    	
       return contact;
 	
    }
   
    private OnClickListener myClickListener = new OnClickListener() {
		
    	Intent i;
    	
		@Override
		public void onClick(View v) {
			
			switch (v.getId()) {
			
			case R.id.booYaBoardBtn:
				i = new Intent(activity, BooYaBoardActivity.class);
				break;
			case R.id.stuffBtn:
				i = new Intent(activity, StuffActivity.class);
				break;
			case R.id.statsBtn:
				i = new Intent(activity, StatsActivity.class);
				break;
			case R.id.button1:
				i = new Intent(activity, BooYaListActivity.class);
				break;
			default:
				break;
			}
			
			activity.startActivity(i);		
		}
	};
    
}