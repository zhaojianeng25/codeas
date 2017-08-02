var SceneConanManager = (function () {
    function SceneConanManager() {
    }
    SceneConanManager.getInstance = function () {
        if (!this._instance) {
            this._instance = new SceneConanManager();
        }
        return this._instance;
    };
    SceneConanManager.prototype.addMoveBox = function ($pos, $scale) {
        if ($scale === void 0) { $scale = 10; }
        var $box = new CANNON.Box(Physics.Vec3dW2C(new Vector3D($scale, $scale, $scale)));
        var $body = new CANNON.Body({ mass: 1 });
        $body.addShape($box);
        $body.position = Physics.Vec3dW2C($pos);
        $body.linearDamping = $body.angularDamping = 0.5;
        var $dis = new CanonPrefabSprite($body);
        $dis.addToWorld();
    };
    SceneConanManager.prototype.addMoveSphere = function ($pos, $scale) {
        if ($scale === void 0) { $scale = 10; }
        var $sphere = new CANNON.Sphere($scale / Physics.baseScale10);
        var $body = new CANNON.Body({ mass: 1 });
        $body.addShape($sphere);
        // $body.position.set($pos.x, $pos.z, $pos.y)
        $body.position = Physics.Vec3dW2C($pos);
        $body.linearDamping = $body.angularDamping = 0.5;
        var $dis = new CanonPrefabSprite($body);
        $dis.addToWorld();
    };
    SceneConanManager.prototype.addMoveCylinder = function ($pos, $scale) {
        if ($scale === void 0) { $scale = 10; }
        var kkk = Physics.Vec3dW2C(new Vector3D($scale, $scale, $scale));
        var $box = new CANNON.Cylinder(kkk.x, kkk.y, kkk.z, 20);
        var $body = new CANNON.Body({ mass: 1 });
        $body.addShape($box);
        $body.position = Physics.Vec3dW2C($pos);
        $body.linearDamping = $body.angularDamping = 0.5;
        var $dis = new CanonPrefabSprite($body);
        $dis.addToWorld();
    };
    SceneConanManager.prototype.creatWorld = function () {
        Physics.world = new CANNON.World();
        Physics.world.gravity = Physics.Vec3dW2C(new Vector3D(0, -1000, 0));
        Physics.world.broadphase = new CANNON.NaiveBroadphase();
    };
    SceneConanManager.prototype.makeGround = function ($pos) {
        var groundShape = new CANNON.Plane();
        var groundBody = new CANNON.Body({ mass: 0 });
        groundBody.addShape(groundShape);
        groundBody.position.set(0, 0, 0);
        groundBody.gameType = 2;
        Physics.world.addBody(groundBody);
    };
    SceneConanManager.prototype.makeExpSceneCollisionItem = function ($arr) {
        if ($arr) {
            var $bodyItem = Physics.makeSceneCollision($arr);
            if (true) {
                for (var i = 0; i < $bodyItem.length; i++) {
                    var $dis = new CanonPrefabSprite($bodyItem[i]);
                    $dis.addToWorld();
                    Physics.world.addBody($bodyItem[i]);
                }
            }
        }
    };
    return SceneConanManager;
})();
//# sourceMappingURL=SceneConanManager.js.map