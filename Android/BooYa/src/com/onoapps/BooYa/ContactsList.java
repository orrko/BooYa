package com.onoapps.BooYa;
import java.util.ArrayList;

import android.app.Application;


public class ContactsList extends Application {

	private ArrayList<ContactData> contacts ;  
	
	// Set Methods
	public void setContacts(ArrayList<ContactData> dataArr){
		this.contacts =  dataArr;
	}
	
	// Get Methods
	public ArrayList<ContactData> getContacts(){
		return this.contacts;
	}
	
}
