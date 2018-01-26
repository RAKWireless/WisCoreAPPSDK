package com.rak.wiscore.component;

import android.os.AsyncTask;
import android.util.Base64;
import android.util.Log;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;

public class ApConfig {
	public static int GET_SSID_FROM_DEVICE = 0;
	public static int CONFIGURE_DEVICE_TO_NETWORK = 1;
	public static int RESET_DEVICE = 2;
	public static int Alexa_Request_Login = 3;
	public static int Alexa_Response_Login = 4;
	public static int GET_VERSION_FORM_DEVICE = 5;
	public static int SET_PARAMETERS_FORM_DEVICE = 6;
	public static int FAC_RESET_DEVICE = 7;
	public static int RESET_NET = 8;
	public static int GET_WIFI_STATUS = 9;
	public static int Alexa_Sign_Out = 10;
	public static int GET_LOGIN_STATUS = 11;

	private String _ip;
	private String _username = "admin";
	private String _password = "admin";
	private OnResultListener _onResultListener;

	public class Response {
		public String body = "";
		public int statusCode = 0;
		public int type;
	}

	class HttpAsyncTask extends AsyncTask<String, Void, Response> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
		}

		@Override
		protected Response doInBackground(String... params) {
			String url = params[0];
			String body=params[1];
			int type = Integer.parseInt(params[2]);
			String way="GET";
			Response response = new Response();
			response.type = type;
			Log.d("url", url);
			InputStream inputs;
			if (body.equals("")==false){
				way="POST";
			}

			try
			{
				HttpURLConnection conn = (HttpURLConnection)new URL(url).openConnection();
				byte[] entity=body.getBytes();
				String basic= Base64.encodeToString((_username+":"+_password).getBytes(), Base64.NO_WRAP);
				//设置http连接参数
				conn.setDoInput(true);
				conn.setRequestProperty("Accept", "*/*");
				conn.setRequestProperty("connection", "Keep-Alive");
				conn.setRequestProperty("Authorization", "Basic "+basic);
				if(way.equals("POST"))
				{
					conn.setDoOutput(true);
					conn.setRequestProperty("Content-Length", String.valueOf(entity.length));
				}
				else
				{
					conn.setDoOutput(false);
				}
				conn.setRequestMethod(way);

				//设置超时时间
				conn.setConnectTimeout(10000);//10S超时
				conn.setReadTimeout(15000);//15S超时
				if (type==Alexa_Response_Login)
					conn.setReadTimeout(50000);//50S超时
				conn.connect();
				//发送https数据
				if(way.equals("POST"))
				{
					OutputStream outStream = conn.getOutputStream();
					outStream.write(entity);
					outStream.flush();
					outStream.close();
				}
				//接收返回数据
				inputs=conn.getInputStream();
				BufferedReader br = new BufferedReader(new InputStreamReader(inputs));
				String lines=null;
				response.statusCode=conn.getResponseCode();
				while((lines = br.readLine()) != null)
				{
					response.body +=lines;
				}
				Log.d("body", response.body);
			}
			catch(Exception e)
			{
				Log.e("error",e.toString());
			}

			return response;
		}

		@Override
		protected void onPostExecute(Response result) {
			_onResultListener.onResult(result);
		}
	}

	public ApConfig(String ip, String password) {
		_ip = ip+":9999";
		if (!password.matches(""))
			_password = password;
	}

	public void SetPassword(String password) {
		_password = password;
	}

	public void SetUsername(String username) {
		_username = username;
	}

	private String urlEncode(String param) {
		String ret = param.replace("%","%25")
				.replace("+","%2B")
				.replace(" ","%20")
				.replace("/","%2F")
				.replace("?","%3F")
				.replace("#","%23")
				.replace("&","%26")
				.replace("=","%3D");
//		try {
//			ret = java.net.URLEncoder.encode(ret, "UTF-8");
//		}
//		catch (UnsupportedEncodingException ex) {}

		return ret;
	}

	private void get(String url, String body, int type) {
		HttpAsyncTask http = new HttpAsyncTask();
		http.execute(url, body,Integer.toString(type));
	}

	//region event
	public void setOnResultListener(OnResultListener listener) {
		_onResultListener = listener;
	}

	public static interface OnResultListener {
		public void onResult(Response result);
	}
	//endregion

	/**
	 * Alexa Request Login
	 */
	public void alexaRequestLogin() {
		get("http://" + _ip + "/server.command?command=login&type=request","", Alexa_Request_Login);
	}

	/**
	 * Alexa Response Login
	 */
	public void alexaResponseLogin(String id,String uri,String code) {
		get("http://" + _ip + "/server.command?command=login&type=response&client_id="+id+"&redirect_uri="+uri+"&authorize_code="+code,"", Alexa_Response_Login);
	}

	/**
	 * Alexa Sign Out
	 */
	public void alexaSignOut() {
		get("http://" + _ip + "/server.command?command=logout","", Alexa_Sign_Out);
	}

	/**
	 * 获取模块扫描到的无线网络名称
	 */
	public void getSsidFromDevice() {
		get("http://" + _ip + "/server.command?command=get_wifilist","", GET_SSID_FROM_DEVICE);
	}

	/**
	 * 解析模块扫描到的无线网络名称
	 */
	private ArrayList<String> rssiList=new ArrayList<String>();
	public ArrayList<String> decodeSsidFromDevice(String ssidString){
		ArrayList<String> ssidList=new ArrayList<String>();
		rssiList.clear();
		String keyString="\"ssid\":\"";
		String keyFlag="\",";
		String endFlag="\",";
		String keyString2="\"signal\":\"";
		String[] ssids=ssidString.split(keyString);
		for (int i=0;i<ssids.length;i++){
			int position=0;
			int index=ssids[i].indexOf(keyFlag,position);
			if(index!=-1) {
				position=index+keyFlag.length();
				int index1=ssids[i].indexOf(endFlag,position);
				if(index1!=-1) {
					position=index1+endFlag.length();
					//rssi
					int index2=ssids[i].indexOf(keyString2,position);
					if(index2!=-1) {
						position = index2 + keyString2.length();
						int index3=ssids[i].indexOf(endFlag,position);
						if(index3!=-1) {
							ssidList.add(ssids[i].substring(index+keyFlag.length(),index1));
							String rssi=ssids[i].substring(position,index3);
							if (rssi.startsWith("-")){
								rssiList.add(rssi);
							}
							else{
								rssiList.add("-"+rssi);
							}
						}
					}
				}
			}
		}
		return ssidList;
	}

	public ArrayList<String> getRssiList(){
		return rssiList;
	}

	public String findString(String src,String key,String endKey){
		String result="";
		int index=src.indexOf(key,0);
		if(index!=-1) {
			int index1 = src.indexOf(endKey, index + key.length());
			if (index1 != -1) {
				result = src.substring(index + key.length(), index1);
			}
		}
		return result;
	}

	/**
	 * 配置模块连接到无线网络
	 */
	public void configureDeviceToNetwork(String ssid,String psk) {
		get("http://" + _ip + "/param.cgi?action=update&group=wifi&sta_ssid="+urlEncode(ssid)+"&sta_auth_key="+urlEncode(psk)+"&sta_encrypt_type=psk2", "", CONFIGURE_DEVICE_TO_NETWORK);
	}

	/**
	 * 复位模块
	 */
	public void resetDevice() {
		get("http://" + _ip + "/restart.cgi","", RESET_DEVICE);
	}

	/**
	 * 复位WIFI
	 */
	public void resetNet() {
		get("http://" + _ip + "/param.cgi?action=restart_net","", RESET_NET);
	}

	/**
	 * 模块恢复出厂
	 */
	public void facResetDevice() {
		get("http://" + _ip + "/server.command?command=resetboard","", FAC_RESET_DEVICE);
	}


	/**
	 * 获取模块版本号
	 */
	public void getVersion() {
		get("http://" + _ip + "/server.command?command=get_version","", GET_VERSION_FORM_DEVICE);
	}

	/**
	 * 获取模块网络信息
	 */
	public void getWifiStatus() {
		get("http://" + _ip + "/server.command?command=get_wifistatus","", GET_WIFI_STATUS);
	}

	/**
	 * 获取模块Alexa登录状态
	 */
	public void getLoginStatus() {
		get("http://" + _ip + "/server.command?command=islogin","", GET_LOGIN_STATUS);
	}
}
