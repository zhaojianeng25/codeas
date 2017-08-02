var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var cannon;
(function (cannon) {
    var CannonModule = (function (_super) {
        __extends(CannonModule, _super);
        function CannonModule() {
            _super.apply(this, arguments);
        }
        CannonModule.prototype.getModuleName = function () {
            return "CannonModule";
        };
        CannonModule.prototype.listProcessors = function () {
            return [new CannonProcessor()];
        };
        return CannonModule;
    })(Module);
    cannon.CannonModule = CannonModule;
    var CannonEvent = (function (_super) {
        __extends(CannonEvent, _super);
        function CannonEvent() {
            _super.apply(this, arguments);
        }
        CannonEvent.INIT_CANNON_SCENE = "INIT_CANNON_SCENE";
        return CannonEvent;
    })(BaseEvent);
    cannon.CannonEvent = CannonEvent;
    var CannonProcessor = (function (_super) {
        __extends(CannonProcessor, _super);
        function CannonProcessor() {
            var _this = this;
            _super.call(this);
            ProgrmaManager.getInstance().registe(LineDisplayShader.LineShader, new LineDisplayShader);
            TimeUtil.addFrameTick(function () { _this.upData(); });
        }
        CannonProcessor.prototype.getName = function () {
            return "CannonProcessor";
        };
        CannonProcessor.prototype.receivedModuleEvent = function ($event) {
            if ($event instanceof CannonEvent) {
                var evt = $event;
                if (evt.type == CannonEvent.INIT_CANNON_SCENE) {
                    this.initCannonScen(evt.data);
                }
            }
        };
        CannonProcessor.prototype.initCannonScen = function ($data) {
            alert("here");
            Physics.creatWorld();
            SceneConanManager.getInstance().makeGround(new Vector3D());
            SceneConanManager.getInstance().makeExpSceneCollisionItem($data);
            new CraneBaseSprite();
            this.test();
            Physics.ready = true;
        };
        CannonProcessor.prototype.test = function () {
            // Add contact material to the world
            //   Physics.world.addContactMaterial(ground_ground_cm);
            var size = 1;
            var boxShape = new CANNON.Box(new CANNON.Vec3(size, size, size));
            var sphereShape = new CANNON.Sphere(size);
            var mass = 5, boxMass = 1;
            // Kinematic Box
            // Does only collide with dynamic bodies, but does not respond to any force.
            // Its movement can be controlled by setting its velocity.
            var b2 = new CANNON.Body({
                mass: boxMass,
                position: new CANNON.Vec3(5, 0, 15),
            });
            b2.addShape(boxShape);
            var $disLock = new CanonPrefabSprite(b2);
            $disLock.addToWorld();
            b2.velocity.set(1, 0, +10);
            var b1 = new CANNON.Body({
                mass: boxMass,
                position: new CANNON.Vec3(8, 0, 15),
            });
            b1.addShape(boxShape);
            var $disLock = new CanonPrefabSprite(b1);
            $disLock.addToWorld();
        };
        CannonProcessor.prototype.upData = function () {
            Physics.update();
        };
        CannonProcessor.prototype.listenModuleEvents = function () {
            return [
                new CannonEvent(CannonEvent.INIT_CANNON_SCENE),
            ];
        };
        return CannonProcessor;
    })(BaseProcessor);
    cannon.CannonProcessor = CannonProcessor;
})(cannon || (cannon = {}));
//# sourceMappingURL=CannonProcessor.js.map