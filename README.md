#Setup
### 1. Versions
Make sure you have the latest stable ruby version which is currently for this project - 2.7.0

In addition, you need to install Redis (currently it's redis-5.0.7 used). Redis is used by background worker Sidekiq.

### 2. Bundle up
Go to the project's directory in your command line `bundle install` or simply `bundle`.

#Launch the project
### 1. Launch redis server
Run the following in your command line:
```
redis-server
```
### 2. Launch the Rails app and Sidekiq

Launch Rails app:
```
bundle exec rails s
```

Launch Sidekiq:
```
bundle exec sidekiq -C ./config/sidekiq.yml
```

JSON payload example:
```
{
  "message": "Some message",
  "receiver": [
    {
      "messenger_type": "viber",
      "uid": "79991234567891"
    }		
  ]
}
```

or with `schedule_at` option:

```
{
  "message": "Some message",
  "schedule_at": "01/02/2020 15:31:29",
  "receiver": [
    {
      "messenger_type": "viber",
      "uid": "79991234567891"
    }		
  ]
}
```