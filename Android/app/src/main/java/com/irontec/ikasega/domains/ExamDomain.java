package com.irontec.ikasega.domains;

import android.content.Context;

import com.irontec.ikasega.IkasegaApplication;

import java.util.List;

import greendao.Exam;
import greendao.ExamDao;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class ExamDomain {

    private final static String TAG = ExamDomain.class.getSimpleName();

    public static void insertOrUpdate(Context context, Exam exam) {
        getDao(context).insertOrReplace(exam);
    }

    public static void insertOrReplaceInTx(Context context, List<Exam> exams) {
        getDao(context).insertOrReplaceInTx(exams);
    }

    public static void clear(Context context) {
        getDao(context).deleteAll();
    }

    public static void deleteWithId(Context context, long id) {
        getDao(context).delete(getForId(context, id));
    }

    public static List<Exam> getAll(Context context) {
        return getDao(context).loadAll();
    }

    public static Exam getForId(Context context, long id) {
        return getDao(context).load(id);
    }

    private static ExamDao getDao(Context context) {
        return ((IkasegaApplication) context.getApplicationContext()).getDaoSession().getExamDao();
    }

}
