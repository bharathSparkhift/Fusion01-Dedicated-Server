using UnityEditor;
using UnityEngine;
using System.IO;

public class BuildScript
{
    [MenuItem("Build/Build APK")]
    public static void BuildAPK()
    {
        string buildPath = "BuildFiles/APK";
        string _apkName   = "LegacyLoot.apk";


        if (!Directory.Exists(buildPath))
        {
            Directory.CreateDirectory(buildPath);
        }

        string[] scenes = { "Assets/Fusion 01 Dedicated Server/DS Scenes/Server.unity", 
                            "Assets/Fusion 01 Dedicated Server/DS Scenes/Menu.unity",
                            "Assets/Fusion 01 Dedicated Server/DS Scenes/Game.unity",
        }; 

        BuildPipeline.BuildPlayer(scenes, buildPath + $"/{_apkName}", BuildTarget.Android, BuildOptions.None);

        Debug.Log("Build complete. APK is located at: " + buildPath + $"/{_apkName}");
    }
}
