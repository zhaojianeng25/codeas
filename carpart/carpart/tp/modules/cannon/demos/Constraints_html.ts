class Constraints_html extends DemoBase_html {

    constructor() {
        super();
    }
    protected initData(): void {

       this.linksScene();
        //this.lockScene();

       // this.clothOnSphere();
      //  this.spherePendulum();
      //  this.SphereChain();
        //this.ParticleCloth();

       // this.cloth3Dstructure()

    }
    private cloth3Dstructure(): void
    {
        var world: CANNON.World = Physics.world;

       // world.solver.iterations = 10;
        var dist = 1;
        var mass = 1;
        var Nx = 6, Ny = 3, Nz = 3;
        var bodies = {}; // bodies["i j k"] => particle
        for (var i = 0; i < Nx; i++) {
            for (var j = 0; j < Ny; j++) {
                for (var k = 0; k < Nz; k++) {
                    // Create a new body
                    var body = new CANNON.Body({ mass: mass });
                    body.addShape(new CANNON.Particle());
                    body.position.set(i * dist, j * dist, k * dist + Nz * dist * 0.3 + 1);
                    body.velocity.set(0, 30 * (Math.sin(i * 0.1) + Math.sin(j * 0.1)), 0);
                    bodies[i + " " + j + " " + k] = body;
              
                    var $disLock: CanonPrefabSprite = new CanonPrefabSprite(body)
                    $disLock.addToWorld();
                }
            }
        }
        function connect(i1, j1, k1, i2, j2, k2, len) {
            world.addConstraint(new CANNON.DistanceConstraint(bodies[i1 + " " + j1 + " " + k1], bodies[i2 + " " + j2 + " " + k2], len));
        }
        for (var i = 0; i < Nx; i++) {
            for (var j = 0; j < Ny; j++) {
                for (var k = 0; k < Nz; k++) {
                    // normal directions
                    if (i < Nx - 1) connect(i, j, k, i + 1, j, k, dist);
                    if (j < Ny - 1) connect(i, j, k, i, j + 1, k, dist);
                    if (k < Nz - 1) connect(i, j, k, i, j, k + 1, dist);

                    // Diagonals
                    if (i < Nx - 1 && j < Ny - 1 && k < Nz - 1) {
                        // 3d diagonals
                        connect(i, j, k, i + 1, j + 1, k + 1, Math.sqrt(3) * dist);
                        connect(i + 1, j, k, i, j + 1, k + 1, Math.sqrt(3) * dist);
                        connect(i, j + 1, k, i + 1, j, k + 1, Math.sqrt(3) * dist);
                        connect(i, j, k + 1, i + 1, j + 1, k, Math.sqrt(3) * dist);

                    }

                    // 2d diagonals
                    if (i < Nx - 1 && j < Ny - 1) {
                        connect(i + 1, j, k, i, j + 1, k, Math.sqrt(2) * dist);
                        connect(i, j + 1, k, i + 1, j, k, Math.sqrt(2) * dist);
                    }
                    if (i < Nx - 1 && k < Nz - 1) {
                        connect(i + 1, j, k, i, j, k + 1, Math.sqrt(2) * dist);
                        connect(i, j, k + 1, i + 1, j, k, Math.sqrt(2) * dist);
                    }
                    if (j < Ny - 1 && k < Nz - 1) {
                        connect(i, j + 1, k, i, j, k + 1, Math.sqrt(2) * dist);
                        connect(i, j, k + 1, i, j + 1, k, Math.sqrt(2) * dist);
                    }
                }
            }
        }
    }
    private ParticleCloth():void
    {
        var world: CANNON.World = Physics.world;

        var dist = 0.2;
        var mass = 0.5;
        var Nrows = 15, Ncols = 15;
        var bodies = {}; // bodies["i j"] => particle
        for (var i = 0; i < Ncols; i++) {
            for (var j = 0; j < Nrows; j++) {
                // Create a new body
                var body = new CANNON.Body({ mass: j == Nrows - 1 ? 0 : mass });
                body.addShape(new CANNON.Particle());
                body.position.set(i * dist, 0, j * dist + 5);
                body.velocity.set(0, 3 * (Math.sin(i * 0.1) + Math.sin(j * 0.1)), 0);
                bodies[i + " " + j] = body;
                
                var $disLock: CanonPrefabSprite = new CanonPrefabSprite(body)
                $disLock.addToWorld();
            }
        }
        function connect(i1, j1, i2, j2) {
            world.addConstraint(new CANNON.DistanceConstraint(bodies[i1 + " " + j1], bodies[i2 + " " + j2], dist));
        }
        for (var i = 0; i < Ncols; i++) {
            for (var j = 0; j < Nrows; j++) {
                if (i < Ncols - 1) connect(i, j, i + 1, j);
                if (j < Nrows - 1) connect(i, j, i, j + 1);
            }
        }

    }
    private SphereChain():void
    {
        var world: CANNON.World = Physics.world;

        world.gravity.set(0, -1, -100);

        var size = 0.5;
        var dist = size * 2 + 0.12;

        //world.solver.setSpookParams(1e20,3);
        var sphereShape = new CANNON.Sphere(size);
        var mass = 1;
        var lastBody = null;
        var N = 20;
  //      world.solver.iterations = N; // To be able to propagate force throw the chain of N spheres, we need at least N solver iterations.
        for (var i = 0; i < N; i++) {
            // Create a new body
            var spherebody = new CANNON.Body({ mass: i === 0 ? 0 : mass });
            spherebody.addShape(sphereShape);
            spherebody.position.set(0, 0, (N - i) * dist);
            spherebody.velocity.x = i;

     
            var $disLock: CanonPrefabSprite = new CanonPrefabSprite(spherebody)
            $disLock.addToWorld();

            // Connect this body to the last one added
            var c;
            if (lastBody !== null) {
                world.addConstraint(c = new CANNON.DistanceConstraint(spherebody, lastBody, dist));
            }

            // Keep track of the lastly added body
            lastBody = spherebody;
        }

    }

    private spherePendulum(): void
    {
        var world: CANNON.World = Physics.world;

     //   world.gravity.set(0, 0, -1);


        var size = 1;
        var sphereShape = new CANNON.Sphere(size);
        var mass = 1;

        var spherebody = new CANNON.Body({ mass: mass });
        spherebody.addShape(sphereShape);
        spherebody.position.set(0, 0, size * 3);
        spherebody.velocity.set(5, 0, 0);
        spherebody.linearDamping = 0;
        spherebody.angularDamping = 0;
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(spherebody)
        $disLock.addToWorld();


    
        var spherebody2 = new CANNON.Body({ mass: 0 });
        spherebody2.addShape(sphereShape);
        spherebody2.position.set(0, 0, size * 7);
  
        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(spherebody2)
        $disLock.addToWorld();

        // Connect this body to the last one
        var c = new CANNON.PointToPointConstraint(spherebody, new CANNON.Vec3(0, 0, size * 2), spherebody2, new CANNON.Vec3(0, 0, -size * 2));
        world.addConstraint(c);

    }
    private clothOnSphere(): void
    {
        var world: CANNON.World = Physics.world;
     
        world.gravity.set(0, -1, -20);

        // To construct the cloth we need Nrows*Ncols particles.
        var dist = 0.2;
        var mass = 0.5;
        var Nrows = 15, Ncols = 15;
        var bodies = {}; // bodies["i j"] => particle
        for (var i = 0; i < Ncols; i++) {
            for (var j = 0; j < Nrows; j++) {
                // Create a new body
                var body = new CANNON.Body({ mass: mass });
                body.addShape(new CANNON.Particle());
                body.position.set((i - Ncols * 0.5) * dist, (j - Nrows * 0.5) * dist, 5);
                bodies[i + " " + j] = body;
      
                var $disLock: CanonPrefabSprite = new CanonPrefabSprite(body)
                $disLock.addToWorld();
            }
        }

        function connect(i1, j1, i2, j2) {
            world.addConstraint(new CANNON.DistanceConstraint(bodies[i1 + " " + j1], bodies[i2 + " " + j2], dist));
        }
        for (var i = 0; i < Ncols; i++) {
            for (var j = 0; j < Nrows; j++) {
                // Connect particle at position (i,j) to (i+1,j) and to (i,j+1).
                if (i < Ncols - 1) connect(i, j, i + 1, j);
                if (j < Nrows - 1) connect(i, j, i, j + 1);
            }
        }

        // Add the static sphere we throw the cloth on top of
        var sphere = new CANNON.Sphere(1.5);
        var body = new CANNON.Body({ mass: 0 });
        body.addShape(sphere);
        body.position.set(0, 0, 3.5);
   

        var $disLock: CanonPrefabSprite = new CanonPrefabSprite(body)
        $disLock.addToWorld();
  
    }
    private linksScene(): void
    {
        var world: CANNON.World = Physics.world;
        world.gravity.set(0, -1, -20);
        var size = 1;
        var boxShape = new CANNON.Box(new CANNON.Vec3(size, size * 0.1, size));
        var mass = 0;
        var space = 0.1 * size;

        var N = 10, last;
        for (var i = 0; i < N; i++) {
            // Create a box
            var boxbody = new CANNON.Body({ mass: mass });
            boxbody.addShape(boxShape);
            boxbody.position.set(0, 0, (N - i) * (size * 2 + 2 * space) + size * 2 + space);
            boxbody.linearDamping = 0.01; // Damping makes the movement slow down with time
            boxbody.angularDamping = 0.01;
      

            var $disLock: CanonPrefabSprite = new CanonPrefabSprite(boxbody)
            $disLock.addToWorld();


            if (i != 0) {
                // Connect the current body to the last one
                // We connect two corner points to each other.
                var c1 = new CANNON.PointToPointConstraint(boxbody, new CANNON.Vec3(-size, 0, size + space), last, new CANNON.Vec3(-size, 0, -size - space));
                var c2 = new CANNON.PointToPointConstraint(boxbody, new CANNON.Vec3(size, 0, size + space), last, new CANNON.Vec3(size, 0, -size - space));
                world.addConstraint(c1);
                world.addConstraint(c2);
            } else {
                // First body is now static. The rest should be dynamic.
                mass = 0.3;
            }

            // To keep track of which body was added last
            last = boxbody;
        }
    }
    private lockScene(): void
    {

        Physics.world.gravity.set(0, 0, -10);


        var size = 0.5;
        var mass: number = 1;
        var space: number = 0.1 * size;
        var N: number = 10


        var $box: CANNON.Shape = new CANNON.Box(new CANNON.Vec3(size, size, size))


        var last: any;


        for (var i = 0; i < N; i++) {
            // Create a box
 


            var $bodyLock: CANNON.Body = new CANNON.Body({ mass: 1 });
            $bodyLock.addShape($box);
            $bodyLock.position = new CANNON.Vec3((N - i - N / 2) * (size * 2 + 2 * space), 0, size * 6 + space)


            var $disLock: CanonPrefabSprite = new CanonPrefabSprite($bodyLock)
            $disLock.addToWorld();

            if (last) {
                // Connect the current body to the last one
                var c = new CANNON.LockConstraint($bodyLock, last);
                Physics.world.addConstraint(c);
            }

            // To keep track of which body was added last
            last = $bodyLock;
        }



        var $bodyA: CANNON.Body = new CANNON.Body({ mass: 0 });
        $bodyA.addShape($box);
        $bodyA.position = new CANNON.Vec3((-N / 2 + 1) * (size * 2 + 2 * space), 0, size * 3)

        var $disA: CanonPrefabSprite = new CanonPrefabSprite($bodyA)
        $disA.addToWorld();


        var $bodyB: CANNON.Body = new CANNON.Body({ mass: 0 });
        $bodyB.addShape($box);
        $bodyB.position = new CANNON.Vec3((N / 2) * (size * 2 + 2 * space), 0, size * 3)

        var $disB: CanonPrefabSprite = new CanonPrefabSprite($bodyB)
        $disB.addToWorld();




    }
    

}