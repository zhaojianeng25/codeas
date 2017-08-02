class Compound_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {

        var world: CANNON.World = Physics.world;

        

        var s = 1.5;

        // Now create a Body for our Compound
        var mass = 10;
        var body = new CANNON.Body({ mass: mass });
        body.position.set(0, 0, 6);
        body.quaternion.setFromAxisAngle(new CANNON.Vec3(0, 1, 0), Math.PI / 10);

        // Use a box shape as child shape
        var shape = new CANNON.Box(new CANNON.Vec3(0.5 * s, 0.5 * s, 0.5 * s));

        // We can add the same shape several times to position child shapes within the Compound.
        body.addShape(shape, new CANNON.Vec3(s, 0, -s));
        //body.addShape(shape, new CANNON.Vec3(s, 0, s));
        //body.addShape(shape, new CANNON.Vec3(-s, 0, -s));
        //body.addShape(shape, new CANNON.Vec3(-s, 0, s));
        // Note: we only use translational offsets. The third argument could be a CANNON.Quaternion to rotate the child shape.
        body.addShape(shape, new CANNON.Vec3(-s, 0, 0));
        body.addShape(shape, new CANNON.Vec3(0, 0, -s));
        body.addShape(shape, new CANNON.Vec3(0, 0, s));

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(body)
        $disLock.addToWorld();


    }

}