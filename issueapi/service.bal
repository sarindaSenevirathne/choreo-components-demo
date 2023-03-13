import ballerina/http;
import ballerina/uuid;

table<Issue> key(id) issuesTable = table[];

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function get issues() returns Issue[]|error {

        Issue[] response = [];
        foreach var issue in issuesTable {
            response.push(issue);
        }
        return response;
    }

    resource function post issues(@http:Payload Name payload) returns Issue|error {
        
        string uuid = uuid:createType4AsString();
        Issue issue= {
            id: uuid,
            name: payload.name,
            status: OPEN
        };
        issuesTable.add(issue);
        return issue;
    }

    resource function patch issues/[string issueId](@http:Payload Status payload) returns Issue|http:NotFound|error {
        
        if !issuesTable.hasKey(issueId) {
            return http:NOT_FOUND;
        }
        
        Issue issue = issuesTable.get(issueId);
        issue.status = payload.status;
        issuesTable.put(issue);
        return issue;
    }
}

public enum IssueStatus {
    OPEN = "Open",
    CLOSED = "Closed"
}

public type Status record {
    IssueStatus status;
};

public type Name record {
    string name;
};

public type Issue record {
    readonly string id;
    string name;
    string status;
};
