var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Constraints_html = (function (_super) {
    __extends(Constraints_html, _super);
    function Constraints_html() {
        _super.call(this);
    }
    Constraints_html.prototype.initData = function () {
        this.linksScene();
        //this.lockScene();
        // this.clothOnSphere();
        //  this.spherePendulum();
        //  this.SphereChain();
        //this.ParticleCloth();
        // this.cloth3Dstructure()
    };
    Constraints_html.prototype.cloth3Dstructure = function () {
        var world = Physics.world;
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
                    var $disLock = new CanonPrefabSprite(body);
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
                    if (i < Nx - 1)
                        connect(i, j, k, i + 1, j, k, dist);
                    if (j < Ny - 1)
                        connect(i, j, k, i, j + 1, k, dist);
                    if (k < Nz - 1)
                        connect(i, j, k, i, j, k + 1, dist);
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
    };
    Constraints_html.prototype.ParticleCloth = function () {
        var world = Physics.world;
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
                var $disLock = new CanonPrefabSprite(body);
                $disLock.addToWorld();
            }
        }
        function connect(i1, j1, i2, j2) {
            world.addConstraint(new CANNON.DistanceConstraint(bodies[i1 + " " + j1], bodies[i2 + " " + j2], dist));
        }
        for (var i = 0; i < Ncols; i++) {
            for (var j = 0; j < Nrows; j++) {
                if (i < Ncols - 1)
                    connect(i, j, i + 1, j);
                if (j < Nrows - 1)
                    connect(i, j, i, j + 1);
            }
        }
    };
    Constraints_html.prototype.SphereChain = function () {
        var world = Physics.world;
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
            var $disLock = new CanonPrefabSprite(spherebody);
            $disLock.addToWorld();
            // Connect this body to the last one added
            var c;
            if (lastBody !== null) {
                world.addConstraint(c = new CANNON.DistanceConstraint(spherebody, lastBody, dist));
            }
            // Keep track of the lastly added body
            lastBody = spherebody;
        }
    };
    Constraints_html.prototype.spherePendulum = function () {
        var world = Physics.world;
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
        var $disLock = new CanonPrefabSprite(spherebody);
        $disLock.addToWorld();
        var spherebody2 = new CANNON.Body({ mass: 0 });
        spherebody2.addShape(sphereShape);
        spherebody2.position.set(0, 0, size * 7);
        var $disLock = new CanonPrefabSprite(spherebody2);
        $disLock.addToWorld();
        // Connect this body to the last one
        var c = new CANNON.PointToPointConstraint(spherebody, new CANNON.Vec3(0, 0, size * 2), spherebody2, new CANNON.Vec3(0, 0, -size * 2));
        world.addConstraint(c);
    };
    Constraints_html.prototype.clothOnSphere = function () {
        var world = Physics.world;
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
                var $disLock = new CanonPrefabSprite(body);
                $disLock.addToWorld();
            }
        }
        function connect(i1, j1, i2, j2) {
            world.addConstraint(new CANNON.DistanceConstraint(bodies[i1 + " " + j1], bodies[i2 + " " + j2], dist));
        }
        for (var i = 0; i < Ncols; i++) {
            for (var j = 0; j < Nrows; j++) {
                // Connect particle at position (i,j) to (i+1,j) and to (i,j+1).
                if (i < Ncols - 1)
                    connect(i, j, i + 1, j);
                if (j < Nrows - 1)
                    connect(i, j, i, j + 1);
            }
        }
        // Add the static sphere we throw the cloth on top of
        var sphere = new CANNON.Sphere(1.5);
        var body = new CANNON.Body({ mass: 0 });
        body.addShape(sphere);
        body.position.set(0, 0, 3.5);
        var $disLock = new CanonPrefabSprite(body);
        $disLock.addToWorld();
    };
    Constraints_html.prototype.linksScene = function () {
        var world = Physics.world;
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
            var $disLock = new CanonPrefabSprite(boxbody);
            $disLock.addToWorld();
            if (i != 0) {
                // Connect the current body to the last one
                // We connect two corner points to each other.
                var c1 = new CANNON.PointToPointConstraint(boxbody, new CANNON.Vec3(-size, 0, size + space), last, new CANNON.Vec3(-size, 0, -size - space));
                var c2 = new CANNON.PointToPointConstraint(boxbody, new CANNON.Vec3(size, 0, size + space), last, new CANNON.Vec3(size, 0, -size - space));
                world.addConstraint(c1);
                world.addConstraint(c2);
            }
            else {
                // First body is now static. The rest should be dynamic.
                mass = 0.3;
            }
            // To keep track of which body was added last
            last = boxbody;
        }
    };
    Constraints_html.prototype.lockScene = function () {
        Physics.world.gravity.set(0, 0, -10);
        var size = 0.5;
        var mass = 1;
        var space = 0.1 * size;
        var N = 10;
        var $box = new CANNON.Box(new CANNON.Vec3(size, size, size));
        var last;
        for (var i = 0; i < N; i++) {
            // Create a box
            var $bodyLock = new CANNON.Body({ mass: 1 });
            $bodyLock.addShape($box);
            $bodyLock.position = new CANNON.Vec3((N - i - N / 2) * (size * 2 + 2 * space), 0, size * 6 + space);
            var $disLock = new CanonPrefabSprite($bodyLock);
            $disLock.addToWorld();
            if (last) {
                // Connect the current body to the last one
                var c = new CANNON.LockConstraint($bodyLock, last);
                Physics.world.addConstraint(c);
            }
            // To keep track of which body was added last
            last = $bodyLock;
        }
        var $bodyA = new CANNON.Body({ mass: 0 });
        $bodyA.addShape($box);
        $bodyA.position = new CANNON.Vec3((-N / 2 + 1) * (size * 2 + 2 * space), 0, size * 3);
        var $disA = new CanonPrefabSprite($bodyA);
        $disA.addToWorld();
        var $bodyB = new CANNON.Body({ mass: 0 });
        $bodyB.addShape($box);
        $bodyB.position = new CANNON.Vec3((N / 2) * (size * 2 + 2 * space), 0, size * 3);
        var $disB = new CanonPrefabSprite($bodyB);
        $disB.addToWorld();
    };
    return Constraints_html;
})(DemoBase_html);
//# sourceMappingURL=Constraints_html.js.map