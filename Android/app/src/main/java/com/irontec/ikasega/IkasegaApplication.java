package com.irontec.ikasega;

import android.app.Application;
import android.database.sqlite.SQLiteDatabase;

import greendao.DaoMaster;
import greendao.DaoSession;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class IkasegaApplication extends Application {

    private static final String DB_NAME = "ikasega-db";
    public static String PREFS_VERSION_KEY = "ikasega_version_key";
    public static final Integer QUESTION_POINTS = 213;
    public static final Integer EXAM_POINTS = 5000;

    public DaoSession daoSession;

    @Override
    public void onCreate() {
        super.onCreate();
        setupDatabase();
    }

    private void setupDatabase() {
        DaoMaster.DevOpenHelper helper = new DaoMaster.DevOpenHelper(this, DB_NAME, null);
        SQLiteDatabase db = helper.getWritableDatabase();
        DaoMaster daoMaster = new DaoMaster(db);
        daoSession = daoMaster.newSession();
    }

    public DaoSession getDaoSession() {
        return daoSession;
    }

}
