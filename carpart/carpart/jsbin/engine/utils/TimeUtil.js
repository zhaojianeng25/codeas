var TimeUtil = (function () {
    function TimeUtil() {
    }
    TimeUtil.getTimer = function () {
        return Date.now() - TimeUtil.START_TIME;
    };
    TimeUtil.getTimerSecond = function () {
        return TimeUtil.getTimer() / 1000;
    };
    //标记现在时间
    TimeUtil.saveNowTime = function () {
        this.lastTime = this.getTimer();
    };
    //得到使用的时间
    TimeUtil.getUseTime = function () {
        return this.getTimer() - this.lastTime;
    };
    /**
    * YYYY-mm-DD HH:MM
    **/
    TimeUtil.getLocalTime = function (nS) {
        var timestamp4 = new Date(nS * 1000); //直接用 new Date(时间戳) 格式转化获得当前时间1-00
        return timestamp4.toLocaleDateString().replace(/\//g, "-") + " " + timestamp4.toTimeString().substr(0, 5);
    };
    /**
     * HH:MM:SS
    **/
    TimeUtil.getLocalTime2 = function (nS) {
        var timestamp4 = new Date(nS * 1000 - 8 * 60 * 60 * 1000); //直接用 new Date(时间戳) 格式转化获得当前时间1-00
        return timestamp4.toTimeString().substr(0, 8);
    };
    /**
     * MM:SS
    **/
    TimeUtil.getLocalTime3 = function (nS) {
        var timestamp4 = new Date(nS * 1000); //直接用 new Date(时间戳) 格式转化获得当前时间1-00
        return timestamp4.toTimeString().substr(3, 5);
    };
    TimeUtil.init = function () {
        TimeUtil.START_TIME = Date.now();
    };
    TimeUtil.addTimeTick = function ($time, $fun, $beginTime) {
        if ($beginTime === void 0) { $beginTime = 0; }
        var timeFunTick = new TimeFunTick();
        timeFunTick.alltime = $time;
        timeFunTick.fun = $fun;
        timeFunTick.time = $time - $beginTime;
        TimeUtil.timefunAry.push(timeFunTick);
    };
    TimeUtil.removeTimeTick = function ($fun) {
        for (var i = 0; i < TimeUtil.timefunAry.length; i++) {
            if (TimeUtil.timefunAry[i].fun == $fun) {
                TimeUtil.timefunAry.splice(i, 1);
                break;
            }
        }
    };
    TimeUtil.addTimeOut = function ($time, $fun) {
        if (this.hasTimeOut($fun)) {
            return;
        }
        var timeFunTick = new TimeFunOut();
        timeFunTick.alltime = $time;
        timeFunTick.fun = $fun;
        timeFunTick.time = 0;
        TimeUtil.outTimeFunAry.push(timeFunTick);
    };
    TimeUtil.removeTimeOut = function ($fun) {
        for (var i = 0; i < TimeUtil.outTimeFunAry.length; i++) {
            if (TimeUtil.outTimeFunAry[i].fun == $fun) {
                TimeUtil.outTimeFunAry.splice(i, 1);
                break;
            }
        }
    };
    TimeUtil.hasTimeOut = function ($fun) {
        for (var i = 0; i < TimeUtil.outTimeFunAry.length; i++) {
            if (TimeUtil.outTimeFunAry[i].fun == $fun) {
                return true;
            }
        }
        return false;
    };
    TimeUtil.addFrameTick = function ($fun) {
        if (TimeUtil.funAry.indexOf($fun) == -1) {
            TimeUtil.funAry.push($fun);
        }
    };
    TimeUtil.hasFrameTick = function ($fun) {
        var index = TimeUtil.funAry.indexOf($fun);
        if (index != -1) {
            return true;
        }
        return false;
    };
    TimeUtil.removeFrameTick = function ($fun) {
        var index = TimeUtil.funAry.indexOf($fun);
        if (index != -1) {
            TimeUtil.funAry.splice(index, 1);
        }
    };
    TimeUtil.update = function () {
        var dtime = TimeUtil.getTimer() - TimeUtil.time;
        for (var i = 0; i < TimeUtil.funAry.length; i++) {
            TimeUtil.funAry[i](dtime);
        }
        for (var i = 0; i < TimeUtil.timefunAry.length; i++) {
            TimeUtil.timefunAry[i].update(dtime);
        }
        for (var i = TimeUtil.outTimeFunAry.length - 1; i >= 0; i--) {
            if (TimeUtil.outTimeFunAry[i].update(dtime)) {
                TimeUtil.outTimeFunAry.splice(i, 1);
            }
        }
        TimeUtil.time = TimeUtil.getTimer();
    };
    TimeUtil.funAry = new Array;
    TimeUtil.timefunAry = new Array;
    TimeUtil.outTimeFunAry = new Array;
    TimeUtil.time = 0;
    TimeUtil.lastTime = 0;
    return TimeUtil;
})();
var TimeFunTick = (function () {
    function TimeFunTick() {
        this.alltime = 0;
        this.time = 0;
    }
    TimeFunTick.prototype.update = function (t) {
        this.time += t;
        if (this.time >= this.alltime) {
            this.fun();
            this.time = 0;
        }
    };
    return TimeFunTick;
})();
var TimeFunOut = (function () {
    function TimeFunOut() {
        this.alltime = 0;
        this.time = 0;
    }
    TimeFunOut.prototype.update = function (t) {
        this.time += t;
        if (this.time >= this.alltime) {
            this.fun();
            return true;
        }
        return false;
    };
    return TimeFunOut;
})();
//# sourceMappingURL=TimeUtil.js.map