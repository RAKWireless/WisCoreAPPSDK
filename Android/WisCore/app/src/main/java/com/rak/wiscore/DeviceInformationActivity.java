package com.rak.wiscore;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.component.ApConfig;
import com.rak.wiscore.component.Loading;
import com.rak.wiscore.component.MainMenuButton;

public class DeviceInformationActivity extends AppCompatActivity {
	public static DeviceInformationActivity _deviceInformationActivity;
	private TextView _deviceInformationName;
	private TextView _deviceInformationSN;
	private TextView _deviceInformationFW;
	private MainMenuButton _deviceInformationBack;
	private ApConfig _DeviceInfoAPConfig;
	private String name;
	private String ip;
	private Loading _infoLoad;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_device_information);

		_deviceInformationActivity=this;
		_deviceInformationBack=(MainMenuButton) findViewById(R.id.device_information_back_btn);
		_deviceInformationBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_deviceInformationName=(TextView)findViewById(R.id.device_information_name);
		name=getIntent().getStringExtra("name");
		ip=getIntent().getStringExtra("ip");
		_deviceInformationName.setText(name);
		_deviceInformationSN=(TextView)findViewById(R.id.device_information_sn);
		_deviceInformationFW=(TextView)findViewById(R.id.device_information_fw);
		_infoLoad=(Loading)findViewById(R.id.info_loading);
		_infoLoad.setText(getResources().getString(R.string.main_get_device_info_text));
		_infoLoad.setVisibility(View.GONE);
		_DeviceInfoAPConfig=new ApConfig(ip,"admin");
		_DeviceInfoAPConfig.setOnResultListener(new ApConfig.OnResultListener() {
			@Override
			public void onResult(final ApConfig.Response result) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						_infoLoad.setVisibility(View.GONE);
						if (result.type==ApConfig.GET_VERSION_FORM_DEVICE){
							if (result.statusCode==200){
								_deviceInformationFW.setText(result.body);
							}
							else{
								Toast.makeText(_deviceInformationActivity,getString(R.string.main_get_device_info_failed),Toast.LENGTH_SHORT).show();
							}
						}
					}
				});
			}
		});
		_infoLoad.setVisibility(View.VISIBLE);
		_DeviceInfoAPConfig.getVersion();
	}
}
