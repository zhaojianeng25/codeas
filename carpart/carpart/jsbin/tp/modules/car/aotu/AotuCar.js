var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CarParkStateMesh = (function () {
    function CarParkStateMesh($car) {
        this.type = 0;
        this.car = $car;
    }
    CarParkStateMesh.prototype.moveToParkPos = function () {
        var $bodyPos = Physics.Vect3dC2W(this.car.carvehicle.chassisBody.position);
        if (this.lastPos) {
            if (Vector3D.distance($bodyPos, this.sotpVec) > Vector3D.distance(this.lastPos, this.sotpVec)) {
                this.type = 1;
                var brakeNum = 10;
                this.car.carvehicle.setBrake(brakeNum, 0);
                this.car.carvehicle.setBrake(brakeNum, 1);
                this.car.carvehicle.setBrake(brakeNum, 2);
                this.car.carvehicle.setBrake(brakeNum, 3);
                console.log("指定点到达");
                return;
            }
        }
        this.lastPos = $bodyPos.clone();
        var $nmr3d = this.sotpVec.subtract($bodyPos);
        $nmr3d.y = 0;
        $nmr3d.normalize();
        var $anlgey = Math.atan2($nmr3d.z, $nmr3d.x) * 180 / Math.PI;
        var $baseRotation = this.car.getBodyRotationY();
        var p0 = new CANNON.Vec3(0, 0, 1);
        this.car.carvehicle.getVehicleAxisWorld(0, p0);
        var $r = Math.atan2($nmr3d.z, $nmr3d.x);
        $r = $r - $baseRotation;
        this.car.carvehicle.setSteeringValue($r, 0);
        this.car.carvehicle.setSteeringValue($r, 1);
        var forceNum = -20;
        this.car.carvehicle.applyEngineForce(forceNum, 0);
        this.car.carvehicle.applyEngineForce(forceNum, 1);
    };
    return CarParkStateMesh;
})();
var AotuCar = (function (_super) {
    __extends(AotuCar, _super);
    function AotuCar($x, $y, $z) {
        if ($x === void 0) { $x = 0; }
        if ($y === void 0) { $y = 0; }
        if ($z === void 0) { $z = 0; }
        _super.call(this, $x, $y, $z);
        this.isParking = false;
        this.canMoveTo = false;
        this.curFrameId = 1;
    }
    AotuCar.prototype.initData = function () {
        _super.prototype.initData.call(this);
        this.inidModel();
    };
    AotuCar.prototype.inidModel = function () {
        this.modelScenePerfab = new ScenePerfab();
        SceneManager.getInstance().addMovieDisplay(this.modelScenePerfab);
        this.modelScenePerfab.setPerfabName("6409");
    };
    AotuCar.prototype.upData = function () {
        _super.prototype.upData.call(this);
        if (this.carvehicle) {
            this.findnextMove();
            this.toParkCar();
            var $ma = new Matrix3D;
            Physics.MathBody2WMatrix3D(this.carvehicle.chassisBody, $ma);
            this.modelScenePerfab.posMatrix.m = $ma.m;
            var $shapeQua = Physics.QuaternionCollisionToH5(this.carvehicle.chassisBody.shapeOrientations[0]);
            var $m = $shapeQua.toMatrix3D();
            this.modelScenePerfab.posMatrix.prepend($m);
        }
    };
    AotuCar.prototype.toParkCar = function () {
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
    };
    AotuCar.prototype.tureOn = function () {
        /*
        var forceNum: number = 10;
        this.carvehicle.applyEngineForce(forceNum, 0);
        this.carvehicle.applyEngineForce(forceNum, 1);

        */
        var $r = 0 * Math.PI / 180;
        this.carvehicle.setSteeringValue($r, 0);
        this.carvehicle.setSteeringValue($r, 1);
        var forceNum = -100;
        this.carvehicle.applyEngineForce(forceNum, 0);
        this.carvehicle.applyEngineForce(forceNum, 1);
        var $num = 0;
        this.carvehicle.setBrake($num, 0);
        this.carvehicle.setBrake($num, 1);
        this.carvehicle.setBrake($num, 2);
        this.carvehicle.setBrake($num, 3);
    };
    AotuCar.prototype.tureOff = function () {
        this.carvehicle.applyEngineForce(0, 0);
        this.carvehicle.applyEngineForce(0, 1);
        this.carvehicle.applyEngineForce(0, 2);
        this.carvehicle.applyEngineForce(0, 3);
        var $num = 10.1;
        this.carvehicle.setBrake($num, 0);
        this.carvehicle.setBrake($num, 1);
        this.carvehicle.setBrake($num, 2);
        this.carvehicle.setBrake($num, 3);
    };
    AotuCar.prototype.pointTopoint = function () {
        //  this.canMoveTo = true
        this.roadItem = new Array();
        var $baseArr = new Array;
        $baseArr.push(new Vector3D());
        $baseArr.push(new Vector3D(100, 0, 50));
        $baseArr.push(new Vector3D(200, 0, -50));
        $baseArr.push(new Vector3D(100, 0, -150));
        for (var i = 0; i < $baseArr.length; i++) {
            var a = $baseArr[i];
            var b = $baseArr[i];
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
    };
    AotuCar.prototype.playToParking = function () {
        this.carParkStateMesh = new CarParkStateMesh(this);
        this.carParkStateMesh.sotpVec = new Vector3D(150, 0, 100);
        ShowDisModel.getInstance().addTempHit(this.carParkStateMesh.sotpVec);
    };
    AotuCar.prototype.showPoint = function () {
        for (var i = 0; i < this.roadItem.length; i++) {
            console.log(this.roadItem[i]);
        }
    };
    AotuCar.prototype.makeBezierData = function (a, d) {
        var $m = new Matrix3D;
        var $dis = Vector3D.distance(a, d) / 4;
        $m.identity();
        $m.appendRotation(a.w, Vector3D.Y_AXIS);
        $m.appendTranslation(a.x, a.y, a.z);
        var b = $m.transformVector(new Vector3D($dis, 0, 0));
        $m.identity();
        $m.appendRotation(d.w, Vector3D.Y_AXIS);
        $m.appendTranslation(d.x, d.y, d.z);
        var c = $m.transformVector(new Vector3D(-$dis, 0, 0));
        for (var i = 0; i < 5; i++) {
            var $ve = MathClass.drawbezier([a, b, c, d], i / 5);
            var $kk = new Vector3D($ve.x, $ve.y, $ve.z);
            this.roadItem.push($kk);
            ShowDisModel.getInstance().addTempHit($kk);
        }
    };
    AotuCar.prototype.getRotation = function (a, b) {
        var $nrm = b.subtract(a);
        return Math.atan2($nrm.z, $nrm.x);
    };
    AotuCar.prototype.findnextMove = function () {
        if (this.canMoveTo) {
            ;
            var $bodyPos = Physics.Vect3dC2W(this.carvehicle.chassisBody.position);
            this.isdriveEnd();
            var $nmr3d = this.toPos.subtract($bodyPos);
            $nmr3d.y = 0;
            $nmr3d.normalize();
            var $anlgey = Math.atan2($nmr3d.z, $nmr3d.x) * 180 / Math.PI;
            var $baseRotation = this.getBodyRotationY();
            var p0 = new CANNON.Vec3(0, 0, 1);
            this.carvehicle.getVehicleAxisWorld(0, p0);
            //  console.log(p0)
            //console.log($baseRotation * 180 / Math.PI);
            //console.log($anlgey);
            //console.log("--------------------------");
            var $r = Math.atan2($nmr3d.z, $nmr3d.x);
            $r = $r - $baseRotation;
            this.carvehicle.setSteeringValue($r, 0);
            this.carvehicle.setSteeringValue($r, 1);
            var forceNum = -20;
            this.carvehicle.applyEngineForce(forceNum, 0);
            this.carvehicle.applyEngineForce(forceNum, 1);
        }
    };
    AotuCar.prototype.isdriveEnd = function () {
        var $bodyPos = Physics.Vect3dC2W(this.carvehicle.chassisBody.position);
        var nearId;
        var dis;
        for (var i = 0; i < this.roadItem.length; i++) {
            if (dis) {
                if (dis > Vector3D.distance($bodyPos, this.roadItem[i])) {
                    dis = Vector3D.distance($bodyPos, this.roadItem[i]);
                    nearId = i;
                }
            }
            else {
                nearId = 0;
                dis = Vector3D.distance($bodyPos, this.roadItem[i]);
            }
        }
        this.curFrameId = nearId + 1;
        if (this.curFrameId < this.roadItem.length) {
            this.toPos = this.roadItem[this.curFrameId];
        }
    };
    AotuCar.prototype.getAngle = function (cen, first, second) {
        var dx1, dx2, dy1, dy2;
        var angle;
        dx1 = first.x - cen.x;
        dy1 = first.y - cen.y;
        dx2 = second.x - cen.x;
        dy2 = second.y - cen.y;
        var c = Math.sqrt(dx1 * dx1 + dy1 * dy1) * Math.sqrt(dx2 * dx2 + dy2 * dy2);
        if (c == 0)
            return -1;
        angle = Math.acos((dx1 * dx2 + dy1 * dy2) / c);
        return angle;
    };
    return AotuCar;
})(CarBodySprite);
//# sourceMappingURL=AotuCar.js.map