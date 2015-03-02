package com.irontec.ikasega.domains;

import android.content.Context;

import com.irontec.ikasega.IkasegaApplication;

import java.util.ArrayList;
import java.util.List;

import greendao.Answer;
import greendao.Question;
import greendao.QuestionDao;
import greendao.Ranking;
import greendao.RankingDao;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class QuestionDomain {

    private static final String TAG = QuestionDomain.class.getSimpleName();

    public static void insertOrUpdate(Context context, Question question) {
        getDao(context).insertOrReplace(question);
    }

    public static void insertOrReplaceInTx(Context context, List<Question> questions) {
        getDao(context).insertOrReplaceInTx(questions);
    }

    public static void clear(Context context) {
        getDao(context).deleteAll();
    }

    public static void deleteWithId(Context context, long id) {
        getDao(context).delete(getForId(context, id));
    }

    public static List<Question> getAllForExamId(Context context, long id) {
        List<Question> list = getDao(context).queryBuilder().where(QuestionDao.Properties.ExamId.eq(1L)).list();
        if (list != null && !list.isEmpty()) {
            return list;
        } else {
            return new ArrayList<Question>();
        }
    }

    public static List<Question> getAll(Context context) {
        return getDao(context).loadAll();
    }

    public static Question getForId(Context context, long id) {
        return getDao(context).load(id);
    }

    public static List<Answer> getAnswersForQuestionId(Context context, long id) {
        Question question = getDao(context).load(id);
        List<Answer> answers = question.getAnswers();
        return answers;
    }

    private static QuestionDao getDao(Context context) {
        return ((IkasegaApplication) context.getApplicationContext()).getDaoSession().getQuestionDao();
    }

}
