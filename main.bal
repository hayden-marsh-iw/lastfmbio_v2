import ballerina/http;
import ballerina/io; 
import ballerina/lang.value as v;
import ballerina/log;
import ballerina/xmldata;
import ballerina/xslt;
import ballerinax/rabbitmq as rmq;
import lastfmbio.functions as f;
import lastfmbio.types as t;

configurable int port = ?;
configurable string url = ?;
configurable string apikey = ?;
//configurable rmq:ConnectionConfiguration rcfg = ?;
//configurable rmq:BasicProperties rprops = ?;
//configurable string rmqhost = ?;
//configurable int rmqport = ?;



configurable string rexch = ?;
configurable string rkey = ?;



service /api/v1/queueBio on new http:Listener(port) {
    isolated resource function get artist(string name) returns string?|error? { 
        log:printInfo("Request on port " + port.toString() + ": for artist: " + name);

        rmq:ConnectionConfiguration rcfg = {username:"shgzthmj", password:"6aOT7qs3WbaJJsp0rqZqAACt8K1ah8ba" };
        string rmqhost = "amqp://snake.rmq.cloudamqp.com/shgzthmj";
        int rmqport = 5672;
        rmq:Client r = check new(rmqhost, rmqport, rcfg);

        http:Client cl = check new(url);
        json prfl = check cl -> get("/?method=artist.getinfo&artist=" + name + "&api_key=" + apikey + "&format=json");
        do { if (prfl?.'error is null) { 
                t:sim[] ss = [];
                t:sim ts = check f:topSong(check v:ensureType(prfl.artist.name, string), url, apikey);
                json[] sa = check v:ensureType(prfl.artist.similar.artist);
                foreach json item in sa { ss.push(check f:topSong(check v:ensureType(item.name, string), url, apikey)); }
                t:bioRecord b = { 
                    name: check v:ensureType(prfl.artist.name, string),
                    listeners: check int:fromString(check prfl.artist.stats.listeners),
                    plays: check int:fromString(check prfl.artist.stats.playcount),
                    top: ts.top,
                    similar: ss,
                    bio: check v:ensureType(prfl.artist.bio.content, string)
                    };
                xml x = check xslt:transform(check v:ensureType(xmldata:fromJson(check b.cloneWithType(json))), check io:fileReadXml("resources/reformat.xslt"));
                check r -> publishMessage({ content: x.toString().toBytes(), routingKey: rkey }); //, properties: rprops
                return "Queued: " + rexch + ":" + rkey + "\r\nSaved to disk: " + check f:saveProfile(x, name) + "\r\n\r\n" + x.toString();
                } else { 
                    xml x = check v:ensureType(xmldata:fromJson(prfl));
                    log:printWarn(x.toString());     
                    return x.toString();   
                }
        } on fail var e { 
            log:printError("Request failed", e, e.stackTrace());
            return e; 
        }
    }
}