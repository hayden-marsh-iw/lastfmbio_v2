public type sim record {|
    string name;
    string top;
    int plays;
|};

public type bioRecord record {|
    string name;
    int listeners;
    int plays;
    string top;
    sim[] similar;
    string bio;
|};

// public type cfg record {|
//     int lastfm_port;
//     string lastfm_url;
//     string lastfm_apikey;

//     int? rmq_port;
//     string? rmq_host;
//     string? rmq_exch;
//     string? rmq_routingkey;
//     string? rmq_user;
//     string? rmq_password;
// |};