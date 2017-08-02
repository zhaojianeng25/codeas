var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var RoleRes = (function (_super) {
    __extends(RoleRes, _super);
    function RoleRes() {
        _super.call(this);
        this.meshBatchNum = 1;
    }
    RoleRes.prototype.load = function (url, $fun) {
        var _this = this;
        this._fun = $fun;
        LoadManager.getInstance().load(url, LoadManager.BYTE_TYPE, function ($byte) {
            _this.loadComplete($byte);
        });
    };
    RoleRes.prototype.loadComplete = function ($byte) {
        this._byte = new ByteArray($byte);
        this._byte.position = 0;
        this.version = this._byte.readInt();
        this.readMesh();
    };
    RoleRes.prototype.readMesh = function () {
        this.roleUrl = this._byte.readUTF();
        if (this.version >= 16) {
            this.ambientLightColor = new Vector3D;
            this.sunLigthColor = new Vector3D;
            this.nrmDircet = new Vector3D;
            this.ambientLightColor.x = this._byte.readFloat();
            this.ambientLightColor.y = this._byte.readFloat();
            this.ambientLightColor.z = this._byte.readFloat();
            this.ambientLightIntensity = this._byte.readFloat();
            this.ambientLightColor.scaleBy(this.ambientLightIntensity);
            this.sunLigthColor.x = this._byte.readFloat();
            this.sunLigthColor.y = this._byte.readFloat();
            this.sunLigthColor.z = this._byte.readFloat();
            this.sunLigthIntensity = this._byte.readFloat();
            this.sunLigthColor.scaleBy(this.sunLigthIntensity);
            this.nrmDircet.x = this._byte.readFloat();
            this.nrmDircet.y = this._byte.readFloat();
            this.nrmDircet.z = this._byte.readFloat();
        }
        MeshDataManager.getInstance().readData(this._byte, this.meshBatchNum, this.roleUrl, this.version);
        this.readAction();
    };
    RoleRes.prototype.readAction = function () {
        var _this = this;
        this.actionAry = new Array;
        var actionNum = this._byte.readInt();
        for (var i = 0; i < actionNum; i++) {
            var actionName = this._byte.readUTF();
            AnimManager.getInstance().readData(this._byte, this.roleUrl + actionName);
            this.actionAry.push(actionName);
        }
        this.read(function () { _this.readNext(); }); //readimg 
    };
    RoleRes.prototype.readNext = function () {
        this.read(); //readmaterial
        this.read(); //readparticle;
        this._fun();
    };
    return RoleRes;
})(BaseRes);
//# sourceMappingURL=RoleRes.js.map