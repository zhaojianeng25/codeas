class Convex_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {
        var world: CANNON.World = Physics.world;

        this.convexOnconvex()

    }
    private convexOnconvex(): void
    {
        var world: CANNON.World = Physics.world;
        // ConvexPolyhedron box shape
        var size = 2;
        var convexShape =this. createBoxPolyhedron(size);
        var mass = 10;
        var boxbody1 = new CANNON.Body({ mass: mass });
        boxbody1.addShape(convexShape);
        var boxbody2 = new CANNON.Body({ mass: mass });
        boxbody2.addShape(convexShape);
        boxbody1.position.set(0, 0, size + 1);
        boxbody2.position.set(10, 0, 4 * size + 1);

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxbody1)
        $disLock.addToWorld();

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxbody2)
        $disLock.addToWorld();

        boxbody2.addEventListener("collide", function (e) {
            //console.log("The sphere just collided with the ground!");
            console.log("Collided with body:", e.body);
           // console.log("Contact between bodies:", e.contact);
     
        });


    }
    private createBoxPolyhedron(size):any {
        size = size || 1;
        var box = new CANNON.Box(new CANNON.Vec3(size, size, size));
        return box.convexPolyhedronRepresentation;
    }

    private createTetra():any {
        var verts = [new CANNON.Vec3(0, 0, 0),
            new CANNON.Vec3(2, 0, 0),
            new CANNON.Vec3(0, 2, 0),
            new CANNON.Vec3(0, 0, 2)];
        var offset = -0.35;
        for (var i = 0; i < verts.length; i++) {
            var v = verts[i];
            v.x += offset;
            v.y += offset;
            v.z += offset;
        }
        return new CANNON.ConvexPolyhedron(verts,
            [
                [0, 3, 2], // -x
                [0, 1, 3], // -y
                [0, 2, 1], // -z
                [1, 2, 3], // +xyz
            ]);
    }

    private various(): void
    {
        var world: CANNON.World = Physics.world;
        // ConvexPolyhedron box shape
        var size = 0.5;
        var convexShape =this. createBoxPolyhedron(size);
        var mass = 10;
        var boxbody = new CANNON.Body({ mass: mass });
        boxbody.addShape(convexShape);
        boxbody.position.set(1, 0, size + 1);

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxbody)
        $disLock.addToWorld();

        // ConvexPolyhedron tetra shape
        /*
        var tetraShape = this.createTetra();
        var tetraBody = new CANNON.Body({ mass: mass });
        tetraBody.addShape(tetraShape);
        tetraBody.position.set(5, -3, size + 1);

        var $disLock: CononDisplay3DSprite = new CononDisplay3DSprite(tetraBody)
        $disLock.addToWorld();
        */


        // ConvexPolyhedron cylinder shape
        var num = 20;
        var verts = [];
        var normals = [];
        var faces = [];
        var bottomface = [];
        var topface = [];
        var L = 2, R = 0.5;
        var cylinderShape = new CANNON.Cylinder(R, R, L, num);
        var cylinderBody = new CANNON.Body({ mass: mass });
        cylinderBody.addShape(cylinderShape);
        cylinderBody.position.set(0, 0, size * 4 + 1);
        cylinderBody.quaternion.setFromAxisAngle(new CANNON.Vec3(0, 1, 0), Math.PI / 3);
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(cylinderBody)
        $disLock.addToWorld();

    }

}