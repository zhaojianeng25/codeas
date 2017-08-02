var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Display3DLocusBallPartilce = (function (_super) {
    __extends(Display3DLocusBallPartilce, _super);
    //protected _posAry: Array<number>;
    //protected _angleAry: Array<number>;
    //protected _tangentAry: Array<number>;
    //protected _tangentSpeed:number;
    function Display3DLocusBallPartilce() {
        _super.call(this);
    }
    Display3DLocusBallPartilce.prototype.creatData = function () {
        this.data = new ParticleLocusballData;
    };
    return Display3DLocusBallPartilce;
})(Display3DBallPartilce);
//# sourceMappingURL=Display3DLocusBallPartilce.js.map