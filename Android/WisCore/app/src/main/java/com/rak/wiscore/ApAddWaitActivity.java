package com.rak.wiscore;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.component.ApConfig;
import com.rak.wiscore.component.DeviceEntity;
import com.rak.wiscore.component.MainMenuButton;
import com.rak.wiscore.component.MyEditText;
import com.rak.wiscore.component.NetworkUtil;
import com.rak.wiscore.component.Scanner;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class ApAddWaitActivity extends AppCompatActivity {
	public static ApAddWaitActivity _apAddWaitActivity;
	private MainMenuButton _apAddWaitBack;
	private ProgressBar _apAddWaitProgressBar;
	private TextView _apAddWaitValueText;
	private Scanner _scanner;
	private ApConfig _apconfig;
	private String _deviceIp;
	private String _devicePassword="admin";
	private String _deviceId;
	private String _deviceSsid;
	private String _devicePsk;
	private boolean _isExit=false;
	private boolean _isReset=false;
	private boolean _isConfigured=false;
	private Timer _timer=null;
	private TimerTask _timerTask =null;
	private int count=0;
	private Handler handler=new Handler();

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ap_add_wait);
		_apAddWaitActivity=this;

		_isExit=false;
		_isReset=false;
		_deviceSsid=getIntent().getStringExtra("ssid");
		_devicePsk=getIntent().getStringExtra("psk");
		_deviceId=getIntent().getStringExtra("id");
		if (_deviceSsid.equals("")){
			_isConfigured=true;
		}
		else{
			_isConfigured=false;
		}

		_apAddWaitBack=(MainMenuButton) findViewById(R.id.ap_add_wait_back_btn);
		_apAddWaitBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				CloseActivity();
			}
		});
		_apAddWaitProgressBar=(ProgressBar)findViewById(R.id.ap_add_wait_progress);
		_apAddWaitValueText=(TextView)findViewById(R.id.ap_add_wait_value);

		if (_timer==null){
			_timer=new Timer();
			//1s定时
			_timerTask = new TimerTask()
			{
				@Override
				public void run()
				{
				if (count<100){
					if(_isReset){
						String _ssid = NetworkUtil.getSsid(_apAddWaitActivity);
						if (_ssid==null)
							return;
						Log.e("_ssid2==>",_ssid);
						if (_ssid.equals(_deviceSsid)){
							_isReset=false;
							if (_isExit)
								return;
							try {
								Thread.sleep(2000);
							} catch (InterruptedException e) {
								e.printStackTrace();
							}
							scanDevice();
						}
					}
					count++;
					_apAddWaitProgressBar.setProgress(count);
					runOnUiThread(new Runnable() {
						@Override
						public void run() {
							_apAddWaitValueText.setText(count+"%");
						}
					});
				}
				else{
					_isExit=true;
					if(_timer!=null)
					{
						_timer.cancel();//关闭定时器
						_timer=null;
						_timerTask.cancel();//关闭定时器
						_timerTask=null;
					}
					Intent intent=new Intent();
					intent.putExtra("result",false);
					intent.putExtra("id",_deviceId);
					intent.putExtra("ssid",_deviceSsid);
					intent.setClass(ApAddWaitActivity.this,ApAddEndActivity.class);
					startActivity(intent);
					finish();
				}
				}
			};
			_timer.schedule(_timerTask, 0, 600);//每0.6s发送一次扫描
		}
		scanDevice();
	}

	private void scanDevice(){
		_scanner = new Scanner(this);
		_scanner.setOnScanOverListener(new com.rak.wiscore.component.Scanner.OnScanOverListener() {
			@Override
			public void onResult(Map<InetAddress, String> data, InetAddress gatewayAddress) {
				Log.e("==>","ScanOver");
				if (data != null) {//扫描到的设备
					for (Map.Entry<InetAddress, String> entry : data.entrySet()) {
						if (_isConfigured){
							String id = entry.getValue();
							String ip = entry.getKey().getHostAddress();
							String name =DeviceEntity.getDeviceNameFromId(_apAddWaitActivity,id);
							if (id.equals(_deviceId)){
								_isExit=true;
								if(_timer!=null)
								{
									_timer.cancel();//关闭定时器
									_timer=null;
									_timerTask.cancel();//关闭定时器
									_timerTask=null;
								}
								DeviceEntity.saveDevicesById(_apAddWaitActivity, id, name, ip);
								Intent intent=new Intent();
								intent.putExtra("result",true);
								intent.putExtra("id",id);
								intent.putExtra("ssid",_deviceSsid);
								intent.setClass(ApAddWaitActivity.this,ApAddEndActivity.class);
								startActivity(intent);
								finish();
								break;
							}
						}
						else{
							_deviceId = entry.getValue();
							_deviceIp = entry.getKey().getHostAddress();
							Log.e("id=", _deviceId);
							Log.e("ip=", _deviceIp);
							_apconfig=new ApConfig(_deviceIp,_devicePassword);
							_apconfig.setOnResultListener(new ApConfig.OnResultListener() {
								@Override
								public void onResult(ApConfig.Response result) {
									if (result.type==ApConfig.CONFIGURE_DEVICE_TO_NETWORK){
										if (result.statusCode==200){
											_apconfig.resetNet();
										}
										else{
											Toast.makeText(_apAddWaitActivity,getString(R.string.main_config_ssid_timeout),Toast.LENGTH_SHORT).show();
										}
									}
									else if (result.type==ApConfig.RESET_NET){
										if (result.statusCode==200){
											_isConfigured=true;
											_isReset=true;
										}
										else{
											Toast.makeText(_apAddWaitActivity,getString(R.string.main_config_reset_failed),Toast.LENGTH_SHORT).show();
										}
									}
								}
							});
							_apconfig.configureDeviceToNetwork(_deviceSsid,_devicePsk);
						}
					}
					if (_isConfigured){//未扫描到已配置的模块，继续扫描
						if (_isExit)
							return;
						handler.post(_scanRunnable);
					}
				}
				else{
					if (_isExit)//未扫描到模块，继续扫描
						return;
					handler.post(_scanRunnable);
				}
			}
		});
		_scanner.scanAll();
	}

	Runnable _scanRunnable=new Runnable() {
		@Override
		public void run() {
			_scanner.scanAll();
		}
	};



	/**
	 * Close
	 */
	private void CloseActivity(){
		_isExit=true;
		if(_timer!=null)
		{
			_timer.cancel();//关闭定时器
			_timer=null;
			_timerTask.cancel();//关闭定时器
			_timerTask=null;
		}
		if(ApAddStep3Activity._apAddStep3Activity!=null)
			ApAddStep3Activity._apAddStep3Activity.finish();
		if(ApAddStep2Activity._apAddStep2Activity!=null)
			ApAddStep2Activity._apAddStep2Activity.finish();
		if(ApAddStep1Activity._apAddStep1Activity!=null)
			ApAddStep1Activity._apAddStep1Activity.finish();
		finish();
	}

	@Override
	public void onBackPressed() {
		CloseActivity();
	}
}
