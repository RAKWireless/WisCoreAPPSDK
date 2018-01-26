package com.rak.wiscore;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.amazon.identity.auth.device.AuthError;
import com.amazon.identity.auth.device.api.authorization.AuthCancellation;
import com.amazon.identity.auth.device.api.authorization.AuthorizationManager;
import com.amazon.identity.auth.device.api.authorization.AuthorizeListener;
import com.amazon.identity.auth.device.api.authorization.AuthorizeRequest;
import com.amazon.identity.auth.device.api.authorization.AuthorizeResult;
import com.amazon.identity.auth.device.api.authorization.ScopeFactory;
import com.amazon.identity.auth.device.api.workflow.RequestContext;
import com.rak.wiscore.component.ApConfig;
import com.rak.wiscore.component.Loading;
import com.rak.wiscore.component.MainMenuButton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

public class DeviceSignInActivity extends AppCompatActivity {
	public static DeviceSignInActivity _deviceSignInActivity;
	private MainMenuButton  _deviceSignInBack;
	private Button _deviceSignInBtn;
	private String ip;
	private Loading _signInLoad;
	private ApConfig _signInAPConfig;

	private String PRODUCT_ID;
	private String PRODUCT_DSN;
	private String CODE_CHALLENGE;
	private String CODE_CHALLENGE_METHOD;

	private RequestContext mRequestContext;

	private String authorizationCode;
	private String redirectUri;
	private String clientId;
	private Timer timer = null;
	private TimerTask task;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		mRequestContext = RequestContext.create(this);
		mRequestContext.registerListener(new AuthorizeListenerImpl());
		setContentView(R.layout.activity_device_alexa_sign_in);

		_deviceSignInActivity=this;
		_deviceSignInBack=(MainMenuButton) findViewById(R.id.alexa_sign_in_back_btn);
		_deviceSignInBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_deviceSignInBtn=(Button)findViewById(R.id.alexa_sign_in_btn);
		_deviceSignInBtn.setOnClickListener(_deviceSignInBtnClick);

		ip=getIntent().getStringExtra("ip");
		_signInLoad=(Loading)findViewById(R.id.sign_in_loading);
		_signInLoad.setText(getResources().getString(R.string.main_login_step1_check_text));
		_signInLoad.setVisibility(View.GONE);
		_signInAPConfig=new ApConfig(ip,"admin");
		_signInAPConfig.setOnResultListener(new ApConfig.OnResultListener() {
			@Override
			public void onResult(final ApConfig.Response result) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						if (result.type==ApConfig.Alexa_Request_Login){
							if (result.statusCode==200){
								_signInLoad.setText(getResources().getString(R.string.main_login_step1_send_text));
								PRODUCT_ID=_signInAPConfig.findString(result.body,"\"product_id\":\"","\"");
								PRODUCT_DSN=_signInAPConfig.findString(result.body,"\"product_dsn\":\"","\"");
								CODE_CHALLENGE=_signInAPConfig.findString(result.body,"\"codechallenge\":\"","\"");
								CODE_CHALLENGE_METHOD=_signInAPConfig.findString(result.body,"\"codechallengemethod\":\"","\"");
								Log.e("kProduct_id==>",PRODUCT_ID);
								Log.e("kProduct_dsn==>",PRODUCT_DSN);
								Log.e("kCodeChallenge==>",CODE_CHALLENGE);
								Log.e("kCodeChallengeMethod==>",CODE_CHALLENGE_METHOD);

								final JSONObject scopeData = new JSONObject();
								final JSONObject productInstanceAttributes = new JSONObject();

								try {
									productInstanceAttributes.put("deviceSerialNumber", PRODUCT_DSN);
									scopeData.put("productInstanceAttributes", productInstanceAttributes);
									scopeData.put("productID", PRODUCT_ID);

									AuthorizationManager.authorize(new AuthorizeRequest.Builder(mRequestContext)
											.addScope(ScopeFactory.scopeNamed("alexa:all", scopeData))
											.forGrantType(AuthorizeRequest.GrantType.AUTHORIZATION_CODE)
											.withProofKeyParameters(CODE_CHALLENGE, CODE_CHALLENGE_METHOD)
											.build());
								} catch (JSONException e) {
									// handle exception here
								}
							}
							else{
								if(timer!=null)
								{
									timer.cancel();//关闭定时器
									timer=null;
									task.cancel();//关闭定时器
									task=null;
								}
								_signInLoad.setVisibility(View.GONE);
								Toast.makeText(_deviceSignInActivity,getString(R.string.main_login_step1_check_failed),Toast.LENGTH_SHORT).show();
							}
						}
						else if(result.type==ApConfig.Alexa_Response_Login){
							if (result.statusCode==200) {
								if(timer!=null)
								{
									timer.cancel();//关闭定时器
									timer=null;
									task.cancel();//关闭定时器
									task=null;
								}
								if(result.body.equals("{\"value\": \"0\"}")) {
									_signInLoad.setVisibility(View.GONE);
									Intent intent = new Intent();
									intent.putExtra("ip",ip);
									intent.setClass(DeviceSignInActivity.this, DeviceSignOutActivity.class);
									startActivity(intent);
								}
								else {
									_signInLoad.setVisibility(View.GONE);
									Toast.makeText(_deviceSignInActivity,getString(R.string.main_login_step1_send_failed),Toast.LENGTH_SHORT).show();
								}
							}
							else{
								if(timer!=null)
								{
									timer.cancel();//关闭定时器
									timer=null;
									task.cancel();//关闭定时器
									task=null;
								}
								_signInLoad.setVisibility(View.GONE);
								Toast.makeText(_deviceSignInActivity,getString(R.string.main_login_step1_send_failed),Toast.LENGTH_SHORT).show();
							}
						}
					}
				});
			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();
		mRequestContext.onResume();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	@Override
	public void onBackPressed() {
		if(timer!=null)
		{
			timer.cancel();//关闭定时器
			timer=null;
			task.cancel();//关闭定时器
			task=null;
		}
		finish();
	}

	/**
	 * Sign in
	 */
	View.OnClickListener _deviceSignInBtnClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			SetTimer(50000);
			_signInLoad.setVisibility(View.VISIBLE);
			_signInAPConfig.alexaRequestLogin();
		}
	};

	boolean isFirst=true;
	private void SetTimer(int timeout){
		isFirst=true;
		if(timer!=null)
		{
			timer.cancel();//关闭定时器
			timer=null;
			task.cancel();//关闭定时器
			task=null;
		}
		timer = new Timer();//初始化定时器
		task = new TimerTask()
		{
			@Override
			public void run()
			{
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						if (isFirst) {
							isFirst = false;
							return;
						}
						_signInLoad.setVisibility(View.GONE);
					}
				});
			}
		};
		timer.schedule(task, 0, timeout);//超时
	}
	private class AuthorizeListenerImpl extends AuthorizeListener {

		/* Authorization was completed successfully. */
		@Override
		public void onSuccess(final AuthorizeResult authorizeResult) {
			authorizationCode = authorizeResult.getAuthorizationCode();
			redirectUri = authorizeResult.getRedirectURI();
			clientId = authorizeResult.getClientId();
			Log.e("authorizationCode==>",authorizationCode);
			Log.e("redirectUri==>",redirectUri);
			Log.e("clientId==>",clientId);
			SetTimer(120000);
			_signInAPConfig.alexaResponseLogin(clientId,redirectUri,authorizationCode);
		}

		/* There was an error during the attempt to authorize the application. */
		@Override
		public void onError(final AuthError authError) {
			Log.e("==>","error");
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					_signInLoad.setVisibility(View.GONE);
				}
			});

			if(timer!=null)
			{
				timer.cancel();//关闭定时器
				timer=null;
				task.cancel();//关闭定时器
				task=null;
			}
		}

		/* Authorization was cancelled before it could be completed. */
		@Override
		public void onCancel(final AuthCancellation authCancellation) {
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					_signInLoad.setVisibility(View.GONE);
				}
			});
			if(timer!=null)
			{
				timer.cancel();//关闭定时器
				timer=null;
				task.cancel();//关闭定时器
				task=null;
			}
		}
	}
}
