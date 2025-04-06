# Project template

### Refer to branches for different project templates

 configProps.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username='' password='';");
       
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class MultiLevelJsonFilterExample {
    public static void main(String[] args) throws Exception {
        // Example multi-level JSON (could start with an array)
        String jsonInput = "[{\"name\":\"John\",\"age\":30,\"email\":\"john@example.com\",\"details\":{\"address\":\"123 Street\",\"phone\":\"123456789\"}},"
                         + "{\"name\":\"Jane\",\"age\":25,\"email\":\"jane@example.com\",\"details\":{\"address\":\"456 Avenue\",\"phone\":\"987654321\"}}]";

        // Create an ObjectMapper instance
        ObjectMapper mapper = new ObjectMapper();

        // Parse JSON into JsonNode
        JsonNode rootNode = mapper.readTree(jsonInput);

        // Create filtered JSON
        JsonNode filteredNode;
        if (rootNode.isArray()) {
            ArrayNode filteredArray = mapper.createArrayNode();
            for (JsonNode element : rootNode) {
                filteredArray.add(filterNode(element, mapper));
            }
            filteredNode = filteredArray;
        } else {
            filteredNode = filterNode(rootNode, mapper);
        }

        // Convert filtered JSON back to string
        String filteredJson = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(filteredNode);
        System.out.println(filteredJson);
    }

    private static JsonNode filterNode(JsonNode node, ObjectMapper mapper) {
        if (node.isObject()) {
            ObjectNode filteredObject = mapper.createObjectNode();
            node.fields().forEachRemaining(field -> {
                String fieldName = field.getKey();
                // Exclude "email" field dynamically
                if (!fieldName.equals("email")) {
                    filteredObject.set(fieldName, filterNode(field.getValue(), mapper));
                }
            });
            return filteredObject;
        } else if (node.isArray()) {
            ArrayNode filteredArray = mapper.createArrayNode();
            for (JsonNode element : node) {
                filteredArray.add(filterNode(element, mapper));
            }
            return filteredArray;
        } else {
            return node; // For primitive values
        }
    }
}
