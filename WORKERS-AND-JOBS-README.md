How to use workers and enqueue jobs?
========================

## Start Redis
To start Redis, please run this command in your terminal:
```
  redis-server
```
We can check if the Redis server is working or not by running the below command:
```
  redis-cli ping  
```
In case Redis server is running, the result should be `PONG`.

## Start workers
```
  rake resque:work QUEUE=<worker_name>

```
Your worker's name maybe is `sleep`, `import_job`, etc. In this case, we will use a queue named `sleep`:
```
  rake resque:work sleep=QUEUE
```

## Enqueue Jobs
For example, we have a Sleeper job below. The main method `perform` receives two arguments are `seconds` and `message`:
```
  class Sleeper
    @queue = :sleep

    def self.perform(seconds, message)
      sleep(seconds)
      Rails.logger.warning(message)
    end
  end

```
Then we can enqueue some jobs for the worker like this:
```
  Resque.enqueue(Sleeper, 10, 'message for logging')
```
The job will be enqueued into the queue named `sleep` then executed automatically by Resque.