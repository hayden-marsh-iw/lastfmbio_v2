import ballerina/http;
import ballerina/log;
import ballerina/url;
import ballerina/io;
import lastfmbio.types as t;
import ballerina/lang.value as v;

public isolated function topSong(string artist, string url, string apikey) returns t:sim|error {
    lock {
        http:Client cl = check new (url);
        http:Response rs = check cl -> get("/?method=artist.gettoptracks&artist=" + check url:encode(artist, "UTF-8") + "&api_key=" + apikey + "&format=json");
        log:printInfo("Request for top song for artist: " + artist);
        json song = check rs.getJsonPayload();
        do { 
            json[] tt = check v:ensureType(song.toptracks.track);
            t:sim s = {
                name: artist,
                top: check v:ensureType(tt[0].name, string),
                plays: check int:fromString(check v:ensureType(tt[0].playcount, string))
            };
            return s;
        } on fail var e { 
            log:printError("Request failed", e, e.stackTrace());
            return e; }    
    }
}

public isolated function saveProfile(xml x, string artist) returns string|error {
    lock {
        do { 
            string fp = "./resources/profiles/" + artist + ".xml";
            check io:fileWriteString(fp, x.toString());
            log:printInfo(fp + " saved."); 
            return fp;
        } on fail var e { 
            log:printError("File write failed", e, e.stackTrace());
            return e; 
        }    
    }
}