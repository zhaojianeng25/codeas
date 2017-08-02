var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CarBodySprite = (function (_super) {
    __extends(CarBodySprite, _super);
    function CarBodySprite(value) {
        _super.call(this, value);
    }
    CarBodySprite.prototype.mathPosMatrix = function () {
        var $ma = new Matrix3D;
        Physics.MathBody2WMatrix3D(this.body, $ma);
        this.posMatrix.m = $ma.m;
        var $shapeQua = Physics.QuaternionCollisionToH5(this.body.shapeOrientations[0]);
        var $m = $shapeQua.toMatrix3D();
        this.posMatrix.prepend($m);
        this.posMatrix.prependRotation(-90, Vector3D.Y_AXIS);
        var $scale = 0.8;
        this.posMatrix.prependScale($scale, $scale, $scale);
        this.posMatrix.prependTranslation(0, -0, 5);
    };
    return CarBodySprite;
})(CanonPrefabSprite);
//# sourceMappingURL=CarBodySprite.js.map