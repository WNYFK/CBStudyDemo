
!function (name, context, definition) {
    if (typeof module != 'undefined' && module.exports) module.exports = definition()
    else if (typeof define == 'function' && define.amd) define(definition)
    else context[name] = definition()
}('Titans', this, function () {

    var context=this;

    var MODULE_IDS = 0;
    var METHOD_IDS = 1;
    var PARAMS = 2;
    var MIN_TIME_BETWEEN_FLUSHES_MS = 5;
    var isNative=false;

    function TitansConstruct() {
        this._queue = [[], [], [], 0];
        this._callbacks = [];
        this._callbackID = 0;
        this._callID = 0;
        this._lastFlush = 0;
        this._debugInfo = {};
        this._todoList=[];
    }

    TitansConstruct.prototype = {
        invokeCallback: function (cbID, args) {
            this.__invokeCallback(cbID, args);
        },
        callFunction: function (module, method, args, onFail, onSucc) {
            this.__nativeCall(module, method, args, onFail, onSucc);
        },
        flushedQueue: function () {
            var queue = this._queue;
            this._queue = [[], [], [], this._callID];
            return queue[0].length ? queue : null;
        },
        onReady: function (todo) {
            if (window.nativeFlushQueueImmediate) {
                todo && todo();
            } else {
                this._todoList.push(todo);
            }
        },
        __iamReady: function () {
            console.log(this);
            while (this._todoList.length) {
                var todo=this._todoList.shift();
                todo&&todo();
            }
        },
        __nativeCall: function (module, method, params, onFail, onSucc) {
            if (onFail || onSucc) {
                // eventually delete old debug info
                (this._callbackID > (1 << 5)) &&
                (this._debugInfo[this._callbackID >> 5] = null);

                this._debugInfo[this._callbackID >> 1] = [module, method];
                onFail && params.push(this._callbackID);
                this._callbacks[this._callbackID++] = onFail;
                onSucc && params.push(this._callbackID);
                this._callbacks[this._callbackID++] = onSucc;
            }

            this._callID++;

            this._queue[MODULE_IDS].push(module);
            this._queue[METHOD_IDS].push(method);
            this._queue[PARAMS].push(params);
            
            if (nativeFlushQueueImmediate) {
                nativeFlushQueueImmediate();
            }
        },
        __invokeCallback: function (cbID, args) {
            var callback = this._callbacks[cbID];
            var debug = this._debugInfo[cbID >> 1];
            this._callbacks[cbID & ~1] = null;
            this._callbacks[cbID | 1] = null;
            callback.apply(null, [args]);
        },
        __fetchQueue: function () {
            var messageQueue = this._queue.slice();
            this._queue = [[], [], [], 0];
            return messageQueue;
        }
    };

    context.Titans||(context.Titans=new TitansConstruct());
    return context.Titans
});
