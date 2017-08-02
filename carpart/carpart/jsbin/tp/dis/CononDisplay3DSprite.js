var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CononDisplay3DSprite = (function (_super) {
    __extends(CononDisplay3DSprite, _super);
    function CononDisplay3DSprite(value) {
        _super.call(this);
        this.body = value;
    }
    Object.defineProperty(CononDisplay3DSprite.prototype, "body", {
        get: function () {
            return this._body;
        },
        set: function (value) {
            this._body = value;
            this._bodyLineSprite = new CollisionDispaly3DSprite();
            this._bodyLineSprite.baseColor = new Vector3D(Math.random() * 0.5 + 0.5, Math.random() * 0.5 + 0.5, Math.random() * 0.5 + 0.5, 1);
            this._bodyLineSprite.setBody(this._body);
            this.mathBodyScale();
        },
        enumerable: true,
        configurable: true
    });
    CononDisplay3DSprite.prototype.mathBodyScale = function () {
        var $body = this._body;
        var arr = null;
        for (var i = 0; i < $body.shapes.length; i++) {
            var $shapePos = Physics.Vect3dC2W($body.shapeOffsets[i]);
            var $shapeQua = Physics.QuaternionCollisionToH5($body.shapeOrientations[i]);
            switch ($body.shapes[i].type) {
                case 1:
                    var $sphere = $body.shapes[i];
                    $shapePos.scaleBy(100 / $sphere.radius);
                    //  this.drawSphereConvexPolyh($sphere.radius, $shapePos, $shapeQua);
                    this.scaleX = $sphere.radius * 1;
                    this.scaleY = $sphere.radius * 1;
                    this.scaleZ = $sphere.radius * 1;
                    this.setModelById(9001);
                    break;
                case 4:
                    var $box = $body.shapes[i];
                    var $boxSize = Physics.Vect3dC2W($box.halfExtents);
                    this.scaleX = $boxSize.x * 0.4;
                    this.scaleY = $boxSize.y * 0.4;
                    this.scaleZ = $boxSize.z * 0.4;
                    this.setModelById(9002);
                    // this.drawBoxConvexPolyh($boxSize, $shapePos, $shapeQua)
                    break;
                case 16:
                    var $cylinder = $body.shapes[i];
                    var $scaleVec = this.drawCylinderConvexPolyh($cylinder, $shapePos, $shapeQua);
                    this.scaleX = $scaleVec.x * 1;
                    this.scaleY = $scaleVec.y * 1;
                    this.scaleZ = $scaleVec.x * 1;
                    this.setModelById(9003);
                    break;
                case 32:
                    var $heightField = $body.shapes[i];
                    //  this.drawFieldPolyh($heightField, $shapePos, $shapeQua);
                    break;
                case 64:
                    this.scaleX = 0.05;
                    this.scaleY = 0.05;
                    this.scaleZ = 0.05;
                    this.setModelById(9001);
                    break;
                default:
                    console.log("mathBodyScale", $body.shapes[i].type);
                    break;
            }
        }
    };
    CononDisplay3DSprite.prototype.drawCylinderConvexPolyh = function ($cylinder, $pos, $qua) {
        var m = new Matrix3D;
        $qua.toMatrix3D(m);
        m.invert();
        m.appendTranslation($pos.x, $pos.y, $pos.z);
        var $radius = 0;
        var $height = 0;
        for (var i = 0; i < $cylinder.faces.length; i++) {
            var a = $cylinder.faces[i][0];
            var b = $cylinder.faces[i][1];
            var c = $cylinder.faces[i][2];
            var d = $cylinder.faces[i][3];
            var A = Physics.Vect3dC2W($cylinder.vertices[a]);
            var B = Physics.Vect3dC2W($cylinder.vertices[b]);
            var C = Physics.Vect3dC2W($cylinder.vertices[c]);
            var D = Physics.Vect3dC2W($cylinder.vertices[d]);
            $height = Math.max($height, A.y, B.y, C.y, D.y);
            $radius = Math.max($radius, A.x * A.x + A.z * A.z);
            $radius = Math.max($radius, B.x * B.x + B.z * B.z);
            $radius = Math.max($radius, C.x * C.x + C.z * C.z);
        }
        return new Vector2D(Math.sqrt($radius) / Physics.baseScale10, $height / Physics.baseScale10);
    };
    CononDisplay3DSprite.prototype.updateMatrix = function () {
    };
    CononDisplay3DSprite.prototype.update = function () {
    };
    CononDisplay3DSprite.prototype.setModelById = function ($id) {
        this.addPart("abcdef", "abcdef", getModelUrl(String($id)));
    };
    CononDisplay3DSprite.prototype.addToWorld = function () {
        if (this._body) {
            SceneManager.getInstance().addMovieDisplay(this);
            SceneManager.getInstance().addDisplay(this._bodyLineSprite);
            Physics.world.addBody(this._body);
        }
    };
    CononDisplay3DSprite.prototype.updateFrame = function (t) {
        _super.prototype.updateFrame.call(this, t);
        if (this._body) {
            this.mathPosMatrix();
        }
    };
    CononDisplay3DSprite.prototype.mathPosMatrix = function () {
        var $ma = new Matrix3D;
        Physics.MathBody2WMatrix3D(this._body, $ma);
        this.posMatrix.m = $ma.m;
        var $shapeQua = Physics.QuaternionCollisionToH5(this._body.shapeOrientations[0]);
        var $m = $shapeQua.toMatrix3D();
        this.posMatrix.prepend($m);
        this.posMatrix.prependScale(this.scaleX, this.scaleY, this.scaleZ);
    };
    return CononDisplay3DSprite;
})(ScenePerfab);
//# sourceMappingURL=CononDisplay3DSprite.js.map