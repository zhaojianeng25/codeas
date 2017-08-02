var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var MeshData = (function (_super) {
    __extends(MeshData, _super);
    function MeshData() {
        _super.apply(this, arguments);
        this.boneIDAry = new Array;
        this.boneWeightAry = new Array;
        this.boneNewIDAry = new Array;
        this.particleAry = new Array;
    }
    MeshData.prototype.destory = function () {
        _super.prototype.destory.call(this);
        if (this.materialParam) {
            this.materialParam.destory();
            this.materialParam = null;
            this.materialParamData = null;
        }
        this.boneIDAry.length = 0;
        this.boneWeightAry.length = 0;
        this.boneNewIDAry.length = 0;
        this.boneIDAry = null;
        this.boneWeightAry = null;
        this.boneNewIDAry = null;
        if (this.boneWeightBuffer) {
            Scene_data.context3D.deleteBuffer(this.boneWeightBuffer);
            this.boneWeightBuffer = null;
        }
        if (this.boneIdBuffer) {
            Scene_data.context3D.deleteBuffer(this.boneIdBuffer);
            this.boneIdBuffer = null;
        }
        if (this.material) {
            this.material.clearUseNum();
        }
        this.particleAry.length = 0;
        this.particleAry = null;
        //for (){
        //}
    };
    return MeshData;
})(ObjData);
var BindParticle = (function () {
    //public particle: CombineParticle;
    function BindParticle($url, $socketName) {
        this.url = $url;
        this.socketName = $socketName;
    }
    return BindParticle;
})();
//# sourceMappingURL=MeshData.js.map