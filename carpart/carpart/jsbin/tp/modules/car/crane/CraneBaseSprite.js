var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CraneBaseSprite = (function (_super) {
    __extends(CraneBaseSprite, _super);
    function CraneBaseSprite($x, $y, $z) {
        if ($x === void 0) { $x = 0; }
        if ($y === void 0) { $y = 0; }
        if ($z === void 0) { $z = 0; }
        _super.call(this, $x, $y, $z);
    }
    CraneBaseSprite.prototype.initData = function () {
        _super.prototype.initData.call(this);
        this.addEvent();
        this.inidModel();
    };
    CraneBaseSprite.prototype.inidModel = function () {
        this.modelScenePerfab = new ScenePerfab();
        SceneManager.getInstance().addMovieDisplay(this.modelScenePerfab);
        this.modelScenePerfab.setPerfabName("6409");
    };
    CraneBaseSprite.prototype.upData = function () {
        _super.prototype.upData.call(this);
        if (this.carvehicle) {
            var $ma = new Matrix3D;
            Physics.MathBody2WMatrix3D(this.carvehicle.chassisBody, $ma);
            this.modelScenePerfab.posMatrix.m = $ma.m;
            var $shapeQua = Physics.QuaternionCollisionToH5(this.carvehicle.chassisBody.shapeOrientations[0]);
            var $m = $shapeQua.toMatrix3D();
            this.modelScenePerfab.posMatrix.prepend($m);
            var $vo0 = this.carvehicle.wheelInfos[0];
            var $vo1 = this.carvehicle.wheelInfos[1];
            //  console.log($vo0.worldTransform.position);
            //  console.log($vo1.worldTransform.position);
            var a0 = new CANNON.Vec3;
            this.carvehicle.getVehicleAxisWorld(1, a0);
            //     console.log(a0)
            var t = this.carvehicle.wheelInfos[1].worldTransform;
        }
    };
    CraneBaseSprite.prototype.addEvent = function () {
        var _this = this;
        document.addEventListener(MouseType.KeyDown, function ($evt) { _this.onKeyDown($evt); });
        document.addEventListener(MouseType.KeyUp, function ($evt) { _this.onKeyDown($evt); });
    };
    CraneBaseSprite.prototype.onKeyDown = function ($evt) {
        if (this.carvehicle) {
            this.keyCodeTo($evt);
        }
    };
    CraneBaseSprite.prototype.clearForce = function () {
        this.carvehicle.chassisBody.velocity.set(0, 0, 0);
    };
    CraneBaseSprite.prototype.keyCodeTo = function (event) {
        var maxSteerVal = 0.5;
        var maxForce = 3 * 100;
        var brakeForce = 1000000;
        var vehicle = this.carvehicle;
        var up = (event.type == 'keyup');
        if (!up && event.type !== 'keydown') {
            return;
        }
        vehicle.setBrake(0, 0);
        vehicle.setBrake(0, 1);
        vehicle.setBrake(0, 2);
        vehicle.setBrake(0, 3);
        switch (event.keyCode) {
            case 38:
                vehicle.applyEngineForce(up ? 0 : -maxForce, 2);
                vehicle.applyEngineForce(up ? 0 : -maxForce, 3);
                break;
            case 40:
                vehicle.applyEngineForce(up ? 0 : maxForce, 2);
                vehicle.applyEngineForce(up ? 0 : maxForce, 3);
                break;
            case 66:
                vehicle.setBrake(brakeForce, 0);
                vehicle.setBrake(brakeForce, 1);
                vehicle.setBrake(brakeForce, 2);
                vehicle.setBrake(brakeForce, 3);
                break;
            case 39:
                vehicle.setSteeringValue(up ? 0 : -maxSteerVal, 0);
                vehicle.setSteeringValue(up ? 0 : -maxSteerVal, 1);
                break;
            case 37:
                vehicle.setSteeringValue(up ? 0 : maxSteerVal, 0);
                vehicle.setSteeringValue(up ? 0 : maxSteerVal, 1);
                break;
        }
    };
    return CraneBaseSprite;
})(CarBodySprite);
//# sourceMappingURL=CraneBaseSprite.js.map