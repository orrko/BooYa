package com.onoapps.BooYa;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

public class BooYaListAdapter extends ArrayAdapter<ContactData> {

    private ArrayList<ContactData> items;
    private Context context;
    
    public BooYaListAdapter(Context context, int textViewResourceId, ArrayList<ContactData> items) {
            super(context, textViewResourceId, items);
            this.items = items;
            this.context = context;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
    	
            View v = convertView;
            
            if (v == null) {
                LayoutInflater vi = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                v = vi.inflate(R.layout.list_view_row, null);
            }
            
            ContactData o = items.get(position);
            
            if (o != null) {
                    TextView tt = (TextView) v.findViewById(R.id.name);
                    ImageView bt = (ImageView) v.findViewById(R.id.imageButton1);
                    
                    if (tt != null) {
                          tt.setText(o.getFName()+ o.getIsBooYa().toString());                            }
                    
                	if(o.getIsBooYa()){
                		bt.setVisibility(View.VISIBLE);
                	}else{
                		bt.setVisibility(View.INVISIBLE);
                	}
                 
            }
            return v;
    }
	
}
