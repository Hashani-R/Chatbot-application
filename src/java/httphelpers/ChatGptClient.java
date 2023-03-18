package httphelpers;

import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import com.google.gson.Gson;
import com.google.gson.JsonObject;


public class ChatGptClient {
    private String _apiKey;
    
    public ChatGptClient(String apiKey) {
        _apiKey = apiKey;
    }
    
    public String chat(String message) {
        if (_apiKey == null || _apiKey.isEmpty()) {
            return "OpenAI registered API key is required before proceed.";
        }
        
        try{
            URL url = new URL("https://api.openai.com/v1/completions");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(10000);
            connection.setRequestProperty("Authorization", "Bearer " + _apiKey);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);
            
            String request = "{\r\n  \"model\": \"text-davinci-003\",\r\n  \"prompt\": \"" + 
                    message + "\",\r\n  \"max_tokens\": 64,\r\n  \"temperature\": 0.5\r\n}";
            
            OutputStream outputStream = connection.getOutputStream();
            byte[] input = request.getBytes("utf-8");
            outputStream.write(input, 0, input.length);
            
            InputStreamReader reader = new InputStreamReader(connection.getInputStream());
            StringBuffer response;
            
            if (connection.getResponseCode() != 200) {
                return "Request failed.";
            }
            
            try (BufferedReader in = new BufferedReader(reader)) {
                String resultLine;
                response = new StringBuffer();
                while ((resultLine = in.readLine()) != null) {
                    response.append(resultLine);
                }
            }
            
            String jsonString = response.toString();
            Gson gson = new Gson();
            
            JsonObject json = gson.fromJson(jsonString, JsonObject.class);
            String reply = json.getAsJsonArray("choices").get(0).getAsJsonObject().get("text").getAsString();
            return reply;
        }
        catch (IOException exp) {
            return exp.getMessage();
        }
    }
}
