var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var SceneChar = (function (_super) {
    __extends(SceneChar, _super);
    function SceneChar() {
        _super.call(this);
    }
    SceneChar.prototype.watch = function ($obj, $syn) {
        if ($syn === void 0) { $syn = false; }
        if (!$obj) {
            console.log("面向对象无");
            return;
        }
        var xx = $obj.x - this.px;
        var yy = $obj.z - this.pz;
        var distance = Math.sqrt(xx * xx + yy * yy);
        xx /= distance;
        yy /= distance;
        var angle = Math.asin(xx) / Math.PI * 180;
        if (yy <= 0) {
            angle = 180 - angle;
        }
        if (!isNaN(angle)) {
            this.rotationY = angle;
        }
    };
    return SceneChar;
})(SceneBaseChar);
//# sourceMappingURL=SceneChar.js.map