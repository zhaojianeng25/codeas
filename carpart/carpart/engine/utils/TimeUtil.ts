class TimeUtil {
    static START_TIME: number;
    public static funAry: Array<Function> = new Array;
    public static timefunAry: Array<TimeFunTick> = new Array;
    public static outTimeFunAry: Array<TimeFunOut> = new Array;
    public static time: number=0;
    
    public static getTimer(): number {
        return Date.now() - TimeUtil.START_TIME;
    }

    public static getTimerSecond(): number {
        return TimeUtil.getTimer() / 1000;
    }

    private static lastTime: number=0;
    //标记现在时间
    public static saveNowTime(): void
    {
        this.lastTime=this.getTimer()
    }
    //得到使用的时间
    public static getUseTime(): number
    {
        return this.getTimer()-this.lastTime 
    }

     /**
     * YYYY-mm-DD HH:MM
     **/
    public static getLocalTime(nS: number): string {
  

        var timestamp4 = new Date(nS*1000);//直接用 new Date(时间戳) 格式转化获得当前时间1-00


        return timestamp4.toLocaleDateString().replace(/\//g, "-") + " " + timestamp4.toTimeString().substr(0, 5)



    }

    /**
     * HH:MM:SS
    **/
    public static getLocalTime2(nS: number): string {

 
        var timestamp4 = new Date(nS * 1000 - 8 * 60 * 60 * 1000);//直接用 new Date(时间戳) 格式转化获得当前时间1-00

        return timestamp4.toTimeString().substr(0, 8)

    }

    /**
     * MM:SS
    **/
    public static getLocalTime3(nS: number): string {


        var timestamp4 = new Date(nS * 1000);//直接用 new Date(时间戳) 格式转化获得当前时间1-00
        
        return timestamp4.toTimeString().substr(3, 5)

    }
 

    public static init(): void {
        TimeUtil.START_TIME = Date.now();
    }


    public static addTimeTick($time: number, $fun: Function, $beginTime: number = 0): void {
        var timeFunTick: TimeFunTick = new TimeFunTick();
        timeFunTick.alltime = $time;
        timeFunTick.fun = $fun;
        timeFunTick.time = $time - $beginTime;
        TimeUtil.timefunAry.push(timeFunTick);
    }

    public static removeTimeTick($fun: Function): void {
        for (var i: number = 0; i < TimeUtil.timefunAry.length; i++){

            if(TimeUtil.timefunAry[i].fun == $fun){
                TimeUtil.timefunAry.splice(i, 1);
                break;
            }

        }
    }

    public static addTimeOut($time: number, $fun: Function): void {
        if(this.hasTimeOut($fun)){
            return;
        }
        var timeFunTick: TimeFunOut = new TimeFunOut();
        timeFunTick.alltime = $time;
        timeFunTick.fun = $fun;
        timeFunTick.time = 0;
        TimeUtil.outTimeFunAry.push(timeFunTick);
    }

    public static removeTimeOut($fun: Function): void {
        for (var i: number = 0; i < TimeUtil.outTimeFunAry.length; i++){

            if(TimeUtil.outTimeFunAry[i].fun == $fun){
                TimeUtil.outTimeFunAry.splice(i, 1);
                break;
            }

        }
    }

    public static hasTimeOut($fun: Function): boolean {
        for (var i: number = 0; i < TimeUtil.outTimeFunAry.length; i++){

            if(TimeUtil.outTimeFunAry[i].fun == $fun){
                return true;
            }

        }
        return false;
    }



    public static addFrameTick($fun:Function): void {
        if(TimeUtil.funAry.indexOf($fun) == -1){
            TimeUtil.funAry.push($fun); 
        }
    }

    public static hasFrameTick($fun: Function): boolean {
        var index: number = TimeUtil.funAry.indexOf($fun);
        if (index != -1) {
            return true;
        }
        return false;
    }

    public static removeFrameTick($fun: Function): void {
        var index: number = TimeUtil.funAry.indexOf($fun);
        if (index != -1){
            TimeUtil.funAry.splice(index, 1);
        }
    }

    public static update(): void {
        var dtime: number = TimeUtil.getTimer() - TimeUtil.time;

        for (var i: number = 0; i < TimeUtil.funAry.length; i++){
            TimeUtil.funAry[i](dtime);
        }
        

        for (var i: number = 0; i < TimeUtil.timefunAry.length; i++){
            TimeUtil.timefunAry[i].update(dtime);
        }

        for (var i: number = TimeUtil.outTimeFunAry.length - 1; i >= 0; i--){
            if (TimeUtil.outTimeFunAry[i].update(dtime)){
                TimeUtil.outTimeFunAry.splice(i, 1);
            }
        }

        TimeUtil.time = TimeUtil.getTimer();
    }

}

class TimeFunTick {
    public alltime: number = 0;
    public time: number = 0;
    public fun: Function;
    public update(t:number): void {
        this.time += t;
        if (this.time >= this.alltime){
            this.fun();
            this.time = 0;
        }
    }
}

class TimeFunOut {
    public alltime: number = 0;
    public time: number = 0;
    public fun: Function;
    public update(t: number): boolean {
        this.time += t;
        if (this.time >= this.alltime) {
            this.fun();
            return true;
        }
        return false;
    }
}

