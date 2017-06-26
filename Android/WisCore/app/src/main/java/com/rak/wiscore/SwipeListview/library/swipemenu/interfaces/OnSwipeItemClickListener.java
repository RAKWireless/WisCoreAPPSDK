package com.rak.wiscore.SwipeListview.library.swipemenu.interfaces;


import com.rak.wiscore.SwipeListview.library.swipemenu.bean.SwipeMenu;
import com.rak.wiscore.SwipeListview.library.swipemenu.view.SwipeMenuView;

public interface OnSwipeItemClickListener {
    void onItemClick(SwipeMenuView view, SwipeMenu menu, int index);
}