package com.irontec.ikasega.deserializers;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;

import java.lang.reflect.Type;

import greendao.Answer;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class AnswerDeserializer  implements JsonDeserializer<Answer> {
    @Override
    public Answer deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        JsonObject jsonObj = (JsonObject) json;
        Answer answer = new Answer();
        answer.setAnswer(jsonObj.get("answ").getAsString());
        answer.setValid(jsonObj.get("valid").getAsInt());
        return answer;
    }
}
