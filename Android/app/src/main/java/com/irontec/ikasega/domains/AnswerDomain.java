package com.irontec.ikasega.domains;

import android.content.Context;

import com.irontec.ikasega.IkasegaApplication;

import java.util.List;

import greendao.Answer;
import greendao.AnswerDao;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class AnswerDomain {

    public static void insertOrUpdate(Context context, Answer answer) {
        getDao(context).insertOrReplace(answer);
    }

    public static void insertOrReplaceInTx(Context context, List<Answer> answers) {
        getDao(context).insertOrReplaceInTx(answers);
    }

    public static void clear(Context context) {
        getDao(context).deleteAll();
    }

    public static void deleteWithId(Context context, long id) {
        getDao(context).delete(getForId(context, id));
    }

    public static List<Answer> getAll(Context context) {
        return getDao(context).loadAll();
    }

    public static Answer getForId(Context context, long id) {
        return getDao(context).load(id);
    }

    private static AnswerDao getDao(Context context) {
        return ((IkasegaApplication) context.getApplicationContext()).getDaoSession().getAnswerDao();
    }

}
