var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Bounce_html = (function (_super) {
    __extends(Bounce_html, _super);
    function Bounce_html() {
        _super.call(this);
    }
    Bounce_html.prototype.initData = function () {
        var size = 1;
        var height = 5;
        var damping = 0.01;
        var world = Physics.world;
        world.gravity.set(0, 0, -10);
        world.broadphase = new CANNON.NaiveBroadphase();
        // ground plane
        var groundMaterial = new CANNON.Material();
        var groundShape = new CANNON.Plane();
        var groundBody = new CANNON.Body({ mass: 0, material: groundMaterial });
        groundBody.addShape(groundShape);
        var $disLock = new CanonPrefabSprite(groundBody);
        $disLock.addToWorld();
        var mass = 10;
        var sphereShape = new CANNON.Sphere(size);
        // Shape on plane
        var mat1 = new CANNON.Material();
        var shapeBody1 = new CANNON.Body({
            mass: mass,
            material: mat1,
            position: new CANNON.Vec3(3 * size, size, height)
        });
        shapeBody1.addShape(sphereShape);
        shapeBody1.linearDamping = damping;
        var $disLock = new CanonPrefabSprite(shapeBody1);
        $disLock.addToWorld();
        var mat2 = new CANNON.Material();
        var shapeBody2 = new CANNON.Body({
            mass: mass,
            material: mat2,
            position: new CANNON.Vec3(0, size, height)
        });
        shapeBody2.addShape(sphereShape);
        shapeBody2.linearDamping = damping;
        var $disLock = new CanonPrefabSprite(shapeBody2);
        $disLock.addToWorld();
        var mat3 = new CANNON.Material();
        var shapeBody3 = new CANNON.Body({
            mass: mass,
            material: mat3,
            position: new CANNON.Vec3(-3 * size, size, height)
        });
        shapeBody3.addShape(sphereShape);
        shapeBody3.linearDamping = damping;
        var $disLock = new CanonPrefabSprite(shapeBody3);
        $disLock.addToWorld();
        // Create contact material behaviour
        var mat1_ground = new CANNON.ContactMaterial(groundMaterial, mat1, { friction: 0.0, restitution: 0.0 });
        var mat2_ground = new CANNON.ContactMaterial(groundMaterial, mat2, { friction: 0.0, restitution: 0.7 });
        var mat3_ground = new CANNON.ContactMaterial(groundMaterial, mat3, { friction: 0.0, restitution: 0.9 });
        world.addContactMaterial(mat1_ground);
        world.addContactMaterial(mat2_ground);
        world.addContactMaterial(mat3_ground);
    };
    return Bounce_html;
})(DemoBase_html);
//# sourceMappingURL=Bounce_html.js.map