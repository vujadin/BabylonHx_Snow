package com.babylonhx.physics.plugins;

import oimohx.math.Mat33;
import oimohx.math.Quat;
import oimohx.math.Vec3;
import oimohx.physics.collision.shape.BoxShape;
import oimohx.physics.collision.shape.Shape;
import oimohx.physics.collision.shape.ShapeConfig;
import oimohx.physics.collision.shape.SphereShape;
import oimohx.physics.dynamics.RigidBody;
import oimohx.physics.dynamics.World;

/**
 * ...
 * @author Krtolica Vujadin
 */
class Body {
	
	public var body:RigidBody;
	public var parent:World;
	public var name:String;
	public var sleeping:Bool;

	public function new(Obj:Dynamic) {
		var obj:Dynamic = Obj != null ? Obj : {};
		
		if (obj.world == null) {
			return;
		}

		// the world where i am
		this.parent = obj.world;

		// Yep my name 
		this.name = obj.name != null ? obj.name : '';

		// I'm dynamique or not
		var move:Bool = obj.move != null ? cast obj.move : false;
		move = true;

		// I can sleep or not
		var noSleep:Bool = obj.noSleep != null ? cast obj.noSleep : false;
		
		// My start position
		var p:Array<Float> = obj.pos != null ? cast obj.pos : [0, 0, 0];
		p = p.map(function(x:Float) { return x * OimoPlugin.INV_SCALE; });

		// My size 
		var s:Array<Float> = obj.size != null ? cast obj.size : [1, 1, 1];
		s = s.map(function(x:Float) { return x * OimoPlugin.INV_SCALE; });

		// My rotation in degre
		var rot:Array<Float> = obj.rot != null ? cast obj.rot : [0, 0, 0];
		rot = rot.map(function(x) { return x * OimoPlugin.TO_RAD; });
		var r:Array<Float> = [];
		for (i in 0...Std.int(rot.length / 3)) {
			var tmp = EulerToAxis(rot[i+0], rot[i+1], rot[i+2]);
			r.push(tmp[0]);  
			r.push(tmp[1]); 
			r.push(tmp[2]); 
			r.push(tmp[3]);
		}

		// My physics setting
		var sc:ShapeConfig = obj.sc != null ? cast obj.sc : new ShapeConfig();
		
		if(obj.config != null){
			// The density of the shape.
			sc.density = obj.config[0] != null ? obj.config[0] : 1;
			// The coefficient of friction of the shape.
			sc.friction = obj.config[1] != null ? obj.config[1] : 0.4;
			// The coefficient of restitution of the shape.
			sc.restitution = obj.config[2] != null ? obj.config[2] : 0.2;
			// The bits of the collision groups to which the shape belongs.
			sc.belongsTo = obj.config[3] != null ? obj.config[3] : 1;
			// The bits of the collision groups with which the shape collides.
			sc.collidesWith = obj.config[4] != null ? obj.config[4] : 0xffffffff;
		}

		if(obj.massPos != null){
			obj.massPos = obj.massPos.map(function(x) { return x * OimoPlugin.INV_SCALE; });
			sc.relativePosition.init(obj.massPos[0], obj.massPos[1], obj.massPos[2]);
		}
		
		if(obj.massRot != null){
			obj.massRot = obj.massRot.map(function(x) { return x * OimoPlugin.TO_RAD; });
			sc.relativeRotation = EulerToMatrix(obj.massRot[0], obj.massRot[1], obj.massRot[2]);
		}
		
		// My rigidbody
		this.body = new RigidBody(p[0], p[1], p[2], r[0], r[1], r[2], r[3]);

		// My shapes
		var shapes:Array<Shape> = [];
		var _type = obj.type != null ? obj.type : "box";
		var type:Dynamic = null;
		if (Std.is(_type, String)) {
			type = [_type];	// single shape
		} else { 
			type = _type;
		}

		var n:Int = 0;
		var n2:Int = 0;
		for(i in 0...type.length){
			n = i * 3;
			n2 = i * 4;
			switch(type[i]){
				case "sphere": 
					shapes[i] = new SphereShape(sc, s[n + 0]); 
					
				case "cylinder": 
					shapes[i] = new BoxShape(sc, s[n + 0], s[n + 1], s[n + 2]); // fake cylinder
					
				case "box": 
					shapes[i] = new BoxShape(sc, s[n + 0], s[n + 1], s[n + 2]); 
					
			}
			this.body.addShape(shapes[i]);
			if(i > 0){
				shapes[i].relativePosition = new Vec3( p[n + 0], p[n + 1], p[n + 2] );
				/*if (r[n2 + 0] != null) {
					shapes[i].relativeRotation = [ r[n2 + 0], r[n2 + 1], r[n2 + 2], r[n2 + 3] ];
				}*/
			}
		} 
		
		// I'm static or i move
		if(move){
			if (obj.massPos != null || obj.massRot != null) {
				this.body.setupMass(0x1, false);
			}
			else {
				this.body.setupMass(0x1, true);
			}
			if (noSleep) {
				this.body.allowSleep = false;
			}
			else {
				this.body.allowSleep = true;
			}
		} else {
			this.body.setupMass(0x2);
		}
		
		this.body.name = this.name;
		this.sleeping = this.body.sleeping;

		// finaly add to physics world
		this.parent.addRigidBody(this.body);
	}
	
	/*public function setPosition(pos:Vec3) {
        this.body.setPosition(pos);
    }*/
	
    /*public function setQuaternion(q:Quat){
        this.body.setQuaternion(q);
    }*/
	
    /*public function setRotation(rot:Vec3) {
        this.body.setRotation(rot);
    }*/
	
    // GET
    /*public function getPosition():Vec3 {
        return this.body.getPosition();
    }*/
	
    /*public function getRotation():Vec3 {
        return this.body.getRotation();
    }*/
	
    /*public function getQuaternion():Quat {
        return this.body.getQuaternion();
    }*/
	
    /*public function getMatrix():Array<Float> {
        return this.body.getMatrix();
    }*/
	
    public function getSleep():Bool {
        return this.body.sleeping;
    }
	
    // RESET
    /*public function resetPosition(x:Float, y:Float, z:Float) {
        this.body.resetPosition(x, y, z);
    }
	
    public function resetRotation(x:Float, y:Float, z:Float) {
        this.body.resetRotation(x, y, z);
    }*/
	
    // force wakeup
    public function awake() {
        this.body.awake();
    }
	
    // remove rigidbody
    public function remove() {
        this.parent.removeRigidBody(this.body);
    }
	
    // test if this object hit another
    public function checkContact(name:String){
        this.parent.checkContact(this.name, name);
    }
	
	public static function EulerToAxis(ox:Float, oy:Float, oz:Float):Array<Float> {	// angles in radians
		var c1 = Math.cos(oy * 0.5);	//heading
		var s1 = Math.sin(oy * 0.5);
		var c2 = Math.cos(oz * 0.5);	//altitude
		var s2 = Math.sin(oz * 0.5);
		var c3 = Math.cos(ox * 0.5);	//bank
		var s3 = Math.sin(ox * 0.5);
		var c1c2 = c1 * c2;
		var s1s2 = s1 * s2;
		var w = c1c2 * c3 - s1s2 * s3;
		var x = c1c2 * s3 + s1s2 * c3;
		var y = s1 * c2 * c3 + c1 * s2 * s3;
		var z = c1 * s2 * c3 - s1 * c2 * s3;
		var angle = 2 * Math.acos(w);
		var norm = x * x + y * y + z * z;
		if (norm < 0.001) {
			x = 1;
			y = z = 0;
		} 
		else {
			norm = Math.sqrt(norm);
			x /= norm;
			y /= norm;
			z /= norm;
		}
		return [angle, x, y, z];
	}
	
	public static function EulerToMatrix(ox:Float, oy:Float, oz:Float):Mat33 {// angles in radians
		var ch = Math.cos(oy);	//heading
		var sh = Math.sin(oy);
		var ca = Math.cos(oz);	//altitude
		var sa = Math.sin(oz);
		var cb = Math.cos(ox);	//bank
		var sb = Math.sin(ox);
		var mtx = new Mat33();
		
		mtx.e00 = ch * ca;
		mtx.e01 = sh * sb - ch * sa * cb;
		mtx.e02 = ch * sa * sb + sh * cb;
		mtx.e10 = sa;
		mtx.e11 = ca * cb;
		mtx.e12 = -ca * sb;
		mtx.e20 = -sh * ca;
		mtx.e21 = sh * sa * cb + ch * sb;
		mtx.e22 = -sh * sa * sb + ch * cb;
		return mtx;
	}
	
}
