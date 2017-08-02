var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var CollisionFilter_html = (function (_super) {
    __extends(CollisionFilter_html, _super);
    function CollisionFilter_html() {
        _super.call(this);
    }
    CollisionFilter_html.prototype.initData = function () {
        var size = 1;
        var mass = 1;
        // Collision filter groups - must be powers of 2!
        var GROUP1 = 1;
        var GROUP2 = 2;
        var GROUP3 = 4;
        var world = Physics.world;
        world.gravity.set(0, 0, 0); // no gravity
        world.broadphase = new CANNON.NaiveBroadphase();
        //   world.solver.iterations = 5;
        // Sphere
        var sphereShape = new CANNON.Sphere(size);
        var sphereBody = new CANNON.Body({
            mass: mass,
            position: new CANNON.Vec3(5, 0, 5),
            velocity: new CANNON.Vec3(-5, 0, 0),
            collisionFilterGroup: GROUP1,
            collisionFilterMask: GROUP2 | GROUP3,
            shape: sphereShape
        });
        // Box
        var boxBody = new CANNON.Body({
            mass: mass,
            position: new CANNON.Vec3(0, 0, 5),
            shape: new CANNON.Box(new CANNON.Vec3(size, size, size)),
            collisionFilterGroup: GROUP2,
            collisionFilterMask: GROUP1 // It can only collide with group 1 (the sphere)
        });
        // Cylinder
        var cylinderShape = new CANNON.Cylinder(size, size, size * 2.2, 10);
        var cylinderBody = new CANNON.Body({
            mass: mass,
            shape: cylinderShape,
            position: new CANNON.Vec3(-5, 0, 5),
            collisionFilterGroup: GROUP3,
            collisionFilterMask: GROUP1 // It can only collide with group 1 (the sphere)
        });
        // Add everything to the world and demo
        var $disLock = new CanonPrefabSprite(sphereBody);
        $disLock.addToWorld();
        var $disLock = new CanonPrefabSprite(boxBody);
        $disLock.addToWorld();
        var $disLock = new CanonPrefabSprite(cylinderBody);
        $disLock.addToWorld();
    };
    return CollisionFilter_html;
})(DemoBase_html);
//# sourceMappingURL=CollisionFilter_html.js.map