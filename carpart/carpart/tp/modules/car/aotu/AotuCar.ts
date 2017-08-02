class CarParkStateMesh {
    public type: number=0;
    public sotpVec: Vector3D;
    public car: AotuCar;
    constructor($car:AotuCar) {
        this.car = $car;
    }

    private lastPos:Vector3D
    public moveToParkPos(): void
    {

        var $bodyPos: Vector3D = Physics.Vect3dC2W(this.car.carvehicle.chassisBody.position);

        if (this.lastPos) {
        
            if (Vector3D.distance($bodyPos, this.sotpVec) > Vector3D.distance(this.lastPos, this.sotpVec)) {
                this.type = 1;

                var brakeNum:number=10
                this.car.carvehicle.setBrake(brakeNum, 0);
                this.car.carvehicle.setBrake(brakeNum, 1);
                this.car.carvehicle.setBrake(brakeNum, 2);
                this.car.carvehicle.setBrake(brakeNum, 3);

                console.log("指定点到达")

                return
            }
            
        }
        this.lastPos = $bodyPos.clone();

        var $nmr3d: Vector3D = this.sotpVec.subtract($bodyPos)
        $nmr3d.y = 0;
        $nmr3d.normalize();
        var $anlgey: number = Math.atan2($nmr3d.z, $nmr3d.x) * 180 / Math.PI;
        var $baseRotation: number = this.car.getBodyRotationY();

        var p0: CANNON.Vec3 = new CANNON.Vec3(0, 0, 1)
        this.car.carvehicle.getVehicleAxisWorld(0, p0)


        var $r: number = Math.atan2($nmr3d.z, $nmr3d.x);
        $r = $r - $baseRotation;


        this.car.carvehicle.setSteeringValue($r, 0);
        this.car.carvehicle.setSteeringValue($r, 1);

        var forceNum: number = -20;
        this.car.carvehicle.applyEngineForce(forceNum, 0);
        this.car.carvehicle.applyEngineForce(forceNum, 1);

       
    }

}

class AotuCar extends CarBodySprite {


    private modelScenePerfab: ScenePerfab;
    constructor($x: number = 0, $y: number = 0, $z: number = 0) {
        super($x, $y, $z);
    }
    protected initData(): void {
        super.initData();
        this.inidModel();
    }
    private inidModel(): void {
        this.modelScenePerfab = new ScenePerfab();
        SceneManager.getInstance().addMovieDisplay(this.modelScenePerfab);
        this.modelScenePerfab.setPerfabName("6409");

    }

   

    public upData(): void {
        super.upData();
        if (this.carvehicle) {


            this.findnextMove()
            this.toParkCar()


            var $ma: Matrix3D = new Matrix3D;
            Physics.MathBody2WMatrix3D(this.carvehicle.chassisBody, $ma);
            this.modelScenePerfab.posMatrix.m = $ma.m;
            var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5(this.carvehicle.chassisBody.shapeOrientations[0]);
            var $m: Matrix3D = $shapeQua.toMatrix3D();
            this.modelScenePerfab.posMatrix.prepend($m);



        }
    }
    private isParking:boolean=false
    private toParkCar(): void
    {
        if (this.carParkStateMesh) {
            switch (this.carParkStateMesh.type) {
                case 0:
                    this.carParkStateMesh.moveToParkPos();
                    break;
                case 1:
                    break;
                default:
                    break;
            }



        }

    }

    private canMoveTo: boolean = false
    public tureOn(): void {
     



        /*
        var forceNum: number = 10;
        this.carvehicle.applyEngineForce(forceNum, 0);
        this.carvehicle.applyEngineForce(forceNum, 1);

        */
        var $r:number=0*Math.PI/180
        this.carvehicle.setSteeringValue($r, 0);
        this.carvehicle.setSteeringValue($r, 1);

        var forceNum: number = -100;
        this.carvehicle.applyEngineForce(forceNum, 0);
        this.carvehicle.applyEngineForce(forceNum, 1);

   
        var $num: number = 0;

        this.carvehicle.setBrake($num, 0)
        this.carvehicle.setBrake($num, 1)
        this.carvehicle.setBrake($num, 2)
        this.carvehicle.setBrake($num, 3)
      
    }
    public tureOff(): void {
        this.carvehicle.applyEngineForce(0, 0);
        this.carvehicle.applyEngineForce(0, 1);
        this.carvehicle.applyEngineForce(0, 2);
        this.carvehicle.applyEngineForce(0, 3);


        var $num: number = 10.1;

        this.carvehicle.setBrake($num, 0)
        this.carvehicle.setBrake($num, 1)
        this.carvehicle.setBrake($num, 2)
        this.carvehicle.setBrake($num, 3)



    }
    private roadItem:Array<Vector3D>
    public pointTopoint(): void {
      //  this.canMoveTo = true
        this.roadItem = new Array();

        var $baseArr: Array<Vector3D> = new Array;
        $baseArr.push(new Vector3D());
        $baseArr.push(new Vector3D(100, 0, 50));
        $baseArr.push(new Vector3D(200, 0, -50));
        $baseArr.push(new Vector3D(100, 0, -150));


        for (var i: number = 0; i < $baseArr.length; i++) {
            var a: Vector3D = $baseArr[i];
            var b: Vector3D = $baseArr[i];
            if (i > 0) {
                a = $baseArr[i - 1];
            }
            if (i < ($baseArr.length - 1)) {
                b = $baseArr[i + 1];
            }
            $baseArr[i].w = -this.getRotation(a, b) * 180 / Math.PI;
            if (i > 0) {
                this.makeBezierData($baseArr[i - 1], $baseArr[i]);
            }
        }
        this.roadItem.push($baseArr[$baseArr.length - 1]);

        this.canMoveTo = true;
  
  
        //this.showPoint()

    }
    private carParkStateMesh: CarParkStateMesh;
    public playToParking(): void
    {


        this.carParkStateMesh = new CarParkStateMesh(this);
        this.carParkStateMesh.sotpVec = new Vector3D(150, 0, 100);

        ShowDisModel.getInstance().addTempHit(this.carParkStateMesh.sotpVec);

    }
    private showPoint(): void
    {
        for (var i: number = 0; i < this.roadItem.length; i++) {
            console.log(this.roadItem[i])
        }
    }

    private makeBezierData(a: Vector3D, d: Vector3D): void {
        var $m: Matrix3D = new Matrix3D
        var $dis: number = Vector3D.distance(a, d) / 4;
        $m.identity();
        $m.appendRotation(a.w, Vector3D.Y_AXIS);
        $m.appendTranslation(a.x, a.y, a.z);
        var b: Vector3D = $m.transformVector(new Vector3D($dis, 0, 0))

        $m.identity();
        $m.appendRotation(d.w, Vector3D.Y_AXIS);
        $m.appendTranslation(d.x, d.y, d.z);
        var c: Vector3D = $m.transformVector(new Vector3D(-$dis, 0, 0))

        for (var i: number = 0; i < 5; i++) {
            var $ve: any = MathClass.drawbezier([a,b,c,d], i / 5)
            var $kk: Vector3D = new Vector3D($ve.x, $ve.y, $ve.z);
            this.roadItem.push($kk);
            ShowDisModel.getInstance().addTempHit($kk);

        }

    }
    private getRotation(a: Vector3D, b: Vector3D): number {
        var $nrm: Vector3D = b.subtract(a);
        return Math.atan2($nrm.z, $nrm.x);
    }
  
   


    private toPos: Vector3D
    private findnextMove(): void
    {
    
        if (this.canMoveTo) {;

            var $bodyPos: Vector3D = Physics.Vect3dC2W(this.carvehicle.chassisBody.position);
            this.isdriveEnd();
      

            var $nmr3d: Vector3D = this.toPos.subtract($bodyPos)
            $nmr3d.y = 0;
            $nmr3d.normalize();
            var $anlgey: number = Math.atan2($nmr3d.z, $nmr3d.x) * 180 / Math.PI;
            var $baseRotation: number = this.getBodyRotationY();
      
            var p0: CANNON.Vec3 = new CANNON.Vec3(0, 0, 1)
            this.carvehicle.getVehicleAxisWorld(0, p0)
          //  console.log(p0)

            //console.log($baseRotation * 180 / Math.PI);
            //console.log($anlgey);
            //console.log("--------------------------");

            var $r: number = Math.atan2($nmr3d.z, $nmr3d.x);
            $r = $r - $baseRotation;


            this.carvehicle.setSteeringValue($r, 0);
            this.carvehicle.setSteeringValue($r, 1);

            var forceNum: number = -20;
            this.carvehicle.applyEngineForce(forceNum, 0);
            this.carvehicle.applyEngineForce(forceNum, 1);

        }
    }
    private isdriveEnd(): void
    {
        var $bodyPos: Vector3D = Physics.Vect3dC2W(this.carvehicle.chassisBody.position);
        var nearId: number;
        var dis: number;
        for (var i: number = 0; i < this.roadItem.length; i++) {
            if (dis) {
                if (dis > Vector3D.distance($bodyPos, this.roadItem[i])) {
                    dis = Vector3D.distance($bodyPos, this.roadItem[i])
                    nearId = i
                }
            } else {
                nearId = 0
                dis = Vector3D.distance($bodyPos, this.roadItem[i])
            }
        }
        this.curFrameId = nearId + 1
        if (this.curFrameId < this.roadItem.length) {
            this.toPos = this.roadItem[this.curFrameId];
        }

    
    }

    public getAngle( cen:Vector2D,  first:Vector2D,  second:Vector2D) :number
    { 
        var dx1, dx2, dy1, dy2;
        var  angle:number
        dx1 = first.x - cen.x;
        dy1 = first.y - cen.y;
        dx2 = second.x - cen.x;
        dy2 = second.y - cen.y;
        var c = Math.sqrt(dx1 * dx1 + dy1 * dy1) * Math.sqrt(dx2 * dx2 + dy2 * dy2);
        if (c == 0) return -1;
        angle = Math.acos((dx1 * dx2 + dy1 * dy2) / c);
        return angle;
    } 
    private curFrameId: number = 1



}