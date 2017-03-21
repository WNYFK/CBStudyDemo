
require('CBTestViewController')

defineClass('CBTestViewController', {
            testBlock: function () {
            self.testObject().finished(block(function(dict) {
                                              console.log('eeeeee: ' + dict)
                                             }));
            }
            })
