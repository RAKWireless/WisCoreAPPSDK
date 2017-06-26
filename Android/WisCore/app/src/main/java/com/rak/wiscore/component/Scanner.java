package com.rak.wiscore.component;

import android.content.Context;
import android.net.DhcpInfo;
import android.net.wifi.WifiManager;
import android.os.AsyncTask;
import android.os.Build;
import android.util.Log;

import java.io.IOException;
import java.math.BigInteger;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

public class Scanner {

	//region member
	private Context _context;
	private OnScanOverListener _onScanOverListener;
	private boolean _getFirst;
	private boolean _scanning = false;
	private WifiManager _wifiManager;
	private WifiManager.MulticastLock _multicastLock;

	// send data
	private byte[] data = {0x00, 0x00, 0x00, 0x01, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2a, 0x00};
	private byte end = 0x00;
	private int deviceIdBeginIndex = 18;
	private Map<InetAddress, String> list = new HashMap<>();
	private DatagramSocket socket = null;
	//endregion

	//region ctor
	public Scanner(Context context) {
		_context = context;
		_wifiManager = (WifiManager)_context.getSystemService(Context.WIFI_SERVICE);
	}
	//endregion

	//region private function
	private boolean scan(boolean getFirst) {
		if (_scanning) {
			return false;
		}

		_scanning = true;
		_getFirst = getFirst;

		_multicastLock = _wifiManager.createMulticastLock("UDPwifi");
		_multicastLock.acquire();

		ScanAsyncTask scanAsyncTask = new ScanAsyncTask();
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			scanAsyncTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
		} else {
			scanAsyncTask.execute();
		}

		return true;
	}

	private InetAddress getBroadcastAddress() throws UnknownHostException {
		DhcpInfo dhcp = _wifiManager.getDhcpInfo();

		int broadcast = (dhcp.ipAddress & dhcp.netmask) | ~dhcp.netmask;
		byte[] quads = new byte[4];
		for (int k = 0; k < 4; k++) {
			quads[k] = (byte)((broadcast >> k * 8) & 0xFF);
		}

		return InetAddress.getByAddress(quads);
	}

	private InetAddress getGatewayAddress() {
		DhcpInfo dhcp = _wifiManager.getDhcpInfo();
		byte[] ip = BigInteger.valueOf(dhcp.serverAddress).toByteArray();

		InetAddress gatewayAddress = null;
		try {
			gatewayAddress = InetAddress.getByAddress(ip);
		}
		catch (UnknownHostException e) {}

		return gatewayAddress;
	}

	private int indexOf(byte[] array, byte valueToFind, int startIndex) {
		if (array == null) {
			return -1;
		}
		if (startIndex < 0) {
			startIndex = 0;
		}
		for (int i = startIndex; i < array.length; i++) {
			if (valueToFind == array[i]) {
				return i;
			}
		}
		return -1;
	}

	private byte[] copyOfRange(byte[] from, int start, int end) {
		int length = end - start;
		byte[] result = new byte[length];
		System.arraycopy(from, start, result, 0, length);
		return result;
	}

	private class ScanAsyncTask extends AsyncTask<Void, Void, Map<InetAddress, String>> {
		@Override
		protected Map<InetAddress, String> doInBackground(Void... voids) {
			try {
				if (socket != null) {
					socket.disconnect();
					socket=null;
				}
				socket = new DatagramSocket();
				socket.setSoTimeout(1000);
				socket.setBroadcast(true);
				DatagramPacket packet = new DatagramPacket(data, data.length,
						getBroadcastAddress(), 5570);
				try
				{
					socket.send(packet);
					Thread.sleep(200);
					socket.send(packet);
					Thread.sleep(200);
					socket.send(packet);
					Thread.sleep(200);
					socket.send(packet);
					Thread.sleep(500);
				} catch (InterruptedException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				list.clear();
				for (int i = 0; i < 10; i++) {
					try {
						byte[] buf = new byte[1024];
						DatagramPacket receivedPacket = new DatagramPacket(buf, buf.length);
						socket.receive(receivedPacket);

						InetAddress address = InetAddress.getByName(
								receivedPacket.getAddress().getHostAddress());

						if (list.containsKey(address)) {
							continue;
						}

						if (receivedPacket.getLength() > deviceIdBeginIndex) {
							int deviceIdEndIndex = indexOf(buf, end, deviceIdBeginIndex);
							String deviceId = new String(
									copyOfRange(buf, deviceIdBeginIndex + 1, deviceIdEndIndex));
							list.put(address, deviceId);
							Log.e("deviceId==>",deviceId);
							if (_getFirst) {
								_scanning=false;
								return list;
							}
						}
					} catch (SocketException e) {}
				}
			}
			catch (SocketException e) {Log.e("s1==>",e.toString());} catch (IOException e) {Log.e("s2==>",e.toString());} finally {
				Log.e("s==>","disconnect");
				if (socket != null) {
					socket.disconnect();
				}
			}
			return list;
		}

		@Override
		protected void onPostExecute(Map<InetAddress, String> addresses) {
			super.onPostExecute(addresses);
			_scanning = false;
			_multicastLock.release();
			if (_onScanOverListener != null) {
				_onScanOverListener.onResult(addresses, getGatewayAddress());
			}
			System.gc();
		}
	}
	// endregion



	//region public function
	public boolean scanAll() {
		return scan(false);
	}

	public boolean scan() {
		return scan(true);
	}

	public void setOnScanOverListener(OnScanOverListener listener) {
		_onScanOverListener = listener;
	}

	public interface OnScanOverListener {
		void onResult(Map<InetAddress, String> data, InetAddress gatewayAddress);
	}
	//endregion
}
