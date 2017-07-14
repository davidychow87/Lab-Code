const express = require('express');
const morgan = require('morgan');
const path = require('path');

const app = express();
const bodyParser = require('body-parser');
const PORT = process.env.PORT || 3001;

app.use(morgan(':remote-addr - :remote-user [:date[clf]] ":method :url HTTP/:http-version" :status :res[content-length]'));

app.use(bodyParser.json());

app.use(express.static('client'));

app.use('/', require('./server/routes')(app, express));

app.get('/', (req, res) => {
  // res.send('index');

  console.log("HAHAH1");
});

app.get('/lolz', (req, res) => {
  function task(callback) {
    // console.log("Start")
    setTimeout(function() {
      // console.log("Done with task");
      callback();
    }, 10000);
  }
  // res.send('index');
  class TaskQueue {
    constructor(concurrency, callback) {
      this.concurrency = concurrency;
      this.running = 0;
      this.queue = [];
        this.count = 1;
        this.callback = callback;
    }

    pushTask(task) {
      this.queue.push(task);
      this.next();
    }



    next() {
      while(this.running < this.concurrency && this.queue.length) {
        const task = this.queue.shift();
        // this.count ++;
        console.log("Pushing a task");
        // console.log("Queuelength", this.queue.length);
        task(() => {


          console.log("Count done", this.count);
          this.count++;
          // console.log("Done task");
          // if(this.queue.length == 0) {
          //   console.log("Finished here!");
          //   return true;
          // }
          this.running--;
          this.next();

        });
        this.running++;
      }
      console.log("queue length", this.queue.length, "running", this.running);
      if(this.queue.length === 0 && this.running == 0) {
        console.log("FINISHED - count", this.count);
        this.callback();
      }
    }
  }

function done(done) {
  console.log("FINISEHDSEDDSDSDS");
}

  let taskQueue = new TaskQueue(3, done);
  let tasks = [];
  for(var i = 0; i < 10; i++) {
    tasks.push(task);
  };

  tasks.forEach(task => {
    taskQueue.pushTask(task)

  })

  // console.log("tasksk", tasks);




});

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}!`);
});
