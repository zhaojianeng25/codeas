

interface ITest {
    name: string;
    age: number;
    run();
    to(x: number, y: number): number;
}

class CarOptions implements CANNON.IWheelInfoOptions {
  
    worldTransform: any
    chassisConnectionPointLocal: CANNON.Vec3;
    chassisConnectionPointWorld: CANNON.Vec3;
    directionLocal: CANNON.Vec3;
    directionWorld: CANNON.Vec3;
    axleLocal: CANNON. Vec3;
    axleWorld: CANNON.Vec3;
    suspensionRestLength: number;
    suspensionMaxLength: number;
    radius: number;
    suspensionStiffness: number;
    dampingCompression: number;
    dampingRelaxation: number;
    frictionSlip: number;
    steering: number;
    engineForce: number
    rotation: number;
    deltaRotation: number;
    rollInfluence: number;
    maxSuspensionForce: number;
    isFrontWheel: boolean;
    clippedInvContactDotSuspension: number;
    suspensionRelativeVelocity: number;
    suspensionForce: number;
    skidInfo: number;
    suspensionLength: number;
    maxSuspensionTravel: number;
    useCustomSlidingRotationalSpeed: boolean;
    customSlidingRotationalSpeed: number;
    position: CANNON.Vec3;
    direction: CANNON.Vec3;
    axis: CANNON.Vec3;
    body: CANNON.Body;
    constructor() {
        this.radius = 0.5,
        this.directionLocal = new CANNON.Vec3(0, 0, -1),
        this.suspensionStiffness = 100,   //悬挂刚度
        this.suspensionRestLength = 0.5,   //悬挂休息长度
        this.frictionSlip = 10,            //摩擦滑
        this.dampingRelaxation = 10,  //阻尼放松
        this.dampingCompression = 2,  //阻尼压缩
        this.maxSuspensionForce = 10000,  //最大悬架力
        this.rollInfluence = 0.1,    //转弯倾斜
        this.axleLocal = new CANNON.Vec3(0, 1, 0),
        this.chassisConnectionPointLocal = new CANNON.Vec3(1, 1, 0),
        this.maxSuspensionTravel = 0.3,
        this.customSlidingRotationalSpeed = -30,
        this.useCustomSlidingRotationalSpeed = false;

        
     
    }

            /*
        var options: any = {
            radius: 0.5,
            directionLocal: new CANNON.Vec3(0, 0, -1),
            suspensionStiffness: 100,   //悬挂刚度
            suspensionRestLength: 0.5,   //悬挂休息长度
            frictionSlip:10,            //摩擦滑
            dampingRelaxation: 0,  //阻尼放松
            dampingCompression: 4.4,
            maxSuspensionForce: 100000,
            rollInfluence: 0.01,
            axleLocal: new CANNON.Vec3(0, 1, 0),
            chassisConnectionPointLocal: new CANNON.Vec3(1, 1, 0),
            maxSuspensionTravel: 0.3,
            customSlidingRotationalSpeed: -30,
            useCustomSlidingRotationalSpeed: true
        };

        */
}

class CarBodySprite extends BaseMachine  {
    constructor($x: number = 0, $y: number = 0, $z: number = 0) {
        super($x, $y, $z);
    }
    protected initData(): void {
        this.makeCarBody();
        this.updateMatrix();
    }


    public carvehicle: CANNON.RaycastVehicle
    private makeCarBody(): void {
        var world: CANNON.World = Physics.world;
        var mass:number = 120;
      
        //world.defaultContactMaterial.friction = 0;
        var chassisShape: CANNON.Box = new CANNON.Box(new CANNON.Vec3(2, 1, 0.5));
        var chassisBody :CANNON.Body= new CANNON.Body({ mass: mass });
        chassisBody.addShape(chassisShape);


        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(chassisBody)
        $disLock.addToWorld();



        // Create the vehicle
        var vehicle: CANNON.RaycastVehicle = new CANNON.RaycastVehicle({
            chassisBody: chassisBody,
        });

        var options: CarOptions = new CarOptions()


        options.chassisConnectionPointLocal.set(1, 1, 0);
        vehicle.addWheel(options);

        options.chassisConnectionPointLocal.set(1, -1, 0);
        vehicle.addWheel(options);

        options.chassisConnectionPointLocal.set(-1, 1, 0);
        vehicle.addWheel(options);

        options.chassisConnectionPointLocal.set(-1, -1, 0);
        vehicle.addWheel(options);

        vehicle.addToWorld(world);

        var wheelBodies: Array<CANNON.Body> = new Array;
        for (var i = 0; i < vehicle.wheelInfos.length; i++) {
            var wheel = vehicle.wheelInfos[i];
            var cylinderShape = new CANNON.Cylinder(wheel.radius, wheel.radius, wheel.radius / 2, 20);
            var wheelBody: CANNON.Body = new CANNON.Body({
                mass: 0
            });
            wheelBody.type = CANNON.Body.KINEMATIC;
            wheelBody.collisionFilterGroup = 0; // turn off collisions
            var q = new CANNON.Quaternion();
            q.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), Math.PI / 2);
            wheelBody.addShape(cylinderShape, new CANNON.Vec3(), q);
            wheelBodies.push(wheelBody);

            var $disLock: CanonPrefabSprite = new CanonPrefabSprite(wheelBody)
            $disLock.addToWorld();
        }
   
        // Update wheels
        world.addEventListener('postStep', function () {
            for (var i = 0; i < vehicle.wheelInfos.length; i++) {
                vehicle.updateWheelTransform(i);
                var t: any = vehicle.wheelInfos[i].worldTransform;

                var wheelBody = wheelBodies[i];
                wheelBody.position.copy(t.position);
                wheelBody.quaternion.copy(t.quaternion);
            }
        });
        this.carvehicle = vehicle;


    }
    public getBodyRotationY(): number {
        var $ma: Matrix3D = new Matrix3D
        Physics.MathBody2WMatrix3D(this.carvehicle.chassisBody, $ma)
        var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5(this.carvehicle.chassisBody.shapeOrientations[0]);
        var $m: Matrix3D = $shapeQua.toMatrix3D();
        $ma.prepend($m);

        $shapeQua.fromMatrix($ma)
        $shapeQua.toMatrix3D($ma)

        var $p: Vector3D = $ma.transformVector(new Vector3D(1, 0, 0));
        return Math.atan2($p.z, $p.x) ;
    }
    protected  lastpos:Vector3D
    public updateMatrix(): void {
        if (this.carvehicle) {
            this.carvehicle.chassisBody.position = Physics.Vec3dW2C(new Vector3D(this._x, this._y, this._z));
        }
    }

    public upData(): void {

        var $ma: Matrix3D = new Matrix3D;
        Physics.MathBody2WMatrix3D(this.carvehicle.chassisBody, $ma);

        var $shapeQua: Quaternion = Physics.QuaternionCollisionToH5(this.carvehicle.chassisBody.shapeOrientations[0]);
        var $pos: Vector3D = $ma.position;
        this._x = $pos.x
        this._y = $pos.y
        this._z = $pos.z
        var $angle: Vector3D = $shapeQua.toEulerAngles();
        this._rotationX = $angle.x;
        this._rotationY = $angle.y;
        this._rotationZ = $angle.z;

        super.upData();

      

    }
   

}