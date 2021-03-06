package greendao;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT. Enable "keep" sections if you want to edit. 
/**
 * Entity mapped to table RANKING.
 */
public class Ranking {

    private Long id;
    private Integer points;
    private Integer completedExams;
    private Long rightAnswers;
    private Long wrongAnswers;

    public Ranking() {
    }

    public Ranking(Long id) {
        this.id = id;
    }

    public Ranking(Long id, Integer points, Integer completedExams, Long rightAnswers, Long wrongAnswers) {
        this.id = id;
        this.points = points;
        this.completedExams = completedExams;
        this.rightAnswers = rightAnswers;
        this.wrongAnswers = wrongAnswers;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    public Integer getCompletedExams() {
        return completedExams;
    }

    public void setCompletedExams(Integer completedExams) {
        this.completedExams = completedExams;
    }

    public Long getRightAnswers() {
        return rightAnswers;
    }

    public void setRightAnswers(Long rightAnswers) {
        this.rightAnswers = rightAnswers;
    }

    public Long getWrongAnswers() {
        return wrongAnswers;
    }

    public void setWrongAnswers(Long wrongAnswers) {
        this.wrongAnswers = wrongAnswers;
    }

}
