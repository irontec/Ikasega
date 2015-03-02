package pl.surecase.eu;

import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Property;
import de.greenrobot.daogenerator.Schema;
import de.greenrobot.daogenerator.ToMany;

public class MyDaoGenerator {

    public static void main(String args[]) throws Exception {

        Schema schema = new Schema(14, "greendao");

        Entity exam = schema.addEntity("Exam");
        exam.addIdProperty();
        exam.addStringProperty("file");
        exam.addStringProperty("url");
        exam.addIntProperty("version");

        Entity ranking = schema.addEntity("Ranking");
        ranking.addIdProperty();
        ranking.addIntProperty("points");
        ranking.addIntProperty("completedExams");
        ranking.addLongProperty("rightAnswers");
        ranking.addLongProperty("wrongAnswers");

        Entity question = schema.addEntity("Question");
        question.addIdProperty();
        question.addStringProperty("questionHtml");
        question.addStringProperty("questionText");
        Property examId = question.addLongProperty("examId").notNull().getProperty();
        ToMany examToQuestions = exam.addToMany(question, examId);
        examToQuestions.setName("questions"); // Optional

        Entity answer = schema.addEntity("Answer");
        answer.addIdProperty();
        answer.addStringProperty("answer");
        answer.addIntProperty("valid");
        Property questionId = answer.addLongProperty("questionId").notNull().getProperty();
        ToMany questionToAnswers = question.addToMany(answer, questionId);
        questionToAnswers.setName("answers"); // Optional

        Entity progress = schema.addEntity("Progress");
        progress.addIdProperty().autoincrement();
        progress.addLongProperty("examId");
        progress.addLongProperty("examDuration");
        progress.addLongProperty("answeredQuestionId").unique();
        progress.addIntProperty("totalRightAnswers");
        progress.addIntProperty("totalWrongAnswers");
        progress.addStringProperty("startDate");
        progress.addStringProperty("endDate");
        new DaoGenerator().generateAll(schema, args[0]);

    }
}
