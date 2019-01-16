# README

**This is one of many clones Stackoverflow =)**


**Short description of realized features:**

    User can create questions, answers and comments. 
    User can vote for answers.
    User can choice the best answer(if he an author of question)
    User can attach files for questions, answers and comments.
    User can subscribe\unsubscribe for updates in any question.
    User automatically subscribe for updates in own questions.
    
**SEARCH**

Search implemented using gem Thinking Sphinx.
For indexing you can run rake task: 
    
    rake ts:index
    
  
Start/stop:

    rake ts:start
    rake ts:stop
    
For details, see the gem documentation. https://github.com/pat/thinking-sphinx   
    
**User roles**
* Admin - can manage all.
* User - can manage only own resources.   

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

#### **API**

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
   
**USERS RESOURCES** 

authorized resource - token needed.
  
    GET /api/v1/profiles.json
    Headers: 
    Authorization: Bearer "access token"
    
    Response: 
    Collection of users profiles.
    [
        {
            "id": 2,
            "created_at": "2018-07-12T10:41:10.423Z",
            "updated_at": "2018-07-12T10:41:10.663Z",
            "email": "whistle@mail.com",
            "admin": false,
            "first_name": null,
            "last_name": null
        },
        {
            "id": 4,
            "created_at": "2018-07-16T13:19:04.418Z",
            "updated_at": "2018-07-16T13:19:04.418Z",
            "email": "wildkaing@yandex.ru",
            "admin": false,
            "first_name": null,
            "last_name": null
        }
    ]
    
    GET /api/v1/profiles/me.json
        Headers: 
        Authorization: Bearer "access token"
        
        Response: 
        Return self profile       
            {
                "id": 2,
                "created_at": "2018-07-12T10:41:10.423Z",
                "updated_at": "2018-07-12T10:41:10.663Z",
                "email": "whistle@mail.com",
                "admin": false,
                "first_name": null,
                "last_name": null
            }
            
            
**QUESTION RESOURCE**

authorized resource - token needed.

* Index of questions

  
    GET /api/v1/questions.json
        Headers: 
        Authorization: Bearer "access token"
        
        Response: 
        Collection of questions with nested resources(answers).
         {
                "id": 48,
                "title": "Second",
                "body": "SecondSecondSecond",
                "created_at": "2018-07-03T21:23:01.826Z",
                "updated_at": "2018-07-03T21:23:01.826Z",
                "answers": [
                    {
                        "id": 84,
                        "body": "Attach",
                        "created_at": "2018-07-08T00:36:50.994Z",
                        "updated_at": "2018-07-08T00:36:50.994Z"
                    },
                    {
                        "id": 81,
                        "body": "sdfsdfsdf",
                        "created_at": "2018-07-04T19:28:06.251Z",
                        "updated_at": "2018-07-04T19:28:06.251Z"
                    }
                ]
            },
* Create question

  
    POST /api/v1/questions.json
        Headers: 
        Authorization: Bearer "access token"
        Body:
           * question[title]
           * question[body]
        Response: 
            Created serialized question
            {
            "id":65,
            "title":"new_title",
            "short_title":"new_title",
            "body":"bodybodybody",
            "created_at":"2019-01-16T14:16:24.101Z",
            "updated_at":"2019-01-16T14:16:24.101Z",
            "answers":[],"comments":[],"attachments":[]
            }
            
* Show single question


  
    GET /api/v1/questions/[:id].json
        Headers: 
        Authorization: Bearer "access token"
        Body:
           
        Response: 
             serialized question
            {
            "id":65,
            "title":"new_title",
            "short_title":"new_title",
            "body":"bodybodybody",
            "created_at":"2019-01-16T14:16:24.101Z",
            "updated_at":"2019-01-16T14:16:24.101Z",
            "answers":[],"comments":[],"attachments":[]
            }
**ANSWERS**

authorized resource - token needed.

* Show index answers of question


     GET /api/v1/questions/[:id]/answers.json
            Headers: 
            Authorization: Bearer "access token"
            Body:
               
            Response: 
                 serialized collecton of question's answers
                     {
                    "id": 84,
                    "body": "Attach",
                    "created_at": "2018-07-08T00:36:50.994Z",
                    "updated_at": "2018-07-08T00:36:50.994Z",
                    "comments": [],
                    "attachments": [
                        {
                            "url": "/uploads/attachment/file/31/Screenshot_from_2018-07-08_00-13-23.png",
                            "filename": "Screenshot_from_2018-07-08_00-13-23.png"
                        }
                    ]
                }
* Create new answer for question

  
    POST /api/v1/questions/[:question_id]/answers.json
        Headers: 
        Authorization: Bearer "access token"
        Body:           
           * answer[body]
        Response: 
            Created serialized answer
            {
                "id": 108,
                "body": "newanswer",
                "created_at": "2019-01-16T14:31:58.412Z",
                "updated_at": "2019-01-16T14:31:58.412Z",
                "comments": [],
                "attachments": []
            }
            
* Show single answer


  
    GET /api/v1/asnwers/[:id].json
        Headers: 
        Authorization: Bearer "access token"
        Body:
           
        Response: 
             serialized answer
            {
              "id": 108,
              "body": "newanswer",
              "created_at": "2019-01-16T14:31:58.412Z",
              "updated_at": "2019-01-16T14:31:58.412Z",
              "comments": [],
              "attachments": []
                        }            