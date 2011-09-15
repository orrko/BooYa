package com.onoapps.BooYa;

import android.R.integer;

public class ContactData {

	private String fName;
	private String lName;
	private String userName;
	private String phone;
	private Boolean isBooYa;
	private int score;
	private String rank;
	
	public ContactData(String name, String phoneNumber){
		this.fName = name;
		this.phone = phoneNumber;
	}

	public void setUserName(String _userName) {	
		 this.userName =  _userName;
	}
	
	public void setFName(String _FName) {	
		 this.fName =  _FName;
	}
	
	public void setLName(String _LName) {	
		 this.lName =  _LName;
	}
	
	public void setPhone(String _phone) {
		 this.phone = _phone;
	}
	
	public void setRank(String _rank) {
		 this.rank = _rank;
	}
	
	public void setIsBooYa(Boolean _isBooYa) {
		 this.isBooYa = _isBooYa;
	}
	
	public void setScore(int _score) {	
		 this.score =  _score;
	}
	
	
	public String getUserName() {	
		return this.userName;
	}
	
	public String getRank() {	
		return this.rank;
	}
	
	public String getFName() {	
		return this.fName;
	}
	
	public String getLName() {	
		return this.lName;
	}
	
	public String getPhone() {
		return this.phone;
	}
	
	public Boolean getIsBooYa() {
		return this.isBooYa;
	}
	
	public int getScore() {	
		 return this.score;
	}
	
	
}
