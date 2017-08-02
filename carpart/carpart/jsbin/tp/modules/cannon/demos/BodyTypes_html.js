var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var BodyTypes_html = (function (_super) {
    __extends(BodyTypes_html, _super);
    function BodyTypes_html() {
        _super.call(this);
    }
    BodyTypes_html.prototype.initData = function () {
        var world = Physics.world;
        world.gravity.set(0, 0, -40);
        world.broadphase = new CANNON.NaiveBroadphase();
        // world.solver.iterations = 10;
        world.defaultContactMaterial.contactEquationStiffness = 1e8;
        world.defaultContactMaterial.contactEquationRelaxation = 10;
        var size = 2;
        var boxShape = new CANNON.Box(new CANNON.Vec3(size, size, size));
        var sphereShape = new CANNON.Sphere(size);
        var mass = 5, boxMass = 0;
        // Kinematic Box
        // Does only collide with dynamic bodies, but does not respond to any force.
        // Its movement can be controlled by setting its velocity.
        var b1 = new CANNON.Body({
            mass: boxMass,
            type: CANNON.Body.KINEMATIC,
            position: new CANNON.Vec3(0, 0, 0.5 * size)
        });
        b1.addShape(boxShape);
        var $disLock = new CanonPrefabSprite(b1);
        $disLock.addToWorld();
        // To control the box movement we must set its velocity
        b1.velocity.set(0, 0, 5);
        setInterval(function () {
            if (b1.velocity.z < 0)
                b1.velocity.set(0, 0, 5);
            else
                b1.velocity.set(0, 0, -5);
        }, 1000);
        // Dynamic Sphere
        // Dynamic bodies can collide with bodies of all other types.
        var b2 = new CANNON.Body({
            mass: mass,
            position: new CANNON.Vec3(0, 0, 3 * size)
        });
        b2.addShape(sphereShape);
        var $disLock = new CanonPrefabSprite(b2);
        $disLock.addToWorld();
    };
    return BodyTypes_html;
})(DemoBase_html);
//# sourceMappingURL=BodyTypes_html.js.map