package com.rak.wiscore;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.component.ApConfig;
import com.rak.wiscore.component.Loading;
import com.rak.wiscore.component.MainMenuButton;

public class DeviceNetworkActivity extends AppCompatActivity {
	public static DeviceNetworkActivity _deviceNetworkActivity;
	private TextView _deviceNetworkSsid;
	private TextView _deviceNetworkMac;
	private TextView _deviceNetworkIp;
	private TextView _deviceNetworkMask;
	private TextView _deviceNetworkGateway;
	private MainMenuButton  _deviceNetworkBack;
	private String name;
	private String ip;
	private Loading _networkLoad;
	private ApConfig _NetworkInfoAPConfig;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_device_network);

		_deviceNetworkActivity=this;
		_deviceNetworkBack=(MainMenuButton) findViewById(R.id.device_network_back_btn);
		_deviceNetworkBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_deviceNetworkSsid=(TextView)findViewById(R.id.device_network_ssid);
		_deviceNetworkMac=(TextView)findViewById(R.id.device_network_mac);
		_deviceNetworkIp=(TextView)findViewById(R.id.device_network_ip);
		_deviceNetworkMask=(TextView)findViewById(R.id.device_network_mask);
		_deviceNetworkGateway=(TextView)findViewById(R.id.device_network_gateway);

		name=getIntent().getStringExtra("name");
		ip=getIntent().getStringExtra("ip");
		_networkLoad=(Loading)findViewById(R.id.network_loading);
		_networkLoad.setText(getResources().getString(R.string.main_get_network_info_text));
		_networkLoad.setVisibility(View.GONE);
		_NetworkInfoAPConfig=new ApConfig(ip,"admin");
		_NetworkInfoAPConfig.setOnResultListener(new ApConfig.OnResultListener() {
			@Override
			public void onResult(final ApConfig.Response result) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						_networkLoad.setVisibility(View.GONE);
						if (result.type==ApConfig.GET_WIFI_STATUS){
							if (result.statusCode==200){
								if(_NetworkInfoAPConfig.findString(result.body,"\"ap_ssid\":\"","\"").equals("")==false){
									_deviceNetworkSsid.setText(_NetworkInfoAPConfig.findString(result.body,"\"ap_ssid\":\"","\""));
									_deviceNetworkMac.setText(_NetworkInfoAPConfig.findString(result.body,"\"ap_bssid\":\"","\""));
									_deviceNetworkIp.setText(_NetworkInfoAPConfig.findString(result.body,"\"ap_addr\":\"","\""));
									_deviceNetworkMask.setText(_NetworkInfoAPConfig.findString(result.body,"\"ap_mask\":\"","\""));
									_deviceNetworkGateway.setText(_NetworkInfoAPConfig.findString(result.body,"\"ap_gateway\":\"","\""));
								}
								else{
									_deviceNetworkSsid.setText(_NetworkInfoAPConfig.findString(result.body,"\"sta_ssid\":\"","\""));
									_deviceNetworkMac.setText(_NetworkInfoAPConfig.findString(result.body,"\"sta_bssid\":\"","\""));
									_deviceNetworkIp.setText(_NetworkInfoAPConfig.findString(result.body,"\"sta_addr\":\"","\""));
									_deviceNetworkMask.setText(_NetworkInfoAPConfig.findString(result.body,"\"sta_mask\":\"","\""));
									_deviceNetworkGateway.setText(_NetworkInfoAPConfig.findString(result.body,"\"sta_gateway\":\"","\""));
								}
							}
							else{
								Toast.makeText(_deviceNetworkActivity,getString(R.string.main_get_network_info_failed),Toast.LENGTH_SHORT).show();
							}
						}
					}
				});
			}
		});
		_networkLoad.setVisibility(View.VISIBLE);
		_NetworkInfoAPConfig.getWifiStatus();
	}
}
