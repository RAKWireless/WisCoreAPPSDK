package com.rak.wiscore;

import android.app.Dialog;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.SwipeListview.library.PullToRefreshSwipeMenuListView;
import com.rak.wiscore.SwipeListview.library.pulltorefresh.interfaces.IXListViewListener;
import com.rak.wiscore.SwipeListview.library.swipemenu.bean.SwipeMenu;
import com.rak.wiscore.SwipeListview.library.swipemenu.bean.SwipeMenuItem;
import com.rak.wiscore.SwipeListview.library.swipemenu.interfaces.OnMenuItemClickListener;
import com.rak.wiscore.SwipeListview.library.swipemenu.interfaces.SwipeMenuCreator;
import com.rak.wiscore.SwipeListview.library.util.RefreshTime;
import com.rak.wiscore.component.DeviceEntity;
import com.rak.wiscore.component.ListAdapter;
import com.rak.wiscore.component.Loading;
import com.rak.wiscore.component.MainMenuButton;
import com.rak.wiscore.component.NetworkUtil;
import com.rak.wiscore.component.Scanner;

import java.io.File;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends AppCompatActivity implements IXListViewListener {
    private MainActivity _mainActivity;
    private ListAdapter mListAdapter;
    private ArrayList<HashMap<String, Object>> mListItem;
    private PullToRefreshSwipeMenuListView mListView;
    private Handler mHandler;
    private MainMenuButton _menuButton;
    private MainMenuButton _refreshButton;
    private MainMenuButton _addButton;
    private Loading _mainLoad;
    private Scanner _scanner;
    private TextView _mainNote;
    private Dialog deleteDialog = null;
    private TextView _mainVersion;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        _mainActivity=this;
        deleteDialog = new Dialog(this, R.style.myDialogTheme);
        _mainLoad=(Loading)findViewById(R.id.main_loading);
        _mainLoad.setText(getResources().getString(R.string.main_scan_indicator));
        mListView = (PullToRefreshSwipeMenuListView) findViewById(R.id.main_device_listView);
        mListView.setOnItemClickListener(_mListViewClick);
        mListItem = new ArrayList<HashMap<String, Object>>();
        mListAdapter = new ListAdapter(this,mListItem, R.layout.list_item,
                new String[]{"list_img","list_text","list_ip","list_id"},
                new int[]{R.id.list_img,R.id.list_text,R.id.list_ip,R.id.list_id});
        mListItem.clear();
        mListView.setAdapter(mListAdapter);
        mListView.setPullRefreshEnable(false);
        mListView.setPullLoadEnable(false);
        mListView.setXListViewListener(this);
        mHandler = new Handler();

        _menuButton=(MainMenuButton)findViewById(R.id.main_menu_btn);
        _menuButton.setOnClickListener(_menuButtonClick);
        _refreshButton=(MainMenuButton)findViewById(R.id.main_refresh_btn);
        _refreshButton.setOnClickListener(_refreshButtonClick);
        _addButton=(MainMenuButton)findViewById(R.id.main_device_add);
        _addButton.setOnClickListener(_addButtonClick);
        _mainNote=(TextView) findViewById(R.id.main_note);
        _mainVersion=(TextView) findViewById(R.id.main_app_version);
        try {
            _mainVersion.setText(getVersionName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        _mainNote.setVisibility(View.GONE);

        // step 1. create a MenuCreator
        SwipeMenuCreator creator = new SwipeMenuCreator() {

            @Override
            public void create(SwipeMenu menu) {
                // create "open" item
                SwipeMenuItem openItem = new SwipeMenuItem(getApplicationContext());
                // set item background
                openItem.setBackground(new ColorDrawable(Color.rgb(0xC9, 0xC9, 0xCE)));
                // set item width
                openItem.setWidth(dp2px(100));
                // set item title
                openItem.setTitle("Edit");
                // set item title fontsize
                openItem.setTitleSize(18);
                // set item title font color
                openItem.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(openItem);

                // create "delete" item
                SwipeMenuItem deleteItem = new SwipeMenuItem(getApplicationContext());
                // set item background
                deleteItem.setBackground(new ColorDrawable(Color.rgb(0xF9, 0x3F, 0x25)));
                // set item width
                deleteItem.setWidth(dp2px(100));
                // set a icon
                deleteItem.setTitle("Delete");
                // set item title fontsize
                deleteItem.setTitleSize(18);
                // set item title font color
                deleteItem.setTitleColor(Color.WHITE);
                // add to menu
                menu.addMenuItem(deleteItem);
            }
        };
        // set creator
        mListView.setMenuCreator(creator);

        // step 2. listener item click event
        mListView.setOnMenuItemClickListener(new OnMenuItemClickListener() {
            @Override
            public void onMenuItemClick(final int position, SwipeMenu menu, int index) {
                if(position<0)
                    return;
                final String id=mListItem.get((position)).get("list_id").toString();
                switch (index) {
                    case 0:{
                        Log.e("==>", "Edit");
                        LayoutInflater delete_Dialog_inflater = getLayoutInflater();
                        View delete_Dialog_admin = delete_Dialog_inflater.inflate(R.layout.delete_admin, (ViewGroup) findViewById(R.id.delete_admin1));
                        TextView device_delete_admin_note = (TextView) delete_Dialog_admin.findViewById(R.id.del_note);
                        device_delete_admin_note.setVisibility(View.GONE);
                        TextView device_delete_admin_ok = (TextView) delete_Dialog_admin.findViewById(R.id.del_ok_btn);
                        TextView device_delete_admin_cancel = (TextView) delete_Dialog_admin.findViewById(R.id.del_cancel_btn);
                        final EditText device_delete_admin_edit = (EditText) delete_Dialog_admin.findViewById(R.id.del_edit);
                        device_delete_admin_edit.setVisibility(View.VISIBLE);
                        device_delete_admin_note.setText(R.string.delete_device_dialog_text);
                        device_delete_admin_ok.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                if(device_delete_admin_edit.getText().toString().equals("")){
                                    Toast.makeText(_mainActivity,getString(R.string.delete_device_name_error),Toast.LENGTH_SHORT).show();
                                    return;
                                }
                                DeviceEntity.modifyDeviceNameById(_mainActivity, id,device_delete_admin_edit.getText().toString());
                                mListItem.clear();
                                mListAdapter.notifyDataSetChanged();
                                _mainLoad.setVisibility(View.VISIBLE);
                                _scanner.scanAll();
                                deleteDialog.dismiss();
                            }
                        });
                        device_delete_admin_cancel.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                deleteDialog.dismiss();
                            }
                        });
                        deleteDialog.setCanceledOnTouchOutside(false);
                        deleteDialog.setContentView(delete_Dialog_admin);
                        deleteDialog.show();
                        break;
                    }
                    case 1: {
                        // delete
                        Log.e("==>", "Delete");
                        //获取设备提示
                        LayoutInflater delete_Dialog_inflater = getLayoutInflater();
                        View delete_Dialog_admin = delete_Dialog_inflater.inflate(R.layout.delete_admin, (ViewGroup) findViewById(R.id.delete_admin1));
                        TextView device_delete_admin_note = (TextView) delete_Dialog_admin.findViewById(R.id.del_note);
                        device_delete_admin_note.setVisibility(View.VISIBLE);
                        TextView device_delete_admin_ok = (TextView) delete_Dialog_admin.findViewById(R.id.del_ok_btn);
                        TextView device_delete_admin_cancel = (TextView) delete_Dialog_admin.findViewById(R.id.del_cancel_btn);
                        EditText device_delete_admin_edit = (EditText) delete_Dialog_admin.findViewById(R.id.del_edit);
                        device_delete_admin_edit.setVisibility(View.GONE);
                        device_delete_admin_note.setText(R.string.delete_device_dialog_text);
                        device_delete_admin_ok.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                mListItem.remove(position);
                                mListAdapter.notifyDataSetChanged();
                                if (mListItem.size() > 0) {
                                    _mainNote.setVisibility(View.GONE);
                                } else {
                                    _mainNote.setVisibility(View.VISIBLE);
                                }
                                DeviceEntity.deleteDeviceById(_mainActivity,id);
                                deleteDialog.dismiss();
                            }
                        });
                        device_delete_admin_cancel.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                deleteDialog.dismiss();
                            }
                        });
                        deleteDialog.setCanceledOnTouchOutside(false);
                        deleteDialog.setContentView(delete_Dialog_admin);
                        deleteDialog.show();
                        break;
                    }
                }
            }
        });

        _scanner = new Scanner(this);
        _scanner.setOnScanOverListener(new Scanner.OnScanOverListener() {
            @Override
            public void onResult(Map<InetAddress, String> data, InetAddress gatewayAddress) {
                ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
                ArrayList<String> _deviceIds = new ArrayList<String>();
                _deviceIds = DeviceEntity.getDevicesId(_mainActivity);
                if (data != null) {//扫描到的设备
                    for (Map.Entry<InetAddress, String> entry : data.entrySet()) {
                        String id = entry.getValue();
                        String ip = entry.getKey().getHostAddress();
                        String name = DeviceEntity.getDeviceNameFromId(_mainActivity, id);
                        Log.e("id=", id);
                        Log.e("ip=", ip);
                        Log.e("name=", name);
                        if(ip.equals("192.168.230.1")==false){
                            boolean same = false;
                            for (int i = 0; i < _deviceIds.size(); i++) {
                                if (_deviceIds.get(i).toString().equals(id)) {
                                    _deviceIds.remove(i);//已保存设备中删除扫描到的设备
                                    same = true;
                                    break;
                                }
                            }

                            if (!same) {
                                //未保存只是本地扫描到的，直接添加到列表
                            } else {//已保存，更新保存的值,主要是更新IP地址，再添加到列表
                                DeviceEntity.saveDevicesById(_mainActivity, id, name, ip);
                            }
                            //添加到列表
                            AddDeviceListItem(name,ip,id,1);
                        }
                    }
                }
                //添加已保存但未扫描到的设备到列表
                for (int l = 0; l < _deviceIds.size(); l++) {
                    String id = _deviceIds.get(l).toString();
                    String ip = "127.0.0.1";
                    String name = DeviceEntity.getDeviceNameFromId(_mainActivity, id);
                    DeviceEntity.saveDevicesById(_mainActivity, id, name, ip);//已保存，更新保存的值,主要是更新IP地址，再添加到列表
                    //添加到列表
                    AddDeviceListItem(name,ip,id,0);
                }
                _mainLoad.setVisibility(View.GONE);
                if (mListItem.size()>0){
                    _mainNote.setVisibility(View.GONE);
                }
                else{
                    _mainNote.setVisibility(View.VISIBLE);
                }
            }
        });
    }

    private String getVersionName() throws Exception
    {
        // 获取packagemanager的实例
        PackageManager packageManager = getPackageManager();
        // getPackageName()是你当前类的包名，0代表是获取版本信息
        PackageInfo packInfo = packageManager.getPackageInfo(getPackageName(),0);
        String version = "V"+packInfo.versionName;
        return version;
    }

    @Override
    protected void onResume() {
        super.onResume();
        mListItem.clear();
        mListAdapter.notifyDataSetChanged();
        _mainLoad.setVisibility(View.VISIBLE);
        _scanner.scanAll();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onBackPressed() {
        exit();
    }

    /**
     * Menu
     */
    View.OnClickListener _menuButtonClick=new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Log.e("==>","_menuButtonClick");
        }
    };

    /**
     * Refresh
     */
    View.OnClickListener _refreshButtonClick=new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Log.e("==>","_refreshButtonClick");
            mListItem.clear();
            mListAdapter.notifyDataSetChanged();
            _mainLoad.setVisibility(View.VISIBLE);
            _scanner.scanAll();
        }
    };

    /**
     * Add
     */
    View.OnClickListener _addButtonClick=new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            Log.e("==>","_addButtonClick");
            Intent intent=new Intent();
            intent.setClass(MainActivity.this,ApAddStep1Activity.class);
            startActivity(intent);
        }
    };

    /**
     * Add Device List
     */
    private void AddDeviceListItem(String name,String ip,String id,int type)
    {
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("list_text",name);
        map.put("list_ip",ip);
        map.put("list_id",id);
        if (type==0)
            map.put("list_img", R.drawable.red);
        else
            map.put("list_img", R.drawable.teal);
        mListItem.add(map);
        mListAdapter.notifyDataSetChanged();
    }

    /**
     * Device List View
     */
    AdapterView.OnItemClickListener _mListViewClick=new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            if(position<1)
                return;
            String name=mListItem.get((position-1)).get("list_text").toString();
            String ip=mListItem.get((position-1)).get("list_ip").toString();
            Log.e("ip==>",ip);
            Log.e("name==>",name);
            if (ip.equals("127.0.0.1")){
                Toast.makeText(_mainActivity,getString(R.string.device_not_online),Toast.LENGTH_SHORT).show();
            }
            else{
                Intent intent=new Intent();
                intent.putExtra("name",name);
                intent.putExtra("ip",ip);
                intent.setClass(MainActivity.this,DeviceViewActivity.class);
                startActivity(intent);
            }
        }
    };

    private void onLoad() {
//        mListView.setRefreshTime(RefreshTime.getRefreshTime(getApplicationContext()));
//        mListView.stopRefresh();
//
//        mListView.stopLoadMore();

    }

    public void onRefresh() {
//        mHandler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                SimpleDateFormat df = new SimpleDateFormat("MM-dd HH:mm", Locale.getDefault());
//                RefreshTime.setRefreshTime(getApplicationContext(), df.format(new Date()));
//                onLoad();
//            }
//        }, 2000);
    }

    public void onLoadMore() {
//        mHandler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                onLoad();
//            }
//        }, 2000);
    }

    private int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, getResources().getDisplayMetrics());
    }

    /**
     * 退出软件
     */
    private static Boolean isExit = false;
    void exit()
    {
        Timer tExit = null;
        if (isExit == false)
        {
            isExit = true;
            Toast.makeText(this, "Press one more time to exit", Toast.LENGTH_SHORT).show();
            tExit = new Timer();
            tExit.schedule(new TimerTask()
            {
                @Override
                public void run()
                {
                    isExit = false; // 取消退出
                }
            }, 2000);

        }
        else
        {
            finish();
            System.exit(0);
            android.os.Process.killProcess(android.os.Process.myPid());
        }
    }
}
