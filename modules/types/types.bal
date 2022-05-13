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
