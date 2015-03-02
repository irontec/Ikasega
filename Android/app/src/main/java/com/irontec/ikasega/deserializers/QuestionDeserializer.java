package com.irontec.ikasega.deserializers;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;

import java.lang.reflect.Type;

import greendao.Question;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class QuestionDeserializer implements JsonDeserializer<Question> {
    @Override
    public Question deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        JsonObject jsonObj = (JsonObject) json;
        Question question = new Question();
        question.setQuestionHtml(jsonObj.get("questionHtml").getAsString());
        question.setQuestionText(jsonObj.get("questionText").getAsString());
        return question;
    }
}
