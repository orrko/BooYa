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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class StuffActivity extends Activity {

	private  String phoneNumber;
	private SharedPreferences app_preferences;
	private Intent i;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.stuff);
		
		Button deActivateBtn = (Button)findViewById(R.id.deActivateBtn);
		
		i = new Intent(this,RegisterActivity.class);
		
        // Get the app's shared preferences
        app_preferences = PreferenceManager.getDefaultSharedPreferences(this);	
			
	    // Get the value for the my user name from SharedPreferences
        phoneNumber = app_preferences.getString("kPhonenumber", null);	
		
		deActivateBtn.setOnClickListener(new View.OnClickListener() {
		  
			
			@Override
			public void onClick(View v) {
							
				// Post to WebServer
				HttpClient client = new DefaultHttpClient();
				HttpPost post = new HttpPost(
						"http://booya.r4r.co.il/ajax.php");
							
				try {

					List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
					nameValuePairs.add(new BasicNameValuePair("funcName","unRegistration"));
					nameValuePairs.add(new BasicNameValuePair("phoneNumber",phoneNumber));
					
					post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
					
					HttpResponse response = client.execute(post);
					BufferedReader rd = new BufferedReader(new InputStreamReader(
							response.getEntity().getContent(),"UTF-8"));
								
					StringBuilder builder = new StringBuilder();
					for (String line = null; (line = rd.readLine()) != null;) {
					    builder.append(line).append("\n");
					}
																       
					JSONObject jObject = new JSONObject(builder.toString());
					
					if(jObject.get("result").toString().equalsIgnoreCase("done")){
						
						// Save the phoneNumbersArr to SharedPreferences and send it to RegisteryActivity (to post it)		                
						SharedPreferences.Editor editor = app_preferences.edit();
						editor.putBoolean("LOG_IN_FLAG", false);
						
						editor.commit(); // Very important
						
    		        	startActivity(i);
    		        	
    		        	finish();
						
					}
					else{
						
						//TODO: show a message to user for not logged out
						
					}
					
					
//					for(int i = 0; i<jArray.length(); i++){
//						
//						jObjContactData = jArray.getJSONObject(i);										
//						
//						if(contactsArr.get(i).getPhone().equalsIgnoreCase(jObjContactData.get("phoneNum").toString())){
//							// Set true or False if the user register to booya application.
//							contactsArr.get(i).setUserName(jObjContactData.get("userName").toString());
//							contactsArr.get(i).setIsBooYa((Boolean)jObjContactData.get("enrolled"));
//							contactsArr.get(i).setRank(jObjContactData.get("rank").toString());
//						}
//						else{
//							
//							Toast.makeText(this,"Web Server Error", Toast.LENGTH_LONG);
//						}
//					}
					
					
																
				} catch (IOException e) {
					e.printStackTrace();
				} catch (JSONException e1){
					e1.printStackTrace();
				}		     
	        }
				
		});
	}

	
	
}
