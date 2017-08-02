var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Hinge_html = (function (_super) {
    __extends(Hinge_html, _super);
    function Hinge_html() {
        _super.call(this);
    }
    Hinge_html.prototype.initData = function () {
        this.hinge();
    };
    Hinge_html.prototype.car = function () {
        var world = Physics.world;
        var mass = 1;
        world.gravity.set(0, 0, -20);
        var groundMaterial = new CANNON.Material("groundMaterial");
        var wheelMaterial = new CANNON.Material("wheelMaterial");
        var wheelGroundContactMaterial = new CANNON.ContactMaterial(groundMaterial, wheelMaterial, { friction: 0.5, restitution: 0.3 });
        world.addContactMaterial(wheelGroundContactMaterial);
        var wheelShape = new CANNON.Sphere(1.2);
        var leftFrontWheel = new CANNON.Body({ mass: mass, material: wheelMaterial });
        leftFrontWheel.addShape(wheelShape);
        var rightFrontWheel = new CANNON.Body({ mass: mass, material: wheelMaterial });
        rightFrontWheel.addShape(wheelShape);
        var leftRearWheel = new CANNON.Body({ mass: mass, material: wheelMaterial });
        leftRearWheel.addShape(wheelShape);
        var rightRearWheel = new CANNON.Body({ mass: mass, material: wheelMaterial });
        rightRearWheel.addShape(wheelShape);
        var chassisShape = new CANNON.Box(new CANNON.Vec3(5, 2, 0.5));
        var chassis = new CANNON.Body({ mass: mass });
        chassis.addShape(chassisShape);
        var $ty = 5;
        chassis.position.set(0, 0, $ty);
        // Position constrain wheels
        var zero = new CANNON.Vec3();
        leftFrontWheel.position.set(5, 5, $ty);
        rightFrontWheel.position.set(5, -5, $ty);
        leftRearWheel.position.set(-5, 5, $ty);
        rightRearWheel.position.set(-5, -5, $ty);
        // Constrain wheels
        var constraints = [];
        // Hinge the wheels
        var leftAxis = new CANNON.Vec3(0, 1, 0);
        var rightAxis = new CANNON.Vec3(0, -1, 0);
        var leftFrontAxis = new CANNON.Vec3(0, 1, 0);
        var rightFrontAxis = new CANNON.Vec3(0, -1, 0);
        if (true) {
            leftFrontAxis = new CANNON.Vec3(0.3, 0.7, 0);
            rightFrontAxis = new CANNON.Vec3(-0.3, -0.7, 0);
            leftFrontAxis.normalize();
            rightFrontAxis.normalize();
        }
        constraints.push(new CANNON.HingeConstraint(chassis, leftFrontWheel, { pivotA: new CANNON.Vec3(5, 5, 0), axisA: leftFrontAxis, pivotB: zero, axisB: leftAxis }));
        constraints.push(new CANNON.HingeConstraint(chassis, rightFrontWheel, { pivotA: new CANNON.Vec3(5, -5, 0), axisA: rightFrontAxis, pivotB: zero, axisB: rightAxis }));
        constraints.push(new CANNON.HingeConstraint(chassis, leftRearWheel, { pivotA: new CANNON.Vec3(-5, 5, 0), axisA: leftAxis, pivotB: zero, axisB: leftAxis }));
        constraints.push(new CANNON.HingeConstraint(chassis, rightRearWheel, { pivotA: new CANNON.Vec3(-5, -5, 0), axisA: rightAxis, pivotB: zero, axisB: rightAxis }));
        for (var i = 0; i < constraints.length; i++)
            world.addConstraint(constraints[i]);
        var bodies = [chassis, leftFrontWheel, rightFrontWheel, leftRearWheel, rightRearWheel];
        for (var i = 0; i < bodies.length; i++) {
            var $disLock = new CanonPrefabSprite(bodies[i]);
            $disLock.addToWorld();
        }
        // Ground
        var groundShape = new CANNON.Plane();
        var ground = new CANNON.Body({ mass: 0, material: groundMaterial });
        ground.addShape(groundShape);
        ground.position.z = -3;
        var $disLock = new CanonPrefabSprite(ground);
        $disLock.addToWorld();
        // Enable motors and set their velocities
        var frontLeftHinge = constraints[2];
        var frontRightHinge = constraints[3];
        frontLeftHinge.enableMotor();
        frontRightHinge.enableMotor();
        var v = -14;
        frontLeftHinge.setMotorSpeed(v);
        frontRightHinge.setMotorSpeed(-v);
    };
    Hinge_html.prototype.hinge = function () {
        var world = Physics.world;
        var mass = 1;
        world.gravity.set(0, 5, -20);
        var s = 5, d = 0.1 * s;
        var shape = new CANNON.Box(new CANNON.Vec3(s * 0.5, s * 0.1, s * 0.5));
        var body = new CANNON.Body({ mass: mass });
        body.position.z = 10;
        body.addShape(shape);
        var staticBody = new CANNON.Body({ mass: 0 });
        staticBody.addShape(shape);
        staticBody.position.z = s + d * 2 + 10;
        // Hinge it
        var c = new CANNON.HingeConstraint(staticBody, body, {
            pivotA: new CANNON.Vec3(0, 0, -s * 0.5 - d),
            axisA: new CANNON.Vec3(1, 0, 0),
            pivotB: new CANNON.Vec3(0, 0, s * 0.5 + d),
            axisB: new CANNON.Vec3(1, 0, 0)
        });
        world.addConstraint(c);
        var $disLock = new CanonPrefabSprite(body);
        $disLock.addToWorld();
        var $disLock = new CanonPrefabSprite(staticBody);
        $disLock.addToWorld();
    };
    return Hinge_html;
})(DemoBase_html);
//# sourceMappingURL=Hinge_html.js.map