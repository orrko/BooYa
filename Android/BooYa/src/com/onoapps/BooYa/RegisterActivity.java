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
import org.json.JSONTokener;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;

public class RegisterActivity extends Activity {

	private EditText userName;
	private EditText phoneNumber;
	private ImageButton registerBtn;
	
	private Activity activity;
	
	private String c2dmRegId;
	private String phoneNumbersArr;
	
	private static String C2DM_EMAIL_ACCOUNT = "onoappsbooya@gmail.com";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		activity = this;
		setContentView(R.layout.register);
				
		userName = (EditText)findViewById(R.id.userName);
		phoneNumber = (EditText)findViewById(R.id.phoneNumber);
		registerBtn = (ImageButton)findViewById(R.id.registerBtn);
		
		// TODO: When pressing back button get out from application and not go back to RootActivity
		
		// Register to C2DM service
		C2DMessaging.register(this, C2DM_EMAIL_ACCOUNT);
		
		registerBtn.setOnClickListener(new View.OnClickListener() {
				
	        // Get the app's shared preferences
	        SharedPreferences app_preferences = //getSharedPreferences("BooYa", MODE_PRIVATE);
	        	PreferenceManager.getDefaultSharedPreferences(activity);
			
			@Override
			public void onClick(View v) {
				//inputs: user name, phone number by the user
				if(userName.getText().equals("")){
					Toast.makeText(activity,"Please fill user name", Toast.LENGTH_LONG).show();
				}
				else if(phoneNumber.getText().equals("")){
					Toast.makeText(activity,"Please fill phone number", Toast.LENGTH_LONG).show();
				}
				else {
									
					// Get the RegisterId from SharedPreferences
					c2dmRegId = app_preferences.getString("C2DMRegId", "No C2DM RegId Yet");
					
					// Get my phone numbers array from SharedPreferences
					phoneNumbersArr = app_preferences.getString("PhoneNumbersArr","Empty Contact List");
					
					// Post to WebServer
					HttpClient client = new DefaultHttpClient();
					HttpPost post = new HttpPost(
							"http://booya.r4r.co.il/ajax.php");

					try {
						
						List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
						nameValuePairs.add(new BasicNameValuePair("funcName","androidRegistration"));
						nameValuePairs.add(new BasicNameValuePair("userName",userName.getText().toString()));
						nameValuePairs.add(new BasicNameValuePair("phoneNumber",phoneNumber.getText().toString()));
						nameValuePairs.add(new BasicNameValuePair("registrationId",c2dmRegId));
						nameValuePairs.add(new BasicNameValuePair("list",phoneNumbersArr));
				
						post.setEntity(new UrlEncodedFormEntity(nameValuePairs));

						HttpResponse response = client.execute(post);
						BufferedReader rd = new BufferedReader(new InputStreamReader(
								response.getEntity().getContent(),"UTF-8"));
									
						StringBuilder builder = new StringBuilder();
						for (String line = null; (line = rd.readLine()) != null;) {
						    builder.append(line).append("\n");
						}
									
						JSONObject jObject = new JSONObject(builder.toString());
													
				        // Set the "LOG_IN_FLAG" according to registration results
				        SharedPreferences.Editor editor = app_preferences.edit();
				        if((Boolean)jObject.get("success") == true){
				        	editor.putBoolean("LOG_IN_FLAG", true);
				        	editor.putString("kUserName", userName.getText().toString());
				        	editor.putString("kPhonenumber", phoneNumber.getText().toString());
				        }else{
				        	editor.putBoolean("LOG_IN_FLAG", false);
				        }
				        
				        editor.commit(); // Very important
						
				        if((Boolean)jObject.get("success") == true){
				        	activity.finish();
				        }
				        else{
				        	Toast.makeText(activity, "Registration Failed: " + jObject.get("message"), Toast.LENGTH_LONG).show();
				        }
				        
					} catch (IOException e) {
						e.printStackTrace();
					} catch (JSONException e1){
						e1.printStackTrace();
					}				
				}			
			}
		});
	}
}
