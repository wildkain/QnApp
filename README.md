# README

**This is one of many clones Stackoverflow =)**

**Entities**
* User
* Question
* Answer
* Comment
* Vote
* Attachement
* Subscription

**Roles** 

Admin - can all)
User  - can manage only own objects(Question, Answer, ... etc)

**API** 

First of all, for interact with API, you must do POST request to special endpoint:

**POST "/oauth/token"**

    Headers:
      Content-Type: application/x-www-form-urlencoded   
    Body: 
      * client_id: "application_id from doorkeeper"
      * client_secret: "secret from doorkeeper"
      * code: "authorization code from doorkeeper"
      * grant_type: authorization_code
      * redirect_uri: "on localhost it is 'urn:ietf:wg:oauth:2.0:oob'"	

    Response:
      Body: 
        {
            "access_token": "b71dc220f7fda884db31771c2b41ca736dd0cbe6fd594695c07bf1a17c538ed5",
            "token_type": "bearer",
            "expires_in": 7200,
            "created_at": 1547643200
        }
Then, you must use the access token from response in each your requests.
   

