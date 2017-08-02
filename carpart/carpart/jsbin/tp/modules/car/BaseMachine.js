var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var BaseMachine = (function (_super) {
    __extends(BaseMachine, _super);
    function BaseMachine($x, $y, $z) {
        if ($x === void 0) { $x = 0; }
        if ($y === void 0) { $y = 0; }
        if ($z === void 0) { $z = 0; }
        _super.call(this, $x, $y, $z);
        this.initData();
    }
    BaseMachine.prototype.initData = function () {
    };
    BaseMachine.prototype.upData = function () {
    };
    return BaseMachine;
})(Object3D);
//# sourceMappingURL=BaseMachine.js.map