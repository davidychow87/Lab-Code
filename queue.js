var tasks = [];

function task(callback) {
  // console.log("Start")
  setTimeout(function() {
    // console.log("Done with task");
    callback();
  }, 10000);
}

for(var i = 0; i < 10; i++) {
  tasks.push(task);
};
//
// console.log("tasks", tasks);
//
// var func = tasks.pop();
//
// func(function() {
//   console.log("DONE");
// });


var concurrency = 3, running = 0, complete = 0, index = 0;
var count = 1;
function next() {
  while(running < concurrency && index < tasks.length) {

      console.log("doing task no", count);
      count++;
      task = tasks[index++];
      task(function() {
        // console.log("done with tasks");
        console.log("*****************************************");
        // done(tasks);
        complete++, running--;
        next();
      });
      running++;
      // console.log("Running,", running, "conncurent", concurrency);
      // console.log("*****************************************");
  }
}

next();

function done(tasks) {
  console.log("Task length", tasks.length);
  if (tasks.length == 0) {
    return true;
  }
}
// console.log("HAHAH!");
