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
import org.json.JSONException;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

public class BooYaListActivity extends ListActivity {

	 private ContactsList myContacts;
	 private BooYaListAdapter adapter;
	 
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
		ContactData contactData = (ContactData)adapter.getItem(position);
		
		// Send BooYa To Contact or Invite if 
		if(contactData.getIsBooYa()){
			
			//TODO: get the my phone number and my user name from shared pref
			sendPushToContact("0505460243",contactData.getPhone(), "");

		}else{
			
			//TODO:invite to BooYa
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
