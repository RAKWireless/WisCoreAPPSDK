package com.rak.wiscore;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.rak.wiscore.component.MainMenuButton;

public class DeviceViewActivity extends AppCompatActivity {
	public static DeviceViewActivity _deviceViewActivity;
	private TextView _deviceViewTitle;
	private MainMenuButton _deviceViewBack;
	private LinearLayout _deviceViewInfo;
	private LinearLayout _deviceViewNetwork;
	private LinearLayout _deviceViewAlexa;
	private String name;
	private String ip;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_device_view);

		_deviceViewActivity=this;
		_deviceViewBack=(MainMenuButton) findViewById(R.id.device_view_back_btn);
		_deviceViewBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_deviceViewTitle=(TextView)findViewById(R.id.device_view_title);
		name=getIntent().getStringExtra("name");
		ip=getIntent().getStringExtra("ip");
		_deviceViewTitle.setText(name);
		_deviceViewInfo=(LinearLayout)findViewById(R.id.device_view_info);
		_deviceViewInfo.setOnClickListener(new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			Intent intent=new Intent();
			intent.putExtra("name",name);
			intent.putExtra("ip",ip);
			intent.setClass(DeviceViewActivity.this,DeviceInformationActivity.class);
			startActivity(intent);
		}
	});
		_deviceViewNetwork=(LinearLayout)findViewById(R.id.device_view_network);
		_deviceViewNetwork.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent=new Intent();
				intent.putExtra("name",name);
				intent.putExtra("ip",ip);
				intent.setClass(DeviceViewActivity.this,DeviceNetworkActivity.class);
				startActivity(intent);
			}
		});
		_deviceViewAlexa=(LinearLayout)findViewById(R.id.device_view_alexa);
		_deviceViewAlexa.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent=new Intent();
				intent.putExtra("ip",ip);
				intent.setClass(DeviceViewActivity.this,DeviceSignInActivity.class);
				startActivity(intent);
			}
		});
	}
}
