package;

import snow.Log.log;
import snow.types.Types;
import snow.utils.ByteArray;
#if cpp
import sys.io.File;
import sys.io.FileOutput;
#end

import com.babylonhx.Engine;
import com.babylonhx.Scene;


@:log_as('app')
class Main extends snow.App {
	
	var engine:Engine;
	var scene:Scene;
	
	// quick and dirty solution to handle mouse/keyboard 
	public static var mouseDown:Array<Dynamic> = [];
	public static var mouseUp:Array<Dynamic> = [];
	public static var mouseMove:Array<Dynamic> = [];
	public static var mouseWheel:Array<Dynamic> = [];
	public static var keyUp:Array<Dynamic> = [];
	public static var keyDown:Array<Dynamic> = [];
	
	override function config(config:AppConfig):AppConfig {
		#if js
		//app.assets.strict = false;
		#end
		config.window.title = 'BabylonHx_Snow samples';
		return config;
	}

	override function ready() {
		
		/*var img = app.assets.image("assets/img/ground/diffuse.png");
		trace(img.image.id);
		var nm = new NormalMap("smoothing", 0);
		var normalMap = nm.create(img.image);
		//var normalMap = com.babylonhxext.bumper.Filter.sobel(com.babylonhxext.bumper.Filter.grayscale(img.image), 2.5, 7, "sobel");
		var fo = File.write("assets/img/ground/normal.png");
		var jpgWriter = new format.jpg.Writer(fo);
		var bytes:ByteArray = new ByteArray();
		bytes.setLength(normalMap.data.length);
		for (i in 0...normalMap.data.length) {
			bytes.set(i, normalMap.data.getUInt8(i));
		}
		try {
			jpgWriter.write( { width: img.image.width, height: img.image.height, quality: 100, pixels: bytes } );
		} catch (err:Dynamic) {
			trace(err);
		}*/
		
		engine = new Engine(this);
		scene = new Scene(engine);
		
		//new samples.BasicScene(scene);
		//new samples.BasicElements(scene);
		//new samples.RotationAndScaling(scene);
		//new samples.Materials(scene);
		//new samples.Lights(scene);
		//new samples.Animations(scene);
		//new samples.Collisions(scene);
		//new samples.Intersections(scene);
		//new samples.EasingFunctions(scene);
		//new samples.ProceduralTextures(scene);
		//new samples.MeshImport(scene);
		//new samples.LoadScene(scene);
		//new samples.CSGDemo(scene);
		//new samples.Fog(scene);
		//new samples.DisplacementMap(scene);
		//new samples.Environment(scene);
		//new samples.LensFlares(scene);
		//new samples.Physics(scene);
		//new samples.PolygonMesh(scene);
		//new samples.CustomRenderTarget(scene);
		//new samples.Lines(scene);
		//new samples.Bones(scene);
		new samples.PostprocessRefraction(scene);
		//new samples.Shadows(scene);
		//new samples.HeightMap(scene);
		//new samples.LoadObjFile(scene);
		//new samples.LOD(scene);
		//new samples.Instances(scene);
		//new samples.Fresnel(scene);
		//new samples.PostprocessConvolution(scene);
		//new samples.VolumetricLights(scene);
		//new samples.CellShading(scene);
		//new samples.Particles(scene);
		//new samples.Particles2(scene);
		//new samples.Extrusion(scene);
		//new samples.Sprites(scene);
		//new samples.PostprocessBloom(scene);
		//new samples.Actions(scene);
		//new samples.Picking(scene);
						
		app.window.onrender = render;
	}
		
	override function onmousedown(x:Int, y:Int, button:Int, _, _) {
		for(f in mouseDown) {
			f(x, y);
		}
	}
	
	override function onmouseup(x:Int, y:Int, button:Int, _, _) {
		for(f in mouseUp) {
			f();
		}
	}
	
	override function onmousemove(x:Int, y:Int, _, _, _, _) {
		for(f in mouseMove) {
			f(x, y);
		}
	}
	
	override function onmousewheel(_, y:Int, _, _) {
		for (f in mouseWheel) {
			f(y);
		}
	}

	override function onkeyup(keycode:Int, scancode:Int, _, mod:ModState, _, _) {
		if (keycode == Key.escape) {
			app.shutdown();
		}
		
		for(f in keyUp) {
			f(keycode);
		}
	}
	
	override function onkeydown(keycode:Int, scancode:Int, _, _, _, _) {
		for(f in keyDown) {
			f(keycode);
		}
	}

	function render(window:snow.window.Window) {
		engine._renderLoop();
	}
}
