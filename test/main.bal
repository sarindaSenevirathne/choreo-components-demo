import ballerina/io;
import ballerina/regex;

public function main() {
    string[] paths = ["abc", "cde", "efg", "xyz"];
    string[] storedPaths = ["/abc/cde/", "/abc/cde/efg", "/abc/cde/efg/hij"];

    // Construct the base path
    string basePath = "/";
    foreach string path in paths {
        basePath = basePath + path + "/";
    }

    // Check against paths in the storedPaths array
    string? closestPath = ();
    int maxMatchCount = 0;
    foreach string storedPath in storedPaths {
        int currentMatchCount = countMatchingSegments(basePath, storedPath);
        if (currentMatchCount > maxMatchCount && basePath.startsWith(storedPath)) {
            maxMatchCount = currentMatchCount;
            closestPath = storedPath;
        }
    }

    // Output the closest path
    io:println("Closest path: ", closestPath);
}

function countMatchingSegments(string basePath, string storedPath) returns int {
    string[] basePathSegments = regex:split(basePath, "/");
    string[] storedPathSegments = regex:split(storedPath, "/");
    int matchCount = 0;

    int minLength = basePathSegments.length() < storedPathSegments.length()
        ? basePathSegments.length()
        : storedPathSegments.length();

    int i = 0;
    foreach string basePathSegment in basePathSegments {
        if (i < minLength && basePathSegment == storedPathSegments[i]) {
            matchCount += 1;
        } else {
            break;
        }
        i += 1;
    }

    return matchCount;
}
