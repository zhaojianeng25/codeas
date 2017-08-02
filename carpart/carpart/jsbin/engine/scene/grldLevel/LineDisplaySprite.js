var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var LineDisplaySprite = (function (_super) {
    __extends(LineDisplaySprite, _super);
    function LineDisplaySprite() {
        _super.call(this);
        this.baseColor = new Vector3D(1, 0, 0);
        this.objData = new ObjData;
        this.shader = ProgrmaManager.getInstance().getProgram(LineDisplayShader.LineShader);
        this.program = this.shader.program;
        this.makeLineMode(new Vector3D(0, 0, 0), new Vector3D(100, 0, 0), new Vector3D());
        this.makeLineMode(new Vector3D(0, 0, 0), new Vector3D(100, 0, 100), new Vector3D());
        this.makeLineMode(new Vector3D(100, 0, 0), new Vector3D(100, 0, 100), new Vector3D());
        this.upToGpu();
    }
    LineDisplaySprite.prototype.makeLineMode = function (a, b, $color) {
        if ($color === void 0) { $color = null; }
        if (!this.lineVecPos || !this.lineIndex) {
            this.clear();
        }
        if ($color) {
            this.baseColor = $color;
        }
        this.lineVecPos.push(a.x, a.y, a.z);
        this.lineVecPos.push(b.x, b.y, b.z);
        this.lineColor.push(this.baseColor.x, this.baseColor.y, this.baseColor.z);
        this.lineColor.push(this.baseColor.x, this.baseColor.y, this.baseColor.z);
        this.lineIndex.push(this.lineIndex.length + 0, this.lineIndex.length + 1);
    };
    LineDisplaySprite.prototype.clear = function () {
        this.lineVecPos = new Array;
        this.lineIndex = new Array;
        this.lineColor = new Array;
        if (this.objData.indexBuffer) {
            this.objData.indexBuffer = null;
        }
    };
    LineDisplaySprite.prototype.upToGpu = function () {
        if (this.lineIndex.length) {
            this.objData.treNum = this.lineIndex.length;
            this.objData.vertexBuffer = Scene_data.context3D.uploadBuff3D(this.lineVecPos);
            this.objData.normalsBuffer = Scene_data.context3D.uploadBuff3D(this.lineColor);
            this.objData.indexBuffer = Scene_data.context3D.uploadIndexBuff3D(this.lineIndex);
        }
    };
    LineDisplaySprite.prototype.update = function () {
        if (this.objData && this.objData.indexBuffer) {
            Scene_data.context3D.setProgram(this.program);
            Scene_data.context3D.setVcMatrix4fv(this.shader, "viewMatrix3D", Scene_data.viewMatrx3D.m);
            Scene_data.context3D.setVcMatrix4fv(this.shader, "camMatrix3D", Scene_data.cam3D.cameraMatrix.m);
            Scene_data.context3D.setVcMatrix4fv(this.shader, "posMatrix3D", this.posMatrix.m);
            Scene_data.context3D.setVa(0, 3, this.objData.vertexBuffer);
            Scene_data.context3D.setVa(1, 3, this.objData.normalsBuffer);
            Scene_data.context3D.drawLine(this.objData.indexBuffer, this.objData.treNum);
        }
    };
    return LineDisplaySprite;
})(Display3D);
var GridLineSprite = (function (_super) {
    __extends(GridLineSprite, _super);
    function GridLineSprite() {
        _super.call(this);
        this.makeGridData();
    }
    GridLineSprite.prototype.makeGridData = function () {
        var w = 100;
        var n = 10;
        var skeep = w / n;
        this.clear();
        var a;
        var b;
        a = new Vector3D(0, 0, +w);
        b = new Vector3D(0, 0, -w);
        this.makeLineMode(a, b, new Vector3D(0, 0, 1, 1));
        a = new Vector3D(+w, 0, 0);
        b = new Vector3D(-w, 0, 0);
        this.makeLineMode(a, b, new Vector3D(1, 0, 0, 1));
        this.baseColor = new Vector3D(128 / 255, 128 / 255, 128 / 255, 1);
        for (var i = 1; i <= n; i++) {
            a = new Vector3D(+i * skeep, 0, +w);
            b = new Vector3D(+i * skeep, 0, -w);
            this.makeLineMode(a, b);
            a = new Vector3D(-i * skeep, 0, +w);
            b = new Vector3D(-i * skeep, 0, -w);
            this.makeLineMode(a, b);
            a = new Vector3D(+w, 0, +i * skeep);
            b = new Vector3D(-w, 0, +i * skeep);
            this.makeLineMode(a, b);
            a = new Vector3D(+w, 0, -i * skeep);
            b = new Vector3D(-w, 0, -i * skeep);
            this.makeLineMode(a, b);
        }
        this.upToGpu();
    };
    return GridLineSprite;
})(LineDisplaySprite);
//# sourceMappingURL=LineDisplaySprite.js.map