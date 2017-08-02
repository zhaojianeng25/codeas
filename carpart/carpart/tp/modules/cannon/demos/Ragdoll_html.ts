class Ragdoll_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {

        var world: CANNON.World = Physics.world;

        var scale = 3;
        var position = new CANNON.Vec3(0, 0, 10);

       // this.createRagdoll(scale, position, world, Math.PI, Math.PI, Math.PI);

      //  this.createRagdoll(scale, position, world, Math.PI / 4, Math.PI / 3, Math.PI / 8);
    
        this.createRagdoll(scale, position, world, 0, 0, 0);
    }

    protected createRagdoll(scale, position, world, angleA, angleB, twistAngle): void {


        var numBodiesAtStart = world.bodies.length;

        var shouldersDistance = 0.5 * scale,
            upperArmLength = 0.4 * scale,
            lowerArmLength = 0.4 * scale,
            upperArmSize = 0.2 * scale,
            lowerArmSize = 0.2 * scale,
            neckLength = 0.1 * scale,
            headRadius = 0.25 * scale,
            upperBodyLength = 0.6 * scale,
            pelvisLength = 0.4 * scale,
            upperLegLength = 0.5 * scale,
            upperLegSize = 0.2 * scale,
            lowerLegSize = 0.2 * scale,
            lowerLegLength = 0.5 * scale;

        var headShape = new CANNON.Sphere(headRadius),
            upperArmShape = new CANNON.Box(new CANNON.Vec3(upperArmLength * 0.5, upperArmSize * 0.5, upperArmSize * 0.5)),
            lowerArmShape = new CANNON.Box(new CANNON.Vec3(lowerArmLength * 0.5, lowerArmSize * 0.5, lowerArmSize * 0.5)),
            upperBodyShape = new CANNON.Box(new CANNON.Vec3(shouldersDistance * 0.5, upperBodyLength * 0.5, lowerArmSize * 0.5)),
            pelvisShape = new CANNON.Box(new CANNON.Vec3(shouldersDistance * 0.5, pelvisLength * 0.5, lowerArmSize * 0.5)),
            upperLegShape = new CANNON.Box(new CANNON.Vec3(upperLegSize * 0.5, upperLegLength * 0.5, lowerArmSize * 0.5)),
            lowerLegShape = new CANNON.Box(new CANNON.Vec3(lowerLegSize * 0.5, lowerLegLength * 0.5, lowerArmSize * 0.5));

        // Lower legs
        var lowerLeftLeg = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(-shouldersDistance / 2, lowerLegLength / 2, 0)
        });
        var lowerRightLeg = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(shouldersDistance / 2, lowerLegLength / 2, 0)
        });
        lowerLeftLeg.addShape(lowerLegShape);
        lowerRightLeg.addShape(lowerLegShape);


        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(lowerLeftLeg)
        $disLock.addToWorld();

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(lowerRightLeg)
        $disLock.addToWorld();

        // Upper legs
        var upperLeftLeg = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(-shouldersDistance / 2, lowerLeftLeg.position.y + lowerLegLength / 2 + upperLegLength / 2, 0),
        });
        var upperRightLeg = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(shouldersDistance / 2, lowerRightLeg.position.y + lowerLegLength / 2 + upperLegLength / 2, 0),
        });
        upperLeftLeg.addShape(upperLegShape);
        upperRightLeg.addShape(upperLegShape);

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(upperLeftLeg)
        $disLock.addToWorld();
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(upperRightLeg)
        $disLock.addToWorld();


        // Pelvis
        var pelvis = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(0, upperLeftLeg.position.y + upperLegLength / 2 + pelvisLength / 2, 0),
        });
        pelvis.addShape(pelvisShape);


        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(pelvis)
        $disLock.addToWorld();

        // Upper body
        var upperBody = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(0, pelvis.position.y + pelvisLength / 2 + upperBodyLength / 2, 0),
        });
        upperBody.addShape(upperBodyShape);
  
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(upperBody)
        $disLock.addToWorld();

        // Head
        var head = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(0, upperBody.position.y + upperBodyLength / 2 + headRadius + neckLength, 0),
        });
        head.addShape(headShape);

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(head)
        $disLock.addToWorld();

        // Upper arms
        var upperLeftArm = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(-shouldersDistance / 2 - upperArmLength / 2, upperBody.position.y + upperBodyLength / 2, 0),
        });
        var upperRightArm = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(shouldersDistance / 2 + upperArmLength / 2, upperBody.position.y + upperBodyLength / 2, 0),
        });
        upperLeftArm.addShape(upperArmShape);
        upperRightArm.addShape(upperArmShape);
  
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(upperLeftArm)
        $disLock.addToWorld();
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(upperRightArm)
        $disLock.addToWorld();

        // lower arms
        var lowerLeftArm = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(upperLeftArm.position.x - lowerArmLength / 2 - upperArmLength / 2, upperLeftArm.position.y, 0)
        });
        var lowerRightArm = new CANNON.Body({
            mass: 1,
            position: new CANNON.Vec3(upperRightArm.position.x + lowerArmLength / 2 + upperArmLength / 2, upperRightArm.position.y, 0)
        });
        lowerLeftArm.addShape(lowerArmShape);
        lowerRightArm.addShape(lowerArmShape);
    
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(lowerLeftArm)
        $disLock.addToWorld();

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(lowerRightArm)
        $disLock.addToWorld();


        // Neck joint
        var neckJoint = new CANNON.ConeTwistConstraint(head, upperBody, {
            pivotA: new CANNON.Vec3(0, -headRadius - neckLength / 2, 0),
            pivotB: new CANNON.Vec3(0, upperBodyLength / 2, 0),
            axisA: CANNON.Vec3.UNIT_Y,
            axisB: CANNON.Vec3.UNIT_Y,
            angle: angleA,
            twistAngle: twistAngle
        });
        world.addConstraint(neckJoint);

        // Knee joints
        var leftKneeJoint = new CANNON.ConeTwistConstraint(lowerLeftLeg, upperLeftLeg, {
            pivotA: new CANNON.Vec3(0, lowerLegLength / 2, 0),
            pivotB: new CANNON.Vec3(0, -upperLegLength / 2, 0),
            axisA: CANNON.Vec3.UNIT_Y,
            axisB: CANNON.Vec3.UNIT_Y,
            angle: angleA,
            twistAngle: twistAngle
        });
        var rightKneeJoint = new CANNON.ConeTwistConstraint(lowerRightLeg, upperRightLeg, {
            pivotA: new CANNON.Vec3(0, lowerLegLength / 2, 0),
            pivotB: new CANNON.Vec3(0, -upperLegLength / 2, 0),
            axisA: CANNON.Vec3.UNIT_Y,
            axisB: CANNON.Vec3.UNIT_Y,
            angle: angleA,
            twistAngle: twistAngle
        });
        world.addConstraint(leftKneeJoint);
        world.addConstraint(rightKneeJoint);

        // Hip joints
        var leftHipJoint = new CANNON.ConeTwistConstraint(upperLeftLeg, pelvis, {
            pivotA: new CANNON.Vec3(0, upperLegLength / 2, 0),
            pivotB: new CANNON.Vec3(-shouldersDistance / 2, -pelvisLength / 2, 0),
            axisA: CANNON.Vec3.UNIT_Y,
            axisB: CANNON.Vec3.UNIT_Y,
            angle: angleA,
            twistAngle: twistAngle
        });
        var rightHipJoint = new CANNON.ConeTwistConstraint(upperRightLeg, pelvis, {
            pivotA: new CANNON.Vec3(0, upperLegLength / 2, 0),
            pivotB: new CANNON.Vec3(shouldersDistance / 2, -pelvisLength / 2, 0),
            axisA: CANNON.Vec3.UNIT_Y,
            axisB: CANNON.Vec3.UNIT_Y,
            angle: angleA,
            twistAngle: twistAngle
        });
        world.addConstraint(leftHipJoint);
        world.addConstraint(rightHipJoint);

        // Spine
        var spineJoint = new CANNON.ConeTwistConstraint(pelvis, upperBody, {
            pivotA: new CANNON.Vec3(0, pelvisLength / 2, 0),
            pivotB: new CANNON.Vec3(0, -upperBodyLength / 2, 0),
            axisA: CANNON.Vec3.UNIT_Y,
            axisB: CANNON.Vec3.UNIT_Y,
            angle: angleA,
            twistAngle: twistAngle
        });
        world.addConstraint(spineJoint);

        // Shoulders
        var leftShoulder = new CANNON.ConeTwistConstraint(upperBody, upperLeftArm, {
            pivotA: new CANNON.Vec3(-shouldersDistance / 2, upperBodyLength / 2, 0),
            pivotB: new CANNON.Vec3(upperArmLength / 2, 0, 0),
            axisA: CANNON.Vec3.UNIT_X,
            axisB: CANNON.Vec3.UNIT_X,
            angle: angleB
        });
        var rightShoulder = new CANNON.ConeTwistConstraint(upperBody, upperRightArm, {
            pivotA: new CANNON.Vec3(shouldersDistance / 2, upperBodyLength / 2, 0),
            pivotB: new CANNON.Vec3(-upperArmLength / 2, 0, 0),
            axisA: CANNON.Vec3.UNIT_X,
            axisB: CANNON.Vec3.UNIT_X,
            angle: angleB,
            twistAngle: twistAngle
        });
        world.addConstraint(leftShoulder);
        world.addConstraint(rightShoulder);

        // Elbow joint
        var leftElbowJoint = new CANNON.ConeTwistConstraint(lowerLeftArm, upperLeftArm, {
            pivotA: new CANNON.Vec3(lowerArmLength / 2, 0, 0),
            pivotB: new CANNON.Vec3(-upperArmLength / 2, 0, 0),
            axisA: CANNON.Vec3.UNIT_X,
            axisB: CANNON.Vec3.UNIT_X,
            angle: angleA,
            twistAngle: twistAngle
        });
        var rightElbowJoint = new CANNON.ConeTwistConstraint(lowerRightArm, upperRightArm, {
            pivotA: new CANNON.Vec3(-lowerArmLength / 2, 0, 0),
            pivotB: new CANNON.Vec3(upperArmLength / 2, 0, 0),
            axisA: CANNON.Vec3.UNIT_X,
            axisB: CANNON.Vec3.UNIT_X,
            angle: angleA,
            twistAngle: twistAngle
        });
        world.addConstraint(leftElbowJoint);
        world.addConstraint(rightElbowJoint);

        // Move all body parts
        for (var i = numBodiesAtStart; i < world.bodies.length; i++) {
            var body = world.bodies[i];
            body.position.vadd(position, body.position);
        }

    }

}