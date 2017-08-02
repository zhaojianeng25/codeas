var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ObjData = (function (_super) {
    __extends(ObjData, _super);
    function ObjData() {
        _super.call(this);
        this.vertices = new Array;
        this.uvs = new Array;
        this.indexs = new Array;
        this.lightuvs = new Array;
        this.normals = new Array;
        this.tangents = new Array;
        this.bitangents = new Array;
        //public collision: CollisionItemVo;
        this.treNum = 0;
        /**顶点 uv lightuv normal 合成一个 va */
        this.compressBuffer = false;
        this.hasdispose = false;
    }
    ObjData.prototype.destory = function () {
        this.vertices.length = 0;
        this.vertices = null;
        this.uvs.length = 0;
        this.uvs = null;
        this.indexs.length = 0;
        this.indexs = null;
        this.lightuvs.length = 0;
        this.lightuvs = null;
        this.normals.length = 0;
        this.normals = null;
        this.tangents.length = 0;
        this.tangents = null;
        this.bitangents.length = 0;
        this.bitangents = null;
        if (this.vertexBuffer) {
            Scene_data.context3D.deleteBuffer(this.vertexBuffer);
            this.vertexBuffer = null;
        }
        if (this.uvBuffer) {
            Scene_data.context3D.deleteBuffer(this.uvBuffer);
            this.uvBuffer = null;
        }
        if (this.indexBuffer) {
            Scene_data.context3D.deleteBuffer(this.indexBuffer);
            this.indexBuffer = null;
        }
        if (this.lightUvBuffer) {
            Scene_data.context3D.deleteBuffer(this.lightUvBuffer);
            this.lightUvBuffer = null;
        }
        if (this.normalsBuffer) {
            Scene_data.context3D.deleteBuffer(this.normalsBuffer);
            this.normalsBuffer = null;
        }
        if (this.tangentBuffer) {
            Scene_data.context3D.deleteBuffer(this.tangentBuffer);
            this.tangentBuffer = null;
        }
        if (this.bitangentBuffer) {
            Scene_data.context3D.deleteBuffer(this.bitangentBuffer);
            this.bitangentBuffer = null;
        }
        this.hasdispose = true;
    };
    return ObjData;
})(ResCount);
//# sourceMappingURL=ObjData.js.map