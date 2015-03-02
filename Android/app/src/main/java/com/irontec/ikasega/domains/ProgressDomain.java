package com.irontec.ikasega.domains;

import android.content.Context;

import com.irontec.ikasega.IkasegaApplication;

import java.util.List;

import greendao.Progress;
import greendao.ProgressDao;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class ProgressDomain {

    public static long insertOrUpdate(Context context, Progress progress) {
        return getDao(context).insertOrReplace(progress);
    }

    public static void insertOrReplaceInTx(Context context, List<Progress> progresses) {
        getDao(context).insertOrReplaceInTx(progresses);
    }

    public static void clear(Context context) {
        getDao(context).deleteAll();
    }

    public static void deleteWithId(Context context, long id) {
        getDao(context).delete(getForId(context, id));
    }

    public static List<Progress> getProgressByExamId(Context context, long id) {
        return getDao(context).queryBuilder()
                .where(
                        ProgressDao.Properties.ExamId.eq(id))
                .orderDesc(
                        ProgressDao.Properties.EndDate)
                .list();
    }

    public static Progress getSingleProgressByExamId(Context context, long id) {
        List<Progress> progresses = getDao(context).queryBuilder()
                .where(
                        ProgressDao.Properties.ExamId.eq(id))
                .orderDesc(
                        ProgressDao.Properties.EndDate)
                .list();
        if (progresses.isEmpty()) {
            return null;
        } else {
            return progresses.get(0);
        }
    }


    public static List<Progress> getAll(Context context) {
        return getDao(context).loadAll();
    }

    public static Progress getForId(Context context, long id) {
        return getDao(context).load(id);
    }

    private static ProgressDao getDao(Context context) {
        return ((IkasegaApplication) context.getApplicationContext()).getDaoSession().getProgressDao();
    }

}
