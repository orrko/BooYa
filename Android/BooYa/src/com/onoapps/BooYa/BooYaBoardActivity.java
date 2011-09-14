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

import android.R.integer;
import android.app.ListActivity;
import android.os.Bundle;

public class BooYaBoardActivity extends ListActivity {
	
	private ArrayList<ContactData> _leaderBoardUsers;
	private BooYaBoardAdapter _adapter;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.booyaboard);
		
		//init the array list
		_leaderBoardUsers = new ArrayList<ContactData>();
		
		//get the leaderboard from server
		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(
				"http://booya.r4r.co.il/ajax.php");

			
		try {

			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
			nameValuePairs.add(new BasicNameValuePair("funcName","getLeaderBoard"));
			
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
			
			JSONObject JSONuser;
			
			for (int i = 0; i < jArray.length(); i++) {
				JSONuser = jArray.getJSONObject(i);
				String name = JSONuser.get("userName").toString();
				String score = JSONuser.get("score").toString();
				String phoneNumber = JSONuser.get("phoneNumOrg").toString();
				ContactData contactData = new ContactData(name,phoneNumber);
				contactData.setUserName(name);
				if (score != null) {
					contactData.setScore(Integer.parseInt(score));
				}
				
				_leaderBoardUsers.add(contactData);
				
			}
			
		
		
		//_contactList = (ContactsList)getApplication();
		
		
		this._adapter = new BooYaBoardAdapter(this, R.layout.board_list_row,_leaderBoardUsers);
         setListAdapter(this._adapter);
			
		} catch (IOException e) {
			e.printStackTrace();
			System.out.print("orr1");
		} catch (JSONException e1){
			e1.printStackTrace();
			System.out.print("orr2");
		}	
		
	}

}
