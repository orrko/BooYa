package com.onoapps.BooYa;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.telephony.SmsManager;
import android.view.View;
import android.widget.ListView;

public class BooYaListActivity extends ListActivity {

	 private ContactsList myContacts;
	 private BooYaListAdapter adapter;
	 private ContactData contactData;
	 
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.booyalist);
				
		myContacts = (ContactsList)getApplication();
			
		adapter = new BooYaListAdapter(this, R.layout.list_view_row, myContacts.getContacts());
                setListAdapter(this.adapter);		
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		
		// Get the selected contact from the list
		contactData = (ContactData)adapter.getItem(position);
		
		// Send BooYa To Contact or Invite if 
		if(contactData.getIsBooYa()){
			
	        SharedPreferences app_preferences = 
	        	PreferenceManager.getDefaultSharedPreferences(this);
	        
	        // Get the value for the my user name from SharedPreferences
	        String phoneNumber = app_preferences.getString("kPhonenumber", null);
	        
	        sendPushToContact(phoneNumber,contactData.getPhone(), "");
	        
		}else{
			
			// Show alert dialog to user if he wants to send an sms text message
			DialogInterface.OnClickListener dialogClickListener = new DialogInterface.OnClickListener() {
			    @Override
			    public void onClick(DialogInterface dialog, int which) {
			        switch (which){
			        case DialogInterface.BUTTON_POSITIVE:
			            //Yes button clicked -> Send the invite sms
			        	SmsManager sm = SmsManager.getDefault();
						 
						sm.sendTextMessage(contactData.getPhone() , null, "Hi" + contactData.getFName()
								+ ", have you ever heard someone saying \"I'm having too much fun\"? + "
								+  "BooYA! is one FUN-tastic app: www..." , null, null); 
			            break;

			        case DialogInterface.BUTTON_NEGATIVE:
			            //No button clicked -> Do nothing
			            break;
			        }
			    }
			};

			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			
			builder.setMessage("Are you sure you want to send an invite SMS?")
				.setPositiveButton("Yes", dialogClickListener)
			    .setNegativeButton("No", dialogClickListener).show();
		
		}		
	}

	// if it's a new request reply will be empty
	private void sendPushToContact(String srcPhoneNumber, String targetPhoneNumber, String reply){
		
		// Post to WebServer
		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(
				"http://booya.r4r.co.il/ajax.php");
		
		try {

			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(6);
			nameValuePairs.add(new BasicNameValuePair("funcName","sendBooYaMessage"));
			nameValuePairs.add(new BasicNameValuePair("idTypeSrc","phoneNumber"));
			nameValuePairs.add(new BasicNameValuePair("idStrSrc",srcPhoneNumber));
			nameValuePairs.add(new BasicNameValuePair("idTypeTarget","phoneNumber"));
			nameValuePairs.add(new BasicNameValuePair("idStrTarget",targetPhoneNumber));
			nameValuePairs.add(new BasicNameValuePair("booYaId",reply));
						
			post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			
			HttpResponse response = client.execute(post);
			BufferedReader rd = new BufferedReader(new InputStreamReader(
					response.getEntity().getContent(),"UTF-8"));
						
			StringBuilder builder = new StringBuilder();
			for (String line = null; (line = rd.readLine()) != null;) {
			    builder.append(line).append("\n");
			}		
		} catch (IOException e) {
			e.printStackTrace();
		}		      	
	}	
}
