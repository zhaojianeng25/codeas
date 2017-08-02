var ShowDisModel = (function () {
    function ShowDisModel() {
    }
    ShowDisModel.getInstance = function () {
        if (!this._instance) {
            this._instance = new ShowDisModel();
        }
        return this._instance;
    };
    ShowDisModel.prototype.setPos = function (value) {
        var ca = new CANNON.Quaternion(Math.abs(value.x), Math.abs(value.y), Math.abs(value.z));
        console.log(ca);
        var cb = Physics.QuaternionC2Vec3dW(ca);
        var $q = new Quaternion(cb.x, cb.y, cb.z, 1);
        $q.setMd5W();
        var $m = $q.toMatrix3D();
        $m.appendTranslation(0, 50, 0);
        $m.prependScale(0.1, 0.1, 0.1);
    };
    ShowDisModel.prototype.addTempHit = function ($pos) {
        var $dis = new ScenePerfab();
        SceneManager.getInstance().addMovieDisplay($dis);
        $dis.setPerfabName("10001");
        $dis.scaleY = 5;
        $dis.scaleX = 0.1;
        $dis.scaleZ = 0.1;
        $dis.x = $pos.x;
        $dis.y = $pos.y;
        $dis.z = $pos.z;
    };
    return ShowDisModel;
})();
//# sourceMappingURL=ShowDisModel.js.map