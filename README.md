# The task
We need to create a prototype of a service. The service to need to emulate sending of messages to popular messengers (Viber, Telegram, WhatsApp).

The app should be able to do the following:
- take messages though its API and send to messengers (with user identifier);
- be able to schedule sending on specific date and time;
- if delivery failed - re-send it N times;
- no possibility of a message sent more than once to a single recipient;
- ability to send the same message to different recipients in just one incoming api request;

# Project Overview

1. **Sidekiq** is used to queue and send requests in background (also allows scheduling). While Rails API part is free to take new requests.
1. **Redis** is used by Sidekiq to store all of its job and operational data.
1. **Posgtres** is used to have historical requests' data in persistent storage.
1. **Grape** allows for easier and faster of API making, validation of incoming requests.
1. **AASM** is for taking advantage of finite state machine pattern. Allows dynamically change request statuses and persist it in database.
1. **httparty** allows to make requests to api stubs. This way stubs emulate behaviour of a fake live service.

# Setup
### 1. Versions
Make sure you have the latest stable ruby version which is currently for this project - 2.7.0

In addition, you need to install Redis (currently it's redis-5.0.7 used). Redis is used by background worker Sidekiq.

### 2. Bundle up
Go to the project's directory in your command line `bundle install` or simply `bundle`.

# Launch the project
### 1. Database setup
Find database.yml.sample and configure your own database.yml out of it.

Then run:
```
bundle exec rails db:create && bundle exec rails db:migrate
```

### 2. Launch the apps
Run the following to start Redis:
```
redis-server
```

Launch Rails app:
```
bundle exec rails s
```

Launch Sidekiq:
```
bundle exec sidekiq -C ./config/sidekiq.yml
```



# How to use API
To send requests to API you can use Postman's desktop app.

To see what is going on with requests you can go to `http://localhost:3000/sidekiq` (the 'Live poll' button can be handy too).
 
**Request fields**

Parameter | Type | Required?
------------ | ------------- | -------------
message | string | yes
send_to | array | yes
schedule_at | array | no
messenger_type | string | yes
phone_number | string | yes

JSON body example:
```
{
  "message": "Some message",
  "receiver": [
    {
      "messenger_type": "viber",
      "phone_number": "79991234567891"
    }		
  ]
}
```

or with `schedule_at` option:

```
{
  "message": "Some message",
  "schedule_at": "2020-02-02 21:33:57.917883 +0300",
  "receiver": [
    {
      "messenger_type": "viber",
      "phone_number": "79991234567891"
    }		
  ]
}
```

**Note**: 20% of the time messengers' stubs will return error which is on purpose. It emulates the case when a service is unavailable so request can be retried again but no more than 4 times (set by default). 