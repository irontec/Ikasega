package com.irontec.ikasega.domains;

import android.content.Context;

import com.irontec.ikasega.IkasegaApplication;

import java.util.List;

import greendao.Ranking;
import greendao.RankingDao;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class RankingDomain {

    public static long insertOrUpdate(Context context, Ranking ranking) {
        return getDao(context).insertOrReplace(ranking);
    }

    public static void clear(Context context) {
        getDao(context).deleteAll();
    }

    public static void deleteWithId(Context context, long id) {
        getDao(context).delete(getForId(context, id));
    }

    public static Ranking getRanking(Context context) {
        List<Ranking> list = getDao(context).queryBuilder().where(RankingDao.Properties.Id.eq(1L)).list();
        if (list != null && !list.isEmpty()) {
            return list.get(0);
        } else {
            return null;
        }
    }

    public static Ranking getForId(Context context, long id) {
        return getDao(context).load(id);
    }

    private static RankingDao getDao(Context context) {
        return ((IkasegaApplication) context.getApplicationContext()).getDaoSession().getRankingDao();
    }

}
