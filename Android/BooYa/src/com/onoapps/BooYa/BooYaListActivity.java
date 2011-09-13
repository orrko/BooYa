package com.onoapps.BooYa;


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
		
		
		adapter = new BooYaListAdapter(this, R.layout.list_view_row,myContacts.getContacts());
                setListAdapter(this.adapter);		
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		// TODO Auto-generated method stub
		System.out.println("dudu");
		
	}

	private void sendPushToContact(){
		
		
		
		
	}
	
	
}
