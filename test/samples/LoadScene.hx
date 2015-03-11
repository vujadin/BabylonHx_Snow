package samples;

import com.babylonhx.cameras.FreeCamera;
import com.babylonhx.materials.StandardMaterial;
import com.babylonhx.materials.textures.CubeTexture;
import com.babylonhx.materials.textures.Texture;
import com.babylonhx.math.Color3;
import com.babylonhx.math.Vector3;
import com.babylonhx.mesh.Mesh;
import com.babylonhx.postprocess.BlackAndWhitePostProcess;
import com.babylonhx.Scene;
import com.babylonhx.loading.SceneLoader;
import com.babylonhx.loading.plugins.BabylonFileLoader;

#if !js
import haxe.Json;
import org.msgpack.Encoder;
import org.msgpack.MsgPack;
import sys.io.FileOutput;
import sys.io.FileOutput;
import sys.io.File;
#end

/**
 * ...
 * @author Krtolica Vujadin
 */
class LoadScene {

	public function new(scene:Scene) {
		#if !js
		//var level = Json.parse(Assets.getText("scenes/HillValley/HillValley.babylon"));
		//var f = MsgPack.encode(level);
		//var fout = File.write("scenes/HillValley/HillValley.bbin", true);
		//fout.writeBytes(f, 0, f.length - 1);
		//return;
		#end
		
		SceneLoader.RegisterPlugin(BabylonFileLoader.plugin);
		SceneLoader.Load("assets/scenes/Train/", "Train.babylon", scene.getEngine(), function(s:Scene) {
			scene = s;
			scene.collisionsEnabled = false;
			for (index in 0...scene.cameras.length) {
				scene.cameras[index].minZ = 10;
			}
			
			for (index in 0...scene.meshes.length) {
				var mesh = scene.meshes[index];
				
				mesh.isBlocker = mesh.checkCollisions;
			}
			
			scene.activeCamera = scene.cameras[6];
			scene.activeCamera.attachControl(this);
			//cast(scene.getMaterialByName("terrain_eau"), StandardMaterial).bumpTexture = null;
			
			// Postprocesses
			//var bwPostProcess = new BlackAndWhitePostProcess("Black and White", 1.0, scene.cameras[2]);
			//scene.cameras[2].name = "B&W";
				
			s.getEngine().runRenderLoop(function () {
				s.render();
			});
		});	
		/*SceneLoader.Load("assets/scenes/V8/", "v8.babylon", scene.getEngine(), function(s:Scene) {
			scene = s;			
			//s.executeWhenReady(function() {
				if (s.activeCamera != null) {
					s.activeCamera.attachControl(this);					
				} 
					
				s.getEngine().runRenderLoop(function () {
					s.render();
				});
			//});
		});*/	
		
	}
	
}
